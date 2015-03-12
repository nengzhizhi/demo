package cc.hl.model.comment.entity.base
{
   import cc.hl.model.comment.SingleCommentData;
   import flash.utils.Timer;
   import cc.hl.model.comment.CommentConfig;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   
   public class Comment extends SimpleCommentEngine implements IComment
   {
      
      public function Comment(param1:SingleCommentData) {
         this.config = CommentConfig.instance;
         var _loc2_:int = param1.size;
         var _loc3_:* = true;
         if(_loc2_ > 99)
         {
            _loc3_ = false;
            _loc2_ = _loc2_ - 100;
         }
         this.stime = int(param1.stime / 1000);
         super(this.config.font,this.config.sizee * _loc2_,param1.color,this.config.bold,param1.border?196607:-1,param1.text);
         this._item = param1;
         this.alpha = GlobalData.textAlphaValue;
         if(_loc3_)
         {
            if(this.item.color == 0)
            {
               this.filters = [new GlowFilter(16777215,1,2,2,1.5,1)];
            }
            else
            {
               this.filters = this.config.filter;
            }
         }
      }
      
      protected var _complete:Function;
      
      private var _item:SingleCommentData;
      
      protected var _index:int;
      
      protected var _bottom:int;
      
      protected var _tm:Timer;
      
      protected var config:CommentConfig;
      
      public var stime:int;
      
      public function setY(param1:int, param2:int, param3:Function) : void {
         this.y = param3(param1,this);
         this._index = param2;
         this._bottom = param1 + this.height + 2;
      }
      
      public function get index() : int {
         return this._index;
      }
      
      public function get bottom() : int {
         return this._bottom;
      }
      
      public function get right() : int {
         return this.x + this.width;
      }
      
      public function resume() : void {
         this._tm.start();
      }
      
      public function pause() : void {
         this._tm.stop();
      }
      
      public function start() : void {
         this._tm = new Timer(250,10);
         this._tm.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
         {
            completeHandler();
         });
         this._tm.start();
      }
      
      public function completeHandler() : void {
         this._complete();
      }
      
      public function set complete(param1:Function) : void {
         this._complete = param1;
      }
      
      public function doComplete() : void {
         this._tm.stop();
         this._tm.removeEventListener(TimerEvent.TIMER_COMPLETE,this.completeHandler);
         this.completeHandler();
      }
      
      public function get innerText() : String {
         return this._item.text;
      }
      
      public function get item() : SingleCommentData {
         return this._item;
      }
   }
}
