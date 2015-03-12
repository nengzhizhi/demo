package cc.hl.model.video.interfaces {
	public interface IVideoInfo
	{
		function get sourceType():String;
		function get vid():String;
		function get rawInfo():Object;
		function get status():String;
		function get totalTime():Number;

		//VideoInfo中part的个数
		function get count():int;

		//获取index指定的partVideoInfo,并用f参数处理
		function getPartVideoInfo(f:Function, index:int, startTime:Number=0):void;

		//根据时间startTime获取partVideoInfo的索引
		function getIndexOfPosition(startTime:Number):Array;

	}
}