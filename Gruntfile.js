Path = require('path');


var inDir    = 'app',
    outDir   = 'build',
    cwd      = process.cwd(),
    package  = require(Path.join(cwd, inDir, 'package.json')),
    name     = package.name,
    version  = package.version,
    eVersion = package.electron_version,
    bundleId = 'netTrek.' + name,
    electron = Path.join(cwd, 'node_modules', 'electron', 'cli.js'),
    packager = Path.join(cwd, 'node_modules', 'electron-packager', 'cli.js');


var getBuildCommand = function(platform, arch)
{
    return {
        command: ("node " + packager + " . " + name
            + " --overwrite"
            + " --platform=" + platform
            + " --arch=" + arch
            + " --prune"
            + " --version=" + eVersion
            + " --app-version=" + version
            + " --app-bundle-id=" + bundleId
            + " --out=" + Path.join(cwd, outDir)).replace(/\n /g, ' '),
        options: {
            execOptions: {
                cwd: Path.join(cwd, inDir)
            }
        }
    }
};


module.exports = function(grunt)
{
    grunt.initConfig(
    {
        shell: {
            run: {
                command: 'node ' + electron + ' ' + Path.join(cwd, inDir)
            },
            'build-mac':   getBuildCommand('darwin', 'x64'),
            'build-win32': getBuildCommand('win32',  'ia32'),
            'build-win64': getBuildCommand('win32',  'x64'),
            'open-mac': {
                command: 'open ' + Path.join(cwd, outDir, name + '-darwin-x64', name + '.app')
            }
        }
    });


    grunt.loadNpmTasks('grunt-shell');


    grunt.registerTask('run',         ['shell:run']);
    grunt.registerTask('build-mac',   ['shell:build-mac']);
    grunt.registerTask('build-win32', ['shell:build-win32']);
    grunt.registerTask('build-win64', ['shell:build-win64']);
    grunt.registerTask('build-win',   ['build-win32', 'build-win64']);
    grunt.registerTask('build-all',   ['build-mac', 'build-win']);
    grunt.registerTask('open',        ['shell:open-mac']);
};
