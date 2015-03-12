package cc.hl.model.comment.entity.base
{
   public interface IComment
   {
      
      function start() : void;
      
      function pause() : void;
      
      function resume() : void;
      
      function doComplete() : void;
      
      function completeHandler() : void;
      
      function set complete(param1:Function) : void;
      
      function get innerText() : String;
   }
}
