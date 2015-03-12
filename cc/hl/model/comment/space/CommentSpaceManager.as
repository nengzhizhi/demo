package cc.hl.model.comment.space
{
   import cc.hl.model.comment.entity.base.Comment;
   import util.CommonUtils;
   
   public class CommentSpaceManager extends Object
   {
      
      public function CommentSpaceManager() {
         this.Pools = [];
         super();
      }
      
      protected var Pools:Array;
      
      protected var Width:int;
      
      protected var Height:int;
      
      protected var isComplete:Boolean = true;
      
      public function setRectangle(param1:int, param2:int) : void {
         this.Width = param1;
         this.Height = param2;
      }
      
      public function add(param1:Comment) : void {
         param1.x = (this.Width - param1.width) / 2;
         if(param1.height >= this.Height - GlobalData.offsetDownHeight)
         {
            param1.setY(0,-1,this.transformY);
         }
         else
         {
            this.setY(param1);
         }
      }
      
      protected function setY(param1:Comment, param2:int = 0) : void {
         var _loc5_:Comment = null;
         var _loc3_:* = 0;
         if(this.Pools.length <= param2)
         {
            this.Pools.push(new Array());
         }
         var _loc4_:Array = this.Pools[param2];
         if(_loc4_.length == 0)
         {
            param1.setY(GlobalData.offsetUpHeight,param2,this.transformY);
            _loc4_.push(param1);
            return;
         }
         if(this.vCheck(GlobalData.offsetUpHeight,param1,param2))
         {
            param1.setY(GlobalData.offsetUpHeight,param2,this.transformY);
            CommonUtils.binsert(_loc4_,param1,this.bottom_cmp);
            return;
         }
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = _loc5_.bottom + 1;
            if(_loc3_ + param1.height > this.Height - GlobalData.offsetDownHeight)
            {
               break;
            }
            if(this.vCheck(_loc3_,param1,param2))
            {
               param1.setY(_loc3_,param2,this.transformY);
               CommonUtils.binsert(_loc4_,param1,this.bottom_cmp);
               return;
            }
         }
         this.setY(param1,param2 + 1);
      }
      
      protected function transformY(param1:int, param2:Comment) : int {
         return param1;
      }
      
      protected function bottom_cmp(param1:Comment, param2:Comment) : int {
         if(param1.bottom < param2.bottom)
         {
            return -1;
         }
         if(param1.bottom == param2.bottom)
         {
            return 0;
         }
         return 1;
      }
      
      protected function vCheck(param1:int, param2:Comment, param3:int) : Boolean {
         var _loc5_:Comment = null;
         var _loc4_:int = param1 + param2.height;
         for each(_loc5_ in this.Pools[param3])
         {
            if(_loc5_.y > _loc4_ || _loc5_.bottom < param1)
            {
               continue;
            }
            return false;
         }
         return true;
      }
      
      public function remove(param1:Comment) : void {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         if(param1.index != -1)
         {
            _loc2_ = this.Pools[param1.index];
            _loc3_ = _loc2_.indexOf(param1);
            _loc2_.splice(_loc3_,1);
         }
      }
      
      public function updateY(param1:int) : int {
         if(param1 > GlobalData.root.stage.stageHeight * 0.35 && param1 < GlobalData.root.stage.stageHeight * 0.65)
         {
            if(Math.random() >= 0)
            {
               param1 = GlobalData.root.stage.stageHeight * 0.65;
            }
         }
         return param1;
      }
   }
}
