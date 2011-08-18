
import com.mcquilleninteractive.learnhvac.event.ApplicationEvent;
import com.mcquilleninteractive.learnhvac.util.Logger;
import com.mcquilleninteractive.learnhvac.model.ApplicationModel;

import flash.filesystem.*;
import mx.logging.Log;
import flash.events.IEventDispatcher;
import mx.controls.Alert;
import flash.display.Screen;
import flash.geom.Rectangle;
import flash.events.Event;

/*************** lifecycle event handlers *****************/

[Dispatcher]
public var dispatcher:IEventDispatcher;

private function onPreInit():void
{		
	Log.addTarget(traceTarget);
	//Logger.debug("onPreInit()",this);
	dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT_APP, true));
	
	

//	Alert.show( "This is a test" );
}


protected function onAddedToStage(event:Event):void
{
	if (ApplicationModel.debugMode) {
		var screen:Screen = Screen.screens[0];
		this.move(screen.visibleBounds.left + 1400, screen.visibleBounds.top + 100);
	}
	
}

private function onAppComplete():void
{
	dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.START_APP, true))	
}


/*************** event handlers *****************/

/*
private function onUncaughtError(e:UncaughtErrorEvent):void
{
    if (e.error is Error)
    {
        var error:Error = e.error as Error;
        Logger.error("Uncaught Error: " + error.errorID + " name: " + error.name + " message " + error.message, this);
    }
    else
    {
        var errorEvent:ErrorEvent = e.error as ErrorEvent;
        Logger.error("Uncaught Error: errorEvent.errorID: " + errorEvent.errorID, this);
    }
}
*/



