package cc.hl.view.marquee{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class MarqueeMediator extends Mediator implements IMediator{
		public function MarqueeMediator(param:Object){
			super("MarqueeMediator",param);
		}

		public static var NAME:String = "MarqueeMediator";

		override public function listNotificationInterests() : Array {
			return  [
						Order.Marquee_Show_Request,
						Order.Marquee_Add_Request,
						Order.On_Resize
					];
		}

		override public function handleNotification(param1:INotification) : void {
			switch(param1.getName()){
				case Order.Marquee_Show_Request:
					this.onMarqueeShow();
					break;
				case Order.Marquee_Add_Request:
					this.onMarqueeAdd(param1.getBody());
					break;
				case Order.On_Resize:
					this.onResize();
					break;
			}
		}

		protected function onMarqueeShow() : void {
			this.marqueeView.initView();
			if(this.marqueeView.parent == null){
				GlobalData.MARQUEELAYER.addChild(this.marqueeView);
				this.onResize();
			}
		}

		protected function onMarqueeAdd(o:Object) : void {
			var str:String = o.message;
			this.marqueeView.onAddMarquee(str);
		}


		public function onResize() : void {
			if(this.marqueeView.parent != null){
				this.marqueeView.resize(GlobalData.root.stage.stageWidth,GlobalData.root.stage.stageHeight);
			}
			this.marqueeView.y = 0;
		}

		public function get marqueeView() : MarqueeView {
			return viewComponent as MarqueeView;
		}		
	}
}