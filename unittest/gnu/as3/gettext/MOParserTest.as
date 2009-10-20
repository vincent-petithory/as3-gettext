package gnu.as3.gettext 
{
	
	import astre.api.*;
	import astre.core.Astre;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.filesystem.*;
	
	public class MOParserTest extends Test 
	{
		
		public function MOParserTest(name:String)
		{
			super(name);
		}
		
		private var moBytes:ByteArray;
		
		override public function setUp():void
		{
			var moFile:File = new File(File.applicationDirectory.nativePath+"/pidgin.mo");
			if (!moFile.exists)
			{
				fail("no input mo file");
			}
			var stream:FileStream = new FileStream();
			stream.open(moFile, FileMode.READ);
			moBytes = new ByteArray();
			stream.readBytes(moBytes);
			stream.close();
			moBytes.position = 0;
			assertTrue(moBytes.bytesAvailable>0);
		}
		
		public function readMOFileDoesNotThrowErrors():void
		{
			try
			{
				var parser:MOParser = new MOParser();
				parser.parse(this.moBytes);
			} catch (e:GettextError)
			{
				fail("An unexpected GettextError was thrown while reading the mo file");
			} catch (e:Error)
			{
				fail("An unexpected error was thrown while reading the mo file");
			}
		}
		
		public function readNullBytesThrowsATypeError():void
		{
			var parser:MOParser = new MOParser();
			try 
			{
				parser.parse(null);
				fail("A TypeError signaling null bytes was not thrown");
			} catch (e:TypeError)
			{
				
			}
		}
		
		public function readInvalidMOFileThrowsAGettextError():void
		{
			// NOTE : no tests with an extra string in the middle of the file, 
			// because it may be inside the original or translations strings, 
			// and so forth, would not be detected
			var parser:MOParser = new MOParser();
			this.moBytes.position = 0;
			this.moBytes.writeUTFBytes("Inserting an invalid string at the beginning");
			this.moBytes.position = 0;
			try 
			{
				parser.parse(this.moBytes);
				fail("MO File was not marked as invalid");
			} catch (ge:GettextError)
			{
				
			}
		}
		
		public function readMOFileWithExtraDataAtTheEndDoesNotThrowAnError():void
		{
			// NOTE : no tests with an extra string in the middle of the file, 
			// because it may be inside the original or translations strings, 
			// and so forth, would not be detected
			var parser:MOParser = new MOParser();
			this.moBytes.position = this.moBytes.length;
			this.moBytes.writeUTFBytes("Inserting an invalid string at the end");
			this.moBytes.position = 0;
			try 
			{
				parser.parse(this.moBytes);
			} catch (ge:GettextError)
			{
				fail("MO File was marked invalid. good, but we should not have reached this position in the file");
			}
		}
		
		public function theNumberOfTranslationReturnedAreValid():void
		{
			var parser:MOParser = new MOParser();
			parser.parse(this.moBytes);
			var dictionary:Dictionary = parser.getDictionary();
			assertNotNull(dictionary);
			
			var numStrings:int = 0;
			for (var str:String in dictionary)
			{
//				trace("--------------");
//				trace("Original::"+str);
//				trace("Translation::"+dictionary[str]);
//				trace("--------------");
				numStrings++;
			}
			assertTrue(numStrings>0);
			assertEquals(3706,numStrings);
		}
		
		override public function tearDown():void
		{
			this.moBytes = null;
		}
		
	}
	
}
