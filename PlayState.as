package {

	import org.flixel.*;
	
	public class PlayState extends FlxState {

		[Embed(source="audio/in-game.mp3")] private var audInGame:Class;
		[Embed(source="audio/rock-hit.mp3")] private var audRockHit:Class;
		[Embed(source="audio/start.mp3")] private var audStart:Class;
		[Embed(source="audio/sweep-in.mp3")] private var audSweepIn:Class;
		[Embed(source="audio/sweep-out.mp3")] private var audSweepOut:Class;
		[Embed(source="images/broom-left.png")] private var imgBroomLeft:Class;
		[Embed(source="images/broom-right.png")] private var imgBroomRight:Class;
		[Embed(source="images/house.png")] private var imgHouse:Class;
		[Embed(source="images/launch-hand.png")] private var imgLaunchHand:Class;
		[Embed(source="images/starfield-back.png")] private var imgStarfieldBack:Class;
		[Embed(source="images/starfield-front.png")] private var imgStarfieldFront:Class;
		[Embed(source="images/winning-rock.png")] private var imgWinningRock:Class;
		
		public var blueTeamRocks:FlxGroup;
		public var broomsOut:Boolean;
		public var broomLeft:FlxSprite;
		public var broomLeftStartX:Number;
		public var broomLeftStartY:Number;
		public var broomRightStartX:Number;
		public var broomRightStartY:Number;
		public var broomRight:FlxSprite;
		public var broomGroup:FlxGroup;
		public var buttonPoint:FlxPoint;
		public var closestRock:Rock;
		public var closestRockDistance:Number;
		public var camera:FlxCamera;
		public var collisionEventRegulator:Number;
		public var distanceMarker:FlxText;
		public var distanceMarkerGroup:FlxGroup;
		public var gameOver:Boolean;
		public var house:FlxSprite;
		public var launchHand:FlxSprite;
		public var launchHandStartX:Number;
		public var playerOneGo:FlxText;
		public var playerTwoGo:FlxText;
		public var redTeamRocks:FlxGroup;
		public var rock:Rock;
		public var rockBeingThrown:Boolean;
		public var rockCount:int;
		public var rockCountText:FlxText;
		public var rockDragStart:int;
		public var rockDragLow:int;
		public var rockGroup:FlxGroup;
		public var rockThrown:Boolean;
		public var rockStartPos:int;
		public var starfieldBack:FlxSprite;
		public var starfieldBackGroup:FlxGroup;
		public var starfieldFront:FlxSprite;
		public var starfieldFrontGroup:FlxGroup;
		public var sweeping:Boolean;
		public var textPersistentGroup:FlxGroup;
		public var textTemporaryGroup:FlxGroup;
		public var winningRock:FlxSprite;
		public var winningTextOne:FlxText;
		public var winningTextTwo:FlxText;
		public var winningTextThree:FlxText;

		override public function create():void {
			
			//	10 screens tall, 1 screen is 240px
			FlxG.worldBounds.height = 2400;
			FlxG.worldBounds.width = 256;
			
			house = new FlxSprite(32, 24);
			house.loadGraphic(imgHouse, false, false, 192, 192);
			
			//	X pos: 256 / 2 - 8 (horizontally centered on bottom screen)
			//	Y pos: 240 * 9 + 180 - 8 (vertically centered on bottom screen)
			rock = new Rock(120, 2332, "blue");
			rockBeingThrown = false;
			rockCount = 1;
			rockThrown = false;
			rockStartPos = 0;
			rockDragStart = 10;
			rockDragLow = 4;
			
			broomsOut = false;
			
			broomLeftStartX = 48;
			broomLeftStartY = 1920;
			broomRightStartX = 144,
			broomRightStartY = 1920;
			
			broomLeft = new FlxSprite(broomLeftStartX, broomLeftStartY);
/*			broomLeft.makeGraphic(64, 8, 0xFF00FF00);*/
			broomLeft.loadGraphic(imgBroomLeft, false, false, 64, 8);

			//	X pos = 256 - 64 - 48 (right aligned 48px from right edge of screen)
			broomRight = new FlxSprite(broomRightStartX, broomRightStartY);
/*			broomRight.makeGraphic(64, 8, 0xFF00FF00);*/
			broomRight.loadGraphic(imgBroomRight, false, false, 64, 8);
			
			broomGroup = new FlxGroup();
			blueTeamRocks = new FlxGroup();
			distanceMarkerGroup = new FlxGroup();
			redTeamRocks = new FlxGroup();
			rockGroup = new FlxGroup();
			starfieldBackGroup = new FlxGroup();
			starfieldFrontGroup = new FlxGroup();
			textPersistentGroup = new FlxGroup();
			textTemporaryGroup = new FlxGroup();

			rockGroup.add(rock);
			blueTeamRocks.add(rock);
			
			broomGroup.add(broomLeft);
			broomGroup.add(broomRight);
			
			camera = new FlxCamera(0, 0, 256, 240);
			camera.setBounds(0, 0, 256, 2400);
			camera.follow(rock);
			FlxG.addCamera(camera);
			
			rockCountText = new FlxText(6, FlxG.height - 18, 100, "Rock " + rockCount + " of 8");
			rockCountText.alignment = "left";
			rockCountText.color = 0xFFFFFFFF;
			rockCountText.scrollFactor.x = 0;
			rockCountText.scrollFactor.y = 0;
			rockCountText.size = 8;
			textPersistentGroup.add(rockCountText);
			
			playerOneGo = new FlxText(0, (2160 + FlxG.height / 2 - 13) * 2 - 107, FlxG.width, "Player 1 Go!");
			playerOneGo.alignment = "center";
			playerOneGo.color = 0xFFFFFFFF;
			playerOneGo.scrollFactor.x = 2;
			playerOneGo.scrollFactor.y = 2;
			playerOneGo.shadow = 0xFF000000;
			playerOneGo.size = 16;
			textTemporaryGroup.add(playerOneGo);
			
			playerTwoGo = new FlxText(0, (2160 + FlxG.height / 2 - 13) * 2 - 107, FlxG.width, "Player 2 Go!");
			playerTwoGo.alignment = "center";
			playerTwoGo.color = 0xFFFFFFFF;
			playerTwoGo.scrollFactor.x = 2;
			playerTwoGo.scrollFactor.y = 2;
			playerTwoGo.shadow = 0xFF000000;
			playerTwoGo.size = 16;
			
			winningRock = new FlxSprite(0, 0);
			winningRock.loadGraphic(imgWinningRock, false, false, 38, 16);
			
			//	Our starfield images are one screen tall and one screen wide,
			//	so we'll need to make copies to cover the entire playfield.
			for (var j:int = 0; j < FlxG.worldBounds.height / 240; j++) {
				starfieldBack = new FlxSprite(0, j * 240);
				starfieldBack.loadGraphic(imgStarfieldBack, false, false, 256, 240);
				starfieldBack.scrollFactor.x = 0.5;
				starfieldBack.scrollFactor.y = 0.5;
				starfieldBackGroup.add(starfieldBack);
			}
			
			for (var k:int = 0; k < FlxG.worldBounds.height / 240; k++) {
				starfieldFront = new FlxSprite(0, k * 240);
				starfieldFront.loadGraphic(imgStarfieldFront, false, false, 256, 240);
				starfieldFront.scrollFactor.x = 0.75;
				starfieldFront.scrollFactor.y = 0.75;
				starfieldFrontGroup.add(starfieldFront);
			}
			
			//	This is a point for the exact middle of the house,
			//	to be used to determine the winner
			buttonPoint = new FlxPoint(128, 120);
			
			//	Set to an impossible value so it gets overwritten on the first pass
			closestRockDistance = 99999;
			
			gameOver = false;
						
/*			FlxG.watch(camera, "x", "camera.x");
			FlxG.watch(camera, "y", "camera.y");
*/			
			launchHandStartX = FlxG.width / 2 - 8;
			
			launchHand = new FlxSprite(launchHandStartX, 2400 - 40);
			launchHand.loadGraphic(imgLaunchHand, false, false, 16, 20);
			
			for (var l:int = 1; l < 9; l++) {
				distanceMarker = new FlxText(FlxG.width - 96, FlxG.height * l + (FlxG.height / 2), 80, l + "00");
				distanceMarker.alignment = "right";
				distanceMarker.color = 0xFFFFFFFF;
				distanceMarker.size = 8;
				distanceMarkerGroup.add(distanceMarker);
			}
			
			winningTextOne = new FlxText(0, camera.y + FlxG.height - 60, FlxG.width, "Player 1 now buys space beer for player 2");
			winningTextOne.alignment = "center";
			winningTextOne.color = 0xFFFFFFFF;
			winningTextOne.shadow = 0xFF000000;
			winningTextOne.size = 8;
/*			textTemporaryGroup.add(winningTextOne);*/

			winningTextTwo = new FlxText(0, camera.y + FlxG.height - 40, FlxG.width, "Those are the rules of intergalactic curling league");
			winningTextTwo.alignment = "center";
			winningTextTwo.color = 0xFFFFFFFF;
			winningTextTwo.shadow = 0xFF000000;
			winningTextTwo.size = 8;
/*			textTemporaryGroup.add(winningTextTwo);*/
			
			winningTextThree = new FlxText(0, camera.y + FlxG.height - 20, FlxG.width, "Press space bar to play again!");
			winningTextThree.alignment = "center";
			winningTextThree.color = 0xFFFFFFFF;
			winningTextThree.shadow = 0xFF000000;
			winningTextThree.size = 8;
/*			textTemporaryGroup.add(winningTextThree);*/

			playerOneGo = new FlxText(0, (2160 + FlxG.height / 2 - 13) * 2 - 107, FlxG.width, "Player 1 Go!");
			playerOneGo.alignment = "center";
			playerOneGo.color = 0xFFFFFFFF;
			playerOneGo.scrollFactor.x = 2;
			playerOneGo.scrollFactor.y = 2;
			playerOneGo.shadow = 0xFF000000;
			playerOneGo.size = 16;
			textTemporaryGroup.add(playerOneGo);
			
			//	Start the in-game music
			FlxG.playMusic(audInGame);
			
			sweeping = false;
			
			collisionEventRegulator = 0;
			
/*			FlxG.watch(rock, "x", "rock.x");
			FlxG.watch(rock, "y", "rock.y");
*/			
			FlxG.watch(rock, "y", "rock.y");
			FlxG.watch(rock.acceleration, "y", "rock.accel.y");
			FlxG.watch(rock.drag, "y", "rock.drag.y");
			FlxG.watch(rock.maxVelocity, "y", "rock.maxVelo.y");
			FlxG.watch(rock.velocity, "x", "rock.velo.x");
			FlxG.watch(rock.velocity, "y", "rock.velo.y");
/*			FlxG.watch(this, "sweeping", "sweeping");*/
			
/*			FlxG.watch(this, "rockBeingThrown", "rockBeingThrown");*/
			
/*			FlxG.watch(broomLeft, "x", "broomLeft.x");
			FlxG.watch(broomRight, "x", "broomRight.x");
*/
/*			FlxG.watch(this, "rockStartPos", "rockStartPos");
			FlxG.watch(this, "rockThrown", "rockThrown");
			FlxG.watch(this, "broomsOut", "broomsOut");*/
			
/*			FlxG.watch(launchHand, "y", "launchHand.y");
*/
			add(starfieldBackGroup);
			add(starfieldFrontGroup);
			add(house);
			add(rockGroup);
			add(broomGroup);
			add(launchHand);
			add(distanceMarkerGroup);
			add(textPersistentGroup);
			add(textTemporaryGroup);
		}
		
		override public function update():void {
			
			super.update();
			
			FlxG.collide(rockGroup, null, rockHit);
			
			//	Have the brooms match the x position of the rock
			if (sweeping) {
				broomLeft.x = (rock.x - broomLeft.width) + 32;
				broomRight.x = (rock.x + 16) - 32;
			} else {
				broomLeft.x = rock.x - broomLeft.width;
				broomRight.x = rock.x + 16;
			}
			
			collisionEventRegulator += FlxG.elapsed;
			
			//	Horizontal movement controls
			if (FlxG.keys.LEFT) {
				
				if (rockThrown) {
					
					if (rock.velocity.y != 0) {
						
						rock.velocity.x -= 0 - rock.velocity.y / 2;
/*						rock.drag.x = 0 - rock.velocity.y * 1.5;*/
						rock.maxVelocity.x = 0 - rock.velocity.y / 2;
						
					}
				}
			}
			
			if (FlxG.keys.RIGHT) {
				
				if (rockThrown) {
					
					if (rock.velocity.y != 0) {
						
						rock.velocity.x += 0 - rock.velocity.y / 2;
/*						rock.drag.x = 0 - rock.velocity.y * 1.5;*/
						rock.maxVelocity.x = 0 - rock.velocity.y / 2;
						
					}
				}
			}
			
			if (FlxG.keys.justPressed("LEFT") && !rockThrown) {
					
				if (rockStartPos > -2) {
					//	Mark the rock as having been moved
					rockStartPos -= 1;
					//	Move the rock to the left
					rock.x -= 32;
					//	Move the brooms over to match
/*					broomLeft.x -= 32;*/
/*					broomRight.x -= 32;*/
					//	AND move the launch hand over to match
					launchHand.x -= 32;
				}
				
			}
			
			if (FlxG.keys.justPressed("RIGHT") && !rockThrown) {

				if (rockStartPos < 2) {
					//	Mark the rock as having been moved
					rockStartPos += 1;
					//	Move the rock to the right
					rock.x += 32;
					//	Move the brooms over to match
/*					broomLeft.x += 32;*/
/*					broomRight.x += 32;*/
					//	AND move the launch hand over to match
					launchHand.x += 32;
				}

			}
			
			
			if (FlxG.keys.justPressed("SPACE")) {
				
				if (gameOver) {
					
					//	Start a new game!
					FlxG.switchState(new PlayState());
				
				} else if (!rockThrown) {

					FlxG.log("rock being thrown");
					rockBeingThrown = true;
					rock.acceleration.y = -1000;
					rock.maxVelocity.y = 220;
					rock.drag.y = rockDragStart;
/*					textTemporaryGroup.clear();*/
					
					//	New stuff for horizontal movement
/*					rock.drag.x = 30;*/
				
				} else if (broomsOut && rock.velocity.y != 0) {
					
					//	Sweep the brooms to lessen drag
					FlxG.log("sweeping the brooms!");
					
/*					broomLeft.x += 32;*/
/*					broomRight.x -= 32;*/
					
					sweeping = true;
					
					rock.drag.y = rockDragLow;
					
					FlxG.play(audSweepIn);

				} else if (rockThrown && rock.velocity.y == 0 || rock.y < 0) {
					
					if (rockCount < 8) {
						//	Start a new rock
						FlxG.log("starting a new rock");
						rockCount += 1;
						rockCountText.text = "Rock " + rockCount + " of 8";
						rockStartPos = 0;
						
						launchHand.y = 2400 - 40;
						
						if (rockCount == 2 || rockCount == 4 || rockCount == 6 || rockCount == 8) {
							rock = new Rock(120, 2332, "red");
							redTeamRocks.add(rock);
							textTemporaryGroup.clear();
							textTemporaryGroup.add(playerTwoGo);
						} else {
							rock = new Rock(120, 2332, "blue");
							blueTeamRocks.add(rock);
							textTemporaryGroup.clear();
							textTemporaryGroup.add(playerOneGo);
						}
						
						rockGroup.add(rock);

/*						FlxG.watch(rock.velocity, "y", "rock.velo.y");*/
						camera.follow(rock);
						rockThrown = false;
						
						//	Bring the brooms back to their starting positions
/*						broomLeft.x = broomLeftStartX;
						broomLeft.y = broomLeftStartY;
						broomRight.x = broomRightStartX;
						broomRight.y = broomRightStartY;
*/						
						//	Bring the launch hand back to its starting position too
						launchHand.x = launchHandStartX;
						
					} else {
						FlxG.log("game over, triggering win conditions")
						//	All rocks thrown for this round, trigger win conditions
						gameOver = true;
						//	Break camera following and snap to top of field, in case the last rock
						//	didn't make it to the house.
						//	Loop through all of the rocks and check how close they are to the button
						for (var i:int = 0; i < rockGroup.members.length; i++) {
							
							FlxG.log("rock.x = " + rock.x);
							FlxG.log("rock.y = " + rock.y);
							
							//	If this rock is in play...
							if (rockGroup.members[i].y > -16 && rockGroup.members[i].x > -16 && rockGroup.members[i].x < FlxG.width) {

								//	Find the midpoint for this rock
								var rockMidpoint:FlxPoint = new FlxPoint(rockGroup.members[i].x + (rockGroup.members[i].width / 2), rockGroup.members[i].y + (rockGroup.members[i].height / 2));
								FlxG.log("rockMidpoint.x = " + rockMidpoint.x);
								FlxG.log("rockMidpoint.y = " + rockMidpoint.y);

								//	Find the distance from that midpoint to the center of the button
								var rockDistance:Number = distanceBetween(rockMidpoint, buttonPoint);
								FlxG.log("distance to button: " + rockDistance);

								//	If that is the closest distance so far, store a reference to this rock
								if (rockDistance < closestRockDistance) {
									closestRockDistance = rockDistance;
									closestRock = rockGroup.members[i];
								}
							}

						}
						//	Now that we've looped through all of the rocks, call out the closest one as the winner
						FlxG.log("the winner is: " + closestRock.team);

						//	Remove the brooms if they're still on screen
						broomLeft.alpha = 0;
						broomRight.alpha = 0;

						//	Focus the camera on the winning rock
						camera.follow(null);
						camera.focusOn(new FlxPoint(closestRock.x, closestRock.y));

						//	Place the WINNER message just above the winning rock
						winningRock.x = closestRock.x - 11;
						winningRock.y = closestRock.y - 18;
						textTemporaryGroup.add(winningRock);

						//	Add the other winning messages to the bottom half of the screen
						if (closestRock.team == "red") {
							winningTextOne.text = "Player 2 now buys space beer for player 1";
						}
						winningTextOne.y = closestRock.y + 40;
						winningTextTwo.y = closestRock.y + 56;
						winningTextThree.y = closestRock.y + 72;
						textTemporaryGroup.add(winningTextOne);
						textTemporaryGroup.add(winningTextTwo);
						textTemporaryGroup.add(winningTextThree);
						
						//	Pause the in game music
						FlxG.pauseSounds();
						
						//	Use the same sound effect as pressing start at the title screen,
						//	and hope that no one notices
						FlxG.play(audStart);
					}
				}
			}
			
			if (FlxG.keys.justReleased("SPACE")) {
				
				if (rockBeingThrown) {

					FlxG.log("rock thrown!");
					rockBeingThrown = false;
					rockThrown = true;
					
				} else if (broomsOut) {

					//	Move the brooms back when the key is released
/*					broomLeft.x -= 32;*/
/*					broomRight.x += 32;*/
					
					sweeping = false;

					rock.drag.y = rockDragLow;

					FlxG.play(audSweepOut);
				}
			}
			
			if (rock.velocity.y <= -200) {
				FlxG.log('done accelerating');
				rock.acceleration.y = 0;
			}
			
			//	If the rock is between screens 3 and 8, activate the brooms
			if (rock.y < 2080 && rock.y > 380) {
				if (!broomsOut) {
					//	bring out the brooms
					FlxG.log("bringing out the brooms");

/*					broomGroup.add(broomLeft);
					broomGroup.add(broomRight);*/
					
					broomLeft.alpha = 1;
					broomRight.alpha = 1;
					
					broomsOut = true;
				}
			} else {
/*				broomGroup.clear();*/
				
				//	Hide the brooms
				broomLeft.alpha = 0;
				broomRight.alpha = 0;
				
				broomsOut = false;
			}
			
			if (broomsOut) {
				//	If the brooms are out, match their y to the rock's y
				broomLeft.y = rock.y - 32;
				broomRight.y = rock.y - 16;
			}
			
			//	If the rock has its drag lessened by sweeping,
			//	quickly restore the drag back to how it was.
			if (rock.drag.y < rockDragStart) {
				rock.drag.y += 0.25;
			}
			
			//	While the rock is held, gradually decrease the rock's speed
			if (rockBeingThrown) {
				FlxG.log('rock being thrown');
				if (rock.velocity.y < 0) {
					FlxG.log('scaling down velocity');
					rock.velocity.y += 0.75;
				}
				
				//	Have the hand match the ball's y position
				launchHand.y = rock.y + 8;
			}
		}

		//	Called whenever two rocks collide
		public function rockHit(rock1:Rock, rock2:Rock):void {
			
			if (collisionEventRegulator > 0.5) {
			
				FlxG.log("rock hit!");

				// 	Play the sound effect
				FlxG.play(audRockHit);

				//	Compare the y positions to determine which rock is farther up,
				//	then space them apart immediately to prevent duplicate events.
				//	We want to transfer half the speed of the faster rock to the 
				//	slower rock, then stop the faster rock from moving.
//				if (rock2.velocity.y == 0) {

/*					rock2.drag.x = rockDragStart;*/

					//	Apply half of rock 1's velocity to rock 2
//					rock2.velocity.x = rock1.velocity.x / 2;
//					rock2.velocity.y = rock1.velocity.y / 2;
					//	Stop rock 1
/*					rock1.velocity.x = 0;
					rock1.velocity.y = 0;*/
					
/*					rock1.velocity.x = -200;*/
					
/*					FlxG.watch(rock2.maxVelocity, "x", "rock1.maxVelo.x");
					FlxG.watch(rock2.drag, "x", "rock1.drag.x");
					FlxG.watch(rock2.velocity, "x", "rock1.velocity.x");
*/
//				} else {

					//	Apply half of rock 1's velocity to rock 2
//					rock1.velocity.x = rock2.velocity.x / 2;
//					rock1.velocity.y = rock2.velocity.y / 2;
					//	Stop rock 1
/*					rock2.velocity.x = 0;
					rock2.velocity.y = 0;
*/
/*					rock2.velocity.x = -200;*/
					
/*					FlxG.watch(rock2.maxVelocity, "x", "rock2.maxVelo.x");
					FlxG.watch(rock2.drag, "x", "rock2.drag.x");
					FlxG.watch(rock2.velocity, "x", "rock2.velocity.x");
*/
//				}
				
/*				if (rock1.velocity.y < rock2.velocity.y) {
					rock1.velocity.y = rock2.velocity.y;
				} else {
					rock2.velocity.y = rock1.velocity.y;
				}
				
				if (rock1.velocity.x < rock2.velocity.x) {
					rock1.velocity.x = rock2.velocity.x;
				} else {
					rock2.velocity.x = rock1.velocity.x;
				}*/
				
				//	Sigh. I can't seem to identify which rock is which during a collision.
				//	There are less than 2 hours left before deadline! O_O
				//	So I've settled for some very non-realistic physics here...
				//	When two rocks collide, they are both assigned the highest of the two 
				//	values (I don't even know why this works)...
				rock1.velocity.x = rock2.velocity.x;
				rock1.velocity.y = rock2.velocity.y;
				
				//	And then both have their velocity values halved.
				rock1.velocity.x = rock1.velocity.x / 2;
				rock1.velocity.y = rock1.velocity.y / 2;
				rock2.velocity.x = rock2.velocity.x / 2;
				rock2.velocity.y = rock2.velocity.y / 2;
				
				//	This prevents the event from being called a billion times a second
				collisionEventRegulator = 0;
			}
			
		}
		
		public function distanceBetween(point1:FlxPoint, point2:FlxPoint):Number {
			var distanceX:Number = point2.x - point1.x;
			var distanceY:Number = point2.y - point1.y;
			return Math.sqrt(distanceX * distanceX + distanceY * distanceY);
		}
	}
}