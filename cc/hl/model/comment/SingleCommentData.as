package cc.hl.model.comment
{
   public class SingleCommentData extends Object
   {
      
      public function SingleCommentData(param1:String, param2:int, param3:int, param4:int, param5:Boolean = false) {
         super();
         this._text = param1;
         this._color = param2;
         this._size = param3;
         this.border = param5;
         this.stime = param4;
      }
      
      public var isChecked:Boolean = false;
      
      public var on:Boolean = false;
      
      public var border:Boolean = false;
      
      private var _text:String;
      
      private var _color:int;
      
      private var _size:int;
      
      public var stime:Number;
      
      public var deleted:Boolean = false;
      
      public function get text() : String {
         return this._text;
      }
      
      public function get color() : int {
         return this._color;
      }
      
      public function get size() : int {
         return this._size;
      }
   }
}
