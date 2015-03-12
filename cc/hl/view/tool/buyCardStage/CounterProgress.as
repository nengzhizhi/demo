package cc.hl.view.tool.buyCardStage
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import util.$;

	import ui.counterProgressBg;

	public class CounterProgress extends Sprite implements ICounter
	{
		private var _maxValue:Number;
		private var _bg:counterProgressBg;
		private var _counterText:TextField;

		public static const PROGRESS_MAX_WIDTH:Number = 80;

		public function CounterProgress(score:Number, max:Number = 10){
			super();
			this._maxValue = max;

			this._bg = new counterProgressBg();
			addChild(this._bg);
			this._bg.doubleScore.visible = false;

			var _defaultFormat_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._counterText = new TextField();
			this._counterText.autoSize = TextFieldAutoSize.CENTER;
			this._counterText.defaultTextFormat = _defaultFormat_;
			addChild(this._counterText);
			this.update(score);
			this.resize();
		}

		public function update(cardNumber:Number) : void{
			$.jscall("console.info",cardNumber.toString());
			if(cardNumber < this._maxValue){
				this._bg.doubleScore.visible = false;
				this._bg.slider.width = cardNumber/this._maxValue*PROGRESS_MAX_WIDTH;
			}
			else{
				this._bg.doubleScore.visible = true;
				this._bg.slider.width = PROGRESS_MAX_WIDTH;
			}
			this._counterText.text = cardNumber.toString() + "/" + this._maxValue.toString();
		}

		public function resize() : void{
			this._counterText.x = this.x - this._counterText.width/2;
			this._counterText.y = this.y - this._counterText.height/2;
		}
	}
}