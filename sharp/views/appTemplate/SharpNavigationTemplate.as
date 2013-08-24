package sharp.views.appTemplate
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.navigation.CFM_SimpleNavigation;
	
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpNavigationEvent;
	import sharp.model.vo.Vo;
	
	public class SharpNavigationTemplate extends CFM_SimpleNavigation
	{

		// =================================================
		// ================ Callable
		// =================================================
		public function enableButtons():void{
			for each(var btn:CFM_SimpleButton in buttonsVector){
				btn.enable();
			}
		}
		public function disableButtons():void{
			for each(var btn:CFM_SimpleButton in buttonsVector){
				btn.disable();
			}
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		private function dispatchThis():void{
			dispatchEvent(new SharpNavigationEvent(SharpNavigationEvent.NAVIGATION_BUILD_COMPLETE, NaN,""));
		}
		
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
		override protected function buildComplete():void{
			TweenMax.delayedCall(Vo.BUILD_DELAY, dispatchThis);
		}
		
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function SharpNavigationTemplate(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
		}

	}
}