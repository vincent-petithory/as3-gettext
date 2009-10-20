package gnu.as3.gettext 
{
	
	import astre.api.*;
	
    public final class AllTests 
    {
        
        public static function suite():TestSuite
        {
            var list:TestSuite = new TestSuite();
            list.add(MOParserTest);
//            list.add(new MOParserTest("theNumberOfTranslationReturnedAreValid"));
            return list;
        }

    }
	
}
