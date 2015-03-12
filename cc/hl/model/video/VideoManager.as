package cc.hl.model.video{

    import flash.geom.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.display.*;
    import flash.net.*;
	import flash.media.*;
	import util.*;
	import cc.hl.model.video.base.*;
	import cc.hl.model.video.interfaces.*;
	import cc.hl.model.video.platform.*;

	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class VideoManager
	{
		private var _videoProviders:Array;
		private var _videoInfos:Array;
		private var _videoIds:Array;
		public var _videoCount:int = 0;
		private var _currentVideoIndex:int = 0;
		private var _playing:Boolean = true;
		private var sendTimer:Timer;

		public function VideoManager():void{}

		public function init(o:Object):void{
			this._videoProviders = [];
			this._videoInfos = [];
			this._videoIds = [];
			this._videoCount = o.length;

			var i:int = 0;
			while(i < o.length)	{
				this._videoIds[i] = o[i].vid;
				this._videoInfos[i] = new YoukuHacker(o[i].vid, i);

				this._videoInfos[i].addEventListener(Event.COMPLETE, function(e:Event):void{
					var index:int = e.target._index;
					var arguments:* = arguments;
					_videoInfos[index].removeEventListener(Event.COMPLETE, arguments.callee);

					_videoProviders[index] = new HttpVideoProvider(_videoInfos[index]);
					_videoProviders[index].start(0);
					_videoProviders[index].volume = 0;

					if(index == 0){
						sendTimer = new Timer(500);
						sendTimer.addEventListener(TimerEvent.TIMER, sendLoop);
						sendTimer.start();
						sendNotification(Order.Video_Show_Request,{"videoIndex":0});
					}
				});

				i++;
			}
		}

		private static var _instance:VideoManager = null;

		private function sendLoop(te:TimerEvent=null):void{
			var playedSecond:Number = this._videoProviders[0].time;
			var videoLength:Number = this._videoProviders[0].videoLength;
			//这里一定要获取buffTime，读取buffTime时会修改bufferFinish，进而判断是否继续载入
			for(var i:int = 0;i < _videoCount; i++){
				var b:Number = this._videoProviders[i].buffTime;
			}
			sendNotification(Order.Play_PlayedSecond_Request, {"playedSecond":playedSecond + 0.5});
			sendNotification(Order.Play_VideoLength_Request, {"videoLength":videoLength});
			sendNotification(Order.Demo_Timer_Request, {"playedSecond":playedSecond + 0.5});
		}

		public static function get instance() : VideoManager{
			if(_instance == null){
				_instance = new VideoManager();
			}
			return _instance;
		}

		public function get time() : Number{
			return this.currentVideo.time;
		}

		public function set currentVideoInx(inx:int) : void{	
			this._currentVideoIndex = inx;
		}

		public function get currentVideoInx() : int{
			return this._currentVideoIndex;
		}


		public function get playing():Boolean{
			return (this._playing);
		}

		public function get currentVideo():VideoProvider{
			return _videoProviders[_currentVideoIndex];
		}

		public function set playing(arg:Boolean):void{
			if(arg != this._playing){
				this._playing = arg;

				for(var i:int = 0; i < _videoCount; i++){
					_videoProviders[i].playing = _playing;
				}
			}
		}

		public function video(index:int) : VideoProvider{
			if(index < 0 || index >= _videoCount){
				return null;
			}
			else{
				return this._videoProviders[index];
			}
		}

		public static function sendNotification( message:String, obj:Object = null ):void
		{
			var facade:IFacade = Facade.getInstance();
			facade.sendNotification( message, obj );
		}		
	}
}