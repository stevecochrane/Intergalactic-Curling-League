package {

	import org.flixel.*;

	[SWF(width="512", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class IntergalacticCurlingLeague extends FlxGame {

		public function IntergalacticCurlingLeague():void {
			FlxG.debug = true;
			super(256, 240, LogoState, 2);
		}

	}
}