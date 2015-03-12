package com.greensock.loading.display
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import com.greensock.loading.core.LoaderItem;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class ContentDisplay extends Sprite
   {
      
      public function ContentDisplay(param1:LoaderItem) {
         super();
         this.loader = param1;
      }
      
      protected static var _transformProps:Object = 
         {
            "x":1,
            "y":1,
            "scaleX":1,
            "scaleY":1,
            "rotation":1,
            "alpha":1,
            "visible":true,
            "blendMode":"normal"
         };
      
      protected var _fitRect:Rectangle;
      
      protected var _loader:LoaderItem;
      
      protected var _rawContent:DisplayObject;
      
      protected var _vars:Object;
      
      public var gcProtect;
      
      public function dispose(param1:Boolean = true, param2:Boolean = true) : void {
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
         this.rawContent = null;
         if(this._loader != null)
         {
            if(param1)
            {
               this._loader.unload();
            }
            if(param2)
            {
               this._loader.dispose(false);
               this._loader = null;
            }
         }
      }
      
      public function get rawContent() : * {
         return this._rawContent;
      }
      
      public function set rawContent(param1:*) : void {
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:String = null;
         var _loc10_:* = NaN;
         var _loc11_:* = NaN;
         if(!(this._rawContent == null) && !(this._rawContent == param1) && this._rawContent.parent == this)
         {
            removeChild(this._rawContent);
         }
         var _loc2_:DisplayObject = this._rawContent = param1 as DisplayObject;
         if(_loc2_ == null || this._vars == null)
         {
            return;
         }
         addChildAt(_loc2_,0);
         var _loc3_:Number = _loc2_.width;
         var _loc4_:Number = _loc2_.height;
         if((this._loader.hasOwnProperty("getClass")) && !this._loader.scriptAccessDenied)
         {
            _loc3_ = _loc2_.loaderInfo.width;
            _loc4_ = _loc2_.loaderInfo.height;
         }
         if(this._fitRect != null)
         {
            _loc5_ = this._fitRect.width;
            _loc6_ = this._fitRect.height;
            _loc7_ = _loc5_ - _loc3_;
            _loc8_ = _loc6_ - _loc4_;
            _loc9_ = this._vars.scaleMode;
            if(_loc9_ != "none")
            {
               _loc10_ = _loc5_ / _loc6_;
               _loc11_ = _loc3_ / _loc4_;
               if(_loc11_ < _loc10_ && _loc9_ == "proportionalInside" || _loc11_ > _loc10_ && _loc9_ == "proportionalOutside")
               {
                  _loc5_ = _loc6_ * _loc11_;
               }
               if(_loc11_ > _loc10_ && _loc9_ == "proportionalInside" || _loc11_ < _loc10_ && _loc9_ == "proportionalOutside")
               {
                  _loc6_ = _loc5_ / _loc11_;
               }
               if(_loc9_ != "heightOnly")
               {
                  _loc2_.width = _loc2_.width * _loc5_ / _loc3_;
                  _loc7_ = this._fitRect.width - _loc5_;
               }
               if(_loc9_ != "widthOnly")
               {
                  _loc2_.height = _loc2_.height * _loc6_ / _loc4_;
                  _loc8_ = this._fitRect.height - _loc6_;
               }
            }
            if(this._vars.hAlign == "left")
            {
               _loc7_ = 0;
            }
            else if(this._vars.hAlign != "right")
            {
               _loc7_ = _loc7_ * 0.5;
            }
            
            if(this._vars.vAlign == "top")
            {
               _loc8_ = 0;
            }
            else if(this._vars.vAlign != "bottom")
            {
               _loc8_ = _loc8_ * 0.5;
            }
            
            _loc2_.x = this._fitRect.x;
            _loc2_.y = this._fitRect.y;
            if(this._vars.crop == true)
            {
               _loc2_.scrollRect = new Rectangle(-_loc7_ / _loc2_.scaleX,-_loc8_ / _loc2_.scaleY,this._fitRect.width / _loc2_.scaleX,this._fitRect.height / _loc2_.scaleY);
            }
            else
            {
               _loc2_.x = _loc2_.x + _loc7_;
               _loc2_.y = _loc2_.y + _loc8_;
            }
         }
         else
         {
            _loc2_.x = this._vars.centerRegistration?-_loc3_ / 2:0;
            _loc2_.y = this._vars.centerRegistration?-_loc4_ / 2:0;
         }
      }
      
      public function get loader() : LoaderItem {
         return this._loader;
      }
      
      public function set loader(param1:LoaderItem) : void {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._loader = param1;
         if(this._loader == null)
         {
            return;
         }
         if(!this._loader.hasOwnProperty("setContentDisplay"))
         {
            throw new Error("Incompatible loader used for a ContentDisplay");
         }
         else
         {
            graphics.clear();
            this._fitRect = null;
            this._vars = this._loader.vars;
            this.name = this._loader.name;
            if(this._vars.container is DisplayObjectContainer)
            {
               (this._vars.container as DisplayObjectContainer).addChild(this);
            }
            for(_loc3_ in _transformProps)
            {
               if(_loc3_ in this._vars)
               {
                  _loc2_ = typeof _transformProps[_loc3_];
                  this[_loc3_] = _loc2_ == "number"?Number(this._vars[_loc3_]):_loc2_ == "string"?String(this._vars[_loc3_]):Boolean(this._vars[_loc3_]);
               }
            }
            if("width" in this._vars || "height" in this._vars)
            {
               this._fitRect = new Rectangle(0,0,Number(this._vars.width),Number(this._vars.height));
               this._fitRect.x = this._vars.centerRegistration?-this._fitRect.width / 2:0;
               this._fitRect.y = this._vars.centerRegistration?-this._fitRect.height / 2:0;
               graphics.beginFill("bgColor" in this._vars?uint(this._vars.bgColor):16777215,"bgAlpha" in this._vars?Number(this._vars.bgAlpha):"bgColor" in this._vars?1:0);
               graphics.drawRect(this._fitRect.x,this._fitRect.y,this._fitRect.width,this._fitRect.height);
               graphics.endFill();
            }
            if(this._loader.content != this)
            {
               (this._loader as Object).setContentDisplay(this);
            }
            this.rawContent = (this._loader as Object).rawContent;
            return;
         }
      }
   }
}
