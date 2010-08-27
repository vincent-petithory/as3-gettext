/*
 * parseMOBytesTest.as
 * This file is part of Actionscript GNU Gettext 
 *
 * Copyright (C) 2010 - Vincent Petithory
 *
 * Actionscript GNU Gettext is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * Actionscript GNU Gettext is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
package gnu.as3.gettext 
{
    
    import astre.api.*;
    import astre.core.Astre;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.filesystem.*;
    
    public class parseMOBytesTest extends Test 
    {
        
        public function parseMOBytesTest(name:String)
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
                parseMOBytes(this.moBytes);
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
            try 
            {
                parseMOBytes(null);
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
            this.moBytes.position = 0;
            this.moBytes.writeUTFBytes("Inserting an invalid string at the beginning");
            this.moBytes.position = 0;
            try 
            {
                parseMOBytes(this.moBytes);
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
            this.moBytes.position = this.moBytes.length;
            this.moBytes.writeUTFBytes("Inserting an invalid string at the end");
            this.moBytes.position = 0;
            try 
            {
                parseMOBytes(this.moBytes);
            } catch (ge:GettextError)
            {
                fail("MO File was marked invalid. good, but we should not have reached this position in the file");
            }
        }
        
        public function theNumberOfTranslationReturnedAreValid():void
        {
            var mo:MOFile = parseMOBytes(this.moBytes);
            var dictionary:Dictionary = mo.strings;
            assertNotNull(dictionary);
            
            var numStrings:int = 0;
            for (var str:String in dictionary)
            {
                numStrings++;
            }
            assertTrue(numStrings>0);
            assertEquals(3706,numStrings);
            assertEquals(mo.numStrings,numStrings);
        }
        
        public function anUnknownEntryReturnsUndefined():void
        {
            var mo:MOFile = parseMOBytes(this.moBytes);
            var dictionary:Dictionary = mo.strings;
            assertUndefined(dictionary["__something that is not found in the mo file__"]);
        }
        
        public function checkAdditionalInfosAreCorrect():void
        {
            var mo:MOFile = parseMOBytes(this.moBytes);
            
            trace();
            
            assertEquals("Pidgin",mo.projectIdVersion);
            assertEquals("",mo.reportMsgidBugsTo);
            
            var datePot:Date = new Date(
                Date.UTC(2009,7-1,19,22-2/*-2 is timezone offset*/,15,0,0)
            );
            
            var datePo:Date = new Date(
                Date.UTC(2009,7-1,19,22-2/*-2 is timezone offset*/,15,0,0)
            );
            
            
            assertEquals(datePot.getTime(),mo.potCreationDate.getTime());
            assertEquals(datePo.getTime(),mo.poRevisionDate.getTime());
            assertEquals("Éric Boumaour <zongo_fr@users.sourceforge.net>",mo.lastTranslator);
            assertEquals("fr <fr@li.org>",mo.languageTeam);
            assertEquals("1.0",mo.mimeVersion);
            assertEquals("text/plain; charset=UTF-8",mo.contentType);
            assertEquals("text/plain",mo.contentMimeType);
            assertEquals("UTF-8",mo.contentCharset);
            assertEquals("8bit",mo.contentTransferEncoding);
            assertEquals("nplurals=2; plural=n>1;",mo.pluralForms);
            // handle test of MOFile features here.
            assertEquals(1,mo.plural);
            assertEquals(2,mo.nPlural);
        }
        
        override public function tearDown():void
        {
            this.moBytes = null;
        }
        
    }
    
}
