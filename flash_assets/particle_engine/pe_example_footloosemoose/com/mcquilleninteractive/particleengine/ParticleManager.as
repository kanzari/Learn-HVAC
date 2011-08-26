// ActionScript file


package com.mcquilleninteractive.particleengine
{
	import flash.display.Stage;
	
	public class ParticleManager 
	{
		
		//SINGLETON CODE AT BOTTOM

		private var allParticles:Array;
		private var recycle:Array;
		
		public function init(stageRef:Stage):void {
			this.allParticles = [];
			this.recycle = [];			
			this.stage = stageRef;
		}
		
		public function createParticle(howMany:int, initObject:Object):void {
			for (var i:int = 0; i < howMany; i++) {
				var pos:int = getNextSlot();				
				this.allParticles[pos] = new Particle().init(pos, initObject);			
				this.stage.addChild(this.allParticles[pos]);
			}
		}
		
		
		public function removeParticle(pid:int):void {
			this.recycle.push(pid);
		}
		
		
		private function getNextSlot():int {
			if (this.recycle.length > 0) {
				return int(this.recycle.pop());
			}
			else {
				return this.allParticles.length;
			}		
		}
		
		
		// SINGLETON CODE
		
		private static var particleManager:ParticleManager
			
		public static function getInstance():ParticleManager
		{
			if (particleManager == null)
			{
				particleManager = new ParticleManager()
			}
			return particleManager
						
		}
		
		public function ParticleManager()
		{
			if (particleManager != null)
			{
				throw new Error("Only one LHModelLocator instance should be instantiated")
			}			
		}
		
	}
		
}

