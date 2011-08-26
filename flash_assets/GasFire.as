
package {
	
	import flash.utils.Timer
	import flash.events.TimerEvent
	import flash.display.MovieClip;
		
	public class GasFire extends MovieClip
	{
				
		public var flameHolder:MovieClip
		public var flameTimer:Timer
		
		public function GasFire()
		{
			trace("GasFire: created")
			flameHolder = new MovieClip()
			flameHolder.addChild(new GasFlameBall())
			addChild(flameHolder)
			flameTimer = new Timer(125)
			flameTimer.addEventListener(TimerEvent.TIMER, onFlameTimer)
			flameTimer.start()
		}
		
		public function onFlameTimer(event:TimerEvent)
		{
			var newFlame:MovieClip = new GasFlameBall()
			newFlame.y = -10
			flameHolder.addChild(newFlame)
		}
				
	}
}