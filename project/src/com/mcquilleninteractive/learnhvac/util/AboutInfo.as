package com.mcquilleninteractive.learnhvac.util
{
	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import mx.core.FlexGlobals;
	
	import mx.core.FlexGlobals;
	
	public class AboutInfo
	{
		
		/* TODO: implement this class so that it grabs version and name info from AIR (if this is an AIR app) or from MDM (if this is a zinc app) */
		
		public static var applicationName:String = "LearnHVAC"
		private static var applicationVersionString:String = ""
			
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
				
		

	}
}