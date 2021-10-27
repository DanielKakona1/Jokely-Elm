module Messages exposing (..)

import Browser
import Http
import Models exposing (..)
import Url


type alias Categories =
    List String


type alias CatetoriesResult =
    Result Http.Error Categories


type Msg
    = GotCategories CatetoriesResult
    | GotJokes (Result Http.Error String)
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | OtherJokeButtonClicked String
    | GoBackButtonClicked
