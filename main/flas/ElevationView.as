﻿
package{
	
	import mx.flash.UIMovieClip
	import flash.display.Shape
	import flash.display.MovieClip
	import flash.display.Sprite
	import flash.geom.ColorTransform
	import flash.events.Event    
	import flash.display.StageAlign
    import flash.display.StageScaleMode
	import flash.geom.Point
	import flash.events.MouseEvent

	public class ElevationView extends UIMovieClip
	{
		protected var floorHighlightTrans:ColorTransform
		protected var floorNormalTrans:ColorTransform
		protected var currFloorHighlightIndex:Number = 0
		protected var currBldgWidth:Number = 100
		protected var currStories:Number = 3
		protected var currStoryHeight:Number = 12
		protected var currWindowStyle:String = WINDOW_STYLE_STRIP
		protected var currWindowRatio:Number = .5
		protected var stageWidth:Number //keep track of width within Flex env
		protected var stageHeight:Number //keep track of height within Flex env
		protected var bldgColor1:Number = 0xE1E1E1
		protected var bldgColor2:Number = 0xDAD1CC
		protected var floorsArr:Array	
		
		public static var WINDOW_STYLE_PUNCH:String = "punch"
		public static var WINDOW_STYLE_STRIP:String = "strip"
		
		
		public function ElevationView()
		{
			//addEventListener("addedToStage", onAddedToStage); 
			floorsArr = []
			
		}
		
		
		public function onAddedToStage(event:Event):void
		{
			trace('ElevationView.onAddedToStage');
			
			//stage.addEventListener(Event.RESIZE, resizeHandler)  //for testing in CS3
			stage.scaleMode = StageScaleMode.NO_SCALE
            stage.align = StageAlign.TOP_LEFT
			currWindowStyle = ElevationView.WINDOW_STYLE_STRIP
			setComponentSize(250,250)
			setFloorOfInterest(1)
			//this.addEventListener(MouseEvent.CLICK, onClick)
		}
		
		public function onClick(event:MouseEvent):void
		{
			var floorNumber:uint = currFloorHighlightIndex+ 1
			var newFloor:Number = floorNumber + 1
			if (newFloor>3) newFloor = 1
		 	this.setFloorOfInterest(newFloor)
		}
		
		public function resizeHandler(event:Event)
		{
			stageWidth = stage.stageWidth
			stageHeight = stage.stageHeight
			//setComponentSize (stageWidth, stageHeight)
		}
		
		public function setComponentSize(w:Number, h:Number):void
		{

			trace('ElevationView.setComponentSize');
			
			//sky background
			mcBG.width = w
			mcBG.height = h
			
			//grass
			mcGrass.width = w
			mcGrass.y = h-25
			
			//trees
			mcTreeRight.x = w - 15
			
			//building
			mcBldg.y = mcGrass.y
			mcBldg.x = uint(w/2) - uint(mcBldg.width/2)
			
			stageWidth = w
			stageHeight = h
			drawFloors(currBldgWidth, currStories, currStoryHeight, currWindowRatio, currWindowStyle)
		}
		
		
		public function setFloorOfInterest(floorNumber:Number):void
		{
			if (floorNumber < 1) floorNumber = 1
			if (floorNumber > floorsArr.length) floorNumber = floorsArr.length
						
			//clear old highlight
			var floor:Sprite = floorsArr[floorNumber]
			if (!isNaN(currFloorHighlightIndex))
			{
				Sprite(floorsArr[currFloorHighlightIndex]).getChildAt(1).transform.colorTransform =  new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0)
			}
			
			//drop down to 0 index for array
			currFloorHighlightIndex = floorNumber - 1
			
			Sprite(floorsArr[currFloorHighlightIndex]).getChildAt(1).transform.colorTransform = new ColorTransform(1, 1, .5, 1, 255, 255, 102, 0) 
			
			for (var i:uint=0;i<floorsArr.length;i++)
			{
				floorsArr[i].getChildAt(0).visible = false				
			}
			floorsArr[currFloorHighlightIndex].getChildAt(0).visible = true
				
		}
		
		
		
		public function setWindowRatio(ratio:Number):void
		{
			if (ratio<0) ratio = 0
			if (ratio>1) ratio = 1
			currWindowRatio = ratio
			drawFloors(currBldgWidth, currStories, currStoryHeight, currWindowRatio, currWindowStyle)
		}
		
		public function setWindowStyle(style:String)
		{
			if (style != ElevationView.WINDOW_STYLE_PUNCH && style != ElevationView.WINDOW_STYLE_STRIP)
			{
				return
			}
			currWindowStyle = style
			drawFloors(currBldgWidth, currStories, currStoryHeight, currWindowRatio, currWindowStyle)		
		}
		
		public function drawFloors(bldgWidth:Number, stories:Number, storyHeight:Number, windowRatio:Number, windowStyle:String=""):void
		{
			trace('ElevationView.drawFloors');
			trace("!!drawing width: " + bldgWidth + " stories: " + stories + " storyHeight: " + storyHeight)
			if (windowStyle=="") windowStyle == this.currWindowStyle
			
			var totalHeight:Number = stories*storyHeight
			
			var availWidth:Number = stageWidth * .6
			var availHeight:Number = stageHeight * .6
			
			//clear out old graphics and children
			mcBldg.graphics.clear()
			while (mcBldg.numChildren>0)
			{
				mcBldg.removeChildAt(0)
			}
			
			mcBldg.scaleX = 1
			mcBldg.scaleY = 1
			mcTreeLeft.scaleX = mcTreeRight.scaleX = 1
			mcTreeLeft.scaleY = mcTreeRight.scaleY = 1
			
			floorsArr=[]
			var fillColor:Number //holds alternating floor color
			
			var windowSections:Number = uint(bldgWidth/10)
			
			//draw floors
			for (var f:Number=0; f<stories; f++)
			{
				if (fillColor == bldgColor1) 
				{
					fillColor = bldgColor2
				}
				else
				{
					fillColor = bldgColor1
				}
				//draw building
				
				
				var floor:Sprite = new Sprite()
				//add FloorMarker first
				var floorMarker:FloorMarker = new FloorMarker()
				floor.addChild(floorMarker)
				floorMarker.x = -12
				floorMarker.y = 3
				floorMarker.visible = false
				
				var wall:Sprite = new Sprite()
				floor.addChild(wall)
				wall.graphics.beginFill(fillColor, 1)
				wall.graphics.lineStyle(0,0xE1E1E1)
				wall.graphics.moveTo(0,0)
				wall.graphics.lineTo(bldgWidth, 0)
				wall.graphics.lineTo(bldgWidth, -storyHeight)
				wall.graphics.lineTo(0, -storyHeight)
				wall.graphics.lineTo(0,0)
				wall.graphics.endFill()
				floor.y = -(f*storyHeight)
				
				
				for (var w:Number = 0; w< windowSections; w++)
				{
					//punch window
					
					var window:Sprite = new WindowShape()
					if (windowStyle == ElevationView.WINDOW_STYLE_PUNCH)
					{
						
						floor.addChild(window)
						if (windowRatio == 1)
						{
							window.height = storyHeight
						} 
						else 
						{
							var area:Number = storyHeight * 10 * windowRatio
							window.height = storyHeight
							window.width = (Math.sqrt(area*10/storyHeight)) 
							window.height = (Math.sqrt(area*storyHeight/10)) 
							
						}
						window.x = 5 + w*10
						window.y = -storyHeight/2
						
					}
					else
					{
						//var window:Sprite = new WindowShape()
						floor.addChild(window)
						if (windowRatio == 1){
							window.height = storyHeight
						} 
						else 
						{
							window.height = storyHeight * windowRatio
							window.y = storyHeight/2
							
						}
						window.x = 5 + w*10
						window.y = -storyHeight/2
						
					}
				}
				
				mcBldg.addChild(floor)
				floorsArr.push(floor)
				//floor.x = -(f*storyHeight)
				
				
			}
			
			//resize bldg to fit
			var scaleFactor:Number = availWidth/bldgWidth
			var hScaleFactor:Number = availHeight/totalHeight
			if (scaleFactor > hScaleFactor) scaleFactor = hScaleFactor
			
			mcBldg.scaleX = mcBldg.scaleY = scaleFactor
						
			//recenter
			trace(" stageWidth: " + stageWidth + " bldg width: " + mcBldg.width)
			mcBldg.x = (stageWidth/2) - (mcBldg.width/2.5 )
			
			//scale and position trees
			mcTreeLeft.scaleX = mcTreeLeft.scaleY = scaleFactor 
			mcTreeRight.scaleX = mcTreeRight.scaleY = scaleFactor 
			mcTreeLeft.y = mcTreeRight.y = mcGrass.y - mcTreeLeft.height
			mcTreeLeft.x = (stageWidth/2) - ( (mcBldg.width/1.8) )
			mcTreeRight.x = (stageWidth/2) + ( (mcBldg.width/1.5))
						
			//keep the current values handy
			currBldgWidth = bldgWidth
			currStories = stories
			currStoryHeight = storyHeight
			
		}
		
		
	}
	
	
	
}