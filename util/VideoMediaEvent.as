package util{
	import flash.events.Event;

	public class VideoMediaEvent extends Event{

		public function VideoMediaEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this.data = param2;
		}

		public static const VIDEO_MEDIA_TIMER:String = "timer";

		public var data;
	}
}