module DataModel exposing (..)

import Browser
import Browser.Navigation as Nav
import Http
import Url


type Route
    = Index
    | Jokes String
    | NotFound


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


type alias CatetoriesResult =
    Result Http.Error Categories


type Msg
    = GotCategories CatetoriesResult
    | GotJokes (Result Http.Error String)
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | MorePlease String
    | GoBackPlease
