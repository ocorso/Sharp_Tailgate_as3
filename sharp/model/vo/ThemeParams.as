package sharp.model.vo
{
	
	import sharp.views.themeModule.dropdownNavigation.DropdownMenu;

	public class ThemeParams extends Object
	{
		private var _dropdownButtonWidth	:Number;
		
		private var _paramsIndex			:int;
		private var _paramsName				:String;
		
		//primary color selection
		private var _primaryColorIndex		:int;
		private var _primaryColor			:uint;
		private var _primaryColorName		:String;
		private var _secondaryColorIndex	:int;
		private var _secondaryColor			:uint;
		private var _secondaryColorName		:String;
		
		//tv size selection
		private var _tvIndex				:int = 3;
		private var _tvSizeName				:String = "";
		private var _tvSize					:Number;
		private var _tvDefaultImage			:String;
		
		
		//room selection
		private var _roomIndex				:int;
		private var _roomId					:String;
		private var _roomItem				:String;
		private var _roomLength				:int;
		private var _roomName				:String;
		private var _roomImageURL			:String;
		private var _roomFurnitureURL		:String;
		private var _roomScrollDirection	:String;
		private var _roomBannerClass		:String;
		private var _roomBannerX			:Number;
		private var _roomBannerY			:Number;
		private var _bannerDifX				:Number;
		private var _bannerDifY				:Number;
		private var _bannerDifScale			:Number;
		private var _photoClass				:String;
		private var _photoX					:Number;
		private var _photoY					:Number;
		private var _photoWidth				:Number;
		private var _photoContentX			:Number;
		private var _tvY					:Number;
		private var _roomType				:String = "";

		
		public function ThemeParams(_init:Object = null) 
		{
			for(var p:String in _init) this[p] = _init[p];
		}

		public function get roomItem():String
		{
			return _roomItem;
		}

		public function set roomItem(value:String):void
		{
			_roomItem = value;
		}

		public function get bannerDifX():Number
		{
			return _bannerDifX;
		}

		public function set bannerDifX(value:Number):void
		{
			_bannerDifX = value;
		}

		public function get bannerDifY():Number
		{
			return _bannerDifY;
		}

		public function set bannerDifY(value:Number):void
		{
			_bannerDifY = value;
		}

		public function get bannerDifScale():Number
		{
			return _bannerDifScale;
		}

		public function set bannerDifScale(value:Number):void
		{
			_bannerDifScale = value;
		}

		public function get tvDefaultImage():String
		{
			return _tvDefaultImage;
		}

		public function set tvDefaultImage(value:String):void
		{
			_tvDefaultImage = value;
		}

		public function get tvSize():Number{return _tvSize;}
		public function set tvSize(value:Number):void{_tvSize = value;}

		public function get roomFurnitureURL():String{return _roomFurnitureURL;}
		public function set roomFurnitureURL(value:String):void{_roomFurnitureURL = value;}

		public function get photoContentX():Number{return _photoContentX;}
		public function set photoContentX(value:Number):void{_photoContentX = value;}

		public function get photoWidth():Number{return _photoWidth;}
		public function set photoWidth(value:Number):void{_photoWidth = value;}

		public function get roomType():String{return _roomType;}
		public function set roomType(value:String):void{_roomType = value;}

		public function get tvY():Number{return _tvY;}
		public function set tvY(value:Number):void{_tvY = value;}

		public function get photoY():Number{return _photoY;}
		public function set photoY(value:Number):void{_photoY = value;}

		public function get photoX():Number{return _photoX;}
		public function set photoX(value:Number):void{_photoX = value;}

		public function get photoClass():String{return _photoClass;}
		public function set photoClass(value:String):void{_photoClass = value;}

		public function get dropdownButtonWidth():Number{return _dropdownButtonWidth};
		public function set dropdownButtonWidth(value:Number):void{_dropdownButtonWidth =  value};
		
		public function get paramsIndex():int{return _paramsIndex};
		public function set paramsIndex(value:int):void{_paramsIndex =  value};
		
		public function get paramsName():String{return _paramsName};
		public function set paramsName(value:String):void{_paramsName =  value};
		
		public function get primaryColorIndex():int{return _primaryColorIndex};
		public function set primaryColorIndex(value:int):void{_primaryColorIndex =  value};
		
		public function get primaryColor():uint{return _primaryColor};
		public function set primaryColor(value:uint):void{_primaryColor =  value};
		
		public function get primaryColorName():String{return _primaryColorName};
		public function set primaryColorName(value:String):void{_primaryColorName =  value};
		
		public function get secondaryColorIndex():int{return _secondaryColorIndex};
		public function set secondaryColorIndex(value:int):void{_secondaryColorIndex =  value};
		
		public function get secondaryColor():uint{return _secondaryColor};
		public function set secondaryColor(value:uint):void{_secondaryColor =  value};
		
		public function get secondaryColorName():String{return _secondaryColorName};
		public function set secondaryColorName(value:String):void{_secondaryColorName =  value};
		
		public function get tvIndex():int{return _tvIndex};
		public function set tvIndex(value:int):void{_tvIndex =  value};
		
		public function get tvSizeName():String{return _tvSizeName};
		public function set tvSizeName(value:String):void{_tvSizeName =  value};
		
		public function get roomIndex():int{return _roomIndex};
		public function set roomIndex(value:int):void{_roomIndex =  value};
		
		public function get roomId():String{return _roomId};
		public function set roomId(value:String):void{_roomId =  value};
		
		public function get roomLength():int{return _roomLength};
		public function set roomLength(value:int):void{_roomLength =  value};
		
		public function get roomName():String{return _roomName};
		public function set roomName(value:String):void{_roomName =  value};
		
		public function get roomImageURL():String{return _roomImageURL};
		public function set roomImageURL(value:String):void{_roomImageURL =  value};
		
		public function get roomScrollDirection():String{return _roomScrollDirection};
		public function set roomScrollDirection(value:String):void{_roomScrollDirection =  value};
		
		public function get roomBannerY():Number{return _roomBannerY;}
		public function set roomBannerY(value:Number):void{_roomBannerY = value;}
		
		public function get roomBannerX():Number{return _roomBannerX;}
		public function set roomBannerX(value:Number):void{_roomBannerX = value;}
		
		public function get roomBannerClass():String{return _roomBannerClass;}
		public function set roomBannerClass(value:String):void{_roomBannerClass = value;}
		
	}
}