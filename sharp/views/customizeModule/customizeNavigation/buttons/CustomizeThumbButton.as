package sharp.views.customizeModule.customizeNavigation.buttons
{
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Image;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.utils.getItemDefinition;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class CustomizeThumbButton extends SharpButtonTemplate
	{
		
		private const THUMB_SIZE				:Number = 85;

		private var id							:String;
		private var loader						:ImageLoader;
		private var imageUrl					:String;
		private var imageClip					:MovieClip;
		private var thumbOver					:CFM_Graphics;
		private var color1						:uint;
		private var color2						:uint;
		private const thumbOverThinkness		:int = 4;

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		

		override protected function buildBackground():void{
			super.buildBackground();
			buildThumbImage();
			backgroundContainer.filters = [new DropShadowFilter(1,45,0,.2,2,2,1,3)];
			
			buildThumbOver();
		}
		
		override protected function buildLabel():void{
		}
		
		private function buildThumbOver():void{
			thumbOver = new CFM_Graphics(thumbOverParams);
			thumbOver.renderTo(labelContainer);
			thumbOver.setProperties({x:thumbOverThinkness*.5, y:thumbOverThinkness*.5});
			thumbOver.alpha = 0;
			thumbOver.visible = false;
		}

		private function buildThumbImage():void{
			
			if(imageUrl){
				loader = new ImageLoader(imageUrl, 
					{name:id, width:THUMB_SIZE-5, height:THUMB_SIZE-5, x:3, y:3, smoothing:true, scaleMode:"proportionalInside", container:backgroundContainer, onComplete:onImageLoad});
				loader.load();
			}else{
				
				imageClip = getItemDefinition(id);
				backgroundContainer.addChild(imageClip);
				if(imageClip.height > THUMB_SIZE-10){
					imageClip.scaleY = (THUMB_SIZE-15)/imageClip.height;
					imageClip.scaleX = imageClip.scaleY;
				}
				
				if(imageClip.width > THUMB_SIZE-10){
					imageClip.scaleX = (THUMB_SIZE-15)/imageClip.width;
					imageClip.scaleY = imageClip.scaleX;
				}
				
				imageClip.x = (background.width - imageClip.width)*.5 + imageClip.width*.5;
				
				if(id == "Banner") {
					imageClip.scaleX = imageClip.scaleY = .1;
					imageClip.x = (background.width - imageClip.width)*.5;
				}
				
				imageClip.y = (background.height - imageClip.height)*.5 + imageClip.height*.5;
				if(imageClip.primary) TweenMax.to(imageClip.primary, 0, {tint:color1});
				if(imageClip.secondary) TweenMax.to(imageClip.secondary, 0, {tint:color2});
			}
		}

		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		private function onImageLoad (e:LoaderEvent):void{
			var image:ContentDisplay = e.target.content;
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xffffff];
			p.lineColor = Vo.GRAY_STROKE;
			p.width =THUMB_SIZE;
			p.height = THUMB_SIZE;
			return p;
		}
		
		private function get thumbOverParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0];
			p.alphas = [0];
			p.width = THUMB_SIZE-thumbOverThinkness*.5;
			p.height = THUMB_SIZE-thumbOverThinkness*.5;
			p.lineColor = Vo.RED;
			p.lineThickness = thumbOverThinkness;
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
		
		override protected function resizeGraphics():void{
			_hitWidth = THUMB_SIZE;
			_hitHeight = THUMB_SIZE;
			super.resizeGraphics();
		}

		// =================================================
		// ================ Constructor
		// =================================================
		public function CustomizeThumbButton(_color1:uint, _color2:uint, _imageUrl:String, _index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			
			id = _id;
			if(_imageUrl){
				imageUrl = _imageUrl;
			}else{
				color1 = _color1;
				color2 = _color2;

			}
		}
	}
}