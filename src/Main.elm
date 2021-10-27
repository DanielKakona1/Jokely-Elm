module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Home exposing (..)
import Html exposing (Html, a, br, button, div, h1, h4, hr, img, input, li, nav, span, text)
import Html.Attributes exposing (href, placeholder, src, style)
import Html.Events exposing (onClick)
import Http
import Jokes exposing (..)
import Json.Decode exposing (Decoder, field, string)
import Messages exposing (..)
import Models exposing (..)
import Routes exposing (..)
import Services exposing (..)
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


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url Index Loading, getCategories )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCategories result ->
            case result of
                Ok categories ->
                    ( { model | dModel = Success categories }, Cmd.none )

                Err _ ->
                    ( { model | dModel = Failure }, Cmd.none )

        GoBackButtonClicked ->
            ( { model | dModel = Loading }, getCategories )

        GotJokes result ->
            case result of
                Ok joke ->
                    ( { model | dModel = FectchJokes joke }, Cmd.none )

                Err _ ->
                    ( { model | dModel = Failure }, Cmd.none )

        OtherJokeButtonClicked cat ->
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

                        Joke cat ->
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

                Joke cat ->
                    viewJokes cat model

                NotFound ->
                    viewIndex model
    in
    { title = "URL Interceptor"
    , body = [ body ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
