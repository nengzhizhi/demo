package cc.hl.view.tool.useCardStage{

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;	
	import util.*;

	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import cc.hl.view.tool.ImageLoader;
	import ui.thumbnailBg;

	public class Thumbnail extends Sprite{
		private var _bg:thumbnailBg;
		private var _titleText:TextField;
		private var _delay:Number;
		private var _id:String;
		private var _state:String;

		public function Thumbnail(id:String, title:String, url:String, delay:Number){
			super();

			this._id = id;
			this._delay = delay;
			this._state = "unselected";

			this._bg = new thumbnailBg();
			(this._bg as MovieClip).gotoAndStop(1);
			addChild(this._bg);

			var _loc1_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._titleText = new TextField();
			this._titleText.autoSize = TextFieldAutoSize.CENTER;
			this._titleText.defaultTextFormat = _loc1_;
			this._titleText.text = title;
			this.addChild(this._titleText);

			var loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
			loader.load(new URLRequest(url));

			this.resize();
		}


		private function completeHandler(e:Event):void{
			var loader:Loader = Loader(e.target.loader);
			var bitmap = Bitmap(loader.content);
			
            bitmap.x = -32;
            bitmap.y = -32;
            bitmap.scaleX = 0.5;
            bitmap.scaleY = 0.5;
		
            addChild(bitmap);

			var onComplete:Function = function():void {
				addEventListener(MouseEvent.MOUSE_OVER, onThumbnailOverred);
				addEventListener(MouseEvent.MOUSE_OUT, onThumbnailOutted);
				addEventListener(MouseEvent.CLICK, onThumbnailClicked);
			}

            TweenLite.to(bitmap,this._delay*0.5,{
				"scaleX":1,
				"scaleY":1,
				"alpha":1,
				"ease":Cubic.easeIn,
				"onComplete":onComplete
			});
		}

		private function onThumbnailOverred(param:MouseEvent){
			Mouse.cursor="hand";
			(this._bg as MovieClip).gotoAndStop(2);
		}

		private function onThumbnailOutted(param:MouseEvent){
			Mouse.cursor="arrow";
			if(this._state != "selected"){
				(this._bg as MovieClip).gotoAndStop(1);
			}
		}

		private function onThumbnailClicked(param:MouseEvent){
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_INTERACTIVE_TOOL_THUMBNAIL_SELECTE,this._id));
		}

		public function getId(){
			return _id;
		}

		public function unselect():void{
			this._state = "unselected";
			(this._bg as MovieClip).gotoAndStop(1);
		}

		public function select():void{
			this._state = "selected";
			(this._bg as MovieClip).gotoAndStop(2);
		}

		public function resize(){
			this._titleText.x = this.x - this._titleText.width/2;
			this._titleText.y = this.y + 32;
		}
	}
}