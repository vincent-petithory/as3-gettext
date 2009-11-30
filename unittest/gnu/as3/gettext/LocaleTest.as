/*
 * LocaleTest.as
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
	
	public class LocaleTest extends Test 
	{
		
		public function LocaleTest(name:String)
		{
			super(name);
		}
		
		private var locale:_Locale;
		
		override public function setUp():void
		{
			locale = new _Locale();
		}
		
		public function constLCVariablesMixCorrectly():void
		{
			assertEquals(locale.LC_MESSAGES, locale.LC_ALL & locale.LC_MESSAGES);
			assertEquals(locale.LC_NUMERIC, locale.LC_ALL & locale.LC_NUMERIC);
			assertNotEquals(1<<8, locale.LC_ALL & (1 << 8));
		}
		
		public function languageConstOverridesLangConstAndLC_ALL():void
		{
			locale.LANGUAGE = mklocale(ISO_639_1.EN,ISO_3166.US);
			assertEquals("en_US", locale.setlocale(locale.LC_ALL));
		}
		
		public function langConstIsAFallBackWhenLanguageIsNotSetAndWhenUsingLC_ALL():void
		{
			assertEquals(locale.LANG, locale.setlocale(locale.LC_ALL));
		}
		
		public function settingLCMessagesThenRetrievingTheValueIsConsistent():void
		{
			locale.setlocale(locale.LC_MESSAGES, "es_ES");
			assertEquals("es_ES", locale.setlocale(locale.LC_MESSAGES));
		}
		
		public function settingLCALLThenRetrievingTheValueOfLCXXXIsConsistent():void
		{
			locale.setlocale(locale.LC_ALL, "it_IT");
			assertEquals("it_IT", locale.setlocale(locale.LC_MESSAGES));
			assertEquals("it_IT", locale.setlocale(locale.LC_TIME));
			assertEquals("it_IT", locale.setlocale(locale.LC_MONETARY));
			assertEquals("it_IT", locale.setlocale(locale.LC_NUMERIC));
			assertEquals("it_IT", locale.setlocale(locale.LC_COLLATE));
			assertEquals("it_IT", locale.setlocale(locale.LC_CTYPE));
		}
		
		override public function tearDown():void
		{
			locale = null;
		}
		
	}
	
}
