module JokesP exposing (..)

import DataModel exposing (..)
import Html exposing (Html, a, br, button, div, h1, h4, hr, img, input, li, nav, span, text)
import Html.Attributes exposing (href, placeholder, src, style)
import Html.Events exposing (onClick)


viewJokes : String -> Model -> Html Msg
viewJokes cat model =
    div
        [ style "max-width" "600px"
        , style "height" "100vh"
        , style "margin" "0 auto"
        , style "display" "flex"
        , style "flex" "1"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "align-items" "center"
        , style "padding" "20px 30px"
        ]
        [ div []
            [ h1
                [ style "font-family" "Reggae One"
                , style "text-align" "center"
                , style "text-transform" "capitalize"
                ]
                [ text cat
                ]
            , h4
                [ style "font-family" "Truculenta, sans-serif"
                , style "text-align" "center"
                , style "font-size" "14px"
                ]
                [ case model.dModel of
                    Failure ->
                        text "I wasn't unable to load your joke."

                    Loading ->
                        text "Looking for something funny 👻..."

                    FectchJokes data ->
                        div
                            [ style "display" "flex"
                            , style "flex-wrap" "wrap"
                            , style "margin-top" "10px"
                            , style "align-items" "center"
                            , style "justify-content" "center"
                            ]
                            [ text data ]

                    Success _ ->
                        text "Looking for something funny 👻..."
                ]
            ]
        , div
            [ style "display" "flex"
            , style "margin-top" "30px"
            , style "justify-content" "space-evenly"
            , style "width" "100%"
            ]
            [ button
                [ onClick GoBackPlease
                , style "cursor" "pointer"
                , style "border" "0"
                , style "text-align" "center"
                , style "padding" "10px"
                , style "border-radius" "4px"
                , style "background-color" "#16a085"
                ]
                [ viewGoBack "go back 🔙" ]
            , div []
                [ button
                    [ onClick (MorePlease cat)
                    , style "cursor" "pointer"
                    , style "border" "0"
                    , style "text-align" "center"
                    , style "padding" "10px"
                    , style "border-radius" "4px"
                    , style "background-color" "#16a085"
                    , style "color" "#ffff"
                    ]
                    [ text "other joke 🤣" ]
                ]
            ]
        ]


viewGoBack : String -> Html msg
viewGoBack path =
    a
        [ href "/"
        , style "color" "#ffff"
        , style "cursor" "pointer"
        , style "text-decoration" "none"
        ]
        [ text path ]
