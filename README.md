# karma-ie-launcher [![Build Status](https://travis-ci.org/karma-runner/karma-ie-launcher.svg?branch=master)](http://travis-ci.org/karma-runner/karma-ie-launcher)

> Launcher for Internet Explorer.

## Installation

The easiest way is to keep `karma-ie-launcher` as a devDependency in your `package.json`.
```json
{
  "devDependencies": {
    "karma": "~0.10",
    "karma-ie-launcher": "~0.1"
  }
}
```

You can simply do it by:
```bash
npm install karma-ie-launcher --save-dev
```

## Configuration
```js
// karma.conf.js
module.exports = function(config) {
  config.set({
    browsers: ['IE']
  });
};
```

You can pass list of browsers as a CLI argument too:
```bash
karma start --browsers IE
```

You can run IE in emulation mode by setting the 'x-ua-compatible' option:
```js
customLaunchers: {
  IE9: {
    base: 'IE',
    'x-ua-compatible': 'IE=EmulateIE9'
  },
  IE8: {
    base: 'IE',
    'x-ua-compatible': 'IE=EmulateIE8'
  }
}
```
See [Specifying legacy document modes] on MSDN.

### Running IE in "No add-ons mode"

Please note that since **v0.2.0** default behaviour of launching Internet Explorer has changed.
Now it runs using system-wide configuration (uses same settings as if you would run it manually) but prior to **v0.2.0** it was spawned with `-extoff` flag set explicitly, so all extensions were disabled.

If you expect the same behaviour as it was before **v0.2.0**, Karma configuration should be slightly changed:
- create new `customLauncher` configuration (`IE_no_addons` is used in an example below) with custom flags (in our case it is `-extoff` only)
- browser `IE` in `browsers` field should be replaced with your new custom launcher name
```js
  browsers: ['IE_no_addons'],
  customLaunchers: {
    IE_no_addons: {
      base:  'IE',
      flags: ['-extoff']
    }
  }
```

See [IE Command-Line Options] on MSDN.

----

For more information on Karma see the [homepage].


[homepage]: http://karma-runner.github.com
[Specifying legacy document modes]: http://msdn.microsoft.com/en-us/library/ie/jj676915(v=vs.85).aspx
[IE Command-Line Options]: https://msdn.microsoft.com/en-us/library/hh826025(v=vs.85).aspx