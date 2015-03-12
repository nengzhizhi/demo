package cc.hl.view.demo {
	import flash.events.Event;
	import flash.system.*;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.*;

	import cc.hl.model.video.VideoManager;
	import cc.hl.model.comment.CommentTime;
	import cc.hl.model.comment.SingleCommentData;
	import util.*;

	public class DemoMediator extends Mediator implements IMediator{

		private var rawRecordArray:Array;
		private var lastPlaySecond:Number = 0;
		private var records:Array;
		private const GET_RECORD_URL:String = "http://vls.whonow.cn:8086/app/room/getRecords?roomId=544e007ab99a88bc8b6c401e&r=" + int(Math.random() * 9999);

		public function DemoMediator(o:Object){
			super("DemoMediator", o);
			records = [];
		}

		override public function listNotificationInterests() : Array {
			return [
					Order.Demo_Start_Request,
					Order.Demo_Timer_Request
				];
		}

		override public function handleNotification(n:INotification) : void{
			switch(n.getName()){
				case Order.Demo_Start_Request:
					this.onStart();
					break;
				case Order.Demo_Timer_Request:
					this.onTimer(n.getBody());
					break;
			}
		}

		protected function onStart() : void {
			var loader:BlockLoader = new BlockLoader(GET_RECORD_URL);

			loader.addEventListener(Event.COMPLETE, function():void{
				var rawRecords:Object = Util.decode(loader.data);
				rawRecordArray = rawRecords.data;

				for(var i:int = 0; i < rawRecordArray.length ; i++){
					records[i] = rawRecordArray[i].data.span;
				}
			});
		}

		protected function onTimer(o:Object) : void {
			//FIXME
			trace("System Memeory:" + System.totalMemory/1024/1024 + "M");
			trace("Total Memeory:" + int.MAX_VALUE/1024/1024 + "M");

			var playedSecond:Number = o.playedSecond;
			if(o.playedSecond - this.lastPlaySecond > 1){
				this.lastPlaySecond = o.playedSecond - 1;
			}

			if(VideoManager.instance.playing){
				var recordStart:int = Util.bsearch(this.records, this.lastPlaySecond);
				var recordEnd:int = Util.bsearch(this.records, o.playedSecond);

				for(var i:int = recordStart; i < recordEnd; i++){
					if(this.rawRecordArray[i].c == "chat.message_push"){
						CommentTime.instance.start(
							new SingleCommentData(
								this.rawRecordArray[i].data.message,
								16777215,
								GlobalData.textSizeValue,
								0,
								false
							)
						);
						$.jscall("js_ws_response",this.rawRecordArray[i]);					
					}
					else if(this.rawRecordArray[i].c == "chat.consume_push"){
						$.jscall("js_ws_response",this.rawRecordArray[i]);
					}
				}
			}
			this.lastPlaySecond = o.playedSecond;
		}
	}
}