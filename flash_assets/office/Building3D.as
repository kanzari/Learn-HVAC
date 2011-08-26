
package
{
 	import flash.display.MovieClip
	import flash.display.Sprite
	import flash.events.Event
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.objects.Cube;
	import org.papervision3d.objects.Sphere;
	import org.papervision3d.scenes.MovieScene3D;	
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.BitmapAssetMaterial
	import org.papervision3d.materials.MaterialsList
	import mx.flash.UIMovieClip

	[SWF(width='800',height='450',backgroundColor='0x000000',frameRate='30')]
	
	public class Building3D extends UIMovieClip
	{
		private var container: Sprite;
		private var scene: MovieScene3D;
		public var camera: Camera3D;
		private var stories: Array
		private var currHeight:Number = 10
		private var currWidth:Number = 100
		private var currLength:Number =100
		private var currStories:Number = 3
		private var currStoryHeight:Number = 10
		private var windowRatioSouth:Number = .7
		private var windowRatioWest:Number = .7
		private var windowThickness:Number = 1
		private var material:ColorMaterial
		private var windows:Array
		private var windowMatLists:Array
		private var buildingMatLists:Array
		
		public function Building3D()
		{
			trace("#Building3D: constructor()")
					
			initMaterials()
			
			makeBuilding()
			
			//addEventListener(Event.ENTER_FRAME, moveCamera)
			
		}
		
		public function initMaterials()
		{
			
			//var concreteStacked:BitmapAssetMaterial = new BitmapAssetMaterial("concreteStacked"); 
			//var concreteBushed:BitmapAssetMaterial = new BitmapAssetMaterial("concreteBrushed");
			
			var grey1:ColorMaterial = new ColorMaterial();
			grey1.fillColor = 0xE1E1E1;
			grey1.fillAlpha = 1.0;
			grey1.doubleSided = false
			
			var grey2:ColorMaterial = new ColorMaterial();
			grey2.fillColor = 0xC1C1C1;
			grey2.fillAlpha = 1.0;
			grey2.doubleSided = false
			
			var grey3:ColorMaterial = new ColorMaterial();
			grey3.fillColor = 0x999999;
			grey3.fillAlpha = 1.0;
			grey3.doubleSided = false
			
			
			var red1:ColorMaterial = new ColorMaterial();
			red1.fillColor = 0xDAD1CC;
			red1.fillAlpha = 1.0;
			red1.doubleSided = false
			
			var red2:ColorMaterial = new ColorMaterial();
			red2.fillColor = 0xBDB4AF;
			red2.fillAlpha = 1.0;
			red2.doubleSided = false
			
			var red3:ColorMaterial = new ColorMaterial();
			red3.fillColor = 0x918883;
			red3.fillAlpha = 1.0;
			red3.doubleSided = false
			
			var window1:ColorMaterial = new ColorMaterial();
			window1.fillColor = 0x269BD9
			window1.fillAlpha = 1.0
			window1.doubleSided = true
			
			var window2:ColorMaterial = new ColorMaterial();
			window2.fillColor = 0x2183B8
			window2.fillAlpha = 1.0
			window2.doubleSided = true
			
			//concreteStacked.doubleSided = true;
			//concreteStacked.smooth = true;
			//concreteBushed.doubleSided = true;
			//concreteBushed.smooth = true;
			
			
			var matList:MaterialsList = new MaterialsList()
			matList.addMaterial(grey2, "front")
			matList.addMaterial(grey3, "left")
			matList.addMaterial(grey2, "back")
			matList.addMaterial(grey3, "right")
			matList.addMaterial(grey1, "top")
			matList.addMaterial(grey1, "bottom")
					
			var matList2:MaterialsList = new MaterialsList()
			matList2.addMaterial(red2, "front")
			matList2.addMaterial(red3, "left")
			matList2.addMaterial(red2, "back")
			matList2.addMaterial(red3, "right")
			matList2.addMaterial(red1, "top")
			matList2.addMaterial(red1, "bottom")
								
			var windowMatList:MaterialsList = new MaterialsList()
			windowMatList.addMaterial(window1, "front")
			windowMatList.addMaterial(window1, "left")
			windowMatList.addMaterial(window1, "back")
			windowMatList.addMaterial(window1, "right")
			windowMatList.addMaterial(window1, "top")
			windowMatList.addMaterial(window1, "bottom")
			
			var windowMatList2:MaterialsList = new MaterialsList()
			windowMatList2.addMaterial(window2, "front")
			windowMatList2.addMaterial(window2, "left")
			windowMatList2.addMaterial(window2, "back")
			windowMatList2.addMaterial(window2, "right")
			windowMatList2.addMaterial(window2, "top")
			windowMatList2.addMaterial(window2, "bottom")
					
			windowMatLists = [windowMatList, windowMatList2]
			buildingMatLists = [matList, matList2]
		}
		
		/*
		public function moveCamera(e:Event)
		{
			camera.x = camera.x + 1
			scene.renderCamera(camera)
		}*/
		
		public function changeStories(value:Number):void
		{
			if (value <3) value = 3
			currStories = value
			makeBuilding()
		}
		
		public function changeStoryHeight(value:Number):void
		{
			currStoryHeight = value
			makeBuilding()
		}
				
		public function changeWidth(value:Number):void
		{
			currWidth = value
			makeBuilding()
		}
		
			
		public function changeLength(value:Number):void
		{
			currLength= value
			makeBuilding()
		}
		
		public function changeRatio(side:String, value:Number){
			
			switch (side)
			{
				case "west":
					windowRatioWest = value
					makeBuilding()
					break
				case "south":
					windowRatioSouth = value
					makeBuilding()
					break
				default:
			}
			
		}
		
		
		
		public function makeBuilding()
		{
			
			stories = []
			windows = []
			
			if (container!=null)
			{
				removeChild( container )
			}
			container = new Sprite;
			container.x = 100;
			container.y = 300;
			addChild( container );
									
			trace("#Building3D: adding scene")
			scene = new MovieScene3D( container );
			
			camera = new Camera3D();
			camera.z = -500;
			camera.y = 400
			camera.x = 380
			camera.zoom = 10;
			
			
			//add three stories
			for (var i:Number=0; i<=30; i++)
			{
				var bldg:Cube = new Cube( buildingMatLists[i%2], currWidth, currLength, currStoryHeight, 2, 2, 2);
				bldg.z = Math.round(currLength/2)
				bldg.x = Math.round(currWidth/2)
				bldg.y = currStoryHeight*i
				if (i>=currStories) bldg.visible = false
				stories.push(bldg)
				scene.addChild(bldg)
			}
			
			updateWindows()			
			
			scene.renderCamera( camera );
		}
		
		
		public function updateBuilding()
		{
			for (var i:Number =0; i<stories.length; i++)
			{
				var bldg:Cube = Cube(stories[i])
				bldg.scaleX = currWidth/100
				bldg.scaleY = currStoryHeight/10
				bldg.scaleZ = currLength/100
				bldg.y = currStoryHeight*i
				if (i<currStories) 
				{
					bldg.visible = true
				}
				else
				{
					bldg.visible = false
				}
				
			}
			updateWindows()
			scene.renderCamera( camera );
		}
		
		public function updateWindows()
		{
			//clear existing
			
			for (var i:Number = 0; i<windows.length; i++)
			{
				for (var j:Number=0; j<windows.length; j++)
				{
					scene.removeChild(windows[i][j])
				}
			}
			
			//add new windows
			var numWindowsSouth:Number = Math.floor(currLength/10)
			var numWindowsWest:Number = Math.floor(currWidth/10)
			var windowWidthSouth:Number = 10*windowRatioSouth
			var windowHeightSouth:Number = currStoryHeight*windowRatioSouth
			var windowWidthWest:Number = 10*windowRatioWest
			var windowHeightWest:Number = currStoryHeight*windowRatioWest
			windows = []
			for (i=0; i<currStories; i++)
			{
				var windowMatListNo:Number = i%2

				var floorWindows:Array = []

				for (var w:Number=0; w<numWindowsSouth; w++)
				{
					var win:Cube = new Cube(windowMatLists[windowMatListNo], windowThickness, windowWidthSouth, windowHeightSouth, 2,2,2);
					
					win.z = w*10 + 5
					win.x = currWidth 
					win.y = currStoryHeight*i
								
					floorWindows.push(win)
					scene.addChild(win)
					
				}
				
				for (w=0; w<numWindowsWest; w++)
				{
					win = new Cube(windowMatLists[windowMatListNo], windowWidthWest, windowThickness, windowHeightWest, 2,2,2);
					
					win.z = 0
					win.x = w*10 + 5 
					win.y = currStoryHeight*i
					
					floorWindows.push(win)
					scene.addChild(win)
					
				}
				windows.push(floorWindows)
			}
			
			
			
		}
	}
	
}
