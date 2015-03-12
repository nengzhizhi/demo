package cc.hl.view.lens{

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import util.*;
	import flash.display.MovieClip;
	
	import cc.hl.model.video.VideoManager;
	import ui.LensControl;

	public class LensView extends Sprite{

		private var _lensCount:int = 0;
		private var _lensTitles:Array;
		private var _lensBtns:Array;

		private var _lensControl:LensControl;
		private var _isSwitchDragging:Boolean = false;
		private var _lensBtnsState:String = "hiding";
		private var _currentLensInx:int = 0;

		public static const VIDEO_WIDTH:Number = 192;
		public static const VIDEO_HEIGHT:Number = 108;

		public function LensView(){
			super();
		}

		public function lensInit(o:Object):void{
			this._lensControl = new LensControl();
			this._lensControl.videoBg.visible = false;

			addChild(this._lensControl);

			this._lensTitles = [];
			this._lensBtns = [];
			this._lensCount = o.length;

			
			var i:int = 0;
			while(i < o.length){
				this._lensTitles[i] = o[i].title;
				this._lensBtns[i] = new LensButton(i);


				if(i == VideoManager.instance.currentVideoInx){
					this._lensBtns[i].onSelected();
				}

				this._lensBtns[i].addEventListener(MouseEvent.CLICK, function(e:MouseEvent){
					var index:int = e.target.parent._index;

					if(index != VideoManager.instance.currentVideoInx){
						dispatchEvent(new SkinEvent(SkinEvent.SKIN_LENS_CLICKED,index));
						
						_lensBtns[VideoManager.instance.currentVideoInx].onUnSelected();
						_lensBtns[index].onSelected();
						_lensControl.videoBg.visible = false;
						VideoManager.instance.currentVideoInx = index;
					}
				});

				this._lensBtns[i].addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent){
					var index:int = e.target.parent._index;

					if(index != VideoManager.instance.currentVideoInx){
						Mouse.cursor="button";
						_lensControl.videoBg.addChild(VideoManager.instance.video(index));
						VideoManager.instance.video(index).resize(VIDEO_WIDTH, VIDEO_HEIGHT);
						VideoManager.instance.video(index).x = 2;
						VideoManager.instance.video(index).y = 2;
						_currentLensInx = index;

						_lensControl.videoBg.title.t.text = _lensTitles[index];
						_lensControl.videoBg.y = _lensBtns[index].y - _lensControl.videoBg.height/2;
						_lensControl.videoBg.visible = true;
					}
				});

				this._lensBtns[i].addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent){
					Mouse.cursor="auto";
					_lensControl.videoBg.visible = false;
				});

				this._lensControl.addChild(this._lensBtns[i]);
				
				this._lensBtns[i].x = this._lensControl.switchBtn.x;
				this._lensBtns[i].y = this._lensControl.switchBtn.y + 57 + i*45;
				this._lensBtns[i].scaleX = 0;
				i++;

				this.bindSwitchDrag();	
			}

			
			this._lensControl.switchBtn.addEventListener(MouseEvent.CLICK, onSwitchBtnClicked);


		}
		
		private function onSwitchBtnClicked(e:MouseEvent) : void{
			if(this._isSwitchDragging){
				this._isSwitchDragging = false;
				return;
			}

			if(_lensBtnsState == "hiding"){
				_lensBtnsState = "showing";
				showLensBtns();
			}
			else if(_lensBtnsState == "showing"){
				_lensBtnsState = "hiding";
				hideLensBtns();
			}
		}		

		private function showLensBtns():void{
			for(var i:int = 0; i < this._lensCount; i++){
				this._lensBtns[i].animateShow();
			}
		}

		private function hideLensBtns():void{
			for(var i:int = 0; i < this._lensCount; i++){
				this._lensBtns[i].animateHide();
			}
		}

		private function bindSwitchDrag() : void {
			var startSwitchDrag:Function = null;
			var endSwitchDrag:Function = null;
			var switchDrag:Function = null;

			var mouseX_Offset:Number = 0;
			var mouseY_Offset:Number = 0;

			startSwitchDrag = function(param:MouseEvent):void{
				mouseX_Offset = stage.mouseX - x;
				mouseY_Offset = stage.mouseY - y;

				stage.addEventListener(MouseEvent.MOUSE_MOVE,switchDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP,endSwitchDrag);
			};
			endSwitchDrag = function(param:MouseEvent):void{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,switchDrag);
				stage.removeEventListener(MouseEvent.MOUSE_UP,endSwitchDrag);
			};
			switchDrag = function(param:MouseEvent):void{
				if(stage.mouseX > stage.stageWidth - 50){
					x = stage.stageWidth - 50;
				}
				else if(stage.mouseX < 230){
					x = 230;
				}
				else{
					x = stage.mouseX - mouseX_Offset;
				}

				if(stage.mouseY > stage.stageHeight - 200){
					y = stage.stageHeight - 200
				}
				else if(stage.mouseY < 100){
					y = 100;
				}
				else{
					y = stage.mouseY - mouseY_Offset;
				}

				_isSwitchDragging = true;
			}

			this._lensControl.switchBtn.addEventListener(MouseEvent.MOUSE_DOWN,startSwitchDrag);
		}


		public function resize(w:Number,h:Number):void{		
		}

	}
}