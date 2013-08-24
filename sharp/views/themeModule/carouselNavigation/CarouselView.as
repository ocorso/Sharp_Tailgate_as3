package sharp.views.themeModule.carouselNavigation
{
	import cfm.core.containers.CFM_ObjectContainer;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpPageTemplate;
	
	public class CarouselView extends SharpPageTemplate
	{
		private const TV_X					:Number = 398;
		private const TV_Y					:Number = 320;
		private const IMAGE_SCALE			:Number = .7;
		private const ORIGIN_IMAGE_Y		:Number = 15;
		private const SMALL_IMAGE_Y			:Number = 50;
		
		private var _imageArray				:Array;
		private var _direction				:String;
		private var _loader					:ImageLoader;
		private var _buttonList				:XML;
		private var _tvList					:XMLList;
		
		private var _currentImageIndex		:int;
		private var _imageHolder			:CFM_ObjectContainer;
		private var _currentImage			:CFM_ObjectContainer = new CFM_ObjectContainer();
		private var _prevImage				:CFM_ObjectContainer = new CFM_ObjectContainer();
		private var _nextImage				:CFM_ObjectContainer = new CFM_ObjectContainer();
		
		private var _imageUrl				:String;
		private var imageWidth				:Number;
		
		private var tvClip					:TV_Select;
		private var defaultImageArray		:Array;
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		public function selectTV(_tvSize:Number):void{
			TweenMax.to(tvClip, .6, {scaleX:_tvSize, scaleY:_tvSize, ease:Cubic.easeOut});
		}
		
		public function updateDefaultImage(_defaultImage:String):void{
			for(var i:String in defaultImageArray){
				TweenMax.to(defaultImageArray[i], .2, {autoAlpha:0, ease:Cubic.easeOut});
				if(defaultImageArray[i].name == _defaultImage) 
					TweenMax.to(defaultImageArray[i], .2, {autoAlpha:1, ease:Cubic.easeOut});
			}
		}

		public function defineImages():void{
			
			_currentImage = _imageArray[currentImageIndex];
			
			if(currentImageIndex == 0)
				_prevImage = _imageArray[_imageArray.length-1];
			else
				_prevImage = _imageArray[currentImageIndex-1];
			
			if(currentImageIndex == _imageArray.length - 1)
				_nextImage = _imageArray[0];
			else
				_nextImage = _imageArray[currentImageIndex+1];	
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			buildImage();
			buildTV();
		}

		private function buildImage():void{
			_imageArray = new Array();
			
			for (var i:int=0; i<_buttonList.button.length(); i++){
				
				_imageHolder = new CFM_ObjectContainer();
				_imageHolder.renderTo(this);
				_imageHolder.y = ORIGIN_IMAGE_Y;
				var roomUrl:String = _imageUrl + "carousel/" + _buttonList.button[i].@id + ".png";
				
				_loader = new ImageLoader(roomUrl, {
					name:_buttonList.button[i].@id,  
					container:_imageHolder,
					noCache:true,
					onComplete:onImageLoad
				});
					
				_imageArray.push(_imageHolder);
					
				_loader.load();
			}
		}
		
		private function buildTV():void{

			tvClip = new TV_Select();
			this.addChild(tvClip);
			tvClip.x = TV_X;
			tvClip.y = TV_Y;
			tvClip.alpha = 0;
			tvClip.y = tvClip.y + 50;

			defaultImageArray = new Array();
			for(var i:int=0; i<tvClip.defaultImage.numChildren; i++){
				var defaultImageClip:MovieClip = MovieClip(tvClip.defaultImage.getChildAt(i));
				defaultImageClip.alpha = 0;
				defaultImageClip.visible = true;
				defaultImageArray.push(defaultImageClip);
			}
		}

		// =================================================
		// ================ Workers
		// =================================================
		private function updateCarousel():void{
			defineImages();
			positionImages();
		}
		
		private function positionImages():void{
			for each(var img:CFM_ObjectContainer in _imageArray){
				img.visible = false;
			}
			
			_currentImage.visible = true;
			_prevImage.visible = true;
			_nextImage.visible = true;
			
			if(stage){
				_currentImage.x = (stage.stageWidth - imageWidth)*.5;
				_prevImage.scaleX = _prevImage.scaleY = 1;
				
				_prevImage.x = -imageWidth;
				_prevImage.y = SMALL_IMAGE_Y;
				_prevImage.scaleX = _prevImage.scaleY = IMAGE_SCALE;
				
				_nextImage.x = stage.stageWidth;
				_nextImage.y = SMALL_IMAGE_Y;
				_nextImage.scaleX = _nextImage.scaleY = IMAGE_SCALE;
			}
		}


		// =================================================
		// ================ Handlers
		// =================================================
		private function onImageLoad(event:LoaderEvent):void {
			var image:ContentDisplay = event.target.content;
			TweenMax.from(image, .5, {y:image.y + 50, alpha:0, ease:Cubic.easeOut});
			TweenMax.to(tvClip, .5, {delay:.2, scaleX:1, scaleY:1, alpha:1, y:320, ease:Cubic.easeOut});
			imageWidth = image.width;

			updateCarousel();
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		public function scrollCarousel():void{

			TweenMax.killDelayedCallsTo(updateCarousel);
			
			switch(direction){
				case "right":
					TweenMax.to(_currentImage, Vo.CAROUSEL_TRANSIT_TIME, {scaleX:IMAGE_SCALE, scaleY:IMAGE_SCALE, y:SMALL_IMAGE_Y, x:-_currentImage.width, ease:Cubic.easeOut});
					TweenMax.to(_nextImage, Vo.CAROUSEL_TRANSIT_TIME, {scaleX:1, scaleY:1, x:(stage.stageWidth - imageWidth)*.5, y:ORIGIN_IMAGE_Y, ease:Cubic.easeOut});
					break;
				case "left":
					TweenMax.to(_currentImage, Vo.CAROUSEL_TRANSIT_TIME, {scaleX:IMAGE_SCALE, scaleY:IMAGE_SCALE, y:SMALL_IMAGE_Y, x:stage.stageWidth, ease:Cubic.easeOut});
					TweenMax.to(_prevImage, Vo.CAROUSEL_TRANSIT_TIME, {scaleX:1, scaleY:1, x:(stage.stageWidth - imageWidth)*.5, y:ORIGIN_IMAGE_Y, ease:Cubic.easeOut});
					break;
			}
			
			TweenMax.delayedCall(Vo.CAROUSEL_TRANSIT_TIME, updateCarousel);
			
		}
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function get imageUrl():String{return _imageUrl;}
		public function set imageUrl(value:String):void{_imageUrl = value;}
		
		public function set direction(_dir:String):void{_direction = _dir;}
		public function get direction():String{return _direction;}
		
		public function set currentImageIndex(_currentIndex:int):void{_currentImageIndex = _currentIndex;}
		public function get currentImageIndex():int{return _currentImageIndex;}
		
		public function get tvList():XMLList{return _tvList;}
		public function set tvList(value:XMLList):void{_tvList = value;}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function CarouselView(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			_buttonList = _xml;
		}
	}
}