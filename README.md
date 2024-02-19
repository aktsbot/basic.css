# basic.css

A tiny fork of Owen Versteeg's [mincss](https://mincss.com/), currently
at 844B gzipped.

Note: All credits to the creator of mincss. I'm using basic.css
for my tiny hacked up projects and thought it'd be nice if I could
clone it from GH instead of copying the files like a mad man.

## Development

```
$ git clone https://github.com/aktsbot/basic.css
$ cd basic.min.css
$ # to run in watch mode, install a tool called entr
$ ls src/*.css | entr ./build.sh
$ python3 -m http.server
$ # visit http://localhost:8000
```

Only the css files in `src` are used for making the final build.
The css files start with a number. Thats the order in which the files
are processed. For example, if you need a css style to apply for all
buttons, create a file called `25-my-buttons.css`, so that it comes
between `20-buttons.css` and `30-grid.css`.

## Taking a build

```
$ ./build.sh
$ # or to make a zip file
$ ./build.sh zip
```

## TODO:

- do a 1.0 release
- [done] bring down bundle size. the sed liners in build.sh are not up to par.
- dark mode?
