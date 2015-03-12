package cc.hl.model.video{

    import flash.geom.*;
    import flash.events.*;
    import flash.display.*;
    import flash.net.*;
	import flash.media.*;
	import util.*;
	import cc.hl.model.video.base.*;
	import cc.hl.model.video.interfaces.*;

	public class VideoProvider extends Sprite implements IVideoProvider {
		

		protected var _video;
		//stage video 使用stage Video可以加速渲染
		protected var _useStageVideo:Boolean;
		protected var _videoInfo:VideoInfo;
		protected var _isInit:Boolean = false;

		protected var _switchFlag:Boolean = false;
		protected var _width:Number = 0;
		protected var _height:Number = 0;

		protected var _ratioType:int = 0;
        protected var _volume:Number = 100;
        //用于静音时记录上次时间
        protected var _volumeBak:Number = 100;
        protected var _loop:Boolean = false;
        protected var _playing:Boolean = true;


		public function VideoProvider(videoInfo:VideoInfo){
			this._videoInfo = videoInfo;

			this._useStageVideo = false;

			this._video = new Video();
			this._video.smoothing = true;
			addChild(this._video);
		}

		//配置修改时 尝试切换video渲染方式
		protected function onSetConfig(_arg1:Object):void{
			if (_arg1["try_hardware_accelerate"] != null){
				this.switchVideo(_arg1["try_hardware_accelerate"]);
			};
		}
		protected function onNsReady(e:Event):void{
			if (!this._isInit){
				this._isInit = true;
				this._video.attachNetStream(this.ns);
				//video provider init
				dispatchEvent(new Event("VP_INIT"));
			}

			if(this._switchFlag){
				this._switchFlag = false;
			}
		}

		protected function onPlayEnd(e:Event):void{
			dispatchEvent(new Event("VP_PLAY_END"));
		}

		protected function onStageVideoAvailability(_arg1):void{
		}

		//TODO
		//切换video
		protected function switchVideo(isUseStageVideo:Boolean):void{

			if(isUseStageVideo){
				return;
			}

			if(this._useStageVideo != isUseStageVideo){
				this._useStageVideo = isUseStageVideo;

				if(isUseStageVideo){
					//Log.info("use stage video!");
				}
				else{
					//Log.info("use normal video!");
				}
				this.resize(this._width, this._height);
			}
		}

		protected function get ns():NetStream{
			return null;
		}		
		protected function switchRate(_arg1:int):void{
		}
		public function start(_arg1:Number=0):void{
		}

        public function resize(w:Number, h:Number):void{
            this._width = w;
            this._height = h;
            this.setVideoRatio(this._ratioType);
        }

		public function setVideoRatio(ratioType:int):void {
			this._ratioType = ratioType;
			if(this._video == null){
				return;
			}

			var _local2:int = ((((this._video.videoWidth) || (((("meta" in this.ns)) && (this.ns["meta"].width))))) || (this._width));
			var _local3:int = ((((this._video.videoHeight) || (((("meta" in this.ns)) && (this.ns["meta"].height))))) || (this._height));
			switch (ratioType) {
				case 0:
					break;
				case 1:
					_local3 = ((_local2 * 3) / 4);
					break;
				case 2:
					_local3 = ((_local2 * 9) / 16);
					break;
				case 3:
					_local2 = this._width;
					_local3 = this._height;
					break;
			}

			var _local4:Rectangle = Util.getCenterRectangle(new Rectangle(0, 0, this._width, this._height), new Rectangle(0, 0, _local2, _local3));
			
			if ((this._video is StageVideo)){
				this._video.viewPort = _local4;
			} else {
				this._video.x = _local4.x;
				this._video.y = _local4.y;
				//this._video.x = (GlobalData.root.stage.stageWidth - this._width)/2;
				//this._video.y = (GlobalData.root.stage.stageHeight - this._height)/2;
				this._video.width = _local4.width;
				this._video.height = _local4.height;
			}
		}

		public function getVideoInfo():String{
			return null;
		}

		//静音开关
		public function toggleSilent(isSilent:Boolean):void{
			if (isSilent){
				this._volumeBak = (((this._volume == 0)) ? 50 : this._volume);
				this.volume = 0;
			} else {
				this.volume = this._volumeBak;
			};
		}

		public function get playing():Boolean{
			return (this._playing);
		}

		//设置播放或者暂停
		public function set playing(_arg1:Boolean):void{
			if (_arg1 != this._playing){				
				this._playing = _arg1;
				
				if (this._playing){
					this.ns.resume();
				} else {
					this.ns.pause();
				}
			}
		}

		public function get volume():Number{
			return (this._volume);
		}
		public function set volume(_arg1:Number):void{
			this._volume = _arg1;
			this.ns.soundTransform = new SoundTransform((this._volume / 100));
		}
        public function get time():Number{
            return (0);
        }
        public function set time(_arg1:Number):void{
        }
        public function get buffTime():Number{
            return (0);
        }
        public function get buffPercent():Number{
            return (0);
        }
        public function get buffering():Boolean{
            return (false);
        }
        public function get loop():Boolean{
            return (this._loop);
        }
        public function set loop(_arg1:Boolean):void{
            this._loop = _arg1;
        }
        public function get videoLength():Number{
            return (0);
        }							
	}
}