module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      index:
        files:
          'www/css/index.css': ['stylus/index.styl']
    coffee:
      eslpod:
        files:
          'www/js/eslpod.js': ['coffee/eslpod.coffee']
    jade:
      index:
        files:
          'www/index.html': ['jade/index.jade']
    watch:
      stylus:
        files: ['stylus/*.styl']
        tasks: ['stylus']
      coffee:
        files: ['coffee/*.coffee']
        tasks: ['coffee']
      jade:
        files: ['jade/*.jade']
        tasks: ['jade']

  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['stylus', 'coffee', 'jade', 'watch']

