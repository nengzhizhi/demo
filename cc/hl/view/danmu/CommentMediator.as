package cc.hl.view.danmu
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import common.event.ObjectEvent;
   import cc.hl.model.comment.SingleCommentData;
   import common.event.EventCenter;
   
   public class CommentMediator extends Mediator implements IMediator
   {
      
      public function CommentMediator(param1:Object) {
         super(NAME,param1);
         EventCenter.addEventListener("AddComment",this.__addComment);
      }
      
      public static var NAME:String = "CommentMediator";
      
      override public function listNotificationInterests() : Array {
         return [Order.Comment_Show_Request,Order.Comment_OpenHide_Request,Order.On_Resize];
      }
      
      override public function handleNotification(param1:INotification) : void {
         switch(param1.getName())
         {
            case Order.Comment_Show_Request:
               this.showComment();
               break;
            case Order.Comment_OpenHide_Request:
               this.openHideComment(param1.getBody());
               break;
            case Order.On_Resize:
               this.onResize();
               break;
         }
      }
      
      public function showComment() : void {
         this.commentView.initComment();
         GlobalData.COMMENTLAYER.addChild(this.commentView);
         this.commentView.onResize();
      }
      
      public function openHideComment(param1:Object) : void {
         var _loc2_:Boolean = param1.status;
         this.commentView.onCommentShowStatus(_loc2_);
      }
      
      public function onResize() : void {
         this.commentView.onResize();
      }
      
      public function get commentView() : CommentView {
         return viewComponent as CommentView;
      }
      
      private function __addComment(param1:ObjectEvent) : void {
         var _loc2_:SingleCommentData = param1.data as SingleCommentData;
         this.commentView.addChild(new CommentCell(_loc2_));
      }
   }
}
