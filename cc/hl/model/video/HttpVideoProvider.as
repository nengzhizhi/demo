package cc.hl.model.video{

    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
	import flash.utils.*;
	import flash.system.*;
	import cc.hl.model.video.base.*;
	import cc.hl.model.video.part.*;
	import util.*;

	public class HttpVideoProvider extends VideoProvider {

		private var nc:NetConnection;
		private var nss:Vector.<PartNetStream>;
		private var currentPlay:int = -1;
		private var currentLoad:int = -1;
		private var playOffset:Number = 0;
		private var loadOffset:Number = 0;
		private var checkTimer:Timer;

		public function HttpVideoProvider(videoInfo:VideoInfo){
			super(videoInfo);

			this.nc = new NetConnection();
			this.nc.connect(null);
			this.nss = new Vector.<PartNetStream>(_videoInfo.count);
			var i:int = 0;
			while(i < videoInfo.count) {
				if(_videoInfo.fileType == "flv"){
					this.nss[i] = new FLVPartNetStream(this.nc);
				}else{
					this.nss[i] = new FLVPartNetStream(this.nc);
				}

				this.nss[i].addEventListener("NS_READY", onNsReady);
				this.nss[i].addEventListener("NS_PLAY_END", this.onPlayEnd);
				//TODO
				//this.nss[i].addEventListener("NS_ERROR", this.onNsError);				

				i++;
			}
			this.checkTimer = new Timer(10000);
			this.checkTimer.addEventListener(TimerEvent.TIMER, this.checkLoad);
		}
		override protected function onPlayEnd(_arg1:Event):void{
			var _local2:int = (this.currentPlay + 1);
			if (_local2 == _videoInfo.count){
				dispatchEvent(new Event("VP_PLAY_END"));
			} else {
				this.switchNs(_local2);
			};
		}
		override public function start(startTime:Number=0):void{
			this.time = startTime;
			this.checkTimer.start();
		}

		override protected function get ns():NetStream{
			return (this.nss[this.currentPlay]);
		}

		private function load(index:int, startTime:Number=0, isPlay:Boolean=false):void{
			var ns:* = null;
			var i:int = 0;
			var bytes:* = 0;

			if (index >= 0 && index < _videoInfo.count){
				if (this.currentLoad != index){
					//$.jscall("console.log", "load 1");
					if(this.currentLoad != -1){
                        if (!this.nss[this.currentLoad].bufferFinish){
                            this.nss[this.currentLoad].close();
                        };
					}

					this.loadOffset = 0;
					i = 1;
					while (i <= index) {
						this.loadOffset = this.loadOffset + (_videoInfo.vtimes[i] / 1000);
						i = i + 1;
					}
					this.currentLoad = index;
				}
				ns = this.nss[this.currentLoad];

				if (startTime <= 1){
					//$.jscall("console.log", "load 2");
					_videoInfo.getPartVideoInfo(function (pvi:PartVideoInfo):void{
						ns.load(pvi, isPlay);
					}, index, 0);
				} else {
					if (_videoInfo.useSecond){
						//$.jscall("console.log", "load 3");
						_videoInfo.getPartVideoInfo(function (pvi:PartVideoInfo):void{
							ns.load(pvi, isPlay, startTime);
						}, index, startTime);
					} else {
						if (ns.canSearchByte()){
							//$.jscall("console.log", "load 4");
							bytes = ns.searchByte(startTime);
							_videoInfo.getPartVideoInfo(function (pvi:PartVideoInfo):void{
								ns.load(pvi, isPlay, startTime);
							}, index, bytes);							
						} else {
							//$.jscall("console.log", "load 5");
							_videoInfo.getPartVideoInfo(function (pvi:PartVideoInfo):void{
								var bytes:* = 0;
								//var pvi:* = _arg1;
								if (ns.ready){
								    bytes = ns.searchByte(startTime);
								    if (bytes > 0){
								        load(index, startTime, isPlay);
								    };
								} else {
								    ns.addEventListener("NS_READY", function ():void{
								        ns.removeEventListener("NS_READY", arguments.callee);
								        var _local2:int = ns.searchByte(startTime);
								        if (_local2 > 0){
								            load(index, startTime, isPlay);
								        };
								    });
								    ns.load(pvi, isPlay, startTime);
								};
							}, index, 0);
						}
					}
				}
			}
		}


		private function switchNs(index:int, startTime:Number=0):void{
			if(index >= _videoInfo.count){
				return;
			}

			if (this.currentPlay != index){
				if(this.currentPlay != -1){
					if(this.nss[this.currentPlay].fullReady){
						this.nss[this.currentPlay].seek(0);
					}
					this.nss[this.currentPlay].pause();
				}

				this.currentPlay = index;
				this.playOffset = 0;

				var i:int = 1;
				while(i <= index ){
					this.playOffset = this.playOffset + (_videoInfo.vtimes[i] / 1000);
					i++;
				}

				_video.attachNetStream(this.nss[index]);
				volume = _volume;
			}

			var partNetStream:PartNetStream = this.nss[index];
			startTime = partNetStream.getRealSeekTime(startTime);

			//if(_videoInfo.disableSeekJump){
				//TODO
			//} else {
				if (partNetStream.canSeek(startTime)){
					partNetStream.seek(startTime);
					if(_playing){
						partNetStream.resume();
					}
				} else {
			
					this.load(index, startTime, _playing);
				}

			//}
		}

		private function checkLoad(e:TimerEvent):void{
			
			if (_isInit){
				this.clearMemory();
				if (((this.nss[this.currentLoad].bufferFinish) && ((((System.totalMemory < GlobalData.MAX_USE_MEMORY_ARRAY[2])) || ((this.currentLoad == this.currentPlay)))))){
				//if (this.nss[this.currentLoad].bufferFinish && this.currentLoad == this.currentPlay){
					this.load(this.currentLoad + 1);
				}
			}
			
		}

			
		private function clearMemory():void{
            var _local2:int;
            var _local3:Array;
            var _local4:int;
            var _local1:int = GlobalData.MAX_USE_MEMORY_ARRAY[2];
            if (System.totalMemory > _local1){
                _local3 = [];
                _local2 = 0;
                while (_local2 < _videoInfo.count) {
                    if (((((((((this.nss[_local2].ready) && (!((_local2 == this.currentLoad))))) && (!((_local2 == this.currentPlay))))) && (!((_local2 == (this.currentPlay + 1)))))) && (!((_local2 == (this.currentPlay - 1)))))){
                        _local3.push(_local2);
                    };
                    _local2++;
                };
                _local3.sort(this.comparePart);
                _local2 = 0;
                while (_local2 < _local3.length) {
                    _local4 = _local3[_local2];
                    if ((((this.currentPlay > _local4)) || ((this.currentLoad < _local4)))){
                        Log.debug("clear index : ", _local4);
                        this.nss[_local4].close();
                        if (System.totalMemory < _local1){
                            break;
                        };
                    };
                    _local2++;
                };
            };
        }
        private function comparePart(_arg1:int, _arg2:int):int{
            if (this.nss[_arg1].fullReady != this.nss[_arg2].fullReady){
                if (!this.nss[_arg1].fullReady){
                    return (-1);
                };
                return (1);
            };
            if (_arg1 < _arg2){
                if (_arg1 > this.currentPlay){
                    return (1);
                };
                return (-1);
            };
            if (_arg2 > this.currentPlay){
                return (-1);
            };
            return (1);
        }
	
        override public function get buffPercent():Number{
            if (((this.nss) && (this.nss[this.currentPlay]))){
                return ((this.nss[this.currentPlay].bufferLength / this.nss[this.currentPlay].bufferTime));
            };
            return (0);
        }
        override public function get buffTime():Number{
            if (this.currentPlay > this.currentLoad){
                return ((this.playOffset + this.nss[this.currentPlay].bufferSeconds));
            };
            return ((this.loadOffset + this.nss[this.currentLoad].bufferSeconds));
        }
        override public function get buffering():Boolean{
            return (this.nss[this.currentPlay].buffering);
        }

		override public function set time(t:Number):void{
			var positions:Array;

			if(_videoInfo.count == 1){
				this.switchNs(0, int(t));
			} else {
				positions = _videoInfo.getIndexOfPosition(int(t));
				this.switchNs(positions[0], positions[1]);
			}
		}

		override public function get time():Number{
			return this.playOffset + this.nss[currentPlay].time;
		}

		
		override public function get videoLength():Number{
			return ((_videoInfo.totalTime) || (this.nss[this.currentPlay].duration));
		}
	}
}