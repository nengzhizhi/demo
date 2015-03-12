package cc.hl.model.video.platform{
	import flash.events.*;
	import asunit.framework.TestCase;
	import cc.hl.model.video.base.*;

	public class YoukuHackerTest extends TestCase {
		private var youkuHacker:YoukuHacker;

		public function YoukuHackerTest(methodName:String=null) {
			super(methodName);
		}

		override protected function setUp():void {
			super.setUp();
			youkuHacker = new YoukuHacker("XODg1OTc2MzUy");
		}

		override protected function tearDown():void {
			super.tearDown();
			youkuHacker = null;
		}

		public function testInstantiated():void {
			assertTrue("youkuHacker is YoukuHacker", youkuHacker is YoukuHacker);
		}

		public function testGetYoukuPlayerListUrl():void{
			trace(youkuHacker.getYoukuPlayerListUrl());
		}

		public function testInit():void{
			youkuHacker.init();
		}

		public function testGetPartVideoInfo():void{
			youkuHacker.init();
			youkuHacker.addEventListener(Event.COMPLETE,function():void{
				youkuHacker.getPartVideoInfo(function (pvi:PartVideoInfo):void{
					trace(pvi.url);
				}, 0, 0);
			});
		}
	}
}