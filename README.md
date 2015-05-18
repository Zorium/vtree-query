# vtree-query

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
$('div').textContent.should.be 'test'

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

$('div .class #id span').textContent.should.be 'abc'
$('span').textContent.should.be 'abc'

$$('div .class #id span').length.should.be 2
$$('span').length.should.be 2

# Attributes
tree = z 'div',
  z 'a', href: 'abc', 'aaa'

$ = query tree
$('a[href=abc]').textContent.should.be 'aaa'
```

## query(vtree, selector)

Returns first matching vNode, with a `textContent` property
This method supports [currying](http://en.wikipedia.org/wiki/Currying)  

```coffee
tree = z 'div', 'test'
$ = query(tree)
$('div').textContent.should.be 'test'
```

## query.all()

Returns all matching vNodes, with `textContent` properties
This method supports [currying](http://en.wikipedia.org/wiki/Currying)  

```coffee
tree = z 'div', 'test'
$$ = query.all(tree)
$$('div')[0].textContent.should.be 'test'
```
