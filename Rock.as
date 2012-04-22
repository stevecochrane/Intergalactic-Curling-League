package {

	import org.flixel.*;

	public class Rock extends FlxSprite {
		
		[Embed(source="images/rock-blue.png")] private var imgRockBlue:Class;
		[Embed(source="images/rock-red.png")] private var imgRockRed:Class;
		
		public var team:String;

		public function Rock(X:int, Y:int, theTeam:String) {

			super(X,Y);
			
			team = theTeam;
			
			if (team == "blue") {

/*				makeGraphic(16, 16, 0xFF0000FF);*/
				loadGraphic(imgRockBlue, true, false, 16, 16);
				
			} else if (team == "red") {

/*				makeGraphic(16, 16, 0xFFFF0000);*/
				loadGraphic(imgRockRed, true, false, 16, 16);

			}
			
			addAnimation("idle", [0], 12);
			addAnimation("roll_1", [0, 3, 2, 1], 6);
			addAnimation("roll_2", [0, 3, 2, 1], 12);
			addAnimation("roll_3", [0, 3, 2, 1], 18);
			addAnimation("roll_4", [0, 3, 2, 1], 24);

		}
		
		override public function update():void {
			
			//	If the rock is rollin' then make it look like it's rollin'
			if (velocity.y != 0 || velocity.x != 0) {
				
				if (velocity.y < -120) {
					play("roll_4");
				} else if (velocity.y < -90) {
					play("roll_3");
				} else if (velocity.y < -60) {
					play("roll_2");
				} else {
					play("roll_1");
				}

			} else {
				play("idle");
			}
			
		}
	}
}