package sharp.views.windows.facebookAlbum.navigations
{
	import cfm.core.buttons.CFM_SimpleButton;
	
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.windows.facebookAlbum.buttons.FacebookAlbumButton;
	
	public class FacebookAlbumNavigation extends SharpNavigationTemplate
	{
		
		private var authToken						:String
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new FacebookAlbumButton(authToken, _i, _tag.@id, _tag.@album_id, _tag.label,0,0);
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

		public function FacebookAlbumNavigation(_list:XMLList, _authToken:String, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			authToken = _authToken;
			buttonSpacing = 28;
		}
	}
}