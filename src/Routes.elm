module Routes exposing (..)

import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)


type Route
    = Index
    | Joke String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Index top
        , map Joke (s "jokes" </> Url.Parser.string)
        ]
