package cc.hl.view.lens{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import ui.LensBtn1;
	import ui.LensBtn2;
	import ui.LensBtn3;
	import ui.LensBtn4;

	public class LensButton extends Sprite{

		private var _btn:*;
		public var _index:int;
		private var _animate:TweenLite;

		public function LensButton(index:int=0){
			super();
			//this._btn.index.text = index;
			if(index == 0){
				this._btn = new LensBtn1();
			}
			else if(index == 1){
				this._btn = new LensBtn2();
			}
			else if(index == 2){
				this._btn = new LensBtn3();
			}
			else if(index == 3){
				this._btn = new LensBtn4();
			}			
			this.addListener();
			this.onUnSelected();
			this._index = index;
			(this._btn as MovieClip).gotoAndStop(1);
			addChild(this._btn);
		}


		protected function addListener():void{
			if(!this._btn.hasEventListener(MouseEvent.CLICK)){
				this._btn.addEventListener(MouseEvent.CLICK, this.onBtnClicked);
				this._btn.addEventListener(MouseEvent.MOUSE_OVER, this.onBtnMoved);
				this._btn.addEventListener(MouseEvent.MOUSE_OUT, this.onBtnOutted);
			}
		}

		protected function removeListener():void{
			if(this._btn.hasEventListener(MouseEvent.CLICK)){
				this._btn.removeEventListener(MouseEvent.CLICK, this.onBtnClicked);
				this._btn.removeEventListener(MouseEvent.MOUSE_OVER, this.onBtnMoved);
				this._btn.removeEventListener(MouseEvent.MOUSE_OUT, this.onBtnOutted);	
			}	
		}

		protected function onBtnClicked(e:MouseEvent):void{
			(this._btn as MovieClip).gotoAndStop(3);
		}

		protected function onBtnMoved(e:MouseEvent):void{
			(this._btn as MovieClip).gotoAndStop(2);
		}

		protected function onBtnOutted(e:MouseEvent):void{
			(this._btn as MovieClip).gotoAndStop(1);
		}

		public function onSelected():void{
			this.removeListener();
			(this._btn as MovieClip).gotoAndStop(3);
		}

		public function onUnSelected():void{
			this.addListener();
			(this._btn as MovieClip).gotoAndStop(1);
		}


		public function animateShow(){
			if(this._animate){
				this._animate.kill();
			}

			this._animate = TweenLite.to(this,0.5,{
				"scaleX":1,
				"ease":Cubic.easeOut
			});
		}

		public function animateHide(){
			if(this._animate){
				this._animate.kill();
			}

			this._animate = TweenLite.to(this,0.5,{
				"scaleX":0,
				"ease":Cubic.easeOut
			});			
		}
	}
}