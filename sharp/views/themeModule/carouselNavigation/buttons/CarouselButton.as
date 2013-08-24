package sharp.views.themeModule.carouselNavigation.buttons
{
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class CarouselButton extends SharpButtonTemplate
	{
		private var tv						:TV;
		private var loader					:ImageLoader;
		private var id						:String;
		
		private var imageUrl					:String;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildBackground():void{
			
		}
		
		
		override protected function buildLabel():void{
			super.buildLabel();
			label.visible = false;
			
			tv = new TV();
			labelContainer.addChild(tv);
			tv.x = tv.width*.5;
			tv.y = tv.height*.5;
			
			loader = new ImageLoader(imageUrl + "rooms/" + id + ".jpg", 
				{name:id, 
					container:tv.holder,
					y:-30,
					width:tv.width-10, 
					height:tv.height+20,
					noCache:true,
					onComplete:onImageLoad
				});
			loader.load();
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onImageLoad(event:LoaderEvent):void {
			var image:ContentDisplay = event.target.content;
			//TweenLite.from(image, 1, {alpha:0});
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function toOverState():void{
			
		}
		
		override protected function toOutState(_tween:Boolean=true):void{
			
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function CarouselButton(_imageUrl:String, _index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			id = _id;
			imageUrl = _imageUrl;
		}

		
	}
}