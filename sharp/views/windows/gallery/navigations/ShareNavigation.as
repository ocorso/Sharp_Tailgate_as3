package sharp.views.windows.gallery.navigations
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.windows.gallery.buttons.ShareButton;
	
	public class ShareNavigation extends SharpNavigationTemplate
	{
		
		private var heading		:CFM_TextField;
		
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			buildHeading();
		}
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new ShareButton(_i,_tag.@id,_tag.@value,"",0,0,allowMultipleSelect,false, _tag.@href);
		}
		
		private function buildHeading():void{
			heading = new CFM_TextField("Share this Tailgate:", headingParams);
			heading.renderTo(this);
			buttonContainer.x = heading.x + heading.width + 10;
			heading.y = 5;
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
		private function get headingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.size = 18;
			p.font = Vo.FONT_MEDIUM;
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

		
		public function ShareNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			
			buttonSpacing = 7;
		}
		
		
	}
}