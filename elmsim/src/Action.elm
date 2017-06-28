module Action exposing (Msg(..), NarrativeElement)

import Chat.Model exposing (BotChatItem, MultiChoiceAction, UserChatMessage)
import Material
import Simulation.Model exposing (GeneratorType, Peer, SearchRadius, SimGenerator, TransmissionLine, Weather)
import Simulation.SimulationInterop exposing (AnimationPhase)


type alias NarrativeElement =
    { timeDelaySec : Float
    , updateMsgs : List Msg
    }


type Msg
    = Input String
    | SendUserChatMsg
    | ProcessNarrative (List NarrativeElement)
    | SendBotChatItem BotChatItem
    | ToggleInputAvailable Bool
    | NoOp
    | CheckWeather
    | CheckBudget
    | DescribeNode Int
    | RequestConvertNode Int
    | RequestNewLine Int Int
    | AddGenerator SimGenerator
    | AddPeer Peer
    | AddGeneratorWithEdges SearchRadius SimGenerator
    | AddPeerWithEdges SearchRadius Peer
    | AddEdge TransmissionLine
    | RenderPhiNetwork
    | AnimateGeneration
    | AnimatePeerConsumption
    | AnimateTrade
    | AnimationFinished AnimationPhase
    | ChangeBuildMode String
    | UpdateWeather Weather
    | CallTurn
    | DaySummary
    | MultiChoiceMsg MultiChoiceAction
    | Mdl (Material.Msg Msg)
    | SendToEliza UserChatMessage
