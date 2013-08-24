package sharp.views.themeModule.dropdownNavigation.buttons
{
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenMax;
	
	import flash.filters.DropShadowFilter;
	
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class DropdownThumbButton extends SharpButtonTemplate
	{
		
		private var colorSwatch				:CFM_Graphics;
		private var colorValue				:uint;
		private var colorOver				:CFM_Graphics;
		
		private const colorOverThinkness	:int = 4;
		private const THUMB_SIZE			:Number = 45;

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildBackground():void{
			
		}
		override protected function buildLabel():void{
			buildColorSwatch();
			buildColorOver();
			
			labelContainer.filters = [new DropShadowFilter(1,45,0,.3,2,2,1,3)];
		}
		private function buildColorSwatch():void{
			colorSwatch = new CFM_Graphics(colorParams);
			colorSwatch.renderTo(labelContainer);
		}
		private function buildColorOver():void{
			colorOver = new CFM_Graphics(colorOverParams);
			colorOver.renderTo(labelContainer);
			colorOver.setProperties({x:colorOverThinkness*.5, y:colorOverThinkness*.5});
			colorOver.alpha = 0;
			colorOver.visible = false;
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		private function get colorParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [colorValue];
			p.width = THUMB_SIZE;
			p.height = THUMB_SIZE;
			p.lineColor = 0xbebebe;
			return p;
		}
		
		private function get colorOverParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0];
			p.alphas = [0];
			p.width = THUMB_SIZE-colorOverThinkness*.5;
			p.height = THUMB_SIZE-colorOverThinkness*.5;
			p.lineColor = 0x999999;
			p.lineThickness = colorOverThinkness;
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function toOverState():void{
			TweenMax.to(colorOver, .3, {autoAlpha:1});
		}
		override protected function toOutState(_tween:Boolean=true):void{
			TweenMax.to(colorOver, _tween ? .3 : 0, {autoAlpha:0});
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function DropdownThumbButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			
			colorValue = uint(_value);
		}

	}
}