package util
{
   import flash.events.Event;
   
   public class SkinEvent extends Event
   {
      
      public function SkinEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false) {
         super(param1,param3,param4);
         this.data = param2;
      }
      
      public static const SKIN_PLAY:String = "play";
      
      public static const SKIN_PAUSE:String = "pause";
      
      public static const SKIN_VOLUME_CHANGE:String = "volume";
      
      public static const SKIN_SILENT:String = "silent";
      
      public static const SKIN_SILENT_CANCEL:String = "silentCancel";
      
      public static const SKIN_COMMENT_SHOW:String = "showComment";
      
      public static const SKIN_COMMENT_HIDE:String = "hideComment";
      
      public static const SKIN_FULLSCREEN:String = "fullscreen";
      
      public static const SKIN_SYSTEM_FULLSCREEN:String = "systemFullscreen";
      
      public static const SKIN_NORMALSCREEN:String = "normalscreen";
      
      public static const SKIN_SENDCOMMENT:String = "sendComment";
      
      public static const SKIN_RELOAD:String = "reload";
      
      public static const SKIN_PAGEFULLSCREEN:String = "pageFullScreen";
      
      public static const SKIN_QUITPAGEFULLSCREEN:String = "quitPageFullScreen";
      
      public static const SKIN_FEEDBACK:String = "feedBack";

      public static const SKIN_CAMERA_CHANGE:String = "cameraChange";

      public static const SKIN_VIDEO_CHANGE:String = "videoChange"; 

      public static const SKIN_DANMU_HIDE:String = "danmuHide";
      
      public static const SKIN_DANMU_SHOW:String = "danmuShow";
      public static const SKIN_PROGRESS_ADJUST_COMPLETE:String = "progressAdjustComplete";
      

      public static const SKIN_INTERACTIVE_TOOL_ACTOR_SELECTE = "actorSelecte";
      public static const SKIN_INTERACTIVE_TOOL_THUMBNAIL_SELECTE = "thumbnailSelecte";
      public static const SKIN_INTERACTIVE_TOOL_DO_NEXT = "doNext";


      //镜头点击事件
      public static const SKIN_LENS_CLICKED:String = "LensClicked";

      public var data;
   }
}
