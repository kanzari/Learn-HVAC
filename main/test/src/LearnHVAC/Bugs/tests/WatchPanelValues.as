package LearnHVAC.Bugs.tests{
    import BaseClass;

    import com.gorillalogic.flexmonkey.core.MonkeyTest;
    import com.gorillalogic.flexmonkey.monkeyCommands.*;
    import com.gorillalogic.flexmonkey.application.VOs.AttributeVO;
    import com.gorillalogic.flexmonkey.events.MonkeyCommandRunnerEvent;

    import mx.collections.ArrayCollection;

    public class WatchPanelValues extends BaseClass {
        public function WatchPanelValues(){
            super();
        }

        private var mtLogin as user 'guest':MonkeyTest = new MonkeyTest('Login as user 'guest'', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Input', 'username', 'automationName', ['guest'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'btnLogin', 'id', [''], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify Basic Scenerio', null, '_SelectScenarioItemRenderer_Label1', 'id', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', 'Basic Scenario')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Click', 'Open Scenario', 'automationName', [null], '', '', '10', '500'),
                new PauseMonkeyCommand(3200)
            ]));

        private var mtLogin as user 'guest'TimeoutTime:int = 34200;

        [Test]
        public function Login as user 'guest'():void{
            beforeTest("WatchPanelValues","Login as user 'guest'");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogin as user 'guest', mtLogin as user 'guest'Complete, mtLogin as user 'guest'TimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogin as user 'guest'Complete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogin as user 'guest');
            afterTest("WatchPanelValues","Login as user 'guest'");
        }

        private var mtCheck Watch Panel:MonkeyTest = new MonkeyTest('Check Watch Panel', 0,
            new ArrayCollection([
                new VerifyMonkeyCommand('New Verify', null, 'btnStartStop', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('enabled', null, 'property', 'true')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Click', 'btnStartStop', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'Open watch panel', 'automationName', [null], '', '', '10', '500'),
                new PauseMonkeyCommand(100),
                new VerifyMonkeyCommand('Verify that the Watch Table is there', null, 'dgWatchVariables', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('automationName', null, 'property', 'dgWatchVariables')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Change', 'tabBar', 'automationName', ['INPUTS'], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify Room Temp TextInput field is enabled', null, 'txtInputItem_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('enabled', null, 'property', 'true')
                    ]), null, null, true, '500', '20', 0),
                new VerifyMonkeyCommand('Verify Room temp is 24 degrees', null, 'txtInputItem_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', '24')
                    ]), null, null, true, '500', '20', 0),
                new VerifyMonkeyCommand('Verify Room Temp Watch Icon', null, 'icoSysVar_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('enabled', null, 'property', 'true')
                    ]), null, null, true, '500', '20', 0),
                new VerifyMonkeyCommand('Verify Room Temp label is enabled', null, 'lblVarName_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('enabled', null, 'property', 'true')
                    ]), null, null, true, '500', '20', 0),
                new VerifyMonkeyCommand('Verify Room Temp Info Button is enabled', null, 'btnInfo_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('enabled', null, 'property', 'true')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Input', 'txtInputItem_SYSTRmSPCool', 'automationName', ['25'], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify Room temp is now 25 degrees', null, 'txtInputItem_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', '25')
                    ]), null, null, true, '500', '20', 0),
                new VerifyMonkeyCommand('New Verify', null, 'icoSysVar_SYSTRmSPCool', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('enabled', null, 'property', 'true')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Click', 'Update', 'automationName', [null], '', '', '10', '500'),
                new PauseMonkeyCommand(100),
                new UIEventMonkeyCommand('Select', 'icoSysVar_SYSTRmSPCool', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('DragStart', 'icoSysVar_SYSTRmSPCool', 'automationName', [''], '', '', '10', '500'),
                new UIEventMonkeyCommand('DragDrop', 'dgWatchVariables', 'automationName', ['move'], '', '', '10', '500'),
                new UIEventMonkeyCommand('DragDrop', 'dgWatchVariables', 'automationName', ['move'], '', '', '10', '500')
            ]));

        private var mtCheck Watch PanelTimeoutTime:int = 142200;

        [Test]
        public function Check Watch Panel():void{
            beforeTest("WatchPanelValues","Check Watch Panel");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtCheck Watch Panel, mtCheck Watch PanelComplete, mtCheck Watch PanelTimeoutTime, defaultTimeoutHandler);
        }

        public function mtCheck Watch PanelComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtCheck Watch Panel);
            afterTest("WatchPanelValues","Check Watch Panel");
        }

        private var mtLogout:MonkeyTest = new MonkeyTest('Logout', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Click', 'Scenario', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Select', 'Scenario Menu', 'automationName', ['Close scenario'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'Learn HVAC', 'automationName', [''], '', '', '10', '500'),
                new UIEventMonkeyCommand('Select', 'Learn HVAC Menu', 'automationName', ['Logout'], '', '', '10', '500'),
                new VerifyMonkeyCommand('is alert visible', null, 'Logout', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('className', null, 'property', 'Alert')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Select', 'Logout', 'automationName', [''], '', '', '10', '500'),
                new UIEventMonkeyCommand('Select', 'OK', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'OK', 'automationName', [null], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify login popup is there', null, 'You may login as \'guest\' (This will give you access to local scenarios only.)', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', 'You may login as \'guest\' (This will give you access to local scenarios only.)')
                    ]), null, null, true, '500', '20', 0)
            ]));

        private var mtLogoutTimeoutTime:int = 60000;

        [Test]
        public function Logout():void{
            beforeTest("WatchPanelValues","Logout");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogout, mtLogoutComplete, mtLogoutTimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogoutComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogout);
            afterTest("WatchPanelValues","Logout");
        }


    }
}