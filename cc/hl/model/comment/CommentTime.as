package cc.hl.model.comment
{
   import cc.hl.model.comment.manager.ScrollCommentManager;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class CommentTime extends Object
   {
      
      public function CommentTime() {
         super();
         if(_instance != null)
         {
            throw new Error("该对象只能存在一个,请改用getInstance()获取");
         }
         else
         {
            return;
         }
      }
      
      private static var _instance:CommentTime = null;
      
      public static function get instance() : CommentTime {
         if(_instance == null)
         {
            _instance = new CommentTime();
         }
         return _instance;
      }
      
      public var manager:ScrollCommentManager;
      
      private var _visible:Boolean = true;
      
      private var _clip:Sprite;
      
      public function setclip(param1:Sprite) : void {
         this._clip = param1;
         this._clip.mouseEnabled = this._clip.mouseChildren = false;
         this.manager = new ScrollCommentManager(this._clip);
      }
      
      public function resize(param1:Number, param2:Number) : void {
         this._clip.scrollRect = new Rectangle(0,0,param1,param2);
         this.manager.resize(param1,param2);
      }
      
      public function set visible(param1:Boolean) : void {
         this._visible = param1;
         if(this._clip == null)
         {
            return;
         }
         this._clip.visible = this._visible;
      }
      
      public function start(param1:SingleCommentData) : void {
         if(!this._visible)
         {
            return;
         }
         this.manager.start(param1);
      }
   }
}
