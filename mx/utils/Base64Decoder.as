package mx.utils
{
   import flash.utils.ByteArray;
   
   public class Base64Decoder extends Object
   {
      
      public function Base64Decoder() {
         this.work = [0,0,0,0];
         super();
         this.data = new ByteArray();
      }
      
      private static const ESCAPE_CHAR_CODE:Number = 61;
      
      private static const inverse:Array = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,62,64,64,64,63,52,53,54,55,56,57,58,59,60,61,64,64,64,64,64,64,64,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,64,64,64,64,64,64,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64];
      
      public function decode(param1:String) : void {
         var _loc3_:* = NaN;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.charCodeAt(_loc2_);
            if(_loc3_ == ESCAPE_CHAR_CODE)
            {
               this.work[this.count++] = -1;
               if(this.count == 4)
               {
                  this.count = 0;
                  this.data.writeByte(this.work[0] << 2 | (this.work[1] & 255) >> 4);
                  this.filled++;
                  if(this.work[2] == -1)
                  {
                     break;
                  }
                  this.data.writeByte(this.work[1] << 4 | (this.work[2] & 255) >> 2);
                  this.filled++;
                  if(this.work[3] == -1)
                  {
                     break;
                  }
                  this.data.writeByte(this.work[2] << 6 | this.work[3]);
                  this.filled++;
               }
            }
            else if(inverse[_loc3_] != 64)
            {
               this.work[this.count++] = inverse[_loc3_];
               if(this.count == 4)
               {
                  this.count = 0;
                  this.data.writeByte(this.work[0] << 2 | (this.work[1] & 255) >> 4);
                  this.filled++;
                  if(this.work[2] == -1)
                  {
                     break;
                  }
                  this.data.writeByte(this.work[1] << 4 | (this.work[2] & 255) >> 2);
                  this.filled++;
                  if(this.work[3] == -1)
                  {
                     break;
                  }
                  this.data.writeByte(this.work[2] << 6 | this.work[3]);
                  this.filled++;
               }
            }
            
            _loc2_++;
         }
      }
      
      public function drain() : ByteArray {
         var _loc1_:ByteArray = new ByteArray();
         var _loc2_:uint = this.data.position;
         this.data.position = 0;
         _loc1_.writeBytes(this.data,0,this.data.length);
         this.data.position = _loc2_;
         _loc1_.position = 0;
         this.filled = 0;
         return _loc1_;
      }
      
      public function flush() : ByteArray {
         return this.drain();
      }
      
      public function reset() : void {
         this.data = new ByteArray();
         this.count = 0;
         this.filled = 0;
      }
      
      public function toByteArray() : ByteArray {
         var _loc1_:ByteArray = this.flush();
         this.reset();
         return _loc1_;
      }
      
      private var count:int = 0;
      
      private var data:ByteArray;
      
      private var filled:int = 0;
      
      private var work:Array;
   }
}
