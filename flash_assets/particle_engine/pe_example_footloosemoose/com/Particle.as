package com 
{
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	public class Particle extends Shape {
		
		private var pid:int;				// particle id
		private var sideLength:Number;		// radius
		
		private var xmov:Number = 0;		// x vector
		private var ymov:Number = 0;		// y vector
		private var tempx:Number = 0;
		private var tempy:Number = 0;
		
		private var isGrowing:Boolean = (Math.random() > .5);	// grow or shrink
	
		
		// --** constructor **--
		public function Particle() {}
		
		
		public function init(pid:int, initObject:Object):Particle {
			this.pid = pid;
			// set the radius and stage position 
			this.sideLength = 2 + Math.random() * 20;
			this.x = initObject.xpos;
			this.y = initObject.ypos;
						
			// set direction and speed
			var dir:Number = (ParticleGenerator.mouseSpeed < 1) ? 0 : ParticleGenerator.mouseAngle;
			var speed:Number = Math.max(ParticleGenerator.mouseSpeed, 2);
	
			// add a little spray to the particle
			var deg:Number = dir * 0.0174532925;
			deg += -5 + Math.random() * 10;
			dir = deg * 57.2957795;	
	
			// convert to movement vectors along each axis
			this.xmov = speed * Math.cos(dir);
			this.ymov = speed * Math.sin(dir);
			
			// listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED, onRemoved);
			
			// render to screen
			draw();
							
			return this;
		}
		
		
		private function onRemoved(event:Event):void {
			// clean up listeners
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED, onRemoved);			
		}
		
		
		private function onEnterFrame(event:Event):void {
			this.tempx = this.x;
			this.tempy = this.y;
			
			this.tempx += this.xmov;
			this.tempy += this.ymov;
			
			this.ymov += ParticleGenerator.gravity;
			
			// if scale or alpha <= 0 then kill, else update position
			if (!grow() || !checkForWalls()) {
				killMe();
			}
			else {
				this.x = this.tempx;
				this.y = this.tempy;				
			}	
		}
		
		
		private function grow():Boolean {
			// return true if still on
			
			// update scale
			this.scaleX = this.scaleY += (this.isGrowing) ? .02 : -.02;
			// update alpha
			this.alpha -= .02;
			
			return (this.alpha > 0 && this.scaleX > 0);
		}
		
		
		private function checkForWalls():Boolean {
			// return true if still on
			
			// top
			if (this.tempy + this.sideLength < 0 || 
			// bottom
			this.tempy - this.sideLength > stage.stageHeight || 
			// left
			this.tempx + this.sideLength < 0 ||
			// right
			this.tempx - this.sideLength > stage.stageWidth) {
				return false;
			}
			else {
				return true;
			}
		}
		
		
		private function killMe():void {
			ParticleManager.getInstance().removeParticle(this.pid);
			stage.removeChild(this);
		}
		
		
		private function draw():void {
			graphics.beginFill(Math.random() * 0xff0000);
			graphics.drawCircle(0, 0, this.sideLength);
			graphics.endFill();
		}
		
		
		override public function toString():String {
			return "[Particle]";
		}
		
	}
}