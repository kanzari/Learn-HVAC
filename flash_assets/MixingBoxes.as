package {
	
	import flash.display.MovieClip
	import mx.flash.UIMovieClip
	
	public class MixingBoxes extends UIMovieClip
	{
		
		public function MixingBoxes()
		{
			
		}
		
		public function setDampers(dampRA:Number, dampOA:Number, dampEA:Number):void
		{
			mcViewMX.mcDamperRA.gotoAndStop(dampRA)
			mcViewMX.mcDamperOA.gotoAndStop(dampOA)
			mcViewMX.mcDamperEA.gotoAndStop(dampEA)				
			
			mcViewRF.mcDamperRA.gotoAndStop(Math.ceil(dampOA*9)+1)
			mcViewRF.mcDamperOA.gotoAndStop(Math.ceil(dampRA*9)+1)
			mcViewRF.mcDamperEA.gotoAndStop(Math.ceil(dampEA*9)+1)
			
			mcViewSYS.mcDamperRA.gotoAndStop(Math.ceil(dampOA*9)+1)
			mcViewSYS.mcDamperOA.gotoAndStop(Math.ceil(dampRA*9)+1)
			mcViewSYS.mcDamperEA.gotoAndStop(Math.ceil(dampEA*9)+1)
			
			
		}
		
		
		
	}
	
}