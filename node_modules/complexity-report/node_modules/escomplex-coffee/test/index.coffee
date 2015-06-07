'use strict'

{ assert } = require 'chai'

modulePath = '../src'

suite 'escomplex-coffee:', ->
  test 'require does not throw', ->
    assert.doesNotThrow ->
      require modulePath

  test 'require returns object', ->
    assert.isObject require modulePath

  suite 'require:', ->
    escomplex = undefined

    setup ->
      escomplex = require modulePath

    teardown ->
      escomplex = undefined

    test 'analyse function is exported', ->
      assert.isFunction escomplex.analyse

    test 'analyse throws when source is invalid CoffeeScript string', ->
      assert.throws ->
        escomplex.analyse 'foo ='

    test 'analyse does not throw when source is valid CoffeeScript string', ->
      assert.doesNotThrow ->
        escomplex.analyse 'foo = "#{foo}"\nunless foo isnt "foo"\n  console.log "foo"\n  foo = undefined\nelse\n  console.log foo'

    test 'analyse does not throw when source is valid array', ->
      assert.doesNotThrow ->
        escomplex.analyse [
          { code: '"foo"', path: 'foo' }
          { code: '"bar"', path: 'bar' }
        ]

    test 'analyse throws when source array contains invalid CoffeeScript', ->
      assert.throws ->
        escomplex.analyse [
          { code: 'foo =', path: 'foo' }
          { code: '"bar"', path: 'bar' }
        ]

    test 'analyse throws when source array is missing path', ->
      assert.throws ->
        escomplex.analyse [
          { code: '"foo"', path: 'foo' }
          { code: '"bar"' }
        ]

    suite 'analyse string:', ->
      result = undefined

      setup ->
        result = escomplex.analyse '"foo"'

      teardown ->
        result = undefined

      test 'analyse returns object', ->
        assert.isObject result

      test 'analyse returns aggregate property', ->
        assert.isObject result.aggregate

      test 'analyse returns maintainability property', ->
        assert.isNumber result.maintainability

      test 'analyse returns functions property', ->
        assert.isArray result.functions

      test 'analyse returns dependencies property', ->
        assert.isArray result.dependencies

    suite 'analyse array:', ->
      result = undefined

      setup ->
        result = escomplex.analyse [ { code: '"foo"', path: 'foo' } ]

      teardown ->
        result = undefined

      test 'analyse returns object when source is array', ->
        assert.isObject result

      test 'analyse returns reports when source is array', ->
        assert.isArray result.reports
        assert.lengthOf result.reports, 1

      test 'analyse returns matrices when source is array', ->
        assert.isArray result.adjacencyMatrix
        assert.lengthOf result.adjacencyMatrix, 1
        assert.isArray result.visibilityMatrix
        assert.lengthOf result.visibilityMatrix, 1

    suite 'analyse conditions:', ->
      result = undefined

      setup ->
        result = escomplex.analyse """
                                   foo = Math.random()
                                   bar = Math.random()

                                   if foo isnt bar
                                     console.log 'foo isnt bar'

                                   unless foo is bar
                                     console.log 'foo still isnt bar'
                                   """

      teardown ->
        result = undefined

      test 'maintainability index is correct', ->
        assert.notEqual result.maintainability, 171

