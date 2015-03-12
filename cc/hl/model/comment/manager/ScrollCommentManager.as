package cc.hl.model.comment.manager
{
   import cc.hl.model.comment.manager.base.CommentManager;
   import cc.hl.model.comment.space.CommentSpaceManager;
   import cc.hl.model.comment.space.ScrollCommentSpaceManager;
   import cc.hl.model.comment.entity.base.IComment;
   import cc.hl.model.comment.SingleCommentData;
   import cc.hl.model.comment.entity.ScrollComment;
   import flash.display.Sprite;
   
   public class ScrollCommentManager extends CommentManager
   {
      
      public function ScrollCommentManager(param1:Sprite) {
         super(param1);
      }
      
      override protected function setSpaceManager() : void {
         this.space_manager = CommentSpaceManager(new ScrollCommentSpaceManager());
      }
      
      override protected function getComment(param1:SingleCommentData) : IComment {
         return IComment(new ScrollComment(param1));
      }
   }
}
