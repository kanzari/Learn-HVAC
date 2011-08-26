package com.mcquilleninteractive.particleengine
{
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import com.mcquilleninteractive.particleengine.ParticleManager
		
	public class Particle extends Shape
	{
		
		public var pid:Number
		public var goalGravity:Array
		public var goalNearRadius:Array
		public var goalHead:Array
		public var goalTail:Array
		public var dieOnThisStep:Array
		public var goalFuzzyRadius:Array
		public var goalProbability:Array
		public var goalPositionX:Array
		public var goalPositionY:Array
		public var goalDriftStep:Array
		
		public var slicenow:Number
		public var slicemax:Number
		
		public var deltax:Number
		public var deltay:Number
		public var targetx:Number
		public var targety:Number
		public var distance:Number
		public var vx:Number
		public var vy:Number
		
		public var angle:Number
		public var bColorChange:Boolean = false
		public var bSizeChange:Boolean = false
	
		public var myColorTransform:ColorTransform
		
		public var newGoal:Number
		public var colorr:Number
		public var colorg:Number
		public var colorb:Number
		public var rdelta:Number
		public var gdelta:Number
		public var bdelta:Number
		public var alphadelta:Number
		public var alphasteps:Number
		public var colorsteps:Number
		public var decay:Number
		public var driftcount:Number
		public var goal:Number
		public var sizedelta:Number
		
		public var driftsteps:Number = 10
		
	
		public function Particle() {}
		
		public function init(pid:int, initObj:Object):Particle {
			
			this.pid = pid;
			
			// set the radius and stage position 
			this.radius = 2 + Math.random() * 20;
			this.x = initObject.xpos;
			this.y = initObject.ypos;
						
			// listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED, onRemoved);
			
			// instructions
			this.goalGravity = initObj.goalGravity
			this.goalNearRadius = initObj.goalNearRadius
			this.goalTail = initObj.goalTail
			this.dieOnThisStep = initObj.dieOnThisStep
			this.goalFuzzyRadius = initObj.goalFuzzyRadius
			this.goalProbability = initObj.goalProbability
			this.goalPositionX = initObj.goalPositionX
			this.goalPositionY = initObj.goalPositionY
			this.goalDriftStep = initObj.goalDriftStep
			
			
			// render to screen
			draw();
							
			return this;
		}
		
		private function killMe():void {
			ParticleManager.getInstance().removeParticle(this.pid);
			stage.removeChild(this);
		}
				
		private function onRemoved(event:Event):void {
			// clean up listeners
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED, onRemoved);			
		}
		
		
		private function draw():void {
			graphics.beginFill(0xff0000);
			graphics.drawCircle(0, 0, this.radius);
			graphics.endFill();
		}
	 	
		public function onEnterFrame(event:Event):void
		{
				deltax = this.targetx - this.x;
				deltay = this.targety - this.y
				
				distance = Math.sqrt( Math.pow(deltax, 2) + Math.pow(deltay, 2) );
				
				this.vx += deltax / distance;
				this.vy += deltay / distance;
			
				this.vx = this.vx / goalGravity[this.goal];
				this.vy = this.vy / goalGravity[this.goal];
						
				if (distance < goalNearRadius[this.goal])
				{
					if (dieOnThisStep[this.goal]>0)
					{	
						killMe()
					}
					
					if (Math.random() > goalProbability[this.goal])
					{
						newGoal = goalHeadGoal[this.goal];	
					}
					else
					{
						newGoal = goalTailGoal[this.goal];
					}
					
					angle = Math.random() * (2 * Math.PI);
					distance = Math.random() * (goalFuzzyRadius[this.goal] - 1);
						
					this.targetx = goalPositionX[newGoal] + (distance * Math.cos(angle));
					this.targety = goalPositionY[newGoal] + (distance * Math.sin(angle));
						
					// color steps only if asked for
					//if (bColorChange)
					//{
						//this.rdelta = (PE.goalColorR[this.goal] - this.colorr) / PE.goalColorStep[this.goal];
						//this.gdelta = (PE.goalColorG[this.goal] - this.colorg) / PE.goalColorStep[this.goal];
						//this.bdelta = (PE.goalColorB[this.goal] - this.colorb) / PE.goalColorStep[this.goal];
						//this.colorsteps = PE.goalColorStep[this.goal];
					//}
					
					// assign drift
					//this.driftsteps = goalDriftStep[this.goal];
					this.driftcount = 0;
					
					// assign timeslice
					//this.slicemax = goalTimeSlice[this.goal];
		
					this.goal = newGoal;
				
			}
			
			
			this.x += this.vx / this.slicemax; 
			this.y += this.vy / this.slicemax;
			
			// Do color steps only if asked for 
			//if (bColorChange)
			//{
				//if (this.colorsteps > 0)
				//{
					//colorr += rdelta;
					//colorg += gdelta;
					//colorb += bdelta;
				
					//this.transform.colorTransform = new ColorTransform(0,colorr,0,colorg,0,colorb);
					//colorsteps--;
				//}
			//}	
			
			// Do Size Steps only if asked for
			/*
			if (bSizeChange)
			{
				if (this.sizesteps > 0)
				{
					this.width += this.sizedelta;
					this.height += this.sizedelta;
				
					this.sizesteps--;
				}
			}
			*/		
			
			if (this.driftcount > this.driftsteps)
			{
				angle = Math.random() * (2 * Math.PI);
				distance = Math.random() * (goalFuzzyRadius[this.goal] - 1);
						
				this.targetx = goalPositionX[this.goal] + (distance * Math.cos(angle));
				this.targety = goalPositionY[this.goal] + (distance * Math.sin(angle));
				
				this.driftcount = 0;
			}
			
			this.driftcount++;
		}
	 
	 
		private function checkForWalls():Boolean {
			// return true if still on
			
			// top
			if (this.y + this.radius < 0 || 
			// bottom
			this.y - this.radius > stage.stageHeight || 
			// left
			this.x + this.radius < 0 ||
			// right
			this.x - this.radius > stage.stageWidth) {
				return false;
			}
			else {
				return true;
			}
		}
		
	 
	}
}