package sharp.views.appTemplate
{
	import cfm.core.objects.CFM_ScrollBar;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import sharp.model.vo.Vo;
	
	public class SharpScrollbar extends CFM_ScrollBar
	{

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
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
		override protected function get slideBackgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = super.slideBackgroundParams;
			p.colors = [0xededed, 0xe0e0e0];
			p.alphas = [1,1];
			return p;
		}
		
		override protected function get thumbParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();

			p.x = 0;
			p.y = 0;
			p.gradRotation = 0;
			p.colors = [Vo.RED, Vo.DARK_RED];
			p.alphas = [1,1];
			p.width = thumbWidth;
			p.height = dragAreaRec.height;
			

			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function toOverState():void{
			//TweenMax.to(thumb, .2, {tint:0xFFFFFF, ease:Linear.easeNone});
		}
		
		override protected function toOutState(_tween:Boolean = true):void{
			//TweenMax.to(thumb, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
		}
		
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function SharpScrollbar(_slideWidth:Number, _thumbWidth:Number, _height:Number, _vertical:Boolean=false, autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_slideWidth, _thumbWidth, _height, _vertical, autoInit, _autoDestroy);
		}

	}
}