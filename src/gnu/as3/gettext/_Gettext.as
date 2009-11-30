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
		
		private var currentStrings:Dictionary;
		
		public const DEFAULT_DIR_NAME:String = "locale";
		
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
								dirName:String = null, 
								service:IGettextService = null
							):String
		{
		    this.currentLocale = __locale.setlocale(__locale.LC_MESSAGES,null);
			if (_domainBindings[domainName] == undefined)
			{
				_domainBindings[domainName] = DEFAULT_DIR_NAME;
			}
			
			if (dirName == null)
			{
				if (service)
					tryService(service, _domainBindings[domainName], domainName);
			}
			else
			{
				var l:int = dirName.length-1;
				if (dirName.charAt(l) == "/")
					dirName = dirName.substring(0,l);
				if (service)
					tryService(service, dirName, domainName);
				_domainBindings[domainName] = dirName;
			}
			return _domainBindings[domainName];
		}
		
		/**
		 * @private
		 * Attempts to launch the service that will load the translations.
		 */
		private function tryService(
								service:IGettextService, 
								dirName:String, 
								domainName:String
							):void
		{
			if (_domainCatalogs[domainName] != undefined)
			{
			    // catalog is already loaded; do not reload.
				service.dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
			    // load the catalog
				service.addEventListener(Event.COMPLETE, onComplete, false, 0x7fffff);
				service.load(dirName+"/"+
							this.currentLocale+"/"+
							this.__locale.LC_MESSAGES_FOLDER+"/"+
							domainName+".mo", domainName);
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
			if (this.currentDomainName != null)
			    this.currentStrings = _domainCatalogs[this.currentDomainName].strings;
		}
		
		/**
		 * Selects the default domain to use for the translations. Libraries 
		 * should not call this method, since it is the responsability of the 
		 * main application to set it. Instead, libraries use the domain 
		 * parameter of the gettext() method (or its _() alias).
		 * 
		 * <p>A call to textdomain assumes that the locale has been set.
		 * The current _Locale associated to this _Gettext will be used 
		 * to resolve the locale to use at this moment.</p>
		 * 
		 * @param domainName the name of the domain to set as the default domain.
		 * @param service the service to use to load the translations 
		 * associated. If null, the loading operation does not occur. As it is 
		 * the last opportunity to load the translations for the specified 
		 * domain, you must load them here if you did not do that in the 
		 * bindtextdomain method.
		 * 
		 */
		public function textdomain(domainName:String = null, service:IGettextService = null):String
		{
			this.currentLocale = __locale.setlocale(__locale.LC_MESSAGES,null);
			if (domainName != null)
			{
				this.currentDomainName = domainName;
				if (_domainCatalogs[this.currentDomainName] != null)
				    this.currentStrings = _domainCatalogs[this.currentDomainName].strings;
				if (service)
					tryService(service, this.bindtextdomain(this.currentDomainName), this.currentDomainName);
				return currentDomainName;
			}
			return this.currentDomainName;
		}
		
		public function ignore(domain:String):void
		{
		    var empty:MOFile = new MOFile();
		    empty.strings = new Dictionary();
		    this._domainCatalogs[domain] = empty;
		}
		
		/**
		 * Returns the translation string for the specified string, using 
		 * the current locale and the current domain.
		 */
		public function gettext(string:String):String
		{
		    var str:String = this.currentStrings[string];
	        if (str)
	            return str;
	        else 
	            return string;
		}
		
		/**
		 * Returns the translation string for the specified string, using 
		 * the current locale and the current domain.
		 */
		public function dgettext(domain:String, string:String):String
		{
		    var str:String = this._domainCatalogs[domain].strings[string];
		    if (str)
		        return str;
		    else
		        return string;
		}
		
	}
	
}
