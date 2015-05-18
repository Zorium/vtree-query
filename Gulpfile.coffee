gulp = require 'gulp'
mocha = require 'gulp-mocha'

paths =
  tests: './test.coffee'
  coffee: './*.coffee'

gulp.task 'default', ['test']

gulp.task 'test', ->
  gulp.src paths.tests
    .pipe mocha()

gulp.task 'watch', ->
  gulp.watch paths.coffee, ['test']
