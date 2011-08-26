package
{
	
	
	import flash.utils.Timer
	import flash.events.TimerEvent
	import flash.display.MovieClip
		
	public class GasFlameBall extends MovieClip
	{
			
		private var timer:Timer
		
		public function GasFlameBall()
		{
			timer = new Timer(10)
			timer.addEventListener(TimerEvent.TIMER, moveFlame)
			timer.start()
		}
		
		
		public function moveFlame(event:TimerEvent)
		{
			this.x += Math.random()-.5;
			this.y -= 1;
			this.width -= .4;
			
			if (this.width<1)
			{
				timer.stop()
				timer.removeEventListener(TimerEvent.TIMER, moveFlame)
				parent.removeChild(this)
			}
		}
		
		
	}	
}