package LearnHVAC.Bugs.tests{
    import BaseClass;

    import com.gorillalogic.flexmonkey.core.MonkeyTest;
    import com.gorillalogic.flexmonkey.monkeyCommands.*;
    import com.gorillalogic.flexmonkey.application.VOs.AttributeVO;
    import com.gorillalogic.flexmonkey.events.MonkeyCommandRunnerEvent;

    import mx.collections.ArrayCollection;

    public class LogoutisBrokenForGuest extends BaseClass {
        public function LogoutisBrokenForGuest(){
            super();
        }

        private var mtLogin as user 'guest':MonkeyTest = new MonkeyTest('Login as user 'guest'', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Input', 'username', 'automationName', ['guest'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'btnLogin', 'id', [''], '', '', '10', '500'),
                new VerifyMonkeyCommand('Verify Basic Scenerio', null, '_SelectScenarioItemRenderer_Label1', 'id', false, 
                    new ArrayCollection([
                        new AttributeVO('text', null, 'property', 'Basic Scenario')
                    ]), null, null, true, '500', '20', 0)
            ]));

        private var mtLogin as user 'guest'TimeoutTime:int = 25000;

        [Test]
        public function Login as user 'guest'():void{
            beforeTest("LogoutisBrokenForGuest","Login as user 'guest'");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogin as user 'guest', mtLogin as user 'guest'Complete, mtLogin as user 'guest'TimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogin as user 'guest'Complete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogin as user 'guest');
            afterTest("LogoutisBrokenForGuest","Login as user 'guest'");
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
            beforeTest("LogoutisBrokenForGuest","Logout");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLogout, mtLogoutComplete, mtLogoutTimeoutTime, defaultTimeoutHandler);
        }

        public function mtLogoutComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLogout);
            afterTest("LogoutisBrokenForGuest","Logout");
        }


    }
}