/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.utils
{

	public class XMLUtil
	{
		/**
		 * Constant representing a text node type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static const TEXT:String = "text";
		
		/**
		 * Constant representing a comment node type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const COMMENT:String = "comment";
		
		/**
		 * Constant representing a processing instruction type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const PROCESSING_INSTRUCTION:String = "processing-instruction";
		
		/**
		 * Constant representing an attribute type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const ATTRIBUTE:String = "attribute";
		
		/**
		 * Constant representing a element type returned from XML.nodeKind.
		 * 
		 * @see XML.nodeKind()
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static const ELEMENT:String = "element";
		
		/**
		 * Checks whether the specified string is valid and well formed XML.
		 * 
		 * @param data The string that is being checked to see if it is valid XML.
		 * 
		 * @return A Boolean value indicating whether the specified string is
		 * valid XML.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public static function isValidXML(data:String):Boolean
		{
			var xml:XML;
			
			try
			{
				xml = new XML(data);
			}
			catch(e:Error)
			{
				return false;
			}
			
			if(xml.nodeKind() != XMLUtil.ELEMENT)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * Returns the next sibling of the specified node relative to the node's parent.
		 * 
		 * @param x The node whose next sibling will be returned.
		 * 
		 * @return The next sibling of the node. null if the node does not have 
		 * a sibling after it, or if the node has no parent.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public static function getNextSibling(x:XML):XML
		{	
			return XMLUtil.getSiblingByIndex(x, 1);
		}
		
		/**
		 * Returns the sibling before the specified node relative to the node's parent.
		 * 
		 * @param x The node whose sibling before it will be returned.
		 * 
		 * @return The sibling before the node. null if the node does not have 
		 * a sibling before it, or if the node has no parent.
		 * 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */			
		public static function getPreviousSibling(x:XML):XML
		{	
			return XMLUtil.getSiblingByIndex(x, -1);
		}		
		
		protected static function getSiblingByIndex(x:XML, count:int):XML	
		{
			var out:XML;
			
			try
			{
				out = x.parent().children()[x.childIndex() + count];	
			} 		
			catch(e:Error)
			{
				return null;
			}
			
			return out;			
		}
	}
}
