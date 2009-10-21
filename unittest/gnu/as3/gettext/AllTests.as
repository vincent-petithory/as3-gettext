package gnu.as3.gettext 
{
	
	import astre.api.*;
	
    public final class AllTests 
    {
        
        public static function suite():TestSuite
        {
            var list:TestSuite = new TestSuite();
            list.add(ParseMOBytesTest);
            list.add(LocaleTest);
            list.add(GettextTest);
            return list;
        }

    }
	
}
