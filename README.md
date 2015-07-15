# Pierrot [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> pm2 bouncy plugin

## Installation

```bash
$ npm install pm2 bouncy pierrot --global
```

## Define pierrot.yml

Can use `$ sudo pierrot vhost` if define one or more apps in `./pierrot.yml`.

```yaml
apps:
  homepage:
    repo: https://github.com/59naga/berabou.me.git
    from: 59naga.localhost
    to: 59798
```

Start the virtual host using 80 port.

```bash
$ sudo pierrot vhost
#[PM2] Spawning PM2 daemon
#[PM2] PM2 Successfully daemonized
#process name not found
#┌──────────┬────┬──────┬───────┬────────┬─────────┬────────┬─────────────┬──────────┐
#│ App name │ id │ mode │ pid   │ status │ restart │ uptime │ memory      │ watching │
#├──────────┼────┼──────┼───────┼────────┼─────────┼────────┼─────────────┼──────────┤
#│ VHOST    │ 0  │ fork │ 85314 │ online │ 0       │ 0s     │ 29.520 MB   │ disabled │
#└──────────┴────┴──────┴───────┴────────┴─────────┴────────┴─────────────┴──────────┘
#
#successfully `vhost`.
#
#  Please fix:
#
#  $ sudo chmod -R 777 ~/.pm2
#
#  See: https://github.com/Unitech/PM2/issues/837
#
```

```bash
$ sudo chmod -R 777 ~/.pm2
```

Deploy the app in local.

```bash
$ pierrot apps
? apps homepage
? task initialize
? really Yes
# apps: git clone https://github.com/59naga/berabou.me.git homepage
# apps/homepage: npm install --production
# apps/homepage: delete and start pm2 process
# process name not found
# 
# homepage was successfully the `initialize`
# 
# ┌──────────┬────┬──────┬───────┬────────┬─────────┬────────┬─────────────┬──────────┐
# │ App name │ id │ mode │ pid   │ status │ restart │ uptime │ memory      │ watching │
# ├──────────┼────┼──────┼───────┼────────┼─────────┼────────┼─────────────┼──────────┤
# │ VHOST    │ 0  │ fork │ 85314 │ online │ 0       │ 3m     │ 29.520 MB   │ disabled │
# │ homepage │ 1  │ fork │ 85830 │ online │ 0       │ 0s     │ 34.074 MB   │ disabled │
# └──────────┴────┴──────┴───────┴────────┴─────────┴────────┴─────────────┴──────────┘
```

Becomes...

```bash
$ tree
# .
# ├── node_modules
# ├── package.json
# ├── pierrot.yml
# └── apps
#      └── homepage
#          ├── node_modules
#          ├── package.json
#          └── ...
```

And be available the `http://59naga.localhost` if Add `127.0.0.1 59naga.localhost` to `/etc/hosts`.

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/pierrot.svg
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/pierrot.svg?style=flat-square
[npm]: https://npmjs.org/package/pierrot
[travis-image]: http://img.shields.io/travis/59naga/pierrot.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/pierrot
[coveralls-image]: http://img.shields.io/coveralls/59naga/pierrot.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/pierrot?branch=master
