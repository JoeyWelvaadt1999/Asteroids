package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;

	public class Main extends Sprite
	{
		private var objective:ObjectiveArt = new ObjectiveArt();
		
		private var chooseEnemy:Number;
		
		private var PickUpClass:PickUps = new PickUps();
		private var playerClass:Player = new Player();
		
		private var bullets:Array = new Array();
		private var enemies:Array = new Array();
		private var bigEnemies:Array = new Array();
		private var spawnPoints:Array = [];
		
		private var lives:int = 30;
		private var intervalId:uint;
		
		private var healthBar:HealthBar = new HealthBar();
		
		private var shoot:Boolean = true;

		public function Main()
		{
			stage.frameRate = 60;
			
			
			setInterval(AddDifferentEnemy, 1500);
		
			spawnPoints.push(new Point(Math.random() * stage.stageWidth, -100));
			spawnPoints.push(new Point(stage.stageWidth + 100, Math.random() * stage.stageHeight));
			spawnPoints.push(new Point(Math.random() * stage.stageWidth, stage.stageHeight + 100));
			spawnPoints.push(new Point(-100, Math.random() * stage.stageHeight));
			
			var l:int = enemies.length;			
			
			addPlayer();
			addObjective();
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEnemies();		
			
			
			healthBar.x = 10;
			healthBar.y = 10;
			addChild(healthBar);
			addChild(PickUpClass);
			
		}

		private function init(e:Event):void {
			addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, addBullets);
			
		}

		private function Update (e:Event):void {
			checkCollision();
			checkBulletPos();
			
			chooseEnemy = new Number(Math.random());
			
			if(lives == 0) {
				removeChild(objective);
			}
			
		}
		
		private function addPlayer():void {
			addChild(playerClass);
			playerClass.x = stage.stageWidth / 2;
			playerClass.y = stage.stageHeight / 2;
			playerClass.scaleX = 0.3;
			playerClass.scaleY = 0.3;			
		}
		
		private function AddDifferentEnemy():void {
			if(chooseEnemy > .5) {
				addBigEnemies();
			} else {
				addEnemies();
			}
		}
		
		private function addObjective():void {
			addChild(objective);
			objective.x = stage.stageWidth / 2;
			objective.y = stage.stageHeight / 2;
			objective.scaleX = 0.5;
			objective.scaleY = 0.5;
		}
		
		private function addBullets(e:KeyboardEvent):void {
			var bullet:Bullet = new Bullet();
			if(shoot) {
				if(e.keyCode == Keyboard.SPACE){
					bullets.push(bullet);
					bullet.scaleY = 0.1;
					bullet.scaleX = 0.2;
					bullet.x = playerClass.x;
					bullet.y = playerClass.y;
					bullet.rotationZ = playerClass.rotationZ;
					bullet.calculateMovement();
					addChild(bullet);			
				}
			}
		}

		private function addEnemies():void {
			var enemy:LittleEnemy = new LittleEnemy(spawnPoints[Math.floor(Math.random() * spawnPoints.length)].x, spawnPoints[Math.floor(Math.random() * spawnPoints.length)].y, objective.x, objective.y);
			
			addChild(enemy);
			
			enemies.push(enemy);		
	
		}
		
		private function addBigEnemies():void {
			var enemy:BigEnemy = new BigEnemy(spawnPoints[Math.floor(Math.random() * spawnPoints.length)].x, spawnPoints[Math.floor(Math.random() * spawnPoints.length)].y, objective.x, objective.y);
			
			addChild(enemy);
			
			bigEnemies.push(enemy);
		}
		
		private function checkCollision():void {
			var l:int = enemies.length;
			var l2:int = bullets.length;
			var l3:int = bigEnemies.length;
			
			for(var k:int = 0; k < l3; k++) {		
				for(var i:int = 0; i < l; i++) {
					//Objective hittest start
					if(objective.hitTestObject(enemies[i])) {
						enemies.splice(enemies[i], 1);
						enemies[i].Destroy();
						lives--;
						healthBar.scaleX = lives / 30;				
					}
					
					if (objective.hitTestObject(bigEnemies[k])) {
						bigEnemies.splice(bigEnemies[k],1);
						bigEnemies[k].Destroy();
						lives -= bigEnemies[k].bigEnemyHealth;
						healthBar.scaleX = lives / 30;
					}
					
					//Shield start
					
					if(PickUpClass.hitTestObject(enemies[i]) && PickUpClass.hitTestObject(playerClass)) {
						enemies[i].Destroy();
						PickUpClass.shieldHealth--;
					}
					
					if(PickUpClass.hitTestObject(bigEnemies[k]) && PickUpClass.hitTestObject(playerClass)) {
						bigEnemies[k].Destroy();
						PickUpClass.shieldHealth--;
					}
					
					if(!PickUpClass.hitTestObject(playerClass)) {
						PickUpClass.Move();
					}else {
						PickUpClass.shieldActive = true;
						PickUpClass.shield.x = stage.stageWidth / 2;
						PickUpClass.shield.y = stage.stageHeight / 2;
						PickUpClass.shield.scaleX = 1;
						PickUpClass.shield.scaleY = 1;
					}
					
					//Shield stop
					
					//Bullet collisionCheck start
					for(var j:int = 0; j < l2; j++) {
						if(enemies[i].hitTestObject(bullets[j])) {
							enemies[i].Destroy();
							bullets[j].Destroy();
							enemies.splice(enemies[i], 1);
							bullets.splice(bullets[j],1);
						}
						
						if(bigEnemies[k].hitTestObject(bullets[j])) {
							bigEnemies[k].bigEnemyHealth--;
							bullets[j].Destroy();
							bullets.splice(bullets[j],1);
						}
					}
					//Bullet collisionCheck stop
					
					//Check big enemy health
					if(bigEnemies[k].bigEnemyHealth <= 0) {
						bigEnemies.splice(bigEnemies[k],1);
					}
					//stop checking big enemy health
				}
			}
		}
		
		private function checkBulletPos():void {
			var l:int = bullets.length;
			for(var i:int = 0; i < l; i++) {
				if(bullets[i].x > stage.stageWidth || bullets[i].x < 0 || bullets[i].y > stage.stageHeight || bullets[i].y < 0){
					bullets.splice(bullets[i],1);
					bullets[i].Destroy();
				}
			}
		}
	}
}