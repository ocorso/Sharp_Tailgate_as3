package sharp.views.themeModule.carouselNavigation.buttons
{
	import cfm.core.vo.CFM_GraphicsParams;
	
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class ArrowButton extends SharpButtonTemplate
	{
		
		private var arrowIcon				:ArrowIcon;
		private var id						:String;

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			arrowIcon = new ArrowIcon();
			labelContainer.addChild(arrowIcon);
			
			if(id == "right") {
				arrowIcon.scaleX = -1;
				arrowIcon.x = arrowIcon.width;
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
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.alphas = [0];
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

		// =================================================
		// ================ Constructor
		// =================================================
		public function ArrowButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			id = _id;
		}

	}
}