package LearnHVAC.Bugs{
    import com.gorillalogic.flexmonkey.flexunit.tests.MonkeyFlexUnitTestSuite;

    import LearnHVAC.Bugs.tests.OutputPanel;
    import LearnHVAC.Bugs.tests.LogoutisBrokenForGuest;
    import LearnHVAC.Bugs.tests.WatchPanelValues;
    import LearnHVAC.Bugs.tests.NewTestCase;

    public class Bugs extends MonkeyFlexUnitTestSuite{
        public function Bugs(){
            addTestCase(new OutputPanel());
            addTestCase(new LogoutisBrokenForGuest());
            addTestCase(new WatchPanelValues());

        }
    }
}