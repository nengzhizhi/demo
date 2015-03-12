package cc.hl.view.tool.useCardStage{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import util.*;

	import ui.multiActorsOneInputBg;

	public class MultiActorsOneInput extends Sprite{
		private var _interactionId:String;

		private var _bg:multiActorsOneInputBg;
		private var _actors:Array;
		private var _actorSelected:String;
		private var _countdownBar:CountdownBar;

		public function MultiActorsOneInput(param:Object){
			super();

			this._interactionId = param.interaction._id;

			this._bg = new multiActorsOneInputBg();
			this._bg.submit.addEventListener(MouseEvent.CLICK, this.onSubmit);
			addChild(this._bg);

			this._actors = [];
			this._actorSelected = null;

			this._countdownBar = new CountdownBar(param.interaction.card.useCardSecond);
			addChild(this._countdownBar);

			for(var i:Number = 0; i<param.interaction.actors.length; i++){
				addActor(
					param.interaction.actors[i].actorId, 
					param.interaction.actors[i].name, 
					param.interaction.actors[i].avatar, 
					i
				);
			}

			this.resize();
			this._countdownBar.start();				
		}
		private function addActor(id:String, title:String, avatar:String, index:Number){
			var actor = new Thumbnail(id, title, avatar, index);
			actor.x = index*90 - 140;
			actor.y = this.y - 60;
			actor.addEventListener(SkinEvent.SKIN_INTERACTIVE_TOOL_THUMBNAIL_SELECTE,this.onActorSelected);
			this._actors.push(actor);
			addChild(actor);
		}

		private function onActorSelected(param:SkinEvent):void{
			this._actorSelected = param.data;

			for(var i:int = 0; i< this._actors.length; i++){
				if(this._actorSelected != this._actors[i].getId()){
					this._actors[i].unselect();
				}
				else{
					this._actors[i].select();
				}
			}
		}

		private function onSubmit(param:MouseEvent){			
			$.jscall(
				"js_interaction_useCard", 
				this._interactionId, 
				this._actorSelected, 
				this._bg.mobileNumber.text
			);
		}

		public function resize(){
			this._countdownBar.x = this.x;
			this._countdownBar.y = this.y + 130;
		}	

	}


}