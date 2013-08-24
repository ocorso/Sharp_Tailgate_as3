package sharp.views.appMainNavigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import sharp.views.appMainButton.AppMainButton;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	
	public class AppMainNavigation extends SharpNavigationTemplate
	{
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			var selectState:Boolean;
			
			return new AppMainButton(_i, _tag.@id, _tag.@value, _tag.label,16,7,false,false) as CFM_SimpleButton;
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
		public function showButton():void{
			for (var j:String in buttonsVector){
				buttonsVector[j].alpha = 0;
				buttonsVector[j].visible = false;
				buttonsVector[j].x = buttonsVector[j].x - 30;
				TweenMax.to(buttonsVector[j], .3, {autoAlpha:1, x:buttonsVector[j].x + 30, delay:.2 + int(j)*.1, ease:Cubic.easeOut});
			}
		}
		
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
		public function AppMainNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			buttonSpacing = 45;
		}

	}
}