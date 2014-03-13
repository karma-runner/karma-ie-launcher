var fs = require('fs');
var util = require('util');
var urlparse = require('url').parse;
var urlformat = require('url').format;

var IEBrowser = function(baseBrowserDecorator, args) {
  baseBrowserDecorator(this);

  var flags = args.flags || [];

  this._getOptions = function (url) {
    var urlObj = urlparse(url, true);

    handleXUaCompatible(args, urlObj);

    delete urlObj.search; //url.format does not want search attribute
    url = urlformat(urlObj);

    return [
      '-extoff'
    ].concat(flags, [url]);
  };
};

/**
 * Handle x-ua-compatible option:
 *
 * Usage :
 *   customLaunchers: {
 *     IE9: {
 *       base: 'IE',
 *       'x-ua-compatible': 'IE=EmulateIE9'
 *     }
 *   }
 *
 * This is done by passing the option on the url, in response the Karma server will
 * set the following meta in the page.
 *   <meta http-equiv="X-UA-Compatible" content="[VALUE]"/>
 */
function handleXUaCompatible(args, urlObj) {
  if (args['x-ua-compatible']) {
    urlObj.query['x-ua-compatible'] = args['x-ua-compatible'];
  }
}

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

IEBrowser.$inject = ['baseBrowserDecorator', 'args'];


// PUBLISH DI MODULE
module.exports = {
  'launcher:IE': ['type', IEBrowser]
};
