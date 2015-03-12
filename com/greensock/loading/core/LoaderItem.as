package com.greensock.loading.core
{
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.LoaderStatus;
   
   public class LoaderItem extends LoaderCore
   {
      
      public function LoaderItem(param1:*, param2:Object = null) {
         super(param2);
         this._request = param1 is URLRequest?param1 as URLRequest:new URLRequest(param1);
         this._url = this._request.url;
      }
      
      protected static var _cacheID:uint = uint(Math.random() * 100000000) * int(Math.random() * 1000);
      
      protected var _url:String;
      
      protected var _request:URLRequest;
      
      protected var _scriptAccessDenied:Boolean;
      
      protected var _auditStream:URLStream;
      
      protected var _preferEstimatedBytesInAudit:Boolean;
      
      protected var _httpStatus:int;
      
      protected function _prepRequest() : void {
         this._scriptAccessDenied = false;
         this._httpStatus = 0;
         this._closeStream();
         if((this.vars.noCache) && (!_isLocal || this._url.substr(0,4) == "http"))
         {
            this._request.url = this._url + (this._url.indexOf("?") == -1?"?":"&") + "cacheBusterID=" + _cacheID++;
         }
      }
      
      override protected function _dump(param1:int = 0, param2:int = 0, param3:Boolean = false) : void {
         this._closeStream();
         super._dump(param1,param2,param3);
      }
      
      override public function auditSize() : void {
         if(this._auditStream == null)
         {
            this._auditStream = new URLStream();
            this._auditStream.addEventListener(ProgressEvent.PROGRESS,this._auditStreamHandler,false,0,true);
            this._auditStream.addEventListener(Event.COMPLETE,this._auditStreamHandler,false,0,true);
            this._auditStream.addEventListener("ioError",this._auditStreamHandler,false,0,true);
            this._auditStream.addEventListener("securityError",this._auditStreamHandler,false,0,true);
            this._auditStream.load(this._request);
         }
      }
      
      protected function _closeStream() : void {
         if(this._auditStream != null)
         {
            this._auditStream.removeEventListener(ProgressEvent.PROGRESS,this._auditStreamHandler);
            this._auditStream.removeEventListener(Event.COMPLETE,this._auditStreamHandler);
            this._auditStream.removeEventListener("ioError",this._auditStreamHandler);
            this._auditStream.removeEventListener("securityError",this._auditStreamHandler);
            try
            {
               this._auditStream.close();
            }
            catch(error:Error)
            {
            }
            this._auditStream = null;
         }
      }
      
      protected function _auditStreamHandler(param1:Event) : void {
         if(param1 is ProgressEvent)
         {
            _cachedBytesTotal = (param1 as ProgressEvent).bytesTotal;
            if((this._preferEstimatedBytesInAudit) && uint(this.vars.estimatedBytes) > _cachedBytesTotal)
            {
               _cachedBytesTotal = uint(this.vars.estimatedBytes);
            }
         }
         else if(param1.type == "ioError" || param1.type == "securityError")
         {
            if("alternateURL" in this.vars && !(this._url == this.vars.alternateURL))
            {
               this._url = this._request.url = this.vars.alternateURL;
               this._auditStream.load(this._request);
               _errorHandler(param1);
               return;
            }
            super._failHandler(param1);
         }
         
         _auditedSize = true;
         this._closeStream();
         dispatchEvent(new Event("auditedSize"));
      }
      
      override protected function _failHandler(param1:Event) : void {
         if("alternateURL" in this.vars && !(this._url == this.vars.alternateURL))
         {
            this.url = this.vars.alternateURL;
            _errorHandler(param1);
         }
         else
         {
            super._failHandler(param1);
         }
      }
      
      protected function _httpStatusHandler(param1:Event) : void {
         this._httpStatus = (param1 as Object).status;
         dispatchEvent(new LoaderEvent(LoaderEvent.HTTP_STATUS,this));
      }
      
      public function get url() : String {
         return this._url;
      }
      
      public function set url(param1:String) : void {
         var _loc2_:* = false;
         if(this._url != param1)
         {
            this._url = this._request.url = param1;
            _loc2_ = Boolean(_status == LoaderStatus.LOADING);
            this._dump(0,LoaderStatus.READY,true);
            if(_loc2_)
            {
               _load();
            }
         }
      }
      
      public function get request() : URLRequest {
         return this._request;
      }
      
      public function get httpStatus() : int {
         return this._httpStatus;
      }
      
      public function get scriptAccessDenied() : Boolean {
         return this._scriptAccessDenied;
      }
   }
}
