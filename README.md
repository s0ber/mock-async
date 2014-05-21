My Library Template
=====
[![Build Status](https://travis-ci.org/s0ber/bower-template.png?branch=master)](https://travis-ci.org/s0ber/bower-template)

## Usage

### Basic preparation

Clone this repo, rename it, remove git files. Install **gulp** and **bower**, and **coffeegulp** to easily run gulp tasks with ```gulp.coffee```.

```
cd ~/my_projects
git clone git@github.com:s0ber/bower-template.git
mv bower-template my_awesome_lib
cd my_awesome_lib
rm -rf .git

npm install -g gulp
npm install -g bower
npm install -g coffeegulp
npm install
bower install
```

Edit ```package.json``` and ```bower.json``` with required data.

### Testing

Run specs in development mode (all file changes will be watched).

```
coffeegulp karma:dev
```

You can also sync your TravisCI account and turn on builds for your repo.

### Releasing

If you want to release a new version of your plugin, at first, edit associated ```package.json``` and ```bower.json``` files, then perform the following task.

```
coffeegulp release
```

It will at first run your specs. If they'll pass, concatenated compiled version of your source files will be created, and also minified one in **build/** folder.


### Modula

Modula is a very simple 15-lines packages manager. It helps you to get your code organised. It doesn't worth to make a library of it, because it's so straightforward. So, it's just included by default.

```
modula.exports('package_name', ReferenceToPackage)
modula.exports('package_name/file', ReferenceToPackageFile)

MyPackage = modula.require 'package_name'
MyPackageSourceFile = modula.require 'package_name/file'
```

### Source files

You should list your source files in ```gulpfile.coffee```, gulp will use them for building compiled version, and karma will use them for running specs.

### License

Don't forget to edit LICENSE file before the release.
