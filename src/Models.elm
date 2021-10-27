module Models exposing (..)

import Browser
import Browser.Navigation as Nav
import Http
import Routes exposing (..)
import Url


type alias Categories =
    List String


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
