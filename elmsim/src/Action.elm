module Action exposing (Msg(..))

import Chat.Model exposing (BotChatItem, MultiChoiceAction)
import Material
import Simulation.Model exposing (GeneratorType, Peer, SimGenerator, TransmissionLine, Weather)


type Msg
    = Input String
    | SendUserChatMsg
    | SendBotChatItem BotChatItem
    | NoOp
    | CheckWeather
    | DescribeNode Int
    | AddGenerator SimGenerator
    | AddPeer Peer
    | AddEdge TransmissionLine
    | RenderPhiNetwork
    | UpdateWeather Weather
    | CallTurn
    | DaySummary
    | MultiChoiceMsg MultiChoiceAction
    | ToggleInputType
    | Mdl (Material.Msg Msg)
