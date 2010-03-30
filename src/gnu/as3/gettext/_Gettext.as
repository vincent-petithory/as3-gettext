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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import gnu.as3.gettext.services.IGettextService;
	
    public class _Gettext extends EventDispatcher 
    {
		
		/**
		 * The current locale.
		 */
		private var currentLocale:String;
		
		/**
		 * The current domain.
		 */
		private var currentDomainName:String;
	
		/*
		 * @private
		 */
		private var __locale:_Locale;

		/**
		 * @private
		 * The locations associated to the domains.
		 */
		private var _domainBindings:Dictionary;
		
		/**
		 * @private
		 * The catalogs associated to the domains.
		 */
		private var _domainCatalogs:Dictionary;
		
		/**
		 * @private
		 * A shortcut to the active domain translation strings.
		 */
		private var currentStrings:Dictionary;
		
		/** 
		 * @private
		 */
		private var isLocaleListened:Boolean = false;
		
		/**
		 * The default directory where locales are stored.
		 */
		public const DEFAULT_DIR_NAME:String = "locale";
		
		/**
		 * The default service to be used when the locale is changed.
		 */
		public var defaultService:IGettextService = null;
		
		/**
		 * Constructor.
		 * 
		 * @param locale The _Locale to use with this _Gettext.
		 */
		public function _Gettext(locale:_Locale)
		{
			this.__locale = locale;
			_domainBindings = new Dictionary(false);
			_domainCatalogs = new Dictionary(false);
		}
		
		/**
		 * Binds a domain to a directory, optionally loading the translations 
		 * using the current locale, if the service parameter is not null.
		 * 
		 * NOTE: the first time this method takes a non null service parameter, 
		 * that service will be set to the defaultService variable.
		 */
		public function bindtextdomain(
								domainName:String, 
								dirName:String = null, 
								service:IGettextService = null
							):String
		{
			// listen only now, to avoid the first assignment to the locale
			if (!isLocaleListened) 
			{
				this.__locale.addEventListener("localeChange", onLocaleChange);
				isLocaleListened = true;
			}
		    this.currentLocale = __locale.setlocale(__locale.LC_MESSAGES,null);
			if (_domainBindings[domainName] == undefined)
			{
				_domainBindings[domainName] = DEFAULT_DIR_NAME;
			}
			
			if (dirName != null)
			{
				// Remove the trailing slash
				var l:int = dirName.length-1;
				if (dirName.charAt(l) == "/")
					dirName = dirName.substring(0,l);
				_domainBindings[domainName] = dirName;
			}
			// Assign the default service
			if (service)
			{
				if (this.defaultService == null)
					this.defaultService = service;
				
				tryService(service, _domainBindings[domainName], domainName);
			}
			return _domainBindings[domainName];
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
		
		/**
		 * Tells the gettext engine to ignore 
		 * the translations of the specified domain. 
		 */
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
	        if (str && str != "")
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
		    if (str && str != "")
		        return str;
		    else
		        return string;
		}
		
		/**
		 * Returns the string as it is. No operation is performed. This method 
		 * is used in some special cases to detect strings to be translated; 
		 * typically, this is used in initialization constants.
		 * 
		 * @param string The string to be translated.
		 * @return The same, non-translated, string.
		 */
		public function gettext_noop(string:String):String
		{
			return string;
		}
		
		/**
		 * Called when the Locale changes
		 * @param event the event to process.
		 */
		protected function onLocaleChange(event:Event):void
        {
            this.currentLocale = this.__locale.setlocale(this.__locale.LC_MESSAGES);
            if (this.defaultService)
                this.defaultService.reset();
            this.tryService(this.defaultService, this.bindtextdomain(this.currentDomainName), this.currentDomainName);
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
			var catalog:MOFile = _domainCatalogs[domainName];
			if (catalog != null && catalog.locale == __locale.setlocale(__locale.LC_MESSAGES))
			{
			    // catalog is already loaded; do not reload.
			    // We do not want to call the onComplete listener here.
				service.dispatchEvent(new Event(Event.COMPLETE));
				this.dispatchEvent(new Event("localeComplete"));
			}
			else
			{
			    // load the catalog
				service.addEventListener(Event.COMPLETE, onComplete, false, 0x7fffff);
				service.load(dirName+"/"+
							this.currentLocale+"/"+
							this.__locale.LC_MESSAGES_DIR+"/"+
							domainName+".mo", domainName);
			}
		}
		
		/**
		 * @private
		 */
		protected function onComplete(event:Event):void
		{
			var service:IGettextService = event.target as IGettextService;
			service.removeEventListener(Event.COMPLETE, onComplete);
			var catalog:MOFile = service.catalog;
			catalog.locale = this.currentLocale;
			_domainCatalogs[service.domainName] = catalog;
			if (this.currentDomainName != null)
			    this.currentStrings = _domainCatalogs[this.currentDomainName].strings;
			this.dispatchEvent(new Event("localeComplete"));
		}
		
		
	}
	
}
