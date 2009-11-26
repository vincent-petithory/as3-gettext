/*
 * _Locale.as
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
	
	import flash.utils.Dictionary;
	import flash.system.Capabilities;
	
	public final class _Locale 
    {
		
		private var pwd_inc:uint = 0;
		
		public const LC_MESSAGES:uint = 1 << pwd_inc++;
		public const LC_TIME:uint = 1 << pwd_inc++;
		public const LC_MONETARY:uint = 1 << pwd_inc++;
		public const LC_NUMERIC:uint = 1 << pwd_inc++;
		public const LC_COLLATE:uint = 1 << pwd_inc++;
		
		/**
		 * LC_CTYPE is essentially used to determine locales in some standard
		 * C functions. There is no such things to localize in AS3, but it 
		 * may be used in your own functions if you use gettext to 
		 * localize your library.
		 */
		public const LC_CTYPE:uint = 1 << pwd_inc++;
		public const LC_ALL:uint = 			LC_MESSAGES | LC_TIME 	 | 
											LC_MONETARY | LC_NUMERIC | 
											LC_COLLATE 	| LC_CTYPE;
		
		private const NUM_LC_XXX:uint = pwd_inc;
		
		private var _domainsMap:Dictionary = new Dictionary(false);
		private var _locales:Dictionary = new Dictionary(false);
		
		public var LANGUAGE:String = "";
		
		private const __FP_ISO639_TO_LOCALE__:Object = { 
			'cs'    : 'cs_CZ',
			'da'    : 'da_DK',
			'nl'    : 'nl_NL',
			'en'    : 'en_US',
			'fi'    : 'fi_FI',
			'fr'    : 'fr_FR',
			'de'    : 'de_DE',
			'hu'    : 'hu_HU',
			'it'    : 'it_IT',
			'ja'    : 'ja_JP',
			'ko'    : 'ko_KR',
			'no'    : 'no_NO',
			'xu'    : 'en_US',
			'pl'    : 'pl_PL',
			'pt'    : 'pt_PT',
			'ru'    : 'ru_RU',
			'zh-CN' : 'zh_CN',
			'es'    : 'es_ES',
			'sv'    : 'sv_SE',
			'zh-TW' : 'zh_TW',
			'tr'    : 'tr_TR' 
		};
		
		public const LANG:String = __FP_ISO639_TO_LOCALE__[Capabilities.language];
		
		/**
		 * The setlocale() method encapsulates all the logic to set and 
		 * retrieve the current locale. 
		 * 
		 * <p>The default locale for every category is determined in the 
		 * following order :
		 * <ul>
		 * <li>the value of the LANGUAGE variable, if set.</li>
		 * <li>the value of the LANGUAGE variable, if set.</li>
		 * </ul>
		 * </p>
		 * 
		 * @param category the category to set/retrieve information.
		 * @param locale the locale to set. If not null, the specified locale 
		 * will be set for the specified category. If null, the method will 
		 * return the current locale for the specified category. 
		 * Use the mklocale() method to create a standard locale.
		 * 
		 * @see mklocale()
		 */
		public function setlocale(category:uint, locale:String = null):String
		{
			var pw:int = 0;
			var lc:uint;
			if (locale == null)
			{
				if (LANGUAGE != null && LANGUAGE != "")
				{
					return LANGUAGE;
				}
				var numCats:uint = 0;
				var cat:uint = 0;
				for (pw = 0; pw < NUM_LC_XXX; pw++)
				{
					lc = 1 << pw;
					if (category == lc)
					{
						cat = lc;
						numCats++;
					}
				}
				if (numCats == 1 && _locales[cat] != undefined)
					return _locales[cat];
				else
					return LANG;
			}
			if (locale == "")
			{
				locale = setlocale(category, null);
			}
			for (pw = 0; pw < NUM_LC_XXX; pw++)
			{
				lc = 1 << pw;
				if ((category & lc) == lc)
				{
					_locales[lc] = locale;
				}
			}
			return locale;
		}
		
	}
	
}
