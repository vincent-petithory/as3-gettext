/*
 * URLLoaderService.as
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
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	import flash.utils.ByteArray;
	
	import gnu.as3.gettext.MOFile;
	import gnu.as3.gettext.parseMOBytes;
	
	public class URLLoaderService 
							extends EventDispatcher 
							implements IGettextService 
	{
		
		private var loader:URLLoader;
		private var data:ByteArray;
		
		private var _domainName:String;
		
		public function get domainName():String
		{
			return this._domainName;
		}
		
		public function get catalog():MOFile
		{
			this.data.position = 0;
			return parseMOBytes(this.data);
		}
	
		public function URLLoaderService(baseURL:String = null)
		{
		    super();
			loader = new URLLoader();
			if (baseURL)
                this.baseURL = baseURL;
		}
        
        private var _baseURL:String;
        
        public function get baseURL():String
        {
            return _baseURL;
        }
        
        public function set baseURL(value:String):void
        {
            this._baseURL = value;
        }
		
		public function load(url:String, domainName:String):void
		{
			this._domainName = domainName;
			// set the format. We expect a ByteArray
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			// set listeners
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, 
										onErrorEventToRedispatch);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
										onErrorEventToRedispatch);
			
			try 
			{
				loader.load(new URLRequest(this._baseURL+"/"+url));
			} catch (e:Error)
			{
				this.dispatchEvent(
					new IOErrorEvent(
						IOErrorEvent.IO_ERROR, false, false, e.message
					)
				);
			}
		}
		
		private function onComplete(event:Event):void
		{
			this.data = loader.data;
			this.dispatchEvent(event.clone());
		}
		
		private function onErrorEventToRedispatch(event:ErrorEvent):void
		{
			this.dispatchEvent(
				new IOErrorEvent(
					IOErrorEvent.IO_ERROR, false, false, event.text
					)
				);
		}
		
	}

}
