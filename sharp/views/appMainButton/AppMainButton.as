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
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.ThemeParams;
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class AppMainButton extends SharpButtonTemplate
	{
		protected var redIcon					:RedArrowIcon;
		protected var greyBG					:CFM_Graphics;
		protected var gradientOutline			:Shape;
		protected var value						:String;
		protected var colorSwatch				:CFM_Graphics;
		protected var colorSwatchOutline		:Shape;
		
		protected var SQUARE_SIZE				:Number = 32;
		
		private const WARNING_MOVE				:Number = 20;
		private const COLOR_SWATCH_SIZE			:Number = 17;
		
		// =================================================
		// ================ Callable
		// =================================================
		public function centerLabel():void{
			labelContainer.setProperties({x:(background.width - labelContainer.width)*.5});
		}
		
		public function dropdownOpen():void{
			redIcon.rotation = 90;
			redIcon.x = greyBG.x + (greyBG.width - redIcon.width)*.5 + redIcon.width;
		}
		
		public function dropdownClose():void{
			redIcon.rotation = 0;
			redIcon.x = greyBG.x + (greyBG.width - redIcon.width)*.5;
		}
		
		public function updateColor(_colorValue:uint):void{
			if(value=="primary_color" || value=="secondary_color") {
				buildColorSwatch(_colorValue);
				TweenMax.to(colorSwatch, 0, {tint:_colorValue});
			}
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			labelContainer.filters = [new DropShadowFilter(1,45,0,.5,2,2,1,3)];
		}
		override protected function buildBackground():void{
			super.buildBackground();
			buildGreyBG();
			buildIcon();
		}
		
		protected function buildGreyBG():void{
			greyBG = new CFM_Graphics(greyParams);
			greyBG.renderTo(backgroundContainer);
			
		}
		
		protected function buildIcon():void{
			redIcon = new RedArrowIcon();
			backgroundContainer.addChild(redIcon);
		}
		
		private function buildColorSwatch(_colorValue:uint):void{
			if(!colorSwatch){
				colorSwatch = new CFM_Graphics();
				colorSwatch.renderTo(labelContainer);
				colorSwatch.setProperties({x:label.width + 4});
				colorSwatch.width = COLOR_SWATCH_SIZE;
				colorSwatch.height = COLOR_SWATCH_SIZE;
				
				colorSwatchOutline = new Shape();
				colorSwatchOutline.graphics.lineStyle(1, Vo.GRAY_STROKE);
				colorSwatchOutline.graphics.lineTo(0,COLOR_SWATCH_SIZE);
				colorSwatchOutline.graphics.lineTo(COLOR_SWATCH_SIZE,COLOR_SWATCH_SIZE);
				colorSwatchOutline.graphics.lineTo(COLOR_SWATCH_SIZE,0);
				colorSwatchOutline.graphics.lineTo(0,0);
				labelContainer.addChild(colorSwatchOutline);
				colorSwatchOutline.x = colorSwatch.x;
				colorSwatchOutline.y = colorSwatch.y;
			}
			
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
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_BOLD;
			p.color = 0xffffff;
			p.size = 15;
			if(value == "tv_sizes"){
				p.width = 160;
				p.wordWrap = true;
				p.align = "center";
			}
			return p;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [Vo.RED, Vo.DARK_RED];
			p.alphas = [1,1];
			//p.lineColor = 0xde2729;
			return p;
		}
		
		protected function get greyParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xededed, 0xd6d6d6];
			p.alphas = [1,1];
			p.width = SQUARE_SIZE;
			p.height = SQUARE_SIZE;
			p.lineColor = 0xacacac;
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
			
			hit.width = background.width + greyBG.width;
			
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
			
			if(Vo.LEFT_BUTTONS.indexOf(value)!=-1){
				background.x = greyBG.width-1;
				gradientOutline.x = background.x;
				labelContainer.x = background.x + paddingH;
				redIcon.scaleX = -1;
				redIcon.x = greyBG.x + redIcon.width + (greyBG.width - redIcon.width)*.5 - 1;
			}else{
				greyBG.x = background.width;
				redIcon.x = greyBG.x + (greyBG.width - redIcon.width)*.5 + 1;
			}
			redIcon.y = greyBG.y + (greyBG.height - redIcon.height)*.5;

		}
		// =================================================
		// ================ Constructor
		// =================================================
		public function AppMainButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			value = _value;

		}
		
	}
}