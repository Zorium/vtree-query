# vtree-query

Testing utility for the [Zorium](https://zorium.org) framework

### Install

```bash
npm install --save-dev vtree-query
```

### Example

```coffee
z = require 'zorium'
query = require 'vtree-query'

tree = z 'div', 'test'
$ = query(tree)
$('div').contents.should.be 'test'

tree =
  z 'div',
    z '.class',
      z '#id',
        z 'span',
          'abc'
        z 'span',
          'xyz'

$ = query(tree)
$$ = query.all(tree)

$('div .class #id span').contents.should.be 'abc'
$('span').contents.should.be 'abc'

$$('div .class #id span').length.should.be 2
$$('span').length.should.be 2

# Properties
tree = z 'input', type: 'button'
$ = query tree
$('input').type.should.be 'button'

# Attributes
tree = z 'div',
  z 'a', href: 'abc', 'aaa'

$ = query tree
$('a[href=abc]').contents.should.be 'aaa'
```

## query(vtree, selector)

Returns first matching vNode, with a `contents` property that contains text info.  
This method supports [currying](http://en.wikipedia.org/wiki/Currying)  

```coffee
tree = z 'div', 'test'
$ = query(tree)
$('div').contents.should.be 'test'
```

## query.all()

Returns all matching vNodes, with `contents` properties that contain text info.  
This method supports [currying](http://en.wikipedia.org/wiki/Currying)  

```coffee
tree = z 'div', 'test'
$$ = query.all(tree)
$$('div')[0].contents.should.be 'test'
```
