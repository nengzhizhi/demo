package common.event
{
   import flash.events.Event;
   
   public class ObjectEvent extends Event
   {
      
      public function ObjectEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      private var _data:Object;
      
      public function get data() : Object {
         return this._data;
      }
   }
}
