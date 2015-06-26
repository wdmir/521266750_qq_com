package State.Room.RoomModel
{
	
	import flash.display.MovieClip;
	
	import mx.controls.Alert;
	
	public class QiziRule
	{
		public const H_MAX:uint = 10;
		public const H_MIN:uint = 1;
		public const V_MAX:uint = 9;
		public const V_MIN:uint = 1;
		
		private var _roadList:Array;
		private var _qiziList:Array;
		
		/**
		 * 
		 */ 
		private var _recordList:Array;
		
		public function addRecord(zf:String):void
		{
			_recordList.push(zf);
		}
		
		public function get recordList():Array
		{
			return _recordList;
		}
				
		/**
		 * roadList来自 RoomViewBg.mxml页面的变量
		 */ 
		public function QiziRule(roadList:Array,qiziList:Array)
		{
			this._roadList = roadList;
			this._qiziList = qiziList;
			_recordList = new Array();
		}
		
		public function getRoad(h:uint,v:uint):MovieClip
		{
			if(0 == h)
			{
				throw new Error("h can not be 0");
			}
			
			if(0 == v)
			{
				throw new Error("v can not be 0");
			}
			
			return this._roadList[h-1][v-1];
		}
		
		public function qiziIsWoFang(color:String):Boolean
		{
			//棋盘
			var matchInfo:Object = GameGlobals.qpc.data.activeRoom.getMatchInfo();//getMatchInfo();			
			
			if(matchInfo.red == GameGlobals.qpc.data.hero.Id &&
			   color == QiziColor.RED)
			{		 
				return true;
					
				//不需要反转
			}else if(matchInfo.black == GameGlobals.qpc.data.hero.Id &&
				  	 color == QiziColor.BLACK)
			{
				return true;
					
			}
			
			return false;
		
		}
		
		/**
		 * 判断基底
		 * 
		 */ 
		public function floor():String
		{
			//棋盘
			var matchInfo:Object = GameGlobals.qpc.data.activeRoom.getMatchInfo();			
			
			if(matchInfo.red == GameGlobals.qpc.data.hero.Id)
			{		 
				return QiziColor.RED;
			}
			else(matchInfo.balck == GameGlobals.qpc.data.hero.Id)
			{
				return QiziColor.BLACK;					
			}
			
			throw new Error("can not found floor");
			
			return "";
		
		}
		
		public function reset():void
		{	
			//取消所有路点
			for(var i:int=this.H_MIN;i<=this.H_MAX;i++)
			{
				for(var j:int=this.V_MIN;j<=this.V_MAX;j++)
				{
					this.getRoad(i,j).visible = false;
									
				}//end for
			
			}//end for
			
			//重设所有棋子为第一帧
			var len:uint = this._qiziList.length;
			
			for(var k:int =0;k<len;k++)
			{
				var q:Qizi = this._qiziList[k] as Qizi;
				
				q.view.gotoAndStop(1);			
			}
			
			//
			this._recordList = new Array();
		}
		
		/**
		 * 第二步走了后是否可以叫将军
		 * 
		 * 同时几个将的情况，所以只要返回一个bool值即可
		 * 
		 * color是第二步棋子的颜色
		 * 
		 */ 
		public function canTipJiangJun(color:String):Boolean
		{
			var jiangJun:Boolean = false;			
			
			var len:uint = this._qiziList.length;
			
			//当前的棋盘是红底还是黑底
			var f:String = this.floor();
			
			for(var k:int=0;k<len;k++)
			{
				var qizi:Qizi = this._qiziList[k] as Qizi;
				
				//第二步棋子的颜色,并且是活着的棋子，
				if(color == qizi.color && true == qizi.view.visible)
				{
					//是否可以将军
					if(QiziName.En_Bing == qizi.enName)
					{
						//特殊
						//红底红兵
						if(f == QiziColor.RED && QiziColor.RED == qizi.color)
						{
							jiangJun = this.movePointGuize_bing_jj(qizi.h,qizi.v,color);
						
						}
						else if(f == QiziColor.RED && QiziColor.BLACK == qizi.color)//红底黑兵
						{
							jiangJun = this.movePointGuize_bing_jj_gridReverse(qizi.h,qizi.v,color);
						}
						else if(f == QiziColor.BLACK && QiziColor.RED == qizi.color)//黑底红兵
						{
							jiangJun = this.movePointGuize_bing_jj_gridReverse(qizi.h,qizi.v,color);
						
						}
						else if(f == QiziColor.BLACK && QiziColor.BLACK == qizi.color)//黑底黑兵
						{
							jiangJun = this.movePointGuize_bing_jj(qizi.h,qizi.v,color);
						}
						
						//debug
						//if(jiangJun){Alert.show("兵将");};
						
						
					}else if(QiziName.En_Pao == qizi.enName)		
					{
						jiangJun = this.movePointGuize_pao_jj(qizi.h,qizi.v,color);
						
						//debug
						//if(jiangJun){Alert.show("pao将");};
						
					}else if(QiziName.En_Ju == qizi.enName)
					{
						jiangJun = this.movePointGuize_ju_jj(qizi.h,qizi.v,color);
						
						//debug
						//if(jiangJun){Alert.show("ju将");};
						
					}else if(QiziName.En_Ma == qizi.enName)
					{
						jiangJun = this.movePointGuize_ma_jj(qizi.h,qizi.v,color);
						
						//debug
						//if(jiangJun){Alert.show("ma将");};
						
					}else if(QiziName.En_Xiang == qizi.enName)
					{
						jiangJun = this.movePointGuize_xiang_jj(qizi.h,qizi.v,color);
						
						//debug
						//if(jiangJun){Alert.show("xiang将");};
						
					}else if(QiziName.En_Shi == qizi.enName)
					{
						jiangJun = this.movePointGuize_shi_jj(qizi.h,qizi.v,color);
						
						//debug
						//if(jiangJun){Alert.show("shi将");};
						
					}else if(QiziName.En_Jiang == qizi.enName)
					{
						//特殊						
						if(f == QiziColor.RED && QiziColor.RED == qizi.color)//红底红将
						{
							jiangJun = this.movePointGuize_jiang_jj(qizi.h,qizi.v,color);
						
						}
						else if(f == QiziColor.RED && QiziColor.BLACK == qizi.color)//红底黑将
						{
							jiangJun = this.movePointGuize_jiang_jj_gridReverse(qizi.h,qizi.v,color);
						}
						else if(f == QiziColor.BLACK && QiziColor.RED == qizi.color)//黑底红将
						{
							jiangJun = this.movePointGuize_jiang_jj_gridReverse(qizi.h,qizi.v,color);
						
						}
						else if(f == QiziColor.BLACK && QiziColor.BLACK == qizi.color)//黑底黑将
						{
							jiangJun = this.movePointGuize_jiang_jj(qizi.h,qizi.v,color);
						}
						
						//debug
						//if(jiangJun){Alert.show("jiang将");};
					}
				
				}//end if
				
				//优化，只需要知道有一个能将军就行了，跳出循环
				if(jiangJun)
				{				
					break;
				}
			
			}//end for
			
			return jiangJun;
		
		}
		
		
		/**
		 * 有棋子并可见，返回true
		 * 如该棋子不可见，则返回false
		 * 同时对敌方棋子做标红处理
		 * 
		 */ 
		public function hereHasOneQizi(h:uint,v:uint):Boolean
		{
			var len:int = this._qiziList.length;
			
			//_qiziList的数量少于 _roadList的数量
			for(var i:int = 0; i<len;i++)
			{
				var qizi:Qizi = this._qiziList[i] as Qizi;
				
				if(h == qizi.h && v == qizi.v && qizi.view.visible == true)
				{	
					//如果该棋子不是已方棋子，则该棋子变红
					//棋子变红后可执行点击命令
					
					if(!this.qiziIsWoFang(qizi.color))
					{
						qizi.view.gotoAndPlay(2);
					}

					return true;
				}//end if 
				
			}//end for 
						
			return false;
		}
		
		/**
		 * 将的特殊实现
		 * 
		 */ 
		public function hereHasOneQizi_jiang(h:uint,v:uint):Boolean
		{
			var len:int = this._qiziList.length;
			
			//_qiziList的数量少于 _roadList的数量
			for(var i:int = 0; i<len;i++)
			{
				var qizi:Qizi = this._qiziList[i] as Qizi;
				
				if(h == qizi.h && v == qizi.v && qizi.view.visible == true)
				{	
					//如果该棋子不是已方棋子，则该棋子变红
					//棋子变红后可执行点击命令
					
					if(!this.qiziIsWoFang(qizi.color))
					{
						//为将才变色
						if(qizi.view.name.indexOf("jiang",0) > -1)
						{
							qizi.view.gotoAndPlay(2);
						}
					}

					return true;
				}//end if 
				
			}//end for 
						
			return false;
		}
		
		/**
		 * 炮的特殊实现
		 * 即第一个棋子不变红
		 * 
		 * 同样也适用于将军的检测 
		 * 将军做动词讲
		 */ 
		public function hereHasOneQizi_pao(h:uint,v:uint):Boolean
		{
			var len:int = this._qiziList.length;
			
			//_qiziList的数量少于 _roadList的数量
			for(var i:int = 0; i<len;i++)
			{
				var qizi:Qizi = this._qiziList[i] as Qizi;
				
				if(h == qizi.h && v == qizi.v && qizi.view.visible == true)
				{
					//炮的特殊实现
					//即第一个棋子不变红

					return true;
				}//end if 
				
			}//end for 
						
			return false;
		}
		
		/**
		 * 上面判断有无棋子
		 * 这里判断棋子是否是将
		 */ 
		private function qiziIsJiang(h:uint,v:uint,color:String):Boolean
		{
			var len:int = this._qiziList.length;
			
			//_qiziList的数量少于 _roadList的数量
			for(var i:int = 0; i<len;i++)
			{
				var qizi:Qizi = this._qiziList[i] as Qizi;
				
				if(h == qizi.h && v == qizi.v && qizi.view.visible == true)
				{
					//炮的特殊实现
					//即第一个棋子不变红
					if(QiziColor.RED == color)
					{
						if("red_jiang_1" == qizi.view.name)
						{
							return true;
						}
					}
					
					if(QiziColor.BLACK == color)
					{
						if("black_jiang_1" == qizi.view.name)
						{
							return true;
						}
					}
									
					
				}//end if 
				
			}//end for 
						
			return false;
		}
		
		//炮的行走规则
		//这一行或这一列，有2个或以上棋子，第2个棋子变红
		//roadPoint只达第一个棋子
		public function movePointGuize_pao(h:uint,v:uint):void
		{			
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//qizi jump use
			var k:int = 0;
			
			//方向下	
			//可行点
			if(h < this.H_MAX)
			{
				for(i=(h+1);i<=this.H_MAX;i++)
				{
					if ( !hereHasOneQizi_pao(i,v))
					{
						//理论可行点		
						this.getRoad(i,v).visible = true;	
					}
					else
					{	
						break;
					}					
				}			
			
				//敌方棋子标红
				for(i=(h+1);i<=this.H_MAX;i++)
				{
					if(hereHasOneQizi_pao(i,v))
					{
						k++;
						
						if(k == 2)
						{
							this.hereHasOneQizi(i,v);
							break;
						}
					}
				}
			}
			
			i = 0;
			j = 0;
			k = 0;
			
			//方向上
			//可行点
			if(h >this.H_MIN)
			{
				for(i=(h-1);i>=this.H_MIN;i--)
				{
					if ( !hereHasOneQizi_pao(i,v))
					{
						//理论可行点		
						this.getRoad(i,v).visible = true;	
					}
					else
					{
						break;
					}					
				}
				
				
				for(i=(h-1);i>=0;i--)
				{
					if(hereHasOneQizi_pao(i,v))
					{
						k++;
						
						if(k == 2)
						{
							this.hereHasOneQizi(i,v);
							break;
						}
					}
				}
			}	
			
			i = 0;
			j = 0;
			k = 0;
			
			//
			//可行点
			if(v < this.V_MAX)
			{
				for(j=(v+1);j<=this.V_MAX;j++)
				{
					if ( !hereHasOneQizi_pao(h,j))
					{
						//理论可行点		
						this.getRoad(h,j).visible = true;	
					}
					else
					{
						break;
					}					
				}
				
				for(j=(v+1);j<=this.V_MAX;j++)
				{
					if(hereHasOneQizi_pao(h,j))
					{
						k++;
						
						if(k == 2)
						{
							this.hereHasOneQizi(h,j);
							break;
						}
					}
				}
				
				
			}
			
			i = 0;
			j = 0;
			k = 0;
			
			if(v > this.V_MIN)
			{
				//可行点
				for(j=(v-1);j>=this.V_MIN;j--)
				{
					if ( !hereHasOneQizi_pao(h,j))
					{
						//理论可行点		
						this.getRoad(h,j).visible = true;	
					}
					else
					{					
						break;
					}					
				}
				
				for(j=(v-1);j>=this.V_MIN;j--)
				{
					if(hereHasOneQizi_pao(h,j))
					{
						k++;
						
						if(k == 2)
						{
							this.hereHasOneQizi(h,j);
							break;
						}
					}
				}
				
				
			}
			
						
		}//end func
		
		//兵在6行(从1开始算)，可横走，但不可退
		//步进:step = 1
		
		public function movePointGuize_bing(h:uint,v:uint):void
		{			
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//未过河			
			if(h > 5)
			{				
				if( !hereHasOneQizi(h-1,v) )
				{	
					this.getRoad(h-1,v).visible = true;
				}
				
				return;
			}
			
			//过河卒
			if(h <= 5)
			{
				//方向左
				if(v > 1)
				{
					for(j=(v-1);j>=(v-1);j--)
					{				
						if( !hereHasOneQizi(h,j) )
						{
							//理论可行点		
							this.getRoad(h,j).visible = true;
						}
						else
						{
							break;
						}	
					}
				}
				
				//方向上
				if(h > 1)//特殊判断，到顶
				{
					for(i=(h-1);i<=(h-1);i++)
					{
						if ( !hereHasOneQizi(i,v))
						{
							//理论可行点		
							this.getRoad(i,v).visible = true;		
						}
						else
						{
							break;
						}					
					}
				}
				
				//方向右	
				if(v < 9)
				{
					for(j=(v+1);j<=(v+1);j++)
					{
						if( !hereHasOneQizi(h,j) )
						{
							//理论可行点
							this.getRoad(h,j).visible = true;
						}
						else
						{
							break;
						}	
					}
				}
			}						
		}
//		
//		//车的行走规则
		public function movePointGuize_ju(h:uint,v:uint):void
		{	
			//以 h,v为中心进行四方向寻路，如遇棋子则中断该寻路
			//            
			//            上
			//           左 右
			//            下
			//
			
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//方向下
			for(i=(h+1);i<=this.H_MAX;i++)
			{
				if ( !hereHasOneQizi(i,v))
				{
					//理论可行点		
					this.getRoad(i,v).visible = true;		
				}
				else
				{
					break;
				}					
			}
			
			i = 0;
			j = 0;
			
			//方向上
			for(i=(h-1);i>=this.H_MIN;i--)
			{
				if ( !hereHasOneQizi(i,v))
				{
					//理论可行点
					this.getRoad(i,v).visible = true;
				}	
				else
				{
					break;
				}	
			}
			
			
			i = 0;
			j = 0;
				
			//方向 右	
			for(j=(v-1);j>=this.V_MIN;j--)
			{				
				if( !hereHasOneQizi(h,j) )
				{
					//理论可行点		
					this.getRoad(h,j).visible = true;			
				}
				else
				{
					break;
				}	
			}
			
			i = 0;
			j = 0;
			
			//方击左
			for(j=(v+1);j<=this.V_MAX;j++)
			{
				if( !hereHasOneQizi(h,j) )
				{
					//理论可行点		
					this.getRoad(h,j).visible = true;						
				}
				else
				{
					break;
				}	
			}
			
			
			
		}
//		
//		//马的行走规则  8方向
//		//
//		//         左上  右上
//		//  左斜上             右斜上
//		//	
//		//  左斜下			右斜下		
//		//       左下   右下
//		//
		public function movePointGuize_ma(h:uint,v:uint):void
		{			
			//右上					
			if( (h-2) >= this.H_MIN && (h-2) <= this.H_MAX && 
			    (v+1) >= this.V_MIN && (v+1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_shang(h,v))
				{
					//红色可吃棋处理，无棋则显示路点				
					if( !hereHasOneQizi(h-2,v+1) )
					{
						this.getRoad(h-2,v+1).visible = true;
					}
				}
			}		
			
			//左上
			if( (h-2) >= this.H_MIN && (h-2) <= this.H_MAX && 
			    (v-1) >= this.V_MIN && (v-1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_shang(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi(h-2,v-1) )
					{
						this.getRoad(h-2,v-1).visible = true;
					}
				}	
			}
			
			//右斜上	
			if( (h-1) >= this.H_MIN && (h-1) <= this.H_MAX && 
			   (v + 2)>= this.V_MIN && (v + 2) <= this.V_MAX)
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_xieshang(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi(h-1,v + 2) )
					{
						this.getRoad(h-1,v+2).visible = true;
					}
				}		
			}
			
			//左	斜上
			if( (h-1) >= this.H_MIN && (h-1) <= this.H_MAX &&
			    (v-2) >= this.V_MIN && (v-2) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_xieshang(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi(h-1,v-2) )
					{
						this.getRoad(h-1,v-2).visible = true;	
					}
				}										
			}
			
			//右下					
			if( (h+2) >= this.H_MIN && (h+2) <= this.H_MAX && 
			    (v+1) >= this.V_MIN && (v+1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_xia(h,v))
				{		
					//红色可吃棋处理
					if( !hereHasOneQizi(h+2,v+1) )
					{			
						this.getRoad(h+2,v+1).visible = true;
					}
				}						
			}	
			
			//左下
			if( (h+2) >= this.H_MIN && (h+2) <= this.H_MAX &&
			    (v-1) >= this.V_MIN && (v-1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_xia(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi(h+2,v-1) )
					{
						this.getRoad(h+2,v-1).visible = true;
					}
				}			
			}
			
			//右斜下
			if( (h + 1) >= this.H_MIN && (h + 1) <= this.H_MAX &&
			    (v + 2) >= this.V_MIN && (v + 2) <= this.V_MAX)
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_xiexia(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi(h+1,v + 2) )
					{
						this.getRoad(h+1,v+2).visible = true;
					}
				}						
			}	
			
			//左斜下
			if(  (h+1) >= this.H_MIN && (h+1) <= this.H_MAX &&
			     (v-2) >= this.V_MIN && (v-2) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_xiexia(h,v))
				{		
					//红色可吃棋处理
					if( !hereHasOneQizi(h+1,v-2) )
					{				
						this.getRoad(h+1,v-2).visible = true;	
					}
				}																
			}
		
		}
//		
//		//撇腿实现
		private function pietui_ma_dir_zuo_shang(h:uint,v:uint):Boolean
		{
			var pietui:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h-1,v))
			{
				pietui = true;
				
				return pietui;			
			}
			
			return pietui;
		}
		
		private function pietui_ma_dir_you_shang(h:uint,v:uint):Boolean
		{
			return pietui_ma_dir_zuo_shang(h,v);
		}
		
		private function pietui_ma_dir_zuo_xieshang(h:uint,v:uint):Boolean
		{
			var pietui:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h,v-1))
			{
				pietui = true;
				
				return pietui;			
			}
			
			return pietui;
		}
//		
		
//		
		private function pietui_ma_dir_you_xieshang(h:uint,v:uint):Boolean
		{
			var pietui:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h,v+1))
			{
				pietui = true;
				
				return pietui;			
			}
			
			return pietui;
		}
//		
		private function pietui_ma_dir_zuo_xiexia(h:uint,v:uint):Boolean
		{
			var pietui:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h,v-1))
			{
				pietui = true;
				
				return pietui;			
			}
			
			return pietui;
		}
//		
		private function pietui_ma_dir_you_xiexia(h:uint,v:uint):Boolean
		{
			var pietui:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h,v+1))
			{
				pietui = true;
				
				return pietui;			
			}
			
			return pietui;
		}
//		
		private function pietui_ma_dir_zuo_xia(h:uint,v:uint):Boolean
		{
			var pietui:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h+1,v))
			{
				pietui = true;
				
				return pietui;			
			}
			
			return pietui;
		}
//		
		private function pietui_ma_dir_you_xia(h:uint,v:uint):Boolean
		{
			return pietui_ma_dir_zuo_xia(h,v);
		}
//		
//		//象的行走规则
		public function movePointGuize_xiang(h:uint,v:uint):void
		{	
			//不能过半屏						
			//左斜下
			if( (h+2) <= this.H_MAX && (v+2) <= this.V_MAX)
			{														
				//红色可吃棋处理
				if( !hereHasOneQizi(h+2,v+2) )
				{
					//塞象眼处理
					if(!this.saixiangyan_xiang_dir_zuo_xiexia(h,v))
					{					
						this.getRoad(h+2,v+2).visible = true;
					}
				}	
			}	
			
			//右斜下
			if( (h+2) <= this.H_MAX && (v-2) >= this.V_MIN)
			{							
				if( !hereHasOneQizi(h+2,v-2) )
				{
					//塞象眼处理
					if(!this.saixiangyan_xiang_dir_you_xiexia(h,v))
					{			
						this.getRoad(h+2,v-2).visible = true;
					}
				}	
			}
			
			//左斜上
			if( (h-2) > 5 && (v+2) <= this.V_MAX)
			{
				if( !hereHasOneQizi(h-2,v+2) )
				{
					//塞象眼处理
					if(!this.saixiangyan_xiang_dir_zuo_xieshang(h,v))
					{									
						this.getRoad(h-2,v+2).visible = true;
					}								
				}								
			}				
			
			//右斜上
			if( (h-2) > 5 && (v-2) >= this.V_MIN)
			{
				if( !hereHasOneQizi(h-2,v-2) )
				{
					//塞象眼处理
					if(!this.saixiangyan_xiang_dir_you_xieshang(h,v))
					{	
						this.getRoad(h-2,v-2).visible = true;
					}
				}	
			}			
		
		}
//		
//		//左斜上
		private function saixiangyan_xiang_dir_zuo_xieshang(h:uint,v:uint):Boolean
		{
		
			var saixiangyan:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h-1,v+1))
			{
				saixiangyan = true;
				
				return saixiangyan;			
			}
			
			return saixiangyan;
		}	
//		
//		//左斜下
		private function saixiangyan_xiang_dir_zuo_xiexia(h:uint,v:uint):Boolean
		{
		
			var saixiangyan:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h+1,v+1))
			{
				saixiangyan = true;
				
				return saixiangyan;			
			}
			
			return saixiangyan;
		}	
//		
//		//右斜上
		private function saixiangyan_xiang_dir_you_xieshang(h:uint,v:uint):Boolean
		{
		
			var saixiangyan:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h-1,v-1))
			{
				saixiangyan = true;
				
				return saixiangyan;			
			}
			
			return saixiangyan;
		}	
//		
//		//右斜下
		private function saixiangyan_xiang_dir_you_xiexia(h:uint,v:uint):Boolean
		{
		
			var saixiangyan:Boolean = false;
			
			if(this.hereHasOneQizi_pao(h+1,v-1))
			{
				saixiangyan = true;
				
				return saixiangyan;			
			}
			
			return saixiangyan;
		}
//		
		public function movePointGuize_shi(h:uint,v:uint):void
		{			
			
			//
			// a   a
			//   a
			// a  a
			//
			//
			//
									
			//10改3，不能走出九宫			
			if( (h) == this.H_MAX && v == 4)
			{			
				//红色可吃棋处理
				if( !hereHasOneQizi(h-1,v + 1) )
				{
					this.getRoad(h-1,v+1).visible = true;								
				}	
			}
			
			if( (h) == this.H_MAX && v == 6)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h-1,v - 1) )
				{
					this.getRoad(h-1,v-1).visible = true;
				}
			}
						
			if( (h) == (this.H_MAX-1) && v == 5)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h+1,v + 1) )
				{
					this.getRoad(h+1,v+1).visible = true;
				}
							
				//红色可吃棋处理
				if( !hereHasOneQizi(h+1,v - 1) )
				{
					this.getRoad(h+1,v-1).visible = true;
				}
							
				//红色可吃棋处理
				if( !hereHasOneQizi(h-1,v + 1) )
				{
					this.getRoad(h-1,v+1).visible = true;
				}
							
				//红色可吃棋处理
				if( !hereHasOneQizi(h-1,v - 1) )
				{
					this.getRoad(h-1,v-1).visible = true;
				}
			} 						
						
			if( (h) == (this.H_MAX-2) && v == 4)
			{	
				//红色可吃棋处理
				if( !hereHasOneQizi(h+1,v + 1) )
				{					
					this.getRoad(h+1,v+1).visible = true;
				}
			}
						
			if( (h) == (this.H_MAX-2) && v == 6)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h+1,v - 1) )
				{
					this.getRoad(h+1,v-1).visible = true;		
				}				
			}
		
		
		
		}
		
		/**
		 * 
		 */ 
		public function movePointGuize_jiang(h:uint,v:uint):void
		{	
			//loop use
			var i:int = 0;
			
			//九宫
			//以自已为中心，增加一个行
			if( (h-1) > 7 && h <= this.H_MAX && 
			    v >= 4 && v <= 6)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h - 1,v) )
				{
					this.getRoad(h-1,v).visible = true;
				}
			}
			
			if( (h+1) > 7 && (h+1) <= this.H_MAX &&
			    v >= 4 && v <= 6)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h+1,v) )
				{
					this.getRoad(h+1,v).visible = true;
				}
							
			}
						
			if( h > 7 && h <= this.H_MAX &&
			    (v + 1) >=4 && (v + 1) <= 6)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h,v + 1) )
				{
					this.getRoad(h,v+1).visible = true;
				}
			}
						
			if( h > 7 && h <= this.H_MAX &&
			    (v-1) >=4 && (v-1) <= 6)
			{
				//红色可吃棋处理
				if( !hereHasOneQizi(h,v-1) )
				{
					this.getRoad(h,v-1).visible = true;
				}
			}		
			
			//特殊处理
			//老将喝酒
			//方向上
						
			i=0;
			
			for(i=(h-1);i>=this.H_MIN;i--)
			{
				if ( !hereHasOneQizi_jiang(i,v))//执行棋子变色
				{
					//理论可行点
					//this.getRoad(i,v).visible = true;
				}	
				else
				{
					break;
				}	
			}
		
				
		}
		
		//将军区，代码以上面的movePoint为准
		public function movePointGuize_pao_jj(h:uint,v:uint,color:String):Boolean
		{			
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//qizi jump use
			var k:int = 0;
			
			//方向下	
			//可行点
			if(h < this.H_MAX)
			{
				for(i=(h+1);i<=this.H_MAX;i++)
				{
					if ( !hereHasOneQizi_pao(i,v))
					{
						//理论可行点		
						//this.getRoad(i,v).visible = true;	
					}
					else
					{	
						break;
					}					
				}			
			
				//敌方棋子标红
				for(i=(h+1);i<=this.H_MAX;i++)
				{
					if(hereHasOneQizi_pao(i,v))
					{
						k++;
						
						if(k == 2)
						{
							jj = qiziIsJiang(i,v,color);
							break;
						}
					}
				}
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			i = 0;
			j = 0;
			k = 0;
			
			//方向上
			//可行点
			if(h >this.H_MIN)
			{
				for(i=(h-1);i>=this.H_MIN;i--)
				{
					if ( !hereHasOneQizi_pao(i,v))
					{
						//理论可行点		
						//this.getRoad(i,v).visible = true;	
					}
					else
					{
						break;
					}					
				}				
				
				for(i=(h-1);i>=this.H_MIN;i--)
				{
					if(hereHasOneQizi_pao(i,v))
					{
						k++;
						
						if(k == 2)
						{
							jj = qiziIsJiang(i,v,color);
							break;
						}
					}
				}
			}
			
			//return 以免jj被重置
			if(jj){return jj;};	
			
			i = 0;
			j = 0;
			k = 0;
			
			//
			//可行点
			if(v < this.V_MAX)
			{
				for(j=(v+1);j<=this.V_MAX;j++)
				{
					if ( !hereHasOneQizi_pao(h,j))
					{
						//理论可行点		
						//this.getRoad(h,j).visible = true;	
					}
					else
					{
						break;
					}					
				}
				
				for(j=(v+1);j<=this.V_MAX;j++)
				{
					if(hereHasOneQizi_pao(h,j))
					{
						k++;
						
						if(k == 2)
						{
							jj = qiziIsJiang(h,j,color);
							break;
						}
					}
				}
				
				
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			i = 0;
			j = 0;
			k = 0;
			
			if(v > this.V_MIN)
			{
				//可行点
				for(j=(v-1);j>=this.V_MIN;j--)
				{
					if ( !hereHasOneQizi_pao(h,j))
					{
						//理论可行点		
						//this.getRoad(h,j).visible = true;	
					}
					else
					{					
						break;
					}					
				}
				
				for(j=(v-1);j>=this.V_MIN;j--)
				{
					if(hereHasOneQizi_pao(h,j))
					{
						k++;
						
						if(k == 2)
						{
							jj = qiziIsJiang(h,j,color);
							break;
						}
					}
				}
				
				
			}
			
			return jj;
			
						
		}//end func
		
		
		/**
		 * 探测
		 * 使用hereHasOneQizi_pao不用显示路点
		 * 
		 */ 
		public function movePointGuize_bing_jj(h:uint,v:uint,color:String):Boolean
		{			
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//loop use
			var i:int = 0;
			var j:int = 0;		
						
			if(h > 5)
			{				
				if( !hereHasOneQizi_pao(h-1,v) )
				{	
					//this.getRoad(h-1,v).visible = true;
				}
				else
				{							
					jj = qiziIsJiang(h,j,color);
				}	
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			//过河卒
			if(h <= 5)
			{
				//方向左
				if(v > 1)
				{
					for(j=(v-1);j>=(v-1);j--)
					{				
						if( !hereHasOneQizi_pao(h,j) )
						{
							//理论可行点		
							//this.getRoad(h,j).visible = true;
						}
						else
						{
							
							jj = qiziIsJiang(h,j,color);
							break;
						}	
					}
				}
				
				//return 以免jj被重置
				if(jj){return jj;};
				
				//方向上
				if(h > 1)//特殊判断，到顶
				{
					for(i=(h-1);i<=(h-1);i++)
					{
						if ( !hereHasOneQizi_pao(i,v))
						{
							//理论可行点		
							//this.getRoad(i,v).visible = true;		
						}
						else
						{
							jj = qiziIsJiang(i,v,color);
							break;
						}					
					}
				}
				
				//return 以免jj被重置
				if(jj){return jj;};
				
				//方向右	
				if(v < 9)
				{
					for(j=(v+1);j<=(v+1);j++)
					{
						if( !hereHasOneQizi_pao(h,j) )
						{
							//理论可行点
							//this.getRoad(h,j).visible = true;
						}
						else
						{
							jj = qiziIsJiang(h,j,color);
							break;
						}	
					}
				}
				
				//return 以免jj被重置
				if(jj){return jj;};
				
			}//end if	
			
			return jj;					
		}
		
		
		public function movePointGuize_bing_jj_gridReverse(h:uint,v:uint,color:String):Boolean
		{			
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//loop use
			var i:int = 0;
			var j:int = 0;		
						
			if(h < 5)//这里gridReverse
			{				
				if( !hereHasOneQizi_pao(h-1,v) )
				{	
					//this.getRoad(h-1,v).visible = true;
				}
				else
				{							
					jj = qiziIsJiang(h,j,color);
				}	
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			//过河卒
			if(h >= 5)//这里gridReverse
			{
				//方向左
				if(v > 1)
				{
					for(j=(v-1);j>=(v-1);j--)
					{				
						if( !hereHasOneQizi_pao(h,j) )
						{
							//理论可行点		
							//this.getRoad(h,j).visible = true;
						}
						else
						{
							
							jj = qiziIsJiang(h,j,color);
							break;
						}	
					}
				}
				
				//return 以免jj被重置
				if(jj){return jj;};
				
				//方向上
				if(h < 10)//特殊判断，未到顶 //这里gridReverse
				{
					for(i=(h+1);i<=(h+1);i++)
					{
						if ( !hereHasOneQizi_pao(i,v))
						{
							//理论可行点		
							//this.getRoad(i,v).visible = true;		
						}
						else
						{
							jj = qiziIsJiang(i,v,color);
							break;
						}					
					}
				}
				
				//return 以免jj被重置
				if(jj){return jj;};
				
				//方向右	
				if(v < 9)
				{
					for(j=(v+1);j<=(v+1);j++)
					{
						if( !hereHasOneQizi_pao(h,j) )
						{
							//理论可行点
							//this.getRoad(h,j).visible = true;
						}
						else
						{
							jj = qiziIsJiang(h,j,color);
							break;
						}	
					}
				}
				
				//return 以免jj被重置
				if(jj){return jj;};
				
			}//end if	
			
			return jj;					
		}
		
		
		
		public function movePointGuize_ju_jj(h:uint,v:uint,color:String):Boolean
		{			
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//方向下
			for(i=(h+1);i<=this.H_MAX;i++)
			{
				if ( !hereHasOneQizi_pao(i,v))
				{
					//理论可行点		
					//this.getRoad(i,v).visible = true;		
				}
				else
				{
					jj = qiziIsJiang(i,v,color);
					break;
				}					
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			i = 0;
			j = 0;
			
			//方向上
			for(i=(h-1);i>=this.H_MIN;i--)
			{
				if ( !hereHasOneQizi_pao(i,v))
				{
					//理论可行点
					//this.getRoad(i,v).visible = true;
				}	
				else
				{
					jj = qiziIsJiang(i,v,color);
					break;
				}	
			}			
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			i = 0;
			j = 0;
				
			//方向 右	
			for(j=(v-1);j>=this.V_MIN;j--)
			{				
				if( !hereHasOneQizi_pao(h,j) )
				{
					//理论可行点		
					//this.getRoad(h,j).visible = true;			
				}
				else
				{
					jj = qiziIsJiang(h,j,color);
					break;
				}	
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			i = 0;
			j = 0;
			
			//方击左
			for(j=(v+1);j<=this.V_MAX;j++)
			{
				if( !hereHasOneQizi_pao(h,j) )
				{
					//理论可行点		
					//this.getRoad(h,j).visible = true;						
				}
				else
				{
					jj = qiziIsJiang(h,j,color);
					break;
				}	
			}
			
			return jj;
			
		}
		
		public function movePointGuize_ma_jj(h:uint,v:uint,color:String):Boolean
		{			
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//右上					
			if( (h-2) >= this.H_MIN && (h-2) <= this.H_MAX && 
			    (v+1) >= this.V_MIN && (v+1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_shang(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h-2,v+1) )
					{
						
							
					}
					else
					{
						jj = qiziIsJiang(h-2,v+1,color);
					}
					//this.getRoad(h-2,v+1).visible = true;
				}
			}
			
			//return 以免jj被重置
			if(jj){return jj;};		
			
			//左上
			if( (h-2) >= this.H_MIN && (h-2) <= this.H_MAX && 
			    (v-1) >= this.V_MIN && (v-1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_shang(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h-2,v-1) )
					{
						
												
					}
					else
					{
						jj = qiziIsJiang(h-2,v-1,color);
					}
					//this.getRoad(h-2,v-1).visible = true;
				}	
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			//右斜上					
			if( (h-1) >= this.H_MIN && (h-1) <= this.H_MAX && 
			    (v+2)>= this.V_MIN  && (v+2) <= this.V_MAX)
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_xiexia(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h-1,v + 2) )
					{						
							
					}
					else
					{
						jj = qiziIsJiang(h-1,v + 2,color);
					}
					//this.getRoad(h-1,v+2).visible = true;
				}
							
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			//左斜上
			if( (h-1) >= this.H_MIN && (h-1) <= this.H_MAX &&
			    (v-2) >= this.V_MIN && (v-2) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_xieshang(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h-1,v-2) )
					{
						
							
					}
					else
					{
						jj = qiziIsJiang(h-1,v-2,color);
					}		
					//this.getRoad(h-1,v-2).visible = true;	
				}										
			}
			
			//return 以免jj被重置
			if(jj){return jj;};
			
			//右下					
			if( (h+2) >= this.H_MIN && (h+2) <= this.H_MAX && 
			    (v+1) >= this.V_MIN && (v+1) <= this.V_MAX )
			{
				
				//蹩腿处理
				if(!this.pietui_ma_dir_you_xia(h,v))
				{	
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h+2,v + 1) )
					{
										
							
					}
					else
					{
						jj = qiziIsJiang(h+2,v + 1,color);
					}		
					
					//this.getRoad(h+2,v+1).visible = true;
				}
			}
			
			//return 以免jj被重置
			if(jj){return jj;};	
			
			//左下
			if( (h+2) >= this.H_MIN && (h+2) <= this.H_MAX &&
			    (v-1) >= this.V_MIN && (v-1) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_xia(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h+2,v-1) )
					{
						
							
					}
					else
					{
						jj = qiziIsJiang(h+2,v-1,color);
					}
					//this.getRoad(h+2,v-1).visible = true;
				}					
			}
			
			//return 以免jj被重置
			if(jj){return jj;};	
			
			//右斜下
			if( (h + 1) >= this.H_MIN && (h + 1) <= this.H_MAX &&
			    (v + 2) >= this.V_MIN && (v + 2) <= this.V_MAX)
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_you_xiexia(h,v))
				{
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h+1,v + 2) )
					{
						
							
					}
					else
					{
						jj = qiziIsJiang(h+1,v + 2,color);
					}	
					//this.getRoad(h+1,v+2).visible = true;				
				}	
			}
			
			//return 以免jj被重置
			if(jj){return jj;};	
			
			//左斜下
			if(  (h+1) >= this.H_MIN && (h+1) <= this.H_MAX &&
			     (v-2) >= this.V_MIN && (v-2) <= this.V_MAX )
			{
				//蹩腿处理
				if(!this.pietui_ma_dir_zuo_xieshang(h,v))
				{	
					//红色可吃棋处理
					if( !hereHasOneQizi_pao(h+1,v-2) )
					{								
											
							
					}
					else
					{
						jj = qiziIsJiang(h+1,v-2,color);
					}	
					//this.getRoad(h+1,v-2).visible = true;	
				}											
			}			
			
			return jj;
		
		}
		
		/**
		 * 象是不可能吃对方将的,优化
		 * 
		 */ 
		public function movePointGuize_xiang_jj(h:uint,v:uint,color:String):Boolean
		{		
			return false;
		}
		
		/**
		 * 士是不可能吃对方将的,优化
		 * 
		 */ 
		public function movePointGuize_shi_jj(h:uint,v:uint,color:String):Boolean
		{			
			return false;
		}
		
		/**
		 * 特殊情况，老将喝酒
		 * 不过喝了后，是被对方老将将死，谁先喝谁死
		 * 拿车的一部分来用
		 */ 
		public function movePointGuize_jiang_jj(h:uint,v:uint,color:String):Boolean
		{
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//loop use
			var i:int = 0;
			var j:int = 0;			

			//方向上
			for(i=(h-1);i>=this.H_MIN;i--)
			{
				if ( !hereHasOneQizi_pao(i,v))
				{
					//理论可行点
					//this.getRoad(i,v).visible = true;
				}	
				else
				{
					jj = qiziIsJiang(i,v,color);
					break;
				}	
			}
			
			return jj;
		
		}
		
		public function movePointGuize_jiang_jj_gridReverse(h:uint,v:uint,color:String):Boolean
		{
			var jj:Boolean = false;
			
			//将对方的棋子
			if(QiziColor.RED == color)
			{
				color = QiziColor.BLACK;
				
			}else
			{
				color = QiziColor.RED;
			}
			
			//loop use
			var i:int = 0;
			var j:int = 0;
			
			//方向下
			for(i=(h+1);i<=this.H_MAX;i++)
			{
				if ( !hereHasOneQizi_pao(i,v))
				{
					//理论可行点		
					//this.getRoad(i,v).visible = true;		
				}
				else
				{
					jj = qiziIsJiang(i,v,color);
					break;
				}					
			}		
		
			return jj;		
		}		

	}
}