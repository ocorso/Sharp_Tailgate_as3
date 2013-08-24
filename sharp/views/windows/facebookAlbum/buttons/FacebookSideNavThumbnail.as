package sharp.views.windows.facebookAlbum.buttons
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.interfaces.util.CFM_IResize;
	import cfm.core.managers.CFM_ResizeManager;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	import sharp.views.windows.buttons.WindowCloseButton;
	
	public class FacebookSideNavThumbnail extends CFM_ObjectContainer
	{
		
		private var thumbUrl					:String;
		private var photoBackground				:CFM_Graphics;
		private var photoPlaceholder			:CFM_Graphics;
		private var imageMask					:CFM_Graphics;
		private var photoImage					:ContentDisplay;
		private var container					:CFM_ObjectContainer;
		private var closeButton					:CFM_SimpleButton;
		
		private const IMG_WIDTH					:int = 76;
		private const IMG_HEIGHT				:int = 50;
		private const FRAME_WIDTH				:int = 89;
		private const FRAME_HEIGHT				:int = 57;
		
		public var  oy							:Number;
		private var _photoUrl					:String;
		private var _photoId					:String;
		
		public function FacebookSideNavThumbnail(_thumbUrl:String, _photoUrl_:String, _photoId_:String)
		{
			super(true);
			this.alpha = 0;
			thumbUrl = _thumbUrl;
			_photoUrl = _photoUrl_;
			_photoId	= _photoId_;

			container = new CFM_ObjectContainer();
			container.renderTo(this);			
			container.mouseChildren = false;
			container.name ="imageHolder";
			buildPhotoBackground();
			buildImageMask();
			loadImage();
			
			closeButton = new WindowCloseButton(0,"close","close","",2,2,false,false);
			
			var circ:Shape = new Shape();
			circ.graphics.beginFill(0xFFFFFF);
			circ.graphics.drawCircle(20,20,14);
			circ.graphics.endFill();
			closeButton.addChild(circ);
			closeButton.filters = [new DropShadowFilter(2,45,0x000000,.2,2,2,1,3)];
			closeButton.scaleX = closeButton.scaleY = .7;
			closeButton.setProperties({x: 63});
			
			closeButton.renderTo(this);
			closeButton.mouseChildren = false;
			closeButton.buttonMode = true;
			closeButton.alpha = 0;
			this.addEventListener(MouseEvent.MOUSE_OVER, showCloseButton, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, hideCloseButton, false, 0, true);
			
		}
		
		public function get photoUrl():String{
			return _photoUrl;
		}
		
		public function get photoId():String{
			return _photoId;
		}		
		
		private function showCloseButton(e:MouseEvent):void{
			TweenMax.to(closeButton, .2, {autoAlpha:1});
		}
		
		private function hideCloseButton(e:MouseEvent):void{
			TweenMax.to(closeButton, .2, {autoAlpha:0});
		}
		
		private function buildImageMask():void{
			imageMask = new CFM_Graphics();
			imageMask.width = IMG_WIDTH;
			imageMask.height = IMG_HEIGHT;
			imageMask.x = photoPlaceholder.x;
			imageMask.y = photoPlaceholder.y;
			imageMask.renderTo(container);
			imageMask.visible = false;
		}
		
		private function buildPhotoBackground():void{
			
			photoBackground = new CFM_Graphics(photoBackgroundParams);
			photoBackground.renderTo(container);
			photoBackground.filters = [new DropShadowFilter(1,45,0,.2,2,2,1,3)];
			
			photoPlaceholder = new CFM_Graphics(photoPlaceholderParams);
			photoPlaceholder.renderTo(container);
			
			var photoX:Number = photoBackground.x + (photoBackground.width - photoPlaceholder.width)*.5;
			var photoY:Number = photoBackground.y + (photoBackground.height - photoPlaceholder.height)*.5;
			photoPlaceholder.setProperties({x:photoX, y:photoY});
			
		}
		
		private function loadImage():void{
			
			var loader:ImageLoader = new ImageLoader(thumbUrl, 
				{
					container:container,
					width:FRAME_WIDTH,
					height:FRAME_HEIGHT,
					scaleMode:"proportionalInside",
					x:photoPlaceholder.x- 7,
					y:photoPlaceholder.y- 6,
					noCache:true,
					onComplete:onImageLoad
				});
			loader.load();
		}
		
		private function onImageLoad(event:LoaderEvent):void {
			photoImage = event.target.content;
			imageMask.visible = true;
			photoImage.mask = imageMask;
			photoImage.alpha = 0;
			TweenMax.to(photoImage, .3, {alpha:1});
		}
		
		private function get photoBackgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.width = FRAME_WIDTH;
			p.height = FRAME_HEIGHT + 6;
			p.lineColor = Vo.GRAY_STROKE;
			p.colors = [0xffffff];
			return p;
		}
		
		private function get photoPlaceholderParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.width = IMG_WIDTH;
			p.height = IMG_HEIGHT;
			p.colors = [0xebebeb];
			return p;
		}
		
		// Override
		override public function renderTo(_parent:DisplayObjectContainer, index:Number = Number.NaN):void{		
			//Resize
//			this.scaleX = this.scaleY = .67;					
			
			(isNaN(index))? _parent.addChild(this):_parent.addChildAt(this, int(index));
			if(this is CFM_IResize) 
				CFM_ResizeManager.addToResizeQue(this as CFM_IResize);

		}		
	}
	
}