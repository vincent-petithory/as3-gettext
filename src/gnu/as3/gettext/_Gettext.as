/*
 * _Gettext.as
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
	
	import flash.events.Event;
	
	import flash.utils.Dictionary;
	
	import gnu.as3.gettext.services.IGettextService;
	
    public final class _Gettext 
    {
	
		private var currentLocale:String;
		private var currentDomainName:String;
	
		private var __locale:_Locale;

		private var _domainBindings:Dictionary;
		private var _domainCatalogs:Dictionary;
		
		public const DEFAULT_DIR_NAME:String = "./locale";
		
		public function _Gettext(locale:_Locale)
		{
			this.__locale = locale;
			_domainBindings = new Dictionary(false);
			_domainCatalogs = new Dictionary(false);
		}
		
		/**
		 * 
		 */
		public function bindtextdomain(
								domainName:String, 
								dirName:String = null 
							):String
		{
			if (_domainBindings[domainName] == undefined)
			{
				_domainBindings[domainName] = DEFAULT_DIR_NAME;
			}
			
			if (dirName == null)
			{
				return _domainBindings[domainName];
			}
			else
			{
				var l:int = dirName.length-1;
				if (dirName.charAt(l) == "/")
				{
					dirName = dirName.substring(0,l);
				}
				_domainBindings[domainName] = dirName;
				return dirName;
			}
		}
		
		/**
		 * @private
		 * Attempts to launch the service that will load the translations.
		 */
		private function tryService(service:IGettextService, dirName:String, domainName:String):void
		{
			if (service)
			{
				if (_domainCatalogs[domainName] != undefined)
				{
					service.dispatchEvent(new Event(Event.COMPLETE));
				}
				else
				{
					service.addEventListener(Event.COMPLETE, onComplete);
					service.load(dirName+"/"+currentLocale+"/LC_MESSAGES/"+domainName+".mo", domainName);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function onComplete(event:Event):void
		{
			var service:IGettextService = event.target as IGettextService;
			service.removeEventListener(Event.COMPLETE, onComplete);
			_domainCatalogs[service.domainName] = service.catalog;
		}
		
		/**
		 * A call to textdomain assumes that the locale has been set.
		 * The current _Locale associated to this _Gettext will be used to resolve the locale to use at this moment.
		 */
		public function textdomain(domainName:String = null, service:IGettextService = null):String
		{
			this.currentLocale = __locale.setlocale(__locale.LC_MESSAGES,null);
			if (domainName == null)
			{
				return this.currentDomainName;
			}
			else
			{
				this.currentDomainName = domainName;
				tryService(service, this.bindtextdomain(this.currentDomainName), this.currentDomainName);
				return currentDomainName;
			}
		}
		
		/**
		 * Returns the translation string for the specified string, using 
		 * the current locale and the current domain.
		 */
		public function gettext(string:String, domain:String = null, locale:String = null):String
		{
			throw new Error("not implemented");
			return string;
		}
		
	}
	
}
