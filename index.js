var fs = require('fs');

var IEBrowser = function(baseBrowserDecorator, args) {
  baseBrowserDecorator(this);

  args = args || {};
  var flags = args.flags || [];

  this._getOptions = function(url) {
    return [
      '-extoff'
    ].concat(flags, [url]);
  }
};

function getInternetExplorerExe() {
    var suffix = '\\Internet Explorer\\iexplore.exe',
        prefixes = [process.env['PROGRAMW6432'], process.env['PROGRAMFILES(X86)'], process.env['PROGRAMFILES']],
        prefix, i;

    for (i = 0; i < prefixes.length; i++) {
        prefix = prefixes[i];
        if (prefix && fs.existsSync(prefix + suffix)) {
            return prefix + suffix;
        }
    }

    throw new Error("Internet Explorer not found");
}

IEBrowser.prototype = {
  name: 'IE',
  DEFAULT_CMD: {
    win32: getInternetExplorerExe()
  },
  ENV_CMD: 'IE_BIN'
};

IEBrowser.$inject = ['baseBrowserDecorator'];


// PUBLISH DI MODULE
module.exports = {
  'launcher:IE': ['type', IEBrowser]
};
