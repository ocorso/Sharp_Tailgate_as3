package sharp.views.themeModule.dropdownNavigation.navigations
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.graphics.CFM_Graphics;
	
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.themeModule.dropdownNavigation.buttons.DropdownThumbButton;
	
	public class DropdownThumbNavigation extends SharpNavigationTemplate
	{
		private var buttonWidth				:Number;
		private var background				:Shape;
		
		private const BACKGROUND_WIDTH		:Number = 240;
		private const BACKGROUND_HEIGHT		:Number = 185;
		private const NECK_HEIGH			:Number = 5;

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			buildBackground();
			super.build();	
			buttonContainer.setProperties({x:(background.width - buttonContainer.width)*.5, y:(background.height - buttonContainer.height)*.5 + 2});
			
		}
		
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new DropdownThumbButton(_i,_tag.@id,_tag.@value,_tag.label,0,0,allowMultipleSelect,hasSelectedState,_tag.@href);
		}
		
		private function buildBackground():void{
			background = new Shape();
			background.graphics.lineStyle(1, 0xcdcdcd);
			background.graphics.beginFill(0xffffff);
			background.graphics.moveTo(0,0);
			background.graphics.lineTo(0,BACKGROUND_HEIGHT);
			background.graphics.lineTo(BACKGROUND_WIDTH,BACKGROUND_HEIGHT);
			background.graphics.lineTo(BACKGROUND_WIDTH,NECK_HEIGH);
			background.graphics.lineTo(buttonWidth,NECK_HEIGH);
			background.graphics.lineTo(buttonWidth,0);
			background.graphics.lineTo(0,0);
			this.addChild(background);
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
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function DropdownThumbNavigation(_buttonWidth:Number, _list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			buttonSpacing = 10;
			buttonWidth = _buttonWidth + 32;
		}

	}
}