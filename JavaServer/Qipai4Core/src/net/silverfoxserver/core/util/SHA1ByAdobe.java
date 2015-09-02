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

public class SHA1ByAdobe
{

	/**
	 *  Performs the SHA1 hash algorithm on a string.
	 *
	 *  @param s		The string to hash
	 *  @return			A string containing the hash value of s
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	9.0
	 *  @tiptext
	 */
	public static String hash(String s)
	{
		//var blocks:Array = createBlocksFromString( s );
		int[] blocks = createBlocksFromString(s);
		//var byteArray:ByteArray = hashBlocks( blocks );

		int[] byteArray = hashBlocks(blocks);
                
                
                return String.valueOf(byteArray[0]) 
                        + String.valueOf(byteArray[1]) 
                        + String.valueOf(byteArray[2])
                        + String.valueOf(byteArray[3])
                        + String.valueOf(byteArray[4]);

//		return IntUtilByAdobe.toHex( byteArray[0], true )
//				+ IntUtilByAdobe.toHex( byteArray[1], true )
//				+ IntUtilByAdobe.toHex( byteArray[2], true )
//				+ IntUtilByAdobe.toHex( byteArray[3], true )
//				+ IntUtilByAdobe.toHex( byteArray[4], true );

		

	}

	private static int[] hashBlocks(int[] blocks)
	{
//            1732584193
//            -271733879
//            -1732584194
//            271733878
//            -1009589776
		// initialize the h's
		int h0 = 1732584193;//0x67452301;

		//-271733879 是 as3的结果
		int h1 = -271733879; //0xefcdab89;
		int h2 = -1732584194; //0x98badcfe;
		int h3 = 271733878;//0x10325476;
		int h4 = -1009589776; //0xc3d2e1f0;

		int len = blocks.length;
		//var w:Array = new Array( 80 );

		int[] w = new int[80];

		// loop over all of the blocks
		for (int i = 0; i < len; i += 16)
		{

			// 6.1.c
			int a = h0;
			int b = h1;
			int c = h2;
			int d = h3;
			int e = h4;

			// 80 steps to process each block
			// TODO: unroll for faster execution, or 4 loops of
			// 20 each to avoid the k and f function calls
			for (int t = 0; t < 80; t++)
			{

				if (t < 16)
				{
					// 6.1.a
					if ((i + t) < len)
					{
						w[t] = blocks[i + t];
					}
					else
					{
						w[t] = 0;
					}

				}
				else
				{
					// 6.1.b
					w[t] = IntUtilByAdobe.rol(w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16], 1);
				}

				// 6.1.d
				int temp = IntUtilByAdobe.rol(a, 5) + f(t, b, c, d) + e + (int)w[t] + k(t);

				e = d;
				d = c;
				c = IntUtilByAdobe.rol(b, 30);
				b = a;
				a = temp;
			}

			// 6.1.e
			h0 += a;
			h1 += b;
			h2 += c;
			h3 += d;
			h4 += e;
		}

		//var byteArray:ByteArray = new ByteArray();
		int[] byteArray = new int[5];
		//byteArray.writeInt(h0);
		//byteArray.writeInt(h1);
		//byteArray.writeInt(h2);
		//byteArray.writeInt(h3);
		//byteArray.writeInt(h4);
		//byteArray.position = 0;

		byteArray[0] = h0;
		byteArray[1] = h1;
		byteArray[2] = h2;
		byteArray[3] = h3;
		byteArray[4] = h4;

		return byteArray;
	}

	/**
	 *  Performs the logical function based on t
	 */
	private static int f(int t, int b, int c, int d)
	{
		if (t < 20)
		{
			return (b & c) | (~b & d);
		}
		else if (t < 40)
		{
			return b ^ c ^ d;
		}
		else if (t < 60)
		{
			return (b & c) | (b & d) | (c & d);
		}
		return b ^ c ^ d;
	}

	/**
	 *  Determines the constant value based on t
	 */
	private static int k(int t)
	{
		if (t < 20)
		{
			return 0x5a827999;
		}
		else if (t < 40)
		{
			return 0x6ed9eba1;
		}
		else if (t < 60)
		{
			//return 0x8f1bbcdc;
			return -1894007588;
		}

		//return 0xca62c1d6;
		return -899497514;
	}

	/**
	 *  Converts a string to a sequence of 16-word blocks
	 *  that we'll do the processing on.  Appends padding
	 *  and length in the process.
	 *
	 *  @param s	The string to split into blocks
	 *  @return		An array containing the blocks that s was split into.
	 */
	private static int[] createBlocksFromString(String s)
	{

		//var blocks:Array = new Array();
		int len = s.length() * 8;

		int[] blocks = new int[len];

		for (int j = 0; j < len; j++)
		{
			blocks[j] = 0;
		}

		/**/
		int mask = 0xFF; // ignore hi byte of characters > 0xFF
		char[] c = s.toCharArray();
		for (int i = 0; i < len; i += 8)
		{
			//blocks[ i >> 5 ] |= ( s.charCodeAt( i / 8 ) & mask ) << ( 24 - i % 32 );

//C# TO JAVA CONVERTER WARNING: The right shift operator was not replaced by Java's logical right shift operator since the left operand was not confirmed to be of an unsigned type, but you should review whether the logical right shift operator (>>>) is more appropriate:
			blocks[i >> 5] |= ((int)(c[i / 8]) & mask) << (24 - i % 32);
		}

		// append padding and length
//C# TO JAVA CONVERTER WARNING: The right shift operator was not replaced by Java's logical right shift operator since the left operand was not confirmed to be of an unsigned type, but you should review whether the logical right shift operator (>>>) is more appropriate:
		blocks[len >> 5] |= 0x80 << (24 - len % 32);
//C# TO JAVA CONVERTER WARNING: The right shift operator was not replaced by Java's logical right shift operator since the left operand was not confirmed to be of an unsigned type, but you should review whether the logical right shift operator (>>>) is more appropriate:
		blocks[(((len + 64) >> 9) << 4) + 15] = len;
		return blocks;

	}



}
