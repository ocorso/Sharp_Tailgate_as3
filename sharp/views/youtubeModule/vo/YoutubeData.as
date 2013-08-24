package sharp.views.youtubeModule.vo
{
	public class YoutubeData extends Object
	{
		
		private var _videoId						:String = "";
		private var _videoUrl						:String;
		private var _videoImageUrl					:String;
		private var _valid							:Boolean;
		
		public function YoutubeData(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}

		public function get videoUrl():String
		{
			return _videoUrl;
		}

		public function set videoUrl(value:String):void
		{
			_videoUrl = value;
		}
		
		public function get videoImageUrl():String
		{
			return _videoImageUrl;
		}
		
		public function set videoImageUrl(value:String):void
		{
			_videoImageUrl = value;
		}
		
		public function get videoId():String
		{
			return _videoId;
		}
		
		public function set videoId(value:String):void
		{
			_videoId = value;
		}
		
		public function get valid():Boolean
		{
			return _valid;
		}
		
		public function set valid(value:Boolean):void
		{
			_valid = value;
		}

	}
}