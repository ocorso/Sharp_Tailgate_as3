package sharp.views.customizeModule.subPages
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appMainNavigation.AppMainNavigation;
	import sharp.views.appTemplate.SharpPageTemplate;
	
	public class FinishPage extends SharpPageTemplate
	{
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		public function updateHeading(_txt:String):void{
			heading.text = _txt;
			Out.info(this, subHeading.text);
			heading.alpha = 0;
			heading.visible = false;
			heading.x = -50;
			TweenMax.to(heading, .5, {delay:.1, autoAlpha:1, x:Vo.MARGIN_LEFT - 5, ease:Cubic.easeOut});
			subHeading.alpha = 0;
			subHeading.visible = false;
			subHeading.x = -50;
			TweenMax.to(subHeading, .5, {delay:.2, autoAlpha:1, x:Vo.MARGIN_LEFT - 2, ease:Cubic.easeOut});
			
			pageNavigation.buttonContainer.alpha = 1;
			AppMainNavigation(pageNavigation).showButton();
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			pageNavigation.scaleX = pageNavigation.scaleY = Vo.SMALL_PAGE_NAV_SCALE + .05;
			pageNavigation.setProperties({x:Vo.MARGIN_LEFT, y:Vo.DROPDOWN_MENU_Y - 5});
			pageNavigation.buttonContainer.alpha = 0;
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

		public function FinishPage(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
		}
	}
}