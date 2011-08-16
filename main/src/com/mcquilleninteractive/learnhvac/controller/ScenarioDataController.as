package com.mcquilleninteractive.learnhvac.controller
{
	import com.mcquilleninteractive.learnhvac.event.ShortTermSimulationEvent;
	import com.mcquilleninteractive.learnhvac.event.UnitsEvent;
	import com.mcquilleninteractive.learnhvac.model.*;
	import com.mcquilleninteractive.learnhvac.model.data.ZoneEnergyUseDataPoint;
	import com.mcquilleninteractive.learnhvac.util.Logger;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import flash.events.IEventDispatcher;
	import org.swizframework.controller.AbstractController;


	import com.mcquilleninteractive.learnhvac.event.WatchListEvent;
	
	
	public class ScenarioDataController  extends AbstractController 
	{		
		
		[Inject] 
		public var scenarioModel:ScenarioModel	
		
		[Inject] 
		public var scenarioDataModel:ScenarioDataModel	
				
		[Inject] 
		public var longTermSimulationModel:LongTermSimulationModel	
				
		[Inject] 
		public var longTermSimulationDataModel:LongTermSimulationDataModel	
		
		[Inject] 
		public var shortTermSimulationDataModel:ShortTermSimulationDataModel	
		
		[Inject] 
		public var shortTermSimulationModel:ShortTermSimulationModel	
				
		
		public function ScenarioDataController()
		{
		}
		
		
		
		/** 
		 *  update the zone energy data when new data comes in from either short or long term simulations
		 *  (or other event that affects data, such as units change)
		 */
		
		/*
		[Mediate(event="UnitsEvent.UNITS_CHANGED")]	
		[Mediate(event="ShortTermSimulationEvent.SIM_OUTPUT_RECEIVED")]		
		public function onUpdateZoneEnergy(event:Event):void
		{	
			var importingFromRun:String = scenarioModel.importLongTermVarsFromRun
			
			if (importingFromRun == ScenarioModel.LT_IMPORT_NONE)
			{
				return 
			}
			
			if (longTermSimulationDataModel.runLoaded(importingFromRun)==false)
			{
				return
			}
			
			var energyPlusData:EnergyPlusData = longTermSimulationDataModel.getEnergyPlusData(importingFromRun)
			
			
			var vavRhcQd:Number = 0
			var lightingPeakLoad:Number = longTermSimulationModel.lightingPeakLoad
			var equipPeakLoad:Number = 0
			var zoneSize:Number = longTermSimulationModel.getCurrentZoneSize()		
			
			scenarioDataModel.calculateZoneEnergyUse(importingFromRun, vavRhcQd, lightingPeakLoad, equipPeakLoad, zoneSize)	
				
		}*/
		
		
		
		
		[Mediate(event="ShortTermSimulationEvent.SIM_STOP")]		
		public function onSimStop(event:Event):void
		{
			scenarioDataModel.clearZoneEnergyUse()
		}
		

		
		
		
	}
}