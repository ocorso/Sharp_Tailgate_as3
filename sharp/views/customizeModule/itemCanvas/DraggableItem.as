package sharp.views.customizeModule.itemCanvas
{
	import cfm.core.containers.CFM_ObjectContainer;
	
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import net.ored.util.out.Out;
	
	import sharp.utils.getItemDefinition;

	
	public class DraggableItem extends CFM_ObjectContainer
	{
		
		private var imageURL			:String;
		private var loader				:ImageLoader;
		private var color1				:uint;
		private var color2				:uint;
		private var ImageClass			:Class;
		private var imageClip			:MovieClip;
		private var colorType			:String;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
	
		private function buildImage():void{
			
			Out.info(this, colorType)
			
			if(colorType == "true"){
				imageClip = getItemDefinition(imageURL);
				addChild(imageClip);
				if(imageClip.primary) TweenMax.to(imageClip.primary, .5, {colorMatrixFilter:{colorize:color1, amount:1, contrast:2}});
				if(imageClip.secondary) TweenMax.to(imageClip.secondary, .5, {colorMatrixFilter:{colorize:color2, amount:1, contrast:2}});
			}else{
				loader = new ImageLoader(imageURL, 
					{ 
						container:this,
						noCache:true,
						centerRegistration:true,
						onComplete:onImageLoad
					});
				loader.load();
			}
		}

		// =================================================
		// ================ Workers
		// =================================================
		
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onImageLoad(event:LoaderEvent):void {
			var image:ContentDisplay = event.target.content;
			image.alpha = 0;
			TweenMax.to(image, .5, {alpha:1});

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
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function DraggableItem(_color1:uint, _color2:uint, _imgUrl:String, _colorType:String)
		{
			super(true);
			
			imageURL = _imgUrl;
			
			colorType = _colorType;
			
			if(_colorType == "true"){
				color1 = _color1;
				color2 = _color2;
			}
			
			buildImage();

		}
	}
}