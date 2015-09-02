package State.Room.RoomModel
{
	import mx.events.IndexChangedEvent;
	
	import net.wdmir.core.logic.ddz.PaiUnit;
	import net.wdmir.core.logic.ddz.PaiCode;
	import net.wdmir.core.logic.ddz.PaiRule;
	import net.wdmir.core.logic.ddz.PaiUnit;
	
	
	/**
	 * PaiRule代码比较多，因此分出一个类
	 * 
	 * px = 牌形
	 * 
	 * pr = 牌rule
	 * 
	 * pc = 牌code
	 * 
	 * pcMeta = 牌code归位后的元数据
	 * 
	 */ 
	public class PaiRuleTip
	{		
		
		/**
		 * pickup 纯的摘要结果
		 */ 
		public static var pickup:Array = new Array();
		
		private static function samePun(a:PaiUnit,b:PaiUnit):Boolean
		{
			var same:Boolean = true;
			var i:int =0;
			var len:int = b.code.length;
			
			for(i = 0;i<len;i++)
			{
				if(a.code.indexOf(b.code[i]) == -1)
				{
					same = false;
					break;
				}			
			}
			
			return same;		
		}
		
		/**
		 * 
		 */ 
		private static function makeup_pair():Array
		{
			var makeup:Array = new Array();
			
			var makeup1:Array = pickup_pair();
			var makeup2:Array = pickup_pair_sanzhang();
			
			var i:int = 0;
			var len:int = makeup1.length;
			
			for(i=0;i<len;i++)
			{
				makeup.push(makeup1[i]);			
			}
			
			//
			len = makeup2.length;
			
			for(i=0;i<len;i++)
			{
				makeup.push(makeup2[i]);			
			}			
			
			return makeup;
		}
		
		/**
		 * 获取对子,
		 * 对子可以是无关联的
		 * 
		 */ 
		private static function makeup_pairX(num:int):Array
		{
			var makeup:Array = new Array();
			
			var makeup2:Array = pickup_pair();
			var makeup3:Array = pickup_pair_sanzhang();
			
			//check
			if(1 == num)
			{
				throw new Error("you should use this func: makeup_pair()");
			}
			
			//对子充足
			if(makeup2.length >= num)
			{
				makeup_pairX_full(makeup,makeup2,num);
			}
			else
			{
				//借
				if(makeup3.length > 0)
				{					
					if((makeup2.length + makeup3.length) >= num)
					{
						makeup_pairX_borrow(makeup,makeup2,makeup3,num);
					}					
								
				}else if(makeup3.length == 0)
				{					
				
				}
				
			}//end if
			
			
			return makeup;
		
		}
		
		private static function makeup_pairX_full(makeup:Array,mu:Array,num:int):void
		{
			if(num >= 2)
			{
				makeup_pairX_full_num2_more(makeup,mu,num);
			
			}else if(num == 1)
			{
				var muLen:int = mu.length;
				
				for(var i:int =0;i<muLen;i++)
				{
					var pun:PaiUnit = new PaiUnit(
													(mu[i] as PaiUnit).code[0],
													(mu[i] as PaiUnit).code[1]
												 );
												 
					makeup.push(pun);
				}
			
			}else
			{
				throw new Error("num can not <= 0 ");			
			}
		
		}
		
		private static function makeup_pairX_full_num2_more(makeup:Array,mu:Array,num:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var pun:PaiUnit;
			//
			var p:int = -1;			
			var muLen:int = mu.length;
			
			//check
			if(num < 2)
			{
				throw new Error("num can not < 2");
			}			
			
			for(i=0;i<muLen;i++)
			{
				pun = new PaiUnit((mu[i] as PaiUnit).code[0],
								  (mu[i] as PaiUnit).code[1]);
								
				for(j=i+1;j<muLen;j++)
				{
					pun.code.push(
						(mu[j] as PaiUnit).code[0],
						(mu[j] as PaiUnit).code[1]);
						
					if(-1 == p)
					{
						p = j;
					}
								
					//save
					//if(pun.code.length == num)
					if((pun.code.length/2) == num)
					{
						makeup.push(pun);
						pun = new PaiUnit((mu[i] as PaiUnit).code[0],
										  (mu[i] as PaiUnit).code[1]);							
						j = p;							
						p = -1;
					} 						
				}
						
			}//end for	
				
			mu.reverse();	
				
			//trace(mu);
			p= -1;
			muLen = mu.length;
				
			for(i=0;i<muLen;i++)
			{
				pun = new PaiUnit((mu[i] as PaiUnit).code[0],
								  (mu[i] as PaiUnit).code[1]);
								
				for(j=i+1;j<muLen;j++)
				{
					pun.code.push(
						(mu[j] as PaiUnit).code[0],
						(mu[i] as PaiUnit).code[1]);
						
					if(-1 == p)
					{
						p = j;
					}
								
					//save
					//if(pun.code.length == num)
					if((pun.code.length/2) == num)
					{
						makeup.push(pun);
						pun = new PaiUnit((mu[i] as PaiUnit).code[0],
										  (mu[i] as PaiUnit).code[1]);							
						j = p;							
						p = -1;
					} 						
				}
						
			}//end for	
				
			//用完后还原
			mu.reverse();
				
			//
			makeup_deleteDup(makeup);
		
		}
		
		private static function makeup_pairX_borrow(makeup:Array,mu:Array,muBorrow:Array,num:int):void
		{
			var z:int = num - mu.length;
			var pun:PaiUnit;
			var k:int = 0;
			var i:int = 0;
			var n:int = 0;
			
			if(z >= 2)
			{
				makeup_pairX_borrow_num2_more(makeup,mu,muBorrow,num);
			
			}else if(z == 1)
			{
				var muLen:int = mu.length;
				var muBorrowLen:int = muBorrow.length;
				
				var muBorrowNew:Array = new Array();
					
				makeup_pairX_full(muBorrowNew,muBorrow,z);
					
				//				
				pun = new PaiUnit((mu[0] as PaiUnit).code[0],
								  (mu[0] as PaiUnit).code[1]);
								  
				for(k=1;k<muLen;k++)
				{
					pun.code.push((mu[k] as PaiUnit).code[0],
								  (mu[k] as PaiUnit).code[1]);	
				}
					
				//
				for(i=0;i<muBorrowNew.length;i++)
				{			
					var p:PaiUnit = pun.clone();
					
					for(n=0;n<(muBorrowNew[i] as PaiUnit).code.length;n++)
					{
						p.code.push((muBorrowNew[i] as PaiUnit).code[n]);
					
					}
						
					makeup.push(p);
					
				}				
			
			}else
			{
				throw new Error("z can not <= 0 ");			
			}
		
		}		
		
		private static function makeup_pairX_borrow_num2_more(makeup:Array,mu:Array,muBorrow:Array,num:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var n:int = 0;
			var pun:PaiUnit;
			//	
			var muLen:int = mu.length;
			var muBorrowLen:int = muBorrow.length;	
						
			//借之前先borrow的组合先弄出来
			var z:int = num - muLen;	
					
			//
			if(muBorrowLen >= z)
			{
				var muBorrowNew:Array = new Array();
				
				makeup_pairX_full(muBorrowNew,muBorrow,z);
				
				//				
				pun = new PaiUnit((mu[0] as PaiUnit).code[0],
				                  (mu[0] as PaiUnit).code[1]);
				
				for(k=1;k<muLen;k++)
				{
					pun.code.push((mu[k] as PaiUnit).code[0],
					              (mu[k] as PaiUnit).code[1]);	
				}
				
				//
				for(i=0;i<muBorrowNew.length;i++)
				{			
					var p:PaiUnit = pun.clone();
					
					for(n=0;n<(muBorrowNew[i] as PaiUnit).code.length;n++)
					{
						p.code.push((muBorrowNew[i] as PaiUnit).code[n]);
					
					}
					
					makeup.push(p);
				
				}
				
			
			}else{};
		
		
		}
		
		/**
		 * 获取单牌
		 */ 
		private static function makeup_single():Array
		{
			var makeup:Array = new Array();
			
			var makeup1:Array = pickup_single();
			var makeup2:Array = pickup_single_pair();
			var makeup3:Array = pickup_single_sanzhang();
			
			var i:int = 0;
			var len:int = makeup1.length;
			
			for(i=0;i<len;i++)
			{
				makeup.push(makeup1[i]);			
			}
			
			//
			len = makeup2.length;
			
			for(i=0;i<len;i++)
			{
				makeup.push(makeup2[i]);			
			}
			
			//
			len = makeup3.length;
			
			for(i=0;i<len;i++)
			{
				makeup.push(makeup3[i]);			
			}
			
			return makeup;
		
		}
		
		/**
		 * 获取单牌,
		 * 单牌可以是无关联的
		 * 
		 */ 
		private static function makeup_singleX(num:int):Array
		{			
			var makeup:Array = new Array();
			
			var makeup1:Array = pickup_single();
			var makeup2:Array = pickup_single_pair();
			var makeup3:Array = pickup_single_sanzhang();
			
			//check
			if(1 == num)
			{
				throw new Error("you should use this func: makeup_single()");
			}
			
			//单牌充足
			if(makeup1.length >= num)
			{
				makeup_singleX_full(makeup,makeup1,num);
			}
			else
			{
				//借
				if(makeup1.length > 0)
				{
					if((makeup1.length + makeup2.length) >= num)
					{
						makeup_singleX_borrow(makeup,makeup1,makeup2,num);
					}
					
					if((makeup1.length + makeup3.length) >= num)
					{
						makeup_singleX_borrow(makeup,makeup1,makeup3,num);
					}
					
					if((makeup1.length + makeup2.length) < num &&
				   	   (makeup1.length+makeup2.length+makeup3.length) >= num)
					{
						var makeup1_2:Array = new Array();
						
						var x:int = 0;
						for(x = 0;x<makeup1.length;x++)
						{
							makeup1_2.push(makeup1[x]);
						}
						
						for(x = 0;x<makeup2.length;x++)
						{
							makeup1_2.push(makeup2[x]);
						}
						
						makeup_singleX_borrow(makeup,makeup1_2,makeup3,num);
					}	
								
				}else if(makeup1.length == 0)
				{
					if(makeup2.length >= num)
					{
						makeup_singleX_full(makeup,makeup2,num);
					}
					
					if(makeup3.length >= num)
					{
						makeup_singleX_full(makeup,makeup3,num);
					}
					
					//2向3借
					if(makeup2.length < num && (makeup2.length+makeup3.length) >= num)
					{
						makeup_singleX_borrow(makeup,makeup2,makeup3,num);
					}
					
					//3没得借
				
				}
				
			}//end if
			
			
			return makeup;
		
		}	
		
		private static function makeup_singleX_full(makeup:Array,mu:Array,num:int):void
		{
			if(num >= 2)
			{
				makeup_singleX_full_num2_more(makeup,mu,num);
			
			}else if(num == 1)
			{
				var muLen:int = mu.length;
				
				for(var i:int =0;i<muLen;i++)
				{
					var pun:PaiUnit = new PaiUnit(
													(mu[i] as PaiUnit).code[0]
												 );
												 
					makeup.push(pun);
				}
			
			}else
			{
				throw new Error("num can not <= 0 ");			
			}
		
		}
		
		private static function makeup_singleX_full_num2_more(makeup:Array,mu:Array,num:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var pun:PaiUnit;
			//
			var p:int = -1;			
			var muLen:int = mu.length;
			
			//check
			if(num < 2)
			{
				throw new Error("num can not < 2");
			}
			
			
			for(i=0;i<muLen;i++)
			{
				pun = new PaiUnit((mu[i] as PaiUnit).code[0]);
								
				for(j=i+1;j<muLen;j++)
				{
					pun.code.push(
						(mu[j] as PaiUnit).code[0]);
						
					if(-1 == p)
					{
						p = j;
					}
								
					//save
					if(pun.code.length == num)
					{
						makeup.push(pun);
						pun = new PaiUnit((mu[i] as PaiUnit).code[0]);							
						j = p;							
						p = -1;
					} 						
				}
						
			}//end for	
				
			mu.reverse();	
				
			//trace(mu);
			p= -1;
			muLen = mu.length;
				
			for(i=0;i<muLen;i++)
			{
				pun = new PaiUnit((mu[i] as PaiUnit).code[0]);
								
				for(j=i+1;j<muLen;j++)
				{
					pun.code.push(
						(mu[j] as PaiUnit).code[0]);
						
					if(-1 == p)
					{
						p = j;
					}
								
					//save
					if(pun.code.length == num)
					{
						makeup.push(pun);
						pun = new PaiUnit((mu[i] as PaiUnit).code[0]);							
						j = p;							
						p = -1;
					} 						
				}
						
			}//end for	
				
			//用完后还原
			mu.reverse();
				
			//
			makeup_deleteDup(makeup);
		}	
		
		private static function makeup_singleX_borrow(makeup:Array,mu:Array,muBorrow:Array,num:int):void
		{
			var z:int = num - mu.length;
			var pun:PaiUnit;
			var k:int = 0;
			var i:int = 0;
			var n:int = 0;
			
			if(z >= 2)
			{
				makeup_singleX_borrow_num2_more(makeup,mu,muBorrow,num);
			
			}else if(z == 1)
			{
				var muLen:int = mu.length;
				var muBorrowLen:int = muBorrow.length;
				
				var muBorrowNew:Array = new Array();
					
				makeup_singleX_full(muBorrowNew,muBorrow,z);
					
				//				
				pun = new PaiUnit((mu[0] as PaiUnit).code[0]);
				for(k=1;k<muLen;k++)
				{
					pun.code.push((mu[k] as PaiUnit).code[0]);	
				}
					
				//
				for(i=0;i<muBorrowNew.length;i++)
				{			
					var p:PaiUnit = pun.clone();
					
					for(n=0;n<(muBorrowNew[i] as PaiUnit).code.length;n++)
					{
						p.code.push((muBorrowNew[i] as PaiUnit).code[n]);
					
					}
						
					makeup.push(p);
					
				}				
			
			}else
			{
				throw new Error("z can not <= 0 ");			
			}
		}
		
		private static function makeup_singleX_borrow_num2_more(makeup:Array,mu:Array,muBorrow:Array,num:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var n:int = 0;
			var pun:PaiUnit;
			//	
			var muLen:int = mu.length;
			var muBorrowLen:int = muBorrow.length;	
						
			//借之前先borrow的组合先弄出来
			var z:int = num - muLen;	
					
			//
			if(muBorrowLen >= z)
			{
				var muBorrowNew:Array = new Array();
				
				makeup_singleX_full(muBorrowNew,muBorrow,z);
				
				//				
				pun = new PaiUnit((mu[0] as PaiUnit).code[0]);
				for(k=1;k<muLen;k++)
				{
					pun.code.push((mu[k] as PaiUnit).code[0]);	
				}
				
				//
				for(i=0;i<muBorrowNew.length;i++)
				{			
					var p:PaiUnit = pun.clone();
					
					for(n=0;n<(muBorrowNew[i] as PaiUnit).code.length;n++)
					{
						p.code.push((muBorrowNew[i] as PaiUnit).code[n]);
					
					}
					
					makeup.push(p);
				
				}
				
			
			}else{};
		
		
		}
		
		private static function makeup_deleteDup(makeup:Array):void
		{		
			var i:int = 0;
			var j:int = 0;
			
			var a:PaiUnit;
			var b:PaiUnit;
			
			for(i = 0;i<makeup.length;i++)
			{
				a = makeup[i] as PaiUnit;	
							
				for(j=i+1;j<makeup.length;j++)
				{					
					b = makeup[j] as PaiUnit;	
					
					if(samePun(a,b))
					{
						makeup.splice(j,1);
						//
						i=-1;
						break;
					}
				}
			}
		
		}
		
				
		
		private static function pickup_single():Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.SINGLE == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0]);
								
					makeup.push(pun);
				}				
			}
			
			return makeup;
		}
				
		/**
		 * makeup 非纯的摘要结果
		 */ 		
		private static function pickup_single_pair():Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.PAIR == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0]);
								
					makeup.push(pun);
				}				
			}
			
			return makeup;
		}
		
		private static function pickup_single_sanzhang():Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.SANZHANG == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0]);
								
					makeup.push(pun);
				}				
			}
			
			return makeup;
		}		
		
		private static function pickup_pair_sanzhang():Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.SANZHANG == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1]);
								
					makeup.push(pun);
				}				
			}
			
			return makeup;		
		}
		
		private static function pickup_pair():Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.PAIR == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1]);
								
					makeup.push(pun);
				}				
			}
			
			return makeup;
		
		}
		
		private static function pickup_sanzhang():Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.SANZHANG == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1],
								(pickup[i] as PaiUnit).code[2]);
								
					makeup.push(pun);
				}				
			}
			
			return makeup;
		
		}
						
		private static function pickup_bomb():Array
		{
			var i:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				//这里不同
				if(PaiRule.BOMB == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1],
								(pickup[i] as PaiUnit).code[2],
								(pickup[i] as PaiUnit).code[3]);
								
					makeup.push(pun);
				}
				
			}
			
			return makeup;
		}
		
		/**
		 * 再上面就是4张了，所以BesideNone
		 * 
		 */ 
		private static function pickup_sanshun(num:int=3):Array
		{
			var i:int =0;
			var j:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			//
			var step:int = num-1;
			
			//
			for(i=0;i<len;i++)
			{
				//SANZHANG 这里不同
				if(PaiRule.SANZHANG == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit((pickup[i] as PaiUnit).code[0],
					                  (pickup[i] as PaiUnit).code[1],
					                  (pickup[i] as PaiUnit).code[2]);
					
					var ok:Boolean = true;
					
					if((i+step) < len)
					{
						//
						var k:int = i;
						
						while(k <(i+step))
						{
							if(PaiRule.SANZHANG == (pickup[k+1] as PaiUnit).Rule)
							{								
								if(PaiCode.ai((pickup[k] as PaiUnit).Meta,
								              (pickup[k+1] as PaiUnit).Meta)
								  )
								{
									pun.code.push((pickup[k+1] as PaiUnit).code[0]);
									pun.code.push((pickup[k+1] as PaiUnit).code[1]);
									pun.code.push((pickup[k+1] as PaiUnit).code[2]);
									
								}else{ ok = false; }
							
							}else { ok = false; }
							
							k++;
						}//end while
						
						if(ok)
						{
							makeup.push(pun);							
						}
												
					}//end if				
				
				}
			
			}//end for
		
			return makeup;		
		}
		
		/**
		 * 根据pick后的结果，进行二次处理，
		 * 
         * 对三张进行筛选,得到sanshun3,可向2张借
         * 
		 */ 
		private static function makeup_pairLink_sanzhang(num:int=3):Array
		{
			var i:int =0;
			var j:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			//
			var step:int = num-1;
			
			//
			for(i=0;i<len;i++)
			{
				//SANZHANG 这里不同
				if(PaiRule.SANZHANG == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit((pickup[i] as PaiUnit).code[0],
					                  (pickup[i] as PaiUnit).code[1]);
					
					var ok:Boolean = true;
					
					if((i+step) < len)
					{
						//
						var k:int = i;
						
						while(k <(i+step))
						{
							if(PaiRule.PAIR == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.SANZHANG == (pickup[k+1] as PaiUnit).Rule)
							{								
								if(PaiCode.ai((pickup[k] as PaiUnit).Meta,
								              (pickup[k+1] as PaiUnit).Meta)
								  )
								{
									pun.code.push((pickup[k+1] as PaiUnit).code[0]);
									pun.code.push((pickup[k+1] as PaiUnit).code[1]);
								
								}else{ ok = false; }
							
							}else { ok = false; }
							
							k++;
						}//end while
						
						if(ok)
						{
							makeup.push(pun);							
						}
												
					}//end if				
				
				}
			
			}//end for
		
			return makeup;
		
		}
		
		/**
		 * 根据pick后的结果，进行二次处理，
		 * 
		 * 对对子进行筛选,得到pairlink3,可向3张借2
		 */ 
		private static function makeup_pairLink_pair(num:int=3):Array
		{
			var i:int =0;
			var j:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			//
			var step:int = num-1;
			
			//
			for(i=0;i<len;i++)
			{
				if(PaiRule.PAIR == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit((pickup[i] as PaiUnit).code[0],
					                  (pickup[i] as PaiUnit).code[1]);
					
					var ok:Boolean = true;
					
					if((i+step) < len)
					{
						//
						var k:int = i;
						
						while(k <(i+step))
						{
							if(PaiRule.PAIR == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.SANZHANG == (pickup[k+1] as PaiUnit).Rule)
							{								
								if(PaiCode.ai((pickup[k] as PaiUnit).Meta,
								              (pickup[k+1] as PaiUnit).Meta)
								  )
								{
									pun.code.push((pickup[k+1] as PaiUnit).code[0]);
									pun.code.push((pickup[k+1] as PaiUnit).code[1]);
								
								}else{ ok = false; }
							
							}else { ok = false; }
							
							k++;
						}//end while
						
						if(ok)
						{
							makeup.push(pun);							
						}
												
					}//end if				
				
				}
			
			}//end for
		
			return makeup;
		}
		
		/**
		 * 可向下容对子,单牌
		 */ 
		private static function makeup_singleLink_sanzhang(num:int=5):Array
		{
			var i:int =0;
			var j:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			//
			var step:int = num-1;
			
			//
			for(i=0;i<len;i++)
			{
				//三张起步
				if(PaiRule.SANZHANG == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit((pickup[i] as PaiUnit).code[0]);
					
					var ok:Boolean = true;
					
					if((i+step) < len)
					{
						//
						var k:int = i;
						
						while(k <(i+step))
						{
							if(PaiRule.SINGLE == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.PAIR == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.SANZHANG == (pickup[k+1] as PaiUnit).Rule)
							{								
								if(PaiCode.ai((pickup[k] as PaiUnit).Meta,
								              (pickup[k+1] as PaiUnit).Meta)
								  )
								{
									pun.code.push((pickup[k+1] as PaiUnit).code[0]);
								
								}else{ ok = false; }
							
							}else { ok = false; }
							
							k++;
						}//end while
						
						if(ok)
						{
							makeup.push(pun);							
						}
												
					}//end if				
				
				}
			
			}//end for
		
			return makeup;
		
		}
		
		/**
		 * 根据pick后的结果，进行二次处理，
		 * 
		 * 对对牌进行筛选,得到singlelink5,可向3张借1
		 * 
		 * 也可向下容单牌
		 */
		private static function makeup_singleLink_pair(num:int=5):Array
		{
			var i:int =0;
			var j:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			//
			var step:int = num-1;
			
			//
			for(i=0;i<len;i++)
			{
				//二张起步
				if(PaiRule.PAIR == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit((pickup[i] as PaiUnit).code[0]);
					
					var ok:Boolean = true;
					
					if((i+step) < len)
					{
						//
						var k:int = i;
						
						while(k <(i+step))
						{
							if(PaiRule.SINGLE == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.PAIR == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.SANZHANG == (pickup[k+1] as PaiUnit).Rule)
							{								
								if(PaiCode.ai((pickup[k] as PaiUnit).Meta,
								              (pickup[k+1] as PaiUnit).Meta)
								  )
								{
									pun.code.push((pickup[k+1] as PaiUnit).code[0]);
								
								}else{ ok = false; }
							
							}else { ok = false; }
							
							k++;
						}//end while
						
						if(ok)
						{
							makeup.push(pun);							
						}
												
					}//end if				
				
				}
			
			}//end for
		
			return makeup;
		}
		
		/**
		 * 根据pick后的结果，进行二次处理，
		 * 
		 * 对单牌进行筛选,得到singlelink5,可向2张借1，可向3张借1
		 */
		private static function makeup_singleLink(num:int=5):Array
		{
			var i:int =0;
			var j:int =0;
			var len:int = pickup.length;
			var makeup:Array = new Array();
			var pun:PaiUnit;
			
			//
			var step:int = num-1;
			
			//
			for(i=0;i<len;i++)
			{
				//每个函数，这里不同
				if(PaiRule.SINGLE == (pickup[i] as PaiUnit).Rule)
				{
					pun = new PaiUnit((pickup[i] as PaiUnit).code[0]);
					
					var ok:Boolean = true;
					
					if((i+step) < len)
					{
						//
						var k:int = i;
						
						while(k <(i+step))
						{
							if(PaiRule.SINGLE == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.PAIR == (pickup[k+1] as PaiUnit).Rule ||
							   PaiRule.SANZHANG == (pickup[k+1] as PaiUnit).Rule)
							{								
								if(PaiCode.ai((pickup[k] as PaiUnit).Meta,
								              (pickup[k+1] as PaiUnit).Meta)
								  )
								{
									pun.code.push((pickup[k+1] as PaiUnit).code[0]);
								
								}else{ ok = false; }
							
							}else { ok = false; }
							
							k++;
						}//end while
						
						if(ok)
						{
							makeup.push(pun);							
						}
												
					}//end if				
				
				}
			
			}//end for
		
			return makeup;		
		}
				
		
		
				
		/**
		 * 存储每次对牌数组的分析结果
		 * 
		 * 并可按要求进行组合
		 * 
		 * 过滤
		 * 
		 * 参数 paiCodeCopy = pcc
		 * 
		 * 参数要先经过排序
		 */ 
		public static function pick(pccArr:Array):void
		{
			//loop use
		  	var i:int = 0;
		  	var j:int = 0;	
		  	var len:int = 0;
		  	
		  	len = pickup.length;
		  	for(i=0;i<len;i++)
		  	{
		  		pickup.pop();
		  	}
		  	
		  			  	
		  	//
		  	var single:PaiUnit;
		  	var pair:PaiUnit;
		  	var sanzhang:PaiUnit;
		  	var bomb:PaiUnit;
		  	
		  	//选纯
		  	while(pccArr.length > 0)
		  	{
		  		i = 0;
		  		j = i+1;
		  		len = pccArr.length;		  		
		  		
		  		if(len >= 2 &&
				   (PaiCode.guiWei(pccArr[i]) == PaiCode.guiWei(pccArr[j]))
				  )
		  		{		  				
			  		//
			  		if((len -j - 1) >= 2)
			  		{
			  			//四张
			  			if(PaiCode.guiWei(pccArr[j]) == PaiCode.guiWei(pccArr[j+1]) &&
			  			   PaiCode.guiWei(pccArr[j+1]) == PaiCode.guiWei(pccArr[j+2]))
			  			{
			  					 bomb = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1],pccArr[j+2]);
			  					 pickup.push(bomb);
			  					 pccArr.splice(i,j+2+1);
			  					 continue;
			  			}
			  			
			  			//三张
			  			if(PaiCode.guiWei(pccArr[j]) == PaiCode.guiWei(pccArr[j+1]))
			  			{
			  					 sanzhang = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1]);
			  					 pickup.push(sanzhang);
			  					 pccArr.splice(i,j+1+1);
			  					 continue;
			  			}
			  			
			  			//二张
			  			pair = new PaiUnit(pccArr[i],pccArr[j]);			  					
			  			pickup.push(pair);
			  			pccArr.splice(i,j+1);
			  			continue;
			  			
			  				
			  		}else if((len -j - 1) >= 1)
			  		{
			  			//三张
			  			if(PaiCode.guiWei(pccArr[j]) == PaiCode.guiWei(pccArr[j+1]))
			  			{
			  					 sanzhang = new PaiUnit(pccArr[i],pccArr[j],pccArr[j+1]);
			  					 pickup.push(sanzhang);
			  					 pccArr.splice(i,j+1+1);
			  					 continue;
			  			}
			  			
			  			//二张
			  			pair = new PaiUnit(pccArr[i],pccArr[j]);			  					
			  			pickup.push(pair);
			  			pccArr.splice(i,j+1);
			  			continue;			  			
			  			
			  				
			  		}else
			  		{
			  			//二张
			  			pair = new PaiUnit(pccArr[i],pccArr[j]);			  					
			  			pickup.push(pair);
			  			pccArr.splice(i,j+1);
			  			continue;
			  			
			  		}//end if
			  				  				
		  		}else
		  		{
		  			single = new PaiUnit(pccArr[i]);
		  			pickup.push(single);
		  			pccArr.splice(i,j);
		  			continue;
		  		
		  		}
		  	
		  	}//end while		
		}		
		
		/**
		 * 要先运行pick方法
		 * 列出牌
		 * 
		 * px对方出的牌，lastPx提示上次使用过的牌
		 * 
		 * 通过px获取meta
		 * 返回px
		 */ 
		public static function list(px:Array,lastPx:Array=null):Array
		{
			//
		    //loop use
			var i:int = 0;
			var len:int = 0;
			//
			var lastMeta:int = null == lastPx?-1:PaiCode.guiWei(lastPx[1]); // 5>3?1:2 返回1				
				
			//索引
			var ind:int = -1;	
			
			//得出一张全表
			var table:Array = list_px(px);
			
			//结果
			var mx:Array;
			
			if(table.length > 0)
			{
				if(null != lastPx)
				{				
					//在表中搜索
					//find begin
					len = table.length;
					
					for(i=0;i<len;i++)
					{
						if(lastPx[0] == PaiRule.HUOJIAN)
						{
							ind = 0;
							break;
						}
						
						var meta:int = PaiCode.guiWei((table[i] as PaiUnit).code[0]);
											
						if(meta == lastMeta && (table[i] as PaiUnit).Rule == lastPx[0])
						{
							if(i == (len-1))
							{
								//
								ind = 0;
								break;
							}
							
							ind = i+1;
							break;
						}
					}
					
					if(-1 == ind)
					{
						//没找到说明上次得出的表和这次不一样
						throw new Error("can not find lastMeta from table:" + lastMeta.toString());
					}
					
					//find end
								
				}
				else
				{
					ind = 0;
				}
				
				mx = getMxArr((table[ind] as PaiUnit));
			
			}else
			{
				//pass
				mx = new Array();
				mx.push(PaiRule.PASS);
			}
			
			//封装结果			
			return mx;
		}
		
		/**
		 * 因为必输，所以这是一个特别的实现
		 */ 
		private static function list_pass():Array
		{
			var mxArr:Array = new Array(); 
			
			mxArr.push(PaiRule.PASS);
		
			return mxArr;
		}			
		
		/**
		 * px = 牌形
		 * 
		 * pr = 牌rule
		 * 
		 * pc = 牌code
		 * 
		 * pcMeta = 牌code归位后的元数据
		 * 
		 */ 
		private static function list_px(px:Array):Array
		{	
			//loop use
			var i:int;
			var len:int;
			var pr:String = px[0];
			
			var pcMeta:int;
			if(PaiRule.PASS == px[0])
			{
				//pass 没有px[1]
				pcMeta = -1;
				
			}else
			{
				pcMeta = PaiCode.guiWei(px[1]);
			}
			
			//这里要得出一张表，大于pcMeta的表
			//然后上层函数搜索，如有lastPx，则定位lastPx，然后next，否则为第一个元素
			var table:Array = new Array();			
						
			//pro = prPriority   根据此参数返回的数组是关键
			var pro:Array = getPrPriority(pr);		
								          
			while(pro.length > 0)
			{
				//list_single_priority是处理pickup的,关键
				var list:Array; //= list_single_priority(pcMeta,prPriority[0]);
				
				//-------------------------------------------------------------------
								
				switch(px[0])
			  	{		  			
			  		case PaiRule.PASS: list = list_single_priority(pcMeta,pro[0]);break;
			  		//单牌区
			  		case PaiRule.SINGLE: list = list_single_priority(pcMeta,pro[0]);break;	
			  		case PaiRule.SINGLELINK5:list = list_singlelink5_priority(pcMeta,pro[0]);break;	
			  		case PaiRule.SINGLELINK6:list = list_singlelink6_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SINGLELINK7:list = list_singlelink7_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SINGLELINK8:list = list_singlelink8_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SINGLELINK9:list = list_singlelink9_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SINGLELINK10:list = list_singlelink10_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SINGLELINK11:list = list_singlelink11_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SINGLELINK12:list = list_singlelink12_priority(pcMeta,pro[0]);break;
			  		//对子区
			  		case PaiRule.PAIR: list = list_pair_priority(pcMeta,pro[0]);break;
			  		case PaiRule.PAIRLINK3:list = list_pairlink3_priority(pcMeta,pro[0]);break;
			  		case PaiRule.PAIRLINK4:list = list_pairlink4_priority(pcMeta,pro[0]);break;					
			  		case PaiRule.PAIRLINK5:list = list_pairlink5_priority(pcMeta,pro[0]);break;					
			  		case PaiRule.PAIRLINK6:list = list_pairlink6_priority(pcMeta,pro[0]);break;					
			  		case PaiRule.PAIRLINK7:list = list_pairlink7_priority(pcMeta,pro[0]);break;					
			  		case PaiRule.PAIRLINK8:list = list_pairlink8_priority(pcMeta,pro[0]);break;					
			  		case PaiRule.PAIRLINK9:list = list_pairlink9_priority(pcMeta,pro[0]);break;					
			  		case PaiRule.PAIRLINK10:list = list_pairlink10_priority(pcMeta,pro[0]);break;					
			  		//三张区
			  		case PaiRule.SANZHANG:list = list_sanzhang_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SANZHANG_SINGLE:list = list_sanzhang_single_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SANZHANG_PAIR:list = list_sanzhang_pair_priority(pcMeta,pro[0]);break;
			  		
			  		case PaiRule.SANSHUN2:
						list = list_sanshun2_priority(pcMeta,pro[0]);
						break;
			  		case PaiRule.SANSHUN3:list = list_sanshun3_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SANSHUN4:list = list_sanshun4_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SANSHUN5:list = list_sanshun5_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SANSHUN6:list = list_sanshun6_priority(pcMeta,pro[0]);break;
			  		//飞机区		
			  		case PaiRule.AIRPLANE_SINGLE2:list = list_airplane_single2_priority(pcMeta,pro[0]);break;
			  		case PaiRule.AIRPLANE_SINGLE3:list = list_airplane_single3_priority(pcMeta,pro[0]);break;
			  		case PaiRule.AIRPLANE_SINGLE4:list = list_airplane_single4_priority(pcMeta,pro[0]);break;
			  		case PaiRule.AIRPLANE_SINGLE5:list = list_airplane_single5_priority(pcMeta,pro[0]);break;		
			  		
			  		case PaiRule.AIRPLANE_PAIR2:
						list = list_airplane_pair2_priority(pcMeta,pro[0]);
						break;
			  		case PaiRule.AIRPLANE_PAIR3:list = list_airplane_pair3_priority(pcMeta,pro[0]);break;
			  		case PaiRule.AIRPLANE_PAIR4:list = list_airplane_pair4_priority(pcMeta,pro[0]);break;
			  		
			  		//四张区
			  		case PaiRule.BOMB:list = list_bomb_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SIZHANG_SINGLE2:list = list_sizhang_single2_priority(pcMeta,pro[0]);break;
			  		case PaiRule.SIZHANG_PAIR2:list = list_sizhang_pair2_priority(pcMeta,pro[0]);break;
			  		
			  		//火箭区
			  		//没有比火箭大的哦
			  		case PaiRule.HUOJIAN:list = list_pass_priority(pcMeta,pro[0]);break;
			  																					
			  		default:throw new Error("can not find pai rule:" + px[0]);
			  	}//end switch 
				
				//-------------------------------------------------------------------
			
				len = list.length;
					
				for(i =0;i<len;i++)
				{
					table.push(list[i] as PaiUnit);	
				}
									
				pro.splice(0,1);
				
			}//end while	
			
			//
			list_makeAndMax_priority(table);	
			
			return table;	
		}
		
		private static function list_sizhang_pair2_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//
			var makeup:Array;
			
			if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();												
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_pairX(2);
						
			//
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			//四张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				
			}//end for
			
			//带二对
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.BOMB == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[3])
					   )
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[3]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
			//对于组合的，要把组合不成功的删掉
			
			//只有四张，因此组合不成功的不删
			/*
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SIZHANG_PAIR2 != (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}
			*/			
		
			return list;
					
		}		
		
		private static function list_sizhang_single2_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//
			var makeup:Array;
			
			if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
												
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_singleX(2);
						
			//
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			//四张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				
			}//end for
			
			//带二
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.BOMB == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
			//对于组合的，要把组合不成功的删掉
			
			//只有四张，因此组合不成功的不删
			/*
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SIZHANG_SINGLE2 != (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}
			*/		
		
			return list;
					
		}
		
		private static function list_bomb_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				if((pickup[i] as PaiUnit).Rule == pr)
				{
					if(PaiRule.BOMB == pr)
					{
						var meta:int = (pickup[i] as PaiUnit).Meta;
					
						//拆对子，三张，不拆炸弹
						if(meta > pcMeta)
						{
							ptun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1],
								(pickup[i] as PaiUnit).code[2],
								(pickup[i] as PaiUnit).code[3]);
								
							list.push(ptun);									
						}							
					}
															
				}//end if
				
			}//end for
			
			return list;
		
		}
		
		private static function list_sanshun6_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN6 == pr)
			{
				makeup = pickup_sanshun(6);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13],
							(makeup[i] as PaiUnit).code[14],
							(makeup[i] as PaiUnit).code[15],
							(makeup[i] as PaiUnit).code[16],
							(makeup[i] as PaiUnit).code[17]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_sanshun5_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN5 == pr)
			{
				makeup = pickup_sanshun(5);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13],
							(makeup[i] as PaiUnit).code[14]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_sanshun4_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN4 == pr)
			{
				makeup = pickup_sanshun(4);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_sanshun3_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN3 == pr)
			{
				makeup = pickup_sanshun(3);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_airplane_pair4_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			var len:int;
			var len2:int;
			var ptun:PaiUnit;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN4 == pr)
			{
				makeup = list_sanshun4_priority(pcMeta,pr);
								
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_pairX(4);
						
			//
			len = makeup.length;
			len2 = makeup2.length;
			var list:Array = new Array();			
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带三对
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN4 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[3]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[4]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[5]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[6]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[7]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(list[i] as PaiUnit).code[6],
							(list[i] as PaiUnit).code[7],
							(list[i] as PaiUnit).code[8],
							(list[i] as PaiUnit).code[9],
							(list[i] as PaiUnit).code[10],
							(list[i] as PaiUnit).code[11],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[3],
							(makeup2[j] as PaiUnit).code[4],
							(makeup2[j] as PaiUnit).code[5],
							(makeup2[j] as PaiUnit).code[6],
							(makeup2[j] as PaiUnit).code[7]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN4 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}			
		
			return list;
			
		
		}
		
		private static function list_airplane_pair3_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			var len:int;
			var len2:int;
			var ptun:PaiUnit;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN3 == pr)
			{
				makeup = list_sanshun3_priority(pcMeta,pr);
								
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_pairX(3);
						
			//
			len = makeup.length;
			len2 = makeup2.length;
			var list:Array = new Array();			
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带三对
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN3 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[3]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[4]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[5]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(list[i] as PaiUnit).code[6],
							(list[i] as PaiUnit).code[7],
							(list[i] as PaiUnit).code[8],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[3],
							(makeup2[j] as PaiUnit).code[4],
							(makeup2[j] as PaiUnit).code[5]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN3 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}			
		
			return list;
		
		}
		
		private static function list_airplane_pair2_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			var len:int;
			var len2:int;
			var ptun:PaiUnit;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN2 == pr)
			{
				makeup = list_sanshun2_priority(pcMeta,pr);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_pairX(2);
						
			//
			len = makeup.length;
			len2 = makeup2.length;
			var list:Array = new Array();			
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带二对
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN2 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[3]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[3]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN2 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}			
		
			return list;
		
		
		}
		
		private static function list_airplane_single5_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN5 == pr)
			{
				makeup = list_sanshun5_priority(pcMeta,pr);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_singleX(5);
						
			//
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13],
							(makeup[i] as PaiUnit).code[14]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带4
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN5 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[3]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[4])
					   )
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(list[i] as PaiUnit).code[6],
							(list[i] as PaiUnit).code[7],
							(list[i] as PaiUnit).code[8],
							(list[i] as PaiUnit).code[9],
							(list[i] as PaiUnit).code[10],
							(list[i] as PaiUnit).code[11],
							(list[i] as PaiUnit).code[12],
							(list[i] as PaiUnit).code[13],
							(list[i] as PaiUnit).code[14],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[3],
							(makeup2[j] as PaiUnit).code[4]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}		
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN5 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}		
		
			return list;
		
		
		}
		
		private static function list_airplane_single4_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN4 == pr)
			{
				makeup = list_sanshun4_priority(pcMeta,pr);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_singleX(4);
						
			//
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带4
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN4 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[3])
					   )
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(list[i] as PaiUnit).code[6],
							(list[i] as PaiUnit).code[7],
							(list[i] as PaiUnit).code[8],
							(list[i] as PaiUnit).code[9],
							(list[i] as PaiUnit).code[10],
							(list[i] as PaiUnit).code[11],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[3]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}		
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN4 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}		
		
			return list;
		
		
		}
		
		private static function list_airplane_single3_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN3 == pr)
			{
				makeup = list_sanshun3_priority(pcMeta,pr);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_singleX(3);
						
			//
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带3
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN3 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[2]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(list[i] as PaiUnit).code[6],
							(list[i] as PaiUnit).code[7],
							(list[i] as PaiUnit).code[8],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1],
							(makeup2[j] as PaiUnit).code[2]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}			
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN3 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}	
		
			return list;
		
		
		}
		
		private static function list_airplane_single2_priority(pcMeta:int,pr:String):Array
		{
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN2 == pr)
			{
				makeup = list_sanshun2_priority(pcMeta,pr);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
								
			}
			
			//附带的，不用判断大小	
			var makeup2:Array = makeup_singleX(2);
						
			//
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_airplane_single2_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5]);
								
						list.push(ptun);		
				}
				
			}//end for
			
			//带二
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANSHUN2 == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(list[i] as PaiUnit).code[3],
							(list[i] as PaiUnit).code[4],
							(list[i] as PaiUnit).code[5],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
			//对于组合的，要把组合不成功的删掉
			for(i=0;i<list.length;i++)
			{
				if(PaiRule.SANSHUN2 == (list[i] as PaiUnit).Rule)
				{
					list.splice(i,1);
					i=0;
				}
			}			
		
			return list;
		
		
		}
		
		private static function list_sanshun2_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SANSHUN2 == pr)
			{
				makeup = pickup_sanshun(2);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
				
		private static function list_sanzhang_pair_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			var j:int = 0;
			
			var makeup:Array = list_sanzhang_priority(pcMeta,pr);	
			//附带的，不用判断大小	
			var makeup2:Array = makeup_pair();
			
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			
			var list:Array = new Array();
			var ptun:PaiUnit;
						
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_sanzhang_pair_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2]);
								
					list.push(ptun);		
				}
				
			}//end for
			
			//带一
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANZHANG == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]) &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[1]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[0],
							(makeup2[j] as PaiUnit).code[1]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}			
		
			return list;		
		}
		
		private static function list_sanzhang_single_priority(pcMeta:int,pr:String):Array
		{			
			var i:int = 0;
			var j:int = 0;
			
			var makeup:Array = list_sanzhang_priority(pcMeta,pr);	
			//附带的，不用判断大小	
			var makeup2:Array = makeup_single();
			
			var len:int = makeup.length;
			var len2:int = makeup2.length;
			
			var list:Array = new Array();
			var ptun:PaiUnit;
						
			//三张
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					//上面已较过meta，list_sanzhang_single_priority是复合方法
					ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2]);
								
					list.push(ptun);
				}
				
			}//end for
			
			//带一
			len = list.length;
			
			for(i=0;i<len;i++)
			{
				for(j=0;j<len2;j++)
				{
					if(PaiRule.SANZHANG == (list[i] as PaiUnit).Rule &&
					   false == (list[i] as PaiUnit).hasCode((makeup2[j] as PaiUnit).code[0]))
					{
						list[i] = new PaiUnit(
							(list[i] as PaiUnit).code[0],
							(list[i] as PaiUnit).code[1],
							(list[i] as PaiUnit).code[2],
							(makeup2[j] as PaiUnit).code[0]);
						
						//没必要加那么多组合，加个最小的就行
						break;
					} 
				
				}
			}
			
		
			return list;
		}
		
		private static function list_pass_priority(pcMeta:int,pr:String):Array
		{
			var list:Array = new Array();
			
			return list;
		}		
		
		private static function list_sanzhang_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				if((pickup[i] as PaiUnit).Rule == pr)
				{
					if(PaiRule.BOMB == pr)
					{
						ptun = new PaiUnit(
							(pickup[i] as PaiUnit).code[0],
							(pickup[i] as PaiUnit).code[1],
							(pickup[i] as PaiUnit).code[2],
							(pickup[i] as PaiUnit).code[3]);
							
						list.push(ptun);
					
					}
					else if(PaiRule.SANZHANG == pr)
					{
						var meta:int = (pickup[i] as PaiUnit).Meta;
					
						//拆对子，三张，不拆炸弹
						if(meta > pcMeta)
						{
							ptun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1],
								(pickup[i] as PaiUnit).code[2]);
								
							list.push(ptun);									
						}							
					}
															
				}//end if
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink10_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK10 == pr)
			{
				makeup = makeup_pairLink_pair(10);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13],
							(makeup[i] as PaiUnit).code[14],
							(makeup[i] as PaiUnit).code[15],
							(makeup[i] as PaiUnit).code[16],
							(makeup[i] as PaiUnit).code[17],
							(makeup[i] as PaiUnit).code[18],
							(makeup[i] as PaiUnit).code[19]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink9_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK9 == pr)
			{
				makeup = makeup_pairLink_pair(9);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13],
							(makeup[i] as PaiUnit).code[14],
							(makeup[i] as PaiUnit).code[15],
							(makeup[i] as PaiUnit).code[16],
							(makeup[i] as PaiUnit).code[17]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink8_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK8 == pr)
			{
				makeup = makeup_pairLink_pair(8);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13],
							(makeup[i] as PaiUnit).code[14],
							(makeup[i] as PaiUnit).code[15]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink7_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK7 == pr)
			{
				makeup = makeup_pairLink_pair(7);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11],
							(makeup[i] as PaiUnit).code[12],
							(makeup[i] as PaiUnit).code[13]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink6_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK6 == pr)
			{
				makeup = makeup_pairLink_pair(6);
				
			}else if(PaiRule.SANSHUN6 == pr)
			{
				makeup = makeup_pairLink_sanzhang(6);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink5_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK5 == pr)
			{
				makeup = makeup_pairLink_pair(5);
				
			}else if(PaiRule.SANSHUN5 == pr)
			{
				makeup = makeup_pairLink_sanzhang(5);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink4_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK4 == pr)
			{
				makeup = makeup_pairLink_pair(4);
				
			}else if(PaiRule.SANSHUN4 == pr)
			{
				makeup = makeup_pairLink_sanzhang(4);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pairlink3_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.PAIRLINK3 == pr)
			{
				makeup = makeup_pairLink_pair(3);
				
			}else if(PaiRule.SANSHUN3 == pr)
			{
				makeup = makeup_pairLink_sanzhang(3);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;		
		}
		
		private static function list_pair_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				if((pickup[i] as PaiUnit).Rule == pr)
				{
					if(PaiRule.BOMB == pr)
					{
						ptun = new PaiUnit(
							(pickup[i] as PaiUnit).code[0],
							(pickup[i] as PaiUnit).code[1],
							(pickup[i] as PaiUnit).code[2],
							(pickup[i] as PaiUnit).code[3]);
							
						list.push(ptun);
					
					}
					else
					{
						var meta:int = (pickup[i] as PaiUnit).Meta;
					
						//拆对子，三张，不拆炸弹
						if(meta > pcMeta)
						{
							ptun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1]);
								
							list.push(ptun);									
						}							
					}
															
				}//end if
				
			}//end for
			
			return list;
		
		}
		
		private static function list_singlelink12_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK12 == pr)
			{
				makeup = makeup_singleLink(12);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10],
							(makeup[i] as PaiUnit).code[11]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		}
		
		private static function list_singlelink11_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK11 == pr)
			{
				makeup = makeup_singleLink(11);
				
			}else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9],
							(makeup[i] as PaiUnit).code[10]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
			
		}
		
		private static function list_singlelink10_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK10 == pr)
			{
				makeup = makeup_singleLink(10);
				
			}else if(PaiRule.PAIRLINK10 == pr)
			{
				makeup = makeup_singleLink_pair(10);
				
			}
			else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8],
							(makeup[i] as PaiUnit).code[9]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		}
		
		private static function list_singlelink9_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK9 == pr)
			{
				makeup = makeup_singleLink(9);
				
			}else if(PaiRule.PAIRLINK9 == pr)
			{
				makeup = makeup_singleLink_pair(9);
				
			}
			else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7],
							(makeup[i] as PaiUnit).code[8]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		}
		
		private static function list_singlelink8_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK8 == pr)
			{
				makeup = makeup_singleLink(8);
				
			}else if(PaiRule.PAIRLINK8 == pr)
			{
				makeup = makeup_singleLink_pair(8);
				
			}
			else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6],
							(makeup[i] as PaiUnit).code[7]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		}
		
		private static function list_singlelink7_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK7 == pr)
			{
				makeup = makeup_singleLink(7);
				
			}else if(PaiRule.PAIRLINK7 == pr)
			{
				makeup = makeup_singleLink_pair(7);
				
			}
			else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5],
							(makeup[i] as PaiUnit).code[6]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		
		}
		
		
		private static function list_singlelink6_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK6 == pr)
			{
				makeup = makeup_singleLink(6);
				
			}else if(PaiRule.PAIRLINK6 == pr)
			{
				makeup = makeup_singleLink_pair(6);
				
			}else if(PaiRule.SANSHUN6 == pr)
			{
				makeup = makeup_singleLink_sanzhang(6);
			}
			else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4],
							(makeup[i] as PaiUnit).code[5]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		
		}
		
		/**
		 * PaiRule.SINGLELINK5,
		 * PaiRule.PAIRLINK5,PaiRule.SANSHUN5,PaiRule.BOMB
		 */ 
		private static function list_singlelink5_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			//
			var makeup:Array;
			
			if(PaiRule.SINGLELINK5 == pr)
			{
				makeup = makeup_singleLink(5);
				
			}else if(PaiRule.PAIRLINK5 == pr)
			{
				makeup = makeup_singleLink_pair(5);
				
			}else if(PaiRule.SANSHUN5 == pr)
			{
				makeup = makeup_singleLink_sanzhang(5);
			}
			else if(PaiRule.BOMB == pr)
			{
				makeup = pickup_bomb();
				
			}else
			{
				throw new Error("can not find pr:" + pr);
			}
			
			var len:int = makeup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{								
				if(PaiRule.BOMB == (makeup[i] as PaiUnit).Rule)
				{
					ptun = new PaiUnit(
						(makeup[i] as PaiUnit).code[0],
						(makeup[i] as PaiUnit).code[1],
						(makeup[i] as PaiUnit).code[2],
						(makeup[i] as PaiUnit).code[3]);
							
					list.push(ptun);
					
				}
				else
				{
					var meta:int = (makeup[i] as PaiUnit).Meta;
					
					//拆对子，三张，不拆炸弹
					if(meta > pcMeta)
					{
						ptun = new PaiUnit(
							(makeup[i] as PaiUnit).code[0],
							(makeup[i] as PaiUnit).code[1],
							(makeup[i] as PaiUnit).code[2],
							(makeup[i] as PaiUnit).code[3],
							(makeup[i] as PaiUnit).code[4]);
								
						list.push(ptun);									
					}							
				}
				
			}//end for
			
			return list;
		
		}
				
		private static function list_single_priority(pcMeta:int,pr:String):Array
		{
			var i:int = 0;
			var len:int = pickup.length;
			var list:Array = new Array();
			var ptun:PaiUnit;
			
			for(i=0;i<len;i++)
			{
				if((pickup[i] as PaiUnit).Rule == pr)
				{
					if(PaiRule.BOMB == pr)
					{
						ptun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0],
								(pickup[i] as PaiUnit).code[1],
								(pickup[i] as PaiUnit).code[2],
								(pickup[i] as PaiUnit).code[3]);
								
					 	list.push(ptun);							
					}
					else
					{
						//拆对牌，三张
						var meta:int = (pickup[i] as PaiUnit).Meta;
						
						if(meta > pcMeta)
						{
							ptun = new PaiUnit(
								(pickup[i] as PaiUnit).code[0]);
								
							list.push(ptun);
						}				
					}					
				}//end if		
				
			}//end for
			
			return list;	
		
		}
		
		/**
		 * 查询是否有火箭
		 * 
		 * 这是一个特殊实现,主要是它是组合出来的，且是最大的牌,加在table的最后
		 */ 
		private static function list_makeAndMax_priority(table:Array):Boolean
		{
			//loop use
			var i:int = 0;
			var len:int = pickup.length;		
			//
			var trigNum:int = 2;
			var has:int = 0;
			
			for(i=0;i<len;i++)
			{
				if((pickup[i] as PaiUnit).Rule == PaiRule.SINGLE)
				{
					if(PaiCode.JOKER_XIAO == (pickup[i] as PaiUnit).code[0] ||
					   PaiCode.JOKER_DA   == (pickup[i] as PaiUnit).code[0])
					{
						has++;					
					}
					
					if(trigNum == has)
					{
						table.push(
						new PaiUnit(PaiCode.JOKER_XIAO,PaiCode.JOKER_DA)
						);	
						return true;
						//break;
					}
					
				}//end if
				
			}//end for			
			
			return false;
		}
		
		/**
		 * 封装结果
		 */ 
		private static function getMxArr(putn:PaiUnit):Array
		{
			//loop use
			var i:int = 0;
			var len:int = putn.code.length;
			
			//结果
			var mx:Array = new Array();
			mx.push(putn.Rule);
			
			for(i=0;i<len;i++)
			{
				mx.push(putn.code[i]);			
			}
			
			return mx;
		}
				
		private static function getPrPriority(pr:String):Array
		{			
			var po:Array;
			
			switch(pr)
			{
				case PaiRule.PASS:po=new Array(PaiRule.SINGLE,PaiRule.PAIR,PaiRule.SANZHANG,PaiRule.BOMB);break;
				//
				case PaiRule.SINGLE:po = new Array(PaiRule.SINGLE,PaiRule.PAIR,PaiRule.SANZHANG,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK5:po = new Array(PaiRule.SINGLELINK5,PaiRule.PAIRLINK5,PaiRule.SANSHUN5,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK6:po = new Array(PaiRule.SINGLELINK6,PaiRule.PAIRLINK6,PaiRule.SANSHUN6,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK7:po = new Array(PaiRule.SINGLELINK7,PaiRule.PAIRLINK7,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK8:po = new Array(PaiRule.SINGLELINK8,PaiRule.PAIRLINK8,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK9:po = new Array(PaiRule.SINGLELINK9,PaiRule.PAIRLINK9,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK10:po = new Array(PaiRule.SINGLELINK10,PaiRule.PAIRLINK10,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK11:po = new Array(PaiRule.SINGLELINK11,PaiRule.BOMB);break;
				case PaiRule.SINGLELINK12:po = new Array(PaiRule.SINGLELINK12,PaiRule.BOMB);break;
				//
				case PaiRule.PAIR:po = new Array(PaiRule.PAIR,PaiRule.SANZHANG,PaiRule.BOMB);break;//不会从四张里面抽二张，没有意义
				case PaiRule.PAIRLINK3:po= new Array(PaiRule.PAIRLINK3,PaiRule.SANSHUN3,PaiRule.BOMB);break;
				case PaiRule.PAIRLINK4:po= new Array(PaiRule.PAIRLINK4,PaiRule.SANSHUN4,PaiRule.BOMB);break;				
				case PaiRule.PAIRLINK5:po= new Array(PaiRule.PAIRLINK5,PaiRule.SANSHUN5,PaiRule.BOMB);break;										      
				case PaiRule.PAIRLINK6:po= new Array(PaiRule.PAIRLINK6,PaiRule.SANSHUN6,PaiRule.BOMB);break;
				case PaiRule.PAIRLINK7:po= new Array(PaiRule.PAIRLINK7,PaiRule.BOMB);break; 
				case PaiRule.PAIRLINK8:po= new Array(PaiRule.PAIRLINK8,PaiRule.BOMB);break; 
				case PaiRule.PAIRLINK9:po= new Array(PaiRule.PAIRLINK9,PaiRule.BOMB);break;  
				case PaiRule.PAIRLINK10:po= new Array(PaiRule.PAIRLINK10,PaiRule.BOMB);break; 
				//
				case PaiRule.SANZHANG:po = new Array(PaiRule.SANZHANG,PaiRule.BOMB);break;
				case PaiRule.SANZHANG_SINGLE:po = new Array(PaiRule.SANZHANG,PaiRule.BOMB);break;
				case PaiRule.SANZHANG_PAIR:po = new Array(PaiRule.SANZHANG,PaiRule.BOMB);break;
				//
				case PaiRule.SANSHUN2:po = new Array(PaiRule.SANSHUN2,PaiRule.BOMB);break;
				case PaiRule.SANSHUN3:po = new Array(PaiRule.SANSHUN3,PaiRule.BOMB);break;
				case PaiRule.SANSHUN4:po = new Array(PaiRule.SANSHUN4,PaiRule.BOMB);break;
				case PaiRule.SANSHUN5:po = new Array(PaiRule.SANSHUN5,PaiRule.BOMB);break;
				case PaiRule.SANSHUN6:po = new Array(PaiRule.SANSHUN6,PaiRule.BOMB);break;
				//
				case PaiRule.AIRPLANE_SINGLE2:po = new Array(PaiRule.SANSHUN2,PaiRule.BOMB);break;
				case PaiRule.AIRPLANE_SINGLE3:po = new Array(PaiRule.SANSHUN3,PaiRule.BOMB);break;
				case PaiRule.AIRPLANE_SINGLE4:po = new Array(PaiRule.SANSHUN4,PaiRule.BOMB);break;
				case PaiRule.AIRPLANE_SINGLE5:po = new Array(PaiRule.SANSHUN5,PaiRule.BOMB);break;
				//
				case PaiRule.AIRPLANE_PAIR2:po = new Array(PaiRule.SANSHUN2,PaiRule.BOMB);break;
				case PaiRule.AIRPLANE_PAIR3:po = new Array(PaiRule.SANSHUN3,PaiRule.BOMB);break;
				case PaiRule.AIRPLANE_PAIR4:po = new Array(PaiRule.SANSHUN4,PaiRule.BOMB);break;				
				//
				case PaiRule.BOMB:po = new Array(PaiRule.BOMB);break;
				case PaiRule.SIZHANG_SINGLE2:po = new Array(PaiRule.BOMB);break;
				case PaiRule.SIZHANG_PAIR2:po = new Array(PaiRule.BOMB);break;
				
				//没有比火箭大的哦
				case PaiRule.HUOJIAN:po = new Array();break;
			
			}
					
			if(null == po)	
			{
				throw new Error("can not find pcRule:" + pr);
			}
			
			return po;	
		}
		
		

	}
}