package 
{
	
    import astre.api.*;
	import gnu.as3.gettext.*;

    import flash.display.Sprite;

    public final class AllTests extends Sprite 
    {
        
        public static function suite():TestSuite
        {
            var list:TestSuite = new TestSuite();
            list.add(gnu.as3.gettext.AllTests.suite());
            return list;
        }

        public function AllTests()
        {
            CLITestRunner.run(suite());
        }
        
    }
}

