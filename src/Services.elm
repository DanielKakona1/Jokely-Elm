module Services exposing (..)

import DataModel exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Index top
        , map Jokes (s "jokes" </> Url.Parser.string)
        ]


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
