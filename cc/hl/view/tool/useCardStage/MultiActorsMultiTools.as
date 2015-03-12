package cc.hl.view.tool.useCardStage{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import util.*;

	import ui.multiActorsMultiToolsBg;


	public class MultiActorsMultiTools extends Sprite{
		private var _interactionId:String;

		private var _bg:multiActorsMultiToolsBg;
		private var _actors:Array;
		private var _tools:Array;
		private var _actorSelected:String;
		private var _toolSelected:String;
		private var _countdownBar:CountdownBar;

		public function MultiActorsMultiTools(param:Object){
			super();

			this._interactionId = param.interaction._id;

			this._bg = new multiActorsMultiToolsBg();
			this._bg.submit.addEventListener(MouseEvent.CLICK, this.onSubmit);
			addChild(this._bg);

			this._actors = [];
			this._tools = [];
			this._actorSelected = null;
			this._toolSelected = null;//此处改成随机

			if(param.interaction.card.useCardSecond > 3){
				this._countdownBar = new CountdownBar(param.interaction.card.useCardSecond - 3);
			}
			else{
				this._countdownBar = new CountdownBar(param.interaction.card.useCardSecond);
			}
			addChild(this._countdownBar);

			for(var i:Number = 0; i<param.interaction.actors.length; i++){
				addActor(
					param.interaction.actors[i].actorId, 
					param.interaction.actors[i].name, 
					param.interaction.actors[i].avatar, 
					i
				);
			}
			
			for(var j:Number = 0; j<param.useCardInfo.tools.length; j++){
				addTool(
					param.useCardInfo.tools[j].id, 
					param.useCardInfo.tools[j].name, 
					param.useCardInfo.tools[j].image, 
					j
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

		private function addTool(id:String, title:String, image:String,index:Number){
			var tool = new Thumbnail(id, title, image, 0);
			tool.x = index*90 - 140;
			tool.y = this.y + 60;
			tool.addEventListener(SkinEvent.SKIN_INTERACTIVE_TOOL_THUMBNAIL_SELECTE,this.onToolSelected);
			this._tools.push(tool);
			addChild(tool);
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

		private function onToolSelected(param:SkinEvent):void{
			this._toolSelected = param.data;

			for(var i:int = 0; i< this._tools.length; i++){
				if(this._toolSelected != this._tools[i].getId()){
					this._tools[i].unselect();
				}
				else{
					this._tools[i].select();
				}
			}
		}

		private function onSubmit(param:MouseEvent){
			$.jscall("console.log",this._actorSelected);
			$.jscall("console.log",this._toolSelected);

			$.jscall(
				"js_interaction_useCard", 
				this._interactionId, 
				this._actorSelected, 
				this._toolSelected
			);
		}

		public function resize(){
			this._countdownBar.x = this.x;
			this._countdownBar.y = this.y + 130;
		}
	}
}