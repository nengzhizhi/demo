package cc.hl.view.tool.useCardStage{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;	
	import util.*;
	
	import ui.preparationBg;

	public class Preparation extends Sprite{
		private var _bg:preparationBg;
		private var _countdownBar:CountdownBar;
		private var _tipText:TextField;

		public function Preparation(tipStr:String){
			super();

			this._bg = new preparationBg();
			//this._bg.submit.addEventListener(MouseEvent.CLICK, this.onDoNext);
			addChild(this._bg);

			this._countdownBar = new CountdownBar(3);
			addChild(this._countdownBar);

			var _loc1_:TextFormat = new TextFormat("微软雅黑",14,0xffa609,false);
			this._tipText = new TextField();
			this._tipText.defaultTextFormat = _loc1_;
			this._tipText.autoSize = TextFieldAutoSize.CENTER;
			this._tipText.text = tipStr;
			this.addChild(this._tipText);

			this._countdownBar.setCallback(function(){
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_INTERACTIVE_TOOL_DO_NEXT,null));
				});

			this.resize();
			this._countdownBar.start();
		}

		public function cancelListener(){
			this._countdownBar.cancelCallback();
		}

		public function onDoNext(param:MouseEvent){
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_INTERACTIVE_TOOL_DO_NEXT,null));
		}

		public function resize():void{
			this._countdownBar.y = this._bg.y + 70;

			this._tipText.x = this._bg.x - this._tipText.textWidth/2;
			this._tipText.y = this._bg.y - 10;
		}
	}
}