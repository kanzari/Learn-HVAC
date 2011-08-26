// ActionScript file


package com.mcquilleninteractive.particleengine
{
	import flash.display.Sprite
	
	public class ParticleManager 
	{
		
		//SINGLETON CODE AT BOTTOM

		private var allParticles:Array;
		private var recycle:Array;
		private var engineRef:Sprite
		
		public function init(engineRef:Sprite):void {
			this.allParticles = [];
			this.recycle = [];			
			this.engineRef = engineRef;
		}
		
		public function createParticle(howMany:int, initObject:Object):void {
			for (var i:int = 0; i < howMany; i++) {
				var slot:int = getNextSlot();				
				this.allParticles[slot] = new Particle().init(slot, initObject);			
				this.engineRef.addChild(this.allParticles[pos]);
			}
		}
		
		
		public function removeParticle(pid:int):void {
			this.recycle.push(pid);
		}
		
		public function removeAllParticles():void
		{
			for (var i:int = 0; i < allParticles.length)
			{
				Particle(allParticles[i]).killMe()
			}
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

