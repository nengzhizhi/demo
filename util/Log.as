package util {
    import flash.events.*;
    import flash.display.*;
    //import fl.controls.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.system.*;
    import flash.external.*;

    public class Log {

        private static const LEVEL_STRING:Array = ["[ERROR]", "[WARN ]", "[DEBUG]", "[INFO ]"];
        private static const LEVEL_FORMAT:Array = [new TextFormat(null, null, 0xFF0000), null, null, null];

        private static var _s:Sprite;
        private static var _tf:TextField;
        private static var _level:int = 0;

        public static function init(_arg1:DisplayObjectContainer, _arg2:Number=500, _arg3:Number=400):void{
            var main:* = _arg1;
            var width:int = _arg2;
            var height:int = _arg3;
            _s = new Sprite();
            _s.graphics.lineStyle(2, 3840985);
            _s.graphics.beginFill(0, 0.8);
            _s.graphics.drawRect(0, 0, width, height);
            _s.graphics.endFill();
            _s.addEventListener(MouseEvent.CLICK, function (_arg1:MouseEvent):void{
                _arg1.stopPropagation();
            });
            _tf = new TextField();
            _tf.width = (width - 2);
            _tf.height = (height - 35);
            _tf.x = 1;
            _tf.y = 1;
            _tf.defaultTextFormat = new TextFormat("Courier New", null, 65433);
            _tf.alpha = 1;
            _tf.appendText("Acfun Logsystem Link Start......\n\n");
            if (ExternalInterface.available){
                try {
                    _tf.appendText((("浏览器标识：" + ExternalInterface.call("function(){ return navigator.userAgent; }")) + "\n"));
                } catch(error:Error) {
                    _tf.appendText(("Error: " + error.message));
                };
            };
            _tf.appendText((("Flash Player 运行时：" + Capabilities.manufacturer) + "\n"));
            _tf.appendText((("Flash Player 版本：" + Capabilities.version) + "\n"));
            _tf.appendText((("Flash Player 是否调试版：" + Capabilities.isDebugger) + "\n"));
            _tf.appendText((("操作系统：" + Capabilities.os) + "\n"));
            _tf.appendText((((("桌面分辨率：" + Capabilities.screenResolutionX) + "x") + Capabilities.screenResolutionY) + "\n"));
            _tf.appendText((("桌面DPI：" + Capabilities.screenDPI) + "\n\n"));
            _s.addChild(_tf);
			/*
            var copyB:* = new Button();
            copyB.label = "复制";
            copyB.width = 60;
            copyB.x = 10;
            copyB.y = (height - 30);
            copyB.addEventListener(MouseEvent.CLICK, function ():void{
                System.setClipboard(_tf.text);
            });
            _s.addChild(copyB);
            var closeB:* = new Button();
            closeB.label = "关闭";
            closeB.width = 60;
            closeB.x = (width - 70);
            closeB.y = (height - 30);
            closeB.addEventListener(MouseEvent.CLICK, function ():void{
                toggleShow(false);
            });
            _s.addChild(closeB);
			*/
            _s.visible = false;
            _s.x = 2;
            _s.y = 2;
            main.addChild(_s);
        }
        public static function toggleShow(_arg1:Boolean):void{
            if (_s){
                _s.visible = _arg1;
            };
        }
        public static function setLevel(_arg1:int):void{
            _level = _arg1;
            debug("Log level = ", _level);
        }
        public static function info(... _args):void{
            append(3, _args);
        }
        public static function debug(... _args):void{
            append(2, _args);
        }
        public static function warn(... _args):void{
            append(1, _args);
        }
        public static function error(... _args):void{
            append(0, _args);
        }
        public static function getText():String{
            return (_tf.text);
        }
        private static function append(_arg1:int, _arg2:Array):void{
            var _local4:int;
            var _local5:int;
            var _local3 = (((((Util.covertToTime(getTimer()) + " ") + LEVEL_STRING[_arg1]) + "  ----  ") + _arg2.join(" ")) + "\n");
            if (((_tf) && ((_level >= _arg1)))){
                if (_tf.length > 100000){
                    _tf.text = "";
                    _tf.appendText("too many log > 100000,clear!\n");
                };
                _local4 = _tf.length;
                _tf.appendText(_local3);
                _local5 = _tf.length;
                if (LEVEL_FORMAT[_arg1]){
                    _tf.setTextFormat(LEVEL_FORMAT[_arg1], _local4, _local5);
                };
                _tf.scrollV = _tf.bottomScrollV;
            };
        }

    }
}//package com.acfun.Utils 
