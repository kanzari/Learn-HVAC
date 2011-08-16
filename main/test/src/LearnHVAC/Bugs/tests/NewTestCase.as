package LearnHVAC.Bugs.tests{
    import BaseClass;

    import com.gorillalogic.flexmonkey.core.MonkeyTest;
    import com.gorillalogic.flexmonkey.monkeyCommands.*;
    import com.gorillalogic.flexmonkey.application.VOs.AttributeVO;
    import com.gorillalogic.flexmonkey.events.MonkeyCommandRunnerEvent;

    import mx.collections.ArrayCollection;

    public class NewTestCase extends BaseClass {
        public function NewTestCase(){
            super();
        }

        private var mtNewTest:MonkeyTest = new MonkeyTest('NewTest', 0,
            new ArrayCollection([
                new UIEventMonkeyCommand('DragStart', 'dgOutputVariables', 'automationName', ['*Economizer mixed air temperature* | MXTAirMix | 25.30 | °C'], '', '', '10', '500'),
                new UIEventMonkeyCommand('DragDrop', 'dgWatchVariables', 'automationName', ['move'], '', '', '10', '500')
            ]));

        private var mtNewTestTimeoutTime:int = 15000;

        [Test]
        public function NewTest():void{
            beforeTest("NewTestCase","NewTest");
            // startTest(<MonkeyTest>, <Complete method>, <Async timeout value>, <Timeout method>);
            startTest(mtNewTest, mtNewTestComplete, mtNewTestTimeoutTime, defaultTimeoutHandler);
        }

        public function mtNewTestComplete(event:MonkeyCommandRunnerEvent, passThroughData:Object):void{
            checkCommandResults(mtNewTest);
            afterTest("NewTestCase","NewTest");
        }


    }
}