module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (attribute)
import List exposing (head)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


sandboxAttributeValues =
    [ "allow-scripts"
    , "allow-forms"
    , "allow-same-origin"
    ]


type alias Plugin =
    { name : String, src : String }


type alias Model =
    { plugins : List Plugin, current : Maybe Plugin }


pluginsConfig =
    [ { name = "Counter Demo", src = "http://localhost:8000/counter-demo.html" }
    , { name = "Http Request Demo", src = "http://localhost:8000/http-demo.html" }
    ]


init : () -> ( Model, Cmd msg )
init _ =
    ( { plugins = pluginsConfig
      , current = head pluginsConfig
      }
    , Cmd.none
    )


type Msg
    = ShowPlugin Plugin


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ShowPlugin plugin ->
            ( { model | current = Just plugin }, Cmd.none )


pluginView : Plugin -> Element msg
pluginView plgin =
    Element.el [ width fill, height fill ]
        (Element.html <|
            Html.node "iframe"
                [ attribute "src" plgin.src
                , attribute "sandbox" <| String.join " " sandboxAttributeValues
                ]
                []
        )


pluginMenuItem plugin =
    Input.button [] { onPress = Just (ShowPlugin plugin), label = text plugin.name }


leftMenuPanel plugins =
    column
        [ height fill
        , width <| fillPortion 1
        , Background.color <| rgb255 92 99 118
        , Font.color <| rgb255 255 255 255
        ]
        (List.map
            pluginMenuItem
            plugins
        )


bodyPanel : Maybe Plugin -> Element msg
bodyPanel maybePlugin =
    let
        content =
            case maybePlugin of
                Just plgin ->
                    [ pluginView plgin ]

                Nothing ->
                    []
    in
    column [ height fill, width <| fillPortion 3 ] content



-- view : Model -> Html msg


view model =
    layout [] <|
        column [ height fill, width fill ]
            [ row [ height <| fillPortion 1, width fill ]
                [ text "header row" ]
            , row [ height <| fillPortion 9, width fill ]
                [ leftMenuPanel model.plugins
                , bodyPanel model.current
                ]
            ]
