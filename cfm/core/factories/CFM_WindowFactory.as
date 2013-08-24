package cfm.core.factories
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	public class CFM_WindowFactory extends CFM_PageFactory
	{
		protected var overlay:CFM_Graphics;
		
		public function CFM_WindowFactory(_pageContainer:CFM_ObjectContainer, _pageList:XMLList)
		{
			super(_pageContainer,_pageList);
			
			buildOverlay();
		}
		
		protected function buildOverlay():void{
			overlay = new CFM_Graphics(overlayParams);
			overlay.renderTo(pageContainer);
			hideOverlay(false);
		}
		
		protected function get overlayParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xFFFFFF];
			p.alphas = [.8];
			return p;
		}
		
		public function showOverlay(_tween:Boolean = true):void{
			TweenMax.killTweensOf(overlay);
			TweenMax.to(overlay, _tween ? .4 : 0, {autoAlpha:1, ease:Cubic.easeInOut});
		}
		
		public function hideOverlay(_tween:Boolean = true):void{
			TweenMax.killTweensOf(overlay);
			TweenMax.to(overlay, _tween ? .4 : 0, {autoAlpha:0, ease:Cubic.easeInOut});
		}
		
		override public function removeCurrentPage(_tween:Boolean = true):void{
			super.removeCurrentPage(_tween);
			hideOverlay();
		}
		
		override protected function newPage(_params:Object = null):void{
			showOverlay();
			super.newPage(_params);
		}
		
		public function resize(_w:Number, _h:Number):void{
			overlay.redraw(_w,_h,-_w*.5,-_h*.5);
			pageContainer.setProperties({x:_w*.5, y:_h*.5});
		}
	}
}