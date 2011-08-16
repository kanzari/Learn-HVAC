package LearnHVAC.UnitTests.tests{
    import BaseClass;

    import com.gorillalogic.flexmonkey.core.MonkeyTest;
    import com.gorillalogic.flexmonkey.monkeyCommands.*;
    import com.gorillalogic.flexmonkey.application.VOs.AttributeVO;
    import com.gorillalogic.flexmonkey.events.MonkeyCommandRunnerEvent;

    import mx.collections.ArrayCollection;

    public class Unit0 extends BaseClass {
        public function Unit0(){
            super();
        }

        private var mtLogin as user 'rrd':MonkeyTest = new MonkeyTest('Login as user 'rrd'', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Input', 'username', 'automationName', ['rrd'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Input', 'password', 'automationName', ['rrdrrd'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'btnLogin', 'id', [''], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify Basic Scenerio', null, 'Basic Scenario', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', 'Basic Scenario')
                    ]), null, null, true, '500', '20', 0)
            ]));

        private var mtLogin as user 'rrd'TimeoutTime:int = 30000;

        [Test]
        public function Login as user 'rrd'():void{
            beforeTest("Unit0","Login as user 'rrd'");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogin as user 'rrd', mtLogin as user 'rrd'Complete, mtLogin as user 'rrd'TimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogin as user 'rrd'Complete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogin as user 'rrd');
            afterTest("Unit0","Login as user 'rrd'");
        }

        private var mtLogout:MonkeyTest = new MonkeyTest('Logout', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Click', 'Learn HVAC', 'automationName', [''], '', '', '10', '500'),
                new UIEventMonkeyCommand('Select', 'Learn HVAC Menu', 'automationName', ['Logout'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'OK', 'automationName', [null], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify login popup is there', null, 'You may login as \'guest\' (This will give you access to local scenarios only.)', 'automationName', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', 'You may login as \'guest\' (This will give you access to local scenarios only.)')
                    ]), null, null, true, '500', '20', 0)
            ]));

        private var mtLogoutTimeoutTime:int = 30000;

        [Test]
        public function Logout():void{
            beforeTest("Unit0","Logout");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogout, mtLogoutComplete, mtLogoutTimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogoutComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogout);
            afterTest("Unit0","Logout");
        }


    }
}