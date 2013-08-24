package sharp.views.appTemplate
{
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.templates.CFM_PageTemplate;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpPageEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appMainNavigation.AppMainNavigation;
	
	
	public class SharpPageTemplate extends CFM_PageTemplate
	{
		protected var subHeading				:CFM_TextField;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildHeading():void{
			super.buildHeading();
			heading.setProperties({x:-100, y:Vo.HEADING_Y});
			heading.alpha = 0;
			if(xml.subHeading.length() > 0) buildSubHeading();
		}
		
		private function buildSubHeading():void{
			subHeading = new CFM_TextField(xml.subHeading, subHeadingParams);
			subHeading.renderTo(_content);
			subHeading.setProperties({x:-100, y:heading.y + heading.height});
			subHeading.alpha = 0;
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		private function dispatchThis():void{
			dispatchEvent(new SharpPageEvent(SharpPageEvent.PAGE_BUILD_COMPLETE,xml.@id));
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
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.alphas = [0];
			return p;
		}
		
		override protected function get headingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.size = 30;
			p.font = Vo.FONT_MEDIUM;
			p.color = Vo.BLACK;
			return p;
		}
		
		private function get subHeadingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = headingParams;
			p.size = 18;

			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function buildComplete():void{
			super.buildComplete();
			TweenMax.delayedCall(Vo.BUILD_DELAY, dispatchThis);
		}
		
		
		override protected function getNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0):CFM_SimpleNavigation{
			return new AppMainNavigation(_list);
		}
		
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function SharpPageTemplate(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
		}

	}
}