package LearnHVAC.UnitTests.tests{
    import BaseClass;

    import com.gorillalogic.flexmonkey.core.MonkeyTest;
    import com.gorillalogic.flexmonkey.monkeyCommands.*;
    import com.gorillalogic.flexmonkey.application.VOs.AttributeVO;
    import com.gorillalogic.flexmonkey.events.MonkeyCommandRunnerEvent;

    import mx.collections.ArrayCollection;

    public class Unit1 extends BaseClass {
        public function Unit1(){
            super();
        }

        private var mtLoginAndChangeTime:MonkeyTest = new MonkeyTest('LoginAndChangeTime', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('Click', 'Login', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'Start Scenario', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'Start Scenario', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', '09:00:00', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'com.superb.learnhvac-2-1-03', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Show', 'appMenu', 'automationName', ['Scenario'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Hide', 'Scenario Menu', 'automationName', [null], '', '', '10', '500'),
                new UIEventMonkeyCommand('Show', 'appMenu', 'automationName', ['Learn HVAC'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Select', 'Learn HVAC Menu', 'automationName', ['Logout'], '', '', '10', '500'),
                new UIEventMonkeyCommand('Click', 'OK', 'automationName', [null], '', '', '10', '500')
            ]));

        private var mtLoginAndChangeTimeTimeoutTime:int = 55000;

        [Test]
        public function LoginAndChangeTime():void{
            beforeTest("Unit1","LoginAndChangeTime");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtLoginAndChangeTime, mtLoginAndChangeTimeComplete, mtLoginAndChangeTimeTimeoutTime, defaultTimeoutHandler);
        }

        public function mtLoginAndChangeTimeComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtLoginAndChangeTime);
            afterTest("Unit1","LoginAndChangeTime");
        }


    }
}