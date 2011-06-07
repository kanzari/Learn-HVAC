package LearnHVAC.Bugs.tests{
    import BaseClass;

    import com.gorillalogic.flexmonkey.core.MonkeyTest;
    import com.gorillalogic.flexmonkey.monkeyCommands.*;
    import com.gorillalogic.flexmonkey.application.VOs.AttributeVO;
    import com.gorillalogic.flexmonkey.events.MonkeyCommandRunnerEvent;

    import mx.collections.ArrayCollection;

    public class OutputPanel extends BaseClass {
        public function OutputPanel(){
            super();
        }

        private var mtLogin:MonkeyTest = new MonkeyTest('Login', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Input', 'username', 'automationName', ['guest'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'btnLogin', 'id', [''], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify Basic Scenerio', null, '_SelectScenarioItemRenderer_Label1', 'id', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', 'Basic Scenario')
                    ]), null, null, true, '500', '20', 0)
            ]));

        private var mtLoginTimeoutTime:int = 25000;

        [Test]
        public function Login():void{
            beforeTest("OutputPanel","Login");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogin, mtLoginComplete, mtLoginTimeoutTime, defaultTimeoutHandler);
        }

        public function mtLoginComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogin);
            afterTest("OutputPanel","Login");
        }

        private var mtCheckOutputPanel:MonkeyTest = new MonkeyTest('CheckOutputPanel', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Click', 'Open Scenario', 'automationName', [null], '', '', '10', '500'),
                new PauseMonkeyCommand(3500),
                new VerifyMonkeyCommand('New Verify', null, 'Open output data window', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('id', null, 'property', 'btnOutputPanel')
                    ]), null, null, true, '500', '20', 0),
                new UIEventMonkeyCommand('Click', 'Open output data window', 'automationName', [null], '', '', '10', '500'),
                new VerifyGridMonkeyCommand('New Verify Grid', 'dgOutputVariables', 'automationName', 0, 1, 'MXMARH', '', '', true, '10', '500')
            ]));

        private var mtCheckOutputPanelTimeoutTime:int = 34500;

        [Test]
        public function CheckOutputPanel():void{
            beforeTest("OutputPanel","CheckOutputPanel");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtCheckOutputPanel, mtCheckOutputPanelComplete, mtCheckOutputPanelTimeoutTime, defaultTimeoutHandler);
        }

        public function mtCheckOutputPanelComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtCheckOutputPanel);
            afterTest("OutputPanel","CheckOutputPanel");
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
            beforeTest("OutputPanel","Logout");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogout, mtLogoutComplete, mtLogoutTimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogoutComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogout);
            afterTest("OutputPanel","Logout");
        }


    }
}