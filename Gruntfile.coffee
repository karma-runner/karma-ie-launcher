JSHINT_NODE =
  node: true,
  strict: false

module.exports = (grunt) ->

  allSrc = ['index.js']
  allTests = ['test/mocha-globals.coffee', 'test/*.spec.coffee']
  all = [].concat(allSrc).concat(allTests).concat(['Gruntfile.coffee'])

  # Project configuration.
  grunt.initConfig
    pkgFile: 'package.json'

    'npm-contributors':
      options:
        commitMessage: 'chore: update contributors'

    bump:
      options:
        commitMessage: 'chore: release v%VERSION%'
        pushTo: 'upstream'

    'auto-release':
      options:
        checkTravisBuild: false

    # JSHint options
    # http://www.jshint.com/options/
    jshint:
      default:
        files:
          src: allSrc
        options: JSHINT_NODE

      options:
        quotmark: 'single'
        bitwise: true
        freeze: true
        indent: 2
        camelcase: true
        strict: true
        trailing: true
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noempty: true
        unused: true
        noarg: true
        sub: true
        undef: true
        maxdepth: 4
        maxstatements: 100
        maxcomplexity: 100
        maxlen: 100
        globals: {}

    jscs:
      default: files: src: allSrc
      options:
        config: '.jscs.json'

    simplemocha:
      options:
        ui: 'bdd'
        reporter: 'dot'
      unit:
        src: allTests

    watch:
      files: all
      tasks:['default']

    # CoffeeLint options
    # http://www.coffeelint.org/#options
    coffeelint:
      unittests: files: src: ['Gruntfile.coffee', 'test/**/*.coffee']
      options:
        max_line_length:
          value: 100

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-npm'
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-auto-release'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-jscs-checker'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'release', 'Bump the version and publish to NPM.', (type) ->
    grunt.task.run [
      'npm-contributors',
      "bump:#{type||'patch'}",
      'npm-publish'
    ]
  grunt.registerTask 'test', ['simplemocha']
  grunt.registerTask 'default', ['lint', 'test']
  grunt.registerTask 'lint', ['jshint', 'jscs', 'coffeelint']
