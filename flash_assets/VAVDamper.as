package {
	
	import flash.display.MovieClip
	import mx.flash.UIMovieClip
	
	public class VAVDamper extends UIMovieClip
	{
		
		public function VAVDamper():void
		{
			
		}
		
		public function setVAVDamper(setting:Number):void
		{
			if (setting<0) setting = 0
			if (setting>100) setting = 100
			mcVAVDamper.gotoAndStop(Math.round(setting/10))
		}
			
		
	}
	
}