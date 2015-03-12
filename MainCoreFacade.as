package 
{
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.interfaces.IFacade;
	import cc.hl.controller.StartCommand;

	import common.event.EventCenter;
	import common.event.ObjectEvent;

	import util.$;

	public class MainCoreFacade extends Facade implements IFacade
	{
		public function MainCoreFacade(){
			super();
		}

		public static function getInstance() : MainCoreFacade
		{
			if(instance == null)
			{
				instance = new MainCoreFacade();
			}
			return instance as MainCoreFacade;
		}

		override protected function initializeController() :void
		{
			super.initializeController();
			registerCommand("start_up",StartCommand);
			this.addListenr();
		}

		private function addListenr() : void {
			EventCenter.addEventListener("ResizeChange",this._resizeChange);
		}

		private function _resizeChange(e:ObjectEvent) : void {
			sendNotification(Order.On_Resize,e.data);
		}
	}

}