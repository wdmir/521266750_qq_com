/*
 * VERSION:3.0
 * DATE:2014-10-15
 * ACTIONSCRIPT VERSION: 3.0
 * UPDATES AND DOCUMENTATION AT: http://www.wdmir.net 
 * MAIL:mir3@163.com
 */
package net.silverfoxserver.extmodel
{
	import net.silverfoxserver.extfactory.ChairModelFactory;
	import net.silverfoxserver.extfactory.LookChairModelFactory;
	import net.silverfoxserver.extmodel.ItemModelByChChess;
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
		
	public class RoomModelByChChess implements IRoomModel
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
		 * 观众集合
		 */ 
		private var _lookChair:Vector.<ILookChairModel>;
		
		/**
		 * 
		 */
		private var _vars:Array; 		
		
		/**
		 * 棋子集合
		 * 元素:ItemModelByChChess
		 */
		private var _qizi:Array; 
		
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
		 * 红方的userId
		 */   
		private var red:String;
		
		private var curRedJuShiTime:int;
		
		/**
		 * 黑方的userId
		 */ 
		private var black:String;  
		
		private var curBlackJuShiTime:int;
		
		/**
		 * 游戏结束后的红方得分信息
		 */ 
		private var redG:String;
		
		/**
		 * 游戏结束后的黑方得分信息
		 */ 
		private var blackG:String;
		
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
		 * 
		 */
		private var round:int;
		
		/**
		 * 规则，用于factory
		 */ 
		private var _rule:IRuleModel;
		
		
		
				
		public function RoomModelByChChess(id:int,rule:IRuleModel)
		{
			//
			this._id = id;
			
			this._chair = new Vector.<IChairModel>();
			
			this._lookChair = new Vector.<ILookChairModel>();
			
			this._rule = rule;
			
			this._diG = -1;
			this._carryG = -1;
			
			//i是 chairId
			var i:int;
			
			for(i =1;i<=_rule.ChairCount;i++)
			{
				this._chair.push(
				ChairModelFactory.CreateEmpty(i,_rule)
				);
			
			}
			
			for(i =1;i<=_rule.lookChairMaxCount;i++)
			{
				
				this._lookChair.push(
					LookChairModelFactory.CreateEmpty(i)
				);
				
			}
			
			this._qizi = new Array();
			this._vars = new Array();
			this._idle = new Array();
			this._roomStatus = "";//
			this._quick = 0;
			
			this.red = "";
			this.black = "";
			this.turn = "";
			this.iswaitreconn = false;
		}
		
		public function getChairCount():int
		{
			return _rule.ChairCount;
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
			
			params.red = this.red;			
			params.black = this.black;
			params.turn = this.turn;
			params.iswaitreconn = this.iswaitreconn;
			params.win = this.win;
			params.round = this.round.toString();
			
			params.curRedJuShiTime = this.curRedJuShiTime;
			params.curBlackJuShiTime = this.curBlackJuShiTime;
			
			return params;
		}
		
		public function getMatchGInfo():Object
		{
			var params:Object = {};
			
			params.redG = this.redG;
			params.blackG = this.blackG;
			
			return params;
		}
		
		/**
		 * 自行刷新matchInfo
		 */ 
		public function setTurn(value:String):void
		{
			this.turn = value;		
		}
		
		/**
		 * update函数必须一起调用,全部执行完
		 */ 
		public function updateMatchInfo(value:XMLList):void
		{
			//<match red="d6b01549c2c297ef723bba03f9b09825" black="" round="0" turn="" win=""/>
			for each(var matchInfo:XML in value)
			{
				var red:String = matchInfo.@red;				
				var black:String = matchInfo.@black;
				var turn:String = matchInfo.@turn;
				var win:String  = matchInfo.@win;
				
				var curRedJuShiTime:int = parseInt(matchInfo.@curRedJuShiTime);
				var curBlackJuShiTime:int = parseInt(matchInfo.@curBlackJuShiTime);
				
				this.red = red;
				this.black = black;
				this.turn = turn;
				this.win = win;
				
				this.curRedJuShiTime = curRedJuShiTime;
				this.curBlackJuShiTime = curBlackJuShiTime;
				
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
				
				if(id.indexOf(this.red) > -1)
				{
					if("add" == type)
					{
						this.redG = "+" + g;
					}else
					{
						this.redG = "-" + g;
					}
					
				}else
				{
					if("add" == type)
					{
						this.blackG = "+" + g;
					}else
					{
						this.blackG = "-" + g;
					}
				}
			
			}
		
		}
		
		public function getVarsList() : Array
        {
            return this._vars;
        }// end function
        
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
			//clear
            var len:uint = this._qizi.length;
            
            for(var i:int=0;i<len;i++)
            {
            	this._qizi.pop();
            }
            
			//
			for each(var itemInfo:XML in value)
			{
				var itemName:String = itemInfo.@n;
				var itemH:uint = uint(itemInfo.@h);
				var itemV:uint = uint(itemInfo.@v);
				
				var itemModel:ItemModelByChChess = new ItemModelByChChess(itemName,itemH,itemV);
				
				this._qizi.push(itemModel);
			}
			
		
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
					var uId_SQL:uint = uint(chair.u.@id_sql);
					var uNickName:String = chair.u.@n;
					var uSex:String = chair.u.@s;
					var uIsAdmin:Boolean = Boolean(parseInt(chair.u.@iam));
					var uHico:String = chair.u.@hico;
				
				var cModel:IChairModel = ChairModelFactory.Create(cId,cR,_rule);
				
				var uModel:IUserModel = UserModelFactory.Create(uId,uSex,uNickName,"",uIsAdmin,_rule);
				uModel.setHeadIco(uHico);
				
				cModel.setUser(uModel);
				
				//qpc.data.activeRoom
				this.setChair(cModel);
			}
		
		}
		
		/**
		 * 
		 */ 
		public function updateLookChairInfo(value:XMLList):void
		{
			//
			for each(var chair:XML in value)
			{
				var cId:int = int(chair.@id);
				//var cR:Boolean = Boolean(parseInt(chair.@ready));
				
				var uId:String = chair.u.@id;
				var uId_SQL:uint = uint(chair.u.@id_sql);
				var uNickName:String = chair.u.@n;
				var uSex:String = chair.u.@s;
				var uIsAdmin:Boolean = Boolean(parseInt(chair.u.@iam));
				
				var cModel:ILookChairModel = LookChairModelFactory.Create(cId);
				
				var uModel:IUserModel = UserModelFactory.Create(uId,uSex,uNickName,"",uIsAdmin,_rule);
				
				cModel.setUser(uModel);
				
				//qpc.data.activeRoom
				this.setLookChair(cModel);
			}
			
		}
		
		/**
		 * roundListXml
		 */ 
		public function updateRoundInfo(value:XMLList):void
		{
		
		}
		
		public function getItemList():Array
		{
			return this._qizi;
		
		}
		
		public function getIdleList():Array
		{
			return this._idle;
		}
		
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
					return (this._chair[i] as IChairModel);
					//break;
				}
				
			}
			
			return null;
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
		
		public function setLookChair(value:ILookChairModel):void
		{
			
			var i:int = 0;
			var len:int = this._lookChair.length;			
			
			for(var i:int =0;i<len;i++)
			{
				if((this._lookChair[i] as ILookChairModel).Id == value.Id)
				{
					
					(this._lookChair[i] as ILookChairModel).setProperty(value.getUser());
					return;
					//break;
				}
				
			}
			
			throw new Error("can not found chair id:" + value.Id);
			
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
		 * == value.Id
		 * 
		 */ 
		public function findHero(value:IUserModel):IUserModel
		{
			
			var i:int;
			var len:int;
			
			
			len = this._chair.length;
			
			for(i =0;i<len;i++)
			{
				if((this._chair[i] as IChairModel).getUser().Id == value.Id)
				{
					return (this._chair[i] as IChairModel).getUser();
					//break;
				}
			
			}
			
			//
			
			len = this._lookChair.length;
						
			for(i =0;i<len;i++)
			{
				if((this._lookChair[i] as ILookChairModel).getUser().Id == value.Id)
				{
					return (this._lookChair[i] as ILookChairModel).getUser();
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
				if((this._chair[i] as IChairModel).getUser().Id == value.Id)
				{
					break;
				}
				
				//到这里还没跳出循环，说明没找到
				//旁观则找不到
				if(i == (this._chair.length-1))
				{
					//throw new Error("can not found user id:" + value.Id);				
				}
			}			
			
			//add
			for(i =0;i<len;i++)
			{
				if((this._chair[i] as IChairModel).getUser().Id != value.Id)
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
		
		
		
		
		
		
	}
}
