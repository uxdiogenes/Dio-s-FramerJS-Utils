dio = {}

# internal helpers
sluggifyNameString = (str) ->
  return str.replace(/[-+!?:*\[\]\(\)\/]/g, '').trim().replace(/\s/g, '_').toLowerCase()

sanitizeLayerName = (layer) ->
  return sluggifyNameString layer.name


dio.normalizeImportedLayers = (layers) ->
  for layer_name in Object.keys(layers)
    layer = layers[layer_name]
    delete layers[layer_name]
    layers[sluggifyNameString layer_name] = layer


dio.initialize = (layers) ->
  layers = Framer.CurrentContext._layerList if not layers
  dio.normalizeImportedLayers layers
  window.Layers = layers

dio.clone = clone = (obj) ->
  copy = undefined
  # Handle the 3 simple types, and null or undefined
  if null == obj or 'object' != typeof obj
    return obj
  # Handle Date
  if obj instanceof Date
    copy = new Date
    copy.setTime obj.getTime()
    return copy
  # Handle Array
  if obj instanceof Array
    copy = []
    len = obj.length
    for i in [0..len-1]
      copy[i] = clone(obj[i])
    return copy
  # Handle Object
  if obj instanceof Object
    copy = {}
    for attr of obj
      if obj.hasOwnProperty(attr)
        copy[attr] = clone(obj[attr])
    return copy

  throw new Error('Unable to copy obj! Its type isn\'t supported.')

dio.setVisibilityWhenAnimating = (layer, showStateName = 'showing', hideStateName = 'hidden') ->
  layer.on Events.StateWillSwitch, (from, to) ->
    layer.visible = true  if to is showStateName or to is 'default'

  layer.on Events.StateDidSwitch, (from, to) ->
    return  if to is from # Workaround for https://github.com/koenbok/Framer/issues/173
    layer.visible = false  if to is hideStateName

dio.switchLayerStates = (layer_names, state_name, animation_options) ->
  for layer_name in layer_names
    layer = window.Layers[layer_name]
    layer.states.switch state_name, animation_options

dio.eachLayer = (fn, filter) ->
  if typeof filter is 'string'
    filter = new RegExp(str, 'i')

  for layer of window.Layers
    _layer = window.Layers[layer]
    fn _layer if not filter or layer.name.match filter

_.extend(exports, dio)
