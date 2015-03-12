package cc.hl.model.net
{
   public class Stringify extends Object
   {
      
      public function Stringify() {
         super();
      }
      
      public static function s(param1:Object) : String {
         return JSON.stringify(param1);
      }
   }
}
