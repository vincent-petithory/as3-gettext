/*
 * IGettextService.as
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

	import flash.events.IEventDispatcher;
	
	import gnu.as3.gettext.MOFile;
	
	/**
	 * A service to load a catalog. Dispatches a complete or an ioError events.
	 */
	public interface IGettextService extends IEventDispatcher 
	{
		function get domainName():String;
		function get catalog():MOFile;
		function get baseURL():String;
		
		function load(path:String, domainName:String):void;
		function reset():void;
		
	}

}
