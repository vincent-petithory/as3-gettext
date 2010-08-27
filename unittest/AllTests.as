/*
 * AllTests.as
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
package 
{
    
    import astre.api.*;
    import gnu.as3.gettext.*;
    import gnu.as3.gettext.services.LocalFilesystemService;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;

    public final class AllTests extends Sprite 
    {
        
        public static function suite():TestSuite
        {
            var list:TestSuite = new TestSuite();
            list.add(gnu.as3.gettext.AllTests.suite());
            return list;
        }

        public function AllTests()
        {
            //setlocale(Locale.LC_MESSAGES, mklocale(ISO_639_1.FR,ISO_3166.FR));
            var service:LocalFilesystemService = new LocalFilesystemService(File.applicationDirectory.nativePath);
            service.addEventListener(Event.COMPLETE, onComplete);
            service.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            ASGettext.bindtextdomain(PACKAGE, null, service);
            ASGettext.textdomain(PACKAGE);
        }
        
        private function onComplete(event:Event):void
        {
            CLITestRunner.run(suite());
        }
        
        private function onIOError(event:IOErrorEvent):void
        {
            trace(event);
        }
        
    }
}

