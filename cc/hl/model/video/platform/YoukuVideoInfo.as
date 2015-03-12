package cc.hl.model.video.platform {
	import cc.hl.model.video.base.*;

	public class YoukuVideoInfo extends VideoInfo {

		public function YoukuVideoInfo(_arg1:String=null){
			super(_arg1, VideoType.YOUKU);

			//使用时间定位
			_useSecond = true;
		}
	}
}