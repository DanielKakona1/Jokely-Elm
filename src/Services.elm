module Services exposing (..)

import Http
import Json.Decode exposing (Decoder, field, string)
import Messages exposing (..)
import Models exposing (..)
import Routes exposing (..)


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
        , expect = Http.expectJson GotJokes jokesDecoder
        }


jokesDecoder : Decoder String
jokesDecoder =
    field "value" Json.Decode.string
