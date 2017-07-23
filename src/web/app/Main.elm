module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    Maybe Bool


type Msg
    = NoOp


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


model : Model
model =
    Nothing


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    div [ class "hero is-dark is-fullheight" ]
        [ div [ class "hero-body" ]
            [ div [ class "container has-text-centered" ]
                [ h1 [ class "title is-1" ] [ text "Yo duck." ]
                , h2 [ class "subtitle is-3" ] [ text "Quack quack!" ]
                ]
            ]
        ]
