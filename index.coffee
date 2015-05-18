_ = require 'lodash'
cssauron = require 'cssauron'

language = cssauron(
  tag: 'tagName'
  children: 'children'
  parent: 'parent'
  contents: 'contents'
  attr: (node, attr) ->
    val = node.attributes?[attr]
    if val is undefined
      return node[attr]
    return val
  class: (node) ->
    node.className
  id: (node) ->
    node.id
)

traverse = (vtree, fn) ->
  fn vtree
  _.map vtree.children, (vtree) ->
    traverse vtree, fn

getTextContent = (vtree) ->
  if vtree.type is 'VirtualText'
    return vtree.text

  if _.isEmpty vtree.children
    return ''


  _.map(vtree.children, getTextContent).join('')

isHook = (hook) ->
  hook and _.isFunction(hook.hook) and not hook.hasOwnProperty 'hook'

mapTree = (vtree, parent) ->
  if vtree.type is 'VirtualText'
    return {
      contents: vtree.text
      parent: parent
      vtree: vtree
    }

  if vtree.type is 'Thunk'
    return mapTree vtree.render(vtree.vnode), parent

  # FIXME: A side effect of virtual-hyperscript not being user friendly
  if isHook vtree.properties.value
    vtree.properties.value = vtree.properties.value.value

  node = _.defaults
    tagName: vtree.tagName
    contents: getTextContent vtree
    parent: parent
    vtree: vtree
  , vtree.properties

  node.children = _.map vtree.children, (child) ->
    mapTree child, node

  return node

capitalizeTags = (selectorString) ->
  selectorString.replace /(^|\s)(\w+)/g, (all) ->
    all.replace /\w+/g, (tag) ->
      tag.toUpperCase()

queryAll = _.curry (tree, selectorString) ->

  selector = language capitalizeTags selectorString

  node = mapTree(tree)
  matched = []
  # Traverse each node in the tree and see if it matches our selector
  traverse node, (node) ->
    result = selector(node)
    if result
      unless _.isArray result
        result = [result]
      matched.push.apply matched, result
    return

  if _.isEmpty matched
    return null

  matched

queryOne = _.curry (tree, selectorString) ->
  _.first queryAll tree, selectorString

_.assign queryOne,
  all: queryAll

module.exports = queryOne
