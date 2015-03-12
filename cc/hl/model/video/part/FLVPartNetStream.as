package cc.hl.model.video.part{
    
	import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
	import cc.hl.model.video.base.*;
	import util.*;

	public class FLVPartNetStream extends PartNetStream {

		protected var checkStartTimeTimer:Timer;
		//FLV中才有，开始时间的偏移值
		protected var _startOffset:Number = 0;
		protected var _filesize:Number = 0;
		protected var _lastPlayTime:Number = 0;

		public function FLVPartNetStream(nc:NetConnection){
			super(nc);
			this.checkStartTimeTimer = new Timer(10);
			this.checkStartTimeTimer.addEventListener(TimerEvent.TIMER, this.onCheckStartTime);			
		}

		protected function onCheckStartTime(timerEvent:TimerEvent):void{
			if (super.time > 0.1 && !(super.time == this._lastPlayTime)){
				this.checkStartTimeTimer.reset();
				realStart = (super.time - this._startOffset);
				realStart = realStart > 1 ? realStart : 0;
				super.onNsReady();
			}
		}

		override public function get time():Number{
			if(!isNaN(realStart)){
				return super.time - this._startOffset;
			}
			return startTime;
		}

		//根据时间定位视频
        override public function seek(_arg1:Number):void{
            var _local2:Number = (_arg1 + this._startOffset);
            var _local3:Number = (bufferSeconds + this._startOffset);
            _local2 = (((_local2 < _local3)) ? _local2 : _local3);
            if (Math.abs((_local2 - super.time)) > 1){
                super.seek(_local2);
            };
        }

		//定位到就近的关键帧
		override public function getRealSeekTime(seekTime:Number):Number{
			var _local1:int;
			if(_meta && _meta.keyframes){
				_local1 = Util.bsearch(_meta.keyframes.times, seekTime + this._startOffset);
				seekTime = _meta.keyframes.times[(_local1 - 1)] - this._startOffset;
			}
			return seekTime;
		}

		override protected function onMetaData(o:Object):void{
			var _local1:Object;
			var _local2:Object;

			this._meta = o;
			this._startOffset = 0;

			if(o.seekpoints){
				_local1 = {
					times:[],
					filepositions:[]
				};

				for each (_local2 in o.seekpoints) {
					_local1.times.push(_local2.time);
					_local1.filepositions.push(_local2.offset);
				}

				o.keyframes = _local1;
			}

			if (_meta.keyframes){
				if (_meta.keyframes.times[1] > 30){
					this._startOffset = _meta.keyframes.times[1];
				}
				this._filesize = o.filesize || o.keyframes.filepositions.slice(-1)[0];
			}
		}

		override protected function reset():void{
			super.reset();
			this.checkStartTimeTimer.reset();
		}

		//获取缓存时间
		override protected function checkBufferWithMeta():Number{
			var _local1:int = Util.bsearch(_meta.keyframes.filepositions, bytesLoaded + (this._filesize - this.bytesTotal));
			return (_meta.keyframes.times[(_local1 - 1)] - this._startOffset);
		}

		override public function load(pVideoInfo:PartVideoInfo, isStartPlay:Boolean=false, startTime:Number=0):void{
			this._lastPlayTime = super.time;
			super.load(pVideoInfo, isStartPlay, startTime);

			
			if(startTime > 0){
				this.checkStartTimeTimer.start();
			}
		}

		//根据时间获取就近的文件位置
		override public function searchByte(seekTime:Number):int{
			var _local1:int;
			if(canSearchByte()){
				if(_meta.keyframes){
					_local1 = Util.bsearch(_meta.keyframes.times, seekTime + this._startOffset);
					if (_local1 != -1){
						return _meta.keyframes.filepositions[(_local1 - 1)];
					}
				}
			}
			return 0;
		}

		override protected function onNsReady():void{
			if((startTime == 0) && (!this.ready)){
				realStart = 0;
				super.onNsReady();
			}
		}

	}
}