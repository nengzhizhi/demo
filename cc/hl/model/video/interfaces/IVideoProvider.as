package cc.hl.model.video.interfaces {

	public interface IVideoProvider {

		function start(startTime:Number=0):void;
		function getVideoInfo():String;
		function resize(h:Number, w:Number):void;
		function setVideoRatio(arg:int):void
		function toggleSilent(silent:Boolean):void;
                function get playing():Boolean;
                function set playing(_arg1:Boolean):void;
                function get volume():Number;
                function set volume(_arg1:Number):void;
                function get time():Number;
                function set time(_arg1:Number):void;
                function get buffTime():Number;
                function get buffPercent():Number;
                function get buffering():Boolean;
                function get loop():Boolean;
                function set loop(_arg1:Boolean):void;
                function get videoLength():Number;		
	}
}