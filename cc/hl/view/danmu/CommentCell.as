package cc.hl.view.danmu
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import cc.hl.model.comment.CommentConfig;
   import com.greensock.TweenLite;
   import flash.events.Event;
   import cc.hl.model.comment.SingleCommentData;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFieldType;
   import com.greensock.easing.Linear;
   
   public class CommentCell extends Sprite
   {
      
      public function CommentCell(param1:SingleCommentData) {
         this.config = CommentConfig.instance;
         super();
         this._debText = new TextField();
         this._debText.autoSize = TextFieldAutoSize.LEFT;
         var _loc2_:TextFormat = new TextFormat(this.config.font,this.config.sizee * param1.size,param1.color,this.config.bold);
         _loc2_.bold = true;
         _loc2_.font = "黑体";
         var _loc3_:int = param1.border?6750207:-1;
         if(_loc3_ > -1)
         {
            this._debText.borderColor = _loc3_;
            this._debText.border = true;
         }
         this._debText.defaultTextFormat = _loc2_;
         this._debText.type = TextFieldType.DYNAMIC;
         this._debText.selectable = false;
         this._debText.mouseEnabled = false;
         this._debText.text = param1.text;
         this.x = GlobalData.root.stage.stageWidth;
         this.y = GlobalData.root.stage.stageHeight * Math.random();
         this.addChild(this._debText);
         this._tw = new TweenLite(this,8,
            {
               "x":-width,
               "onComplete":this.completeHandler,
               "ease":Linear.easeInOut
            });
         this._tw.play();
      }
      
      private var _debText:TextField;
      
      protected var config:CommentConfig;
      
      protected var _tw:TweenLite;
      
      private function completeHandler() : void {
         this._tw.kill();
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
         delete this[this];
      }
      
      private function __render(param1:Event) : void {
         this.x = this.x - 2;
         if(this.x < -this._debText.textWidth)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.__render);
            if(this.parent != null)
            {
               this.parent.removeChild(this);
            }
            delete this[this];
         }
      }
   }
}
