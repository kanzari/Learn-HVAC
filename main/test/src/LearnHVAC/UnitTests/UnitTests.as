package LearnHVAC.UnitTests{
    import com.gorillalogic.flexmonkey.flexunit.tests.MonkeyFlexUnitTestSuite;

    import LearnHVAC.UnitTests.tests.Unit0;
    import LearnHVAC.UnitTests.tests.Unit1;

    public class UnitTests extends MonkeyFlexUnitTestSuite{
        public function UnitTests(){
            addTestCase(new Unit0());
            addTestCase(new Unit1());
        }
    }
}