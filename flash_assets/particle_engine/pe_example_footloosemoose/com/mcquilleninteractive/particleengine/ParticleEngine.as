package com.mcquilleninteractive.particleengine
{
	
	import com.mcquilleninteractive.particleengine.ParticleManager
	import com.mcquilleninteractive.particleengine.Particle
	import mx.display.Sprite
		
	class ParticleEngine extends Sprite
	{
		
		public var ADMIN_DISABLE:Boolean = false //controlled by user via admin panel on output panel
		public var running:Boolean = false
		public var currUnits:String 
		public var UNITS_IP:String = "IP"
		public var UNITS_SI:String= "SI"
		
		private var particleMax_SYS = 170
		private var particleBirth_SYS = 10
		private var particleMax_MX = 120
		private var particleBirth_MX = 2
		private var particleMax_FAN = 120
		private var particleMax_DIF = 70
		private var particleBirth_DIF = 2
		private var particleMax_DEFAULT = 50
		private var particleBirth_DEFAULT = 1
		
		private var birthPace:Number
		private var particleMax:Number
					
		public function ParticleEngine() 
		{
			super()
			ParticleManager.getInstance().init(this)
		}
		
		///////////////////////////////
		// Public Functions
		///////////////////////////////

		public function setScene(systemNode:String):void
		{
			stopAnim()
			iScene = systemNode
			if (running)
			{
				startPE()
			}
		}

		public function startPE(){
			
			trace("#PE: startPE()")
			if (ADMIN_DISABLE) return
			initScene(iScene)
			running = true
			if (iScene == SN_ROOF) return
			this.visible = true
			addEventListener(Event.ENTER_FRAME, animate)
		}

		public function stopPE(){
			trace("#PE: stopPE()")
			running = false
			this.visible = false
			stopAnim()
		}

		public function switchUnits(units:String)
		{
			currUnits = units
		}

		public function setParticleAnimation(evt:Object)
		{
			// event object is expected to have the following properties
			//    - evt.setting property of "full", "reduced" or "none"
			//    - evt.currAHUStatus property with value of "AHUon" "AHUoff" or "AHUpaused"
		
			trace("#PE: setting particle anim to : " + evt.setting + " currAHUStatus: "+ evt.currAHUStatus)
	
			if (evt.setting == "full" || evt.setting=="reduced")
			{
	
				if (evt.setting=="full")
				{
					particleMax_SYS = 170
					particleBirth_SYS = 10
					particleMax_MX = 120
					particleBirth_MX = 2
					particleMax_FAN = 120
					particleMax_DIF = 70
					particleBirth_DIF = 2
					particleMax_DEFAULT = 50
					particleBirth_DEFAULT = 1
					ADMIN_DISABLE = false
				}
				else
				{
					particleMax_SYS = 90
					particleBirth_SYS = 20
					particleMax_MX = 60
					particleBirth_MX = 5
					particleMax_FAN = 60
					particleMax_DIF = 35
					particleBirth_DIF = 5
					particleMax_DEFAULT = 25
					particleBirth_DEFAULT = 5
					ADMIN_DISABLE = false
				}
		
				switch (iScene)
				{
					case CONST.SN_SYSTEM:
						birthPace = particleBirth_SYS
						particleMax = particleMax_SYS
						break	
					case CONST.SN_MIXINGBOX:
						birthPace = particleBirth_MX
						particleMax = particleMax_MX
						break
					case CONST.SN_FAN:
						birthPace = particleBirth_DEFAULT
						particleMax = particleMax_MX
						break
					case CONST.SN_DIFFUSER:
						birthPace = particleBirth_DIF
						particleMax = particleMax_DIF
						break
					case CONST.SN_FILTER:
					case CONST.SN_HC:		
					case CONST.SN_CC:
					case CONST.SN_FILTER: 	
					case CONST.SN_VAV:
					case CONST.SN_ROOF:
					case CONST.SN_SYSTEM:
					default:
						birthPace = particleBirth_DEFAULT
						particleMax = particleMax_DEFAULT
					
				}
			
				if (running == false && (evt.currAHUStatus == CONST.AHU_RUNNING))
				{
					startPE()
				}
		
			
			}
			else
			{
				//assume "none"
				stopPE()
				ADMIN_DISABLE = true
			}
		}

		
		///////////////////////////////
		// INTERNAL Functions
		///////////////////////////////

		
		private function stopAnim()
		{
			removeEventListener(Event.ENTER_FRAME, animate);
			ParticleManager.getInstance().removeAllParticles()
		}

function initPE()
{
	running = false
	currUnits = "IP"
	 	
	sysVarsArr = []	
	//Make accessing constants a little more convenient
	
	SN_HC = "HC" 			//Heating Coil
	SN_CC = "CC"			//Cooling Coil
	SN_FAN = "Fan"			//This is lower case because for some reason the SPARK variables have lowercase Fan
	SN_FILTER = "Flt"		//This is lower case because for some reason the SPARK variables have lowercase Flt
	SN_MIXINGBOX = "MX"	
	SN_VAV = "VAV"
	SN_DIFFUSER = "DIF"
	SN_ROOF = "RF"			//Roof view -- three-quarters view
	SN_SYSTEM = "SYS"		//System view -- entire system is visible in head-on view
	SN_SPARK = "SPK"		//System view -- entire system is visible in head-on view
	
	//particle max and birth settings
	particleMax_SYS = 170
	particleBirth_SYS = 10
	particleMax_MX = 120
	particleBirth_MX = 2
	particleMax_FAN = 120
	particleMax_DIF = 70
	particleBirth_DIF = 2
	particleMax_DEFAULT = 50
	particleBirth_DEFAULT = 1	
	ADMIN_DISABLE = false
	
	//init variables
	count = 0
	
	masks = []
	masks[SN_MIXINGBOX] = maskMIXINGBOX
	masks[SN_HC] = maskHC
	masks[SN_CC] = maskCC
	masks[SN_FAN] = maskFAN
	masks[SN_FILTER] = maskFILTER
	masks[SN_VAV] = maskVAV
	masks[SN_DIFFUSER] = maskDIFFUSER
	masks[SN_SYSTEM] = maskSYSTEM
	
	
	//hide masks
	for (var i in masks)
	{
		masks[i]._visible = false
	}
	
	initColors()
	initVars()
}
	
	
	
	
function setSysVar(sysVarName, sysVarValue)
{
	
	if (sysVarsArr[sysVarName]== undefined)
	{
		sysVarsArr[sysVarName] = sysVarValue
	}	
	
	if (sysVarValue==null || sysVarValue == undefined || isNaN(sysVarValue))
	{
		return
	}
	
	colorObj = getColorObject(sysVarValue)
	sysVarsArr[sysVarName] = colorObj
	 
	switch(sysVarName)
	{
		
		case "MXRAPosDamperReal":
			if (iScene == SN_MIXINGBOX)
			{
				// Both Mixing Box and System View
				trace("#PE: setting MXRAPosDamperReal to : " + sysVarValue)
				trace("#PE: setting MXRAPosDamperReal to : " + sysVarValue)
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
				HCgoalColorR[0] = sysVarsArr["HCTAirEnt"].r
				HCgoalColorG[0] = sysVarsArr["HCTAirEnt"].g
				HCgoalColorB[0] = sysVarsArr["HCTAirEnt"].b
				
				//set the temp for the filter here to as it will be the same value
				for (i=0; i<4;i++)
				{
					FLTgoalColorR[i] = sysVarsArr["HCTAirEnt"].r
				    FLTgoalColorG[i] = sysVarsArr["HCTAirEnt"].g
					FLTgoalColorB[i] = sysVarsArr["HCTAirEnt"].b				
				}
			}
			break
				
		case "HCTAirLvg":
			if (iScene == SN_HC || iScene == SN_SYSTEM)
			{
				HCgoalColorR[1] = sysVarsArr["HCTAirLvg"].r
				HCgoalColorG[1] = sysVarsArr["HCTAirLvg"].g
				HCgoalColorB[1] = sysVarsArr["HCTAirLvg"].b
				
				//system view
				SYSgoalColorR[3] = sysVarsArr["HCTAirLvg"].r
				SYSgoalColorG[3] = sysVarsArr["HCTAirLvg"].g
				SYSgoalColorB[3] = sysVarsArr["HCTAirLvg"].b		
			}
			break
			
		case "CCTAirEnt":
			if (iScene==SN_CC)
			{
				//change first half of CC
				CCgoalColorR[0] = sysVarsArr["CCTAirEnt"].r
				CCgoalColorG[0] = sysVarsArr["CCTAirEnt"].g
				CCgoalColorB[0] = sysVarsArr["CCTAirEnt"].b
			}
			break
			
		case "CCTAirLvg":
			if (iScene == SN_CC || iScene == SN_SYSTEM)
			{
				//change second half of CC
				CCgoalColorR[1] = sysVarsArr["CCTAirLvg"].r
				CCgoalColorG[1] = sysVarsArr["CCTAirLvg"].g
				CCgoalColorB[1] = sysVarsArr["CCTAirLvg"].b
			
				//system view
				SYSgoalColorR[4] = sysVarsArr["CCTAirLvg"].r
				SYSgoalColorG[4] = sysVarsArr["CCTAirLvg"].g
				SYSgoalColorB[4] = sysVarsArr["CCTAirLvg"].b		
			}
			break
			
		case "FanTAirEnt":
			if (iScene == SN_FAN)
			{
				for (var i=0;i<=5;i++)
				{
					FANgoalColorR[i] = sysVarsArr["FanTAirEnt"].r
					FANgoalColorG[i] = sysVarsArr["FanTAirEnt"].g
					FANgoalColorB[i] = sysVarsArr["FanTAirEnt"].b
				}
			}
			break
			
		case "FanTAirLvg":
			if (iScene == SN_FAN || iScene == SN_SYSTEM)
			{
				FANgoalColorR[i] = sysVarsArr["FanTAirLvg"].r
				FANgoalColorG[i] = sysVarsArr["FanTAirLvg"].g
				FANgoalColorB[i] = sysVarsArr["FanTAirLvg"].b
				for (i=5;i<=7;i++)
				{
					SYSgoalColorR[i] = sysVarsArr["FanTAirLvg"].r
					SYSgoalColorG[i] = sysVarsArr["FanTAirLvg"].g
					SYSgoalColorB[i] = sysVarsArr["FanTAirLvg"].b	
				}
			}
			break
			
		case "MXTRet":
			if (iScene == SN_MIXINGBOX)
			{
				//change first third of CC
				for (i=0;i<2;i++)
				{
					MXgoalColorR[i] = sysVarsArr["MXTRet"].r
					MXgoalColorG[i] = sysVarsArr["MXTRet"].g
					MXgoalColorB[i] = sysVarsArr["MXTRet"].b
				}
				MXgoalColorR[2] = sysVarsArr["MXTRet"].r
				MXgoalColorG[2] = sysVarsArr["MXTRet"].g
				MXgoalColorB[2] = sysVarsArr["MXTRet"].b
				
				MXgoalColorR[9] = sysVarsArr["MXTRet"].r
				MXgoalColorG[9] = sysVarsArr["MXTRet"].g
				MXgoalColorB[9] = sysVarsArr["MXTRet"].b
			}
			break
			
		case "MXTOut":
			if (iScene == SN_MIXINGBOX)
			{
				//change second third of CC
				MXgoalColorR[4] = sysVarsArr["MXTOut"].r
				MXgoalColorG[4] = sysVarsArr["MXTOut"].g
				MXgoalColorB[4] = sysVarsArr["MXTOut"].b
			}
			break
			
		case "MXTmix":
			if (iScene == SN_MIXINGBOX || iScene == SN_SYSTEM)
			{
				//change final third of CC
				MXgoalColorR[3] = sysVarsArr["MXTmix"].r
				MXgoalColorG[3] = sysVarsArr["MXTmix"].g
				MXgoalColorB[3] = sysVarsArr["MXTmix"].b
				MXgoalColorR[5] = sysVarsArr["MXTmix"].r
				MXgoalColorG[5] = sysVarsArr["MXTmix"].g
				MXgoalColorB[5] = sysVarsArr["MXTmix"].b
				MXgoalColorR[6] = sysVarsArr["MXTmix"].r
				MXgoalColorG[6] = sysVarsArr["MXTmix"].g
				MXgoalColorB[6] = sysVarsArr["MXTmix"].b
				
				//set color for system level view
				SYSgoalColorR[2] = sysVarsArr["MXTmix"].r
				SYSgoalColorG[2] = sysVarsArr["MXTmix"].g
				SYSgoalColorB[2] = sysVarsArr["MXTmix"].b		
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
				for (i = 0; i<=6; i++)
				{
					if (i==2 || i ==3) continue
					VAVgoalColorR[i] = sysVarsArr["VAVHCTAirEnt"].r
					VAVgoalColorG[i] = sysVarsArr["VAVHCTAirEnt"].g
					VAVgoalColorB[i] = sysVarsArr["VAVHCTAirEnt"].b
				}
			}
			break
			
		case "VAVHCTAirLvg":
			if (iScene == SN_VAV || iScene == SN_DIFFUSER || iScene == SN_SYSTEM)
			{
				VAVgoalColorR[2] = sysVarsArr["VAVHCTAirLvg"].r
				VAVgoalColorG[2] = sysVarsArr["VAVHCTAirLvg"].g
				VAVgoalColorB[2] = sysVarsArr["VAVHCTAirLvg"].b
				
				VAVgoalColorR[3] = sysVarsArr["VAVHCTAirLvg"].r
				VAVgoalColorG[3] = sysVarsArr["VAVHCTAirLvg"].g
				VAVgoalColorB[3] = sysVarsArr["VAVHCTAirLvg"].b
				
				//system view
				for (i=8; i<10;i++)
				{
					SYSgoalColorR[i] = sysVarsArr["VAVHCTAirLvg"].r
					SYSgoalColorG[i] = sysVarsArr["VAVHCTAirLvg"].g
					SYSgoalColorB[i] = sysVarsArr["VAVHCTAirLvg"].b		
				}
			
				//diffuser view
				DIFgoalColorR[0] = DIFgoalColorR[1] = sysVarsArr["VAVHCTAirLvg"].r
				DIFgoalColorG[0] = DIFgoalColorG[1] = sysVarsArr["VAVHCTAirLvg"].g
				DIFgoalColorB[0] = DIFgoalColorB[1] = sysVarsArr["VAVHCTAirLvg"].b	
			}
			break
			
		case "TRoom":
			if (iScene == SN_DIFFUSER || iScene == SN_SYSTEM)
			{
				//system view
				SYSgoalColorR[1] = sysVarsArr["TRoom"].r
				SYSgoalColorG[1] = sysVarsArr["TRoom"].g
				SYSgoalColorB[1] = sysVarsArr["TRoom"].b		
	
				for (i=10; i<15;i++)
					{
					SYSgoalColorR[i] = sysVarsArr["TRoom"].r
					SYSgoalColorG[i] = sysVarsArr["TRoom"].g
					SYSgoalColorB[i] = sysVarsArr["TRoom"].b		
				}
				
				//diffuser view
				DIFgoalColorR[2] = sysVarsArr["TRoom"].r
				DIFgoalColorG[2] = sysVarsArr["TRoom"].g
				DIFgoalColorB[2] = sysVarsArr["TRoom"].b		
				
				DIFgoalColorR[4] = sysVarsArr["TRoom"].r
				DIFgoalColorG[4] = sysVarsArr["TRoom"].g
				DIFgoalColorB[4] = sysVarsArr["TRoom"].b		
			}
		
			break
			
		case "TAirOut":
			if (iScene == SN_SYSTEM)
			{
				//system view
				SYSgoalColorR[0] = sysVarsArr["TAirOut"].r
				SYSgoalColorG[0] = sysVarsArr["TAirOut"].g
				SYSgoalColorB[0] = sysVarsArr["TAirOut"].b		
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

function getColorObject(p_temp:Number):Object{
			
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
	
	
		r = Math.round(r)
		g = Math.round(g)
		b = Math.round(b)
	
		var o:Object = new Object()
		o.r = r
		o.g = g
		o.b = b
		
		return o
		
	
}
	


function initVars()
{
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
function initColors()
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



function initScene(iScene:String){
	
	
	count = 0
	particleAlive = 0 
	iTimeS = 1
	serialNumber = 0
	engineRun = true
	bColorChange = true
	bSizeChange  = true
		
	switch(iScene){
		
		case CONST.SN_SYSTEM:
			
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
		
		case CONST.SN_MIXINGBOX:
		
			bornHeadGoal = 0;
			bornTailGoal = 4;
			bornProbability = OABornProbability
			exhaustProb = OABornProbability
			iSize = 25
			rGGrav = 1.15
			trace("initScene: setting birthPace to " + particleBirth_MX)
			birthPace = particleBirth_MX
			trace("initScene: birthPace now: " + birthPace)
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
					
		case CONST.SN_HC:
			
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
		
		case CONST.SN_CC:
			
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
		
		case CONST.SN_FILTER:
					
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
		
		
		case CONST.SN_FAN:
		
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

			//trace('done setting fan')
			
			break
			
		case CONST.SN_VAV:
				
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
			
		
		case CONST.SN_DIFFUSER:		
		
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
			trace("#PE: initScene(): unrecognized system node: " + iScene)
			
	}
	
}

		
		
function animate(){
	
	count++; 
		
	while( (engineRun) && (count > birthPace) && (particleAlive < particleMax) )
	{
		serialNumber++;

		trace("serialNumber: " + serialNumber )
		
		var initObj = new Object()
				
		//particle.mycolor = new Color(particle);		

		if (Math.random() > bornProbability)		
		{
			flip = bornHeadGoal;
		}
		else
		{
			flip = bornTailGoal;
		}
		
		angle = Math.random() * (2 * Math.PI);
		distance = Math.random() * (goalFuzzyRadius[flip] - 1);
		initObj.xPos = goalPositionX[flip] + (distance * Math.cos(angle));
		initObj.yPos= goalPositionY[flip] + (distance * Math.sin(angle));
		initObj.goalGravity = goalGravity
		initObj.goalNearRadius = goalNearRadius
		initObj.goalTail = goalTail
		initObj.dieOnThisStep = dieOnThisStep
		initObj.goalFuzzyRadius = goalFuzzyRadius
		initObj.goalProbability = goalProbability
		initObj.goalPositionX = goalPositionX
		initObj.goalPositionY = goalPositionY
		initObj.goalDriftStep = goalDriftStep
		
		if (Math.random() > goalProbability[flip])
		{
			initObj.goal =  goalHeadGoal[flip];
		}
		else
		{
			initObj.goal =  goalTailGoal[flip];
		}

		angle = Math.random() * (2 * Math.PI);
		distance = Math.random() * (goalFuzzyRadius[initObj.goal] - 1);
		initObj.targetx = goalPositionX[initObj.goal] + (distance * Math.cos(angle));
		initObj.targety = goalPositionY[initObj.goal] + (distance * Math.sin(angle));
				
		// set alpha
		//particle._alpha = 0;
		//particle.alphadelta = goalAlpha[flip] / goalAlphaStep[flip];
		//particle.alphasteps = goalAlphaStep[flip];

		// set decay
		//particle.decay = goalDecay[flip];
								
		// If bColorChange is "True" than call function to change color
		//if (bColorChange)
		//{
			//ChangeColor();
		//}
				
		// set new approach to size
		//particle._width = particleSize;
		//particle._height = particleSize;		
		// particle._width = sizeBorn;
		// particle._height = sizeBorn;		
		
	
		// If boolean "bSizeChange" is "true" call function to incrementally change size
		//if (bSizeChange)
		//{
			//ChangeSize();
		//}
			
		// set drift
		//particle.driftsteps = goalDriftStep[particle.goal];
		//particle.driftcount = 0;
		
		// set timeslice
		//particle.slicenow = 0;
		//particle.slicemax = goalTimeSlice[flip];
		
		//particle.vx = 0;
		//particle.vy = 0;
				
		ParticleManager.createParticle(1, initObj)
		
	}
}




initPE()


setScene(SN_MIXINGBOX)
startPE()

var testPics = []
testPics[SN_FAN] = pFAN
testPics[SN_HC] = pHC
testPics[SN_CC] = pCC
testPics[SN_MIXINGBOX] = pMIXINGBOX
testPics[SN_SYSTEM] = pSYSTEM
testPics[SN_FILTER] = pFILTER
testPics[SN_VAV] = pVAV
testPics[SN_DIFFUSER] = pDIFFUSER

function setTestPic(node)
{
	for (var i in testPics)
	{
		trace('setting text pick: ' + testPics[i])
		testPics[i]._visible = false
	}
	testPics[node]._visible = true
}

btnUpdateMX.onRelease = function()
{
	trace('updating MX')
	i = i + .1
	if (i>1) i=0;
	setSysVar("MXRAPosDamperReal", i)
	
}
btnStart.onRelease = function()
{
	setScene(SN_MIXINGBOX)
	setTestPic(SN_MIXINGBOX)
	startPE()
}
btnMIXINGBOX.onRelease = function()
{
	setTestPic(SN_MIXINGBOX)
	setScene(SN_MIXINGBOX)
}
btnHC.onRelease = function()
{
	setTestPic(SN_HC)
	setScene(SN_HC)
}
btnCC.onRelease = function()
{
	setTestPic(SN_CC)
	setScene(SN_CC)
}
btnFAN.onRelease = function()
{
	setTestPic(SN_FAN)
	setScene(SN_FAN)
}
btnSYSTEM.onRelease = function()
{
	setTestPic(SN_SYSTEM)
	setScene(SN_SYSTEM)
}
btnDIFFUSER.onRelease = function()
{
	setTestPic(SN_DIFFUSER)
	setScene(SN_DIFFUSER)
}
btnVAV.onRelease = function()
{
	setTestPic(SN_VAV)
	setScene(SN_VAV)
}
btnFILTER.onRelease = function()
{
	setTestPic(SN_FILTER)
	setScene(SN_FILTER)
}



		
	}
	
}