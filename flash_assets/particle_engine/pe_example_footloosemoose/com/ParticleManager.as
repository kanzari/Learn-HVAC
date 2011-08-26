package com {
	
	import flash.display.Stage;
	import com.*

	
	public class ParticleManager {
				
		static private var instance:ParticleManager;
		
		private var stage:Stage;		
		private var allParticles:Array;
		private var recycle:Array;
		

		// --** constructor **--
		public function ParticleManager(enforecer:SingletonEnforcer) {}
		
		
		public function init(stageRef:Stage):void {
			this.allParticles = [];
			this.recycle = [];			
			this.stage = stageRef;
		}
		
		
		static public function getInstance():ParticleManager {
			if (ParticleManager.instance == null) {
				ParticleManager.instance = new ParticleManager(new SingletonEnforcer());
			}
			
			return ParticleManager.instance;
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
		
	}
	
}

class SingletonEnforcer{}