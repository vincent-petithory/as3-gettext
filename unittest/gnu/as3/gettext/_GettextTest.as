/*
 * _GettextTest.as
 * This file is part of Actionscript GNU Gettext
 *
 * Copyright (C) 2009 - Vincent Petithory
 *
 * Actionscript GNU Gettext is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Actionscript GNU Gettext is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Actionscript GNU Gettext; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, 
 * Boston, MA  02110-1301  USA
 */
package gnu.as3.gettext 
{
	
	import astre.api.*;
	
	public class _GettextTest extends Test 
	{
		
		public function _GettextTest(name:String)
		{
			super(name);
		}
		
		private var asgettext:_Gettext;
		
		override public function setUp():void
		{
			asgettext = new _Gettext(new _Locale());
		}
		
		public function bindtextdomainStoresDomains():void
		{
			var dir:String = "./another_dir/locale";
			asgettext.bindtextdomain("pidgin",dir);
			assertEquals(dir,asgettext.bindtextdomain("pidgin",null));
		}
		
		public function bindtextdomainReturnsTheDirNameOfTheDomainWhenPassingNullOrNothing():void
		{
			var dir:String = "./another_dir/locale";
			asgettext.bindtextdomain("pidgin",dir);
			assertEquals(dir,asgettext.bindtextdomain("pidgin",null));
			assertEquals(dir,asgettext.bindtextdomain("pidgin"));
		}
		
		public function aDomainHasTheDefaultDomainWhenHavingNotSetAPreviousDirName():void
		{
			assertEquals(asgettext.DEFAULT_DIR_NAME, asgettext.bindtextdomain("pidgin",null));
		}
		
		public function bindtextdomainStripsTrailingSlashesInDirNames():void
		{
			asgettext.bindtextdomain("pidgin","./locale2/");
			assertEquals("./locale2",asgettext.bindtextdomain("pidgin",null));
			assertEquals("./locale2",asgettext.bindtextdomain("pidgin"));
		}
		
		public function textdomainThrowsAnErrorIfTheStringParameterIsEmpty():void
		{
			fail("not implemented");
		}
		
		public function textdomainRetrievesTheCurrentDomainWhenParamIsNull():void
		{
			fail("not implemented");
		}
		
		override public function tearDown():void
		{
			asgettext = null;
		}
		
	}
	
}
