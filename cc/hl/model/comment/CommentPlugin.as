package cc.hl.model.comment
{
   import flash.display.Sprite;
   
   public class CommentPlugin extends Sprite
   {
      
      public function CommentPlugin() {
         super();
         CommentTime.instance.setclip(this);
      }
      
      public function start(param1:SingleCommentData) : void {
         CommentTime.instance.start(param1);
      }
      
      public function resize(param1:Number, param2:Number) : void {
         CommentTime.instance.resize(param1,param2);
      }
      
      public function set commentShow(param1:Boolean) : void {
         CommentTime.instance.visible = param1;
      }
   }
}
