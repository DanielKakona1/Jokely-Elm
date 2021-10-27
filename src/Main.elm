module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, br, button, div, h1, h4, hr, img, input, li, nav, span, text)
import Html.Attributes exposing (href, placeholder, src, style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type Route
    = Index
    | Jokes String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Index top
        , map Jokes (s "jokes" </> Url.Parser.string)
        ]


type DModel
    = Failure -- ??? why did it fail
    | Loading
    | Success Categories
    | FectchJokes String


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Route
    , dModel : DModel
    }


type alias Categories =
    List String


getCategories : Cmd Msg
getCategories =
    Http.get
        { url = "https://api.chucknorris.io/jokes/categories"
        , expect = Http.expectJson GotCategories (Json.Decode.list Json.Decode.string)
        }


getJokes : String -> Cmd Msg
getJokes cat =
    Http.get
        { url = "https://api.chucknorris.io/jokes/random?category=" ++ cat
        , expect = Http.expectJson GotJokes gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "value" Json.Decode.string


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url Index Loading, getCategories )


type alias CatetoriesResult =
    Result Http.Error Categories


type Msg
    = GotCategories CatetoriesResult
    | GotJokes (Result Http.Error String)
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | MorePlease String
    | GoBackPlease


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCategories result ->
            case result of
                Ok categories ->
                    ( { model | dModel = Success categories }, Cmd.none )

                Err _ ->
                    ( { model | dModel = Failure }, Cmd.none )

        GoBackPlease ->
            ( { model | dModel = Loading }, getCategories )

        GotJokes result ->
            case result of
                Ok joke ->
                    ( { model | dModel = FectchJokes joke }, Cmd.none )

                Err _ ->
                    ( { model | dModel = Failure }, Cmd.none )

        MorePlease cat ->
            ( { model | dModel = Loading }, getJokes cat )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            case parse routeParser url of
                Nothing ->
                    ( { model | route = NotFound }
                    , Cmd.none
                    )

                Just urlr ->
                    let
                        newRoute =
                            urlr
                    in
                    case newRoute of
                        Index ->
                            ( { model | route = Index }
                            , Cmd.none
                            )

                        Jokes cat ->
                            ( { model | route = newRoute }
                            , getJokes cat
                            )

                        NotFound ->
                            ( { model | route = NotFound }
                            , Cmd.none
                            )


view : Model -> Browser.Document Msg
view model =
    let
        body =
            case model.route of
                Index ->
                    viewIndex model

                Jokes cat ->
                    viewJokes cat model

                NotFound ->
                    viewIndex model
    in
    { title = "URL Interceptor"
    , body = [ body ]
    }



-- INDEX PAGE VIEW


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



-- JOKES PAGE VIEW


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


viewGoBack : String -> Html msg
viewGoBack path =
    a
        [ href "/"
        , style "color" "#ffff"
        , style "cursor" "pointer"
        , style "text-decoration" "none"
        ]
        [ text path ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
