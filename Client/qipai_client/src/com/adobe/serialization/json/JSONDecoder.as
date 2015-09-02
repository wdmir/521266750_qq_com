/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.serialization.json {

	public class JSONDecoder {
		
		/** The value that will get parsed from the JSON string */
		private var value:*;
		
		/** The tokenizer designated to read the JSON string */
		private var tokenizer:JSONTokenizer;
		
		/** The current token from the tokenizer */
		private var token:JSONToken;
		
		/**
		 * Constructs a new JSONDecoder to parse a JSON string 
		 * into a native object.
		 *
		 * @param s The JSON string to be converted
		 *		into a native object
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONDecoder( s:String ) {
			
			tokenizer = new JSONTokenizer( s );
			
			nextToken();
			value = parseValue();
		}
		
		/**
		 * Gets the internal object that was created by parsing
		 * the JSON string passed to the constructor.
		 *
		 * @return The internal object representation of the JSON
		 * 		string that was passed to the constructor
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function getValue():* {
			return value;
		}
		
		/**
		 * Returns the next token from the tokenzier reading
		 * the JSON string
		 */
		private function nextToken():JSONToken {
			return token = tokenizer.getNextToken();
		}
		
		/**
		 * Attempt to parse an array
		 */
		private function parseArray():Array {
			// create an array internally that we're going to attempt
			// to parse from the tokenizer
			var a:Array = new Array();
			
			// grab the next token from the tokenizer to move
			// past the opening [
			nextToken();
			
			// check to see if we have an empty array
			if ( token.type == JSONTokenType.RIGHT_BRACKET ) {
				// we're done reading the array, so return it
				return a;
			}
			
			// deal with elements of the array, and use an "infinite"
			// loop because we could have any amount of elements
			while ( true ) {
				// read in the value and add it to the array
				a.push ( parseValue() );
			
				// after the value there should be a ] or a ,
				nextToken();
				
				if ( token.type == JSONTokenType.RIGHT_BRACKET ) {
					// we're done reading the array, so return it
					return a;
				} else if ( token.type == JSONTokenType.COMMA ) {
					// move past the comma and read another value
					nextToken();
				} else {
					tokenizer.parseError( "Expecting ] or , but found " + token.value );
				}
			}
            return null;
		}
		
		/**
		 * Attempt to parse an object
		 */
		private function parseObject():Object {
			// create the object internally that we're going to
			// attempt to parse from the tokenizer
			var o:Object = new Object();
						
			// store the string part of an object member so
			// that we can assign it a value in the object
			var key:String
			
			// grab the next token from the tokenizer
			nextToken();
			
			// check to see if we have an empty object
			if ( token.type == JSONTokenType.RIGHT_BRACE ) {
				// we're done reading the object, so return it
				return o;
			}
			
			// deal with members of the object, and use an "infinite"
			// loop because we could have any amount of members
			while ( true ) {
			
				if ( token.type == JSONTokenType.STRING ) {
					// the string value we read is the key for the object
					key = String( token.value );
					
					// move past the string to see what's next
					nextToken();
					
					// after the string there should be a :
					if ( token.type == JSONTokenType.COLON ) {
						
						// move past the : and read/assign a value for the key
						nextToken();
						o[key] = parseValue();	
						
						// move past the value to see what's next
						nextToken();
						
						// after the value there's either a } or a ,
						if ( token.type == JSONTokenType.RIGHT_BRACE ) {
							// // we're done reading the object, so return it
							return o;
							
						} else if ( token.type == JSONTokenType.COMMA ) {
							// skip past the comma and read another member
							nextToken();
						} else {
							tokenizer.parseError( "Expecting } or , but found " + token.value );
						}
					} else {
						tokenizer.parseError( "Expecting : but found " + token.value );
					}
				} else {
					tokenizer.parseError( "Expecting string but found " + token.value );
				}
			}
            return null;
		}
		
		/**
		 * Attempt to parse a value
		 */
		private function parseValue():Object {
					
			switch ( token.type ) {
				case JSONTokenType.LEFT_BRACE:
					return parseObject();
					
				case JSONTokenType.LEFT_BRACKET:
					return parseArray();
					
				case JSONTokenType.STRING:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
					return token.value;

				default:
					tokenizer.parseError( "Unexpected " + token.value );
					
			}
            return null;
		}
	}
}
