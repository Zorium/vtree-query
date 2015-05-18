z = require 'zorium'
should = require('clay-chai').should()

query = require './index'

describe 'vtree-query', ->
  it 'queries vtree from zorium', ->
    tree = z 'div', 'test'
    $ = query(tree)
    $('div').contents.should.be 'test'

  it 'deep queries using css selectors', ->
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
    $('div .class span').contents.should.be 'abc'
    $('div #id span').contents.should.be 'abc'
    $('.class #id span').contents.should.be 'abc'
    $('.class span').contents.should.be 'abc'
    $('#id span').contents.should.be 'abc'
    $('span').contents.should.be 'abc'

    $$('div .class #id span').length.should.be 2
    $$('div .class span').length.should.be 2
    $$('div #id span').length.should.be 2
    $$('.class #id span').length.should.be 2
    $$('.class span').length.should.be 2
    $$('#id span').length.should.be 2
    $$('span').length.should.be 2

    $('div .class #id').contents.should.be 'abcxyz'
    $$('div .class #id span')[0].contents.should.be 'abc'
    $$('div .class #id span')[1].contents.should.be 'xyz'

  it 'deep queries sub-components', ->
    class Wrapper
      render: ({$el}) ->
        z '.z-wrapper',
          $el

    $wrapper = new Wrapper()
    $ = query z '.top',
      z $wrapper,
        $el: z '.sub', 'abc'

    $('.top .sub').contents.should.be 'abc'

  it 'queries by attribute', ->
    $ = query z 'div',
      z 'a', href: 'xyz', 'xxx'
      z 'a', href: 'abc', 'aaa'

    $('a[href=xyz]').contents.should.be 'xxx'
    $('a[href=abc]').contents.should.be 'aaa'

  it 'passes props', ->
    $ = query z 'input', type: 'button'
    $('input').type.should.be 'button'

  it 'supports input value prop', ->
    $ = query z 'input', value: 'abc'
    $('input').value.should.be 'abc'

  it 'passes attribues', ->
    $ = query z 'input', attributes: name: 'myname'
    $('input[name=myname]').attributes.name.should.be 'myname'
