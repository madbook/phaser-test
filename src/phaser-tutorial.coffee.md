# Phaser Tutorial

Simple phaser game from [this tutorial][1]. [Back to the demo!][2].

First, I'm building the dom out with `domo`, which is _not_ a part of the
tutorial, but is super useful.

    HTML lang: 'EN',
        HEAD {},
            TITLE "Phaser Tutorial"
        BODY onload: 'main()',
            H1 'Phaser Tutorial!'
            A {href:'docs/phaser-tutorial.html'}, 'Read the source'
            SCRIPT src: 'bower_components/phaser/phaser.js'

## Constants

Here I'll define a couple of constants.  Nothing fancy.

    game = null
    SCORE_STYLE =
        font: '32px arial'
        fill: '#000'

## Launching the game

The game gets instantiated by `window.main`, as referenced in the DOM markup
above.

    @main = () ->
        game = new Phaser.Game 800, 600, Phaser.AUTO
        game.state.add 'main', MainState
        game.state.start 'main'

## Game state

Although you can apparently just pass an object to `Phaser.Game`, I prefer to
use the state system as it makes for cleaner code, and would easily let me add
a title screen or some such thing.

    class MainState

### Preloading

The state system gives you a nice preload function to throw all of your asset
requirements in, and a handy `load` method for doing just that.

        preload: () ->
            game.load.image 'sky', 'assets/sky.png'
            game.load.image 'ground', 'assets/platform.png'
            game.load.image 'star', 'assets/star.png'
            game.load.spritesheet 'dude', 'assets/dude.png', 32, 48

### Creation

The bulk of the work is done here to set up the level.  I think this is probably
the "dirtiest" part of the code, but the demo is just that so no big deal.

        create: () ->

            game.add.sprite 0, 0, 'sky'

            @platforms = game.add.group()
            ground = @platforms.create 0, game.world.height - 64, 'ground'
            ground.scale.setTo 2, 2
            ground.body.immovable = true

            ledge = @platforms.create 400, 400, 'ground'
            ledge.body.immovable = true

            ledge2 = @platforms.create -150, 250, 'ground'
            ledge2.body.immovable = true

            @player = game.add.sprite 32, game.world.height - 150, 'dude'
            @player.body.bounce.y = 0.2
            @player.body.gravity.y = 400
            @player.body.collideWorldBounds = true

            @player.animations.add 'left', [0, 1, 2, 3], 10, true
            @player.animations.add 'right', [5, 6, 7, 8], 10, true

            @cursors = game.input.keyboard.createCursorKeys()

            @score = 0
            @scoreText = game.add.text 16, 16, 'score: 0', SCORE_STYLE

            @stars = game.add.group()
            for i in [0..12]
                star = @stars.create i * 70, 0, 'star'
                star.body.gravity.y = 1000
                star.body.bounce.y = 0.2 + Math.random() * 2

### Update Loop

All of the built-in physics calculations from phaser are called here for
collision checking, as well as handling input to update the `player` object.

        update: () ->
            game.physics.collide @player, @platforms
            game.physics.collide @stars, @platforms
            game.physics.overlap @player, @stars, @collectStar, null, this

            @player.body.velocity.x = 0

            if @cursors.left.isDown
                @player.body.velocity.x = -150
                @player.animations.play 'left'
            else if @cursors.right.isDown
                @player.body.velocity.x = 150
                @player.animations.play 'right'
            else
                @player.animations.stop()
                @player.frame = 4

            if @cursors.up.isDown and @player.body.touching.down
                @player.body.velocity.y = -350

### Collecting Stars

This function doesn't _really_ need to be a method of the game state, but I
put it here for consistency.  The only thing it does is destroy the star
instance and increment the score.

        collectStar: (player, star) ->
            star.kill()
            @score += 10
            @scoreText.content = 'Score: ' + @score

[1]: http://www.photonstorm.com/phaser/tutorial-making-your-first-phaser-game
[2]: ../phaser-tutorial.html