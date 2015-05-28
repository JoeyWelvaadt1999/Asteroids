package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;

	public class Player extends MovieClip
	{
		private var aPressed:Boolean = false;
		private var dPressed:Boolean = false;		
		private var player:PlayerArt = new PlayerArt();
		public function Player()
		{
			addChild(player);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop (e:Event):void {
			if (aPressed) {
				rotationZ -= 3;
			}
			if(dPressed) {
				rotationZ += 3;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.A) {
				aPressed = true;
			}
			
			if(e.keyCode == Keyboard.D) {
				dPressed = true;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.A) {
				aPressed = false;
			}
			
			if(e.keyCode == Keyboard.D) {
				dPressed = false;
			}
		}
	}
}