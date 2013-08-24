package sharp.views.windows.facebookAlbum.buttons
{
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;

	public class FacebookPhotoButton extends FacebookAlbumButton
	{
		private var id					:String;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================

		override protected function onGetPhotoUrl(e:Event):void{
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
				
				//Check if this image has already listed in Facebook selected image navigation panel
				for (var i:int = 0; i < Vo.customizeParams.photoIds.length; i++){
					if (Vo.customizeParams.photoIds[i] == imageData.id)
						this.select(false);
				}
				
			}else{
			}
		}		
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		override protected function get thumbOverParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0];
			p.alphas = [0];
			p.width = THUMB_WIDTH+thumbOverThinkness;
			p.height = THUMB_HEIGHT+thumbOverThinkness + 10;
			p.lineColor = Vo.RED;
			p.lineThickness = thumbOverThinkness;
			return p;
		}
		
		public function get photoUrl():String{
			return imageData.source;
		}
		

		public function get thumbUrl():String{
			return imageData.picture;
		}		
		
		public function get photoId():String{
			return imageData.id;
		}		
		
		public function get photoImage():* {
			return placeHolder;
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

		public function FacebookPhotoButton(_authToken:String, _index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_authToken, _index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			
			THUMB_WIDTH = 126;
			THUMB_HEIGHT = 77;

			
			id = _id;


		}
	}
}