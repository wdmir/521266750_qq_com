/*
 * SilverFoxServer: massive multiplayer game server for Flash, ...
 * VERSION:3.0
 * PUBLISH DATE:2015-9-2 
 * GITHUB:github.com/wdmir/521266750_qq_com
 * UPDATES AND DOCUMENTATION AT: http://www.silverfoxserver.net
 * COPYRIGHT 2009-2015 SilverFoxServer.NET. All rights reserved.
 * MAIL:521266750@qq.com
 */
package net.silverfoxserver.core.util;

public class IntUtilByAdobe
{
        /** String for quick lookup of a hex character based on index */
	private static String hexChars = "0123456789abcdef";
                

	/**
	 * Rotates x left n bits
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 * 
	 * 
	 * 
	 */
	public static int rol(int x, int n)
	{

		//return ( x << n ) | ( x >>> ( 32 - n ) );

		return (x << n) | bitwise_unsigned_right_shift(x, (32 - n));
	}

	/**
	 * 
	 * For instance "-100>>>2" returns "1073741799".
	    
	   int x = -100;
	   int y = (int)((uint)x >> 2);
	   Console.WriteLine(y); // Prints 1073741799
	 * 
	 */ 
	public static int bitwise_unsigned_right_shift(int x, int shift)
	{
//C# TO JAVA CONVERTER WARNING: The right shift operator was replaced by Java's logical right shift operator since the left operand was originally of an unsigned type, but you should confirm this replacement:
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: return (int)((uint)x >> shift);
	   return (int)((int)x >>> shift);
	}

	/**
	 * Rotates x right n bits
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: public static uint ror(int x, int n)
	public static int ror(int x, int n)
	{
		int nn = 32 - n;
		//return ( x << nn ) | ( x >>> ( 32 - nn ) );

//C# TO JAVA CONVERTER WARNING: Unsigned integer types have no direct equivalent in Java:
//ORIGINAL LINE: return Convert.ToUInt32((x << nn) | bitwise_unsigned_right_shift(x,(32 - nn)));
		return (int)((x << nn) | bitwise_unsigned_right_shift(x, (32 - nn)));
	}

	/** String for quick lookup of a hex character based on index */
	//private static String hexChars = "0123456789abcdef";

	/**
	 * Outputs the hex value of a int, allowing the developer to specify
	 * the endinaness in the process.  Hex output is lowercase.
	 *
	 * @param n The int value to output as hex
	 * @param bigEndian Flag to output the int as big or little endian
	 * @return A string of length 8 corresponding to the 
	 *		hex representation of n ( minus the leading "0x" )
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */

        public static String toHex( int n, Boolean bigEndian )
        {
                String s = "";

                if ( bigEndian ) {
                        for ( int i = 0; i < 4; i++ ) {
                                s += hexChars.charAt( ( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF ) 
                                        + hexChars.charAt( ( n >> ( ( 3 - i ) * 8 ) ) & 0xF );
                        }
                } else {
                        for ( int x = 0; x < 4; x++ ) {
                                s += hexChars.charAt( ( n >> ( x * 8 + 4 ) ) & 0xF )
                                        + hexChars.charAt( ( n >> ( x * 8 ) ) & 0xF );
                        }
                }

                return s;
        }
        
	/*
	 * 这段代码有问题 ，得出的结果全是数字和 as3不一样
	public static String toHex( int n, Boolean bigEndian = false ) {
		String s = "";
		
		if ( bigEndian ) {
			for ( int i = 0; i < 4; i++ ) {
				s += hexChars[ ( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF ] 
					+ hexChars[ ( n >> ( ( 3 - i ) * 8 ) ) & 0xF ];
			}
		} else {
			for ( int x = 0; x < 4; x++ ) {
				s += hexChars[ ( n >> ( x * 8 + 4 ) ) & 0xF ]
					+ hexChars[ ( n >> ( x * 8 ) ) & 0xF ];
			}
		}
		
		return s;
	}
	*/




}
