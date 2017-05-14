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
    }


type Msg
    = RouteChanged Sitemap
    | RouteTo Sitemap
    | NavbarMsg Navbar.State


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
            }

        ( model, routeCmd ) =
            handleRoute initialModel.route initialModel
    in
        ( model, Cmd.batch [ navbarCmd, routeCmd ] )



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


parseRoute : Location -> Msg
parseRoute =
    Routes.parsePath >> RouteChanged


handleRoute : Sitemap -> Model -> ( Model, Cmd Msg )
handleRoute route ({ ready } as model) =
    let
        newModel =
            { model | route = route }
    in
        case route of
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
                , navigation model
                ]
        _ ->
            div []
                [ navigation model
                , Grid.container [] [ content model ]
                , footer
                ]


navigation : Model -> Html Msg
navigation model =
    H.nav [ class "navbar", id "nav" ]
    [ div [ class "container" ]
    [H.a [ class "navbar-brand", href "/" ]
    [ img [ alt "", src "img/logo-nav.png" ]
      []
    ]
  , H.button [ A.attribute "aria-expanded" "false", class "navbar-toggler hidden-md-up pull-right collapsed", A.attribute "data-target" "#navbar-collapse", A.attribute "data-toggle" "collapse", type_ "button" ]
    [ H.span [ class "sr-only" ]
      [ text "Toggle navigation" ], text "☰" 
    ]
  , div [ A.attribute "aria-expanded" "false", class "navbar-toggleable-sm collapse", id "navbar-collapse" ]
    [ H.ul [ class "nav navbar-nav" ]
      [ H.li [ class "nav-item" ]
        [ H.a [ class "nav-link", href "about" ]
          [ text "About",  H.span [ class "sr-only" ]
            [ text "(current)" ]
          ]
        ]
      , H.li [ class "nav-item active" ]
        [ H.a [ class "nav-link", href "schedule" ]
          [ text "Schedule" ]
        ]
      , H.li [ class "nav-item" ]
        [ H.a [ class "nav-link", href "instructors" ]
          [ text "Instructors" ]
        ]
      , H.li [ class "nav-item" ]
        [ H.a [ class "nav-link", href "contact" ]
          [ text "Contact" ]
        ]
      ]
    ]
  , H.nav [ class "nav social-nav pull-right hidden-sm-down" ]
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
    -- , H.a [ href "https://www.youtube.com/channel/UCihAjjXntS8Q-5a4wBIolgQ" ]
    --   [ H.i [ class "fa fa-youtube" ]
    --     []
    --   ]
    , H.a [ href "mailto:miki@ahimsayoga.jp" ]
      [ H.i [ class "fa fa-envelope" ]
        []
      ]
    ]
  ]
    ]

    -- Navbar.config NavbarMsg
    --     |> Navbar.container
    --     |> Navbar.collapseMedium
    --     |> Navbar.collapseSmall
    --     -- Collapse menu at the medium breakpoint
    --     |>
    --         Navbar.attrs
    --             [ id "nav" ]
    --     -- Customize coloring
    --     |>
    --         Navbar.brand
    --             -- Add logo to your brand with a little styling to align nicely
    --             [ href "#" ]
    --             [ img
    --                 [ src "img/logo-nav.png"
    --                 , class "navbar-brand"
    --                 ]
    --                 []
    --             , text "Toggle navigation"
    --             ]
    --     |> Navbar.items
    --         [ Navbar.itemLink (linkAttrs HomeR) [ text "Home" ]
    --         , Navbar.itemLink (linkAttrs AboutR) [ text "About" ]
    --         , Navbar.itemLink (linkAttrs ScheduleR) [ text "Schedule" ]
    --         , Navbar.itemLink (linkAttrs InstructorsR) [ text "Instructors" ]
    --         , Navbar.itemLink (linkAttrs ContactR) [ text "Contact" ]
    --         ]
    --     |> Navbar.view model.navbarState


content : Model -> Html Msg
content ({ route } as model) =
    case model.route of
        HomeR ->
            home

        AboutR ->
            about

        ScheduleR ->
            schedule

        InstructorsR ->
            instructors

        ContactR ->
            contact

        NotFoundR ->
            notFound


footer : Html Msg
footer =
    H.footer []
        [ H.footer [ class "site-footer", id "contact" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                [ div [ class "footer-col col-sm-12 col-lg-6 text-xs-center text-lg-left" ]
                    [ H.h2 []
                    [ text "Contact Us" ]
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
                    -- , H.a [ href "https://www.youtube.com/channel/UCihAjjXntS8Q-5a4wBIolgQ" ]
                    --     [ H.i [ class "fa fa-youtube" ]
                    --     []
                    --     ]
                    ]
                    ]
                , div [ class "footer-col col-sm-12 col-lg-6 text-xs-center text-lg-left" ]
                    [ H.p [ class "footer-text" ]
                    [ text "Anyone that practices Shivam Yoga seeks the improvement of conscious as a focus of daily living. This is found by observing oneself. We observe the way we express ourselves through our experiences so as to cultivate a renewed awareness of this world, Nature and the Universe." ]
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
                            [ text "Home" , H.span [ class "sr-only" ]
                            [ text "Toggle navigation" ]
                            ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "about" ]
                            [ text "About" ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "schedule" ]
                            [ text "Schedule" ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "instructors" ]
                            [ text "Instructors" ]
                        ]
                        , H.li [ class "list-inline-item" ]
                        [ H.a [ href "contact" ]
                            [ text "Contact" ]
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


home : Html Msg
home =
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
                        , div [ class "col-md-10 col-md-push-1" ]
                        [ H.h1 []
                            [ text "Shivam Yoga Center" ]
                        , H.p [ class "location" ]
                            [ text "Ishikawa, Japan" ]
                        , H.p [ class "tagline" ]
                            [ text "Join our traditional Shivam Yoga classes, proven to improve health on all levels of the body." ]
                        , H.a [ class "btn btn-full", href "schedule" ]
                            [ text "View Schedule" ]
                        ]
                        ]
                    ]
                ]
            ]
        ]


schedule : Html Msg
schedule =
    div []
        [ 
            H.section [ class "schedule", id "schedule" ]
            [ div [ class "container text-xs-center" ]
                [ H.h2 []
                [ text "Class Schedule" ]
                , div [ class "schedule-intro" ]
                [ H.p []
                    [ text "See below the 2017 schedule, please check the correct location and "  ,H.a [ href "contact" ]
                    [ text "contact" ] ,text " to book in advance to avoid dissapointment." 
                    ]
                ]
                , H.table [ class "table table-responsive" ]
                [ H.thead [ class "thead-default" ]
                    [ H.tr []
                    [ H.th []
                        [ text "Location" ]
                    , H.th []
                        [ text "M" ]
                    , H.th []
                        [ text "T" ]
                    , H.th []
                        [ text "W" ]
                    , H.th []
                        [ text "T" ]
                    , H.th []
                        [ text "F" ]
                    , H.th []
                        [ text "Sa" ]
                    , H.th []
                        [ text "Su" ]
                    ]
                    ]
                , H.tbody []
                    [ H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "http://ahimsayoga.jp/contact" ]
                        [ text "Ahimsa Center" ] ,text ", Kanazawa" 
                        , H.br []
                        []
                        , H.span [ class "start-time" ]
                        [ text "Starting 16th May" ]
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "7pm - 60mins" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "7pm - 60mins" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    ]
                    , H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "http://comingle.net/inn/kanazawa-tabine" ]
                        [ text "旅音(tabi-Ne) Guesthouse" ] ,text ", Kanazawa" 
                        , H.br []
                        []
                        , H.span [ class "start-time" ]
                        [ text "Starting 24th May" ]
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "10am - 75mins" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    ]
                    , H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "http://takigaharafarm.com" ]
                        [ text "Takigahara Farm" ] ,text ", Komatsu" 
                        , H.br []
                        []
                        , H.span [ class "start-time" ]
                        [ text "Starting 2nd June" ]
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
                        [ text "10am - 75mins" ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    ]
                    , H.tr []
                    [ H.th [ scope "row" ]
                        [ H.a [ href "https://www.google.ie/maps/place/1-112+Kib%C5%8Dgaoka,+Komatsu-shi,+Ishikawa-ken+923-0826,+Japan/@36.3974177,136.4965842,19z/data=!3m1!4b1!4m13!1m7!3m6!1s0x5ff85014c2398f95:0x541113e9b0c30afe!2sKibogaoka,+Komatsu,+Ishikawa+Prefecture+923-0826,+Japan!3b1!8m2!3d36.3985343!4d136.4975591!3m4!1s0x5ff8506b510285b5:0xd2e2361d1dfd949c!8m2!3d36.3974177!4d136.4971314" ]
                        [ text "喜多笑天, 1-112 Kibogaoka" ] ,text ", Komatsu" 
                        , H.br []
                        []
                        , H.span [ class "start-time" ]
                        [ text "Starting 2nd June" ]
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
                        [ text "2pm & 7pm - 60mins" 
                        ]
                    , H.td []
                        [ text "-" ]
                    , H.td []
                        [ text "-" ]
                    ]
                    ]
                ],
                H.h3 [] [text "Class Cost"],
                div [class "class-cost"]
                    [   H.p [class "drop-in"] [
                            H.strong [] [text "Drop-in: "],
                            text "60mins class - 1,200円, 75mins class - 1,500円" 
                        ],
                        H.p [class "monthly"] [
                            H.strong [] [text "Monthly: "],
                            text "4 classes - 4,000円" 
                        ]
                    ]
                ]
            ]
        ]


about : Html Msg
about =
    div []
        [ 
            H.section [ class "about", id "about" ]
            [ div [ class "container text-xs-center" ]
                [ H.h2 []
                [ text "About Shivam Yoga" ]
                , div [ class "about-text" ]
                [ H.p []
                    [ H.strong []
                    [ text "Shivam Yoga" ], text " is a philosophical and therapeutic system combining psychology and science. This traditional methodology respects the original source of Yoga knowledge which began between 7 and 10 thousands years in the Dravidian Civilization." 
                    ]
                , H.p []
                    [ text "The Shivam Yoga is grounded on two philosophic bases called Sankhya and Tantra philosophies." ]
                , H.p []
                    [ H.strong []
                    [ text "Shankhya" ], text " explains about the existence of the life and Universe based on Universal laws, mainly Karma and Dharma laws." 
                    ]
                , H.p []
                    [ H.strong []
                    [ text "Tantra" ], text " is a behavioural philosophy. Tantra means toll (Tra) of development (Tan). Tantra is also understood as an energetic philosophy because explain about the energetic physiology of the body and life. Sankhya and Tantra philosophies are a life expression of the Dravidian people." 
                    , H.br [] []
                    , H.strong []
                    [ text "This expression is not religious or devotional." ]
                    ]
                ]
                ]
            ]
            ,H.section [ class "features", id "features" ]
            [ div [ class "container" ]
                [ H.h2 [ class "text-sm-center" ]
                [ text "Sadhana: our practice" ]
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
                        [ text "The mental concentration state by which we aim to focus the mind, lowering the frequency of our thoughts." ]
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
                        [ text "Pujas are realised through a transmission and a reception of energy. They are a spiritual but not devotional force." ]
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
                        [ text "Breathing exercises providing a greater flow of pranic energy and health throughout all of the levels of our being." ]
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
                        [ text "Mostly having names of animals or natural elements, through Asana we perfect ourselves as spiritual beings." ]
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
                        [ text "Energising exercises for the organs and glands, activating the chakras and awakening power and discipline." ]
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
                        [ text "Detoxification and purification exercises for the physical, energetic, emotional, mental and spiritual bodies." ]
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
                        [ text "A process of relaxation and self-knowledge, calming the mind and the flux of the emotions." ]
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
                        [ text "Non devotional chanting of mantras to propitiate and enter into a state of joy and happiness." ]
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
                        [ text "Mudras are gestures and energetic expressions made with the hands, arms and sometimes, the body." ]
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
                        [ text "In meditation we achieve total concentration of the mind, the state of mind after Dharana has taken place." ]
                        ]
                    ]
                    ]
                ]
                ]
            ]
        ]


instructors : Html Msg
instructors =
    div []
        [ 
            H.section [ class "team", id "team" ]
            [ div [ class "container" ]
                [ H.h2 [ class "text-xs-center" ]
                [ text "Instructors" ]
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
                            [ text "Connect with me" ]
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
                            [ text "Paul has 5 years experience giving Shivam Yoga classes in many countries worldwide." ]
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
                            [ text "Connect with me" ]
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
                            [ text "Miki trained in Dublin, Ireland and Kerala, India, completing qualification in Shivam Yoga Dublin." ]
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


contact : Html Msg
contact =
    div []
        [ 
            H.section [ class "contact" ]
            [ div [ class "container" ]
                [ H.h2 [ class "text-xs-center" ]
                [ text "Contact Us" ]
                , H.address []
                [ H.p []
                    [ H.strong []
                    [ text "Ahimsa Life" ]
                    , H.br []
                    [] ,text "2 Chome−1-24" 
                    , H.br []
                    [] ,text "Ishibiki" 
                    , H.br []
                    [] ,text "Kanazawa" 
                    , H.br []
                    [] ,text "Ishikawa Prefecture, 〒920-0935" 
                    , H.br []
                    [] ,text "Japan" 
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
