package sharp.views.customizeModule.customizeNavigation.buttons
{
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class YoutubeBrowseButton extends SharpButtonTemplate
	{
		private var gradientOutline			:Shape;
		private var youtubeLogo				:YoutubeLogo;
		private var overGraph				:CFM_Graphics;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			labelContainer.filters = [new DropShadowFilter(1,45,0,.5,2,2,1,3)];
			buildYoutubeLogo();
			labelContainer.y = 5;
		}
		override protected function buildBackground():void{
			super.buildBackground();
			buildOverGraph();
		}
		private function buildYoutubeLogo():void{
			youtubeLogo = new YoutubeLogo();
			labelContainer.addChild(youtubeLogo);
			youtubeLogo.x = label.x + label.width + 8;
			label.y = 5;
		}
		
		private function buildOverGraph():void{
			overGraph = new CFM_Graphics(overGraphParams);
			overGraph.renderTo(backgroundContainer);
			overGraph.visible = false;
			overGraph.alpha = 0;
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
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [Vo.RED, Vo.DARK_RED];
			p.alphas = [1,1];
			return p;
		}
		
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_BOLD;
			p.color = 0xffffff;
			p.size = 13;
			return p;
		}
		
		private function get overGraphParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [Vo.DARK_RED, Vo.RED];
			p.alphas = [1,1];
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function toOverState():void{
			killTweens();
			TweenMax.to(overGraph, .3, {autoAlpha:1});
			
		}
		
		override protected function toOutState(_tween:Boolean=true):void{
			killTweens();
			TweenMax.to(overGraph, (_tween) ? .3 : 0, {autoAlpha:0});
		}
		override protected function resizeGraphics():void{
			super.resizeGraphics();
			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox(100, 50, Math.PI/2, 0, 0); 
			
			gradientOutline = new Shape();
			gradientOutline.graphics.lineStyle(1);
			gradientOutline.graphics.lineGradientStyle(GradientType.LINEAR, [0x9e0705, 0xfb1d1f], [1,1], [0,255], matrix);
			gradientOutline.graphics.lineTo(0,background.height);
			gradientOutline.graphics.lineTo(background.width,background.height);
			gradientOutline.graphics.lineTo(background.width,0);
			gradientOutline.graphics.lineTo(0,0);
			backgroundContainer.addChild(gradientOutline);
			
			overGraph.setProperties({width:background.width, height:background.height});
			
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function YoutubeBrowseButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
		}
	}
}