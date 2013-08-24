package sharp.views.galleryModule.buttons
{
	import cfm.core.vo.CFM_GraphicsParams;
	
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class ShareButton extends SharpButtonTemplate
	{
		
		protected var id					:String;
		
		protected var facebookIcon			:FacebookIcon;
		protected var twitterIcon			:TwitterIcon;
		protected var emailIcon				:EmailIcon;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			
			switch(id){
				case "facebook":
					facebookIcon = new FacebookIcon();
					labelContainer.addChild(facebookIcon);
					break;
				case "twitter":
					twitterIcon = new TwitterIcon();
					labelContainer.addChild(twitterIcon);
					break;
				case "email":
					emailIcon = new EmailIcon();
					labelContainer.addChild(emailIcon);
					break;
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
			var p:CFM_GraphicsParams = super.backgroundParams;
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
			killTweens();
			//TweenMax.to(labelContainer, .2, {tint:_m.uiManager.HEADER_BUTTON_OVER_COLOR, ease:Linear.easeNone});
		}
		
		override protected function toOutState(_tween:Boolean = true):void{
			killTweens();
			//TweenMax.to(labelContainer, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function ShareButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			
			id = _id;
		}
	}
}