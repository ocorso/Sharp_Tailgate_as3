package sharp.views.customizeModule.customizeNavigation.buttons
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.filters.DropShadowFilter;
	
	import sharp.model.vo.Vo;
	
	public class FacebookPhotoThumbnail extends CFM_ObjectContainer
	{
		
		private var imageUrl					:String;
		private var photoBackground				:CFM_Graphics;
		private var photoPlaceholder			:CFM_Graphics;
		private var imageMask					:CFM_Graphics;
		private var photoImage					:ContentDisplay;
		private var isSlideshow					:Boolean;
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		private function buildImageMask():void{
			imageMask = new CFM_Graphics();
			imageMask.width = 113;
			imageMask.height = 75;
			imageMask.x = photoPlaceholder.x;
			imageMask.y = photoPlaceholder.y;
			imageMask.renderTo(this);
			imageMask.visible = false;
		}
		
		private function buildPhotoBackground():void{
			
			photoBackground = new CFM_Graphics(photoBackgroundParams);
			photoBackground.renderTo(this);
			photoBackground.filters = [new DropShadowFilter(1,45,0,.2,2,2,1,3)];
			
			photoPlaceholder = new CFM_Graphics(photoPlaceholderParams);
			photoPlaceholder.renderTo(this);
			
			var photoX:Number = photoBackground.x + (photoBackground.width - photoPlaceholder.width)*.5;
			var photoY:Number = photoBackground.y + (photoBackground.height - photoPlaceholder.height)*.5;
			photoPlaceholder.setProperties({x:photoX, y:photoY});
			
		}
		
		private function loadImage():void{
			
			var loader:ImageLoader = new ImageLoader(imageUrl, 
				{
					container:this,
					width:Vo.FACEBOOK_THUMB_WIDTH,
					height:Vo.FACEBOOK_THUMB_HEIGHT,
					scaleMode:"proportionalInside",
					x:photoPlaceholder.x-10,
					y:photoPlaceholder.y-10,
					noCache:true,
					onComplete:onImageLoad
				});
			loader.load();
		}
		
		private function buildArrowIcon():void{
			var arrow:CFM_Graphics = new CFM_Graphics();
			arrow.graphics.clear();
			arrow.graphics.beginFill(0xFFFFFF);
			arrow.graphics.lineTo(30, 15);
			arrow.graphics.lineTo(0, 30);
			arrow.graphics.lineTo(0,0);
			arrow.graphics.endFill();
			arrow.filters = [new DropShadowFilter(3,45,0x000000,.2,2,2,1,3)];
			arrow.setProperties({x: imageMask.width/2 - arrow.width/2 + photoPlaceholder.x, y: imageMask.height/2 - arrow.height/2 + photoPlaceholder.y});
			arrow.renderTo(this);
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onImageLoad(event:LoaderEvent):void {
			photoImage = event.target.content;
			imageMask.visible = true;
			photoImage.mask = imageMask;
			if (isSlideshow) buildArrowIcon();
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		private function get photoBackgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.width = Vo.FACEBOOK_THUMB_WIDTH;
			p.height = Vo.FACEBOOK_THUMB_HEIGHT+10;
			p.lineColor = Vo.GRAY_STROKE;
			p.colors = [0xffffff];
			return p;
		}
		
		private function get photoPlaceholderParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.width = 113;
			p.height = 75;
			p.colors = [0xebebeb];
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function FacebookPhotoThumbnail(_imageUrl:String, slideshow:Boolean)
		{
			super(true);
			
			imageUrl	 = _imageUrl;
			isSlideshow	 = slideshow;
			
			buildPhotoBackground();
			buildImageMask();
			loadImage();
			
		}
		
		
		
		
	}
}