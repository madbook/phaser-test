
var fs = require('fs')

module.exports = function (grunt) {
    grunt.registerMultiTask('generatePages',
                            'Generate HTML pages that load compiled projects.',
                            generatePages)

    function generatePages () {
        this.files.forEach(function (file) {
            var template = '<!DOCTYPE html>\n<script src="node_modules/domo/lib/domo.js"></script>\n<script src="'+file.src[0]+'"></script>';
            grunt.file.write(file.dest, template)
            grunt.log.writeln('File '+file.dest+ ' written successfully.')
        })
    }
}