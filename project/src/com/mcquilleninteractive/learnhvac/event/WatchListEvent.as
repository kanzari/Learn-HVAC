package com.mcquilleninteractive.learnhvac.event{
	
	import flash.events.Event;
	import com.mcquilleninteractive.learnhvac.model.SystemVariable;
	
	public class WatchListEvent extends Event
	{
		
		public static const ADD: String = "Add";
		public static const REMOVE: String = "Remove";
		public static const UPDATE: String = "Update";
		
		public var systemVariable:SystemVariable

		
		public function WatchListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new WatchListEvent(this.type, this.bubbles, this.cancelable );
		}
		
	}
	
}