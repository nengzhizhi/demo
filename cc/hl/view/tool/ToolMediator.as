package cc.hl.view.tool
{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;	


	public class ToolMediator extends Mediator implements IMediator{
		public function ToolMediator(o:Object){
			super("ToolMediator",o);
		}

		override public function listNotificationInterests() : Array {
			return [
					Order.Tool_Show_Request,
					Order.Tool_UpdateCardNumber_Request,
					Order.Tool_ShowBuyCard_Request,
					Order.Tool_ShowUseCard_Request,
					Order.Tool_ShowEndCard_Request,
					Order.Tool_HideBuyCard_Request,
					Order.Tool_HideUseCard_Request,
					Order.Tool_HideEndCard_Request,
					Order.On_Resize
				];
		}

		override public function handleNotification(n:INotification) : void {
			switch(n.getName())
			{
				case Order.Tool_Show_Request:
					this.onToolShow();
					break;
				case Order.Tool_UpdateCardNumber_Request:
					this.onUpdateCardNumber(n.getBody());
					break;
				case Order.Tool_ShowBuyCard_Request:
					this.onShowBuyCard(n.getBody());
					break;
				case Order.Tool_ShowUseCard_Request:
					this.onShowUseCard(n.getBody());
					break;					
				case Order.Tool_ShowEndCard_Request:
					this.onShowEndCard(n.getBody());
					break;
				case Order.Tool_HideBuyCard_Request:
					this.onHideBuyCard(n.getBody());
					break;
				case Order.Tool_HideUseCard_Request:
					this.onHideUseCard(n.getBody());
					break;
				case Order.Tool_HideEndCard_Request:
					this.onHideEndCard(n.getBody());
					break;										

				case Order.On_Resize:
					this.onResize();
					break;
			}
		}

		protected function onUpdateCardNumber(param:Object) : void {
			this.toolView.updateCardNumber(param);
		}

		protected function onShowEndCard(param:Object) : void {
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}

			this.toolView.showEndCardStage(param);			
		}

		protected function onShowBuyCard(param:Object) : void {
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}

			this.toolView.showBuyCardStage(param);
		}
		
		protected function onShowUseCard(param:Object) : void {
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}			
			this.toolView.showUseCardStage(param);
		}

		protected function onHideBuyCard(param:Object) : void {	
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}

			this.toolView.hideBuyCardStage(param);
		}

		protected function onHideUseCard(param:Object) : void {		
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}

			this.toolView.hideUseCardStage(param);
		}

		protected function onHideEndCard(param:Object) : void {		
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}

			this.toolView.hideEndCardStage(param);
		}				


		protected function onToolShow() :void{
			if(this.toolView.parent == null){
				GlobalData.TOOLLAYER.addChild(this.toolView);
			}
			//this.toolView.initView();
		}

		protected function onResize() : void {
			this.toolView.resize();
		}

		public function get toolView() : ToolView {
			return viewComponent as ToolView;
		}			
	}
}

