package com.mcquilleninteractive.learnhvac.event{
	
	import com.mcquilleninteractive.learnhvac.model.data.IGraphDataModel;
	import com.mcquilleninteractive.learnhvac.util.Logger
	import flash.events.Event;

	public class ScenarioDataLoadedEvent extends Event
	{
						
		
		public static const ENERGY_PLUS_FILE_LOADED : String = "EnergyPlusFileLoaded"; // loaded but not parsed
		public static const ENERGY_PLUS_RESULTS_PARSED : String = "EnergyPlusResultsParsed"; // parsed

		public static const MODELICA_SYSVARS_LOADED : String = "ModelicaSysVarsLoaded";// loaded but not parsed
		public static const MODELICA_RESULTS_PARSED : String = "ModelicaDataParsed";// loaded but not parsed
		
		public var graphDataModelID:String
		public var graphDataModel:IGraphDataModel

		public function ScenarioDataLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
        {
            return new ScenarioDataLoadedEvent(this.type, this.bubbles, this.cancelable );
        }
		     	
	}
	
}