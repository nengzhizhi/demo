package
{
	public class Param extends Object
	{
		/*
		public class CameraParam extends Object{
			public function CameraParam() {
				super();
			}

			public var Url:String;
			public var LiveId:String;
			public var cTitle:String;
		}
		*/

		public function Param() {
			super();
		}

		public static var clock:Number = 100;

		public static var videos:Object;

		public static var wsServerUrl:String;
		public static var roomId:String;
		public static var cookie:String;
		public static var sponsorStr:String;

		public static var isLive:Boolean = false;


		public static var isLoadByWeb:Boolean = false;

		public static function init(o:Object) : void {
			if(o["wsUrl"]!=undefined){
				isLoadByWeb = true;

				wsServerUrl = o["wsUrl"];
				roomId = o["roomId"];
				cookie = o["cookie"];
			}
		}
	}
}