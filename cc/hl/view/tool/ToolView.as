package cc.hl.view.tool
{
	import flash.display.Sprite;
	import cc.hl.view.tool.buyCardStage.OneCardMultiActor;
	import cc.hl.view.tool.buyCardStage.OneCardNoneActor;
	
	//import cc.hl.view.tool.buyCardStage.ActorInfo;
	//import cc.hl.view.tool.buyCardStage.ScoreProgress;

	import cc.hl.view.tool.useCardStage.MultiActorsMultiTools;
	import cc.hl.view.tool.useCardStage.OneActorMultiTools;
	import cc.hl.view.tool.useCardStage.MultiActorsOneInput;
	import cc.hl.view.tool.useCardStage.Preparation;
	import cc.hl.view.tool.useCardStage.LoseInfo;
	import cc.hl.view.tool.useCardStage.CountdownBar;
	
	import cc.hl.view.tool.endCardStage.EndCardStage;

	import flash.events.TimerEvent;
	import util.*;
	
	public class ToolView extends Sprite
	{
		public var buyCardStage;
		public var useCardStage;
		public var endCardStage;

		public function ToolView() {
			super();
		}

		public function updateCardNumber(param:Object) : void {
			if(this.buyCardStage != null){
				this.buyCardStage.updateCardNumber(param);
			}
		}

		public function showBuyCardStage(param:Object) : void{
			
			if(param.interaction.card.type == "ChangeClothes" 
				||param.interaction.card.type == "Punishment" 
				||param.interaction.card.type == "ToMyHouse" 
				){

				if(this.buyCardStage == null){
					this.buyCardStage = new OneCardNoneActor(param);
					addChild(this.buyCardStage);
					this.resize();
				}
				else if(param.interaction.card.buyCardSecond <= 10 && !this.buyCardStage.isCountdown()){
					this.buyCardStage.setCountdown(10);
					this.buyCardStage.start();
				}
			}
			else if(param.interaction.card.type == "OneMoreTime"
					||param.interaction.card.type == "SingleReduction"
					||param.interaction.card.type == "MultiReduction"){
				if(this.buyCardStage == null){
					this.buyCardStage = new OneCardMultiActor(param);
					addChild(this.buyCardStage);
					this.resize();
					this.buyCardStage.setCountdown(param.interaction.card.buyCardSecond);
					this.buyCardStage.start();
				}
			}
			else if(param.interaction.card.type == "DoubleScore"){
				if(this.buyCardStage == null){
					this.buyCardStage = new OneCardMultiActor(param);
					addChild(this.buyCardStage);
					this.resize();
				}
				else if(param.interaction.card.buyCardSecond <= 10 && !this.buyCardStage.isCountdown()){
					this.buyCardStage.setCountdown(10);
					this.buyCardStage.start();
				}
			}
		}

		public function hideBuyCardStage(param:Object) : void{
			if(this.buyCardStage != null && this.buyCardStage.parent != null){
				this.buyCardStage.parent.removeChild(this.buyCardStage);
			}
			delete[this.buyCardStage];
			this.buyCardStage = null;
		}

		public function showUseCardStage(param:Object) : void {
			this.hideBuyCardStage(param);
			if(this.useCardStage == null){
				if(param.interaction.card.type == "ChangeClothes"){
					if(param.useCardInfo.tools == undefined){
						this.useCardStage = new LoseInfo(param);
						addChild(this.useCardStage);
						this.resize();
					}
					else{
						this.useCardStage = new Preparation("恭喜您，获得指定一名选手变装的权利！");
						addChild(this.useCardStage);
						this.resize();

						this.useCardStage.addEventListener(SkinEvent.SKIN_INTERACTIVE_TOOL_DO_NEXT,function(param2:SkinEvent){									
							if(useCardStage.parent != null){
								useCardStage.parent.removeChild(useCardStage);
							}
							useCardStage.cancelListener();

							useCardStage = new MultiActorsMultiTools(param);
							addChild(useCardStage);
							resize();					
						});
					
					}
				}
				else if(param.interaction.card.type == "Punishment"){
					if(param.useCardInfo.tools == undefined){
						this.useCardStage = new LoseInfo(param);
					}
					else{
						this.useCardStage = new OneActorMultiTools(param);
					}
					addChild(this.useCardStage);
					this.resize();					
				}
				else if(param.interaction.card.type == "ToMyHouse"){
					if(param.useCardInfo == undefined){
						this.useCardStage = new MultiActorsOneInput(param);
					}
					else{
						this.useCardStage = new LoseInfo(param);
					}
					addChild(this.useCardStage);
					this.resize();						
				}
			}
		}

		private function doUseCard(param:Object){
			if(this.useCardStage.parent != null){
				this.useCardStage.parent.removeChild(this.useCardStage);
			}
			this.useCardStage = new MultiActorsMultiTools(param);
			addChild(this.useCardStage);
			this.resize();
		}

		public function hideUseCardStage(param:Object) : void {
			if(this.useCardStage != null && this.useCardStage.parent != null){
				this.useCardStage.parent.removeChild(this.useCardStage);
			}
			delete[this.useCardStage];
			this.useCardStage = null;
		}

		public function showEndCardStage(param:Object) : void {
			this.hideUseCardStage(param);
			if(this.endCardStage == null){
				this.endCardStage = new EndCardStage(param);
				addChild(this.endCardStage);
				this.resize();
				this.endCardStage.show();
			}
		}

		public function hideEndCardStage(param:Object) : void {
			if(this.endCardStage != null && this.endCardStage.parent != null){
				this.endCardStage.hide();
				//this.endCardStage.parent.removeChild(this.endCardStage);
			}
			//delete[this.endCardStage];
			this.endCardStage = null;
		}

		public function resize() : void {
			if(this.buyCardStage != null){
				this.buyCardStage.x = GlobalData.root.stage.stageWidth/2;
				this.buyCardStage.y = GlobalData.root.stage.stageHeight - this.buyCardStage.height/2 - 50;
			}

			if(this.useCardStage != null){
				this.useCardStage.x = GlobalData.root.stage.stageWidth/2;
				this.useCardStage.y = GlobalData.root.stage.stageHeight - this.useCardStage.height/2 - 100;
			}

			if(this.endCardStage != null){
				this.endCardStage.x = GlobalData.root.stage.stageWidth/2;
				this.endCardStage.y = GlobalData.root.stage.stageHeight - this.endCardStage.height/2 - 100;
			}
		}
	}	
}