JSHINT_NODE =
  node: true,
  strict: false

module.exports = (grunt) ->

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
          src: ['index.js']
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
      default: files: src:  ['index.js']
      options:
        config: '.jscs.json'

  grunt.loadNpmTasks 'grunt-npm'
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-auto-release'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-jscs-checker'

  grunt.registerTask 'release', 'Bump the version and publish to NPM.', (type) ->
    grunt.task.run [
      'npm-contributors',
      "bump:#{type||'patch'}",
      'npm-publish'
    ]
  grunt.registerTask 'default', ['lint']
  grunt.registerTask 'lint', ['jshint', 'jscs']
