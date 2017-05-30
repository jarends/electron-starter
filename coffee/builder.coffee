Path   = require 'path'
CSpawn = require 'cross-spawn'
CWD    = Path.resolve __dirname, '..'
task   = process.argv[2] or 'run'


class Builder


    constructor: () ->
        @inDir     = Path.join CWD, 'app'
        @outDir    = Path.join CWD, 'build'
        @pkg       = require Path.join(@inDir, 'package.json')
        @name      = @pkg.name
        @version   = @pkg.version
        @eVersion  = @pkg.electron_version or '1.6.10'
        @bundleId  = 'org.netTrek.' + @name
        @electron  = Path.join CWD, 'node_modules', 'electron', 'cli.js'
        @packager  = Path.join CWD, 'node_modules', 'electron-packager', 'cli.js'
        @options   =
            stdio: 'inherit'
            cwd:   CWD


    run: () ->
        @spawn 'node', [@electron, @inDir], 'inherit'
        null


    open: () ->
        return null if process.platform != 'darwin'
        dir = @name + '-darwin-x64'
        app = @name + '.app'
        @spawn 'open', [Path.join @outDir, dir, app], 'inherit'
        null


    build: (platform, arch) ->
        args = [
            @packager
            'app'
            @name
            "--overwrite"
            "--platform="         + platform
            "--arch="             + arch
            "--electron-version=" + @eVersion
            "--app-version="      + @version
            "--app-bundle-id="    + @bundleId
            "--icon="             + Path.join @inDir, 'img/icon.icns'
            "--out="              + @outDir
        ]
        @spawn 'node', args, 'inherit'
        null


    buildMac: () ->
        @build 'darwin', 'x64'
        null


    buildWin32: () ->
        @build 'win32',  'ia32'
        null


    buildWin64: () ->
        @build 'win32',  'x64'
        null


    buildWin: () ->
        @buildWin32()
        @buildWin64()
        null


    buildAll: () ->
        @buildMac()
        @buildWin()
        null


    install: () ->
        return null if process.platform != 'darwin'
        try
            @spawn './bin/install.sh', [@name], 'inherit'
        catch e
            console.log 'error while installing the app: ', e
        null


    launch: () ->
        return null if process.platform != 'darwin'
        try
            @spawn 'killall', [@name], null
            @spawn 'killall', [@name], null
            @spawn 'open', ['/Applications/' + @name + '.app'], null
        catch e
            console.log 'error while installing the app: ', e
        null


    distribute: () ->
        return null if process.platform != 'darwin'
        @buildMac()
        @install()
        null



    spawn: (cmd, args, stdio) ->
        CSpawn cmd, args, @options




    printHelp: () ->
        console.log """usage:
run          (r)   - run app from project folder, same as: node .
open         (o)   - open app from build folder (mac only)
mac          (m)   - build for mac
win          (w)   - build win32 and win64
win32        (w32) - build win32
win64        (w64) - build win64
all          (a)   - build all platforms
install      (i)   - install and launch app from application folder (mac only)
launch       (l)   - launch app from application folder (mac only)
distribute   (d)   - build for mac, install, kill and launch (mac only)
help         (h)   - show this help text"""
        null




builder = new Builder()




switch task
    when 'run'         , 'r'   then builder.run()
    when 'open'        , 'o'   then builder.open()
    when 'install'     , 'i'   then builder.install()
    when 'launch'      , 'l'   then builder.launch()
    when 'mac'         , 'm'   then builder.buildMac()
    when 'win'         , 'w'   then builder.buildWin()
    when 'win32'       , 'w32' then builder.buildWin32()
    when 'win64'       , 'w64' then builder.buildWin64()
    when 'all'         , 'a'   then builder.buildAll()
    when 'distribute'  , 'd'   then builder.distribute()
    when 'help'        , 'h'   then builder.printHelp()
    else
        console.log "\nunknown task \"#{task}\"\n"
        builder.printHelp()