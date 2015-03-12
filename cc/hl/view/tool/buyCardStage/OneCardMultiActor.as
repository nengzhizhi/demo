package cc.hl.view.tool.buyCardStage{

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	import flash.external.ExternalInterface;
	import util.*;

	import cc.hl.view.tool.ImageLoader;
	import ui.withActorCardBg;
	import ui.OneMoreTimeCard;
	import ui.ChangeClothesCard;
	import ui.DoubleScoreCard;
	import ui.ToMyHouseCard;
	import ui.ReductionCard;
	import ui.PunishmentCard;

	public class OneCardMultiActor extends Sprite implements IBuyCard{

		private var _bg:withActorCardBg;

		private var _cardPriceText:TextField;
		private var _boughtNumText:TextField;
		private var _interactionId:String;
		private var _card;


		private var _countdownClock:CountdownClock;
		private var _actorInfos:Array;
		private var _actorSelected;

		public function OneCardMultiActor(param:Object){
			super();
			

			this._actorSelected = null;
			this._interactionId = param.interaction._id;

			this._bg = new withActorCardBg();
			addChild(this._bg);

			this._actorInfos = [];
			var actors = param.interaction.actors as Array;
			for(var i:int=0;i<actors.length;i++){
				var actorinfo:ActorInfo = new ActorInfo(i, actors[i].actorId, param.interaction.card.counterType, actors[i].name, actors[i].avatar);
				if(actors.length==1){
					this._actorSelected = i;
					actorinfo.select();
				}
				this.addActorInfo(actorinfo);
			}

			var _loc1_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._cardPriceText = new TextField();
			this._cardPriceText.defaultTextFormat = _loc1_;
			this._cardPriceText.htmlText = "<font color='#FFA609'>"+param.interaction.card.price+"G</font>"+"/张";
			this.addChild(this._cardPriceText);

			this._boughtNumText = new TextField();
			this._boughtNumText.defaultTextFormat = _loc1_;
			this._boughtNumText.htmlText = "我已送出"+"<font color='#FFA609'>0</font>"+"张";
			this.addChild(this._boughtNumText);

			
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

			this.addJsCallback();

			this.resize();
			
		}

		public function setCountdown(second:Number){
			this._countdownClock = new CountdownClock(second);
			this._countdownClock.x = this._bg.x;
			this._countdownClock.y = this._bg.y;
			addChild(this._countdownClock);

		}

		public function isCountdown(){
			return this._countdownClock != null;
		}

		private function addActorInfo(actorInfo:ActorInfo){
			actorInfo.addEventListener(SkinEvent.SKIN_INTERACTIVE_TOOL_ACTOR_SELECTE,this.onActorSelected);
			this._actorInfos.push(actorInfo);
			this.addChild(actorInfo);
		}


		private function onActorSelected(param1:SkinEvent){
			this._actorSelected = param1.data;

			for(var i:int=0;i<this._actorInfos.length;i++){
				if(i != this._actorSelected){
					this._actorInfos[i].unselect();
				}
				else{
					this._actorInfos[i].select();
				}
			}
		}

		public function resize(){
			var width:Number = this._bg.width + this._actorInfos.length*90;
			this._bg.x = width/2 - this._bg.width + 75;

			for(var i:int=this._actorInfos.length-1;i>=0;i--){
				this._actorInfos[i].x = this._bg.x - i*90 - this._bg.width/2;
				this._actorInfos[i].resize();
			}

			this._cardPriceText.x = this._bg.x + 90;
			this._cardPriceText.y = this._bg.y - 25;
			this._boughtNumText.x = this._bg.x + 90;
			this._boughtNumText.y = this._bg.y + 5;

			this._card.x = this._bg.x;
			this._card.y = this._bg.y;

			if(this._countdownClock != null){
				this._countdownClock.x = this._bg.x;
				this._countdownClock.y = this._bg.y;
				this._countdownClock.resize();
			}		
		}

		private function onCardClicked(param:MouseEvent){
			if(this._actorInfos[this._actorSelected] != null){
				$.jscall("js_interaction_buyCard", this._interactionId, this._actorInfos[this._actorSelected]._actorId);
			}
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
				this._boughtNumText.htmlText = "我已送出"+"<font color='#FFA609'>" + snapshot.sentCardCount + "</font>"+"张";
			}
			var actors = snapshot.actors as Array;
			for(var i:int = 0 ; i < actors.length ; i++){
				for(var j:int = 0; j< this._actorInfos.length; j++){
					if(actors[i].actorId == this._actorInfos[j]._actorId){
						this._actorInfos[j].updateCardNumber(actors[i].cardNumber);
					}
				}
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