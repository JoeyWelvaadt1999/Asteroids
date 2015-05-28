package
{
	import flash.display.MovieClip;

	public class HealthBar extends MovieClip
	{
		private var healthBar:HealthBarArt = new HealthBarArt();
		public function HealthBar()
		{
			addChild(healthBar);
			healthBar.scaleX = 0.2;
			healthBar.scaleY = 0.2;
		}
	}
}