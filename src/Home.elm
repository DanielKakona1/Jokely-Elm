module Home exposing (..)

import DataModel exposing (..)
import Html exposing (Html, a, br, button, div, h1, h4, hr, img, input, li, nav, span, text)
import Html.Attributes exposing (href, placeholder, src, style)
import Html.Events exposing (onClick)


viewIndex : Model -> Html msg
viewIndex model =
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
                [ style "font-family" "Reggae One, cursive"
                , style "text-align" "center"
                ]
                [ text "Welcome to Jokely"
                , span [] [ text "🤪" ]
                ]
            , h4
                [ style "font-family" "Truculenta, sans-serif"
                , style "text-align" "center"
                , style "font-size" "14px"
                ]
                [ text "A simple smile. That's the start of opening your heart and being compassionate to others."
                , br [] []
                , br [] []
                , text "Select Category and we will tell you a joke:"
                ]
            ]
        , div
            [ style "width" "100%"
            , style "margin-top" " 20px"
            , style "margin-bottom" " 20px"
            , style "background" " #fff"
            ]
            [ div
                []
                [ case model.dModel of
                    Failure ->
                        text "I wasn't unable to load your categories."

                    Loading ->
                        text "Loading..."

                    Success data ->
                        div
                            [ style "display" "flex"
                            , style "flex-wrap" "wrap"
                            , style "margin-top" "10px"
                            , style "align-items" "center"
                            , style "justify-content" "center"
                            ]
                            (List.map displayCategories data)

                    FectchJokes _ ->
                        text "Loading...111"
                ]
            ]
        ]


displayCategories : String -> Html msg
displayCategories cat =
    div
        [ style "margin" "5px"
        ]
        [ button
            [ style "cursor" "pointer"
            , style "border" "0"
            , style "text-align" "center"
            , style "padding" "10px"
            , style "border-radius" "4px"
            , style "background-color" "#16a085"
            ]
            [ viewLink cat ]
        ]


viewLink : String -> Html msg
viewLink path =
    a
        [ href ("jokes/" ++ path)
        , style "color" "#ffff"
        , style "cursor" "pointer"
        , style "text-decoration" "none"
        ]
        [ text path ]
