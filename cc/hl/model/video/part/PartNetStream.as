package cc.hl.model.video.part{

    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.media.*;
	import cc.hl.model.video.base.*;

	public class PartNetStream extends NetStream{

		//真实的开始时间
		protected var realStart:Number = NaN;
		//配置stream加载完成后是否自动播放
		protected var startPlay:Boolean = false;
		//期望开始的时间
		protected var startTime:Number = 0;
		protected var _meta:Object;
		protected var _partVideoInfo:PartVideoInfo;
		protected var _ready:Boolean = false;
		protected var _bufferFinish:Boolean = false;
		protected var _playFinish:Boolean = false;
		protected var _buffering:Boolean = false;
		protected var _bakSt:SoundTransform;

		public function PartNetStream(nc:NetConnection){
			this._bakSt = new SoundTransform(1);
			super(nc, "connectToFMS");
			this.bufferTime = 1;
			this.client = {onMetaData:this.onMetaData};
			this.addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
		}

		public function get ready():Boolean{
			return (this._ready);
		}

        public function get fullReady():Boolean{
            return (((((this._ready) && ((this.realStart == 0)))) && (this._bufferFinish)));
        }		

		public function get bufferFinish():Boolean{
			return (this._bufferFinish);
		}

		public function get playFinish():Boolean{
			return (this._playFinish);
		}		

		public function get loading():Boolean{
			return (this._ready && !(this._bufferFinish));
		}

		public function get buffering():Boolean{
			return (this._buffering);
		}

		public function get meta():Object{
			return (((this._meta) || ({})));
		}

		public function get partVideoInfo():PartVideoInfo{
			return (this._partVideoInfo);
		}

		public function get duration():Number{
			return (((this._partVideoInfo.duration) || (this.meta.duration)));
		}

		public function get bufferSeconds():Number{
			if (this._ready){
				if (this.bytesLoaded > 0 && this.bytesLoaded == this.bytesTotal){
					if(!this._bufferFinish) {
						this._bufferFinish = true;
						dispatchEvent(new Event("NS_BUFFER_END"));
					}
					return this.duration;
				}

				if(this._meta && this._meta.keyframes){
					return (this.checkBufferWithMeta());
				}
				return (((this.duration * this.bytesLoaded) / this.bytesTotal));
			}
			return 0;
		}

		public function canSearchByte():Boolean{
			return ((this._ready) || (this._meta));
		}

		public function canSeek(pos:Number):Boolean{
			return this._ready && this.bufferSeconds > pos && this.realStart <= pos;
		}

		public function getRealSeekTime(seekTime:Number):Number{
			return seekTime;
		}

		//载入指定的partVideo
		public function load(pvi:PartVideoInfo, isStartPlay:Boolean=false, startTime:Number=0):void{
			this.close();
			this.startPlay = isStartPlay;
			this.startTime = startTime;
			this._partVideoInfo = pvi;

			setTimeout(function():void{
				play(pvi.url);
			},0);
		}

		override public function close():void{
			super.close();
			this.reset();
		}

		protected function onStatus(e:NetStatusEvent):void{
			switch (e.info.code){
				case "NetStream.Play.Start":
					super.soundTransform = new SoundTransform(0);
					this._playFinish = false;
					this.onNsReady();
					break;
				case "NetStream.Buffer.Full":
					this._buffering = false;
					break;
				case "NetStream.Buffer.Empty":
					if (this._playFinish) {
						dispatchEvent(new Event("NS_PLAY_END"));
						} else {
							this._buffering = true;
						}
					break;

				case "NetStream.Play.Stop":
					if (this._ready){
						this._playFinish = true;
					}
					break;

				case "NetStream.Seek.InvalidTime":
					super.seek(e.info.details);
					break;

				case "NetStream.Seek.Failed":
					break;

				case "NetStream.Play.StreamNotFound":
					this.close();
					break;
			}
		}

		protected function reset():void{
			this.realStart = NaN;
			this._ready = false;
			this._bufferFinish = false;
			this._buffering = true;
			this._playFinish = false;
		}

		protected function onNsReady():void{
			if(!this._ready){
				this._buffering = false;
				this._ready = true;
				if(this.startPlay){
					super.soundTransform = this._bakSt;
				}else{
					pause();
				}
				dispatchEvent(new Event("NS_READY"));
			}
		}

		override public function set soundTransform(sound:SoundTransform):void{
			this._bakSt = sound;
			if (this.ready){
				super.soundTransform = sound;
			}
		}

		override public function resume():void{
			super.resume();
			super.soundTransform = this._bakSt;
			this._playFinish = false;
		}

		protected function checkBufferWithMeta():Number{
			throw (new Error((this.toString() + " need override 'checkBufferWithMeta'!")));
		}
		public function searchByte(_arg1:Number):int{
			throw (new Error((this.toString() + " need override 'searchByte'!")));
		}

		protected function onMetaData(_arg1:Object):void{
			throw (new Error((this.toString() + " need override 'onMetaData'!")));
		}		
	}
}