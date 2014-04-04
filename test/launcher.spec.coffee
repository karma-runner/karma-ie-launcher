util = require 'util'
di = require 'di'
mocks = require 'mocks'
fs = require 'fs'

describe 'launcher', ->
  injector = null
  launcher = null
  module = null
  IELauncher = null
  EventEmitter = null

  beforeEach ->
    EventEmitter = require('../node_modules/karma/lib/events').EventEmitter
    IELauncher = mocks.loadFile(__dirname + '/../index').module.exports
    module = {
      'baseBrowserDecorator': ['value', (->)],
      'emitter': ['value', new EventEmitter]
      'logger': ['value', {
        create : ->
          return {
            error : (->),
            debug : (->)
          }
        }]
      'args': ['value', []]
    }

  afterEach ->
    injector = null
    launcher = null

  describe 'exports', ->
    it 'should export launcher:IE', (done) ->
      expect(IELauncher['launcher:IE']).to.defined
      done()

  describe 'initialization', ->

    beforeEach ->
      injector = new di.Injector([module, IELauncher])
      launcher = injector.get('launcher:IE')

    it 'should initialize name', (done) ->
      expect(launcher.name).to.equal "IE"
      done()

    it 'should initialize ENV_CMD', (done) ->
      expect(launcher.ENV_CMD).to.equal "IE_BIN"
      done()

    it 'should initialize DEFAULT_CMD.win32', (done) ->
      expect(launcher.DEFAULT_CMD.win32).to.beDefined
      done()

  describe '_getOptions', ->

    getOptions = null

    beforeEach ->
      getOptions = (url, module) ->
        injector = new di.Injector([module, IELauncher])
        launcher = injector.get('launcher:IE')
        launcher._getOptions('url')

    it 'should add -extoff', (done) ->
      options = getOptions('url', module)
      expect(options[0]).to.equal '-extoff'
      done()

    it 'should include args.flags', (done) ->
      module.args[1] = {flags: ['-flag1', '-flag2']}
      options = getOptions('url', module)
      expect(options[1]).to.equal '-flag1'
      expect(options[2]).to.equal '-flag2'
      done()

    it 'should return url as the last flag', (done) ->
      options = getOptions('url', module)
      expect(options[options.length-1]).to.equal 'url'
      done()

    it 'should convert x-ua-compatible arg to encoded url', (done) ->
      module.args[1] = {'x-ua-compatible':'browser=mode'}
      options = getOptions('url', module)
      expect(options[options.length-1]).to.equal 'url?x-ua-compatible=browser%3Dmode'
      done()

  describe 'locating iexplore.exe', ->

    win32Location = null
    fsMock = null

    beforeEach ->
      process.env['' + 'PROGRAMW6432'] = '\\fake\\PROGRAMW6432'
      process.env['' + 'PROGRAMFILES(X86)'] = '\\fake\\PROGRAMFILES(X86)'
      process.env['' + 'PROGRAMFILES'] = '\\fake\\PROGRAMFILES'

      fsMock = mocks.fs.create
        'folder1':
          'Internet Explorer':
            'iexplore.exe' : 1

      IELauncher = mocks.loadFile(__dirname + '/../index', {
        fs:fsMock
      }).module.exports

      win32Location = () ->
        injector = new di.Injector([module, IELauncher])
        launcher = injector.get('launcher:IE')
        launcher._getInternetExplorerExe()

    it 'should locate in PROGRAMW6432', (done) ->
      process.env['' + 'PROGRAMW6432'] = '\\folder1'
      expect(win32Location()).to.equal '\\folder1\\Internet Explorer\\iexplore.exe'
      done()

    it 'should locate in PROGRAMFILES(X86)', (done) ->
      process.env['' + 'PROGRAMFILES(X86)'] = '\\folder1'
      expect(win32Location()).to.equal '\\folder1\\Internet Explorer\\iexplore.exe'
      done()

    it 'should locate in PROGRAMFILES', (done) ->
      process.env['' + 'PROGRAMFILES'] = '\\folder1'
      expect(win32Location()).to.equal '\\folder1\\Internet Explorer\\iexplore.exe'
      done()

    it 'should return undefined when not found', (done) ->
      expect(win32Location()).to.equal undefined
      done()

  describe '_onProcessExit', ->

    onProcessExit = null
    child_processCmd = null

    beforeEach ->
      onProcessExit = () ->

        child_processMock = {
          exec : (cmd, cb)->
            child_processCmd = cmd
            cb()
        }

        IELauncher = mocks.loadFile(__dirname + '/../index', {
          child_process:child_processMock
        }).module.exports

        injector = new di.Injector([module, IELauncher])
        launcher = injector.get('launcher:IE')
        launcher._process = { pid : 10 }
        launcher._onProcessExit(1, 2)

    it 'should call wmic with process ID', (done) ->
      onProcessExit()
      expect(child_processCmd).to.equal 'wmic.exe Path win32_Process where ' +
        '\"Name=\'iexplore.exe\' and CommandLine Like \'%SCODEF:10%\'\" call Terminate'
      done()
