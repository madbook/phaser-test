# Phlappy bird
Stupid simple clone of flappy-bird using `phaser`.  Based off of
[this tutorial][1].  [View the demo][2]

## DOM
I'm using `domo` to write out the necessary DOM.  Since I'm writing everything
in `coffeescript`, domo actually reads very nicely, and since its such a small
app it makes sense to bundle it all together.  `index.html` only loads `domo`
and the compiled version of this script.

    HTML lang: 'EN',
        HEAD {},
            TITLE "Test"
        BODY onload: 'main()',
            H1 'This is a thing!'
            DIV id: 'game_div'
            SCRIPT src: 'bower_components/phaser/phaser.js'

## Helpers and Constants
Nothing too interesting here

    BG_COLOR = '#71c5cf'
    SCORE_STYLE = font: '30px Helvetica', fill: '#ffffff'

    rand = (n) -> Math.random() * n
    floor = Math.floor

## Launching the Game
This function is referenced in the dom structure above, and launches the game.

    @main = () ->
        game = new Phaser.Game 400, 500, Phaser.AUTO, 'game_div'
        game.state.add 'main', MainState
        game.state.start 'main'

## Game State
The logic to run the game.  Note that the `preload`, `create`, and `update`
methods are used by `Phaser` automatically.

    class MainState
        preload: ->
            @game.stage.backgroundColor = BG_COLOR
            @game.load.image 'bird', 'assets/bird.png'
            @game.load.image 'pipe', 'assets/pipe.png'

        create: ->
            @bird = @game.add.sprite 100, 245, 'bird'
            @bird.body.gravity.y = 1000

            @pipes = @game.add.group()
            @pipes.createMultiple 20, 'pipe'

            @spaceKey = @game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
            @spaceKey.onDown.add @jump, this

            @timer = @game.time.events.loop 1500, @addRowOfPipes, this

            @score = 0
            @labelScore = @game.add.text 20, 20, '0', SCORE_STYLE


        update: ->
            if @bird.inWorld == false
                return @restartGame()
            @game.physics.overlap @bird, @pipes, @restartGame, null, this

        jump: ->
            @bird.body.velocity.y = -350

        addOnePipe: (x, y) ->
            pipe = @pipes.getFirstDead()
            pipe.reset x, y
            pipe.body.velocity.x = -200
            pipe.outOfBoundsKill = true

        addRowOfPipes: ->
            @score += 1
            @labelScore.content = @score

            hole = 1 + floor rand 5
            for i in [0..8]
                if i != hole and i != hole + 1
                    @addOnePipe 400, i * 60 + 10

        restartGame: ->
            @game.time.events.remove @timer
            @game.state.start 'main'

[1]: http://blog.lessmilk.com/how-to-make-flappy-bird-in-html5-1/
[2]: ../phlappy-bird.html