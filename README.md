phaser-test
===========

Me playing around with phaser.

Each file in `src/*.coffee.md` is a single-page app written in
_literate coffeescript_. Running the default `grunt` task will compile
`*.html` and `lib/*.js` to run the app _and_ compile the markdown copy into
`docs/*.html`.  I'm using `domo` to write any necessary markup or styles
within the coffescript source, and as the repo name implies, I'm using the
`phaser` library.