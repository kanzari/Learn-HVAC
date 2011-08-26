// ActionScript file


package 
{
	import com.mcquilleninteractive.learnhvac.model.ScenarioModel;
	import com.mcquilleninteractive.learnhvac.util.Logger;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import mx.core.UIComponent;
	
	public class ParticleEngine extends UIComponent
	{
		
		public var currScene:String = ScenarioModel.SN_ROOF //simulation view always starts with roof
		public var timer:Timer
		public var count:Number
		
		//Make accessing constants a little more convenient
		public var SN_HC:String = ScenarioModel.SN_HC
		public var SN_CC:String =  ScenarioModel.SN_CC
		public var SN_FAN:String =  ScenarioModel.SN_FAN
		public var SN_FILTER:String =  ScenarioModel.SN_FILTER
		public var SN_MIXINGBOX:String = ScenarioModel.SN_MIXINGBOX 
		public var SN_VAV:String = ScenarioModel.SN_VAV
		public var SN_DIFFUSER:String = ScenarioModel.SN_DIFFUSER
		public var SN_ROOF:String	= ScenarioModel.SN_ROOF
		public var SN_SYSTEM:String = ScenarioModel.SN_SYSTEM
		
		
		public var particleArr:Array
		public var iScene:String
		public var serialnumber:Number = 0
		public var running:Boolean
		public var DISABLED_PE:Boolean = false //set by admin panel 
		public var currUnits:String
		public var birthPace:Number
		public var particleMax:Number
		public var sysVarsArr:Array
		
		public var debugMXRAPosDamperReal:Number
		public var OABornProbability:Number
		public var bornProbability:Number
		
		public var particleMax_SYS:Number
		public var particleBirth_SYS:Number
		public var particleMax_MX:Number
		public var particleBirth_MX:Number
		public var particleMax_FAN:Number
		public var particleMax_DIF:Number
		public var particleBirth_DIF:Number
		public var particleMax_DEFAULT:Number
		public var particleBirth_DEFAULT:Number
		
		public var particleSize:Number = 20 //why does this have no setting in the original code?
		public var particleAlive:Number = 0 
		public var iTimeS:Number = 1
		public var serialNumber:Number = 0
		public var engineRun:Boolean = true
		public var bColorChange:Boolean = true
		public var bSizeChange:Boolean  = true
		
		public var goalProbability:Array
		
		public var SYSgoalColorR:Array
		public var SYSgoalColorG:Array
		public var SYSgoalColorB:Array	
		
		public var HCgoalColorR:Array
		public var HCgoalColorG:Array
		public var HCgoalColorB:Array
			
		public var CCgoalColorR:Array
		public var CCgoalColorG:Array
		public var CCgoalColorB:Array
			
		public var FLTgoalColorR:Array
		public var FLTgoalColorG:Array
		public var FLTgoalColorB:Array
			
		public var MXgoalColorR:Array
		public var MXgoalColorG:Array
		public var MXgoalColorB:Array
			
		public var FANgoalColorR:Array
		public var FANgoalColorG:Array
		public var FANgoalColorB:Array
			
		public var DIFgoalColorR:Array
		public var DIFgoalColorG:Array
		public var DIFgoalColorB:Array
			
		public var VAVgoalColorR:Array
		public var VAVgoalColorG:Array
		public var VAVgoalColorB:Array
					
		public var returnProb:Number
		public var bornHeadGoal:Number
		public var bornTailGoal:Number
		public var iSize:Number	
		public var rGGrav:Number
		public var exhaustProb:Number
		public var goalHeadGoal:Array = new Array(15)
		public var goalTailGoal:Array= new Array(15)
		public var goalPositionX:Array= new Array(15)
		public var goalPositionY:Array= new Array(15)
		public var goalFuzzyRadius:Array= new Array(15)
		public var goalNearRadius:Array= new Array(15)
		public var goalDriftStep:Array= new Array(15)
		public var goalTimeSlice:Array= new Array(15)
		public var goalGravity:Array= new Array(15)
		public var goalAlpha:Array= new Array(15)
		public var goalAlphaStep:Array= new Array(15)
		public var goalDecay:Array= new Array(15)
		public var goalColorR:Array= new Array(15)
		public var goalColorG:Array= new Array(15)
		public var goalColorB:Array= new Array(15)
		public var dieOnThisStep:Array= new Array(15)
		public var goalColorStep:Array= new Array(15)
		public var goalSize:Array= new Array(15)
		public var goalSizeStep:Array= new Array(15)
		
		public function ParticleEngine():void
		{
			graphics.beginFill(0xFFFFFF)
			graphics.drawRect(0,0,650,550)
			timer = new Timer(40)
			timer.addEventListener("timer", onTimer)	
			initPE(SN_HC)
		}
		
		public function setScene(systemNode:String):void
		{
			Logger.info("#PE: setScene() to systemNode: " + systemNode)
			stopAnim()
			iScene = systemNode
			initScene(iScene)
			if (running)
			{
				startPE()
			}
		}
		
		public function startPE():void
		{
			Logger.info("#PE: startPE()")
			if (DISABLED_PE) return
			running=true
			count = 0
			serialnumber=0
			if (iScene==SN_ROOF) return
			this.visible = true
			timer.start()
			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		public function stopPE():void
		{
			Logger.info("#PE: stopPE()")
			running = false
			visible = false
			timer.stop()
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		public function switchUnits(units:String)
		{
			currUnits = units
		}
		
		public function onEnterFrame(event:Event)
		{
			animate()
		}
		
		public function onTimer(event:TimerEvent):void
		{
			animate()
		}

		public function destroy(p:Particle):void
		{
			this.removeChild(p)
			particleAlive--
		}
		
		public function setParticleEngine(evt:Object):void
		{
			Logger.info("#PE: setting particle engine to : " + evt.setting )
			if (evt.setting == "full" || evt.setting=="reduced"){
				if (evt.setting=="full")
				{
					particleMax_SYS = 170
					particleBirth_SYS = 10
					particleMax_MX =120
					particleBirth_MX = 2
					particleMax_FAN = 120
					particleMax_DIF = 70
					particleBirth_DIF = 2
					particleMax_DEFAULT = 50
					particleBirth_DEFAULT = 1
					DISABLED_PE = false
				}
				else
				{
					particleMax_SYS = 90
					particleBirth_SYS = 20
					particleMax_MX =60
					particleBirth_MX = 5
					particleMax_FAN = 60
					particleMax_DIF = 35
					particleBirth_DIF = 5
					particleMax_DEFAULT = 25
					particleBirth_DEFAULT = 5
					DISABLED_PE = false
				}
			}
			
			switch(iScene)
			{
				case SN_SYSTEM:
					birthPace = particleBirth_SYS
					particleMax = particleMax_SYS
					break
				case SN_MIXINGBOX:
					birthPace = particleBirth_MX
					particleMax = particleMax_MX
				case SN_FAN:
					birthPace = particleBirth_DEFAULT
					particleMax = particleMax_MX
					break
				case SN_DIFFUSER:
					birthPace = particleBirth_DIF
					particleMax = particleMax_DIF
					break
				default:
					birthPace = particleBirth_DEFAULT
					particleMax = particleMax_DEFAULT
			}
			
			if (running==false && evt.currAHUStatus == ScenarioModel.AHU_ON)
			{
				startPE()
			}
			else
			{
				//assume "none"
				stopPE()
				
			}
		}
		
		/////////////////////
		// INTERNAL FUNCTIONS
		/////////////////////
		
		private function stopAnim()
		{
			for (var i:String in particleArr)
			{
				removeChild(particleArr[i])
			}
			timer.stop()
		}
		
		
		private function initPE(iScene:String):void
		{
	
			Logger.info("#PE#initPE: " + iScene)
			running = false
			currUnits = "IP"
			sysVarsArr = []
	
			//particle max settings
			particleMax_SYS = 170
			particleBirth_SYS = 10
			particleMax_MX = 120
			particleBirth_MX = 2
			particleMax_FAN = 120
			particleMax_DIF = 70
			particleBirth_DIF = 2
			particleMax_DEFAULT = 50
			particleBirth_DEFAULT = 1
			DISABLED_PE = false
			
			
			//init variables
			count = 0
			
			initColors()
			initVars()
			
		}
		
		function initVars():void
		{
			Logger.info("#PE:initVars()")
			//Setup default values for variables
			//SYS
			setScene (SN_MIXINGBOX)
			setSysVar ("MXRAPosDamperReal", .9)
			//HC
			setScene (SN_HC)
			setSysVar ("HCTAirEnt", 10)
			setSysVar ("HCTAirLvg", 35)
			//CC
			setScene (SN_CC)
			setSysVar ("CCTAirEnt", 35)
			setSysVar ("CCTAirLvg", 25)
			//Fan
			setScene (SN_FAN)
			setSysVar ("FanTAirEnt", 25)
			setSysVar ("FanTAirLvg", 25)
			//MX
			setScene (SN_MIXINGBOX)
			setSysVar ("MXTRet", 40)
			setSysVar ("MXTOut", 10)
			setSysVar ("MXTmix", 30)
			//VAV
			setScene (SN_VAV)
			setSysVar ("VAVHCTAirEnt", 25)
			setSysVar ("VAVHCTAirLvg", 45)
			setSysVar ("VAVPos", 0)
			//SYSTEM
			setScene (SN_SYSTEM)
			setSysVar ("TRoom", 35)
			setSysVar ("TAirOut", 20)
		}
		
		
		//Setup initial goal color arrays
		public function initColors():void
		{
		
			SYSgoalColorR = new Array(10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10);
			SYSgoalColorG = new Array(100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100);
			SYSgoalColorB = new Array(41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41);
			
			HCgoalColorR = new Array(100, 100, 255, 255, 255, 255, 255, 255);
			HCgoalColorG = new Array(100, 100, 100, 100, 150, 150, 150, 150);
			HCgoalColorB = new Array(255, 255, 100, 100, 150, 150, 150, 150);
			
			CCgoalColorR = new Array(255, 100, 100, 100, 255, 255, 255, 255);
			CCgoalColorG = new Array(100, 100, 100, 100, 150, 150, 150, 150);
			CCgoalColorB = new Array(255, 255, 255, 255, 150, 150, 150, 150);
			
			FLTgoalColorR = new Array(255, 255, 255, 255, 255, 255, 255, 255);
			FLTgoalColorG = new Array(100, 100, 100, 100, 100, 100, 100, 100);
			FLTgoalColorB = new Array(100, 100, 100, 100, 100, 100, 100, 100);
			
			MXgoalColorR = new Array(42, 42, 42, 42, 42, 42, 42, 42, 42, 42);
			MXgoalColorG = new Array(200, 200, 200, 200, 200, 200, 200, 200, 200, 200);
			MXgoalColorB = new Array(230, 230, 230, 230, 230, 230, 230, 230, 230, 230);
			
			FANgoalColorR = new Array(255, 255, 255, 255, 255, 255, 255, 255);
			FANgoalColorG = new Array(150, 150, 150, 150, 150, 150, 150, 150);
			FANgoalColorB = new Array(150, 150, 150, 150, 150, 150, 150, 150);
			
			DIFgoalColorR = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			DIFgoalColorG = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			DIFgoalColorB = new Array(0, 0, 0, 0, 0, 0, 0, 0);
			
			VAVgoalColorR = new Array(25, 25, 25, 25, 25, 25, 25);
			VAVgoalColorG = new Array(100, 100, 100, 100, 100, 100, 100);
			VAVgoalColorB = new Array(255, 255, 255, 255, 255, 255, 255);
		
		}

		
		public function setSysVar(sysVarName, sysVarValue):void
		{
			
			if (sysVarsArr[sysVarName]== undefined)
			{
				sysVarsArr[sysVarName] = sysVarValue
			}	
	
			if (sysVarValue==null || sysVarValue == undefined || isNaN(sysVarValue))
			{
				return
			}
	
			var colorObj:ColorTransform = getColorObject(sysVarValue)
			sysVarsArr[sysVarName] = colorObj
			switch(sysVarName)
			{
				case "MXRAPosDamperReal":
					if (iScene == SN_MIXINGBOX)
					{
						// Both Mixing Box and System View
						debugMXRAPosDamperReal = sysVarValue
						OABornProbability = 1 - sysVarValue
						bornProbability = OABornProbability
						//System view
						goalProbability[13] = sysVarValue
						//Mixing box
						goalProbability[1] = sysVarValue
					}
					break
					
				case "HCTAirEnt":
					if (iScene == SN_HC || iScene == SN_FILTER)
					{
						HCgoalColorR[0] = ColorTransform(sysVarsArr["HCTAirEnt"]).redOffset
						HCgoalColorG[0] = sysVarsArr["HCTAirEnt"].greenOffset
						HCgoalColorB[0] = sysVarsArr["HCTAirEnt"].blueOffset
						
						//set the temp for the filter here to as it will be the same value
						for (i=0; i<4;i++)
						{
							FLTgoalColorR[i] = sysVarsArr["HCTAirEnt"].redOffset
						    FLTgoalColorG[i] = sysVarsArr["HCTAirEnt"].greenOffset
							FLTgoalColorB[i] = sysVarsArr["HCTAirEnt"].blueOffset			
						}
					}
					break
						
				case "HCTAirLvg":
					if (iScene == SN_HC || iScene == SN_SYSTEM)
					{
						HCgoalColorR[1] = sysVarsArr["HCTAirLvg"].redOffset
						HCgoalColorG[1] = sysVarsArr["HCTAirLvg"].greenOffset
						HCgoalColorB[1] = sysVarsArr["HCTAirLvg"].blueOffset
						
						//system view
						SYSgoalColorR[3] = sysVarsArr["HCTAirLvg"].redOffset
						SYSgoalColorG[3] = sysVarsArr["HCTAirLvg"].greenOffset
						SYSgoalColorB[3] = sysVarsArr["HCTAirLvg"].blueOffset		
					}
					break
					
				case "CCTAirEnt":
					if (iScene==SN_CC)
					{
						//change first half of CC
						CCgoalColorR[0] = sysVarsArr["CCTAirEnt"].redOffset
						CCgoalColorG[0] = sysVarsArr["CCTAirEnt"].greenOffset
						CCgoalColorB[0] = sysVarsArr["CCTAirEnt"].blueOffset
					}
					break
					
				case "CCTAirLvg":
					if (iScene == SN_CC || iScene == SN_SYSTEM)
					{
						//change second half of CC
						CCgoalColorR[1] = sysVarsArr["CCTAirLvg"].redOffset
						CCgoalColorG[1] = sysVarsArr["CCTAirLvg"].greenOffset
						CCgoalColorB[1] = sysVarsArr["CCTAirLvg"].blueOffset
					
						//system view
						SYSgoalColorR[4] = sysVarsArr["CCTAirLvg"].redOffset
						SYSgoalColorG[4] = sysVarsArr["CCTAirLvg"].greenOffset
						SYSgoalColorB[4] = sysVarsArr["CCTAirLvg"].blueOffset		
					}
					break
					
				case "FanTAirEnt":
					if (iScene == SN_FAN)
					{
						for (var i=0;i<=5;i++)
						{
							FANgoalColorR[i] = sysVarsArr["FanTAirEnt"].redOffset
							FANgoalColorG[i] = sysVarsArr["FanTAirEnt"].greenOffset
							FANgoalColorB[i] = sysVarsArr["FanTAirEnt"].blueOffset
						}
					}
					break
					
				case "FanTAirLvg":
					if (iScene == SN_FAN || iScene == SN_SYSTEM)
					{
						FANgoalColorR[i] = sysVarsArr["FanTAirLvg"].redOffset
						FANgoalColorG[i] = sysVarsArr["FanTAirLvg"].greenOffset
						FANgoalColorB[i] = sysVarsArr["FanTAirLvg"].blueOffset
						for (var i=5;i<=7;i++)
						{
							SYSgoalColorR[i] = sysVarsArr["FanTAirLvg"].redOffset
							SYSgoalColorG[i] = sysVarsArr["FanTAirLvg"].greenOffset
							SYSgoalColorB[i] = sysVarsArr["FanTAirLvg"].blueOffset	
						}
					}
					break
					
				case "MXTRet":
					if (iScene == SN_MIXINGBOX)
					{
						//change first third of CC
						for (i=0;i<2;i++)
						{
							MXgoalColorR[i] = sysVarsArr["MXTRet"].redOffset
							MXgoalColorG[i] = sysVarsArr["MXTRet"].greenOffset
							MXgoalColorB[i] = sysVarsArr["MXTRet"].blueOffset
						}
						MXgoalColorR[2] = sysVarsArr["MXTRet"].redOffset
						MXgoalColorG[2] = sysVarsArr["MXTRet"].greenOffset
						MXgoalColorB[2] = sysVarsArr["MXTRet"].blueOffset
						
						MXgoalColorR[9] = sysVarsArr["MXTRet"].redOffset
						MXgoalColorG[9] = sysVarsArr["MXTRet"].greenOffset
						MXgoalColorB[9] = sysVarsArr["MXTRet"].blueOffset
					}
					break
					
				case "MXTOut":
					if (iScene == SN_MIXINGBOX)
					{
						//change second third of CC
						MXgoalColorR[4] = sysVarsArr["MXTOut"].redOffset
						MXgoalColorG[4] = sysVarsArr["MXTOut"].greenOffset
						MXgoalColorB[4] = sysVarsArr["MXTOut"].blueOffset
					}
					break
					
				case "MXTmix":
					if (iScene == SN_MIXINGBOX || iScene == SN_SYSTEM)
					{
						//change final third of CC
						MXgoalColorR[3] = sysVarsArr["MXTmix"].redOffset
						MXgoalColorG[3] = sysVarsArr["MXTmix"].greenOffset
						MXgoalColorB[3] = sysVarsArr["MXTmix"].blueOffset
						MXgoalColorR[5] = sysVarsArr["MXTmix"].redOffset
						MXgoalColorG[5] = sysVarsArr["MXTmix"].greenOffset
						MXgoalColorB[5] = sysVarsArr["MXTmix"].blueOffset
						MXgoalColorR[6] = sysVarsArr["MXTmix"].redOffset
						MXgoalColorG[6] = sysVarsArr["MXTmix"].greenOffset
						MXgoalColorB[6] = sysVarsArr["MXTmix"].blueOffset
						
						//set color for system level view
						SYSgoalColorR[2] = sysVarsArr["MXTmix"].redOffset
						SYSgoalColorG[2] = sysVarsArr["MXTmix"].greenOffset
						SYSgoalColorB[2] = sysVarsArr["MXTmix"].blueOffset		
					}
					break
					
				case "VAVPos":
					if (iScene == SN_VAV)
					{
						if (sysVarValue>=0 && sysVarValue<=1)
						{			
							trace("setting VAV pos on [1] to : "+ sysVarValue)
							goalProbability[1] = sysVarValue
						}
					}
					
				case "VAVHCTAirEnt":
					if (iScene == SN_VAV)
					{
						for (var i:Number = 0; i<=6; i++)
						{
							if (i==2 || i ==3) continue
							VAVgoalColorR[i] = sysVarsArr["VAVHCTAirEnt"].redOffset
							VAVgoalColorG[i] = sysVarsArr["VAVHCTAirEnt"].greenOffset
							VAVgoalColorB[i] = sysVarsArr["VAVHCTAirEnt"].blueOffset
						}
					}
					break
					
				case "VAVHCTAirLvg":
					if (iScene == SN_VAV || iScene == SN_DIFFUSER || iScene == SN_SYSTEM)
					{
						VAVgoalColorR[2] = sysVarsArr["VAVHCTAirLvg"].redOffset
						VAVgoalColorG[2] = sysVarsArr["VAVHCTAirLvg"].greenOffset
						VAVgoalColorB[2] = sysVarsArr["VAVHCTAirLvg"].blueOffset
						
						VAVgoalColorR[3] = sysVarsArr["VAVHCTAirLvg"].redOffset
						VAVgoalColorG[3] = sysVarsArr["VAVHCTAirLvg"].greenOffset
						VAVgoalColorB[3] = sysVarsArr["VAVHCTAirLvg"].blueOffset
						
						//system view
						for (var i=8; i<10;i++)
						{
							SYSgoalColorR[i] = sysVarsArr["VAVHCTAirLvg"].redOffset
							SYSgoalColorG[i] = sysVarsArr["VAVHCTAirLvg"].greenOffset
							SYSgoalColorB[i] = sysVarsArr["VAVHCTAirLvg"].blueOffset		
						}
					
						//diffuser view
						DIFgoalColorR[0] = DIFgoalColorR[1] = sysVarsArr["VAVHCTAirLvg"].redOffset
						DIFgoalColorG[0] = DIFgoalColorG[1] = sysVarsArr["VAVHCTAirLvg"].greenOffset
						DIFgoalColorB[0] = DIFgoalColorB[1] = sysVarsArr["VAVHCTAirLvg"].blueOffset	
					}
					break
					
				case "TRoom":
					if (iScene == SN_DIFFUSER || iScene == SN_SYSTEM)
					{
						//system view
						SYSgoalColorR[1] = sysVarsArr["TRoom"].redOffset
						SYSgoalColorG[1] = sysVarsArr["TRoom"].greenOffset
						SYSgoalColorB[1] = sysVarsArr["TRoom"].blueOffset		
			
						for (var i=10; i<15;i++)
							{
							SYSgoalColorR[i] = sysVarsArr["TRoom"].redOffset
							SYSgoalColorG[i] = sysVarsArr["TRoom"].greenOffset
							SYSgoalColorB[i] = sysVarsArr["TRoom"].blueOffset		
						}
						
						//diffuser view
						DIFgoalColorR[2] = sysVarsArr["TRoom"].redOffset
						DIFgoalColorG[2] = sysVarsArr["TRoom"].greenOffset
						DIFgoalColorB[2] = sysVarsArr["TRoom"].blueOffset		
						
						DIFgoalColorR[4] = sysVarsArr["TRoom"].redOffset
						DIFgoalColorG[4] = sysVarsArr["TRoom"].greenOffset
						DIFgoalColorB[4] = sysVarsArr["TRoom"].blueOffset		
					}
				
					break
					
				case "TAirOut":
					if (iScene == SN_SYSTEM)
					{
						//system view
						SYSgoalColorR[0] = sysVarsArr["TAirOut"].redOffset
						SYSgoalColorG[0] = sysVarsArr["TAirOut"].greenOffset
						SYSgoalColorB[0] = sysVarsArr["TAirOut"].blueOffset		
					}
					break
					
					
				default:
					trace("#PE : setSysVar(): unrecognized sysVarName: " + sysVarName) 
			}
		}
		
		
		
		
		
		
				
		
		
		/**********************************************************
		   This function is responsible for coloring the particles
		   based on current value of system variables.
		   Change the code below to change the color ranges
		***********************************************************/
		
		function getColorObject(p_temp:Number):ColorTransform{
					
				var temp:Number = p_temp
			 
				var r:Number=0
				var g:Number=0
				var b:Number=0
				
				/****************************************************
				   DEFINE COLORS FOR IP HERE
				****************************************************/
				if (currUnits =="IP")
				{
					if (temp<0){
						r = 0
						g = 0
						b = 120
					} else if (temp <=15){
						r = 0
						g = 0
						b = 120 + (9 * temp)    
					} else if (temp <=50){
						r = 1.4*(temp-15)
						g = 2.9*(temp-15)
						b = 255    
					} else if (temp<=60){
						r = 50 + (10 * (temp-50))
						g = 100 - (5 *(temp-50))
						b = 255 - (20.5 * (temp-50))
					} else if (temp<=80){
						r = 150 + (3.5 * (temp -60))
						g = 50-(2.5*(temp-60))
						b = 50-(2.5*(temp-60))
					} else if (temp<=100){
						r = 255-(3*(temp-80))
						g = 0
						b = 0
					} else {
						r = 195
						g = 0
						b = 0
					}
				}
				else
				/****************************************************
				   DEFINE COLORS FOR SI HERE
				****************************************************/
				{
					if (temp<-17.8){
						r = 0
						g = 0
						b = 120
					} else if (temp <=-9.4){
						r = 0
						g = 0
						b = 120 + (16.07 * (temp + 17.8)) 
					} else if (temp <=0){
						r = 2.5 *(temp+9.4)
						g = 5.1 *(temp+9.4)
						b = 255    
					} else if (temp<=10){
						r = 24 + (2.5*10)
						g = 48 + (5.1*10)
						b = 200-(4.44*(temp-35))
					} else if (temp<=15.6){
						r = 50 + (17.9*(temp-10))
						g = 100 - (9*(temp-10))
						b = 255
					} else if (temp<=26.7){
						r = 150 + (9.5*(temp-15.6))
						g =  50 - (4.5*(temp-15.6))
						b =  50 - (4.5*(temp-15.6))
					} else if (temp<=26.7){
						r = 255-(5.5*(temp-26.7))
						g = 0
						b = 0
					} else {
						r = 195
						g = 0
						b = 0
					}
				}
			
				return new ColorTransform(0,Math.round(r),0,Math.round(g),0,Math.round(b))

		}
					
		
		
		

	
					
				
		public function initScene(iScene:String){
			
			count = 0
			particleAlive = 0 
			iTimeS = 1
			serialNumber = 0
			engineRun = true
			bColorChange = true
			bSizeChange  = true
				
			switch(iScene){
				
				case SN_SYSTEM:
					
					bornProbability = OABornProbability
					returnProb = 1 - OABornProbability
					bornHeadGoal = 0;
					bornTailGoal = 1;
					iSize = 5
					rGGrav = 1.7
					birthPace = particleBirth_SYS 
					particleMax = particleMax_SYS
					
					goalProbability = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, returnProb, 1, 1);
					goalHeadGoal = new Array(2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 2, 0, 0);
					goalTailGoal = new Array(2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
					goalPositionX = new Array(270, 160, 275, 362, 413, 575, 600, 600, 525, 450, 420, 300, 275, 165, 165, -10);
					goalPositionY = new Array(10, 120, 120, 120, 120, 120, 150, 220, 220, 220, 350, 350, 225, 225, 125, 125);
					goalFuzzyRadius = new Array(15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15);
					goalNearRadius = new Array(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
					goalDriftStep = new Array(10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
					goalColorR = SYSgoalColorR 
					goalColorG = SYSgoalColorG
					goalColorB = SYSgoalColorB
					dieOnThisStep = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2);
					
					break
				
				case SN_MIXINGBOX:
				
					bornHeadGoal = 0;
					bornTailGoal = 4;
					bornProbability = OABornProbability
					exhaustProb = OABornProbability
					iSize = 25
					rGGrav = 1.15
					birthPace = particleBirth_MX
					particleMax =  particleMax_MX
					
					goalProbability = new Array(1, exhaustProb, 1, 1, 1, 1, 1, 1, 1, 1);
					goalHeadGoal = new Array(1, 2, x, x, x, x, x, x, x, x)
					goalTailGoal = new Array(1, 3, 6, 7, 5, 6, 7, 8, 9, 0)
					goalPositionX = new Array(285, 290, -50, 490, 492, 495, 595, 740, 740, 320);
					goalPositionY = new Array(530, 330, 290, 297, 10, 280, 285, 285, 550, 550);
					goalFuzzyRadius = new Array(10, 36, 30, 30, 5, 36, 30, 10, 10, 10);
					goalNearRadius = new Array(25, 36, 30, 30, 5, 36, 30, 25, 25, 25);
					goalDriftStep = new Array(10, 10, 10, 10, 10, 10, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1,1,1,1,1,1,1,1,1,1);
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
					goalColorR = MXgoalColorR
					goalColorG = MXgoalColorG
					goalColorB = MXgoalColorB
					dieOnThisStep = new Array(0, 0, 1, 0, 0, 0, 0, 0, 0, 0);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 50, 2, 2, 2, 2, 2, 2, 2);
					
					
					break
							
				case SN_HC:
					
					bornProbability = 1;
					bornHeadGoal = 0;
					bornTailGoal = 0;
					iSize = 30
					rGGrav = 1.15
					birthPace = particleBirth_DEFAULT
					particleMax =  particleMax_DEFAULT
					
					goalProbability = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalHeadGoal = new Array(1, 2, 3, 0, 0, 0, 0, 0);
					goalTailGoal = new Array(1, 2, 3, 0, 0, 0, 0, 0);
					goalPositionX = new Array(-50, 340, 730, 0, 0, 0, 0, 0);
					goalPositionY = new Array(75, 105, 185, 0, 0, 0, 0, 0);
					goalFuzzyRadius = new Array(70, 70, 70, 0, 0, 0, 0, 0);
					goalNearRadius = new Array(70, 70, 70, 0, 0, 0, 0, 0);
					goalDriftStep = new Array(70, 70, 70, 10, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0, 0);
					goalColorR = HCgoalColorR 
					goalColorG = HCgoalColorG
					goalColorB = HCgoalColorB
					dieOnThisStep = new Array(0, 0, 1, 0, 0, 0, 0, 0);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2, 2);
					
					break
				
				case SN_CC:
					
					bornProbability = 1;
					bornHeadGoal = 0;
					bornTailGoal = 0;
					iSize = 30
					rGGrav = 1.15
					birthPace = particleBirth_DEFAULT
					particleMax =  particleMax_DEFAULT
		
					goalProbability = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalHeadGoal = new Array(1, 2, 3, 0, 0, 0, 0, 0);
					goalTailGoal = new Array(1, 2, 3, 0, 0, 0, 0, 0);
					goalPositionX = new Array(-50, 360, 730, 0, 0, 0, 0, 0);
					goalPositionY = new Array(115, 140, 215, 0, 0, 0, 0, 0);
					goalFuzzyRadius = new Array(70, 70, 70, 0, 0, 0, 0, 0);
					goalNearRadius = new Array(70, 70, 70, 0, 0, 0, 0, 0);
					goalDriftStep = new Array(70, 70, 70, 10, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0, 0);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalColorR = CCgoalColorR 
					goalColorG = CCgoalColorG
					goalColorB = CCgoalColorB
					dieOnThisStep = new Array(0, 0, 1, 0, 0, 0, 0, 0);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2, 2);
					
					break
				
				case SN_FILTER:
							
					bornProbability = .5;
					bornHeadGoal = 0;
					bornTailGoal = 2;
					iSize = 30
					rGGrav = 1.15
					birthPace = particleBirth_DEFAULT
					particleMax =  particleMax_DEFAULT
		
					goalProbability = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalHeadGoal = new Array(1, 2, 3, 4, 2, 2, 2, 2);
					goalTailGoal = new Array(1, 2, 3, 4, 5, 6, 7, 7);
					goalPositionX = new Array(-70, 730, -70, 730, 0, 0, 0, 0);
					goalPositionY = new Array(175, 185, 275, 245, 0, 0, 0, 0);
					goalFuzzyRadius = new Array(160, 60, 40, 60, 5, 36, 30, 10);
					goalNearRadius = new Array(30, 60, 40, 60, 5, 36, 30, 5);
					goalDriftStep = new Array(10, 10, 10, 10, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 0, 70, 0, 70, 70, 70, 0);
					goalAlphaStep = new Array(1, 1, 1, 1, 20, 10, 10, 10);
					goalDecay = new Array(0, 69, 0, 69, 0, 0, 0, 69);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 100, 1);
					goalColorR = FLTgoalColorR 
					goalColorG = FLTgoalColorG
					goalColorB = FLTgoalColorB
					dieOnThisStep = new Array(0, 1, 0, 1, 0, 0, 0, 0);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2, 2);
					
					break
				
				
				case SN_FAN:
				
					bornProbability = 1
					bornHeadGoal = 0
					bornTailGoal = 0
					iSize = 30
					rGGrav = 1.15
					birthPace = particleBirth_DEFAULT
					particleMax =  particleMax_FAN
					
					goalProbability = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalHeadGoal = new Array(1, 2, 3, 4, 5, 6, 0, 0);
					goalTailGoal = new Array(1, 2, 3, 4, 5, 6, 0, 0);
					goalPositionX = new Array(-50, 360, 370, 275, 730, 0, 0, 0);
					goalPositionY = new Array(235, 210, 290, 200, 215, 0, 0, 0);
					goalFuzzyRadius = new Array(70, 70, 20, 10, 10, 10, 0, 0);
					goalNearRadius = new Array(70, 70, 20, 10, 10, 10, 0, 0);
					goalDriftStep = new Array(70, 70, 70, 10, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0, 0);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalColorR = FANgoalColorR 
					goalColorG = FANgoalColorG
					goalColorB = FANgoalColorB
					dieOnThisStep = new Array(0, 0, 0, 0, 1, 0, 0, 0);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2, 2);
		
					//Log.info('done setting fan')
					
					break
					
				case SN_VAV:
						
					iSize = 25
					rGGrav = 1.15
					birthPace = particleBirth_DEFAULT
					particleMax =  particleMax_DEFAULT
		
					// All particles for this view will start at the same place
					bornProbability = 1;
					bornHeadGoal = 0;
					bornTailGoal = 0;
					
					goalProbability = new Array(.5, .5, 1, 1, .5, 1, 1);
					goalHeadGoal = new Array(1, 6, x, x, 5, x, x);
					goalTailGoal = new Array(4, 2, 3, 3, 6, 5, 6);
					goalPositionX = new Array(500, 500, 200, -40, 510, 750, 510);
					goalPositionY = new Array(-10, 170, 235, 235, 235, 265, 620);	
					goalFuzzyRadius = new Array(40, 40, 10, 10, 10, 10, 40);
					goalNearRadius = new Array(10, 40, 20, 10, 10, 10, 40)	
					goalDriftStep = new Array(20, 10, 10, 10, 30, 30, 30)
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1, 1, 1, 1, 1, 1, 1);
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0);
					dieOnThisStep = new Array(0, 0, 0, 1, 0, 1, 1);
					// for now we will assume color is that of mixed air (MA or SA).  
					goalColorR = VAVgoalColorR
					goalColorG = VAVgoalColorG
					goalColorB = VAVgoalColorB
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2);
					
					break
					
				
				case SN_DIFFUSER:		
				
					bornProbability = 1;
					bornHeadGoal = 0;
					bornTailGoal = 0;
					iSize = 10
					rGGrav = 1.5
					particleMax =  particleMax_DIF
					birthPace = particleBirth_DIF
					
					goalProbability = new Array(1, 1, .5, 1, 1, 1, 1, 1);
					goalHeadGoal = new Array(1, 2, 4, 5, 7, 8, 0, 0);
					goalTailGoal = new Array(1, 2, 5, 6, 7, 8, 0, 0);
					goalPositionX = new Array(560, 350, 327, 327, 227, 380, 0, 0);
					goalPositionY = new Array(95, 86, 190, 410, 450, 450, 0, 0);
					goalFuzzyRadius = new Array(20, 15, 30, 140, 140, 120, 0, 0);
					goalNearRadius = new Array(15, 15, 15, 100, 100, 100, 0, 0);
					goalDriftStep = new Array(10, 10, 20, 20, 10, 10, 10, 10);
					goalTimeSlice = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalGravity = new Array(rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav, rGGrav);
					goalAlpha = new Array(70, 70, 70, 70, 70, 70, 70, 70);
					goalAlphaStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalDecay = new Array(0, 0, 0, 0, 0, 0, 0, 0);
					goalColorStep = new Array(1, 1, 1, 1, 1, 1, 1, 1);
					goalColorR = DIFgoalColorR 
					goalColorG = DIFgoalColorG
					goalColorB = DIFgoalColorB
					dieOnThisStep = new Array(0, 0, 0, 0, 1, 1, 0, 0);
					goalSize = new Array(iSize, iSize, iSize, iSize, iSize, iSize, iSize, iSize);
					goalSizeStep = new Array(2, 2, 2, 2, 2, 2, 2, 2);
					
					break
				
				default:
					Logger.warn("#PE: initScene(): unrecognized system node: " + iScene)
					
			}
			
		}

		
		
		public function animate():void
		{
			Logger.info("PE: animate()")
			Logger.info("#count: "+ count + " birthPace: " + birthPace + " particleAlive: " + particleAlive + " particleMax: "+ particleMax)
			count++;
			while( (engineRun) && (count > birthPace) && (particleAlive < particleMax) )
			{
				Logger.info("#PE: animate() adding particle #: " + serialNumber)
				serialNumber++;
		
				var particle:Particle = new Particle (this, serialnumber)
				particle.cacheAsBitmap = true	
				this.addChild(particle)
		
				var flip:Number
				if (Math.random() > bornProbability)		
				{
					flip = bornHeadGoal;
				}
				else
				{
					flip = bornTailGoal;
				}
				
				var angle:Number = Math.random() * (2 * Math.PI);
				var distance:Number = Math.random() * (goalFuzzyRadius[flip] - 1);
				particle.x = goalPositionX[flip] + (distance * Math.cos(angle));
				particle.y = goalPositionY[flip] + (distance * Math.sin(angle));
				
				if (Math.random() > goalProbability[flip])
				{
					particle.goal = goalHeadGoal[flip];
				}
				else
				{
					particle.goal = goalTailGoal[flip];
				}
		
		
				angle = Math.random() * (2 * Math.PI);
				distance = Math.random() * (goalFuzzyRadius[particle.goal] - 1);
				particle.targetx = goalPositionX[particle.goal] + (distance * Math.cos(angle));
				particle.targety = goalPositionY[particle.goal] + (distance * Math.sin(angle));
						
				// set alpha
				//particle.alpha = 0;
				//particle.alphadelta = goalAlpha[flip] / goalAlphaStep[flip];
				//particle.alphasteps = goalAlphaStep[flip];
		
				// set decay
				particle.decay = goalDecay[flip];
										
				// If bColorChange is "True" than call function to change color
				if (bColorChange)
				{
					changeColor(particle, flip);
				}
						
				// set new approach to size
				particle.width = particleSize;
				particle.height = particleSize;		
				
				// If boolean "bSizeChange" is "true" call function to incrementally change size
				if (bSizeChange)
				{
					changeSize(particle, flip);
				}
					
				// set drift
				particle.driftsteps = goalDriftStep[particle.goal];
				particle.driftcount = 0;
				
				// set timeslice
				particle.slicenow = 0;
				particle.slicemax = goalTimeSlice[flip];
				
				particle.vx = 0;
				particle.vy = 0;
				
				particleAlive++;
				
				count = 0;
				
			}
		
			
		}
		
		
		
		public function changeColor(particle:Particle, flip:Number)
		{ 
			particle.colorsteps = 0
			
			var myColorTransform:ColorTransform = new ColorTransform()
			myColorTransform.redOffset = goalColorR[flip]
			myColorTransform.greenOffset = goalColorG[flip]
			myColorTransform.blueOffset = goalColorB[flip]
			
			particle.transform.colorTransform =  myColorTransform
		}
		
		public function changeSize(particle:Particle, flip:Number)
		{
			particle.width = goalSize[flip];
			particle.height = goalSize[flip];
			particle.sizedelta = 0;//(goalSize[particle.goal] - goalSize[flip]) / goalSizeStep[particle.goal];
			particle.sizesteps = 0;//goalSizeStep[particle.goal];
		}
		
		

	}
}

