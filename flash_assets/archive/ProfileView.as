
package{
	
	import mx.flash.UIMovieClip
	import flash.display.Shape
	import flash.display.MovieClip
	import flash.display.Sprite
	import flash.geom.ColorTransform
	import flash.events.Event    
	import flash.display.StageAlign
    import flash.display.StageScaleMode

	public class ProfileView extends MovieClip
	{
		
		private var floorHighlightTrans:ColorTransform
		private var floorNormalTrans:ColorTransform
		private var currFloorHighlightIndex:Number
		private var currBldgWidth:Number = 100
		private var currStories:Number = 12
		private var currStoryHeight:Number = 12
		private var currWindowStyle:Number
		private var currWindowRatio:Number = .5
		private var stageWidth:Number //keep track of width within Flex env
		private var stageHeight:Number //keep track of height within Flex env
		private var bldgColor1:Number = 0xE1E1E1
		private var bldgColor2:Number = 0xDAD1CC
		private var floorsArr:Array
		
		public static var WINDOW_STYLE_PUNCH:Number = 0
		public static var WINDOW_STYLE_STRIP:Number = 1
		
		public function ProfileView()
		{
			addEventListener("addedToStage", onAddedToStage); 
			floorsArr = []
		}
		
		public function onAddedToStage(event:Event):void
		{
			//stage.addEventListener(Event.RESIZE, resizeHandler)  for testing in CS3
			stage.scaleMode = StageScaleMode.NO_SCALE
            stage.align = StageAlign.TOP_LEFT
			currWindowStyle = ProfileView.WINDOW_STYLE_STRIP
			setComponentSize(250,250)
		}
		
		public function resizeHandler(event:Event)
		{
			stageWidth = stage.stageWidth
			stageHeight = stage.stageHeight
			setComponentSize (stageWidth, stageHeight)
		}
		
		public function setComponentSize(w:Number, h:Number):void
		{
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
			setFloorOfInterest(3)
		}
		
		
		public function setFloorOfInterest(floorNumber:Number):void
		{
			/* highlights the "floor of interest" */
			if (floorNumber < 0) floorNumber = 0
			if (floorNumber > floorsArr.length) floorNumber = floorsArr.length
			
			//clear old highlight
			Sprite(floorsArr[currFloorHighlightIndex]).transform.colorTransform =  new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0)
			
			//highlight new floor
			Sprite(floorsArr[floorNumber]).transform.colorTransform =  new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0)
			
			currFloorHighlightIndex = floorNumber
			
		}
		
		public function drawFloors(bldgWidth:Number, stories:Number, storyHeight:Number, windowRatio:Number, windowStyle:Number):void
		{
			trace("drawing width: " + bldgWidth + " stories: " + stories + " storyHeight: " + storyHeight)
			var totalHeight:Number = stories*storyHeight
			
			var availWidth:Number = stageWidth * .6
			var availHeight:Number = stageHeight * .6
			
			//clear out old graphics
			mcBldg.graphics.clear()
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
				var floor:MovieClip = new MovieClip()
				floor.graphics.beginFill(fillColor, 1)
				floor.graphics.lineStyle(0,0xE1E1E1)
				floor.graphics.moveTo(0,-f*storyHeight)
				floor.graphics.lineTo(bldgWidth, -(f*storyHeight))
				floor.graphics.lineTo(bldgWidth, -((f+1)*storyHeight))
				floor.graphics.lineTo(0, -((f+1)*storyHeight))
				floor.graphics.lineTo(0,-f*storyHeight)
				floor.graphics.endFill()
				
				//draw windows
				windowRatio = .5
				for (var w:Number = 0; w< windowSections; w++)
				{
					//punch window
					if (currWindowStyle == ProfileView.WINDOW_STYLE_PUNCH)
					{
						var window:MovieClip = new WindowShape()
						floor.addChild(window)
						if (windowRatio == 1){
							trace("windowHeight: " + window.height)
							window.height = storyHeight
						} 
						else 
						{
							var area:Number = storyHeight * 10 * windowRatio
							window.height = storyHeight
							window.width = (Math.sqrt(area*10/storyHeight)) 
							window.height = (Math.sqrt(area*storyHeight/10)) 
							trace("window.height: " + window.height)
							trace("window.width: " + window.width)
							trace("storyHeight: " + storyHeight)
							
						}
						window.x = 5 + w*10
						window.y = -uint(storyHeight/2)
						
					}
					else
					{
						var window:MovieClip = new WindowShape()
						floor.addChild(window)
						if (windowRatio == 1){
							trace("windowHeight: " + window.height)
							window.height = storyHeight
						} 
						else 
						{
							var area:Number = storyHeight * 10 * windowRatio
							window.height = storyHeight
							window.height = storyHeight/2
							window.y = storyHeight/2
							
						}
						window.x = 5 + w*10
						window.y = -uint(storyHeight/2)
						
					}
				}
				
				mcBldg.addChild(floor)
				//floor.x = -(f*storyHeight)
			}
			
			//resize bldg to fit
			var scaleFactor:Number = availWidth/bldgWidth
			trace ("scaleFactor: " + scaleFactor)
			var hScaleFactor:Number = availHeight/totalHeight
			if (scaleFactor > hScaleFactor) scaleFactor = hScaleFactor
			
			mcBldg.scaleX = mcBldg.scaleY = scaleFactor
						
			//recenter
			mcBldg.x = uint(stageWidth/2) - uint(mcBldg.width/2)
			
			//scale and position trees
			mcTreeLeft.scaleX = mcTreeLeft.scaleY = scaleFactor
			mcTreeRight.scaleX = mcTreeRight.scaleY = scaleFactor
			trace("left tree scaled to : " + mcTreeLeft.scaleX)
			trace("right tree scaled to : " + mcTreeRight.scaleX)
			mcTreeLeft.y = mcTreeRight.y = mcGrass.y - mcTreeLeft.height
			mcTreeLeft.x = uint(stageWidth/2) - ( uint(mcBldg.width/2) + 1.2*mcTreeLeft.width )
			mcTreeRight.x = uint(stageWidth/2) + ( uint(mcBldg.width/2) + 1.2*mcTreeRight.width )
			
			//keep the current values handy
			currBldgWidth = bldgWidth
			currStories = stories
			currStoryHeight = storyHeight
			
		}
		
		
	}
	
	
	
}