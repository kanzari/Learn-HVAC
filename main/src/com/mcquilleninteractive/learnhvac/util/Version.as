package com.mcquilleninteractive.learnhvac.util
{
	public class Version
	{
		private var _major:int;
		private var _minor:int;
		private var _maintenance:int;
			
		
		public function get major():int
		{
			return _major;
		}
		public function get minor():int
		{
			return _minor;
		}
		public function get maintenance():int
		{
			return _maintenance;
		}
		
		
		
		public function Version(scenerioVersion : String)
		{
			var scenerioAry : Array = scenerioVersion.split('.');
			
			if (scenerioAry.length < 3) {
				throw new Error('unexpected verion format');
			} else {
				_major = int(scenerioAry[0]);
				_minor = int(scenerioAry[1]);
				_maintenance = int(scenerioAry[2]);	
				
			}
			
		}
	}
}