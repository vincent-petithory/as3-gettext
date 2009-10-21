package gnu.as3.gettext.services 
{

	import flash.events.IEventDispatcher;
	
	import gnu.as3.gettext.MOFile;

	public interface IGettextService extends IEventDispatcher 
	{
		function load(url:String, domainName:String):void;
		function get domainName():String;
		function get catalog():MOFile;
	}

}