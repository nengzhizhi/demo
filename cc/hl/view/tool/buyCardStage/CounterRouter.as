package cc.hl.view.tool.buyCardStage
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import ui.counterRouterBg;

	public class CounterRouter extends Sprite implements ICounter{
		private var _bg:counterRouterBg;

		public function CounterRouter(number:Number){
			super();

			this._bg = new counterRouterBg();
			(this._bg as MovieClip).gotoAndStop(1);
			addChild(this._bg);

			this.update(number);
		}

		public function update(number:Number) : void {
			if( number > 10 ){
				(this._bg as MovieClip).gotoAndStop(11);
			}
			else if(number >= 0){
				(this._bg as MovieClip).gotoAndStop(number+1);
			}
		}
	}
}