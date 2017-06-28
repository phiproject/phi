port module Simulation.BuildingMode exposing (..)

import Action exposing (Msg(..))
import Graph exposing (Edge, Node, NodeContext, NodeId)
import Json.Decode as Decode
import Json.Encode exposing (Value)
import ListHelpers exposing (addToFirstElement, takeFirstElementWithDefault0)
import Model exposing (Model)
import Simulation.GraphUpdates exposing (addEdge, createEdge)
import Simulation.Helpers exposing (getCoords)
import Simulation.Init.Generators as Generators
import Simulation.Model exposing (..)


-- PORTS


port changeBuildMode : String -> Cmd msg


port requestConvertNode : (Value -> msg) -> Sub msg


port requestNewLine : (Value -> msg) -> Sub msg


parseConvertNodeRequest : Value -> Msg
parseConvertNodeRequest x =
    let
        result =
            Decode.decodeValue Decode.int x
    in
    case result of
        Ok nodeId ->
            RequestConvertNode nodeId

        Err _ ->
            NoOp


parseConvertNewLine : Value -> Msg
parseConvertNewLine x =
    let
        result =
            Decode.decodeValue (Decode.list Decode.int) x
    in
    case result of
        Ok list ->
            case list of
                head :: tail ->
                    let
                        first =
                            Debug.log "first" head

                        second =
                            Debug.log "second" (takeFirstElementWithDefault0 tail)
                    in
                    RequestNewLine first second

                _ ->
                    NoOp

        Err _ ->
            NoOp



--handleConvertNodeRequest : NodeId -> PhiNetwork -> PhiNetwork
--handleConvertNodeRequest nodeId phiNetwork =
--    let
--        convertNode node =
--            { node | label = convertNodeLabel node.label }
--
--        convertNodeLabel label =
--            case label of
--                PotentialNode { nodeType, pos } ->
--                    case nodeType of
--                        PotentialGenerator ->
--                            GeneratorNode { defaultGenerator | pos = pos }
--
--                        PotentialPeer ->
--                            PeerNode { defaultPeer | pos = pos }
--
--                _ ->
--                    label
--
--        convertNodeContext nodeContext =
--            { nodeContext | node = convertNode nodeContext.node }
--    in
--    Graph.get nodeId phiNetwork
--        |> Maybe.map ((\nc -> Graph.insert nc phiNetwork) << convertNodeContext)
--        |> Maybe.withDefault phiNetwork


handleConvertNode : NodeId -> Model -> ( Model, Cmd Msg )
handleConvertNode nodeId model =
    let
        networkWithoutOldNode =
            Graph.remove nodeId model.network

        maybeNodeLabel =
            Graph.get nodeId model.network
                |> Maybe.map (.node >> .label)

        nodeGenerator : NodeLabel -> Maybe (Cmd Msg)
        nodeGenerator nodeLabel =
            let
                coords =
                    getCoords nodeLabel
            in
            case nodeLabel of
                PotentialNode potential ->
                    case potential.nodeType of
                        PotentialWindTurbine ->
                            Just <| Generators.generateWindTurbine AddGenerator coords

                        PotentialSolarPanel ->
                            Just <| Generators.generatePVPanel AddGenerator coords

                        PotentialPeer ->
                            Just <| Generators.generatePeer AddPeer coords

                _ ->
                    Nothing

        cmd =
            maybeNodeLabel
                |> Maybe.andThen nodeGenerator
                |> Maybe.withDefault Cmd.none
    in
    { model | network = networkWithoutOldNode } ! [ cmd ]

conversionBudgetUpdate : NodeId -> Model -> ( Model, Cmd Msg )
conversionBudgetUpdate nodeId model =
    let
        maybeNodeLabel =
            Graph.get nodeId model.network
                |> Maybe.map (.node >> .label)

        getCost maybeLabel =
            case maybeLabel of
                Just nodeLabel ->
                    case nodeLabel of
                        GeneratorNode gen ->
                            case gen.generatorType of
                                WindTurbine ->
                                    200

                                SolarPanel ->
                                    150

                        PeerNode peer ->
                                50
                        _ ->
                           0
                Nothing ->
                    0

        cost = maybeNodeLabel
                |> getCost

    in
    { model | budget = addToFirstElement model.budget -cost} ! [ Cmd.none ]

handleNewLineRequest : NodeId -> NodeId -> PhiNetwork -> PhiNetwork
handleNewLineRequest a b phiNetwork =
    phiNetwork
        |> addEdge (createEdge a b)
