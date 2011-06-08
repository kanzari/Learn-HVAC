package com.mcquilleninteractive.learnhvac.model
{	
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class WatchListModel
	{
		[Bindable]
		public var data : ArrayCollection;
		
		public function WatchListModel()
		{
			data = new ArrayCollection();
		}
		
		public function add(systemVariable : SystemVariable) : void {
			
			data.addItem(systemVariable);
			
		}
		
	}
}