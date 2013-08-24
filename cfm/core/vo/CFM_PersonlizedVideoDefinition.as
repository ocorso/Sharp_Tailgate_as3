package cfm.core.vo
{
	import flash.display.BitmapData;

	public class CFM_PersonlizedVideoDefinition
	{
		private var _bitmapDataList		:Vector.<BitmapData>;
		private var _videoDirectory		:String;
		private var _xmlDirectory		:String;
		private var _id					:String;
		private var _version			:String;
		
		public function CFM_PersonlizedVideoDefinition(_init:Object = null)
		{
			_xmlDirectory = "";
			_videoDirectory = "";
			_id = "";
			
			for(var p:String in _init) this[p] = _init[p];
		}
		
		public function set bitmapDataList(_value:Vector.<BitmapData>):void{
			_bitmapDataList = _value;
		}
		
		public function get bitmapDataList():Vector.<BitmapData>{
			if(!_bitmapDataList)
				_bitmapDataList = new Vector.<String>();
			
			return _bitmapDataList;
		}
		
		public function set videoDirectory(_value:String):void{
			_videoDirectory = _value;
		}
		public function get videoDirectory():String{
			return _videoDirectory;
		}
		
		public function set xmlDirectory(_value:String):void{
			_xmlDirectory = _value;
		}
		public function get xmlDirectory():String{
			return _xmlDirectory;
		}
		
		public function set id(_value:String):void{
			_id = _value;
		}
		public function get id():String{
			return _id;
		}
		
		public function set version(_value:String):void{
			_version = _value;
		}
		public function get version():String{
			return _version;
		}
		
		public function get xmlUrl():String{
			return xmlDirectory + version + "/" + id + "_" + version + ".xml";
		}
		
		public function get videoUrl():String{
			return videoDirectory + version + "/" + id + "_" + version + ".swf";
		}
	}
}