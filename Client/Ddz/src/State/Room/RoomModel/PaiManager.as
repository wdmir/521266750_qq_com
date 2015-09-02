package State.Room.RoomModel
{
	import flash.display.MovieClip;
	
	import net.wdmir.core.PokerName;
	import net.wdmir.core.logic.ddz.PaiCode;
	import net.wdmir.core.logic.ddz.PaiRule;
	import net.wdmir.core.logic.ddz.PaiRuleCompare;
	import net.wdqipai.client.extmodel.ItemModelByDdz;
	import net.wdqipai.client.extmodel.RoundModelByDdz;
	import net.wdqipai.client.extmodel.RoundTypeByDdz;

	
	public class PaiManager
	{
		
		/**
		 * 54张牌的实例
		 */ 
		private var _paiList:Array;		
		
		/**
		 * 54张底牌的实例
		 * 三张底牌
		 */ 
		private var _dipaiList:Array;
		
		private var _sortOrder:Boolean = true;//true;
		
		/**
		 * 走棋记录
		 */ 
		private var _record:RoundModelByDdz;
		
		/**
		 * 走棋记录集合
		 */ 
		private var _round:Vector.<RoundModelByDdz>;		
		
		
		/**
		 * paiList来自 RoomViewBg.mxml页面的变量
		 */		
		public function PaiManager(paiList:Array,dipaiList:Array)
		{
			this._paiList = paiList;
			
			this._dipaiList = dipaiList;
			
			this._record = new RoundModelByDdz(RoundTypeByDdz.JIAO_FEN);
			
			this._round = new Vector.<RoundModelByDdz>();//new Array();
			
		}
		
		/**
		 * 排序方向
		 * 
		 * true = 从大到小
		 * 
		 * false = 从小到大
		 * 
		 */
		public function setSortOrder():void
		{
			
			_sortOrder = _sortOrder == true?false:true;
			
			
		}
		
		
		public function get Record():RoundModelByDdz
		{
			return this._record;
		}

		public function getRecord():RoundModelByDdz
		{
			return this._record;
		}
		
		public function get Round():Vector.<RoundModelByDdz>
		{
			return this._round;		
		}
		
		public function getRound():Vector.<RoundModelByDdz>
		{
			return this._round;		
		}
		
		/**
        * 获取上家出的牌，如上家pass则略过，并向上获取，
        * 如pass,步进为二步
        * 上家指的是上二家中出的最大的牌
        */ 
        public function getSjPai():Array
        {         
        	//loop use
        	var i:int = 0;
        	var record:RoundModelByDdz;    
        	
        	//
        	var sjPai:Array = new Array();    	
        	
        	if(this._record.isEmpty())
        	{
        		//this._round.length 必定是大于 0的
        		record = this._round[_round.length-1];
        		
	        	if(RoundTypeByDdz.CHU_PAI == record.type)
	        	{   
	        		sjPai.push(record.clock_three_chupai);	        		
	        		sjPai.push(record.clock_two_chupai);
	        	}
	        	    
        	}
        	else
        	{
        		if(RoundTypeByDdz.CHU_PAI == this._record.type)
	        	{    
	        		if("" != this._record.clock_three)	        		 
	        		{
	        			sjPai.push(this._record.clock_three_chupai);
	        		}
	        		
	        		if("" != this._record.clock_two)	        		 
	        		{
	        			sjPai.push(this._record.clock_two_chupai);
	        		}
	        		
	        		if("" != this._record.clock_one)	        		 
	        		{
	        			sjPai.push(this._record.clock_one_chupai);
	        		}
	        		
	        		while(sjPai.length > 2)
	        		{
	        			sjPai.splice(sjPai.length-1,1);	        		
	        		}
	        		
	        		if(sjPai.length < 2)
	        		{
	        			record = this._round[_round.length-1];
	        			
	        			if(RoundTypeByDdz.CHU_PAI == record.type)
	        			{   
	        				sjPai.push(record.clock_three_chupai);			        		
			        		sjPai.push(record.clock_two_chupai);			        		
	        			}
	        		}
	        		
	        		while(sjPai.length > 2)
	        		{
	        			sjPai.splice(sjPai.length-1,1);	        		
	        		}
	        		        			
	        	}  
        	
        	}    
        	
        	//从2个里面选出一个出牌
        	//先删掉pass
        	if(2 == sjPai.length)
	        {
	        	for(i= 0;i<sjPai.length;i++)
	        	{
	        		if("" == String(sjPai[i]))
		        	{
		        		sjPai.splice(i,1);
		        		
		        		i=-1;
		        	} 	
	        	
	        	}	        	        		
	        }   
	        
	        //如果都有出牌，则去掉一个
	        if(2 == sjPai.length)
	        {
	        	sjPai.splice(1,1);
	        	
	        	return toArray(sjPai[0]);//String(sjPai[0]).split(',');
	        }
	        
	        if(0 == sjPai.length)
	        {
	        	return sjPai;
	        }
        		
        	return toArray(sjPai[0]);//String(sjPai[0]).split(',');
        	
		}
		
		/**
		 * 拷贝从RoundModelByDdz
		 */ 
		public function toArray(value:String):Array
		{
			var arr:Array = value.split(',')
			
			for(var i:int=0;i<arr.length;i++)
			{
				if("" == arr[i])
				{
					arr.splice(i,1);
					i=0;
					continue;
				}
				
			}
			
			
			return arr;
		}
		
		/**
		 * 满了就保存
		 */ 
		public function getRecordIsFullAndSave(roundType:String):void
		{
			if (this._record.isFull())
			{
			    this._round.push(this._record);
			    this._record = new RoundModelByDdz(roundType);
			}	
		
		}
		
		/**
		 * 游戏到出牌状态后，保存叫分record，并更改record type
		 */ 
		public function saveRecordAndChangeTypeToChuPai():void
		{
			if (!this._record.isEmpty())
			{
			    this._round.push(this._record);			    
			}		
			
			this._record = new RoundModelByDdz(RoundTypeByDdz.CHU_PAI);	
		}		
		
		public function getRecordIsFull(type:String):Boolean
		{
			if(this._record.isEmpty() && this._record.type == type)
			{
				return true;
			}	
			
			if (this._record.isFull() && this._record.type == type)
			{
			    return true;
			}	
			
			return false;
		}
				
		/**
		 * 是否满了一圈，且有人叫分
		 * 
		 * 先查询record是否为empty
		 * 为empty时才使用此方法
		 */ 
	   public function getRoundLastGroupIsHasFen():Boolean
	   {
	   		var hasFen:int = PaiRule.JIAO_FEN_MINVALUE + 1;
	   	
	   		if(0 == this._round.length)
	   		{
	   			if("" != this._record.clock_one &&
	   			   "" != this._record.clock_two &&
	   			   "" != this._record.clock_three)
	   			{
	   				if(hasFen <= this._record.clock_one_jiaofen ||
	   				   hasFen <= this._record.clock_two_jiaofen ||
	   				   hasFen <= this._record.clock_three_jiaofen)
	   				   {	   				   
	   				   		return true;	   				   
	   				   }
	   			}
	   		}
	   		
	   		if(0 < this._round.length)
	   		{
	   			if("" != (this._round[this._round.length-1]).clock_one &&
	   			   "" != (this._round[this._round.length-1]).clock_two &&
	   			   "" != (this._round[this._round.length-1]).clock_three)
	   			   {
	   			   		if(hasFen <= (this._round[this._round.length-1]).clock_one_jiaofen ||
		   				   hasFen <= (this._round[this._round.length-1]).clock_two_jiaofen ||
		   				   hasFen <= (this._round[this._round.length-1]).clock_three_jiaofen)
		   				   {	   				   
		   				   		return true;	   				   
		   				   }
	   			   
	   			   }
	   		}
	   		
	   		return false;	   
	   }
		
		public function reset():void
		{
			//clear以便内存回收
			var len:int = this._round.length;
			
			for(var i:int =0;i<len;i++)
			{
				this._round.pop();
			}
			
			//
			this._record = new RoundModelByDdz(RoundTypeByDdz.JIAO_FEN);			
			this._round = new Vector.<RoundModelByDdz>();//new Array();
		}
		
		public function rebuild(value:XMLList,valueMeta:XMLList):void
		{
			reset();
			//trace(value);
			
			//
			var A:String = "";
			var B:String = "";
			var C:String = "";
			
			//只有一行
			for each(var vm:XML in valueMeta)
			{
				if(valueMeta.@A != undefined){
				A = valueMeta.@A;
				}
				
				if(valueMeta.@B != undefined){
				B = valueMeta.@B;
				}
				
				if(valueMeta.@C != undefined){
				C = valueMeta.@C;
				}
			}
			
			//
			for each (var v:XML in value)
			{
				//
				var ro:RoundModelByDdz = new RoundModelByDdz(v.@type);
				
				//
				ro.clock_one = v.@ck_1;
				
				ro.clock_one_jiaofen = v.@ck_1_jf;
				ro.clock_one_chupai = v.@ck_1_cp;
				
				//
				ro.clock_two = v.@ck_2;
				ro.clock_two_jiaofen = v.@ck_2_jf;
				ro.clock_two_chupai = v.@ck_2_cp;
				
				//
				ro.clock_three = v.@ck_3;
				ro.clock_three_jiaofen = v.@ck_3_jf;
				ro.clock_three_chupai = v.@ck_3_cp;
				
				//meta replace
				if(ro.clock_one == "A"){
					ro.clock_one = A;
					
				}else if(ro.clock_one == "B"){
					ro.clock_one = B;
					
				}else if(ro.clock_one == "C"){
					ro.clock_one = C;
				}
				
				//
				if(ro.clock_two == "A"){
					ro.clock_two = A;
					
				}else if(ro.clock_two == "B"){
					ro.clock_two = B;
					
				}else if(ro.clock_two == "C"){
					ro.clock_two = C;
				}
				
				
				//
				if(ro.clock_three == "A"){
					ro.clock_three = A;
					
				}else if(ro.clock_three == "B"){
					ro.clock_three = B;
					
				}else if(ro.clock_three == "C"){
					ro.clock_three = C;
				}
				
				
				//
				this._round.push(ro);
			}
			
			//
			this._record = this._round.pop();
		}
		 
		/**
		 * 交换时，交换名称，其它不变
		 * 
		 * //a=a+b; 
		   //b=a-b;  
		   //a=a-b
		 * 
		 */ 
		public function sort(arr:Array,cId:int):void
		{
			//
			var find_h:int = cId - 1;
			
			//
			var len:int = arr.length;
			var tmpName:String;
			//var tmpV:int;
			
			for(var i:int =0;i<len;i++)
			{
				var m1:ItemModelByDdz = arr[i] as ItemModelByDdz;
				
				for(var j:int=i + 1;j<len;j++)
				{	
					var m2:ItemModelByDdz = arr[j] as ItemModelByDdz;
					
					if(m1.h == find_h &&
					   m2.h == find_h)
					   {					
							if(getPaiCodeByName(m1.name) < getPaiCodeByName(m2.name))
							{
								if(this._sortOrder)//从大到小
								{
									tmpName = m1.name;
									//tmpV  = m1.v;
									
									m1.name = m2.name;
									//m1.v = m2.v;
									
									m2.name = tmpName;
									//m2.v = tmpV;
									
									//arrTmp[i] = arrTmp[i] + arrTmp[j];
									//arrTmp[j] = arrTmp[i] - arrTmp[j];
									//arrTmp[i] = arrTmp[i] - arrTmp[j];
								}else{
								
									//这里不用改就是从小到大的
									
								
								};
								
							}else if(getPaiCodeByName(m1.name) > getPaiCodeByName(m2.name))
							{
								if(this._sortOrder)//从大到小
								{
									//这里不用改就是从小到大的
								
								}else
								{
									tmpName = m1.name;
									//tmpV = m1.v;
									
									m1.name = m2.name;
									//m1.v = m2.v;
									
									m2.name = tmpName;
									//m2.v = tmpV;
								}
							
							
							
							}
							
							
					   }//end if
				}//end for
			}//end for
		
		
		} 	
		
		
		/**
		 * 批量的获取
		 */ 
		public function getFrontPaiMcByNameArr(paiNameArr:Array):Array
		{
			var ind:int = 0;
			var len:int = this._paiList.length;
			var mcArr:Array = new Array();
			
			if(null == paiNameArr)
			{
				throw new Error("value can not be empty!");
			}
			
			for(var i:int = 0;i<paiNameArr.length;i++)
			{	
				var paiName:String = paiNameArr[i];
				
				for(var j:int =0;j<len;j++)
				{					
					if((this._paiList[j] as Pai).instanceName == paiName)
					{
						mcArr.push((this._paiList[j] as Pai).view);
						break;
					}
				}
				
			}//end for			
		
			return mcArr;
		}		
		
		/**
		 * 根据名称获取MC实例在_paiList中的索引
		 * 
		 * 注意是指_paiList，不包括背面牌
		 */ 
		public function getFrontPaiMcByName(paiName:String):MovieClip
		{
			var i:int = 0;
			var len:int = this._paiList.length;
			
			if("" == paiName)
			{
				throw new Error("value can not be empty!");
			}
			
			for(i = 0;i<len;i++)
			{				
				if((this._paiList[i] as Pai).instanceName == paiName)
				{
					return (this._paiList[i] as Pai).view;
				}
				
			}//end for			
		
			throw new Error("can not find pai by paiName:" + paiName);
		
			return null;	
		
		}
		
		/**
		 * 参数为mc.name
		 * 如paiMc.name
		 * 返回类型是pai
		 */ 
		public function getFrontPaiByMcName(mcName:String):Pai
		{
			var i:int = 0;
			var len:int = this._paiList.length;
			
			if("" == mcName)
			{
				throw new Error("value can not be empty!");
			}
			
			for(i = 0;i<len;i++)
			{				
				if((this._paiList[i] as Pai).view.name == mcName)
				{
					return (this._paiList[i] as Pai);
				}
				
			}//end for
			
			throw new Error("can not find pai by mcName:" + mcName);
		
			return null;		
		}
		
		/**
		 * 获取关于三张底牌的
		 */ 
		public function getFrontDiPaiMcByName(paiName:String):MovieClip
		{
			var ind:int = 0;
			var len:int = this._dipaiList.length;
			
			if("" == paiName)
			{
				throw new Error("value can not be empty, getFrontPaiMcByName must need one of PokerName!");
			}
			
			for(var i:int = 0;i<len;i++)
			{				
				if((this._dipaiList[i] as Pai).instanceName == paiName)
				{
					ind = i;
					break;
				}
				
			}//end for			
		
			return (this._dipaiList[ind] as Pai).view;
		
		}
		
		public function getPaiCodeByNameArr(paiNameArr:Array):Array
		{
			//loop use			
			var len:int = paiNameArr.length;
			
			var pcArr:Array = new Array();
			
			for(var i:int =0;i<len;i++)
			{
				pcArr.push(getPaiCodeByName(paiNameArr[i]));			
			}
			
			return pcArr;
		
		}
		
		public function getPaiCodeByName(paiName:String):int
		{
			var code:int = 0;
			var len:int = this._paiList.length;
			
			if(PokerName.BG_NORMAL == paiName)
			{
				return PaiCode.BG_NORMAL;
			}
			
			if(PokerName.BG_NONGMING == paiName)
			{
				return PaiCode.BG_NONGMING;
			}
		
			if(PokerName.BG_DIZHU == paiName)
			{
				return PaiCode.BG_DIZHU;	
			}
		
			for(var i:int = 0;i<len;i++)
			{				
				if((this._paiList[i] as Pai).instanceName == paiName)
				{
					code = (this._paiList[i] as Pai).code;
					break;
				}
				
			}//end for
		
			return code;
		}//end func
		
		public function getPaiNameByCodeArr(paiCodeArr:Array):Array
		{
			//loop use			
			var len:int = paiCodeArr.length;
			
			var pnArr:Array = new Array();
			
			for(var i:int =0;i<len;i++)
			{
				pnArr.push(getPaiNameByCode(paiCodeArr[i]));			
			}
			
			return pnArr;
		
		}
		
		public function getPaiNameByCode(paiCode:int):String
		{
			var name:String = "";
			var len:int = this._paiList.length;
			
			if(PaiCode.BG_NORMAL == paiCode)
			{
				return PokerName.BG_NORMAL;
			}
			
			if(PaiCode.BG_NONGMING == paiCode)
			{
				return PokerName.BG_NONGMING;
			}
		
			if(PaiCode.BG_DIZHU == paiCode)
			{
				return PokerName.BG_DIZHU;	
			}			
		
			for(var i:int = 0;i<len;i++)
			{				
				if((this._paiList[i] as Pai).code == paiCode)
				{
					name = (this._paiList[i] as Pai).instanceName;
					break;
				}
				
			}//end for
		
			return name;
		
		
		}
		 
		 
		 //list区 end ---------------------------------------------------------------------- 
		 
		 private function tip_help(pcArr:Array):Array
		 {
		 	
			//
		  	var ra:Array = [];
		  	
		  	
		  		
		  	//
		  	//this.sort(pcArr);
		  		
		  	return ra;		
		}
		
		 /**
		 * 只列出单牌
		 */ 
		 public function tip_single():void
		 {
		 
		 
		 }
		 
		 /**
		 * 牌列表
		 * 根据对方牌形列出自已对应的牌形
		 * 优化，如果列出所有牌形，计算量过大
		 */ 
		 public function tip(pcArr:Array,myArr:Array,lastUse:Array=null):Array
		 {		  	  	
		  	  	//结果是要点的牌列表
		  	  	var res:Array =[];
		  	  	
		  	  	//牌形,元数据1,元数据2				
		  	  	var px:Array = PaiRuleCompare.validate(pcArr);
		  	  	
		  	  	PaiRuleTip.pick(myArr);
		  	  	
		  	  	res = PaiRuleTip.list(px,lastUse);
		  	  	
		  		return res;		  
		 }		
		//list区 end ---------------------------------------------------------------------- 

		
	}
}