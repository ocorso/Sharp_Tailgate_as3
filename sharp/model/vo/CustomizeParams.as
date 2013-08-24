package sharp.model.vo
{
	import flash.display.Bitmap;

	public class CustomizeParams extends Object
	{
		
		private var _paramsIndex					:int;
		private var _paramsId						:String;
		
		private var _itemImageURL					:String;
		private var _itemId							:String;
		private var _itemColorType					:String;
		
		private var _entertainmentItems				:Vector.<String> = new Vector.<String>();
		private var _entertainmentItemIndex			:int;

		private var _decorationsItems				:Vector.<String> = new Vector.<String>();
		private var _decorationsItemIndex			:int;
		
		private var _extrasItems					:Vector.<String> = new Vector.<String>();
		private var _extrasItemIndex				:int;
		
		private var _albumId						:String;
		private var _photoUrl						:String;

		private var _photoUrls						:Array;
		private var _photoIds						:Array;

		private var _thumbUrl						:String;
		private var _photoId						:String = "";


		private var _teamName						:String = "";
		private var _tailgateName					:String = "";
		private var _userEmail						:String = "";
		
		private var _pageStatus						:String;
		
		private var _roomBitmap						:Bitmap;
		private var _forgroundBitmap				:Bitmap;
		private var _isSlideshow					:Boolean = false;
		
		private var _listId							:String;
		
		private var _tvContentWidth					:Number;
		private var _tvContentHeight				:Number;
		

		public function CustomizeParams(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}

		public function get userEmail():String
		{
			return _userEmail;
		}

		public function set userEmail(value:String):void
		{
			_userEmail = value;
		}

		public function get photoId():String
		{
			return _photoId;
		}

		public function set photoId(value:String):void
		{
			_photoId = value;
		}

		public function get thumbUrl():String
		{
			return _thumbUrl;
		}

		public function set thumbUrl(value:String):void
		{
			_thumbUrl = value;
		}

		public function get forgroundBitmap():Bitmap
		{
			return _forgroundBitmap;
		}

		public function set forgroundBitmap(value:Bitmap):void
		{
			_forgroundBitmap = value;
		}

		public function get itemColorType():String
		{
			return _itemColorType;
		}

		public function set itemColorType(value:String):void
		{
			_itemColorType = value;
		}

		public function get tvContentHeight():Number{return _tvContentHeight;}
		public function set tvContentHeight(value:Number):void{_tvContentHeight = value;}

		public function get tvContentWidth():Number{return _tvContentWidth;}
		public function set tvContentWidth(value:Number):void{_tvContentWidth = value;}

		public function get isSlideshow():Boolean{return _isSlideshow;}
		public function set isSlideshow(value:Boolean):void{_isSlideshow = value;}

		public function get photoUrl():String{return _photoUrl;}
		public function set photoUrl(value:String):void{_photoUrl = value;}
		
		public function get photoUrls():Array{return _photoUrls;}
		public function set photoUrls(value:Array):void{_photoUrls = value;}

		public function get photoIds():Array{return _photoIds;}
		public function set photoIds(value:Array):void{_photoIds = value;}

		public function get albumId():String{return _albumId;}
		public function set albumId(value:String):void{_albumId = value;}

		public function get paramsIndex():int{return _paramsIndex};
		public function set paramsIndex(value:int):void{_paramsIndex =  value};
		
		public function get paramsId():String{return _paramsId};
		public function set paramsId(value:String):void{_paramsId =  value};
		
		public function get itemImageURL():String{return _itemImageURL};
		public function set itemImageURL(value:String):void{_itemImageURL =  value};
		
		public function get itemId():String{return _itemId};
		public function set itemId(value:String):void{_itemId =  value};
		
		public function get entertainmentItems():Vector.<String>{return _entertainmentItems};
		public function set entertainmentItems(value:Vector.<String>):void{_entertainmentItems =  value};
		
		public function get entertainmentItemIndex():int{return _entertainmentItemIndex};
		public function set entertainmentItemIndex(value:int):void{_entertainmentItemIndex =  value};
		
		public function get decorationsItems():Vector.<String>{return _decorationsItems};
		public function set decorationsItems(value:Vector.<String>):void{_decorationsItems =  value};
		
		public function get decorationsItemIndex():int{return _decorationsItemIndex};
		public function set decorationsItemIndex(value:int):void{_decorationsItemIndex =  value};
		
		public function get extrasItems():Vector.<String>{return _extrasItems};
		public function set extrasItems(value:Vector.<String>):void{_extrasItems =  value};
		
		public function get extrasItemIndex():int{return _extrasItemIndex};
		public function set extrasItemIndex(value:int):void{_extrasItemIndex =  value};
		
		public function get teamName():String{return _teamName;}
		public function set teamName(value:String):void{_teamName = value;}
		
		public function get tailgateName():String{return _tailgateName;}
		public function set tailgateName(value:String):void{_tailgateName = value;}
		
		public function get pageStatus():String{return _pageStatus;}
		public function set pageStatus(value:String):void{_pageStatus = value;}
		
		public function get roomBitmap():Bitmap{return _roomBitmap;}
		public function set roomBitmap(value:Bitmap):void{_roomBitmap = value;}
		
		public function get listId():String{return _listId;}
		public function set listId(value:String):void{_listId = value;}

	}
}