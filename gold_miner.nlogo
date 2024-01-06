;; WELCOME TO THE GOLD MINER WORLD

;; We create a simulation environment of the game "Gold Miner".
;; Our purpose is finding the relative best strategy, making the most money & spending the least time.
;; LET'S PLAY! :-)


breed [miners miner]
miners-own [

  ;vision ;; the size of the vision radius (between 1 and max-eye-size)
]

breed [diamonds diamond]
breed [stones stone]
breed [golds gold]

turtles-own [value] ;; give values to each treasure, 200 for diamond, 100 for gold, 50 for stone

globals [step
  total_step
  target-treasure
  money
  Y   ;; Y = miner's money / total_step
  miner's_money
  a
  b
]


to setup
  ca
  import-drawing "黄金矿工.png" ;; set "treasure field" background

  add_miner ;; set miner to find treasure
  add_treasure ;; set target-treasure including diamond, stone, golds

  set target-treasure nobody

  set Y 0
  set miner's_money 0

  reset-ticks

end


to add_miner
  create-miners 1[
    set shape "miner"
    set color 24
    set size 5
    setxy 31 36
    set money 0
    set energy energy
    set label energy
  ]
end


to add_treasure ;; add miner, diamonds, golds, stones in treasure field
  create-diamonds num_diamond[
    set shape "diamond"
    set size 2
    setxy random-xcor random 20 ;; only appear in middle and lower layers
    set heading 0
    set value 200
  ]

  create-golds num_gold[
    set shape "gold"
    set size 5
    setxy random-xcor random 20 ;; only appear in middle and lower layers
    set value 100
  ]

  create-stones num_stone[
    set shape "stone"
    set color 23
    set size 3
    setxy random-xcor random 20 ;; only appear in middle and lower layers
    set value 50
  ]
end



;; compare two strategy to find the best one, make money while saving time

to strategy_1 ;; strategy 1: go nearest first

  ask miners [
    pd

    set a xcor
    set b ycor

    set target-treasure min-one-of other turtles [distance myself]

    ask target-treasure [
      set step (distancexy a b)
      set total_step total_step + step

    ]

    move-to target-treasure

    ask other turtles-here [die]



    set energy energy - 1
    set label energy
    if energy < 0 [die]


    if count turtles with [breed != miners] = 0 [stop]
    if energy = 0 [stop]
    ;; set Y miner's_money / total_step
  ]

  print (word "Step=" step)
  print (word "TotalStep=" total_step)

  set Y ((num_diamond * 200 + num_gold * 100 + num_stone * 50) - count turtles with [shape = "diamond"] * 200 - count turtles with [shape = "gold"] * 100 - count turtles with [shape = "stone"] * 50) / total_step
  set miner's_money ((num_diamond * 200 + num_gold * 100 + num_stone * 50) - count turtles with [shape = "diamond"] * 200 - count turtles with [shape = "gold"] * 100 - count turtles with [shape = "stone"] * 50)

  tick

end


to strategy_2 ;; strategy 2: go high value first: diamond > gold > stone

  ask miners [
    pd

    set a xcor
    set b ycor

    set target-treasure max-one-of turtles with [breed != miners] [value]


    ask target-treasure [
      set step (distancexy a b)
      set total_step total_step + step

    ]



    move-to max-one-of turtles with [breed != miners] [value]

    set energy energy - 1
    set label energy
    if energy < 0 [die]




    ;; set step distance target-treasure




    ;; if count turtles with [shape = "diamond"] = 1 [set money money + 200]

    ask diamonds-here [die]

    if count turtles with [shape = "diamond"] = 0 [
      ask golds-here [die]

      if count turtles with [shape = "gold"] = 0 [
        ask stones-here [die]]
      ;;[set money money + 100]

      if count turtles with [breed != miners] = 0 [stop]
      if energy = 0 [stop]

    ]
  ]



  print (word "Step=" step)
  print (word "Total_Step=" total_step)

  set Y ((num_diamond * 200 + num_gold * 100 + num_stone * 50) - count turtles with [shape = "diamond"] * 200 - count turtles with [shape = "gold"] * 100 - count turtles with [shape = "stone"] * 50) / total_step
  set miner's_money ((num_diamond * 200 + num_gold * 100 + num_stone * 50) - count turtles with [shape = "diamond"] * 200 - count turtles with [shape = "gold"] * 100 - count turtles with [shape = "stone"] * 50)

  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
828
429
-1
-1
10.0
1
10
1
1
1
0
0
0
1
0
60
0
40
0
0
1
ticks
30.0

BUTTON
67
14
133
47
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
17
54
189
87
num_diamond
num_diamond
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
17
95
189
128
num_gold
num_gold
0
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
17
138
189
171
num_stone
num_stone
0
40
40.0
1
1
NIL
HORIZONTAL

BUTTON
886
20
987
53
NIL
strategy_1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
887
112
988
145
NIL
strategy_2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
853
161
1025
194
vision
vision
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
18
180
190
213
energy
energy
0
100
21.0
1
1
NIL
HORIZONTAL

MONITOR
27
225
84
270
NIL
step
17
1
11

MONITOR
106
226
188
271
NIL
total_step
17
1
11

MONITOR
106
282
199
327
diamond value
count turtles with [shape = \"diamond\"] * 200
17
1
11

MONITOR
10
282
99
327
all value
num_diamond * 200 + num_gold * 100 + num_stone * 50
17
1
11

MONITOR
17
336
99
381
gold value
count turtles with [shape = \"gold\"] * 100
17
1
11

MONITOR
109
336
198
381
stone value
count turtles with [shape = \"stone\"] * 50
17
1
11

MONITOR
53
393
156
438
miner's_money
(num_diamond * 200 + num_gold * 100 + num_stone * 50) - count turtles with [shape = \"diamond\"] * 200 - count turtles with [shape = \"gold\"] * 100 - count turtles with [shape = \"stone\"] * 50
17
1
11

PLOT
854
216
1054
366
gain_curve
NIL
Y
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"total_step" 1.0 0 -16777216 true "" "plot Y"

MONITOR
892
379
1018
424
Y
((num_diamond * 200 + num_gold * 100 + num_stone * 50) - count turtles with [shape = \"diamond\"] * 200 - count turtles with [shape = \"gold\"] * 100 - count turtles with [shape = \"stone\"] * 50) / total_step
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

diamond
true
7
Polygon -11221820 true false 120 75 180 75 225 120 75 120 120 75
Polygon -11221820 true false 75 120 150 225 225 120 75 120 75 120
Line -11221820 false 120 75 150 120
Line -1 false 75 120 225 120
Line -1 false 120 120 150 225
Line -1 false 150 225 180 120
Line -1 false 120 75 120 120
Line -1 false 120 75 150 120
Line -1 false 180 75 150 120
Line -1 false 180 75 180 120

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

gold
true
0
Polygon -6459832 true false 150 60 120 75 135 90 105 60 90 75 75 90 75 105 60 120 60 135 90 150 105 165 120 165 135 150 150 165 165 150 180 135 180 105 165 75 150 60
Polygon -1184463 true false 105 75 90 90 90 105 75 120 75 135 105 150 135 135 150 150 165 135 165 105 150 75 135 90 120 90 105 75
Polygon -1184463 true false 105 60 75 90 75 105 60 120 60 135 90 150 105 165 120 165 135 150 150 165 180 135 180 105 165 75 150 60 120 75 105 60
Polygon -955883 true false 105 60 75 90 75 105 60 120 60 135 90 150 105 165 120 165 135 150 150 165 180 135 180 105 165 75 150 60 120 75 105 60 105 75 90 90 90 105 75 120 75 135 90 135 105 150 120 150 135 135 150 150 165 135 165 105 165 90 150 75 120 90 105 75

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

miner
false
2
Rectangle -7500403 true false 123 76 176 95
Polygon -6459832 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -6459832 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true false 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true true 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true true 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -6459832 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -7500403 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285
Line -16777216 false 135 45 135 60
Line -16777216 false 165 45 165 60

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

stone
false
2
Polygon -16777216 true false 140 145 170 250 245 190 234 122 247 107 260 79 260 55 245 40 215 32 185 40 155 31 122 41 108 53 28 118 110 115 140 130
Polygon -6459832 true false 135 151 165 256 240 196 225 121 241 105 255 76 255 61 240 46 210 38 180 46 150 37 120 46 105 61 47 108 105 121 135 136
Polygon -1 true false 60 181 45 256 165 256 150 181 165 166 180 136 180 121 165 106 135 98 105 106 75 97 46 107 29 118 30 136 45 166 60 181
Polygon -6459832 false false 45 255 165 255 150 180 165 165 180 135 180 120 165 105 135 97 105 105 76 96 46 106 29 118 30 135 45 165 60 180
Line -16777216 false 165 255 239 195
Polygon -955883 false true 30 120 30 135 45 165 60 180 45 255 165 255 150 180 165 165 180 135 180 120 165 105 135 90 105 105 75 90 45 105 30 120 30 135 105 150
Polygon -6459832 true false 75 105 75 105 60 135 90 165 105 120 75 105
Polygon -6459832 true false 75 90 105 135 135 120 135 90 105 105 75 90
Polygon -6459832 true false 75 90 45 105 30 120 90 105 75 90
Polygon -6459832 true false 135 90 135 120 165 105 135 90
Polygon -6459832 true false 45 255 120 240 165 255 45 255
Polygon -6459832 true false 150 180 135 225 165 255 150 180
Polygon -6459832 true false 30 120 30 135 45 165 60 135 30 120
Polygon -6459832 true false 45 165 60 180 75 150 60 135
Polygon -6459832 true false 60 180 45 255 75 210 60 180
Polygon -6459832 true false 165 105 105 135 150 180 195 135 165 105
Polygon -6459832 true false 30 120 60 135 90 120 75 105 30 120
Polygon -6459832 true false 75 150 60 180 75 210 135 165 90 135 105 135 135 165 75 150
Polygon -6459832 true false 75 210 150 195 150 180 135 165 75 210
Polygon -6459832 true false 75 210 60 240 135 225 150 195 75 210
Polygon -6459832 true false 135 225 60 240 45 255 135 225 120 240 45 255
Polygon -6459832 true false 135 225 120 240 165 255 135 225
Polygon -6459832 true false 105 135 90 150 135 165 105 135
Polygon -6459832 true false 90 105 75 105 90 120 90 105
Polygon -6459832 true false 105 120 75 165 135 165 105 120
Polygon -6459832 true false 75 210 45 255 75 225 75 210
Polygon -7500403 true false 150 45 120 60 45 120 45 135 75 165 60 195 60 240 90 240 135 240 165 240 225 195 210 120 225 90 240 75 240 60 225 60 195 60 180 60 150 45 135 60
Line -7500403 false 150 45 135 90
Line -7500403 false 45 120 135 90
Line -7500403 false 135 90 210 120
Line -7500403 false 135 90 135 150
Line -7500403 false 135 150 75 165
Line -7500403 false 135 150 225 195
Line -7500403 false 135 150 60 240
Line -7500403 false 135 150 135 195
Line -7500403 false 135 195 165 240

suit diamond
false
0
Polygon -7500403 true true 150 15 45 150 150 285 255 150

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
