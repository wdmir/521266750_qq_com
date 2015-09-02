/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package com.adobe.utils
{
	
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Arrays.
	* 
	*	Note that all APIs assume that they are working with well formed arrays.
	*	i.e. they will only manipulate indexed values.  
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/		
	public class ArrayUtil
	{
				
		/**
		*	Determines whether the specified array contains the specified value.	
		* 
		* 	@param arr The array that will be checked for the specified value.
		*
		*	@param value The object which will be searched for within the array
		* 
		* 	@return True if the array contains the value, False if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function arrayContainsValue(arr:Array, value:Object):Boolean
		{
			return (arr.indexOf(value) != -1);
		}	
		
		/**
		*	Remove all instances of the specified value from the array,
		* 
		* 	@param arr The array from which the value will be removed
		*
		*	@param value The object that will be removed from the array.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function removeValueFromArray(arr:Array, value:Object):void
		{
			var len:uint = arr.length;
			
			for(var i:Number = len; i > -1; i--)
			{
				if(arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}					
		}

		/**
		*	Create a new array that only contains unique instances of objects
		*	in the specified array.
		*
		*	Basically, this can be used to remove duplication object instances
		*	from an array
		* 
		* 	@param arr The array which contains the values that will be used to
		*	create the new array that contains no duplicate values.
		*
		*	@return A new array which only contains unique items from the specified
		*	array.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function createUniqueCopy(a:Array):Array
		{
			var newArray:Array = new Array();
			
			var len:Number = a.length;
			var item:Object;
			
			for (var i:uint = 0; i < len; ++i)
			{
				item = a[i];
				
				if(ArrayUtil.arrayContainsValue(newArray, item))
				{
					continue;
				}
				
				newArray.push(item);
			}
			
			return newArray;
		}
		
		/**
		*	Creates a copy of the specified array.
		*
		*	Note that the array returned is a new array but the items within the
		*	array are not copies of the items in the original array (but rather 
		*	references to the same items)
		* 
		* 	@param arr The array that will be copies
		*
		*	@return A new array which contains the same items as the array passed
		*	in.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function copyArray(arr:Array):Array
		{	
			return arr.slice();
		}
		
		/**
		*	Compares two arrays and returns a boolean indicating whether the arrays
		*	contain the same values at the same indexes.
		* 
		* 	@param arr1 The first array that will be compared to the second.
		*
		* 	@param arr2 The second array that will be compared to the first.
		*
		*	@return True if the arrays contains the same values at the same indexes.
			False if they do not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			
			var len:Number = arr1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if(arr1[i] !== arr2[i])
				{
					return false;
				}
			}
			
			return true;
		}
	}
}
