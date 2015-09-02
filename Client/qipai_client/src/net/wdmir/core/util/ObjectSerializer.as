/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdmir.core.util
{
	/**
	 * ObjectSerializer class.
	 * 
	 * @version	1.0.0
	 * 
	 * @author	The gotoAndPlay() Team
	 * 			{@link http://www.smartfoxserver.com}
	 * 			{@link http://www.gotoandplay.it}
	 * 
	 * @exclude
	 */
	public class ObjectSerializer
	{
		private static var instance:ObjectSerializer
		
		private var debug:Boolean
		private var eof:String
		private var tabs:String
		
		/**
		 * Singleton: private constructor
		 */
		public function ObjectSerializer(debug:Boolean = false)
		{
			this.tabs 	= "\t\t\t\t\t\t\t\t\t\t\t\t\t"
			setDebug(debug)
		}
		
		
		/**
		 * Set debug
		 */
		private function setDebug(b:Boolean):void
		{
			this.debug = b
			
			if (this.debug)
				this.eof = "\n"
			else
				this.eof = ""
		}
		
		
		/**
		 * Return the one and only instance of this class
		 */
		public static function getInstance(debug:Boolean = false):ObjectSerializer
		{
			if (instance == null)
				instance = new ObjectSerializer(debug)
				
			return instance
		}
		
		public function serialize(o:Object):String
		{
			var result:Object = {}
			obj2xml(o, result)
			
			return result.xmlStr	
		}
		
		public function deserialize(xmlString:String):Object
		{
			var xmlData:XML = new XML(xmlString)
			var resObj:Object = {}
			
			xml2obj(xmlData, resObj)
			
			return resObj
		}
		
		private function obj2xml(srcObj:Object, trgObj:Object, depth:int = 0, objName:String = ""):void
		{
			// First run
			if (depth == 0)
			{
				trgObj.xmlStr = "<dataObj>" + this.eof
			}
			
			// Inside a recursive call
			else
			{
				if (this.debug)
					trgObj.xmlStr += this.tabs.substr(0, depth)
					
				// Object type
				var ot:String = (srcObj is Array) ? "a" : "o"	
				trgObj.xmlStr += "<obj t='" + ot + "' o='" + objName + "'>" + this.eof
			}
			
			// Scan the object recursively
			for (var i:String in srcObj)
			{
				var t:String = typeof srcObj[i]
				var o:*		 = srcObj[i]		
				
				//
				// if a primitive type is found
				// generate an xml <var n="name" t="type">value</var> TAG
				//
				// n = name of var
				//
				// t = b: boolean
				//     n: number
				//     s: string
				//     x: null
				//
				// v = value of var
				//
				if ((t == "boolean") || (t == "number") || (t == "string") || (t == "null"))
				{	
					if (t == "boolean")
					{
						o = Number(o)
					}
					else if (t == "null")
					{
						t = "x"
						o = ""
					}
					else if (t == "string")
					{
						o = Entities.encodeEntities(o) 
					}
					
					if (this.debug)
						trgObj.xmlStr += this.tabs.substr(0, depth + 1)
					
					trgObj.xmlStr += "<var n='" + i + "' t='" + t.substr(0,1) + "'>" + o + "</var>" + this.eof
				}
				
				//
				// if an object / array is found
				// recursively scans the new Object
				// and create a <obj o=""></obj> TAG
				//
				// o = object name
				//
				else if (t == "object")
				{
					obj2xml(o, trgObj, depth + 1, i)
					
					if (this.debug)
						trgObj.xmlStr += this.tabs.substr(0, depth + 1)
		
					trgObj.xmlStr += "</obj>" + this.eof
				}
			}
			
			// Close root TAG
			if (depth == 0)
				trgObj.xmlStr += "</dataObj>" + this.eof
		}

		
		private function xml2obj(x:XML, o:Object):void
		{
			var i:int = 0
			var nodes:XMLList = x.children()
			var nodeName:String
			
			for each(var node:XML in nodes)
			{ 
				nodeName = node.name().toString()
				
				// Handle Object
				if (nodeName == "obj")
				{
					var objName:String = node.@o
					var objType:String = node.@t
					
					// Create nested array
					if (objType == "a")
						o[objName] = []
					
					// Create nested object
					else if (objType == "o")
						o[objName] = {}
						
					xml2obj(node, o[objName])
				}
				
				// Handle Array
				else if (nodeName == "var")
				{
					var varName:String = node.@n
					var varType:String = node.@t
					var varVal:String = node.toString()
					
					// Cast variable to its original type
					if (varType == "b")
						o[varName] = (varVal == "0" ? false : true)
							
					else if (varType == "n")
						o[varName] = Number(varVal)
						
					else if (varType == "s")
						o[varName] = varVal // No need of Entities.decodeEntities()
						
					else if (varType == "x")
						o[varName] = null
				}
			}	
		}
		
		private function encodeEntities(s:String):String
		{
			return s
		}
	}
}
