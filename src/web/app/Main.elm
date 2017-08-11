module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation exposing (Location)
import UrlParser


type Page
    = Welcome
    | SignIn
    | LoggedIn


type alias User =
    { firstName : String
    , lastName : String
    }


type alias Name a =
    { a
        | firstName : String
        , lastName : String
    }


type alias Model =
    { page : Page
    , firstName : String
    , lastName : String
    , user : Maybe User
    }


type Msg
    = SetPage Location
    | SetFirstName String
    | SetLastName String
    | Continue


emptyHtml : Html Msg
emptyHtml =
    text ""


main : Program Never Model Msg
main =
    Navigation.program
        SetPage
        { init = init
        , update = update
        , view = view
        , subscriptions = subscription
        }


init : Location -> ( Model, Cmd Msg )
init location =
    Model (pageFromLocation location) "" "" Nothing
        ! []


pageFromLocation : Location -> Page
pageFromLocation location =
    case UrlParser.parseHash route location of
        Just page ->
            page

        Nothing ->
            Welcome


route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Welcome UrlParser.top
        , UrlParser.map SignIn (UrlParser.s "sign-in")
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPage location ->
            { model | page = (pageFromLocation location) } ! []

        SetFirstName firstName ->
            { model | firstName = firstName } ! []

        SetLastName lastName ->
            { model | lastName = lastName } ! []

        Continue ->
            { model
                | user = Just (User model.firstName model.lastName)
                , page = LoggedIn
            }
                ! []


view : Model -> Html Msg
view model =
    viewPage model model.page


viewPage : Model -> Page -> Html Msg
viewPage model page =
    case page of
        Welcome ->
            viewWelcomePage

        SignIn ->
            viewSignInPage model

        LoggedIn ->
            case model.user of
                Just user ->
                    viewLoggedInPage user

                Nothing ->
                    viewSignInPage model


viewWelcomePage : Html Msg
viewWelcomePage =
    div [ class "hero is-dark is-fullheight" ]
        [ div [ class "hero-body" ]
            [ div [ class "container has-text-centered" ]
                [ h1 [ class "title is-1" ] [ text "Yo Duck." ]
                , h2 [ class "subtitle is-4" ] [ text "Quack quack!" ]
                , a [ href "#sign-in", class "button is-info" ] [ text "Get quackin'" ]
                ]
            ]
        ]


viewSignInPage : Name a -> Html Msg
viewSignInPage { firstName, lastName } =
    div [ class "hero is-info is-fullheight" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h3 [ class "title is-2 has-text-centered" ] [ text "Let's quack to it." ]
                , div [ class "card max-640" ]
                    [ div [ class "card-content is-clearfix" ]
                        [ viewFieldWithLabel firstName SetFirstName "First Name"
                        , viewFieldWithLabel lastName SetLastName "Last Name"
                        , viewContinueButton firstName lastName
                        ]
                    ]
                ]
            ]
        ]


viewLoggedInPage : User -> Html Msg
viewLoggedInPage user =
    div [ class "hero is-success is-fullheight" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title is-1 has-text-centered" ]
                    [ text ("Hey, " ++ user.firstName ++ ".")
                    ]
                ]
            ]
        ]


viewFieldWithLabel : String -> (String -> Msg) -> String -> Html Msg
viewFieldWithLabel model msg label =
    viewField model msg label Nothing Nothing


viewField : String -> (String -> Msg) -> String -> Maybe String -> Maybe String -> Html Msg
viewField model msg label_ placeholder_ helpText =
    div [ class "field" ]
        [ label [ class "label is-medium" ] [ text label_ ]
        , div [ class "control" ]
            [ input
                [ class "input is-medium"
                , type_ "text"
                , placeholder (Maybe.withDefault "" placeholder_)
                , onInput msg
                , value model
                ]
                []
            ]
        , (case helpText of
            Just helpText ->
                p [ class "help" ] [ text helpText ]

            Nothing ->
                emptyHtml
          )
        ]


viewContinueButton : String -> String -> Html Msg
viewContinueButton firstName lastName =
    button
        ([ class "button is-success is-medium is-pulled-right"
         , onClick Continue
         ]
            ++ (if (String.length firstName) == 0 then
                    [ attribute "disabled" "" ]
                else
                    []
               )
        )
        [ text ("Continue as " ++ firstName ++ " " ++ lastName) ]


subscription : Model -> Sub Msg
subscription model =
    Sub.none
