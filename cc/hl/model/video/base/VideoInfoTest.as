package cc.hl.model.video.base{
	import asunit.framework.TestCase;

	public class VideoInfoTest extends TestCase {
		private var videoInfo:VideoInfo;

		public function VideoInfoTest(methodName:String=null) {
			super(methodName);
		}

		override protected function setUp():void {
			super.setUp();
			videoInfo = new VideoInfo("test", "test");
		}

		override protected function tearDown():void {
			super.tearDown();
			videoInfo = null;
		}

		public function testInstantiated():void {
			assertTrue("videoInfo is VideoInfo", videoInfo is VideoInfo);
		}

		public function testTotalTime():void{
			trace("total time is:", videoInfo.totalTime);
		}

		public function testSetRate():void{
			assertTrue("setRate", videoInfo.setRate(2, false));
		}

		public function testGetIndexOfPosition():void{
			var result;
			result = videoInfo.getIndexOfPosition(10);
			trace(result);
		}
	}
}