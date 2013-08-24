package cfm.facebook.vo
{
	public class WallPostParams
	{
		private var _message:String;
		private var _linkName:String;
		private var _linkUrl:String;
		private var _caption:String;
		private var _title:String;
		private var _description:String;
		private var _imageUrl:String;
		private var _userFacebookUI:Boolean = true;
		
		public function WallPostParams(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}
		
		public function get message():String{return _message;}
		public function set message(value:String):void{_message = value;}
		
		public function get linkName():String{return _linkName;}
		public function set linkName(value:String):void{_linkName = value;}
		
		public function get linkUrl():String{return _linkUrl;}
		public function set linkUrl(value:String):void{_linkUrl = value;}
		
		public function get caption():String{return _caption;}
		public function set caption(value:String):void{_caption = value;}
		
		public function get title():String{return _title;}
		public function set title(value:String):void{_title = value;}
		
		public function get description():String{return _description;}
		public function set description(value:String):void{_description = value;}
		
		public function get imageUrl():String{return _imageUrl;}
		public function set imageUrl(value:String):void{_imageUrl = value;}
		
		public function get userFacebookUI():Boolean{return _userFacebookUI;}
		public function set userFacebookUI(value:Boolean):void{_userFacebookUI = value;}
	}
}