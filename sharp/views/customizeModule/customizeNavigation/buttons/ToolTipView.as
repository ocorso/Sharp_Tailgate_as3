package sharp.views.customizeModule.customizeNavigation.buttons
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	
	import sharp.model.vo.Vo;
	
	public class ToolTipView extends CFM_ObjectContainer
	{
		private var _tooltipContainer				:CFM_ObjectContainer;
		private var _background						:Shape;
		private var _label							:CFM_TextField;
		private var _labelText						:String;
		
		private var BACKGROUND_WIDTH				:Number;
		private var BACKGROUND_HEIGHT				:Number;
		private const MOVE_AMOUNT					:Number = 30;
		// =================================================
		// ================ Callable
		// =================================================
		public function showTooltip():void{
			TweenMax.to(_tooltipContainer, .3, {y:0, autoAlpha:1, ease:Cubic.easeOut});
		}
		public function hideTooltip():void{
			if(_tooltipContainer.visible) TweenMax.to(_tooltipContainer, .3, {y:MOVE_AMOUNT, autoAlpha:0, ease:Cubic.easeOut});
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		private function buildTooltipContainer():void{
			_tooltipContainer = new CFM_ObjectContainer();
			_tooltipContainer.renderTo(this);
		}
		private function buildBackground():void{
			
			var corner:Number = 6;
			var w:Number = BACKGROUND_WIDTH;
			var h:Number = BACKGROUND_HEIGHT;
			var arrowHeight:Number = 8;
			var arrowWidth:Number = 16;
			var arrowStart:Number = BACKGROUND_WIDTH*.5 + arrowWidth*.5;
			
			_background = new Shape();
			_background.graphics.lineStyle(2, Vo.GRAY_STROKE);
			_background.graphics.beginFill(0xffffff);
			_background.graphics.moveTo( 0, corner );
			_background.graphics.curveTo( 0, 0, corner, 0 );
			_background.graphics.lineTo(w - corner, 0);
			_background.graphics.curveTo( w, 0, w, corner );
			_background.graphics.lineTo(w, h - corner);
			_background.graphics.curveTo( w, h, w - corner, h );
			_background.graphics.lineTo(arrowStart, h);
			_background.graphics.lineTo(arrowStart - arrowWidth*.5, h + arrowHeight);
			_background.graphics.lineTo(arrowStart - arrowWidth, h);
			_background.graphics.lineTo(corner, h);
			_background.graphics.curveTo( 0, h, 0, h - corner );
			
			_background.graphics.endFill();
			
			_tooltipContainer.addChildAt(_background,0);
			
			_background.filters = [new DropShadowFilter(0,0,0,.3,10,10,1,3)];
		}
		
		private function buildLabel():void{
			_label = new CFM_TextField(_labelText,labelParams);
			_label.renderTo(_tooltipContainer);
			_label.setProperties({x:(BACKGROUND_WIDTH - _label.width)*.5, y:(BACKGROUND_HEIGHT - _label.height)*.5});
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
		private function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.size = 12;
			p.font = Vo.FONT_MEDIUM;
			p.width = BACKGROUND_WIDTH - 20;
			p.wordWrap = true;
			p.font = Vo.FONT_MEDIUM;
			p.leading = 4;
			return p;
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

		public function ToolTipView(_labelTxt:String, _width:Number, _height:Number)
		{
			super(true);
			_labelText = _labelTxt;
			BACKGROUND_WIDTH = _width
			BACKGROUND_HEIGHT = _height;
			buildTooltipContainer();
			buildBackground();
			buildLabel();
			
			_tooltipContainer.y = MOVE_AMOUNT;
			_tooltipContainer.visible = false;
			_tooltipContainer.alpha = 0;
		}
	}
}