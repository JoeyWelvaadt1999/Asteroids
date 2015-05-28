package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LittleEnemy extends MovieClip
	{
		private var enemy:EnemyArt = new EnemyArt();
		
		private var _moveSpeedMax:Number = 3;
		private var _moveSpeedCurrent:Number = 1;
		private var _acceleration:Number = 0;
		
		private var _rotateSpeedMax:Number = 10;
		
		private var _destinationX:int;
		private var _destinationY:Number;
		
		private var _minX:Number = 0;
		private var _minY:Number = 0;
		private var _maxX:Number = 550;
		private var _maxY:Number = 400;
		
		
		private var _directionChangeProximity:Number = 5;
		private var _distance:Number;
		
		
		// global		
		private var _dx:Number = 0;
		private var _dy:Number = 0;		
		private var _vx:Number = 0;
		private var _vy:Number = 0;
		
		private var _trueRotation:Number = 0;
		
		private var xPos:Number;
		private var yPos:Number;
		
		public function LittleEnemy(enemyX, enemyY, objectiveX, objectiveY)
		{
			xPos = objectiveX;
			yPos = objectiveY;
			
			var randomSpawn:Number = Math.random();
			
			this.addChild(enemy);
			
			
			enemy.x = enemyX;
			enemy.y = enemyY;
			scaleX = 1;
			scaleY = 1;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init (e:Event):void {
			addEventListener(Event.ENTER_FRAME, Update);
			_destinationX = xPos;
			_destinationY = yPos;
			if(enemy.x < stage.stageWidth && enemy.x > 0 && enemy.y < stage.stageHeight && enemy.y > 0) {
				removeChild(enemy);
			} 
		}
		
		private function Update (e:Event):void {
			updatePosition();
			updateRotation();
			
		}
		
		public function Destroy():void {
			removeChild (enemy);
		}
		
		private function updateRotation():void
		{
			// calculate rotation
			_dx = enemy.x - _destinationX;
			_dy = enemy.y - _destinationY;
			
			// which way to rotate
			var rotateTo:Number = getDegrees(getRadians(_dx, _dy));	
			
			// keep rotation positive, between 0 and 360 degrees
			if (rotateTo > enemy.rotation + 180) rotateTo -= 360;
			if (rotateTo < enemy.rotation - 180) rotateTo += 360;
			
			// ease rotation
			_trueRotation = (rotateTo - enemy.rotation) / _rotateSpeedMax;
			
			// update rotation
			enemy.rotation += _trueRotation;
		}
		
		private function updatePosition():void
		{
			
			// get distance
			_distance = getDistance(_destinationX - enemy.x, _destinationY - enemy.y);
			
			// update speed (accelerate/slow down) based on distance
			if (_distance >= 50)
			{
				_moveSpeedCurrent += _acceleration;
				
				if (_moveSpeedCurrent > _moveSpeedMax)
				{
					_moveSpeedCurrent = _moveSpeedMax;
				}
			}
			else if (_distance < 30)
			{
				_moveSpeedCurrent *= .90;
			}
			
			// update velocity
			_vx = (_destinationX - enemy.x) / _distance * _moveSpeedCurrent;
			_vy = (_destinationY - enemy.y) / _distance * _moveSpeedCurrent;
			
			// update position
			enemy.x += _vx;
			enemy.y += _vy;
		}
		
		
		/**
		 * Get distance
		 * @param	delta_x
		 * @param	delta_y
		 * @return
		 */
		public function getDistance(delta_x:Number, delta_y:Number):Number
		{
			return Math.sqrt((delta_x*delta_x)+(delta_y*delta_y));
		}
		
		/**
		 * Get radians
		 * @param	delta_x
		 * @param	delta_y
		 * @return
		 */
		public function getRadians(delta_x:Number, delta_y:Number):Number
		{
			var r:Number = Math.atan2(delta_y, delta_x);
			
			if (delta_y < 0)
			{
				r += (2 * Math.PI);
			}
			return r;
		}
		
		/**
		 * Get degrees
		 * @param	radians
		 * @return
		 */
		public function getDegrees(radians:Number):Number
		{
			return Math.floor(radians/(Math.PI/180));
		}
		
	}
}