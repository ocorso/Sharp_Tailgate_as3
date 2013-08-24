package sharp.views.appMainButton
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
	
	public class SimpleRedButton extends SharpButtonTemplate
	{
		private var gradientOutline			:Shape;
		private var deActivateGraph			:CFM_Graphics;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			labelContainer.filters = [new DropShadowFilter(1,45,0,.5,2,2,1,3)];
		}
		
		override protected function buildBackground():void{
			super.buildBackground();
			buildDeActiveGraph();
		}
		
		private function buildDeActiveGraph():void{
			deActivateGraph = new CFM_Graphics(deActivateParams);
			deActivateGraph.renderTo(backgroundContainer);
			deActivateGraph.visible = false;
			deActivateGraph.alpha = 0;
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
			//p.lineColor = 0xde2729;
			return p;
		}
		
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_BOLD;
			p.color = 0xffffff;
			p.size = 13;
			return p;
		}
		
		private function get deActivateParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [Vo.GRAY_STROKE, Vo.GRAY_TEXT];
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
			
		}
		
		override protected function toOutState(_tween:Boolean=true):void{
			
		}
		override protected function resizeGraphics():void{
			super.resizeGraphics();
			deActivateGraph.setProperties({width:background.width, height:background.height});
			
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

		}
		
//		override public function activate():void{
//			isActive = true;
//			hit.visible = true;
//			TweenMax.to(deActivateGraph, .2, {autoAlpha:0});
//			TweenMax.to(gradientOutline, .2, {autoAlpha:1});
//			
//		}
//		
//		override public function deActivate():void{
//			isActive = false;
//			hit.visible = false;
//			TweenMax.to(deActivateGraph, .2, {autoAlpha:1});
//			TweenMax.to(gradientOutline, .2, {autoAlpha:0});
//		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function SimpleRedButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
		}
	}
}