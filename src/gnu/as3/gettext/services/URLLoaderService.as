package gnu.as3.gettext.services 
{
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	import flash.utils.ByteArray;
	
	import gnu.as3.gettext.MOFile;
	import gnu.as3.gettext.parseMOBytes;
	
	public class URLLoaderService extends EventDispatcher implements IEventDispatcher 
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
	
		public function URLLoaderService()
		{
			loader = new URLLoader();
		}
		
		public function load(url:String, domainName:String):void
		{
			this._domainName = domainName;
			// set the format. We expect a ByteArray
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			// set listeners
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorEventToRedispatch);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEventToRedispatch);
			
			try 
			{
				loader.load(new URLRequest(url));
			} catch (e:Error)
			{
				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.message));
			}
		}
		
		private function onComplete(event:Event):void
		{
			this.data = loader.data;
			this.dispatchEvent(event.clone());
		}
		
		private function onErrorEventToRedispatch(event:ErrorEvent):void
		{
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.text));
		}
		
	}

}