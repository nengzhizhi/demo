package cc.hl.model.video.base {

	public class PartVideoInfo{

		public var rawObject:Object;
		public var index:int;
		public var url:String;
		public var duration:Number;
		public var tryTimes:int;
		public var rate:int;

		public function PartVideoInfo(arg1:Object, arg2:int, arg3:String, arg4:Number, arg5:int=0, arg6:int=0){
			this.rawObject = arg1;
			this.index = arg2;
			this.url = arg3;
			this.duration = arg4;
			this.tryTimes = arg5;
			this.rate = arg6;
		}
	}
}