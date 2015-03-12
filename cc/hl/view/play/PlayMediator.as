package cc.hl.view.play{
	import flash.display.StageDisplayState;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import util.*;

	public class PlayMediator extends Mediator implements IMediator{
		public function PlayMediator(param:Object){
			super("PlayMediator",param);
		}

		override public function listNotificationInterests() : Array {
			return [
						Order.Play_Show_Request,
						Order.Play_PlayedSecond_Request,
						Order.Play_VideoLength_Request,
						Order.On_Resize
					];
		}

		override public function handleNotification(param1:INotification) : void {
			switch(param1.getName()){
				case Order.Play_Show_Request:
					this.onPlayShow();
					break;
				case Order.Play_PlayedSecond_Request:
					this.onPlayedSecond(param1.getBody());
					break;
				case Order.Play_VideoLength_Request:
					this.onVideoLength(param1.getBody());
					break;
				case Order.On_Resize:
					this.onResize();
					break;
			}
		}

		public function addListener() : void{
			if(!this.playView.hasEventListener(SkinEvent.SKIN_FULLSCREEN)){

				this.playView.addEventListener(SkinEvent.SKIN_PLAY,this.onPlay);
				this.playView.addEventListener(SkinEvent.SKIN_PAUSE,this.onPause);
				this.playView.addEventListener(SkinEvent.SKIN_RELOAD,this.onReload);
				this.playView.addEventListener(SkinEvent.SKIN_SILENT,this.onSilent);
				this.playView.addEventListener(SkinEvent.SKIN_SILENT_CANCEL,this.onSilentCancel);
				this.playView.addEventListener(SkinEvent.SKIN_FULLSCREEN,this.onFullScreen);
				this.playView.addEventListener(SkinEvent.SKIN_NORMALSCREEN,this.onNormalScreen);
				this.playView.addEventListener(SkinEvent.SKIN_VOLUME_CHANGE,this.onVolumeChange);
				this.playView.addEventListener(SkinEvent.SKIN_DANMU_HIDE,this.onDanmuHide);
				this.playView.addEventListener(SkinEvent.SKIN_DANMU_SHOW,this.onDanmuShow);
				this.playView._progressBar.addEventListener(SkinEvent.SKIN_PROGRESS_ADJUST_COMPLETE,this.onProgressAdjustComplete);
			}
		}

		protected function onPlayShow() : void {
			this.playView.initView();
			this.addListener();
			if(this.playView.parent == null){
				GlobalData.PLAYLAYER.addChild(this.playView);
			}
			this.playView.resize(GlobalData.root.stage.stageWidth,GlobalData.root.stage.stageHeight);
			this.playView.y = GlobalData.root.stage.stageHeight - PlayView.SKIN_HEIGHT;
		}

		protected function onPlay(param1:SkinEvent) : void {
			sendNotification(Order.Video_Play_Request,null);
		}

		protected function onPause(param1:SkinEvent) : void{
			sendNotification(Order.Video_Pause_Request,null);
		}

		protected function onReload(param1:SkinEvent) : void {
			sendNotification(Order.Video_Reload_Request,null);
		}

		protected function onSilent(param1:SkinEvent) : void {
			this.playView.volume = 0;
		}

		protected function onSilentCancel(param1:SkinEvent) : void {
			this.playView.volume = 0.5;
		}

		protected function onVolumeChange(param1:SkinEvent) : void {
			sendNotification(Order.Video_VolumeChange_Request,{"size":param1.data});
		}

		protected function onDanmuShow(param1:SkinEvent) : void {
			sendNotification(Order.Comment_OpenHide_Request,{"status":param1.data});
		}

		protected function onDanmuHide(param1:SkinEvent) : void {
			sendNotification(Order.Comment_OpenHide_Request,{"status":param1.data});
		}

		protected function onFullScreen(param1:SkinEvent) : void {
			GlobalData.root.stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		protected function onNormalScreen(param1:SkinEvent) : void {
			GlobalData.root.stage.displayState = StageDisplayState.NORMAL;
		}

		protected function onProgressAdjustComplete(e:SkinEvent):void{
			var seekTime:Number = this.playView._progressBar.position * this.playView._totalLength;
			sendNotification(Order.Video_Seek_Request, {"seekTime":seekTime});
		}

		protected function onPlayedSecond(o:Object):void{
			var playedSecond:Number = o.playedSecond;
			this.playView._progressBar.position = playedSecond / this.playView._totalLength;
			this.playView._controlBar.timer.now.text = Util.digits(playedSecond);
		}

		protected function onVideoLength(o:Object):void{
			var videoLength:Number = o.videoLength;
			if(this.playView._totalLength != videoLength){
				this.playView._totalLength = videoLength;
				this.playView._progressBar.totalTime = videoLength;
				this.playView._controlBar.timer.total.text = ("/ " + Util.digits(videoLength));
			}
		}

		public function onResize() : void {
			if(this.playView.parent != null){
				this.playView.resize(GlobalData.root.stage.stageWidth,GlobalData.root.stage.stageHeight);
			}
			this.playView.y = GlobalData.root.stage.stageHeight - PlayView.SKIN_HEIGHT;
		}

		public function get playView() : PlayView {
			return viewComponent as PlayView;
		}
	}
}