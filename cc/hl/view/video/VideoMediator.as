package cc.hl.view.video{

	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;
	import cc.hl.model.video.*;
	import util.*;


	public class VideoMediator extends Mediator implements IMediator{
		public function VideoMediator(o:Object){
			super("VideoMediator", o);
		}

		override public function listNotificationInterests() : Array {
			return [
					Order.Video_Show_Request,
					Order.Video_Seek_Request,
					Order.Video_Pause_Request,
					Order.Video_Play_Request,
					Order.Video_VolumeChange_Request,
					Order.On_Resize
				];
		}

		override public function handleNotification(n:INotification) : void{
			switch (n.getName()){
				case Order.Video_Show_Request:
					this.onShowVideo(n.getBody());
					break;
				case Order.Video_Seek_Request:
					this.onSeekVideo(n.getBody());
					break;
				case Order.Video_Pause_Request:
					this.onPause();
					break;
				case Order.Video_Play_Request:
					this.onPlay();
					break;
				case Order.Video_VolumeChange_Request:
					this.onVolumeChange(n.getBody());
					break;
				case Order.On_Resize:
					this.onResize();
					break;
			}
		}

		protected function onShowVideo(o:Object) : void {
			if(this.videoView.parent == null){
				GlobalData.VIDEOLAYER.addChild(this.videoView);
			}
			var index:int = o.videoIndex;

			this.videoView.showVideo(index);
		}

		protected function onSeekVideo(o:Object) : void{
			var seekTime:Number = o.seekTime;
			this.videoView.seekTime(seekTime);
		}

		protected function onPause():void{
			VideoManager.instance.playing = false;
		}

		protected function onPlay():void{
			VideoManager.instance.playing = true;
		}

		protected function onVolumeChange(o:Object) : void {
			var v:Number = o.size;
			VideoManager.instance.currentVideo.volume = v * 100;
		}


		protected function onResize():void{
			VideoManager.instance.currentVideo.resize(GlobalData.root.stage.stageWidth,GlobalData.root.stage.stageHeight);
		}

		public function get videoView() : VideoView {
			return viewComponent as VideoView;
		}			
	}
}