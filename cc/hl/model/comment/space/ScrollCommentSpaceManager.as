package cc.hl.model.comment.space
{
   import cc.hl.model.comment.CommentConfig;
   import cc.hl.model.comment.entity.base.Comment;
   import cc.hl.model.comment.entity.ScrollComment;
   
   public class ScrollCommentSpaceManager extends CommentSpaceManager
   {
      
      public function ScrollCommentSpaceManager() {
         this.config = CommentConfig.instance;
         this.commentArr = [];
         super();
      }
      
      private var duration:Number = 4.8;
      
      private var config:CommentConfig;
      
      public var commentArr:Array;
      
      override public function add(param1:Comment) : void {
         var _loc2_:Comment = null;
         param1.x = this.Width;
         ScrollComment(param1).duration = (this.Width + param1.width) / this.getSpeed(param1);
         this.commentArr.push(param1);
         while(this.commentArr.length != 0)
         {
            if(isComplete)
            {
               _loc2_ = this.commentArr[0] as Comment;
               isComplete = false;
               if(_loc2_.height >= this.Height - GlobalData.offsetDownHeight)
               {
                  _loc2_.setY(GlobalData.offsetUpHeight,-1,transformY);
               }
               else
               {
                  this.setY(_loc2_);
               }
               isComplete = true;
               this.commentArr.shift();
            }
         }
      }
      
      override public function setRectangle(param1:int, param2:int) : void {
         this.Width = param1 - 10;
         this.Height = param2;
      }
      
      override protected function vCheck(param1:int, param2:Comment, param3:int) : Boolean {
         var _loc6_:Comment = null;
         var _loc4_:int = param1 + param2.height;
         var _loc5_:int = param2.x + param2.width;
         for each(_loc6_ in this.Pools[param3])
         {
            if(_loc6_.y > _loc4_ || _loc6_.bottom < param1)
            {
               continue;
            }
            if(_loc6_.right < param2.x || _loc6_.x > _loc5_)
            {
               if(this.getEnd(_loc6_) <= this.getMiddle(param2))
               {
                  continue;
               }
               return false;
            }
            return false;
         }
         return true;
      }
      
      private function getSpeed(param1:Comment) : Number {
         return (this.Width + param1.width) * (this.config.width / this.Width + 0.1) * this.config.speede / this.duration;
      }
      
      private function getEnd(param1:Comment) : Number {
         return (this.Width + param1.width) / this.getSpeed(param1);
      }
      
      private function getMiddle(param1:Comment) : Number {
         return this.Width / this.getSpeed(param1);
      }
   }
}
