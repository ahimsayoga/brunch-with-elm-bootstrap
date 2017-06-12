module Routes exposing (Sitemap(..), parsePath, navigateTo, toString)

import Navigation exposing (Location)
import Route exposing (..)


type Sitemap
    = HomeR
    | AboutR
    | AboutEnR
    | ScheduleR
    | InstructorsR
    | ContactR
    | NotFoundR


homeR : Route Sitemap
homeR =
    HomeR := static ""


scheduleR : Route Sitemap
scheduleR =
    ScheduleR := static "schedule"


aboutR : Route Sitemap
aboutR =
    AboutR := static "about"


aboutEnR : Route Sitemap
aboutEnR =
    AboutEnR := static "en" </> static "about"


instructorsR : Route Sitemap
instructorsR =
    InstructorsR := static "instructors"


contactR : Route Sitemap
contactR =
    ContactR := static "contact"


sitemap : Router Sitemap
sitemap =
    router [ homeR, aboutR, aboutEnR, scheduleR, instructorsR, contactR ]


match : String -> Sitemap
match =
    Route.match sitemap
        >> Maybe.withDefault NotFoundR


toString : Sitemap -> String
toString r =
    case r of
        HomeR ->
            reverse homeR []

        AboutR ->
            reverse aboutR []

        AboutEnR ->
            reverse aboutEnR []

        ScheduleR ->
            reverse scheduleR []

        InstructorsR ->
            reverse instructorsR []

        ContactR ->
            reverse contactR []

        NotFoundR ->
            Debug.crash "cannot render NotFound"


parsePath : Location -> Sitemap
parsePath =
    .pathname >> match


navigateTo : Sitemap -> Cmd msg
navigateTo =
    toString >> Navigation.newUrl
