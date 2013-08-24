package sharp.views.galleryModule.navigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	
	import com.greensock.TweenMax;
	
	import sharp.model.Model;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.galleryModule.GalleryPage;
	import sharp.views.galleryModule.buttons.GalleryButton;
	
	public class GalleryNavigation extends SharpNavigationTemplate
	{
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new GalleryButton(_tag.full_name, _i,_tag.@id, _tag.thumb, String(_tag.title).toUpperCase(),0,0,false,false);
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
			for(var i:String in buttonsVector){
				buttonsVector[i].alpha = 0;
				TweenMax.to(buttonsVector[i], .3, {alpha:1, delay:int(i)*.1});
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

		public function GalleryNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			buttonSpacing  = 40;
		}
	}
}