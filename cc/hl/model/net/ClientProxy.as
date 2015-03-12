package cc.hl.model.net{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.interfaces.IProxy;
	import flash.external.ExternalInterface;

	public class ClientProxy extends Proxy implements IProxy{
		public function ClientProxy(){
			super(NAME);
			this.addJsCallback();
		}

		public static var NAME:String = "ClientProxy";
		private var _client:Client;

		public function connectServer(wsServerUrl:String,roomId:String,cookie:String) : void {
			this._client = new Client();
			this._client.connectServer(wsServerUrl,roomId,cookie);
		}

		private function addJsCallback() : void {
			if(ExternalInterface.available){
				ExternalInterface.addCallback("as_chat_send",this.chatSend);
				ExternalInterface.addCallback("as_chat_silence",this.chatSilence);
			}
		}

		private function chatSend(m:String) : void{
			this._client.sendMessage(m);
		}

		private function chatSilence(target:String) : void {
			this._client.chatSilence(target);
		}
	}
}