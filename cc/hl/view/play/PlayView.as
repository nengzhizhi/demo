package cc.hl.view.play{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import util.SkinEvent;
	import ui.ControlBar;


	
	public class PlayView extends Sprite{

		public function PlayView(){
			super();
		}
		
		public static const SKIN_HEIGHT:Number = 40;
		public static const VOLUME_BAR_MAX:Number = 82;
		public static const SKIN_SHOW_THRESHOLD:int = 200;
		
		private var _isSilent:Boolean = false;
		private var _isDanmuShowing:Boolean = true;
		public var _controlBar:ControlBar;
		private var _volume:Number;
		public var _progressBar:VideoProgressBar;
		public var _totalLength:Number = 0;



		public function get volume():Number{
			return this._volume;
		}

		public function set volume(param1:Number): void{
			var _loc2_:* = NaN;
			if(param1 != this._volume){
				if(param1 != this._volume){
					if(param1 < 0){
						param1 = 0;
					}
					if(param1 > 1){
						param1 = 1;
					}
					this._volume = param1;
					_loc2_ = param1 * VOLUME_BAR_MAX;
					this._controlBar.volumeBar.tg.x = _loc2_;
					this._controlBar.volumeBar.slider.width = _loc2_;

					if(this._volume == 0){
						this._isSilent = true;
						if((this._controlBar.volumeBtm as MovieClip).currentFrame == 1){
							(this._controlBar.volumeBtm as MovieClip).gotoAndStop(2);
						}
					}
					else{
						this._isSilent = false;
						if((this._controlBar.volumeBtm as MovieClip).currentFrame == 2){
							(this._controlBar.volumeBtm as MovieClip).gotoAndStop(1);
						}						
					}

					dispatchEvent(new SkinEvent(SkinEvent.SKIN_VOLUME_CHANGE,param1));
				}
			}
		}

		public function vLength(vl:Number):void{
		}

		public function initView():void{
			if(this._controlBar == null){
				this._controlBar = new ControlBar();

				this._controlBar.playBtn.visible = false;
				this._controlBar.pauseBtn.visible = true;
				this._controlBar.reloadBtn.visible = true;
				this._controlBar.fullScreenBtn.visible = true;
				this._controlBar.normalScreenBtn.visible = false;
				this._controlBar.danmuShowBtn.visible = false;
				this._controlBar.danmuHideBtn.visible = true;


				this._controlBar.playBtn.addEventListener(MouseEvent.CLICK,this.onPlayBtnClicked);
				this._controlBar.reloadBtn.addEventListener(MouseEvent.CLICK,this.onReloadBtnClicked);
				this._controlBar.volumeBtm.addEventListener(MouseEvent.CLICK,this.onVolumeBtmClicked);				
				(this._controlBar.volumeBtm as MovieClip).buttonMode = true;
				(this._controlBar.volumeBtm as MovieClip).gotoAndStop(1);
				(this._controlBar.danmuTag as MovieClip).buttonMode = true;
				(this._controlBar.danmuTag as MovieClip).gotoAndStop(1);
				this._controlBar.pauseBtn.addEventListener(MouseEvent.CLICK,this.onPauseBtnClicked);
				
				this._controlBar.danmuShowBtn.addEventListener(MouseEvent.CLICK,this.onDanmuShowBtnClicked);
				this._controlBar.danmuHideBtn.addEventListener(MouseEvent.CLICK,this.onDanmuHideBtnClicked);
				this._controlBar.fullScreenBtn.addEventListener(MouseEvent.CLICK,this.onFullScreenBtnClicked);
				this._controlBar.normalScreenBtn.addEventListener(MouseEvent.CLICK,this.onNormalScreenBtnClicked);			
				
				this._progressBar = new VideoProgressBar();
				if(!Param.isLive){
					var _loc2_:int = this._controlBar.getChildIndex(this._controlBar.playBtn);
					this._controlBar.addChildAt(this._progressBar, (_loc2_ + 1));
				}

				this.initVolumeBar();
				addChild(this._controlBar);
				addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
			}
		}

		public function resize(param1:Number, param2:Number) :void{
			this._controlBar.bg.width = param1;
			this._progressBar.setWidth(param1);
			this._controlBar.reloadBtn.x = this._controlBar.x + 40;
			this._controlBar.fullScreenBtn.x = param1 - 31;
			this._controlBar.normalScreenBtn.x = this._controlBar.fullScreenBtn.x;

			this._controlBar.danmuTag.x = this._controlBar.fullScreenBtn.x - this._controlBar.danmuTag.width - 20;
			this._controlBar.danmuHideBtn.x = this._controlBar.danmuTag.x - this._controlBar.danmuHideBtn.width - 5;
			this._controlBar.danmuShowBtn.x = this._controlBar.danmuTag.x - this._controlBar.danmuShowBtn.width - 5;
			this._controlBar.volumeBar.x = this._controlBar.danmuHideBtn.x - this._controlBar.volumeBar.width - 25;
			this._controlBar.volumeBtm.x = this._controlBar.volumeBar.x - 31;
		}

		protected function onAddToStage(param1:Event) : void {
			setTimeout(function():void{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,controlBarAnimate);
				stage.addEventListener(Event.MOUSE_LEAVE,controlBarAnimate);
				controlBarAnimate(null);
			},5000);
		}

		private var _animateState:String = "showing";
		private var _controlBarAnimate:TweenLite;
		
		public function controlBarAnimate(event:Event = null) : void{
			if(stage == null){
				return;
			}
			if((event) && (event.type == MouseEvent.MOUSE_MOVE) && stage.stageHeight - stage.mouseY < SKIN_SHOW_THRESHOLD){
				if(this._animateState != "showing"){
					this._animateState = "showing";
					if(this._controlBarAnimate){
						this._controlBarAnimate.kill();
					}
					this._controlBarAnimate = TweenLite.to(this,0.5,{
							"y":stage.stageHeight - this._controlBar.bg.height,
							"alpha":1,
							"ease":Cubic.easeOut
						});
				}
			}
			else if(this._animateState != "hiding"){
				this._animateState = "hiding";
				if(this._controlBarAnimate){
					this._controlBarAnimate.kill();
				}
				this._controlBarAnimate = TweenLite.to(this,0.5,{
						"y":stage.stageHeight,
						"alpha":0,
						"ease":Cubic.easeOut
					});				
			}
		}

		private function initVolumeBar() : void {
			var startVolumeDrag:Function = null;
			var endVolumeDrag:Function = null;
			var volumeDrag:Function = null;

			startVolumeDrag = function(param1:MouseEvent):void{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,volumeDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP,endVolumeDrag);
			};
			endVolumeDrag = function(param1:MouseEvent):void{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,volumeDrag);
				stage.removeEventListener(MouseEvent.MOUSE_UP,endVolumeDrag);				
			};
			volumeDrag = function(param1:MouseEvent):void{
				var _loc2_:Number = _controlBar.volumeBar.mouseX;
				if(_loc2_ < 0){ _loc2_ = 0; }
				if(_loc2_ > VOLUME_BAR_MAX){ _loc2_ = VOLUME_BAR_MAX; }
				volume =  _loc2_ / VOLUME_BAR_MAX;
			};

			this._controlBar.volumeBar.tg.x = VOLUME_BAR_MAX;
			this._controlBar.volumeBar.slider.width = VOLUME_BAR_MAX;
			this._controlBar.volumeBar.tg.addEventListener(MouseEvent.MOUSE_DOWN,startVolumeDrag);
			this._controlBar.volumeBar.addEventListener(MouseEvent.CLICK,volumeDrag);
		}


		protected function onPlayBtnClicked(param1:MouseEvent) : void {
			this._controlBar.playBtn.visible = false;
			this._controlBar.pauseBtn.visible = true;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_PLAY));
		}

		protected function onPauseBtnClicked(param1:MouseEvent) : void {
			this._controlBar.playBtn.visible = true;
			this._controlBar.pauseBtn.visible = false;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_PAUSE));	
		}

		protected function onReloadBtnClicked(param1:MouseEvent) : void {
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_RELOAD));	
		}

		protected function onVolumeBtmClicked(param1:MouseEvent) : void {
			if(this._isSilent){
            	(this._controlBar.volumeBtm as MovieClip).gotoAndStop(1);
           		dispatchEvent(new SkinEvent(SkinEvent.SKIN_SILENT_CANCEL));				
			}
			else{
				(this._controlBar.volumeBtm as MovieClip).gotoAndStop(2);
				dispatchEvent(new SkinEvent(SkinEvent.SKIN_SILENT));				
			}
		}

		protected function onDanmuHideBtnClicked(param1:MouseEvent) : void {
			this._controlBar.danmuShowBtn.visible = true;
			this._controlBar.danmuHideBtn.visible = false;
			(this._controlBar.danmuTag as MovieClip).gotoAndStop(2);
			this._isDanmuShowing = false;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_DANMU_HIDE,this._isDanmuShowing));
		}

		protected function onDanmuShowBtnClicked(param1:MouseEvent) : void {
			this._controlBar.danmuShowBtn.visible = false;
			this._controlBar.danmuHideBtn.visible = true;
			(this._controlBar.danmuTag as MovieClip).gotoAndStop(1);
			this._isDanmuShowing = true;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_DANMU_SHOW,this._isDanmuShowing));
		}

		protected function onFullScreenBtnClicked(param1:MouseEvent) : void {
			this._controlBar.fullScreenBtn.visible = false;
			this._controlBar.normalScreenBtn.visible = true;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_FULLSCREEN));
		}

		protected function onNormalScreenBtnClicked(param1:MouseEvent) : void {
			this._controlBar.fullScreenBtn.visible = true;
			this._controlBar.normalScreenBtn.visible = false;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_NORMALSCREEN));
		}		
	}
}