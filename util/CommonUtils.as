package util
{
   //import com.adobe.serialization.json.JSON;
   import flash.utils.ByteArray;
   
   public class CommonUtils extends Object
   {
      
      public function CommonUtils() {
         super();
      }
      
      /*
      public static function encode(param1:Object) : String {
         return com.adobe.serialization.json.JSON.encode(param1);
      }
      
      public static function decode(param1:String, param2:Boolean = true) : * {
         return com.adobe.serialization.json.JSON.decode(param1,param2);
      }
      */
      public static function binsert(param1:*, param2:Object, param3:Function) : void {
         var _loc4_:int = bsearch(param1,param2,param3);
         param1.splice(_loc4_,0,param2);
      }
      
      public static function bsearch(param1:*, param2:Object, param3:Function) : int {
         var _loc6_:* = 0;
         if(param1.length == 0)
         {
            return 0;
         }
         if(param3(param2,param1[0]) < 0)
         {
            return 0;
         }
         if(param3(param2,param1[param1.length - 1]) >= 0)
         {
            return param1.length;
         }
         var _loc4_:* = 0;
         var _loc5_:int = param1.length - 1;
         var _loc7_:* = 0;
         while(_loc4_ <= _loc5_)
         {
            _loc6_ = Math.floor((_loc4_ + _loc5_ + 1) / 2);
            _loc7_++;
            if(param3(param2,param1[_loc6_ - 1]) >= 0 && param3(param2,param1[_loc6_]) < 0)
            {
               return _loc6_;
            }
            if(param3(param2,param1[_loc6_ - 1]) < 0)
            {
               _loc5_ = _loc6_ - 1;
            }
            else if(param3(param2,param1[_loc6_]) >= 0)
            {
               _loc4_ = _loc6_;
            }
            else
            {
               throw new Error("查找错误.");
            }
            
            if(_loc7_ > 1000)
            {
               throw new Error("查找超时.");
            }
            else
            {
               continue;
            }
         }
         return -1;
      }
      
      public static function copyObject(param1:Object) : Object {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         var _loc3_:Object = _loc2_.readObject();
         return _loc3_;
      }
   }
}
