/*
 * _FxGettext.as
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
    import flash.events.IEventDispatcher;

    public class _FxGettext extends _Gettext implements IEventDispatcher 
    {
        
        private var internalDispatcher:IEventDispatcher;
        
        public function _FxGettext(locale:_Locale)
        {
            super(locale);
            internalDispatcher = new EventDispatcher(this);
        }
        
        /**
         * @private
         */
        override protected function onComplete(event:Event):void
        {
            super.onComplete(event);
            this.dispatchEvent(new Event("localeChange"));
        }
        
        /**
         * @inheritDoc
         */
        [Bindable("localeChange")]
        override public function gettext(string:String):String
        {
            return super.gettext(string);
        }
        
        /**
         * @copy #gettext()
         */
        [Bindable("localeChange")]
        public function _(string:String):String
        {
            return super.gettext(string);
        }
        
        /**
         * @inheritDoc
         */
        [Bindable("localeChange")]
        override public function dgettext(domain:String, string:String):String
        {
            return super.dgettext(domain,string);
        }
        
        /**
         * @copy #dgettext()
         */
        [Bindable("localeChange")]
        public function _d(domain:String, string:String):String
        {
            return super.dgettext(domain,string);
        }
        
        //---------------------------------------------------------------------
        // IEventDispatcher implementation
        //---------------------------------------------------------------------
        
        /**
         * @inheritDoc
         */
        public function addEventListener(
                            type:String, 
                            listener:Function, 
                            useCapture:Boolean = false, 
                            priority:int = 0, 
                            useWeakReference:Boolean = false
                            ):void
        {
            internalDispatcher.addEventListener(
                                                type, 
                                                listener, 
                                                useCapture, 
                                                priority, 
                                                useWeakReference
                                            );
        }
        
        /**
         * @inheritDoc
         */
        public function dispatchEvent(event:Event):Boolean
        {
            return internalDispatcher.dispatchEvent(event);
        }
        
        /**
         * @inheritDoc
         */
        public function hasEventListener(type:String):Boolean
        {
            return internalDispatcher.hasEventListener(type);
        }
        
        /**
         * @inheritDoc
         */
        public function removeEventListener(
                            type:String, 
                            listener:Function, 
                            useCapture:Boolean = false
                            ):void
        {
            internalDispatcher.removeEventListener(type, listener, useCapture);
        }
        
        /**
         * @inheritDoc
         */
        public function willTrigger(type:String):Boolean
        {
            return internalDispatcher.willTrigger(type);
        }
        
    }
    
}
