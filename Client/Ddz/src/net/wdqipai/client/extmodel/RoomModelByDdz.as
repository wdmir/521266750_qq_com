/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.wdqipai.client.extmodel
{
	import mx.messaging.channels.StreamingAMFChannel;
	
	import net.wdmir.core.PokerName;
	import net.wdqipai.client.extfactory.ChairModelFactory;
	import net.wdqipai.core.factory.UserModelFactory;
	import net.wdqipai.core.model.EUserSex;
	import net.wdqipai.core.model.FChat;
	import net.wdqipai.core.model.IChairModel;
	import net.wdqipai.core.model.IHallRoomModel;
	import net.wdqipai.core.model.ILookChairModel;
	import net.wdqipai.core.model.IRoomModel;
	import net.wdqipai.core.model.IRuleModel;
	import net.wdqipai.core.model.IUserModel;
	import net.wdqipai.core.model.level2.IdleModel;
	import net.wdqipai.core.model.level2.VarModel;
		
	public class RoomModelByDdz implements IRoomModel
	{
		/**
		 * tableId
		 */ 
		private var _id:int;
		
		
		public function get Id():int
		{
			return this._id;
		}
		
		public function getId():int
		{
			return this._id;
		}
		
		public function setId(value:int):void
		{
			this._id = value;
			
		}
		
		
		/**
		 * tableName
		 * 如为空则采用 桌子 + id组合的方法
		 */ 
		private var _name:String;
		/**
		 * 基础扣分
		 * 
		 */ 
		private var _diG:int;
		
		public function getDiG():int
		{
			return this._diG;
		}
		
		public function setDiG(value:int):void
		{
			this._diG = value;
		}
		
		/**
		 * 最少携带
		 * 
		 */ 
		private var _carryG:int;
		
		public function getCarryG():int
		{
			return this._carryG;
		}
		
		public function setCarryG(value:int):void
		{
			this._carryG = value;
		}
		
		/**
		 * 椅子集合
		 */ 
		private var _chair:Vector.<IChairModel>;
		
		/**
		 * 
		 */
		private var _vars:Array; 
		
		/**
		 * 棋子集合
		 * 牌集合
		 * 元素:ItemModelByX
		 */
		private var _pai:Array; 
		
		/**
		 * 空闲用户列表
		 */
		private var _idle:Array; 
		
		/**
		 * 房间状态
		 */ 
		private var _roomStatus:String;		
				 
		/**
		 * 是否为快速场
		 */ 
		private var _quick:int;
		
		public function get isQuick():Boolean
		{
			if(0 == _quick){
				
				return false;
			}
			
			return true;
		}
		
		public function setQuick(value:int):void
		{
			_quick = value;
		}
		
		/**
		 * 地主的userId
		 */   
		private var dizhu:String;
		
		/**
		 * 农民的userId
		 */ 
		private var nongming:String;  
		
		/**
		 * 游戏结束后的地主得分信息
		 */ 
		private var dizhuG:MatchGModelByDdz;
		
		/**
		 * 游戏结束后的农民得分信息
		 */
		private var nongmingG:MatchGModelByDdz;  
		
		/**
		 * 决定是红先还是黑先
		 * 
		 */ 
		private var turn:String; 
		
		/**
		 * 是否处于断线重连
		 */ 
		private var iswaitreconn:Boolean;
		
		/**
		 * 哪一方赢
		 */ 
		private var win:String;  
		
		/**
		 * 底分
		 */ 
		private var difen:String;
		
		/**
		 * 炸弹统计
		 */ 
		private var bomb:int;
		
		/**
		 * 
		 */
		private var round:int;
		
		/**
		 * 规则，用于factory
		 */ 
		private var _rule:IRuleModel;
				
		public function RoomModelByDdz(id:int)
		{
			//
			this._id = id;
			
			this._chair = new Vector.<IChairModel>();
			
			//this._rule = rule;
			
			//i是 chairId
			for(var i:int =1;i<=3;i++)
			{
				this._chair.push(
					ChairModelFactory.CreateEmpty(i)
				);
			
			}
			
			this._diG = -1;
			this._carryG = -1;
			this._pai = new Array();
			this._vars = new Array();
			this._idle = new Array();
			this._roomStatus = "";//
			this._quick = 0;
			
			this.dizhu = "";
			this.nongming = "";
			this.turn = "";
			this.iswaitreconn = false;
			this.difen = "";
			this.bomb = 0;
			this.round = 0;
			
		}
		
		public function getChairCount():int
		{
			return 3;
		}
		
		public function getSomeBodyChairCount():int
		{
			//loop use
            var len:int = this._chair.length;

            var count:int = 0;

            for (var i:int = 0; i < len; i++)
            {
                var chair:IChairModel = this._chair[i] as IChairModel;

                if ("" != chair.getUser().Id)
                {
                    count++;
                }

            }

            return count;
		}
		
		
		public function Name(lang_RoomName:String="room"):String
		{
			if("" == this._name)
			{
				return lang_RoomName + this._id.toString();
			}
			
			return this._name;
		}
		
		public function setName(value:String):void
		{		
			this._name = value;		
		}
		
		public function getMatchInfo():Object
		{
			var params:Object = {};
			
			params.dizhu = this.dizhu;
			params.nongming = this.nongming;
			params.turn = this.turn;
			params.iswaitreconn = this.iswaitreconn;
			params.win = this.win;
			params.difen = this.difen;
			params.bomb = this.bomb.toString();
			params.round = this.round.toString();
			
			return params;
		}
		
		public function getMatchGInfo():Object
		{
			var params:Object = {};
			
			params.dizhuG = this.dizhuG;
			params.nongmingG = this.nongmingG;
			
			return params;
		}
		
		public function setBombCount():void
		{
			this.bomb++;
		}
		
		/**
		 * 自行刷新matchInfo
		 */ 
		public function setTurn(value:String):void
		{
			this.turn = value;		
		}
		
		public function getVarsList() : Array
        {
            return this._vars;
        }// end function
        
        public function getItemList():Array
		{
			return this._pai;
		
		}
		
		public function getIdleList():Array
		{
			return this._idle;
		}
		
		/**
		 * 此方法不适合空用户，如果有2个，则找到第1个就直接return了
		 */ 
		public function getChair(value:IUserModel):IChairModel
		{
			for(var i:int =0;i<this._chair.length;i++)
			{
				if((this._chair[i] as IChairModel).getUser().Id == value.Id)
				{
					return (this._chair[i] as IChairModel);
					//break;
				}
			
			}
			
			//throw new Error("can not found user id:" + value.Id);
			return null;
		}
		
		public function getChairByUserId(value:String):IChairModel
		{
			for(var i:int =0;i<this._chair.length;i++)
			{
				if((this._chair[i] as IChairModel).getUser().Id == value)
				{
					return (this._chair[i] as IChairModel);
					//break;
				}
				
			}
			
			//throw new Error("can not found user id:" + value.Id);
			return null;
		}
		
		public function getChairById(value:int):IChairModel
		{
			for(var i:int =0;i<this._chair.length;i++)
			{
				if((this._chair[i] as IChairModel).Id == value)
				{
					return this._chair[i];
					//break;
				}
				
			}
			
			//throw new Error("can not found user id:" + value.Id);
			return null;
		}
		
		public function get Status():String
		{
			return this._roomStatus;
		}
		
		public function setStatus(value:String):void
		{
			this._roomStatus = value;
		}
        		
		/**
		 * update函数必须一起调用,全部执行完
		 */ 
		public function updateMatchInfo(value:XMLList):void
		{
			//<match red="d6b01549c2c297ef723bba03f9b09825" black="" round="0" turn="" win=""/>
			for each(var matchInfo:XML in value)
			{
				this.dizhu    = matchInfo.@dizhu;
				this.nongming = matchInfo.@nongming;
				this.turn     = matchInfo.@turn;
				this.iswaitreconn = Boolean(parseInt(matchInfo.@iswaitreconn));
				this.win      = matchInfo.@win;
				this.round    = parseInt(matchInfo.@round);
				this.difen    = matchInfo.@difen;
				this.bomb     = parseInt(matchInfo.@bomb);
			}		
		}
		
		public function updateMatchGInfo(value:XMLList):void
		{
			//<action type='add' id='d6b01549c2c297ef723bba03f9b09825,5a105e8b9d40e1329780d62ea2265d8a,' g='900'/>
            //<action type='sub' id='ad0234829205b9033196ba818f7a872b' g='1800'/>
			for each(var matchGInfo:XML in value)
			{
				var type:String = matchGInfo.@type;
				
				var id:String =  matchGInfo.@id;
				
				var g:String = matchGInfo.@g;
				
				//
				var plusOrSubSign:String = "";
				
				if("add" == type)
				{
					plusOrSubSign = "+";
					
				}else if("sub" == type)
				{
					plusOrSubSign = "-";						
					
				}else
				{
					plusOrSubSign = "";
				}
				
				//if(id.indexOf(this.dizhu) > -1)
				if(id == this.dizhu)
				{				
	
					this.dizhuG = new MatchGModelByDdz(id,g,plusOrSubSign);
					
				}else if(this.nongming.indexOf(id) > -1 ||
						 this.nongming == id)
				{
					this.nongmingG = new MatchGModelByDdz(id,g,plusOrSubSign);
				
				}
			
			}
		
		}
        
        /**
        * 每次收到指令后，到这里取
        * 比 qipaiEvt带参数的好处是可以取多次
        */ 
        public function updateVarsList(value:XMLList) : void
        {
        	//clear
            var len:uint = this._vars.length;
            
            for(var i:int=0;i<len;i++)
            {
            	this._vars.pop();
            }
            
            //
            for each (var varInfo:XML in value)
            {
                
                var n:String = varInfo.val.@n;
                var t:String = varInfo.val.@t;
                var val:String = varInfo.val;
                var varModel:VarModel = new VarModel(n, t, val);
                this._vars.push(varModel);
            }
            return;
        }// end function
		
		
		public function updateItemList(value:XMLList):void
		{
			//loop use
			var i:int = 0;
			
			//clear			
            var len:uint = this._pai.length;
            
            for(i=0;i<len;i++)
            {
            	this._pai.pop();
            }
            
			//
			for each(var itemInfo:XML in value)
			{
				var itemName:String = itemInfo.@n;
				var itemH:uint = uint(itemInfo.@h);
				var itemV:uint = uint(itemInfo.@v);
				
				//
				var itemModel:ItemModelByDdz;
				
				//
				if(PokerName.BG_NORMAL == itemName ||
				   PokerName.BG_DIZHU == itemName ||
				   PokerName.BG_NONGMING == itemName
				)
				{			
					//这个我们称之为传输压缩，内存释放		
					for(i=0;i<itemV;i++)
					{
						itemModel = new ItemModelByDdz(itemName,itemH,i);//v
				
						this._pai.push(itemModel);
					}				
				}
				else
				{
					itemModel = new ItemModelByDdz(itemName,itemH,itemV);
				
					this._pai.push(itemModel);
				
				}//end if
				
				
			}//end for
			
		
		}		
		
		public function updateIdleList(value:XMLList):void
		{
			//clear
            var len:uint = this._idle.length;
            
            for(var i:int=0;i<len;i++)
            {
            	this._idle.pop();
            }
            
			//
			for each(var idleInfo:XML in value)
			{
				var uId:String = idleInfo.@id;
				var uNickName:String = idleInfo.@n;
				var uSex:String = idleInfo.@s;
				
				var idleModel:IdleModel = new IdleModel(uId,uNickName);
				
				this._idle.push(idleModel);
			}
		
		}
		
		/**
		 * chairListXml
		 */ 
		public function updateChairInfo(value:XMLList):void
		{
			//
			for each(var chair:XML in value)
			{
				var cId:int = int(chair.@id);
				var cR:Boolean = Boolean(parseInt(chair.@ready));
				
					var uId:String = chair.u.@id;
					var uId_SQL:String = chair.u.@id_sql;
					var uG:String = chair.u.@g;
					var uNickName:String = chair.u.@n;
					var uSex:String = chair.u.@s;
					var uBbs:String = chair.u.@bbs;
					var uHico:String = chair.u.@hico;
					var uIsAdmin:Boolean = Boolean(parseInt(chair.u.@iam));
				
				var cModel:IChairModel = ChairModelFactory.Create(cId,cR);
				
				var uModel:IUserModel = UserModelFactory.Create(uId,uSex,uNickName,uBbs,uIsAdmin,_rule);
				
					uModel.setG(uG);
					uModel.setId_SQL(uId_SQL);
					uModel.setHeadIco(uHico);
				
				cModel.setUser(uModel);
				
				//qpc.data.activeRoom
				this.setChair(cModel);
			}
		
		}
		
		/**
		 * roundListXml
		 */ 
		public function updateRoundInfo(value:XMLList):void
		{
			
			
		}
		
		public function setChair(value:IChairModel):void
		{
			for(var i:int =0;i<this._chair.length;i++)
			{
				if((this._chair[i] as IChairModel).Id == value.Id)
				{
					//this._chair[i] = value;
					(this._chair[i] as IChairModel).setProperty(value.getReady(),value.getUser());
					return;
					//break;
				}
			
			}
			
			throw new Error("can not found chair id:" + value.Id);
		
		}
		
		/**
		 * == value.Id
		 * 
		 */ 
		public function findHero(value:IUserModel):IUserModel
		{
			for(var i:int =0;i<this._chair.length;i++)
			{
				if((this._chair[i] as IChairModel).getUser().Id == value.Id)
				{
					return (this._chair[i] as IChairModel).getUser();
					//break;
				}
			
			}
			
			throw new Error("can not found user id:" + value.Id);
		
		}
		
		/**
		 * != value.Id
		 */ 
		public function findUser(value:IUserModel):Array
		{
			var users:Array = new Array();
			
			//loop use
			var i:int = 0;
			var len:int = this._chair.length;
			
			//check
			for(i =0;i<len;i++)
			{
				if(this._chair[i].getUser().Id == value.Id)
				{
					break;
				}
				
				//到这里还没跳出循环，说明没找到
				if(i == (len-1))
				{
					throw new Error("can not found user id:" + value.Id);				
				}
			}			
			
			//add
			for(i =0;i<len;i++)
			{
				if(this._chair[i].getUser().Id != value.Id)
				{
					users.push((this._chair[i] as IChairModel));
				}
			
			}
			
			return users;		
		}
		
		public function getUserById(userId:String):IUserModel
		{
			var i:int=0;
			var len:int = this._chair.length;
			
			for(i =0;i<len;i++)
			{
				if(this._chair[i].getUser().Id == userId)
				{
					return this._chair[i].getUser();
				}
				
			}
		
			return null;
		}
		
		
		public function updateLookChairInfo(value:XMLList):void
		{
			//斗地主不需要旁观
		
		}
		
		
		
		
	}
}
