package cc.hl.view.tool.buyCardStage
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;

	import ui.counterNumberBg;

	public class CounterNumber extends Sprite implements ICounter
	{
		private var _counterText:TextField;
		private var _bg:counterNumberBg;

		public function CounterNumber(number:Number){
			super();

			this._bg = new counterNumberBg();
			(this._bg as MovieClip).gotoAndStop(1);
			addChild(this._bg);

			var _defaultFormat_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._counterText = new TextField();
			this._counterText.autoSize = TextFieldAutoSize.CENTER;
			this._counterText.defaultTextFormat = _defaultFormat_;
			this._counterText.text = "0";
			addChild(this._counterText);

			this.update(number);
			this.resize();
		}

		public function update(cardNumber:Number) :void{
			this._counterText.text = cardNumber.toString();
		}


		public function resize(){
			this._counterText.x = this.x - this._counterText.width/2;
			this._counterText.y = this.y - this._counterText.height/2;
		}
	}
}