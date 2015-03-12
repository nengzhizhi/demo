package cc.hl.view.video
{
	import flash.display.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.events.*;
	import cc.hl.model.video.VideoManager;
	import util.VideoMediaEvent;
	import util.SkinEvent;
	
	public class VideoView extends Sprite {
		public function VideoView(){}

		public function showVideo(index:int = 0){
			if(index < 0 || currentVideoInx == index){
				return;
			}

			var currentVideoInx = VideoManager.instance.currentVideoInx;

			if(VideoManager.instance.video(currentVideoInx).parent != null ){
				VideoManager.instance.video(currentVideoInx).volume = 0;
				VideoManager.instance.video(currentVideoInx).parent.removeChild(VideoManager.instance.video(currentVideoInx));
			}

			VideoManager.instance.video(index).volume = 100;
			VideoManager.instance.video(index).setVideoRatio(2);
			VideoManager.instance.video(index).resize(GlobalData.root.stage.stageWidth, GlobalData.root.stage.stageHeight);
			addChild(VideoManager.instance.video(index));
		}

		public function seekTime(timeToSeek:Number){
			for(var i:int = 0;i < VideoManager.instance._videoCount;i++){
				VideoManager.instance.video(i).time = timeToSeek;
			}
		}
	}
}