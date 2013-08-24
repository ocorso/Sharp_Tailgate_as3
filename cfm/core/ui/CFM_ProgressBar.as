package cfm.core.ui
{	
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.objects.CFM_Object;
	import cfm.core.objects.CFM_ScrollBar;
	import cfm.core.vo.CFM_GraphicsParams;
		
	public class CFM_ProgressBar extends CFM_Object
	{		
		protected var container			:CFM_ObjectContainer;
		protected var containerMask		:CFM_Graphics;
		
		protected var background		:CFM_Graphics;
		protected var loadProgress		:CFM_Graphics;
		protected var playProgress		:CFM_Graphics;
		protected var overlay			:CFM_Graphics;
		
		protected var totalWidth		:Number;
		protected var totalHeight		:Number;
		
		protected var status			:Object;
		
		public function CFM_ProgressBar(_width:Number, _height:Number, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			totalWidth 				= _width;
			totalHeight 			= _height;
			status 					= new Object();
			
			super("ProgressBar", _autoInit, _autoDestroy);
		}
		
		override public function get width():Number{
			return totalWidth;
		}
		
		override protected function build():void{
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			
			buildBackground();
			buildLoadingProgress();
			buildPlayProgress();
			buildOverlay();
			
			buildContainerMask();
			container.mask = containerMask;
		}
		
		protected function buildBackground():void{
			background = new CFM_Graphics(backgroundParams);
			background.renderTo(container);
		}
		
		protected function buildLoadingProgress():void{
			loadProgress = new CFM_Graphics( loadingParams );
			loadProgress.renderTo(container);
		}
		
		protected function buildPlayProgress():void{
			playProgress = new CFM_Graphics( playParams );
			playProgress.renderTo(container);
		}
		
		protected function buildOverlay():void{
			overlay = new CFM_Graphics( overlayParams );
			overlay.renderTo(container);
		}
		
		protected function buildContainerMask():void{
			containerMask = new CFM_Graphics( maskParams );
			containerMask.renderTo(container);
		}
		
		protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = baseParams
			return p;
		}
		
		protected function get loadingParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = baseParams;
			return p;
		}
		
		protected function get playParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = baseParams;
			return p;
		}
		
		protected function get maskParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = baseParams
			return p;
		}
		
		protected function get overlayParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = baseParams
			return p;
		}
		
		protected function get baseParams():CFM_GraphicsParams{
			return new CFM_GraphicsParams({width:totalWidth, height:totalHeight, corners:[0]});
		}
		
		public function onLoadProgress(_percent:Number):void{
			status.laodProgress = _percent;
			
			if(loadProgress) loadProgress.scaleX = status.laodProgress;
		}
		
		public function onPlayProgress(_percent:Number):void{
			status.playProgress = _percent;
			
			if(playProgress) playProgress.scaleX = status.playProgress;
		}
		
		public function get playPercent():Number{return status.playProgress;}
	}
}