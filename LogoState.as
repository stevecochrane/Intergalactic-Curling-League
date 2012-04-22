//	Note: this state and its images were created outside of Ludum Dare for another project, 
//	but that's allowed in the rules so be cool

package {

	import org.flixel.*;

	public class LogoState extends FlxState {

		[Embed(source="images/steve-avatar-2.png")] private var imgSteveAvatar2:Class;
		[Embed(source="images/steve-avatar-3.png")] private var imgSteveAvatar3:Class;		
		[Embed(source="images/steve-avatar-4.png")] private var imgSteveAvatar4:Class;
		
		public var bgColor:uint;
		public var currentState:String;
		public var gameBy:FlxText;
		public var gameByName:FlxText;
		public var gameByLink:FlxText;
		public var mousePosX:int;
		public var mousePosY:int;
		public var steveAvatar:FlxSprite;
		public var testers:FlxText;
		public var textColor_step2:uint;
		public var textColor_step3:uint;
		public var textColor_step4:uint;
		public var textGroup:FlxGroup;				
		public var timer:Number;
		
		override public function create():void {

			bgColor = 0xFF000000;
			currentState = "1_fadeIn_step1";
			textColor_step2 = 0xFF7C7C7C;
			textColor_step3 = 0xFFD8D8D8;
			textColor_step4 = 0xFFFCFCFC;
			textGroup = new FlxGroup();
			timer = 0;

			FlxG.bgColor = bgColor;
			
			//	Screen 2 objects
			gameBy = new FlxText(0, FlxG.height / 2 - 4, FlxG.width, "a videogame by");
			gameBy.alignment = "center";
			gameBy.color = bgColor;
			gameBy.size = 8;
			
			gameByName = new FlxText(FlxG.width / 2 - 80, FlxG.height / 2 + 6, 160, "Steve Cochrane");
			gameByName.alignment = "center";			
			gameByName.color = bgColor;
			gameByName.size = 16;
			
			gameByLink = new FlxText(FlxG.width / 2 - 80, FlxG.height / 2 + 31, 160, "http://stevecochrane.com/");
			gameByLink.alignment = "center";
			gameByLink.color = bgColor;
			gameByLink.size = 8;
			
			steveAvatar = new FlxSprite(FlxG.width / 2 - 24, 60);
			steveAvatar.makeGraphic(48, 48, 0xFF000000);

			//	Add screen 1 objects to the FlxGroup
/*			textGroup.add(gameBy);*/
			textGroup.add(gameByName);
			textGroup.add(gameByLink);
			
			//	Then add the groups to the stage.
			//	Groups are used here to easily do things to multiple pieces of text at once.
			add(textGroup);
			add(steveAvatar);
			
			FlxG.watch(this, "currentState", "currentState");
		}

		override public function update():void {
			super.update();
			
			//	Increment the timer for the following scripted events
			timer += FlxG.elapsed;
			
			//	And now the mother of all switch statements happens
			switch (currentState) {


				case "1_fadeIn_step1":
					if (timer >= 0.25) {
						textGroup.setAll("color", textColor_step2);
						steveAvatar.loadGraphic(imgSteveAvatar2, false, false, 48, 48);
						currentState = "1_fadeIn_step2";
						timer = 0;
					}
				break;


				case "1_fadeIn_step2":
					if (timer >= 0.25) {
						textGroup.setAll("color", textColor_step3);
						steveAvatar.loadGraphic(imgSteveAvatar3, false, false, 48, 48);
						currentState = "1_fadeIn_step3";
						timer = 0;
					}
				break;


				case "1_fadeIn_step3":
					if (timer >= 0.25) {
						textGroup.setAll("color", textColor_step4);
						steveAvatar.loadGraphic(imgSteveAvatar4, false, false, 48, 48);
						currentState = "1";
						timer = 0;
					}
				break;


				case "1":
					if (timer >= 3) {
						textGroup.setAll("color", textColor_step3);
						steveAvatar.loadGraphic(imgSteveAvatar3, false, false, 48, 48);						
						currentState = "1_fadeOut_step3";
						timer = 0;
					}
				break;


				case "1_fadeOut_step3":
					if (timer >= 0.25) {
						textGroup.setAll("color", textColor_step2);
						steveAvatar.loadGraphic(imgSteveAvatar2, false, false, 48, 48);
						currentState = "1_ended";
						timer = 0;
					}
				break;

				case "1_ended":
					if (timer >= 0.25) {
						textGroup.clear();
						steveAvatar.kill();
						currentState = "go_to_next";
						timer = 0;
					}
				break;

				case "go_to_next":
					if (timer >= 1) {
						FlxG.switchState(new TitleState());
					}
				break;
			}
		}
	}
}
