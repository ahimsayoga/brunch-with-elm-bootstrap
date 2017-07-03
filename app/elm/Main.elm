module Main exposing (main)

import Html as H exposing (Html, text, div, img)
import Html.Attributes as A exposing (id, class, href, src, style, title, alt, type_, scope)
import Html.Events as E
import Json.Decode as JD
import Navigation exposing (Location)
import Routes exposing (Sitemap(..))
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar exposing (attrs)
import Bootstrap.Alert as Alert
import Bootstrap.Grid.Col as Col
import Http
import I18Next exposing
      ( t
      , tr
      , Translations
      , Delims(..)
      , initialTranslations
      , fetchTranslations
      )


-- Main
-- ----


main : Program Never Model Msg
main =
    Navigation.program parseRoute
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model
-- ------


type alias Model =
    { route : Sitemap
    , navbarState : Navbar.State
    , ready : Bool
    , error : Maybe String
    , translations: Translations
    }


type Msg
    = RouteChanged Sitemap
    | RouteTo Sitemap
    | NavbarMsg Navbar.State
    | TranslationsLoaded (Result Http.Error Translations)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        initialModel =
            { route = Routes.parsePath location
            , navbarState = navbarState
            , ready = False
            , error = Nothing
            , translations = initialTranslations
            }

        ( model, routeCmd ) =
            handleRoute initialModel.route initialModel
    in
        ( model, Cmd.batch [ navbarCmd, routeCmd, fetchTranslations TranslationsLoaded "/locale/translations.jp.json" ] )



-- Subscriptions
-- -------------


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- Update
-- ------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged route ->
            handleRoute route model

        RouteTo route ->
            model ! [ Routes.navigateTo route ]

        NavbarMsg state ->
            { model | navbarState = state } ! []

        TranslationsLoaded (Ok translations) ->
            ( { model | translations = translations },
                Cmd.none
            )

        TranslationsLoaded (Err _) ->
            ( model, Cmd.none )


parseRoute : Location -> Msg
parseRoute =
    Routes.parsePath >> RouteChanged


handleRoute : Sitemap -> Model -> ( Model, Cmd Msg )
handleRoute route ({ ready } as model) =
    let
        newModel =
            { model | route = route }
        -- fetchLang =
        --     fetchTranslations TranslationsLoaded "/locale/translations.en.json"
    in
        case route of
            -- HomeR ->
            --     newModel ! []
            -- ContactR ->
            --     newModel ! [ fetchLang ]
            _ ->
                newModel ! []



-- View
-- ----


view : Model -> Html Msg
view ({ route } as model) =
    case model.route of
        HomeR ->
            div []
                [ content model
                , div [class "nav-wrapper nav", id "nav"] [navigation model]
                ]
        ContactR ->
            div []
                [ div [class "nav-wrapper nav", id "nav"] [navigation model]
                , Grid.container [] [ content model ]
                , footer model
                ]
        _ ->
            div []
                [ div [class "nav-wrapper nav", id "nav"] [navigation model]
                , Grid.container [] [ content model ]
                , footer model
                ]

navigation : Model -> Html Msg
navigation model =
    Navbar.config NavbarMsg
        |> Navbar.lightCustomClass "navbar-inverse"
        |> Navbar.withAnimation
        |> Navbar.collapseSmall
        |> Navbar.container
        |> Navbar.brand [ href "/" ] [
            img [ alt "", src "img/logo-nav.png" ][]
        ]
        |> Navbar.items
            [ Navbar.itemLink (linkAttrs AboutR) [ text (t model.translations "nav.about") ]
            , Navbar.itemLink (linkAttrs ScheduleR) [ text (t model.translations "nav.schedule") ]
            , Navbar.itemLink (linkAttrs InstructorsR) [ text (t model.translations "nav.instructors") ]
            , Navbar.itemLink (linkAttrs ContactR) [ text (t model.translations "nav.contact") ]
            ]
        |> Navbar.customItems [ socialMenu ]
        |> Navbar.view model.navbarState



-- custom items/ right menu
socialMenu : Navbar.CustomItem msg
socialMenu =
    Navbar.customItem
        (H.nav [ class "social-nav pull-right hidden-sm-down" ]
            [ H.a [ href "http://facebook.com/ahimsayogajp" ]
                [ H.i [ class "fa fa-facebook" ]
                    []
                ]
            , H.a [ href "http://instagram.com/ahimsayogajp" ]
                [ H.i [ class "fa fa-instagram" ]
                    []
                ]
            , H.a [ href "http://twitter.com/ahimsayogajp" ]
                [ H.i [ class "fa fa-twitter" ]
                    []
                ]
            , H.a [ href "https://www.youtube.com/channel/UCihAjjXntS8Q-5a4wBIolgQ" ]
                [ H.i [ class "fa fa-youtube" ]
                    []
                ]
            , H.a [ href "mailto:miki@ahimsayoga.jp" ]
                [ H.i [ class "fa fa-envelope" ]
                    []
                ]
            ]
        )



content : Model -> Html Msg
content ({ route } as model) =
    case model.route of
        HomeR ->
            home model

        AboutR ->
            about model

        ScheduleR ->
            schedule model

        InstructorsR ->
            instructors model

        ContactR ->
            contact model

        NotFoundR ->
            notFound


footer : Model -> Html Msg
footer model =
    H.footer []
        [ H.footer [ class "site-footer", id "contact" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                [ div [ class "footer-col col-sm-12 col-lg-6 text-xs-center text-lg-left" ]
                    [ H.h2 []
                    [ text (t model.translations "footer.contactus") ]
                    , div [ class "cta" ]
                    [ H.a [ href "tel:+817044408396" ]
                        [ H.i [ class "fa fa-phone" ]
                        [] ,text "070-4440-8396"
                        ]
                    ]
                    , div [ class "cta" ]
                    [ H.a [ href "mailto:miki@ahimsayoga.jp" ]
                        [ H.i [ class "fa fa-envelope" ]
                        [] ,text "miki@ahimsayoga.jp"
                        ]
                    ]
                    , H.nav [ class "nav social-nav footer-social-nav" ]
                    [ H.a [ href "http://facebook.com/ahimsayogajp" ]
                        [ H.i [ class "fa fa-facebook" ]
                        []
                        ]
                    , H.a [ href "http://instagram.com/ahimsayogajp" ]
                        [ H.i [ class "fa fa-instagram" ]
                        []
                        ]
                    , H.a [ href "http://twitter.com/ahimsayogajp" ]
                        [ H.i [ class "fa fa-twitter" ]
                        []
                        ]
                    , H.a [ href "https://www.youtube.com/channel/UCihAjjXntS8Q-5a4wBIolgQ" ]
                        [ H.i [ class "fa fa-youtube" ]
                        []
                        ]
                    ]
                    ]
                , div [ class "footer-col col-sm-12 col-lg-6 text-xs-center text-lg-left" ]
                    [ H.p [ class "footer-text" ]
                    [ text (t model.translations "footer.body") ]
                    ]
                ]
                ]
            , div [ class "bottom" ]
                [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-lg-9 col-xs-12" ]
                    [ H.ul [ class "list-inline" ]
                        [ H.li [ class "list-inline-item" ]
                        [ H.a [ href "/" ]
                            [ text (t model.translations "nav.home") , H.span [ class "sr-only" ]
                            [ text "Toggle navigation" ]
                            ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "about" ]
                            [ text (t model.translations "nav.about") ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "schedule" ]
                            [ text (t model.translations "nav.schedule") ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "instructors" ]
                            [ text (t model.translations "nav.instructors") ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "contact" ]
                            [ text (t model.translations "nav.contact") ]
                        ]
                        ]
                    ]
                    , div [ class "col-lg-3 col-xs-12 text-lg-right text-xs-center" ]
                    [ H.p [ class "copyright-text" ]
                        [ text "© "  ,H.a [ href "http://ahimsalife.jp" ]
                        [ text "Ahimsa Life" ] ,text ", Japan"
                        ]
                    ]
                    ]
                ]
                ]
            ]
        ]


notFound : Html Msg
notFound =
    Alert.danger [ text "Page not found" ]


home : Model -> Html Msg
home model =
    div []
        [ Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.section [ class "hero" ]
                    [ div [ class "container text-xs-center" ]
                        [ div [ class "row" ]
                        [ div [ class "col-md-12" ]
                            [ H.a [ class "hero-brand", href "/", title "Home" ]
                            [ img [ alt "Bell Logo", src "img/logo.png" ]
                                []
                            ]
                            ]
                        ]
                        , div [ class "container justify-content-center" ]
                        [ H.h1 []
                            [ text "Shivam Yoga Center" ]
                        , H.p [ class "location" ]
                            [ text "Kanazawa 金沢 & Komatsu 小松" ]
                        , H.p [ class "tagline" ]
                            [ text (t model.translations "home.intro") ]
                        , H.a [ class "btn btn-full", href "schedule" ]
                            [ text (t model.translations "home.cta") ]
                        ]
                        ]
                    ]
                ]
            ]
        ]


schedule : Model -> Html Msg
schedule model =
    div []
        [
            H.section [ class "schedule", id "schedule" ]
            [ div [ class "container text-xs-center" ]
                [ H.h2 [class "text-center"]
                [ text (t model.translations "schedule.title") ]
                , div [ class "schedule-intro" ]
                [ H.p []
                    [ text (t model.translations "schedule.intro.p1")  ,H.a [ href "contact" ]
                    [ text (t model.translations "nav.contact") ] ,text (t model.translations "schedule.intro.p2")
                    ]
                ]
                , H.table [ class "table table-responsive" ]
                [ H.thead [ class "thead-default" ]
                    [ H.tr []
                    [ H.th []
                        [ text (t model.translations "schedule.locations.title") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.mon") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.tues") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.wed") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.thurs") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.fri") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.sat") ]
                    , H.th []
                        [ text (t model.translations "schedule.days.sun") ]
                    ]
                    ]
                , H.tbody []
                    [ H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "http://ahimsayoga.jp/contact" ]
                        [ text (t model.translations "schedule.locations.ahimsa.title") ]
                        , H.br []
                        []
                        , H.span [ class "address" ]
                        [ text (t model.translations "schedule.locations.ahimsa.address") ]
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text ("10am - 60" ++ (t model.translations "schedule.pricing.mins")) ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text ("7pm - 60" ++ (t model.translations "schedule.pricing.mins")) ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    ]
                    , H.tr []
                    -- [ H.th [ scope "row" ]
                    --     [ H.a [ href "http://comingle.net/inn/kanazawa-tabine" ]
                    --     [ text "旅音(tabi-Ne) Guesthouse" ] ,text ", Kanazawa"
                    --     , H.br []
                    --     []
                    --     , H.span [ class "address" ]
                    --     [ text "Starting 31st May" ]
                    --     ]
                    -- , H.td []
                    --     [ text "-" ]
                    -- , H.td []
                    --     [ text "-" ]
                    -- , H.td []
                    --     [ text "10:30am - 75mins" ]
                    -- , H.td []
                    --     [ text "-" ]
                    -- , H.td []
                    --     [ text "-" ]
                    -- , H.td []
                    --     [ text "-" ]
                    -- , H.td []
                    --     [ text "-" ]
                    -- ]
                    -- , H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "http://takigaharafarm.com" ]
                        [ text (t model.translations "schedule.locations.takigahara.title") ]
                        , H.br []
                        []
                        , H.span [ class "address" ]
                        [ text (t model.translations "schedule.locations.takigahara.address") ]
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text ("10am - 75" ++ (t model.translations "schedule.pricing.mins")) ]
                    , H.td []
                        [ text "-" ]
                    ]
                    , H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "https://goo.gl/maps/jhapfk1SZeE2" ]
                        [ text (t model.translations "schedule.locations.kiboagaoka.title") ]
                        , H.br []
                        []
                        , H.span [ class "address" ]
                        [ text (t model.translations "schedule.locations.kiboagaoka.address") ]
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text ("1:30pm & 7pm - 60" ++ (t model.translations "schedule.pricing.mins"))
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    ]
                    ]
                ],
                H.h3 [class "class-cost-title"] [text (t model.translations "schedule.pricing.title")],
                div [class "class-cost"]
                    [   H.p [class "drop-in"] [
                            H.strong [] [text ((t model.translations "schedule.pricing.dropin") ++ ": ")],
                            text ("60" ++  (t model.translations "schedule.pricing.mins") ++ " "
                            ++ (t model.translations "schedule.pricing.class") ++ " - 1,200円, 75"
                            ++ (t model.translations "schedule.pricing.mins") ++ " "
                            ++ (t model.translations "schedule.pricing.class") ++ " - 1,500円")
                        ],
                        H.p [class "monthly"] [
                            H.strong [] [text ((t model.translations "schedule.pricing.monthly") ++ ": ")],
                            text ("4 " ++ (t model.translations "schedule.pricing.classes")  ++ " - 4,000円")
                        ]
                    ]
                ]
            ]
        ]


about : Model -> Html Msg
about model =
    div []
        [
            H.section [ class "about", id "about" ]
            [ div [ class "container text-xs-center" ]
                [ H.h2 [class "text-center"]
                [ text (t model.translations "about.maintitle") ]
                , div [ class "about-text" ]
                [ H.p []
                    [ H.strong []
                    [ text "Shivam Yoga" ], text (" " ++ (t model.translations "about.shivamyoga.p1"))
                    ]
                , H.p []
                    [ text (t model.translations "about.shivamyoga.p2") ]
                , H.p []
                    [ H.strong []
                    [ text (t model.translations "about.shivamyoga.sankhya.title") ], text (" " ++ (t model.translations "about.shivamyoga.sankhya.body"))
                    ]
                , H.p []
                    [ H.strong []
                    [ text (t model.translations "about.shivamyoga.tantra.title") ], text (" " ++ (t model.translations "about.shivamyoga.tantra.body"))
                    ]
                , H.p []
                    [ H.strong []
                    [ text (t model.translations "about.shivamyoga.expression") ]
                    ]
                ]
                ]
            ]
            ,H.section [ class "features", id "features" ]
            [ div [ class "container" ]
                [ H.h2 [ class "text-sm-center" ]
                [ text (t model.translations "about.features.title") ]
                , div [ class "row" ]
                [ div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-volume-down" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Dharana" ]
                        , H.p []
                        [ text (t model.translations "about.features.dharana") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-exchange" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Pujas" ]
                        , H.p []
                        [ text (t model.translations "about.features.pujas") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-user" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Pranayamas" ]
                        , H.p []
                        [ text (t model.translations "about.features.pranayamas") ]
                        ]
                    ]
                    ]
                ]
                , div [ class "row" ]
                [ div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-balance-scale" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Asanas" ]
                        , H.p []
                        [ text (t model.translations "about.features.asanas") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-battery-full" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Bandhas" ]
                        , H.p []
                        [ text (t model.translations "about.features.bandhas") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-sign-out" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Kriyas" ]
                        , H.p []
                        [ text (t model.translations "about.features.kriyas") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-unlock-alt" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Yoganidra" ]
                        , H.p []
                        [ text (t model.translations "about.features.yoganidra") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-heart" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Mantras" ]
                        , H.p []
                        [ text (t model.translations "about.features.mantras") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-hand-paper-o" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Mudras" ]
                        , H.p []
                        [ text (t model.translations "about.features.mudras") ]
                        ]
                    ]
                    ]
                , div [ class "feature-col col-lg-4 col-xs-12" ]
                    [ div [ class "card card-block" ]
                    [ div []
                        [ div [ class "feature-icon" ]
                        [ H.span [ class "fa fa-circle" ]
                            []
                        ]
                        ]
                    , div []
                        [ H.h3 []
                        [ text "Dhyana" ]
                        , H.p []
                        [ text (t model.translations "about.features.dhyana") ]
                        ]
                    ]
                    ]
                ]
                ]
            ]
        ]


instructors : Model -> Html Msg
instructors model =
    div []
        [
            H.section [ class "team", id "team" ]
            [ div [ class "container" ]
                [ H.h2 [class "text-center"]
                [ text (t model.translations "instructors.title") ]
                , div [ class "row" ]
                [ div [ class "col-sm-3 col-xs-6 paul-bio" ]
                    [ div [ class "card card-block" ]
                    [ H.a [ href "#" ]
                        [ img [ alt "", class "team-img", src "img/paul-1.jpg" ]
                        []
                        , div [ class "card-title-wrap" ]
                        [ H.span [ class "card-title" ]
                            [ text "Paul Mc Crodden" ]
                        , H.span [ class "card-text" ]
                            [ text "Shivam Yoga Instructor" ]
                        ]
                        , div [ class "team-over" ]
                        [ H.h4 [ class "hidden-md-down" ]
                            [ text (t model.translations "instructors.connect") ]
                        , H.nav [ class "nav social-nav" ]
                            [ H.a [ href "http://twitter.com/mccrodp" ]
                            [ H.i [ class "fa fa-twitter" ]
                                []
                            ]
                            , H.a [ href "http://medium.com/@mccrodp" ]
                            [ H.i [ class "fa fa-medium" ]
                                []
                            ]
                            ]
                        , H.p []
                            [ text (t model.translations "instructors.bios.paul") ]
                        ]
                        ]
                    ]
                    ]
                , div [ class "col-sm-3 col-xs-6" ]
                    [ div [ class "card card-block" ]
                    [ img [ alt "", class "team-img", src "img/paul-2.jpg" ]
                        []
                    ]
                    ]
                , div [ class "col-sm-3 col-xs-6 miki-bio" ]
                    [ div [ class "card card-block" ]
                    [ H.a [ href "#" ]
                        [ img [ alt "", class "team-img", src "img/miki-1.jpg" ]
                        []
                        , div [ class "card-title-wrap" ]
                        [ H.span [ class "card-title" ]
                            [ text "Miki Dono" ]
                        , H.span [ class "card-text" ]
                            [ text "Shivam Yoga Instructor" ]
                        ]
                        , div [ class "team-over" ]
                        [ H.h4 [ class "hidden-md-down" ]
                            [ text (t model.translations "instructors.connect") ]
                        , H.nav [ class "nav social-nav" ]
                            [ H.a [ href "tel:+817044408396" ]
                            [ H.i [ class "fa fa-phone" ]
                                []
                            ]
                            , H.a [ href "mailto:miki@ahimsayoga.jp" ]
                            [ H.i [ class "fa fa-envelope" ]
                                []
                            ]
                            ]
                        , H.p []
                            [ text (t model.translations "instructors.bios.miki") ]
                        ]
                        ]
                    ]
                    ]
                , div [ class "col-sm-3 col-xs-6" ]
                    [ div [ class "card card-block" ]
                    [ img [ alt "", class "team-img", src "img/miki-2.jpg" ]
                        []
                    ]
                    ]
                ]
                ]
            ]
        ]


contact : Model -> Html Msg
contact model =
    div []
        [
            H.section [ class "contact" ]
            [ div [ class "container" ]
                [ H.h2 [class "text-center"]
                [ text (t model.translations "contact.title") ]
                , H.address []
                [ H.p []
                    [ H.strong []
                    [ text (t model.translations "contact.location.title") ]
                    , H.br []
                    [] ,text (t model.translations "contact.location.address.line1")
                    , H.br []
                    [] ,text (t model.translations "contact.location.address.line2")
                    , H.br []
                    [] ,text (t model.translations "contact.location.address.line3")
                    ]
                , H.abbr [ title "Phone" ]
                    [ H.i [ class "fa fa-phone" ]
                    []
                    ]
                , H.a [ href "tel:+817044408396" ]
                    [ text "070-4440-8396" ]
                , H.br []
                    []
                , H.abbr [ title "Email" ]
                    [ H.i [ class "fa fa-envelope" ]
                    []
                    ]
                , H.a [ href "mailto:miki@ahimsayoga.jp" ]
                    [ text "miki@ahimsayoga.jp" ]
                ]
                , div [ id "map" ]
                []
                ]
            ]
        ]


loading : Html Msg
loading =
    Alert.warning [ text "Loading ..." ]


linkAttrs : Sitemap -> List (H.Attribute Msg)
linkAttrs route =
    let
        onClickRoute =
            E.onWithOptions
                "click"
                { preventDefault = True
                , stopPropagation = True
                }
                (JD.succeed <| RouteTo route)
    in
        [ A.href <| Routes.toString route
        , onClickRoute
        ]
