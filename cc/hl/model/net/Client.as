package cc.hl.model.net{
	import com.worlize.websocket.*;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.*;
    import flash.system.*;
    import flash.external.*;
    import util.*;
	import cc.hl.model.video.VideoManager;
	import cc.hl.model.comment.CommentTime;
	import cc.hl.model.comment.SingleCommentData;
	import com.adobe.serialization.json.JSON;

	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class Client extends Object{
		public function Client(){
			super();
		}

		public static const PING_INTERVAL = 60000;
		public var _conn:WebSocket;
		private var _wsUrl:String;
		private var _roomId:String;
		private var _cookie:String;
		private var _token:String;
		private var _pingHandle = null;

		public function connectServer(wsUrl:String,roomId:String,cookie:String){
			if(this._conn != null){
				this._conn.close(false);
				this.removeWebsocketListeners();
			}

			this._wsUrl = wsUrl;
			this._roomId = roomId;
			this._cookie = cookie;
			this._conn = new WebSocket(wsUrl,cookie,null,5000);
			this.addWebsocketListeners();
			this._conn.connect();
		}

		public function pingServer(){
			var pingRequest:Object = {
				"c":"chat.ping",
				"data":{
					"token":this._token,
					"roomId":this._roomId,
					"cookie":this._cookie
				}
			}
			this._conn.sendUTF(com.adobe.serialization.json.JSON.encode(pingRequest));
		}

		public function sendMessage(m:String){
			var rawRequest:Object = {
				"c":"chat.send",
				"data":{
					"token":this._token,
					"message":m,
					"roomId":this._roomId,
					"cookie":this._cookie
				}
			}			
			this._conn.sendUTF(com.adobe.serialization.json.JSON.encode(rawRequest));
			$.jscall("js_add_message", VideoManager.instance.time.toFixed(1), "message", m);
		}

		public function chatSilence(target:String){
			var rawRequest:Object = {
				"c":"chat.silence",
				"data":{
					"token":this._token,
					"target":target,
					"roomId":this._roomId,
					"cookie":this._cookie					
				}
			}
			//$.jscall("console.log",com.adobe.serialization.json.JSON.encode(rawRequest));
			this._conn.sendUTF(com.adobe.serialization.json.JSON.encode(rawRequest));			
		}

		private function handleWebSocketMessage(event:WebSocketEvent) : void {
			if(event.message){
				$.jscall("console.log",event.message.utf8Data);
				var reply = com.adobe.serialization.json.JSON.decode(event.message.utf8Data);
				//$.jscall("console.log",event.message.utf8Data);
				$.jscall("js_ws_response",reply);

				if(reply.data != null && reply.c != null){
					var channel = com.adobe.serialization.json.JSON.decode(Stringify.s(reply.c));
					var body 	= com.adobe.serialization.json.JSON.decode(Stringify.s(reply.data));

					switch(channel){
						case 'chat.connect':
							this._token = body.token;
							this._pingHandle = setInterval(this.pingServer , PING_INTERVAL);
							break;
						case 'chat.send':
							CommentTime.instance.start(new SingleCommentData(body.message,16777215,GlobalData.textSizeValue,getTimer(),true));
							break;
						case 'chat.message_push':
							CommentTime.instance.start(new SingleCommentData(body.message,16777215,GlobalData.textSizeValue,getTimer(),false));
							break;
						case 'chat.marquee':
							sendNotification(Order.Marquee_Add_Request,{"message":body.message});
							break;
						case 'product.showBuyCard':
							sendNotification(Order.Tool_ShowBuyCard_Request,body);
							break;
						case 'product.showUseCard':
							sendNotification(Order.Tool_ShowUseCard_Request,body);
							break;
						case 'product.showEndCard':
							sendNotification(Order.Tool_ShowEndCard_Request,body);
							break;
						case 'product.hideBuyCard':
							sendNotification(Order.Tool_HideBuyCard_Request,body);
							break;
						case 'product.hideUseCard':
							sendNotification(Order.Tool_HideUseCard_Request,body);
							break;
						case 'product.hideEndCard':
							sendNotification(Order.Tool_HideEndCard_Request,body);
							break;
						case 'product.updateCardNumber':
							sendNotification(Order.Tool_UpdateCardNumber_Request,body);
							break;
						default:
							break;						
					}
				}
			}
		}

		private function addWebsocketListeners() : void {
			this._conn.addEventListener(WebSocketEvent.MESSAGE,this.handleWebSocketMessage);
			this._conn.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.handleConnectionFail);
			this._conn.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
			this._conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
			this._conn.addEventListener(WebSocketEvent.OPEN,this.handleWebSocketOpen);
			this._conn.addEventListener(WebSocketEvent.CLOSED,this.handleWebSocketClosed);
		}

		private function removeWebsocketListeners() : void {
			this._conn.removeEventListener(WebSocketEvent.MESSAGE,this.handleWebSocketMessage);
			this._conn.removeEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.handleConnectionFail);
			this._conn.removeEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
			this._conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
			this._conn.removeEventListener(WebSocketEvent.OPEN,this.handleWebSocketOpen);
			this._conn.removeEventListener(WebSocketEvent.CLOSED,this.handleWebSocketClosed);
		}

		private function handleIOError(param1:IOErrorEvent){
			$.jscall("console.log", "ws:IO_ERROR");
		}

		private function handleSecurityError(param1:SecurityErrorEvent) : void {
			$.jscall("console.log", "SecurityErrorEvent:"+param1.toString());
		}

		private function handleConnectionFail(param1:WebSocketErrorEvent){
			$.jscall("console.log", "ws:WEBSOCKET_ERROR");
		}

		private function handleWebSocketOpen(param1:WebSocketEvent) : void {
			var rawRequest:Object = {
				"c" : "chat.connect",
				"data" : { 
					"roomId" : this._roomId,
					"cookie" : this._cookie
				}
			};
			//$.jscall("console.log", com.adobe.serialization.json.JSON.encode(rawRequest));
			this._conn.sendUTF(com.adobe.serialization.json.JSON.encode(rawRequest));
		}

		private function handleWebSocketClosed(param1:WebSocketEvent) : void {
			if(this._pingHandle != null){
				clearInterval(_pingHandle);
			}
		}

		public static function sendNotification( message:String, obj:Object = null ):void
		{
			var facade:IFacade = Facade.getInstance();
			facade.sendNotification( message, obj );
		}
	}
}