module Charts exposing (donutChart, donutWithPct)

import FormatNumber
import Html exposing (Html, div, span, text)
import Svg exposing (circle, svg)
import Svg.Attributes exposing (..)


donutChart : Int -> Int -> Float -> Html msg
donutChart size thickness percent =
    let
        viewbox =
            viewBox <| "0 0 " ++ toString size ++ " " ++ toString size

        center =
            toString <| toFloat size / 2.0

        radius =
            toFloat (size - thickness - 1) / 2.0

        radiusStr =
            toString radius

        circumference =
            2 * Basics.pi * radius
    in
    svg [ width (toString size), height (toString size), viewbox, class "donut" ]
        [ circle [ class "donut-hole", cx center, cy center, r radiusStr, opacity "0" ] []
        , circle
            [ class "donut-ring"
            , cx center
            , cy center
            , r radiusStr
            , fill "transparent"
            , stroke "#FFFFFF"
            , strokeWidth <| toString thickness
            ]
            []
        , circle
            [ class "donut-segment"
            , cx center
            , cy center
            , r radiusStr
            , fill "transparent"
            , strokeWidth <| toString thickness
            , strokeDasharray <| toString (percent * circumference) ++ " " ++ toString ((1 - percent) * circumference)
            , strokeDashoffset <| toString (circumference / 4)
            ]
            []
        ]


percentFormat : Float -> String
percentFormat percent =
    case percent of
        0 ->
            ""

        _ ->
            (100 * percent)
                |> FormatNumber.format
                    { decimals = 0
                    , thousandSeparator = ","
                    , decimalSeparator = "."
                    }
                |> (\x -> x ++ "%")


donutWithPct : Int -> Int -> Float -> Html msg
donutWithPct size thickness percent =
    div
        [ class "donut_chart"
        , width <| toString size
        , height <| toString size
        ]
        [ donutChart size thickness percent
        , span [] [ text <| percentFormat percent ]
        ]
