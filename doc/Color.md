### Color

- [Color](#Color)
- [Color_print](#Color_print)

#### Color

> return a colored string

- **text** \<*string*\> the text to color
- **colorOrStyle** \<*string*\> color, bgColor, or style control

+ **@return** colored string \<*string*\>

```sh
Color "Hello World" "red"
Color "Hello World" "red" "bgBlack"
# hex color
Color "Hello World" "#fa0" "#000|bg"
# rgb color
Color "Hello World" "rgb(11, 255, 0)" "rgb(0, 0, 0)|bg"
Color "Hello World" "bold" "red" "underline"

# preset colors

# black
# red
# green
# yellow
# blue
# magenta
# cyan
# white
# blackBright
# redBright
# greenBright
# yellowBright
# blueBright
# magentaBright
# cyanBright
# whiteBright

# bgBlack
# bgRed
# bgGreen
# bgYellow
# bgBlue
# bgMagenta
# bgCyan
# bgWhite
# bgBlackBright
# bgRedBright
# bgGreenBright
# bgYellowBright
# bgBlueBright
# bgMagentaBright
# bgCyanBright
# bgWhiteBright

# preset styles

# reset
# bold
# dim
# italic
# underline
# blink
# overline
# inverse
# hidden
# strikethrough
```

#### Color_print

> print a colored string

- **text** \<*string*\> the text to color
- **colorOrStyle** \<*string*\> color, bgColor, or style control

```sh
Color_print "Hello World" "red"
Color_print "Hello World" "red" "bgBlack"
# hex color
Color_print "Hello World" "#fa0" "#000|bg"
# rgb color
Color_print "Hello World" "rgb(11, 255, 0)" "rgb(0, 0, 0)|bg"
Color_print "Hello World" "bold" "red" "underline"
```