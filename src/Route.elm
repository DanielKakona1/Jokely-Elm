module Main exposing (Route(..), fromUrl, parseUrl, parser)


type Route
    = Error404
    | Home
    | About


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Home top
        , map About (s "about")
        ]


parseUrl : Url -> Route
parseUrl url =
    case fromUrl url of
        Just route ->
            route

        Nothing ->
            Error404


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> parse parser
