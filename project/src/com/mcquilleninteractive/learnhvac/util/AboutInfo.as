package com.mcquilleninteractive.learnhvac.util
{
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import mx.core.FlexGlobals;

	
	public class AboutInfo
	{
		
		/* TODO: implement this class so that it grabs version and name info from AIR (if this is an AIR app) or from MDM (if this is a zinc app) */
		
		public static var applicationName:String = "LearnHVAC"
		private static var applicationVersionString:String = ""
			
		private static var _appVersion:Version;
		private static var _minimumScerioVersion:Version;
		
		//if a scerio was created in a version of Learn Hvac before this, 
		//this it cannot be loaded
		private static const _minimumScenerioVersionStr:String = "2.0.2";

		
			
		public function AboutInfo()
		{
		
			
		}
	
		public static function get applicationVersion():String
		{
			//var appXML:XML = NativeApplication.nativeFlexGlobals.topLevelApplicationDescriptor
			
			if (applicationVersionString == "") {
				
				var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
				var air:Namespace = appXML.namespaceDeclarations()[0]
				var version:String = appXML.air::version
				
				if (version.indexOf("v")==0) version = version.substr(1)
				applicationVersionString = version;
			} 
			
			return applicationVersionString;

		}
		
		
		public static function get flashPlayerVersion():String
		{
			return Capabilities.version.toString()
		}
		
		public static function get minimumScenerioVersionStr():String
		{
			return _minimumScenerioVersionStr
		}
		
		public static function canParseScenarioVersion(scenerioVersion : String):Boolean
		{
			if (_appVersion == null) {
				_appVersion = new Version (applicationVersion);
			}
				
			if (_minimumScerioVersion == null) {
				_minimumScerioVersion = new Version (_minimumScenerioVersionStr);
			}
			
			var scererioWasCreatedWithVersion : Version = new Version (scenerioVersion);
			
			if (_minimumScerioVersion.major > scererioWasCreatedWithVersion.major ||	
				_minimumScerioVersion.minor > scererioWasCreatedWithVersion.minor ||
				_minimumScerioVersion.maintenance > scererioWasCreatedWithVersion.maintenance)
			{
				return false;
			} else {
				return true;
			}

		}
				

	}
}