module.exports = (grunt) ->

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-markdown'
    grunt.loadTasks 'tasks'

    grunt.initConfig
        watch:
            coffee:
                files: ['src/*.coffee', 'src/*.coffee.md']
                tasks: ['coffee', 'markdown']

        coffee:
            glob_to_multiple:
                expand: true
                flatten: true
                src: ['src/*.coffee', 'src/*.coffee.md']
                dest: 'lib/'
                ext: '.js'

        markdown:
            all:
                files: [
                    expand: true
                    flatten: true
                    src: 'src/*.md'
                    dest: 'docs/'
                    ext: '.html'
                ]

        generatePages:
            all:
                expand: true
                flatten: true
                src: 'lib/*.js'
                dest: './'
                ext: '.html'

    grunt.registerTask 'default', ['coffee', 'markdown', 'generatePages']