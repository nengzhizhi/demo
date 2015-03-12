package ui
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import ui.CameraCell;

	public dynamic class CameraGallery extends MovieClip
	{
		private var _cameraCell:CameraCell;
		private var _cameraCells:Array;
		private var _cameraChange:Function;
		private var _count:Number;

		public function CameraGallery() {
			super();
		}

		public function initCameraGallery(n:Number,f:Function){
			this._count = n;
			this._cameraChange = f;
			
			this._cameraCells = new Array();

			for(var i:Number=0;i<4;i++){
				var c:CameraCell = new CameraCell(Param.CameraParams[i].cTitle,i);
				this._cameraCells.push(c);
				addChild(c);
			}

			addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
		}

		public function resize(x:Number,y:Number){
			this.x = x;
			this.y = y;

			
			for(var i:Number=0;i<4;i++){
				this._cameraCells[i].resize((this.width - this._cameraCells[i].width)/2,(i+1)*20+i*20);
			}
		}

		public function onAddToStage(e:Event){
			for(var i:Number=0;i<4;i++){
				this._cameraCells[i].addEventListener(MouseEvent.CLICK,this.onCameraChange);
			}
		}

		private function onCameraChange(e:MouseEvent){
			var targetCell:MovieClip = e.currentTarget as MovieClip;
			this._cameraChange(targetCell.cameraIndex);
		}
	}
}