package {
    import asunit.framework.TestSuite;
	import cc.hl.model.video.base.VideoInfoTest;
    import cc.hl.view.video.*;
    import cc.hl.model.video.platform.*;

    public class AllTests extends TestSuite {

        public function AllTests() {
            /*
            addTest(new VideoInfoTest("testInstantiated"));
			addTest(new VideoInfoTest("testSetRate"));
			addTest(new VideoInfoTest("testTotalTime"));
			addTest(new VideoInfoTest("testGetIndexOfPosition"));
            */
            //addTest(new PlayerCoreTest("testInstantiated"));
            //addTest(new PlayerCoreTest("testStart"));
            //addTest(new YoukuHackerTest("testGetYoukuPlayerListUrl"));
            //addTest(new YoukuHackerTest("testInit"));
            addTest(new YoukuHackerTest("testGetPartVideoInfo"));
        }
    }
}