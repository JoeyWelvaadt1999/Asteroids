package
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Bullet extends MovieClip
	{
		private var xMove:Number;
		private var yMove:Number;
		private var bullet:BulletArt = new BulletArt();
		public function Bullet()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			this.addChild(bullet);
			
		}
		private function init(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, Update);
		}
		public function calculateMovement():void
		{
			var radians:Number = this.rotation * Math.PI / 180;
			xMove = Math.cos(radians);
			yMove = Math.sin(radians);
		} 
		public function Update(e:Event):void {
			this.x += xMove * 5;
			this.y += yMove * 5;
			checkBulletPos();
		}
		
		public function Destroy():void {
			this.removeChild(bullet);
		}
		
		private function checkBulletPos():void {
			if(this.x > stage.stageWidth || this.x < 0 || this.y > stage.stageHeight || this.y < 0){
				this.removeChild(bullet);
				trace("LOL");
			}
			
		}
	}
}