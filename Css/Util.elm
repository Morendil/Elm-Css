module Css.Util (toCss) where

{-| Utility functions provided to make viewing the css generated by
your functions possible. I am still not quite sure just how useful this is,
but it is quite interesting to see.

#Functions
@docs toCss
-}

-- Native Imports
import String

-- Third Party Imports
import Html exposing (Html, Attribute, div, code, text, pre)
import Html.Attributes exposing (style)

-- My Imports
import Css exposing (Styles)
import Css.Flex as Flex
import Css.Display as Display exposing (display)
import Css.Margin as Margin
import Css.Padding as Padding
import Css.Font as Font


-- Arrange items in a column using flexbox.
columnStyle : Styles -> Styles
columnStyle styles =
  display Display.Flex
  <| Flex.direction Flex.Column styles


-- Remove all margin, padding, and increase the font size to 18px
codeStyle : Styles -> Styles
codeStyle styles =
  Margin.all 0 0 0 0
  <| Padding.all 0 0 0 0
  <| Font.size 18 styles


-- Arrange items in a column, and apply a 20px margin to the top and bottom.
containerStyle : Styles -> Styles
containerStyle styles =
  columnStyle
  <| Margin.all 20 0 20 0 styles


{-- In Elm, css styles are just a list of (String, String). This makes it really
easy to modify and manipulate them. In this case we want to actually show
them as they would appear in css. So we add a : between the name and value
as well as a ; to the end of the line.

ie ("color", "rgba(0, 0, 0, 1)") -> color: rgba(0, 0, 0, 1);
--}
getCode : (String, String) -> Html
getCode (name, value) =
  let pc = String.right 1 value
      v = if pc == " " then String.dropRight 1 value else value
  in
    pre
      [ style <| codeStyle [] ]
      [ code
        [ style <| codeStyle [] ]
        [ text ("  " ++ name ++ ": " ++ v ++ ";") ]
      ]


{-| This function takes a class name and a list of styles.
It will then generate a block of code that shows how the equivalent styles
would look in css.

This is really useful if you start to have really complex styles, which no
longer resemble the base abstractions that were made, yet you still want to
see how they transform to css.
-}
toCss : String -> Styles -> Html
toCss className styles =
  div
    [ style <| containerStyle [] ]
    [ code [ style <| codeStyle [] ] [ text ("." ++ className ++ " {") ]
    , div [ style <| columnStyle [] ] <| List.map (\s -> getCode s ) styles
    , code [ style <| codeStyle [] ] [ text "}" ]
    ]
