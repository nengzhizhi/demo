package cc.hl.view.tool.buyCardStage{

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	import flash.external.ExternalInterface;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.display.SimpleButton;
	import util.*;

	import cc.hl.view.tool.ImageLoader;
	import ui.noneActorCardBg;
	import ui.OneMoreTimeCard;
	import ui.ChangeClothesCard;
	import ui.DoubleScoreCard;
	import ui.ToMyHouseCard;
	import ui.ReductionCard;
	import ui.PunishmentCard;

	public class OneCardNoneActor extends Sprite implements IBuyCard{

		private var _bg:noneActorCardBg;
		private var _cardImage:ImageLoader;
		private var _countdownClock:CountdownClock;
		private var _boughtNumText:TextField;
		private var _cardNameText:TextField;
		private var _cardPriceText:TextField;
		private var _cardDescText:TextField;

		private var _interactionId:String;
		private var _card;


		public function OneCardNoneActor(param:Object){
			super();

			//GlobalData.sentCardCount = 0;
			this._interactionId = param.interaction._id;

			this._bg = new noneActorCardBg();
			addChild(this._bg);

			/*
			this._cardImage = new ImageLoader(75, 100, param.interaction.card.image);
			this._cardImage.addEventListener(MouseEvent.CLICK, this.onCardClicked);
			this._cardImage.addEventListener(MouseEvent.MOUSE_OVER, this.onCardOverred);
			this._cardImage.addEventListener(MouseEvent.MOUSE_OUT, this.onCardOutted);	
			addChild(this._cardImage);
			*/

			if(param.interaction.card.type=="OneMoreTime"){
				this._card = new OneMoreTimeCard();
			}else if(param.interaction.card.type=="ChangeClothes"){
				this._card = new ChangeClothesCard();
			}else if(param.interaction.card.type=="DoubleScore"){
				this._card = new DoubleScoreCard();
			}else if(param.interaction.card.type=="ToMyHouse"){
				this._card = new ToMyHouseCard();
			}else if(param.interaction.card.type=="SingleReduction"){
				this._card = new ReductionCard();
			}else if(param.interaction.card.type=="MultiReduction"){
				this._card = new ReductionCard();
			}else if(param.interaction.card.type=="Punishment"){
				this._card = new PunishmentCard();
			}
			addChild(this._card);

			this._card.addEventListener(MouseEvent.CLICK, this.onCardClicked);

			var _loc1_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._boughtNumText = new TextField();
			this._boughtNumText.defaultTextFormat = _loc1_;
			this._boughtNumText.htmlText = "我已送出"+"<font color='#FFA609'>0</font>"+"张";
			this.addChild(this._boughtNumText);

			this._cardNameText = new TextField();
			this._cardNameText.defaultTextFormat = _loc1_;
			this._cardNameText.text = param.interaction.card.name;
			this.addChild(this._cardNameText);

			this._cardPriceText = new TextField();
			this._cardPriceText.defaultTextFormat = _loc1_;
			this._cardPriceText.htmlText = "<font color='#FFA609'>" + param.interaction.card.price + "G</font>" +"/张";
			this.addChild(this._cardPriceText);

			var _loc2_:TextFormat = new TextFormat("微软雅黑",12,0xFFA609,false);
			this._cardDescText = new TextField();
			this._cardDescText.width = 130;
			this._cardDescText.wordWrap = true;
			this._cardDescText.defaultTextFormat = _loc2_;
			this._cardDescText.text = param.interaction.card.description;
			this.addChild(this._cardDescText);			

			this.addJsCallback();

			this.resize();
		}

		public function setCountdown(second:Number){
			this._countdownClock = new CountdownClock(second);
			addChild(this._countdownClock);
		}

		public function isCountdown(){
			return this._countdownClock != null;
		}

		public function resize(){
			this._boughtNumText.x = this.x - this._boughtNumText.textWidth/2;
			this._boughtNumText.y = this.y + 82;


			this._cardPriceText.x = this.x - 140;
			this._cardPriceText.y = this.y - 50;

			this._cardNameText.x = this.x - 220;
			this._cardNameText.y = this.y - 50;

			this._cardDescText.x = this.x - 220;
			this._cardDescText.y = this.y - 30;

			if(this._cardImage != null){
				this._cardImage.x = this.x - 37.5;
				this._cardImage.y = this.y - 50;
			}
		}

		private function onCardClicked(param:MouseEvent){
			$.jscall("js_interaction_buyCard", this._interactionId, null);
		}

		private function onCardOverred(param:MouseEvent){
			Mouse.cursor="hand";
		}

		private function onCardOutted(param:MouseEvent){
			Mouse.cursor="arrow";
		}

		private function addJsCallback() : void {
			if(ExternalInterface.available){
				ExternalInterface.addCallback("as_interaction_updateScore",this.updateCardNumber);
			}
		}

		//公共接口
		public function updateCardNumber(snapshot:Object):void{
			if(snapshot.sentCardCount != null && snapshot.sentCardCount != "null"){
				//GlobalData.sentCardCount = snapshot.sentCardCount;
				this._boughtNumText.htmlText = "我已送出"+"<font color='#FFA609'>" + snapshot.sentCardCount + "</font>"+"张";
			}
		}

		//公共接口
		public function start():void{
			if(this._countdownClock != null){
				this._countdownClock.start();
			}
		}
	}
}