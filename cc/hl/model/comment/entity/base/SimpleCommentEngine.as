package cc.hl.model.comment.entity.base
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFieldType;
   
   public class SimpleCommentEngine extends Sprite
   {
      
      public function SimpleCommentEngine(param1:String, param2:Number, param3:int, param4:Boolean, param5:int, param6:String, param7:Boolean = true) {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.cacheAsBitmap = true;
         if(param7)
         {
         }
         this._debText = new TextField();
         this._debText.autoSize = TextFieldAutoSize.LEFT;
         var _loc8_:TextFormat = new TextFormat(param1,param2,param3,param4);
         _loc8_.bold = true;
         _loc8_.font = "黑体";
         this._debText.defaultTextFormat = _loc8_;
         this._debText.type = TextFieldType.DYNAMIC;
         this._debText.selectable = false;
         this._debText.mouseEnabled = false;
         this._debText.text = param6;
         this.addChild(this._debText);
         if(param5 > -1)
         {
            this.drawBg(param5);
         }
      }
      
      private var _width:Number = 0;
      
      private var _height:Number = 0;
      
      private var _debText:TextField;
      
      private function drawBg(param1:uint) : void {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.lineStyle(3,param1);
         _loc2_.graphics.moveTo(0,0);
         _loc2_.graphics.lineTo(this._debText.width,0);
         _loc2_.graphics.lineTo(this._debText.width,this._debText.height);
         _loc2_.graphics.lineTo(0,this._debText.height);
         _loc2_.graphics.lineTo(0,0);
         _loc2_.graphics.endFill();
         this.addChild(_loc2_);
      }
      
      override public function get width() : Number {
         return this._debText.width;
      }
      
      override public function get height() : Number {
         return this._debText.height;
      }
   }
}
