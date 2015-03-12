package util {
    import flash.geom.*;
    import flash.events.*;
    import flash.display.*;
    import flash.net.*;
    import flash.filters.*;
    import flash.utils.*;
    import flash.text.*;
    import com.adobe.serialization.json.*;
    import flash.system.*;
    import flash.desktop.*;

    public class Util {

        private static var saveTimeRecordPosition:int = -1;

        public static function date(_arg1:Date=null):String{
            if (_arg1 == null){
                _arg1 = new Date();
            };
            return (((((((((((_arg1.getFullYear() + "-") + zeroPad((_arg1.getMonth() + 1))) + "-") + zeroPad(_arg1.getDate())) + " ") + zeroPad(_arg1.getHours())) + ":") + zeroPad(_arg1.getMinutes())) + ":") + zeroPad(_arg1.getSeconds())));
        }
        public static function date2(_arg1:Date=null):String{
            if (_arg1 == null){
                _arg1 = new Date();
            };
            return (((_arg1.getFullYear() + zeroPad((_arg1.getMonth() + 1))) + zeroPad(_arg1.getDate())));
        }
        public static function zeroPad(_arg1, _arg2:int=2):String{
            var _local3:String = ("" + _arg1);
            while (_local3.length < _arg2) {
                _local3 = ("0" + _local3);
            };
            return (_local3);
        }
        public static function digits(_arg1:Number):String{
            var _local2:String = (((_arg1 < 0)) ? "-" : "");
            _arg1 = int(Math.abs(_arg1));
            var _local3:Number = Math.floor((_arg1 / 60));
            var _local4:Number = Math.floor((_arg1 % 60));
            _local2 = (_local2 + ((zeroPad(_local3) + ":") + zeroPad(_local4)));
            return (_local2);
        }
        public static function covertToTime(_arg1:int):String{
            var _local2:Date = new Date();
            _local2.time = _arg1;
            return (((((((("" + zeroPad(_local2.hoursUTC, 2)) + ":") + zeroPad(_local2.minutesUTC, 2)) + ":") + zeroPad(_local2.secondsUTC, 2)) + ".") + zeroPad(_local2.millisecondsUTC, 3)));
        }
        public static function addUrlParam(_arg1:String, _arg2:String, _arg3:Object):String{
            if ((((_arg2 == null)) || ((_arg2.length == 0)))){
                return (_arg1);
            };
            var _local4:RegExp = new RegExp((_arg2 + "=\\w*(?![^&])"));
            if (_local4.test(_arg1)){
                return (_arg1.replace(_local4, ((_arg2 + "=") + _arg3)));
            };
            return (((((_arg1 + (((_arg1.indexOf("?") == -1)) ? "?" : "&")) + _arg2) + "=") + _arg3));
        }
        public static function convertToColorString(_arg1:uint):String{
            var _local2:String = _arg1.toString(16).toUpperCase();
            _local2 = zeroPad(_local2, 6);
            return (_local2);
        }
		/*
        public static function bindComponent(_arg1:LabelButton, _arg2:MovieClip, _arg3:uint):void{
            var ct:* = null;
            var onChange:* = null;
            var button:* = _arg1;
            var mc:* = _arg2;
            var color:* = _arg3;
            onChange = function (_arg1:Event):void{
                if (button.selected){
                    mc.transform.colorTransform = ct;
                } else {
                    mc.transform.colorTransform = new ColorTransform();
                };
            };
            mc.buttonMode = true;
            mc.mouseChildren = false;
            ct = new ColorTransform();
            ct.color = color;
            button.addEventListener(Event.CHANGE, onChange);
            mc.addEventListener(MouseEvent.CLICK, function ():void{
                button.selected = !(button.selected);
                onChange(null);
            });
            onChange(null);
        }
		*/
        public static function hasFont(_arg1:String):Boolean{
            var _local3:Font;
            var _local2:Array = Font.enumerateFonts(true);
            for each (_local3 in _local2) {
                if ((((_local3.fontType == FontType.DEVICE)) && ((_local3.fontName == _arg1)))){
                    return (true);
                };
            };
            return (false);
        }
		/*
        public static function saveTimeRecord(_arg1:String, _arg2:Number):void{
            var _local4:int;
            var _local3:Array = LocalStorage.getValue(LocalStorage.VIDEO_TIME_RECORD, []);
            if (saveTimeRecordPosition == -1){
                _local4 = 0;
                while (_local4 < _local3.length) {
                    if (_local3[_local4].vid == _arg1){
                        saveTimeRecordPosition = _local4;
                    };
                    _local4++;
                };
                if (saveTimeRecordPosition == -1){
                    if (_local3.length >= 16){
                        _local3.shift();
                        saveTimeRecordPosition = 15;
                    } else {
                        saveTimeRecordPosition = _local3.length;
                    };
                };
            };
            _local3[saveTimeRecordPosition] = {
                vid:_arg1,
                time:_arg2
            };
            LocalStorage.setValue(LocalStorage.VIDEO_TIME_RECORD, _local3, false);
        }
        public static function getTimeRecord(_arg1:String):Number{
            var _local2:Array = LocalStorage.getValue(LocalStorage.VIDEO_TIME_RECORD, []);
            var _local3:int;
            while (_local3 < _local2.length) {
                if (_local2[_local3].vid == _arg1){
                    return (_local2[_local3].time);
                };
                _local3++;
            };
            return (0);
        }
        public static function dragEnable(_arg1:Sprite, _arg2:Sprite, _arg3:Rectangle, _arg4:Stage):void{
            var sprite:* = _arg1;
            var controlSprite:* = _arg2;
            var rect:* = _arg3;
            var stage:* = _arg4;
            sprite.addEventListener(MouseEvent.MOUSE_DOWN, function (_arg1:MouseEvent):void{
                var event:* = _arg1;
                if (event.target == controlSprite){
                    sprite.startDrag(false, rect);
                    stage.addEventListener(MouseEvent.MOUSE_UP, function ():void{
                        stage.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee);
                        sprite.stopDrag();
                    });
                };
            });
        }
		
        public static function encode(_arg1:Object):String{
            return (JSON.encode(_arg1));
        }
        public static function decode(_arg1:String, _arg2:Boolean=true){
            return (JSON.decode(_arg1, _arg2));
        }
		*/
        public static function getCenterRectangle(_arg1:Rectangle, _arg2:Rectangle):Rectangle{
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local3:Number = 1;
            var _local4:Number = 1;
            if ((((_arg2.width > 0)) && ((_arg2.height > 0)))){
                _local3 = (_arg1.width / _arg2.width);
                _local4 = (_arg1.height / _arg2.height);
            };
            if (_local3 < _local4){
                _local7 = (_arg2.width * _local3);
                _local8 = (_arg2.height * _local3);
                _local5 = 0;
                _local6 = ((_arg1.height - _local8) / 2);
            } else {
                _local7 = (_arg2.width * _local4);
                _local8 = (_arg2.height * _local4);
                _local5 = ((_arg1.width - _local7) / 2);
                _local6 = 0;
            };
            return (new Rectangle(_local5, _local6, _local7, _local8));
        }
        public static function binsert(_arg1, _arg2:Object, _arg3:Function=null):void{
            if (_arg3 == null){
                _arg3 = numberCompare;
            };
            var _local4:int = bsearch(_arg1, _arg2, _arg3);
            _arg1.splice(_local4, 0, _arg2);
        }
        public static function bsearch(_arg1, _arg2:Object, _arg3:Function=null):int{
            var _local6:int;
            if (_arg3 == null){
                _arg3 = numberCompare;
            };
            if (_arg1.length == 0){
                return (0);
            };
            if (_arg3(_arg2, _arg1[0]) < 0){
                return (0);
            };
            if (_arg3(_arg2, _arg1[(_arg1.length - 1)]) >= 0){
                return (_arg1.length);
            };
            var _local4:int;
            var _local5:int = (_arg1.length - 1);
            var _local7:int;
            while (_local4 <= _local5) {
                _local6 = Math.floor((((_local4 + _local5) + 1) / 2));
                _local7++;
                if ((((_arg3(_arg2, _arg1[(_local6 - 1)]) >= 0)) && ((_arg3(_arg2, _arg1[_local6]) < 0)))){
                    return (_local6);
                };
                if (_arg3(_arg2, _arg1[(_local6 - 1)]) < 0){
                    _local5 = (_local6 - 1);
                } else {
                    if (_arg3(_arg2, _arg1[_local6]) >= 0){
                        _local4 = _local6;
                    } else {
                        throw (new Error("查找错误."));
                    };
                };
                if (_local7 > 1000){
                    throw (new Error("查找超时."));
                };
            };
            return (-1);
        }
        public static function numberCompare(_arg1:Number, _arg2:Number):int{
            if (_arg1 > _arg2){
                return (1);
            };
            if (_arg1 < _arg2){
                return (-1);
            };
            return (0);
        }
        public static function get isChromeFlash():Boolean{
            return (!((Capabilities.manufacturer.indexOf("Google") == -1)));
        }
		/*
        public static function isJsonTestFunc(_arg1:String):Boolean{
            var data:* = _arg1;
            var flag:* = false;
            try {
                Util.decode(data);
                flag = true;
            } catch(e:Error) {
                Log.error("[JSON PARSE ERROR]", data);
            };
            return (flag);
        }
		*/
		
        public static function copy(_arg1){
            registerClassAlias(_arg1.toString(), (getDefinitionByName(getQualifiedClassName(_arg1)) as Class));
            var _local2:ByteArray = new ByteArray();
            _local2.writeObject(_arg1);
            _local2.position = 0;
            var _local3:* = _local2.readObject();
            _local2.clear();
            return (_local3);
        }
        public static function runOnceIn(_arg1:int, _arg2:Function, ... _args):Function{
            var last:* = 0;
            var seed:* = 0;
            var run:* = null;
            var time:* = _arg1;
            var func:* = _arg2;
            var params:* = _args;
            run = function (_arg1):void{
                if ((getTimer() - last) < time){
                    clearTimeout(seed);
                    seed = setTimeout.apply(null, [func, time].concat(params));
                } else {
                    seed = setTimeout.apply(null, [func, time].concat(params));
                };
                last = getTimer();
            };
            last = 0;
            return (run);
        }
        public static function getFilterRect(_arg1:DisplayObject, _arg2:Array):Rectangle{
            var _local6:BitmapFilter;
            var _local7:Rectangle;
            var _local3:Rectangle = _arg1.getRect(_arg1);
            var _local4:BitmapData = new BitmapData(_local3.width, _local3.height);
            var _local5:Rectangle = _local3.clone();
            for each (_local6 in _arg2) {
                _local7 = _local4.generateFilterRect(_local3, _local6);
                _local5 = _local5.union(_local7);
            };
            _local4.dispose();
            return (_local5);
        }
		/*
        public static function colorPickerExtend(_arg1:ColorPicker):void{
            var cp:* = _arg1;
            cp.addEventListener(Event.COPY, function (_arg1:Event):void{
                System.setClipboard(cp.textField.text);
            });
            cp.addEventListener(Event.PASTE, function (_arg1:Event):void{
                var _local2:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT).toString();
                cp.textField.text = _local2;
            });
        }
		*/

        public static function encode(param1:Object) : String {
            return com.adobe.serialization.json.JSON.encode(param1);
        }

        public static function decode(param1:String, param2:Boolean = true) : * {
            return com.adobe.serialization.json.JSON.decode(param1,param2);
        }

    }
}//package com.acfun.Utils 
