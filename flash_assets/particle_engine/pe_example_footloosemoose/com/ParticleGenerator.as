package com {
		
	import flash.display.Sprite;	
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.*

	
	[SWF(width="440", height="440", backgroundColor="0xFFFFFF", frameRate="31")]


	public class ParticleGenerator extends Sprite {
		
		private var mouseIsDown:Boolean = false;
		
		private var mousex:int;
		private var mousey:int;
		
		public static var mouseSpeed:Number = 0;
		public static var mouseAngle:Number = 0;
		public static var gravity:int = 1;
		
		
		// --** constructor **--
		public function ParticleGenerator() {
			//init();
		}
		
		
		public function init():void {
			ParticleManager.getInstance().init(stage);
			
			stage.addEventListener(Event.ENTER_FRAME, spawn);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);		
		}
		
		

		public function spawn(event:Event):void {	
			ParticleGenerator.mouseSpeed = distBetweenTwoPoints(stage.mouseX, stage.mouseY, this.mousex, this.mousey)/2;
			ParticleGenerator.mouseAngle = anglePointAPointB(stage.mouseX, stage.mouseY, this.mousex, this.mousey);
			
			this.mousex = stage.mouseX;
			this.mousey = stage.mouseY;	
			
			if (this.mouseIsDown) {								
				// make the particle
				ParticleManager.getInstance().createParticle(5, {xpos:this.mousex, ypos:this.mousey});	
			}
			
		}
		
		
		private function mouseDown(event:MouseEvent):void {
			this.mouseIsDown = true;
			Mouse.hide();
		}
		
		
		private function mouseUp(event:MouseEvent):void {
			this.mouseIsDown = false;
			Mouse.show();
		}
		
		
		private function distBetweenTwoPoints(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			// returns the distance in pixels between x1.y1 and x2,y2
			var xDiff:Number = x2 - x1;
			var yDiff:Number = y2 - y1;
			return (Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2)));
		}
	
	
		private function anglePointAPointB(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			// returns the angle in radians from point A to point B
			return Math.atan2((y1 - y2), (x1 - x2));
		}		
		
	}
	

}
