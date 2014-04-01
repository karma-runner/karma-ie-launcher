# karma-ie-launcher

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

----

For more information on Karma see the [homepage].


[homepage]: http://karma-runner.github.com
[Specifying legacy document modes]: http://msdn.microsoft.com/en-us/library/ie/jj676915(v=vs.85).aspx