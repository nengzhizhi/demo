package cc.hl.model.comment.entity
{
   import cc.hl.model.comment.entity.base.Comment;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import cc.hl.model.comment.SingleCommentData;
   
   public class ScrollComment extends Comment
   {
      
      public function ScrollComment(param1:SingleCommentData) {
         super(param1);
      }
      
      protected var _tw:TweenLite;
      
      protected var _dur:Number;
      
      public function set duration(param1:Number) : void {
         this._dur = param1;
      }
      
      override public function start() : void {
         this._tw = new TweenLite(this,this._dur,
            {
               "x":-width,
               "onComplete":this.completeHandler,
               "ease":Linear.easeInOut
            });
         this._tw.play();
      }
      
      override public function completeHandler() : void {
         _complete();
         this._tw.kill();
         delete this[this];
      }
      
      override public function resume() : void {
         this._tw.resume();
      }
      
      override public function pause() : void {
         this._tw.pause();
      }
      
      override public function doComplete() : void {
         this._tw.complete();
      }
   }
}
