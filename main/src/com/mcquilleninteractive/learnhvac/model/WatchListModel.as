package com.mcquilleninteractive.learnhvac.model
{	
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class WatchListModel
	{

		public var data : ArrayCollection;
		public var watchNames : Array = []//keep this array of sysVarNames just to prevent multiple instances of same name
			
		public function WatchListModel()
		{
			data = new ArrayCollection();
		}
		
		public function add(systemVariable : SystemVariable) : void {
			
			//if the var has already been added, then do nothing
			if (watchNames[systemVariable.name] == null || watchNames[systemVariable.name] == false) {
				watchNames[systemVariable.name] = true;
				data.addItem(systemVariable);
			}
				
		}
		
		public function removeItems(removeItemsIndices : Array) : void {
			
			//if the var has already been added, then do nothing
			//if (watchNames[systemVariable.name] != null && watchNames[systemVariable.name] == true) {
				
				
				//TODO actually remove
			//	watchNames[systemVariable.name] = false;

		//}
			//
	//	}
			
			// remove selected items
			for (var i:Number = 0; i < removeItemsIndices.length; i++) {
				data.removeItemAt(removeItemsIndices[i]);

			} 
				
				
		}
		
	}
}