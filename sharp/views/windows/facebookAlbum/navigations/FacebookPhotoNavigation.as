package sharp.views.windows.facebookAlbum.navigations
{
	import cfm.core.buttons.CFM_SimpleButton;
	
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpNavigationEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.windows.facebookAlbum.buttons.FacebookPhotoButton;
	
	public class FacebookPhotoNavigation extends SharpNavigationTemplate
	{
		private var authToken				:String;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		public function update($imagesXMLList:XMLList):void
		{
			Out.status(this, "update");
			
			list = $imagesXMLList;
			
			//1. fade out and destroy current _buttonContainer
			//TweenLite.to(buttonContainer, .3, {autoAlpha:0, onComplete: _onButtonContainerAnimateOut});
			
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{

			return new FacebookPhotoButton(authToken, _i, _tag.@id, _tag.@value, _tag.label, 0, 0);
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		private function dispatchThis():void{
			dispatchEvent(new SharpNavigationEvent(SharpNavigationEvent.NAVIGATION_BUILD_COMPLETE,NaN, ""));
		}
		
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
		override protected function buildComplete():void{
			TweenMax.delayedCall(Vo.BUILD_DELAY, dispatchThis);
			
		}		
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function FacebookPhotoNavigation(_list:XMLList, _authToken:String, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			authToken = _authToken;
			buttonSpacing = 25;
		}
	}
}