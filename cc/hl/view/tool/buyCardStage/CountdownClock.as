package cc.hl.view.tool.buyCardStage
{
	import flash.display.Sprite;
	import flash.utils.Timer;

	import flash.events.TimerEvent;
	import flash.display.MovieClip;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;

	import ui.arcUnit;

	public class CountdownClock extends Sprite
	{
		private var _countdownSecond:Number;
		private var _angle:Number;
		private var _timer:Timer;
		private var _pools:Array;
		private var _cdText:TextField;

		public function CountdownClock(second:Number) {
			super();
			this._countdownSecond = second;
			this._cdText = new TextField();
			this._cdText.autoSize = TextFieldAutoSize.LEFT;
	        var _loc2_:TextFormat = new TextFormat("微软雅黑",12,0xFFA609,false);
	        this._cdText.defaultTextFormat = _loc2_;
	        this._cdText.type = TextFieldType.DYNAMIC;
	        this._cdText.selectable = false;
	        this._cdText.mouseEnabled = false;
			var minutes = Math.floor(this._countdownSecond/60);
			var seconds = this._countdownSecond%60;
			var minutesStr = minutes > 9 ? minutes.toString() : "0"+minutes.toString();
			var secondsStr = seconds > 9 ? seconds.toString() : "0"+seconds.toString();
			_cdText.htmlText = minutesStr+":"+secondsStr;

			this._pools = [];
		}

		public function start(){
			this.clearPool();

			if(this._timer != null){
				this._timer.stop();
			}

			this._timer = new Timer(1000,this._countdownSecond);
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);

			//初始化倒计时圈
			this._angle = 0;

			//初始化倒计时文本
	        addChild(this._cdText);
	        this._cdText.x = 0 - this._cdText.width/2;
	        this._cdText.y = 0 - 100;

	        var rotatePerSecond = 360/this._countdownSecond;
	        var rotateAccumulate:Number = 0;

			function onTimer(event:TimerEvent):void{
				_countdownSecond = _countdownSecond - 1;
				rotateAccumulate = rotateAccumulate + rotatePerSecond;

				if(rotateAccumulate > 1){
					for(var i:int = 0; i<int(rotateAccumulate); i++){
						addArc(1);
					}
				}

				rotateAccumulate = rotateAccumulate - int(rotateAccumulate);

				var minutes = Math.floor(_countdownSecond/60);
				var seconds = _countdownSecond%60;
				var minutesStr = minutes > 9 ? minutes.toString() : "0"+minutes.toString();
				var secondsStr = seconds > 9 ? seconds.toString() : "0"+seconds.toString();

				_cdText.htmlText = minutesStr+":"+secondsStr;	        	
			}

			this._timer.start();
		}

		private function addArc(rotateIncrement:Number) : void{
			var _arcUnit = new arcUnit();
			_arcUnit.rotation = this._angle;
			this._angle = this._angle + rotateIncrement;
			this._pools.push(_arcUnit);
			addChild(_arcUnit);
		}

		public function resize(){
	        this._cdText.x = 0 - this._cdText.width/2;
	        this._cdText.y = 0 - 100;
		}


		private function clearPool(){
			while(this._pools.length > 0){
				var arc_mc = this._pools.pop();
				if(arc_mc.parent != null){
					arc_mc.parent.removeChild(arc_mc);
				}
				delete arc_mc[arc_mc];
			}
		}				
	}
}