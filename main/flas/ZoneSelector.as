package {
	
	import mx.flash.UIMovieClip
	import flash.display.MovieClip
	import flash.display.Shape
	import flash.geom.ColorTransform
	import flash.display.Sprite
	import flash.filters.DropShadowFilter
	import flash.geom.Point
	import fl.transitions.Tween
 	import fl.transitions.easing.*
	import flash.events.Event    
	import flash.display.StageAlign
    import flash.display.StageScaleMode
	
	public class ZoneSelector extends UIMovieClip
	{
		
		private var floorPlan:MovieClip
		private var stageWidth:Number
		private var stageHeight:Number
		private var bldgWidth:Number = 500
		private var bldgLength:Number = 500
		private var m1:MovieClip
		private var m2:MovieClip
		private var m3:MovieClip
		private var m4:MovieClip
		private var m5:MovieClip
		private var zone1:Sprite
		private var zone2:Sprite
		private var zone3:Sprite
		private var zone4:Sprite
		private var zone5:Sprite
		private var zones:Array
		private var rot:Number = 0
		private var pad:Number //padding for zones from central core
		private var zoneHighlight:ColorTransform
		private var noZoneHighlight:ColorTransform
		
		
		public function ZoneSelector()
		{
			addEventListener("addedToStage", onAddedToStage); 
		}
		
		public function onAddedToStage(event:Event)
		{
			trace("ZoneSelector.onAddedToStage()")
            //stage.addEventListener(Event.RESIZE, resizeHandler)
			stage.scaleMode = StageScaleMode.NO_SCALE
            stage.align = StageAlign.TOP_LEFT
			setComponentSize(250,250)
			drawZones(500,500,0)
			selectZone(1)
			floorPlan.x = 125
			floorPlan.y = 125
			removeEventListener("addedToStage", onAddedToStage); 
		
		}
		
		/*
		public function resizeHandler(event:Event)
		{
			//not using this as when resized in flex, stage is giving the *whole* stage size, not the container
			var w:Number = stage.stageWidth
			var h:Number = stage.stageHeight
			setComponentSize(w,h)
		}
		*/
				
		public function setComponentSize(w:Number, h:Number):void
		{
			trace("ZoneSelector.setComponentSize()")
			mcBG.width = w
			mcBG.height = h
			compass.x = w - 20
			compass.y = 20
			if (floorPlan!=null)
			{
				floorPlan.x = uint(w / 2)
				floorPlan.y = uint(h/ 2)
			}
			stageWidth = w
			stageHeight = h
			drawGrid()
		}
		
	
		
		public function selectZone(zoneNum:Number)
		{
			trace("ZoneSelector.selectZone()")
			if (zoneNum<0) zoneNum =0
			if (zoneNum>5) zoneNum = 5
			
			//clear any highlights 
			for(var z:Number=0; z<zones.length; z++)
			{
				var zone:Sprite = Sprite(zones[z])
				if (z==zoneNum-1){
					zone.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 179, 179, 0, 0)
				}
				else
				{
					zone.transform.colorTransform =  new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0)
				}
			}
		}
		
		
		public function drawGrid():void
		{
			
			mcGrid.graphics.clear()
									
			var maxScale:Number = bldgWidth
			if (maxScale < bldgLength) maxScale = bldgLength
						
			var squareSize:Number = uint(200/(maxScale/50))
			
			var widthSteps:Number = uint(stageWidth/squareSize)
			var heightSteps:Number = uint(stageHeight/squareSize)
			
			mcGrid.graphics.lineStyle(0,0xffffff,50)
			//drawborder
			mcGrid.graphics.moveTo(0,0)
			mcGrid.graphics.lineTo(stageWidth,0)
			mcGrid.graphics.lineTo(stageWidth, stageHeight)
			mcGrid.graphics.lineTo(0,stageHeight)
			mcGrid.graphics.lineTo(0,0)
					
			for (var i:Number = 0; i<=widthSteps; i++)
			{
				mcGrid.graphics.moveTo(squareSize*i, 0)
				mcGrid.graphics.lineTo(squareSize*i, stageHeight)
			}
			
			for (i = 0; i<=heightSteps; i++)
			{
				mcGrid.graphics.moveTo(0, squareSize*i )
				mcGrid.graphics.lineTo(stageWidth, squareSize*i)
			}
		}
		
		public function drawZones(w:Number, l:Number, r:Number=0, z:Number=0)
		{
			trace("ZoneSelector.drawZones()")
			bldgWidth = w
			bldgLength = l
			drawGrid()
			
			if (floorPlan != null)
			{
				removeChild(floorPlan)
			}
				
			floorPlan = new MovieClip()
			addChild(floorPlan)
			
			//find short side and computer padding from that
			if (w<l)
			{
				pad = uint(w/3)
			} 
			else 
			{
				pad = uint(l/3)
			}
			
			
			w = uint(w/2)
			l = uint(l/2)
			
			if (zone1==null)
			{
				zone1 = new Sprite()
			}
			else
			{
				zone1.graphics.clear()
			}
			zone1.graphics.lineStyle(0,0x777777)
			zone1.graphics.moveTo(-l,-w)
			zone1.graphics.beginFill(0xE1E1E1,1)
			zone1.graphics.lineTo(+l,-w)
			zone1.graphics.lineTo(+l-pad,-w+pad)
			zone1.graphics.lineTo(-l+pad,-w+pad)
			zone1.graphics.lineTo(-l,-w)
			zone1.graphics.endFill()
			floorPlan.addChild(zone1)
			//add labels
			
						
			if (zone2==null)
			{
				zone2 = new Sprite()
			}
			else
			{
				zone2.graphics.clear()
			}
			zone2.graphics.lineStyle(0,0x777777)
			zone2.graphics.moveTo(l,-w)
			zone2.graphics.beginFill(0xE1E1E1,1)
			zone2.graphics.lineTo(l,w)
			zone2.graphics.lineTo(l-pad,w-pad)
			zone2.graphics.lineTo(l-pad,-w+pad)		
			zone2.graphics.lineTo(l,-w)
			zone2.graphics.endFill()
			floorPlan.addChild(zone2)
			
			if (zone3==null)
			{
				zone3 = new Sprite()
			}
			else
			{
				zone3.graphics.clear()
			}
			zone3.graphics.lineStyle(0,0x777777)
			zone3.graphics.moveTo(l,w)
			zone3.graphics.beginFill(0xE1E1E1,1)
			zone3.graphics.lineTo(-l,w)
			zone3.graphics.lineTo(-l+pad,w-pad)
			zone3.graphics.lineTo(l-pad,w-pad)
			zone3.graphics.lineTo(l,w)
			zone3.graphics.endFill()
			floorPlan.addChild(zone3)
						
			if (zone4==null)
			{
				zone4 = new Sprite()
			}
			else
			{
				zone4.graphics.clear()
			}
			zone4.graphics.lineStyle(0,0x777777)
			zone4.graphics.moveTo(-l,-w)
			zone4.graphics.beginFill(0xE1E1E1,1)
			zone4.graphics.lineTo(-l+pad,-w+pad)
			zone4.graphics.lineTo(-l+pad,w-pad)
			zone4.graphics.lineTo(-l,w)
			zone4.graphics.lineTo(-l,-w)
			zone4.graphics.endFill()
			floorPlan.addChild(zone4)

			if (zone5==null)
			{
				zone5 = new Sprite()
			}
			else
			{
				zone5.graphics.clear()
			}
			zone5.graphics.lineStyle(0,0x777777)
			zone5.graphics.moveTo(-l+pad,-w+pad)
			zone5.graphics.beginFill(0xE1E1E1,1)
			zone5.graphics.lineTo(l-pad,-w+pad)
			zone5.graphics.lineTo(l-pad, w-pad)
			zone5.graphics.lineTo(-l+pad,w-pad)
			zone5.graphics.lineTo(-l+pad,-w+pad)
			zone5.graphics.endFill()
			floorPlan.addChild(zone5)
			
			m1 = new Marker1()
			m1.x = 0
			m1.y = -w + pad/2
			floorPlan.addChild(m1)
			
			
			m2 = new Marker2()
			m2.x = l - pad/2
			m2.y = 0
			floorPlan.addChild(m2)
			
			
			m3 = new Marker3()
			m3.x = 0
			m3.y = w - pad/2
			floorPlan.addChild(m3)
			
			
			m4 = new Marker4()
			m4.x = -l + Math.floor(pad/2)
			m4.y = 0
			floorPlan.addChild(m4)
			
			
			m5 = new Marker5()
			m5.x = 0
			m5.y = 0
			floorPlan.addChild(m5)
			
			
			floorPlan.x = 125	
			floorPlan.y = 125
			
			floorPlan.rotation = r
			
			var scale:Number
			//scale to 170 of 200 (height or width of containing clip)
			if (floorPlan.height > floorPlan.width)
			{
				scale = 200/floorPlan.height
			}
			else 
			{
				scale = 200/floorPlan.width
			}
			
			floorPlan.scaleX = scale
			floorPlan.scaleY = scale
			
			m1.scaleX = 1/scale
			m1.scaleY = 1/scale
			m1.rotation = -r
			m2.scaleX = 1/scale
			m2.scaleY = 1/scale
			m2.rotation = -r
			m3.scaleX = 1/scale
			m3.scaleY = 1/scale
			m3.rotation = -r
			m4.scaleX = 1/scale
			m4.scaleY = 1/scale
			m4.rotation = -r
			m5.scaleX = 1/scale
			m5.scaleY = 1/scale
			m5.rotation = -r
			
			zones = [zone1, zone2, zone3, zone4, zone5]
			
			if (z!=0){
				if (z<1) z=1
				if (z>5) z=5
				selectZone(z)
			}
			
			rot = r
			
		}
		
		public function set northAxis (northAxis:Number):void
		{
			if (northAxis == rot) return //same value
			var newRot:Number = northAxis
			var floorPlanTween:Tween = new Tween(floorPlan, "rotation", Regular.easeOut, rot, newRot, 1, true)
			var m1Tween:Tween = new Tween(m1, "rotation", Regular.easeOut, 0, (-newRot), 1, true)
			var m2Tween:Tween = new Tween(m2, "rotation", Regular.easeOut, 0, (-newRot), 1, true)
			var m3Tween:Tween = new Tween(m3, "rotation", Regular.easeOut, 0, (-newRot), 1, true)
			var m4Tween:Tween = new Tween(m4, "rotation", Regular.easeOut, 0, (-newRot), 1, true)
			var m5Tween:Tween = new Tween(m5, "rotation", Regular.easeOut, 0, (-newRot), 1, true)
			floorPlanTween.start()
			m1Tween.start()
			rot = newRot
		}
		
		
		
	}
	
	
	
}