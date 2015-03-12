package cc.hl.view.tool.useCardStage
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import util.*;	
	import ui.oneActorMultiToolsBg

	public class OneActorMultiTools extends Sprite{
		private var _bg:oneActorMultiToolsBg;
		private var _actor:ActorInfo;
		private var _countdownBar:CountdownBar;
		private var _toolSelected:String;
		private var _actorSelected:String;
		private var _tools:Array;
		private var _interactionId:String;

		public function OneActorMultiTools(param:Object){
			super();

			this._tools = [];
			
			this._interactionId = param.interaction._id;

			this._bg = new oneActorMultiToolsBg();
			this._bg.submit.addEventListener(MouseEvent.CLICK, this.onSubmit);
			addChild(this._bg);

			this._actor = new ActorInfo(
									0, 
									param.interaction.actors[0].actorId,
									null,
									param.interaction.actors[0].name,
									param.interaction.actors[0].avatar
								);
			//this._actor.select();
			addChild(this._actor);

			this._actorSelected = param.interaction.actors[0].actorId;

			this._countdownBar = new CountdownBar(param.interaction.card.useCardSecond);
			addChild(this._countdownBar);

			for(var j:Number = 0;j < param.useCardInfo.tools.length; j++ ){
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

		private function addTool(id:String, title:String, image:String,index:Number){
			var tool = new Thumbnail(id, title, image, 0);
			tool.x = index*90 - 90;
			tool.y = this.y;
			tool.addEventListener(SkinEvent.SKIN_INTERACTIVE_TOOL_THUMBNAIL_SELECTE,this.onToolSelected);
			this._tools.push(tool);
			addChild(tool);
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

		public function resize() : void {
			this._actor.x = this.x - this._bg.width/2;
			this._actor.y = this.y;

			this._countdownBar.x = this.x;
			this._countdownBar.y = this.y + 100;
		}
	}
}