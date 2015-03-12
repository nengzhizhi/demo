package cc.hl.model.comment.manager.base
{
   import flash.display.Sprite;
   import cc.hl.model.comment.CommentConfig;
   import cc.hl.model.comment.space.CommentSpaceManager;
   import cc.hl.model.comment.SingleCommentData;
   import cc.hl.model.comment.entity.base.IComment;
   import flash.display.DisplayObject;
   import cc.hl.model.comment.entity.base.Comment;
   
   public class CommentManager extends Object implements ICommentManager
   {
      
      public function CommentManager(param1:Sprite) {
         super();
         this.clip = param1;
         this.config = CommentConfig.instance;
         this.setSpaceManager();
      }
      
      private var clip:Sprite;
      
      private var config:CommentConfig;
      
      protected var space_manager:CommentSpaceManager;
      
      protected function setSpaceManager() : void {
         this.space_manager = new CommentSpaceManager();
      }
      
      public function start(param1:SingleCommentData) : void {
         var cmt:IComment = null;
         var self:CommentManager = null;
         var data:SingleCommentData = param1;
         data.on = true;
         cmt = this.getComment(data);
         self = CommentManager(this);
         cmt.complete = function():void
         {
            self.complete(data);
            self.removeFromSpace(cmt);
            clip.removeChild(DisplayObject(cmt));
            cmt = null;
         };
         this.add2Space(cmt);
         this.clip.addChild(DisplayObject(cmt));
         cmt.start();
      }
      
      protected function add2Space(param1:IComment) : void {
         this.space_manager.add(Comment(param1));
      }
      
      protected function removeFromSpace(param1:IComment) : void {
         this.space_manager.remove(Comment(param1));
      }
      
      protected function getComment(param1:SingleCommentData) : IComment {
         return new Comment(param1);
      }
      
      protected function complete(param1:SingleCommentData) : void {
         param1.on = false;
      }
      
      public function resize(param1:Number, param2:Number) : void {
         this.space_manager.setRectangle(param1,param2);
      }
   }
}
