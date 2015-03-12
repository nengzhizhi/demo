package cc.hl.view.marquee
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFieldType;

	public class SponsorCell extends Sprite
	{
		public function SponsorCell(name:String){
			super();
			this._debText = new TextField();
			this._debText.autoSize = TextFieldAutoSize.LEFT;

			this._debText.type = TextFieldType.DYNAMIC;
			this._debText.selectable = false;
			this._debText.mouseEnabled = false;

			var _loc2_:TextFormat = new TextFormat("微软雅黑"/*font*/,20/*size*/,16777215/*color*/ ,false /*is bold*/);

			this._debText.defaultTextFormat = _loc2_;
			this._debText.htmlText = "本期节目由<font color='#FFA609'>"+name+"</font>独家冠名播出";
			this.x = 10;
			this.y = 5;
			this.addChild(this._debText);
		}

		private var _debText:TextField;
	}
}