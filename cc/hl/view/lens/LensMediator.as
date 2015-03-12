package cc.hl.view.lens{
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	import util.*;

	public class LensMediator extends Mediator implements IMediator{
		public function LensMediator(o:Object){
			super("LensMediator", o);
		}

		override public function listNotificationInterests() : Array {
			return [
						Order.Lens_Init_Request,
						Order.On_Resize
					];
		}

		override public function handleNotification(n:INotification) : void {
			switch(n.getName())
			{
				case Order.Lens_Init_Request:
					this.onLensInit(n.getBody());
					break;
				case Order.On_Resize:
					this.onResize();
					break;					
			}
		}

		protected function onLensInit(o:Object):void{
			if(this.lensView.parent == null){
				GlobalData.LENSLAYER.addChild(this.lensView);
				this.lensView.x = GlobalData.root.stage.stageWidth - 100;
				this.lensView.y = 100;
			}
			this.lensView.lensInit(o);
			this.addListener();
		}

		protected function onResize() : void {
			this.lensView.resize(GlobalData.root.stage.stageWidth,GlobalData.root.stage.stageHeight);
		}

		private function addListener() : void{
			if(!this.lensView.hasEventListener(SkinEvent.SKIN_LENS_CLICKED)){
				this.lensView.addEventListener(SkinEvent.SKIN_LENS_CLICKED, this.onLensClicked);
			}
		}


		private function onLensClicked(e:SkinEvent) : void{
			var videoIndex:int = e.data;
			sendNotification(Order.Video_Show_Request,{"videoIndex":videoIndex});
		}

		public function get lensView() : LensView {
			return viewComponent as LensView;
		}			
	}	
}