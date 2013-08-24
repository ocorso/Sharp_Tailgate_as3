package sharp.views.themeModule.dropdownNavigation.navigations
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.navigation.CFM_SimpleNavigation;
	
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.themeModule.dropdownNavigation.buttons.DropdownListButton;
	import sharp.views.themeModule.dropdownNavigation.buttons.DropdownThumbButton;
	
	public class DropdownListNavigation extends SharpNavigationTemplate
	{
		private var buttonWidth				:Number;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new DropdownListButton(buttonWidth, _i,_tag.@id,_tag.@value,_tag.label,8,5,allowMultipleSelect,hasSelectedState,_tag.@href);
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
		// ================ Interfaced
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

		public function DropdownListNavigation(_buttonWidth:Number, _list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			buttonSpacing = 0;
			buttonWidth = _buttonWidth;
		}
	}
}