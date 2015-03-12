package cc.hl.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;

	import flash.display.Sprite;

	import cc.hl.view.video.VideoMediator;
	import cc.hl.view.video.VideoView;	
	import cc.hl.view.play.PlayMediator;
	import cc.hl.view.play.PlayView;
	import cc.hl.view.danmu.CommentMediator;
	import cc.hl.view.danmu.CommentView;

	import cc.hl.view.marquee.MarqueeMediator;
	import cc.hl.view.marquee.MarqueeView;
	
	import cc.hl.view.tool.ToolMediator;
	import cc.hl.view.tool.ToolView;

	import cc.hl.view.demo.DemoMediator;
	import cc.hl.view.demo.DemoView;

	import cc.hl.view.lens.LensMediator;
	import cc.hl.view.lens.LensView;

	import cc.hl.model.net.ClientProxy;
	import cc.hl.model.video.VideoManager;
	import util.*;

	public class StartCommand extends SimpleCommand implements ICommand
	{
		public function StartCommand() {
			super();
		}

		override public function execute(param1:INotification): void {
			VideoManager.instance.init(Param.videos);

			facade.registerMediator(new VideoMediator(new VideoView()));
			facade.registerMediator(new LensMediator(new LensView()));
			facade.registerMediator(new PlayMediator(new PlayView()));
			facade.registerMediator(new CommentMediator(new CommentView));
			facade.registerMediator(new DemoMediator(new DemoView));
			facade.registerMediator(new MarqueeMediator(new MarqueeView));
			facade.registerMediator(new ToolMediator(new ToolView));
			/*
			facade.registerMediator(new CameraMediator(new CameraView()));
			facade.registerMediator(new PlayMediator(new PlayView()));
			facade.registerMediator(new CommentMediator(new CommentView));
			facade.registerMediator(new MarqueeMediator(new MarqueeView));
			facade.registerMediator(new ToolMediator(new ToolView));
			*/
			var mainLayer:WebRoom = param1.getBody() as WebRoom;
			this.initLayer(mainLayer);


			//sendNotification(Order.Video_Show_Request,{"videoIndex":0});
			sendNotification(Order.Lens_Init_Request,Param.videos);
			sendNotification(Order.Play_Show_Request,null);
			sendNotification(Order.Comment_Show_Request,null);
			sendNotification(Order.Demo_Start_Request,null);
			sendNotification(Order.Marquee_Show_Request,null);
			
			
			/*
			sendNotification(Order.Comment_Show_Request,null);
			sendNotification(Order.Video_Load_Request,{"index":0});
			sendNotification(Order.Play_Show_Request,null);
			sendNotification(Order.Marquee_Show_Request,null);
			*/

			
			var clientProxy:ClientProxy = new ClientProxy();
			facade.registerProxy(clientProxy);
			clientProxy.connectServer(Param.wsServerUrl,Param.roomId,Param.cookie);
		}

		private function initLayer(mainLayer:WebRoom) : void {
			var _loc1_:Sprite = new Sprite();
			var _loc2_:Sprite = new Sprite();
			var _loc3_:Sprite = new Sprite();
			var _loc4_:Sprite = new Sprite();
			var _loc5_:Sprite = new Sprite();
			var _loc6_:Sprite = new Sprite();

			GlobalData.VIDEOLAYER = _loc1_;	
			GlobalData.PLAYLAYER = _loc2_;
			GlobalData.COMMENTLAYER = _loc3_;
			GlobalData.MARQUEELAYER = _loc4_;
			GlobalData.LENSLAYER = _loc5_;
			GlobalData.TOOLLAYER = _loc6_;
			/*
			GlobalData.CAMERALAYER = _loc2_;
			GlobalData.PLAYLAYER = _loc3_;
			GlobalData.COMMENTLAYER = _loc4_;
			GlobalData.MARQUEELAYER = _loc5_;
			GlobalData.TOOLLAYER = _loc6_;
			*/

			mainLayer.addChild(_loc1_);
			mainLayer.addChild(_loc2_);
			mainLayer.addChild(_loc3_);
			mainLayer.addChild(_loc4_);
			mainLayer.addChild(_loc5_);
			mainLayer.addChild(_loc6_);
			/*
			mainLayer.addChild(_loc2_);
			mainLayer.addChild(_loc3_);
			mainLayer.addChild(_loc4_);
			mainLayer.addChild(_loc5_);
			mainLayer.addChild(_loc6_);
			*/

		}
	}
}