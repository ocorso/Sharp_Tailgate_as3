package sharp.views.windows.buttons
{
	import com.greensock.TweenMax;
	
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class LikeButton extends SharpButtonTemplate
	{
		
		private var likeIcon				:LikeButtonIcon;
		private var unlikeIcon				:UnlikeButtonIcon;
		// =================================================
		// ================ Callable
		// =================================================
		
		public function toUserLikeState():void{
			//TweenMax.to(unlikeIcon, .2, {autoAlpha:1});
			//TweenMax.to(likeIcon, .2, {autoAlpha:0});
			//this.select();
			toSelectedState();
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			likeIcon = new LikeButtonIcon();
			unlikeIcon = new UnlikeButtonIcon();
			labelContainer.addChild(likeIcon);
			labelContainer.addChild(unlikeIcon);
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
		
		override protected function toSelectedState():void{
			//TweenMax.to(unlikeIcon, .2, {autoAlpha:1});
			//TweenMax.to(likeIcon, .2, {autoAlpha:0});
		}
		
		override protected function toUnselectedState():void{
			//TweenMax.to(unlikeIcon, .2, {autoAlpha:0});
			//TweenMax.to(likeIcon, .2, {autoAlpha:1});
		}
		
		public function toSelect():void{
			TweenMax.to(unlikeIcon, .2, {autoAlpha:1});
			TweenMax.to(likeIcon, .2, {autoAlpha:0});
		}
		
		public function toUnselect():void{
			TweenMax.to(unlikeIcon, .2, {autoAlpha:0});
			TweenMax.to(likeIcon, .2, {autoAlpha:1});
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function LikeButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
		}
	}
}