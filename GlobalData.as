package
{
	import flash.display.Sprite;

	public class GlobalData extends Object
	{
		public function GlobalData() {
			super();
		}

		public static var VIDEOLAYER:Sprite;
		public static var LOADLAYER:Sprite;
		public static var PLAYLAYER:Sprite;
		public static var COMMENTLAYER:Sprite;
		public static var MARQUEELAYER:Sprite;
		public static var TOOLLAYER:Sprite;
		public static var LENSLAYER:Sprite;

		public static var root:WebRoom;

		public static var offsetUpHeight:int = 20;
		public static var offsetDownHeight:int = 0;
		public static var textAlphaValue:Number = 0.85;
		public static var textSizeValue:Number = 14;

		public static var MAX_USE_MEMORY_ARRAY:Array = [104857600, 209715200, 0x19000000, int.MAX_VALUE];

		//public static var sentCardCount:Number = 0;
	}
}