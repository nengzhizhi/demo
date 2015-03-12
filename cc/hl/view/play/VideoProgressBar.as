package cc.hl.view.play{

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import ui.ProgressDragBar;
	import util.SkinEvent;

	public class VideoProgressBar extends Sprite{

		public static const NORMAL_HEIGHT:int = 3;
		public static const OVER_HEIGHT:int = 5;

		private var _bar:*;
		private var _position:Number = 0;
		private var _buffer:Number = 0;
		private var min:Number = 0;
		private var max:Number = 1;
		protected var isDragging:Boolean = false;
		public var totalTime:Number = 0;


		public function VideoProgressBar(){
			this._bar = new ProgressDragBar();
			this._bar.buffered.width = 0;
			addChild(this._bar);
			this._bar.spot.visible = false;
			addEventListener(MouseEvent.ROLL_OUT, this.onOut);
			addEventListener(MouseEvent.ROLL_OVER, this.onOver);			
			addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
		}

		protected function onOver(e:MouseEvent):void{
			this.setHeight(OVER_HEIGHT);
			this._bar.spot.visible = true;
		}

		protected function onOut(e:Event):void{
			if(!isDragging){
				this.setHeight(NORMAL_HEIGHT);
				this._bar.spot.visible = false;
			}
		}

		public function setWidth(w:int):void{
			this._bar.bg.width = w;
			this.position = this._position;
			this.drawSensingRange(12);
		}

		public function setHeight(h:int):void{
			this._bar.bg.height = h;
			this._bar.progressed.height = h;
			this._bar.spot.y = (this._bar.bg.height / 2);
			this.drawSensingRange(12);
		}

		public function get buffer():Number{
			return this._buffer;
		}

		public function set buffer(bp:Number):void{
			if(bp < 0){
				bp = 0;
			}
			if(bp > 1){
				bp = 1;
			}
			this._buffer = bp;
			this._bar.buffered.width = this._bar.bg.width * bp;
		}

		public function get position():Number{
			return (this.min + (this._position * (this.max - this.min)));
		}

		public function set position(p:Number):void{
			if(!this.isDragging){
				this._position = ((p - this.min) / (this.max - this.min));
				this._bar.spot.x = this._bar.bg.width * this._position;
				this._bar.progressed.width = this._bar.spot.x;
			}
		}

		protected function onMouseDown(e:MouseEvent):void{
			if(mouseX <= this._bar.bg.width && mouseX >= 0){
				this._bar.spot.x = mouseX;
			}
			this.onMouseMove(e);
			this._bar.spot.startDrag(true, new Rectangle(0, this._bar.spot.y, this._bar.bg.width, 0));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			this.isDragging = true;			
		}

		protected function onMouseMove(e:MouseEvent):void{
			var _loc2_:Number = (this._bar.spot.x / this._bar.bg.width);
			if(_loc2_ < 0){
				_loc2_ = 0;
			}
			if(_loc2_ > 1){
				_loc2_ = 1;
			}
			this._position = _loc2_;
			this._bar.progressed.width = (this._bar.bg.width * this._position);

			if(e){e.updateAfterEvent();}
		}

		protected function onMouseUp(e:MouseEvent):void{
			this._bar.spot.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
			this.isDragging = false;
			dispatchEvent(new SkinEvent(SkinEvent.SKIN_PROGRESS_ADJUST_COMPLETE));
		}

		protected function drawSensingRange(_arg1:int):void{
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, (-((_arg1 - this._bar.bg.height)) / 2), this._bar.bg.width, _arg1);
			this.graphics.endFill();
		}		
	}
}