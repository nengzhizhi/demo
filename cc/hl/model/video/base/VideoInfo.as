package cc.hl.model.video.base {
	import flash.events.*;
	import flash.utils.*;
	import util.*;
	import cc.hl.model.video.interfaces.IVideoInfo;

	public class VideoInfo extends EventDispatcher implements IVideoInfo {

		protected static const VIDEO_PARSE_API:String = "http://jiexi.acfun.info/index.php?vid=";

		protected static var VIDEO_RATES_CODE:Array = ["C40", "C30", "C20", "C10"];
		public static var VIDEO_RATES_STRING:Array = ["原画", "超清", "高清", "流畅"];

		protected var _vid:String;
		//视频源类型
		protected var _sourceType:String;
		protected var _fileType:String;
		//视频定位方式，timestamp 或者 关键帧的位置
		protected var _useSecond:Boolean = false;
		protected var _startParamName:String = "start";

		protected var _rawInfo:Object;
		protected var _urlArray:Array;
		protected var _vtimems:Array;
		protected var _rateInfo:Array;
		//当前码率所用索引
		protected var _rate:int = 0;
		protected var _tryTimes:int = 0;
		protected var _success:Boolean = true;
		protected var _disableSeekJump:Boolean = false;

		public function VideoInfo(vid:String, sourceType:String){
			this._rawInfo = {};
			this._urlArray = [];
			this._vtimems = [];
			this._rateInfo = [];
			super();
			this._sourceType = sourceType;
			this._vid = vid;
			this.init();
			//this.load();
		}
		//VideoInfo载入成功
		protected function dispatchComplete():void{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function init():void{
		}

		/*
		//根据vid读取video info
		protected function load(isCache:Boolean=false):void{
			var loader:* = null;

			loader = new BlockLoader(VIDEO_PARSE_API);
			loader.addEventListener(Event.COMPLETE, function():void{
				
				_rawInfo = 
				{
					"code": 200,
					"message": "request success.",
					"success": true,
					"result": {
					"C20": {
			            "quality": "分段_标清_FLV",
			            "totalseconds": 129,
			            "totalbytes": 4631670,
			            "files": [
			                {
			                    "type": "flv",
			                    "seconds": 129,
			                    "bytes": 4631670,
			                    "url": "http://k.youku.com/player/getFlvPath/sid/942311862893212dbf30d_01/st/flv/fileid/030002010054D19540A736045CC724BFF8C2D5-9D80-2059-E083-A6526BF9AC99?K=53dcdfab16bca920282a3942&hd=0&myp=0&ts=129&ypp=2&ctype=12&ev=1&token=8624&oip=3059483240&ep=eyaWGUiMXsgC7Srcij8bM360d3dbXP4J9h%2BFg9JjALshTJy%2BkDvVx%2By3TflCEvxqASUEFJmH3diUaDQRYfk3oWgQ3U6tMPqV%2Fvjg5dxVwZIGFG8%2FA77evVSWRTL1",
			                    "no": 0
			                }
			            ]
			        }
					}
				};
				_rateInfo = [];

				var _local1:int;
				_local1 = 0;

				//读取码率信息
				while (_local1 < VIDEO_RATES_CODE.length) {
					if (VIDEO_RATES_CODE[_local1] in _rawInfo.result){
						_rateInfo.push(_local1);
					}
					_local1++;
				}
				setRate(2, isCache);

			});
		}
		*/

		public function get sourceType():String{
			return (this._sourceType);
		}
		public function get fileType():String{
			return (this._fileType);
		}
		public function get vid():String{
			return (this._vid);
		}
		public function get rawInfo():Object{
			return (this._rawInfo);
		}
		public function get useSecond():Boolean{
			return (this._useSecond);
		}
		public function get status():String{
			return ("");
		}
		public function get rateInfo():Array{
			return (this._rateInfo);
		}
		public function get rate():int{
			return (this._rate);
		}
		public function get rateString():String{
			return (VIDEO_RATES_STRING[this._rate]);
		}
		public function get totalTime():Number{
			return ((this._vtimems[0] / 1000));
		}
		public function get count():int{
			return ((this._vtimems.length - 1));
		}
		public function get urls():Array{
			return (this._urlArray);
		}
		public function get vtimes():Array{
			return (this._vtimems);
		}

		public function getPartVideoInfo(f:Function, index:int, startTime:Number=0):void{
			//TODO 判断当前状态
			if(index >= this._urlArray.length){
				//Log.error("getPartVideoInfo参数错误");
				index = 0;
			}

			var _local1:String = this._urlArray[index];
			var _local2:Number = (this._vtimems[(index + 1)] / 1000);

			if((this._useSecond) && ((_local2 - startTime) < 10)){
				startTime = (_local2 - 10);
			}

			if(startTime > 0){
				_local1 = Util.addUrlParam(_local1, this._startParamName, int(startTime));
			}

			var _local3:PartVideoInfo = new PartVideoInfo(this._rawInfo, index, _local1, _local2, this._tryTimes, this._rate);

			f(_local3);
		}

		//返回值第一个参数对应part索引，第二个参数对应当前part偏移时间
		public function getIndexOfPosition(param1:Number) : Array {
		var _loc4_:* = NaN;
		var _loc2_:Number = 0;
		var _loc3_:* = 1;
		while(_loc3_ < this._vtimems.length)
		{
		_loc2_ = _loc2_ + int(this._vtimems[_loc3_]);
		if(param1 < _loc2_ / 1000)
		{
		_loc4_ = param1 - (_loc2_ - this._vtimems[_loc3_]) / 1000;
		if(_loc4_ < 0.5)
		{
		_loc4_ = 0;
		}
		return [_loc3_ - 1,_loc4_];
		}
		_loc3_++;
		}
		return [0,0];
		}


		//设置指定索引号对应的码率
		public function setRate(rateIndex:int, isCache:Boolean=false):Boolean{
			var _local1:String;
			var _local2:Object;

			if((rateIndex < 0) || (rateIndex > VIDEO_RATES_CODE.length)){
				rateIndex = 0;
			}

			while (rateIndex < VIDEO_RATES_CODE.length) {
				//_local1码率参数,例如："C20"
				_local1 = VIDEO_RATES_CODE[rateIndex];


				if(_local1 in this._rawInfo.result){
					this._rate = rateIndex;
					this._vtimems = [];
					this._urlArray = [];
					this._vtimems.push(this._rawInfo.result[_local1].totalseconds * 1000);

					for each (_local2 in this._rawInfo.result[_local1].files) {
						this._urlArray.push(_local2.url);
						this._vtimems.push(_local2.seconds * 1000);
						this._fileType = _local2.type;
					}

					if(this._fileType == "mp4"){
						this._useSecond = true;
						this._startParamName = "start";
					}
					this.dispatchComplete();
					return true;

					//TODO 發送完成事件
				}
				rateIndex++;
			}
			return false;
		}

		public function refresh():void{
			this._tryTimes ++;

			if(this._tryTimes < 3){
				setTimeout(function():void{
					//load(true);
					init();
				}, 4000);
			} else {
				this._tryTimes = 0;
				//TODO 超过重试次数
				this._success = true;
			}
		}

	}
}