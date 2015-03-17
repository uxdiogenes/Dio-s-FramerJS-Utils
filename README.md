# Dio's FramerJS Utils
A collection of useful functions to make general prototyping with Framer faster and easier.

I sometimes use [Facebook's shortcut's for framer](https://github.com/facebook/shortcuts-for-framer) too, sometimes, so these utilities overlap little with theirs and try not to conflict.

## How to use with Framer Studio

* Create a new Framer project
* Download `dio.coffee` and put it in the `modules` folder of the project
* At the top of your code, write: `dio = require 'dio'`


## How to use with vanilla Framer.js

* Download `builds/dio.js` and place it in your project folder
* Add `<script src="dio.js"></script>` inside the <head> section of index.html


## Usage
* After importing your PSD/Sketch layers, call `initialize()` to normalize and lowercase all layer names.
    
```
myLayers = Framer.Importer.load "..."
dio.initialize(myLayers)
```

* This will let you access `myLayers['Some layer']` as simply `myLayers.some_layer`
* Note that some Javascript variable names are [reserved](http://www.javascripter.net/faq/reserved.htm) and using them as layer names can cause problems.


### `dio.clone()`
A not-bulletproof, recursive, object-copying function. Handy for copying simple object cases like `animationOptions`. For example, you might want two sets of animation options that are mostly the same except for a delay:
```
anim_opts =
	curve: 'spring-rk4'
	curveOptions:
		tension: 42
		friction: 15
		velocity: 12

other_anim_opts = dio.clone anim_opts
other_anim_opts.delay = 0.5
```

### `dio.setVisibilityWhenAnimating(layer, showStateName='showing', hideStateName='hidden')`
A quick way to set a layer to visible _before_ beginning to animate it to a show-state, and also hide it _after_ completing an animation to a hide state. This is handy when you want, say, a layer that you are animating to 0 opacity to not be around to accept click events once it is no longer visible.


### `dio.switchLayerStates(layer_names, state_name, [animation_options])`
A shortcut for switching an array of layers all to a single state name, optionally using one set of animation options.

### `dio.eachLayer(fn, [filter])`
A shortcut for running a function that takes a layer, for each layer. If you pass in an optional regular expression or filtering string as the second argument, it will only run the function on layers whose names match. So here's how you might hide any layers whose names contain "poop".:
```
hideLayer = (layer) ->
  layer.visible = false
  
dio.eachLayer hideLayer, 'poop'
```

# Questions

Submit an issue why don't you. Even better, fix it and submit a pull request!
