package gnu.as3.gettext 
{
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import flash.errors.EOFError;

    public class MOParser 
    {
		/**
		 * Magic number stored in little endian byte order
		 */
		public static const LITTLE_ENDIAN_MAGIC_NUMBER:uint = 0xde120495;
		
		/**
		 * Magic number stored in big endian byte order
		 */
		public static const BIG_ENDIAN_MAGIC_NUMBER:uint = 0x950412de;
		
		public static const DEFAULT_FILE_FORMAT_REVISION:uint = 0;
		
		//-----------------------------------------------------------
		// Header
		//-----------------------------------------------------------
		
		/**
		 * Magic number
		 */
		private var magicNumber:uint;
		
		/**
		 * File format revision
		 */
		private var fileFormatRevision:uint;
		
		/**
		 * Number of strings
		 */
		private var n:uint;
		
		/**
		 * Offset of table of original strings
		 */
		private var o:uint;
		
		/**
		 * Offset of table with original translations
		 */
		private var t:uint;
		
		/**
		 * Size of hashing table
		 */
		private var s:uint;
		
		/**
		 * Offset of hashing table
		 */
		private var h:uint;
		
		/**
		 * The dictionary of the string and translated strings.
		 * The original strings are the keys ;
		 * the translated strings are the values.
		 */
		private var dictionary:Dictionary;
		
		/**
		 * Constructor
		 */
        public function MOParser()
        {
            super();
        }
        
        /**
         * Parses the bytes representing an MO file
         * 
         * @param bytes the bytes of the MO file
         * 
         * @throws GettextError if the bytes does not represent a valid MO file.
         * @throws TypeError if the specified ByteArray is null.
         */
        public function parse(bytes:ByteArray):void
        {
			if (bytes == null)
			{
				throw new TypeError("The <bytes> parameter must not be null");
			}
			var originalPosition:uint = bytes.position;
			
			this.magicNumber = bytes.readUnsignedInt();
			if (this.magicNumber == LITTLE_ENDIAN_MAGIC_NUMBER)
			{
				bytes.endian = Endian.LITTLE_ENDIAN;
			}
			else if (this.magicNumber == BIG_ENDIAN_MAGIC_NUMBER)
			{
				bytes.endian = Endian.BIG_ENDIAN;
			}
			else
			{
				throw new GettextError("The magic number is invalid.");
			}
			
			this.fileFormatRevision = bytes.readUnsignedInt();
			if (this.fileFormatRevision != DEFAULT_FILE_FORMAT_REVISION)
			{
				throw new GettextError("Unknown MO file format revision.");
			}
			
			this.n = bytes.readUnsignedInt();
			if (this.n <= 0)
			{
				throw new GettextError("The MO file has no translations.");
			}
			
			this.o = bytes.readUnsignedInt();
			this.t = bytes.readUnsignedInt();
			this.s = bytes.readUnsignedInt();
			this.h = bytes.readUnsignedInt();
			
			// Loop through string and translations location informations 
			// and retrieve string and translations infos
			const LOOP_INCREMENT:int = 4+4;
			const NUM_LOOPS:int = (n-1);
//			trace(magicNumber,fileFormatRevision,n,o,t,s,h,"|",NUM_LOOPS,bytes.length);
			var i:int = -1;
			var dictionary:Dictionary = new Dictionary(false);
			while (++i<=NUM_LOOPS)
			{
				try 
				{
					bytes.position = this.o+i*LOOP_INCREMENT;
					var strlen:uint = bytes.readUnsignedInt();
					var stroffset:uint = bytes.readUnsignedInt();
					bytes.position = this.t+i*LOOP_INCREMENT;
					var trStrlen:uint = bytes.readUnsignedInt();
					var trStroffset:uint = bytes.readUnsignedInt();
				
					// get string
					bytes.position = stroffset;
					var str:String = bytes.readUTFBytes(strlen);
					bytes.position = trStroffset;
					dictionary[str] = bytes.readUTFBytes(trStrlen);
				} catch (e:EOFError)
				{
					throw new GettextError("The MO file is invalid or corrupted.");
				}
			}
			
			this.dictionary = dictionary;
			// Put the byte array in its original state.
			bytes.position = originalPosition;
		}
        
        public function getDictionary():Dictionary
        {
			return this.dictionary;
		}
        
    }
    
}
