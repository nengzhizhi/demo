package cc.hl.view.tool.useCardStage{
	import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.Loader;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;

	import flash.utils.Timer;
	import flash.events.TimerEvent;	
    import flash.net.URLRequest;


	import ui.loseInfoBg;

	public class LoseInfo extends Sprite{
		private var _bg:loseInfoBg;
		private var _text:TextField;

		public function LoseInfo(param:Object){
			super();

			this._bg = new loseInfoBg();
			this._bg.submit.addEventListener(MouseEvent.CLICK, this.onClicked);
			addChild(this._bg);

			var _loc1_:TextFormat = new TextFormat("微软雅黑",14,0xFFFFFF,false);
			this._text = new TextField();
			this._text.defaultTextFormat = _loc1_;
			this._text.autoSize = TextFieldAutoSize.CENTER;
			this._text.htmlText = "(我送出了"+ 0 
								+ "张，获胜者<font color='#FFA609'>"
								+ param.useCardInfo.winner + 
								"</font>送出了" + param.useCardInfo.cardNumber + "张)";
			this.addChild(this._text);

			var timer:Timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();

			this.resize();
		}

		private function completeHandler(e:Event):void {
			var loader:Loader = Loader(e.target.loader);
			this._bg.test = Bitmap(loader.content);
			addChild(this._bg.test);
		}

		private function onTimer(event:TimerEvent) : void{
			this.parent.removeChild(this);
			delete this;
		}

		public function onClicked(param:MouseEvent){
			this.parent.removeChild(this);
			delete this;
		}

		public function resize(){
			this._text.x = this.x - this._text.textWidth/2;
			this._text.y = 10;
		}
	}
}