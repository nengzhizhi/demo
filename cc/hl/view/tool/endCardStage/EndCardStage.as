package cc.hl.view.tool.endCardStage
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;	
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import cc.hl.view.tool.ImageLoader;
	import ui.endCardStageBg;
	import ui.endCardBg;

	public class EndCardStage extends Sprite
	{
		private var _bg:endCardBg;
		private var _avatar:ImageLoader;
		private var _endText:TextField;

		private var _scoreText:TextField;
		private var _nameText:TextField;

/*
		public function EndCardStage(param:Object){
			super();
			
			this._bg = new endCardStageBg();
			addChild(this._bg);

			var _defaultFormat_:TextFormat = new TextFormat("微软雅黑",14,0xFFFFFF,false);
			this._endText = new TextField();
			this._endText.autoSize = TextFieldAutoSize.CENTER;
			this._endText.defaultTextFormat = _defaultFormat_;
			addChild(this._endText);
	
			var _smallFormat_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._scoreText = new TextField();
			this._scoreText.autoSize = TextFieldAutoSize.CENTER;
			this._scoreText.defaultTextFormat = _smallFormat_;
			addChild(this._scoreText);

			this._nameText = new TextField();
			this._nameText.autoSize = TextFieldAutoSize.CENTER;
			this._nameText.defaultTextFormat = _smallFormat_;
			this._nameText.text = param.endCardInfo.actor.name;
			addChild(this._nameText);

			this._avatar = new ImageLoader(64,64,param.endCardInfo.actor.avatar);
			addChild(this._avatar);

			if(param.interaction.card.type == "OneMoreTime"){
				this._endText.htmlText = 
									"恭喜<font color='#FFA609'>" 
									+ param.endCardInfo.actor.name 
									+ "</font>选手获得<font color='#FFA609'>"+param.interaction.card.name 
									+ "</font>的机会";
				this._scoreText.text = param.endCardInfo.actor.cardNumber;
			}
			else if(param.interaction.card.type == "ChangeClothes"){
				this._endText.htmlText = 
									"<font color='#FFA609'>" 
									+ param.endCardInfo.winner 
									+ "</font>用户指定选手<font color='#FFA609'>"
									+ param.endCardInfo.actor.name
									+ "</font>换上<font color='#FFA609'>"
									+ param.endCardInfo.useInfo.name
									+ "</font>";				
			}

			this.resize();
			
			this.show();
		}
*/
		public function EndCardStage(param:Object){
			super();
			this._bg = new endCardBg();

			var _defaultFormat_:TextFormat = new TextFormat("微软雅黑",14,0xFFFFFF,false);
			this._endText = new TextField();
			this._endText.autoSize = TextFieldAutoSize.CENTER;
			this._endText.defaultTextFormat = _defaultFormat_;

			if(param.interaction.card.type == "OneMoreTime"){
				this._avatar = new ImageLoader(64,64,param.endCardInfo.actor.avatar);
				this._endText.htmlText = 
									"<font color='#FFA609'>" 
									+ param.endCardInfo.actor.name 
									+ "</font>获得最多的<font color='#FFA609'>“"+param.interaction.card.name 
									+ "”</font>道具，需要再次展示刚才的表演";
			}
			else if(param.interaction.card.type == "ChangeClothes"){
				this._avatar = new ImageLoader(64,64,param.endCardInfo.actor.avatar);
				this._endText.htmlText = 
									"<font color='#FFA609'>" 
									+ param.endCardInfo.winner 
									+ "</font>用户指定选手<font color='#FFA609'>"
									+ param.endCardInfo.actor.name
									+ "</font>换上<font color='#FFA609'>"
									+ param.endCardInfo.useInfo.name
									+ "</font>";				
			}
			else if(param.interaction.card.type == "ToMyHouse"){
				this._avatar = new ImageLoader(64,64,param.endCardInfo.actor.avatar);
				this._endText.htmlText = 
									"<font color='#FFA609'>" 
									+ param.endCardInfo.winner 
									+ "</font>用户要选手<font color='#FFA609'>"
									+ param.endCardInfo.actor.name
									+ "</font>的礼物";	
			}
			else if(param.interaction.card.type == "Punishment"){
				this._avatar = new ImageLoader(64,64,param.interaction.actors[0].avatar);
				this._endText.htmlText = 
									"<font color='#FFA609'>" 
									+ param.endCardInfo.winner 
									+ "</font>用户要选手<font color='#FFA609'>"
									+ param.interaction.actors[0].name
									+ "</font>惩罚<font color='#FFA609'>"
									+ param.endCardInfo.useInfo.name
									+"</font>项目";				
			}else if(param.interaction.card.type == "SingleReduction"){
				this._avatar = new ImageLoader(64,64,param.interaction.actors[0].avatar);
				this._endText.htmlText = 
									"选手<font color='#FFA609'>"
									+ param.interaction.actors[0].name
									+ "</font>获得<font color='#FFA609'>"
									+ param.endCardInfo.cardNumber.toString()
									+"</font>张降低难度卡";				
			}			
		}


		public function show(){
			_bg.retangleBg.scaleX = 0;
			_bg.circleBg.scaleY = 0;
			addChild(this._bg);

			TweenLite.to(_bg.circleBg,0.5,{
					"scaleX":1,
					"scaleY":1,
					"ease":Cubic.easeIn,
					"onComplete":circleMove
				});

			function circleMove():void{
				TweenLite.to(_bg.circleBg,0.5,{
						"x":_bg.circleBg.x - 255,
						"ease":Cubic.easeIn,
						"onComplete":fillInfo
					});

				TweenLite.to(_bg.retangleBg,0.5,{
						"scaleX":1,
						"ease":Cubic.easeIn
					});
			}
		}

		public function fillInfo(){
			this._bg.circleBg.addChild(this._avatar);
			this._avatar.x = 0 - this._avatar.width/2;
			this._avatar.y = 0 - this._avatar.height/2;

			this._bg.retangleBg.addChild(this._endText);
			this._endText.x = 0 - this._endText.width/2;
			this._endText.y = 0 - this._endText.height/2;
		}

		public function hide(){
			TweenLite.to(_bg.circleBg,0.5,{
					"x":_bg.circleBg.x + 265,
					"ease":Cubic.easeIn,
					"onComplete":circleReduce
				});

			TweenLite.to(_bg.retangleBg,0.5,{
					"scaleX":0,
					"ease":Cubic.easeIn
				});

			function circleReduce():void{
				TweenLite.to(_bg.circleBg,0.5,{
						"scaleX":0,
						"scaleY":0,
						"ease":Cubic.easeIn,
						"onComplete":destruct
					});				
			}
		}

		public function destruct():void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			delete this;
		}



		/*
		public function resize() : void {
			this._endText.x = this._bg.x - this._endText.width/2;
			this._endText.y = this._bg.y - this._endText.height/2;

			this._scoreText.x = this._bg.x - 168 - this._scoreText.width/2;
			this._scoreText.y = this._bg.y - 70;

			this._nameText.x = this._bg.x - 168 - this._nameText.width/2;
			this._nameText.y = this._bg.y + 40;

			this._avatar.x = this._bg.x - 200;
			this._avatar.y = this._bg.y - 32;
		}
		*/
	}
}