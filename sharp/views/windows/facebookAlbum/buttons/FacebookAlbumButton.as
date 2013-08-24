package sharp.views.windows.facebookAlbum.buttons
{
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class FacebookAlbumButton extends SharpButtonTemplate
	{
		protected var THUMB_WIDTH							:Number = 127;
		protected var THUMB_HEIGHT							:Number = 140;
		private const MARGIN								:Number  = 10;

		protected var imageUrl								:String;
		protected var imageData								:Object;
		protected var imageMask								:CFM_Graphics;
		protected var thumbOver								:CFM_Graphics;
		protected var placeHolder							:CFM_Graphics;
		protected const thumbOverThinkness					:int = 4;
		protected var imagePreloader						:ImagePreloader;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			buildPlaceHolder();
			buildImagePreloader();
			label.setProperties({x:MARGIN, y:Vo.FACEBOOK_THUMB_HEIGHT + 5});
		}
		
		
		override protected function buildBackground():void{
			super.buildBackground();
			backgroundContainer.filters = [new DropShadowFilter(1,45,0,.2,2,2,1,3)];
			
			buildThumbOver();
		}
		
		protected function buildThumbOver():void{
			thumbOver = new CFM_Graphics(thumbOverParams);
			thumbOver.renderTo(labelContainer);
			thumbOver.x = thumbOverThinkness*.5;
			thumbOver.y = thumbOverThinkness*.5;
			thumbOver.alpha = 0;
			thumbOver.visible = false;
		}
		private function buildImageMask():void{
			imageMask = new CFM_Graphics();
			imageMask.width = 113;
			imageMask.height = 75;
			imageMask.x = 11;
			imageMask.y = 10;
			imageMask.renderTo(labelContainer);
		}
		
		private function buildPlaceHolder():void{
			placeHolder = new CFM_Graphics(placeHolderParams);
			placeHolder.width = 113;
			placeHolder.height =75;
			placeHolder.x = 11;
			placeHolder.y = 10;
			placeHolder.renderTo(labelContainer);
		}
		private function buildImagePreloader():void{
			imagePreloader = new ImagePreloader();
			labelContainer.addChild(imagePreloader);
			imagePreloader.x = placeHolder.x + (placeHolder.width - imagePreloader.width)*.5;
			imagePreloader.y = placeHolder.y + (placeHolder.height - imagePreloader.height)*.5;
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		protected function onGetPhotoUrl(e:Event):void{
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetPhotoUrl);
			
			var data:Object = JSON.decode(loader.data);
			imageData = data;

			if(imageData) {
				var imageLoader:ImageLoader = new ImageLoader(imageData.picture, 
					{
						noCache:true,
						width:Vo.FACEBOOK_THUMB_WIDTH,
						height:Vo.FACEBOOK_THUMB_HEIGHT,
						x:1,
						scaleMode: "proportionalInside",
						onComplete:onImageLoad
					});
				imageLoader.load();
			}else{
			}

		}
		
		protected function onImageLoad(event:LoaderEvent):void {
			var image:ContentDisplay = event.target.content;
			TweenMax.from(image, .3, {alpha:0});
			if(labelContainer.contains(imagePreloader))labelContainer.removeChild(imagePreloader);
			labelContainer.addChild(image);

			buildImageMask();
			image.mask = imageMask;
			
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		protected function get thumbOverParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0];
			p.alphas = [0];
			p.width = THUMB_WIDTH+thumbOverThinkness;
			p.height = THUMB_HEIGHT+thumbOverThinkness;
			p.lineColor = Vo.RED;
			p.lineThickness = thumbOverThinkness;
			return p;
		}
		
		protected function get placeHolderParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xebebeb];
			return p;
		}
		
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.size = 12;
			p.font = Vo.FONT_MEDIUM;
			p.color = 0x333333;
			p.wordWrap = true;
			p.width = Vo.FACEBOOK_THUMB_WIDTH - 20;
			p.leading = 4;
			return p;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xffffff];
			p.lineColor = Vo.GRAY_STROKE;
			return p;
		}		
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================

		override protected function toOverState():void{
			TweenMax.to(thumbOver, .3, {autoAlpha:1});
		}
		
		override protected function toOutState(_tween:Boolean=true):void{
			TweenMax.to(thumbOver, _tween ? .3 : 0, {autoAlpha:0});
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		
		public function FacebookAlbumButton(_authToken:String, _index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			imageUrl = Vo.GRAPH_URL + _id + "?access_token="+ _authToken;
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(imageUrl));
			loader.addEventListener(Event.COMPLETE, onGetPhotoUrl);
		}
	}
}