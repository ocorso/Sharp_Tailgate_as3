package sharp.views.windows.buttons
{
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class WindowCloseButton extends SharpButtonTemplate
	{
		
		private var closeIcon					:CloseButtonIcon;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			closeIcon = new CloseButtonIcon();
			labelContainer.addChild(closeIcon);
		}
		
		override protected function buildBackground():void{
			
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
		override protected function toOverState():void{
		}
		override protected function toOutState(_tween:Boolean=true):void{
		}
		
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function WindowCloseButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
		}
	}
}