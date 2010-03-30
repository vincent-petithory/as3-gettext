/*
 * HelloWorldLocaleChange.as
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
package 
{
    
    import flash.display.Sprite;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    
    import flash.filesystem.File;
    
    import flash.utils.setTimeout;
    
    import gnu.as3.gettext.AsGettext;
    import gnu.as3.gettext.Locale;
    import gnu.as3.gettext.ISO_639_1;
    import gnu.as3.gettext.ISO_3166;
    import gnu.as3.gettext.PACKAGE;
    
    import gnu.as3.gettext.services.IGettextService;
    import gnu.as3.gettext.services.LocalFilesystemService;
    
    public class HelloWorldLocaleChange extends Sprite 
    {
        public function HelloWorldLocaleChange()
        {
            super();
            this.init();
        }
        
        public static const PACKAGE_HELLOWORLD_LOCALE_CHANGE:String = "helloworldlocalechange";
        
        public static const _:Function = gnu.as3.gettext.gettext;
        
        private var doChangeLocale:Boolean = true;
        
        private function init():void
        {
            // we set the locale for the messages category to fr_FR
            setlocale(Locale.LC_MESSAGES, mklocale(ISO_639_1.FR,ISO_3166.FR));
            
            // prepare the service. As an AIR sample, we use a local 
            // file system service based on the File class.
            var service:IGettextService = new LocalFilesystemService(File.applicationDirectory.nativePath);
            service.addEventListener(Event.COMPLETE, onComplete);
            service.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            
            // Binds the messages of the helloworldlocalechange domain to the 
            // default directory (locale)
            var relativeLocalePath:String = "../locale"; // Set this path accordingly
            AsGettext.bindtextdomain(PACKAGE_HELLOWORLD_LOCALE_CHANGE, relativeLocalePath, service);
            // if we use libraries that use gettext to localize their messages,
            // we should call bindtextdomain again for each library.
            //AsGettext.bindtextdomain(PACKAGE, null, service);
            
            // We select helloworld to be the default domain. 
            // Localized libraries should not call this. Instead, they use 
            // the gettext() method with the domain optional parameters.
            AsGettext.textdomain(PACKAGE_HELLOWORLD_LOCALE_CHANGE);
        }
        
        
        private function onComplete(event:Event):void
        {
            var hello:String = _("hello, world!");
            trace("[Locale "+setlocale(Locale.LC_MESSAGES)+"] "+hello);
            if (doChangeLocale)
            {
                var newLocale:String = mklocale(ISO_639_1.ES,ISO_3166.ES);
                setTimeout(setlocale, 1000, Locale.LC_MESSAGES, newLocale);
            }
        }
        
        private function onIOError(event:IOErrorEvent):void
        {
            // an error occured while loading the catalog
            // it probably means there is no translations for this locale
            // or the base path to the translations is incorrect.
            trace(event);
        }
        
    }

}
