/*
 * LocalAsyncFilesystemService.as
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
package gnu.as3.gettext.services 
{

	import gnu.as3.gettext.parseMOBytes;
	import gnu.as3.gettext.MOFile;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import flash.utils.ByteArray;

    public class LocalAsyncFilesystemService extends EventDispatcher implements IGettextService 
    {
        public function LocalAsyncFilesystemService()
        {
            super();
        }
        
        private var _domainName:String;
        
        public function get domainName():String
        {
        	return this._domainName;
        }
        
        private var data:ByteArray;
        
		public function get catalog():MOFile
		{
			return parseMOBytes(this.data);
		}
        
        public function load(url:String, domainName:String):void
        {
//            try 
//            {
//		        var moFile:File = new File(File.applicationDirectory.nativePath+"/pidgin.mo");
//				if (!moFile.exists)
//				{
//					fail("no input mo file");
//				}
//				var stream:FileStream = new FileStream();
//				stream.open(moFile, FileMode.READ);
//				moBytes = new ByteArray();
//				stream.readBytes(moBytes);
//				stream.close();
//				moBytes.position = 0;
//				this.data = moBytes;
//			} catch (e:Error)
//			{
//				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,e.message));
//			}
//			this.dispatchEvent(new Event(Event.COMPLETE));
			
        }
        
    }
    
}
