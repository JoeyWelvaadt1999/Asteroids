package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PickUps extends MovieClip
	{
		public var shieldHealth:int = 3;
		public var shieldActive:Boolean = false;
		public var shield:ShieldArt = new ShieldArt();
		private var addShieldTimer:Timer = new Timer(40000, 100);
		
		private var speed:int = 1;
		public function PickUps()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			addShieldTimer.addEventListener(TimerEvent.TIMER, addShield);
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		private function Update(e:Event):void {
			if(!shieldActive) {
				addShieldTimer.start();
			} else {
				addShieldTimer.stop();
			}
			
			if(shieldHealth <= 0) {
				shieldActive = false;
				removeChild(shield);
				shieldHealth+=3;
			}
		}
		
		private function addShield(e:TimerEvent):void {
			shield.x = stage.stageWidth + 200;
			shield.y = stage.stageHeight/2;
			shield.scaleX = 0.1;
			shield.scaleY = 0.1;
			addChild(shield);
			speed = 1;
		}
		
		
		
		public function Move():void {
			shield.x -= speed;
		}
	}
}