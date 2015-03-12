package
{
	public class Order extends Object
	{
		public function Order()
		{
			super();
		}

		public static var Video_Load_Request:String = "Video_Load_Request";

		public static var Comment_Show_Request:String = "Comment_Show_Request";
		public static var Comment_OpenHide_Request:String = "Comment_OpenHide_Request";


//------------------------------------------------------------------------------------------		

		public static var Video_Show_Request:String = "Video_Show_Request";

		public static var Video_Play_Request:String = "Video_Play_Request";

		public static var Video_Pause_Request:String = "Video_Pause_Request";
		public static var Video_VolumeChange_Request:String = "Video_VolumeChange_Request";

		public static var Video_Reload_Request:String = "Video_Reload_Request";
		public static var Video_Seek_Request:String = "Video_Seek_Request";

		public static var Load_Show_Request:String = "Load_Show_Request";

		public static var Load_Hide_Request:String = "Load_Hide_Request";

		public static var Load_Reload_Request:String = "Load_Reload_Request";

		public static var Load_Play_Request:String = "Load_Play_Request";

		public static var Play_Show_Request:String = "Play_Show_Request";
		public static var Play_PlayedSecond_Request:String = "Play_PlayedSecond_Request";
		public static var Play_VideoLength_Request:String = "Play_VideoLength_Request";

		public static var On_Resize:String = "On_Resize";
		public static var Marquee_Show_Request:String = "Marquee_Show_Request";
		public static var Marquee_Add_Request:String = "Marquee_Add_Request";

		public static var Tool_Show_Request:String = "Tool_Show_Request";
		public static var Tool_ShowBuyCard_Request:String = "Tool_ShowBuyCard_Request";
		public static var Tool_ShowUseCard_Request:String = "Tool_ShowUseCard_Request";
		public static var Tool_ShowEndCard_Request:String = "Tool_ShowEndCard_Request";
		public static var Tool_HideBuyCard_Request:String = "Tool_HideBuyCard_Request";
		public static var Tool_HideUseCard_Request:String = "Tool_HideUseCard_Request";
		public static var Tool_HideEndCard_Request:String = "Tool_HideEndCard_Request";
		public static var Tool_UpdateCardNumber_Request:String = "Tool_UpdateScore_Request";

		public static var MultiVideo_Show_Request:String = "MultiVideo_Show_Request";

		public static var MultiVideo_Pause_Request:String = "MultiVideo_Pause_Request";

		public static var MultiVideo_Reload_Request:String = "MultiVideo_Reload_Request";

		public static var MultiVideo_VolumeChange_Request:String = "MultiVideo_VolumeChange_Request";

		public static var MultiVideo_ShowMainCamera_Request:String = "MultiVideo_ShowMainCamera_Request";

		public static var MultiVideo_ShowSubCamera_Request:String = "MultiVideo_ShowSubCamera_Request";

		public static var MultiVideo_CameraChange_Request:String = "MultiVideo_CameraChange_Request";

		public static var Camera_Show_Request:String = "Camera_Show_Request";
		public static var Camera_Load_Request:String = "Camera_Load_Request";

		//-------------------------------------------------------------------------
		//Lens commands
		//-------------------------------------------------------------------------
		public static var Lens_Init_Request:String = "Lens_Init_Request";
		//-------------------------------------------------------------------------
		//Demo commands
		//-------------------------------------------------------------------------
		public static var Demo_Timer_Request:String = "Demo_Timer_Request";
		public static var Demo_Start_Request:String = "Demo_Start_Request";

	}
}