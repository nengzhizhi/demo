package ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public dynamic class CameraCell extends MovieClip{
		private var _cameraTitle:TextField;
		private var _cameraTitleFormat:TextFormat;
		public var cameraIndex:Number = 1;
		private var _cameraTitleText:String;

		public function CameraCell(t:String,i:Number) {
			super();
			this.cameraIndex = i;
			this._cameraTitleText = t;
			
			this.initCameraCell();
		}

		public function onMouseOver(param:MouseEvent):void{
			this._cameraTitle.borderColor = 0xffffff;
			this._cameraTitleFormat.color = 0xffffff;

			this._cameraTitle.setTextFormat(this._cameraTitleFormat);
			Mouse.cursor = "button";
		}

		public function onMouseOut(param:MouseEvent):void{
			this._cameraTitle.borderColor = 0x999999;
			this._cameraTitleFormat.color = 0x999999;

			this._cameraTitle.setTextFormat(this._cameraTitleFormat);
			Mouse.cursor = "auto";		
		}

		public function initCameraCell(){
			this.initFormat();

			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);

			this._cameraTitle = new TextField();
			this._cameraTitle.text = this._cameraTitleText;
			this._cameraTitle.border = true;
			this._cameraTitle.borderColor = 0x999999;
			this._cameraTitle.autoSize = TextFieldAutoSize.CENTER;

			this._cameraTitle.setTextFormat(this._cameraTitleFormat);
			addChild(this._cameraTitle);
		}

		public function initFormat(){
			if(this._cameraTitleFormat == null){
				this._cameraTitleFormat = new TextFormat();
			}

			this._cameraTitleFormat.size = 12;
			this._cameraTitleFormat.color = 0x999999;
			this._cameraTitleFormat.font = "微软雅黑";
		}

		public function resize(x:Number,y:Number){
			this._cameraTitle.x = 0;
			this._cameraTitle.y = 0;
			this.x = x;
			this.y = y;
		}
	}
}