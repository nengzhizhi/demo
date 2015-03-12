package cc.hl.view.marquee{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import ui.MarqueeBg;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import flash.utils.setTimeout;
	import flash.events.MouseEvent;
	import util.$;

	public class MarqueeView extends Sprite{

		public static const SKIN_SHOW_THRESHOLD:int = 200;

		private var _bg:MarqueeBg;
		private var _sponsor:SponsorCell;
		private var _pools:Array;
		private var _marqueeing:Boolean;

		public function MarqueeView(){
			super();
		}

		public function initView():void{
			this._bg = new MarqueeBg();
			this._pools = [];
			this._marqueeing = false;

			if(Param.sponsorStr != null){
				this._sponsor = new SponsorCell( Param.sponsorStr );
			}

			addChild(this._bg);
			this._sponsor.x = (GlobalData.root.stage.stageWidth - this._sponsor.width)/2;
			addChild(this._sponsor);

			addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
		}

		public function onAddMarquee(str:String) : void {
			var cell = new MarqueeCell(str);
			this.addChild(cell);
			this.onMarqueeStart();
			cell.setComplete(this.onMarqueeComplete);

			/*
			if(this._pools.length > 0){
				this._pools[this._pools.length - 1].setComplete(cell.start);
			}
			else{
				cell.start();
			}
			*/
			if(this._pools.length == 0){
				cell.start();
			}
			this._pools.push(cell);
		}

		private function onMarqueeStart(){
			this._marqueeing = true;
			this.showMarqueeAnimate();
			
			if(this._sponsor.parent){
				this._sponsor.parent.removeChild(this._sponsor);
			}
		}

		private function onMarqueeComplete(){
			this._pools.shift();
			if(this._pools.length > 0){
				this._pools[0].start();
			}
			else{
				this._marqueeing = false;
				hideMarqueeAnimate();
				this.addChild(this._sponsor);
			}
		}

		protected function onAddToStage(param1:Event) : void {
			setTimeout(function():void{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,marqueeAnimate);
				stage.addEventListener(Event.MOUSE_LEAVE,marqueeAnimate);
				marqueeAnimate(null);
			},5000);
		}

		private var _animateState:String = "showing";
		private var _marqueeAnimate:TweenLite;
		
		public function marqueeAnimate(event:Event = null) : void{
			if(stage == null){
				return;
			}

			if(this._marqueeing){
				return;
			}

			if((event) && (event.type == MouseEvent.MOUSE_MOVE) && stage.mouseY < SKIN_SHOW_THRESHOLD){
				this.showMarqueeAnimate();
			}
			else{
				this.hideMarqueeAnimate();
			}
		}

		private function showMarqueeAnimate(){
			if(this._animateState != "showing"){
				this._animateState = "showing";
				if(this._marqueeAnimate){
					this._marqueeAnimate.kill();
				}
				this._marqueeAnimate = TweenLite.to(this,0.5,{
						"y":0,
						"alpha":1,
						"ease":Cubic.easeOut
					});
			}
		}

		private function hideMarqueeAnimate(){
			if(this._animateState != "hiding"){
				this._animateState = "hiding";
				if(this._marqueeAnimate){
					this._marqueeAnimate.kill();
				}
				this._marqueeAnimate = TweenLite.to(this,0.5,{
						"y": -40,
						"alpha":0,
						"ease":Cubic.easeOut
					});				
			}	
		}

		public function resize(param1:Number, param2:Number) : void {
			this._bg.width = param1;
			this._sponsor.x = (GlobalData.root.stage.stageWidth - this._sponsor.width)/2;
		}		
	}
}