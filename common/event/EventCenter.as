package common.event
{
   import flash.events.EventDispatcher;
   
   public class EventCenter extends Object
   {
      
      public function EventCenter() {
         super();
      }
      
      private static var dispatcher:EventDispatcher = new EventDispatcher();
      
      public static function addEventListener(param1:String, param2:Function) : void {
         dispatcher.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void {
         dispatcher.removeEventListener(param1,param2);
      }
      
      public static function dispatchEvent(param1:ObjectEvent) : void {
         dispatcher.dispatchEvent(param1);
      }
      
      public static function dispatch(param1:String, param2:Object = null) : void {
         dispatcher.dispatchEvent(new ObjectEvent(param1,param2));
      }
   }
}
