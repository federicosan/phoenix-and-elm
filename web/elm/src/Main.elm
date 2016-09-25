module Main exposing (..)

import Navigation
import View exposing (view)
import Model exposing (..)
import Contact.Model
import Update exposing (..)
import Types exposing (Msg(..))
import Routing exposing (Route)
import Routing exposing (..)
import Subscriptions exposing (..)
import Contacts.Update exposing (fetchContacts)
import Contact.Update exposing (fetchContact)


init : Result String Route -> ( Model, Cmd Msg )
init result =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        urlUpdate result (initialModel currentRoute)


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        case currentRoute of
            ContactsRoute ->
                ( { model
                    | route = currentRoute
                    , contact = Contact.Model.initialModel
                  }
                , Cmd.map ContactsMsg (fetchContacts model.contacts.search model.contacts.page_number)
                )

            ContactRoute id ->
                ( { model | route = currentRoute }
                , Cmd.map ContactMsg (fetchContact id)
                )

            _ ->
                ( { model | route = currentRoute }
                , Cmd.none
                )


main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
