package cc.hl.view.tool.useCardStage
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	import util.SkinEvent;
	import cc.hl.view.tool.ImageLoader;
	import ui.actorInfoBg;

	public class ActorInfo extends Sprite
	{
		public var _index:Number;
		private var _state:String;
		private var _bg:actorInfoBg;
		private var _counter;
		private var _avatar:ImageLoader;
		private var _nameText:TextField;
		public var _actorId:String;


		public function ActorInfo(i:Number, actorId:String, counterType:String, actorName:String, avatarUrl:String){
			super();
			this._state = "unselected";

			this._index = i;
			this._actorId = actorId;
			
			this._bg = new actorInfoBg();
			(this._bg as MovieClip).gotoAndStop(2);
			this._avatar = new ImageLoader(64,64,avatarUrl);
			this._bg.addChild(this._avatar);	


			var _defaultFormat_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._nameText = new TextField();
			this._nameText.autoSize = TextFieldAutoSize.CENTER;
			this._nameText.defaultTextFormat = _defaultFormat_;
			this._nameText.text = actorName;
			this._bg.addChild(this._nameText);

			addChild(this._bg);
			this.resize();
		}

		public function updateCardNumber(number:String){
			this._counter.update(number);
		}

		public function resize(){
			this._avatar.x = this._bg.x - 32;
			this._avatar.y = this._bg.y - 32;

			this._nameText.x = this._bg.x - this._nameText.width/2;
			this._nameText.y = this._bg.y + 38;
		}

		private function onMouseOver(param1:MouseEvent):void{
			Mouse.cursor="hand";
			(this._bg as MovieClip).gotoAndStop(2);
		}

		private function onMouseOut(param1:MouseEvent):void{
			Mouse.cursor="arrow";
			if(this._state != "selected"){
				(this._bg as MovieClip).gotoAndStop(1);
			}
		}

		private function onMouseClick(param1:MouseEvent):void{
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_INTERACTIVE_TOOL_THUMBNAIL_SELECTE,this._index));	
		}

		public function select():void{
			this._state = "selected";
		}

		public function unselect():void{
			this._state = "unselected";
			(this._bg as MovieClip).gotoAndStop(1);
		}
	}
}