package cc.hl.view.tool.useCardStage
{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;

	import ui.countdownBar;

	public class CountdownBar extends Sprite
	{
		private var _bar:countdownBar;
		private var _countdownSecond:Number;
		private var _leftSecond:Number;
		private var _timer:Timer;
		private var _cdText:TextField;
		private var _titleText:TextField;
		private var _callback:Function;

		public function CountdownBar(second:Number) {
			super();

			this._countdownSecond = second;

			this._bar = new countdownBar();
			addChild(this._bar);

			this._bar.slider.width = 20;


			var _loc2_:TextFormat = new TextFormat("微软雅黑",12,0xFFFFFF,false);
			this._cdText = new TextField();
			this._cdText.autoSize = TextFieldAutoSize.CENTER;
			this._cdText.defaultTextFormat = _loc2_;
			this._cdText.type = TextFieldType.DYNAMIC;
			this._cdText.selectable = false;
			this._cdText.mouseEnabled = false;
			var minutes = Math.floor(this._countdownSecond/60);
			var seconds = this._countdownSecond%60;
			var minutesStr = minutes > 9 ? minutes.toString() : "0"+minutes.toString();
			var secondsStr = seconds > 9 ? seconds.toString() : "0"+seconds.toString();
			this._cdText.htmlText = minutesStr+":"+secondsStr;
			addChild(this._cdText);

			this._titleText = new TextField();
			this._titleText.autoSize = TextFieldAutoSize.CENTER;
			this._titleText.defaultTextFormat = _loc2_;
			this._titleText.type = TextFieldType.DYNAMIC;
			this._titleText.selectable = false;
			this._titleText.mouseEnabled = false;
			this._titleText.text = "倒计时：";
			addChild(this._titleText);

			this._bar.slider.width = 0;
			this.resize();
		}

		public function setCallback(f:Function){
			this._callback = f;
		}

		public function cancelCallback(){
			this._callback = null;
		}

		public function start(){
			this._leftSecond = this._countdownSecond;

			this._timer = new Timer(1000, this._countdownSecond);
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);

			function onTimer(event:TimerEvent) : void{
				_leftSecond = _leftSecond - 1;
				_bar.slider.width = 160 - _leftSecond/_countdownSecond*160;

				var minutes = Math.floor(_leftSecond/60);
				var seconds = _leftSecond%60;
				var minutesStr = minutes > 9 ? minutes.toString() : "0"+minutes.toString();
				var secondsStr = seconds > 9 ? seconds.toString() : "0"+seconds.toString();
				_cdText.htmlText = minutesStr+":"+secondsStr;

				if(_leftSecond <= 0 && _callback!=null){
					_callback();
				}				
			}

			this._timer.start();
		}

		public function resize(){
			this._cdText.x = this.x + 90;
			this._cdText.y = this.y - this._cdText.height/2;

			this._titleText.x = this.x - 80 - this._titleText.width;
			this._titleText.y = this.y - this._titleText.height/2;
		}
	}
}