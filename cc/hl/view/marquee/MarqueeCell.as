package cc.hl.view.marquee
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFieldType;
   import com.greensock.easing.Linear;

	public class MarqueeCell extends Sprite
	{
		private var _debText:TextField;
		protected var _complete:Function;
		protected var _tw:TweenLite;

		public function MarqueeCell(param1:String){
			super();
			this._debText = new TextField();
			this._debText.autoSize = TextFieldAutoSize.LEFT;
	        var _loc2_:TextFormat = new TextFormat("微软雅黑",20,16777215,false);
	        this._debText.defaultTextFormat = _loc2_;
	        this._debText.type = TextFieldType.DYNAMIC;
	        this._debText.selectable = false;
	        this._debText.mouseEnabled = false;
	        this._debText.htmlText = param1;
	        this.x = GlobalData.root.stage.stageWidth;
	        this.y = 5;
	        this.addChild(this._debText);   
		}

		public function start(){
			this._tw = new TweenLite(this,8,
			{
				"x":-width,
				"onComplete":this.completeHandler,
				"ease":Linear.easeInOut
			});     
			this._tw.play();
		}

		public function setComplete(f:Function){
			this._complete = f;
		}

		private function completeHandler() : void {
			this._tw.kill();
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}
			delete this[this];
			if(this._complete != null){
				this._complete();
			}
		}		
	}
}