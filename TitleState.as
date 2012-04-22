package {

	import org.flixel.*;

	public class TitleState extends FlxState {
		
		[Embed(source="audio/title-screen.mp3")] private var audTitleScreen:Class;
		[Embed(source="audio/start.mp3")] private var audStart:Class;		
		[Embed(source="images/title-screen.png")] private var imgTitleScreen:Class;
		
		public var titleScreen:FlxSprite;
		public var pressSpaceBar:FlxText;
		public var pressSpaceBarBlinkTimer:Number;
		public var pressSpaceBarBlinkCount:Number;
		public var spaceBarPressed:Boolean;
		
		override public function create():void {

			titleScreen = new FlxSprite(0, 0);
			titleScreen.loadGraphic(imgTitleScreen, false, false, 256, 240);
			
			pressSpaceBar = new FlxText(0, FlxG.height - 64, FlxG.width, "Press Space Bar to Play");
			pressSpaceBar.alignment = "center";
			pressSpaceBar.color = 0xFFFFFFFF;
			pressSpaceBar.size = 8;
			pressSpaceBar.shadow = 0xFF000000;
			
			spaceBarPressed = false;
			
			pressSpaceBarBlinkTimer = 0;
			pressSpaceBarBlinkCount = 0;

			add(titleScreen);
			add(pressSpaceBar);

			FlxG.play(audTitleScreen);
		}

		override public function update():void {

			super.update();
			
			pressSpaceBarBlinkTimer += FlxG.elapsed;

			//	when Z and X are pressed for the first time, start the transition (blinking text)
			if (FlxG.keys.justPressed("SPACE")) {

				//	Stop the music
				FlxG.pauseSounds();
				//	Play the Press Start sound
				FlxG.play(audStart);
				
				//	Replace the text with "Good Curling!"
				pressSpaceBar.text = "Good Curling!";

				spaceBarPressed = true;
				pressSpaceBarBlinkTimer = 0;

			}
			
			//	Blink the text every 0.25 seconds
			if (spaceBarPressed && pressSpaceBarBlinkTimer > 0.15) {

				//	Flip the alpha to show and hide the text
				if (pressSpaceBar.alpha == 1) {
					pressSpaceBar.alpha = 0;
				} else {
					pressSpaceBar.alpha = 1;
				}

				//	Reset the timer to start again
				pressSpaceBarBlinkTimer = 0;
				//	Increment the blink count
				pressSpaceBarBlinkCount += 1;
				
			}
			
			//	When the text has blinked 8 times, start the game
			if (pressSpaceBarBlinkCount == 10) {
				
				FlxG.switchState(new PlayState());
				
			}
			
			
		}
	}
}
