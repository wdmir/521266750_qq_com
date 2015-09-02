/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.serialization.json {

	public class JSONToken {
	
		private var _type:int;
		private var _value:Object;
		
		/**
		 * Creates a new JSONToken with a specific token type and value.
		 *
		 * @param type The JSONTokenType of the token
		 * @param value The value of the token
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONToken( type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object = null ) {
			_type = type;
			_value = value;
		}
		
		/**
		 * Returns the type of the token.
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function get type():int {
			return _type;	
		}
		
		/**
		 * Sets the type of the token.
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function set type( value:int ):void {
			_type = value;	
		}
		
		/**
		 * Gets the value of the token
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function get value():Object {
			return _value;	
		}
		
		/**
		 * Sets the value of the token
		 *
		 * @see com.adobe.serialization.json.JSONTokenType
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function set value ( v:Object ):void {
			_value = v;	
		}

	}
	
}
