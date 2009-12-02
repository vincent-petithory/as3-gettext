/*
 * mklocale.as
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
       
    import gnu.as3.gettext.ISO_639_1;
    import gnu.as3.gettext.ISO_3166;
    
    /**
     * Creates a locale using an ISO 639 code (language) 
     * and an ISO 3166 code (country).
     * 
     * @param iso639 the iso 639 language code.
     * @param iso3166 the iso 3166 country code.
     * @return a standard locale.
     * 
     * @see gnu.as3.gettext.ISO_639_1
     * @see gnu.as3.gettext.ISO_3166
     */
    public function mklocale(iso639:String, iso3166:String):String
    {
        return ISO_639_1.codes[iso639]+"_"+ISO_3166.codes[iso3166];
    }
}

