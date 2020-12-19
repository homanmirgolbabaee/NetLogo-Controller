;;Forest Fire Model
;;by Kevin Stessel
;;June 2019

breed[fires fire]
breed[trees tree]
breed[raindrops raindrop]
breed[treecorpses treecorpse];;Baumkronen        ;;Count the dead trees
breed[firecorpses firecorpse];;Feuerkronen        ;;Count the dead fires
globals[
  burned-trees
]

to Setup_spreadingFire                            ;;Initializes the program.
  clear-all
  create_turtles
  update-plot
  set burned-trees 0
  reset-ticks
end

to create_turtles
  create-trees number-trees[
    set color green
    set shape "tree"
    setxy random-xcor random-ycor]
  create-fires fire-strength [
    set color red
    set shape "fire"
    setxy random-xcor random-ycor]
end

to setup_groundFire
  clear-all
  create_turtles
  update-plot
  set burned-trees 0
  reset-ticks
  ask patches[
    set pcolor 35.6]
end

to setup_hill
  clear-all
  create_turtles
  update-plot
  set burned-trees 0
  reset-ticks
  ;let hill bitmap:import "hoehe.png"
  ;let hill-width bitmap:width hill
  ;let hill-height bitmap:height hill
  ;let untergrund_hill bitmap:scaled hill 16 16
  ;bitmap:copy-to-pcolors untergrund_hill true
  ;ask patches[
  ;  set pcolor grey]
  ask n-of 600 patches[
  set pcolor grey
  ]
  ask n-of 600 patches[
  set pcolor 2
  ]
  ask n-of 600 patches[
  set pcolor 1
  ]
  ask patches with [pcolor = 0] [
  set pcolor grey
  ]
end

to update-plot
  set-current-plot "Populations"
  set-current-plot-pen "trees"
  plot count trees
  set-current-plot-pen "fires"
  plot count fires
end

to go
  if count trees = 0 [stop];; if all trees are burned - stop
  if count patches with [pcolor = 105] = count patches [stop]
  if rain?
  [
    create-raindrops rain-rate
       [move-to one-of patches
        set shape "circle"
        set size 0.5
        set color 104 ]
  ]
  ask patches with [any? raindrops-here and any? fires-here];;if rain and fire is on the same patch
    [
      set pcolor 105
      ask fires[
        if pcolor = 105[
          die
        ]
      ]
    ]

  ask fires
  [
    if (pcolor = 35.6) or (pcolor = 16);;Bodenfeuer
    [
      set pcolor 16
      if wind_on_off?[
        set heading wind-direction
        rt 2
        fd 0.5
        set pcolor 16
      ]
      ask neighbors4 [ set pcolor 16 ]
      fd 0.5
      set pcolor 16
    ]
    let probability random 100
    if probability <= probability-spread
      [
        if wind_on_off?
          [
            set heading 0
            set heading wind-direction
            ;;very flat
            if (((wind-direction >= 0) and (wind-direction <= 89)) or ((wind-direction >= 271) and (wind-direction <= 359))) and (pcolor = grey)
            [
              hill-kill-trees 0.8
            ]
            if (((wind-direction >= 0) and (wind-direction <= 89)) or ((wind-direction >= 271) and (wind-direction <= 359))) and (pcolor = 2);,steiler
            [
              hill-kill-trees 2
            ]
            if (((wind-direction >= 0) and (wind-direction <= 89)) or ((wind-direction >= 271) and (wind-direction <= 359))) and (pcolor = 1);;am steilsten
            [
              hill-kill-trees 3
            ]
            if (((wind-direction >= 90) and (wind-direction <= 180)) or ((wind-direction >= 181) and (wind-direction <= 269))) and (pcolor = grey);;ganz flach
            [
              hill-kill-trees 0.8
            ]
            if (((wind-direction >= 90) and (wind-direction <= 180)) or ((wind-direction >= 181) and (wind-direction <= 269))) and (pcolor = 2);;steiler
            [
              hill-kill-trees 0.4
            ]
            if (((wind-direction >= 90) and (wind-direction <= 180)) or ((wind-direction >= 181) and (wind-direction <= 269))) and (pcolor = 1);,am Steilsten
            [
              hill-kill-trees 0.1
            ]
            if big_jumps?
              [
                if random 100 <= probability-big-jumps
                  [
                    kill-tree-jump
                ]
            ]
            hill-kill-trees 0.5
        ]
        kill-trees
      ]
    ]
  update-plot
  tick
end

to kill-trees
  let neighbors_tree one-of trees in-radius fire-radius
  ifelse neighbors_tree != nobody
     [face neighbors_tree ask neighbors_tree [set breed treecorpses hide-turtle] fd 0.5
        hatch 1 [fd 0.5]]
     [set breed firecorpses hide-turtle]
end

to kill-tree-jump
  let direction wind-direction
  set heading direction
  fd 2
  let next_neighbors one-of trees in-radius fire-radius
  ifelse next_neighbors != nobody
      [face next_neighbors ask next_neighbors [set breed treecorpses hide-turtle] set heading wind-direction fd 0.5
        hatch 1 [set heading wind-direction fd 0.5]]
  [set breed firecorpses hide-turtle]
end

to hill-kill-trees [speed]
  let neighbors_tree one-of trees in-radius fire-radius
  ifelse neighbors_tree != nobody
     [face neighbors_tree ask neighbors_tree [set breed treecorpses hide-turtle] set heading wind-direction fd speed
      hatch 1 [set heading wind-direction fd speed]]
    [set breed firecorpses hide-turtle]
end
@#$#@#$#@
GRAPHICS-WINDOW
461
25
1081
646
-1
-1
14.93
1
10
1
1
1
0
0
0
1
-20
20
-20
20
1
1
1
ticks
30.0

SLIDER
33
45
205
78
number-trees
number-trees
0
2000
1300
50
1
NIL
HORIZONTAL

SLIDER
35
100
207
133
fire-strength
fire-strength
1
20
20
1
1
NIL
HORIZONTAL

PLOT
262
26
422
146
Populations
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Fires" 1.0 0 -2674135 true "" ""
"Trees" 1.0 0 -14439633 true "" ""

BUTTON
29
304
180
337
Setup - spreading fire
Setup_spreadingFire\n
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
204
301
267
334
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
34
145
206
178
fire-radius
fire-radius
0.5
4
2
0.1
1
NIL
HORIZONTAL

MONITOR
34
185
113
230
Trees
count Trees
17
1
11

MONITOR
33
242
90
287
Fires
count Fires
17
1
11

MONITOR
246
187
392
232
Percent of burned trees
((number-trees - count Trees) / number-trees) * 100
17
1
11

SLIDER
164
356
336
389
wind-direction
wind-direction
0
360
45.0
5
1
NIL
HORIZONTAL

SWITCH
30
356
161
389
wind_on_off?
wind_on_off?
0
1
-1000

SWITCH
28
400
153
433
rain?
rain?
1
1
-1000

SLIDER
167
399
339
432
rain-rate
rain-rate
0
20
0.0
1
1
drops / tick
HORIZONTAL

MONITOR
119
185
235
230
Burned trees
count treecorpses
17
1
11

SLIDER
30
457
202
490
probability-spread
probability-spread
0
100
90
1
1
NIL
HORIZONTAL

SWITCH
30
555
147
588
big_jumps?
big_jumps?
1
1
-1000

MONITOR
118
242
227
287
Dead fires
count firecorpses
17
1
11

SLIDER
153
555
334
588
probability-big-jumps
probability-big-jumps
0
100
80.0
1
1
NIL
HORIZONTAL

BUTTON
278
303
414
336
Setup - ground fire
setup_groundFire
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
30
509
197
542
Setup - hill map
setup_hill
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
352
549
502
605
Without wind:\n\tno big jumps\n\tclimp the hill\n\n
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

This model simulates the spread of a fire through a forest and it depends on the type of fire. Furthermore, it is possible to see, which variables have an influence on the propagation. 

## HOW IT WORKS

The amount of fires spawns randomly on a patch. Each fire looks 360 degree around of it in the size of the fire radius for potential trees. The fire chooses one of the potential trees in the fire radius and killed it, from the death tree a new fire is generated. If there are no trees in the fire radius the fire dies. 

If the wind option is on, it is possible to set the wind direction. So, the fire will go through the wind direction and kill the trees on the path. Furthermore, there is a probability, that the fire is spreading or not. 

If the big jump option is on, the fire will take big jumps over some patches depending on the probability. Big jumps mean, that some embers rolling down the hill or the wind is spreading some pieces of embers over the trees away. 

Furthermore, it is possible to switch on the rain slider, to create some rain drops. If a rain drop and a fire are on the same patch, the fire will be killed, and the patch is blue coloured. It is possible to increase or decrease the drops per ticks. 

Depending on the used setup for the different types of forest fire, the fire will have a different behaviour. 

## HOW TO USE IT

There are three SETUP buttons, for each type of fire one button. Click the GO button to start the simulation. 

The Number-trees slider controls the number of trees in the simulation. Changes in this slider do not have any effect until the next SETUP command. 

The Fire-strength slider controls the number of fires. Changes in this slider do not have any effect until the next SETUP command. 

The Fire-radius slider controls the watching radius of each fire. One tree in this radius will be randomly selected to get killed. Changes in this slider do not have any effect until the next SETUP command. 

The Wind-direction slider controls the direction of the wind in degree. To use wind, the switch must be on. 

The Rain-rate slider controls the number of raindrops per tick. To use raindrops, the switch must be on. 

The Probability-spread slider controls the randomly spread of the fire. 
The Probability-big Jumps slider controls the probability of big-jumps fire spread. To use wind, the switch must be on. 

There are other parameters in the model that are not accessible by sliders. They can be changed by modifying the code in the code tab. They are: 

•	the speed if wind is on - [0.1 - 3] 
•	the distance of big jumps - [2] 

## THINGS TO NOTICE

* Try the different setup buttons to watch the speed and spread of the fire. 
* If the probability of spread is near 0, there will be no fire spread. 
* If there are under 1000 trees, the fire will not spread. 

## THINGS TO TRY

Try different numbers of the variables to get different solutions. 

## EXTENDING THE MODEL

* It is also possible to extend the model to add some other bitmap maps, to get another solution. For example, a bitmap map with a track on it to stop the fire. 
* make bigger trees 
* add a moisture of the trees and ground
* add different ages of the trees
* create a wall of fire
* ...

## NETLOGO FEATURES

none

## RELATED MODELS

Following models in the NetLogo Models Library are relevant for this model:

* Fire
* Fire Simple
* Fire Simple Extension 1 - 3

## CREDITS AND REFERENCES

made by Kevin Stessel in June 2019
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

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

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
NetLogo 6.0.4
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
