/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package  net.wdmir.core.util
{
	/**
	 * Entities class.
	 * 
	 * @version	1.0.0
	 * 
	 * @author	The gotoAndPlay() Team
	 * 			{@link http://www.smartfoxserver.com}
	 * 			{@link http://www.gotoandplay.it}
	 * 
	 * @exclude
	 */
	public class Entities
	{
		private static var ascTab:Array
		private static var ascTabRev:Array
		private static var hexTable:Array
		
		//--- XML Entities Conversion table ----------------------
		ascTab				= []
		ascTab[">"] 		= "&gt;"
		ascTab["<"] 		= "&lt;"
		ascTab["&"] 		= "&amp;"
		ascTab["'"] 		= "&apos;"
		ascTab["\""] 		= "&quot;"
		
		ascTabRev			= []
		ascTabRev["&gt;"]	= ">"
		ascTabRev["&lt;"] 	= "<"
		ascTabRev["&amp;"] 	= "&"
		ascTabRev["&apos;"] = "'"
		ascTabRev["&quot;"] = "\""
		
		hexTable = new Array()
		hexTable["0"] = 0
		hexTable["1"] = 1
		hexTable["2"] = 2
		hexTable["3"] = 3
		hexTable["4"] = 4
		hexTable["5"] = 5
		hexTable["6"] = 6
		hexTable["7"] = 7
		hexTable["8"] = 8
		hexTable["9"] = 9
		hexTable["A"] = 10
		hexTable["B"] = 11
		hexTable["C"] = 12
		hexTable["D"] = 13
		hexTable["E"] = 14
		hexTable["F"] = 15
		
		public static function encodeEntities(st:String):String
		{
			var strbuff:String = ""
		
			// char codes < 32 are ignored except for tab,lf,cr
			for (var i:int = 0; i < st.length; i++)
			{
				var ch:String = st.charAt(i)
				var cod:int = st.charCodeAt(i)
				
				if (cod == 9 || cod == 10 || cod == 13)
				{
					strbuff += ch
				}
				else if (cod >= 32 && cod <=126)
				{
					if (ascTab[ch] != null)
					{
						strbuff += ascTab[ch]
					}
					else
						strbuff += ch
				}

				else
					strbuff += ch
			}
		
			return strbuff
		}
	
	
	
		public static function decodeEntities(st:String):String
		{
			var strbuff:String
			var ch:String
			var ent:String
			var chi:String
			var item:String
			
			var i:int = 0
	
			strbuff = ""
	
			while(i < st.length)
			{
				ch = st.charAt(i)
	
				if (ch == "&")
				{
					ent = ch
					
					// read the complete entity
					do
					{
						i++
						chi = st.charAt(i)
						ent += chi
					} 
					while (chi != ";" && i < st.length )
					
					item = ascTabRev[ent]
	
					if (item != null)
						strbuff += item
					else
						strbuff += String.fromCharCode(getCharCode(ent))
				}
				else
					strbuff += ch
					
				i++
			}

			return strbuff
		}
		
	
		//-----------------------------------------------
		// Transform xml code entity into hex code
		// and return it as a number
		//-----------------------------------------------
		public static function getCharCode(ent:String):Number
		{
			var hex:String = ent.substr(3, ent.length)	
			hex = hex.substr(0, hex.length - 1)
			
			return Number("0x" + hex)
		}
	}
}
