package sharp.views.windows
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.templates.CFM_PageTemplate;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpWindowEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appMainNavigation.AppMainNavigation;
	import sharp.views.windows.buttons.WindowCloseButton;
	
	public class SharpPopupWindowTemplate extends CFM_PageTemplate
	{
		protected var _totalWidth			:Number = 500;
		protected var _totalHeight			:Number = 500;
		protected var _dropShadow			:DropShadowFilter;
		protected var overlay				:CFM_Graphics;
		
		
		// =================================================
		// ================ Callable
		// =================================================
		public function closeWindow():void{
			TweenMax.to(this, .5, {autoAlpha:0});
		}
		public function resize(_w:Number, _h:Number):void{
			overlay.redraw(_w,_h,-_w*.5,-_h*.5);
		}
		// =================================================
		// ================ Create and Build
		// =================================================
		protected function buildOverlay():void{
			overlay = new CFM_Graphics(overlayParams);
			overlay.renderTo(this,0);
		}
		
		override protected function buildCloseButton():void{
			closeButton = new WindowCloseButton(0,"close","close","",4,4,false,false);
			closeButton.renderTo(_container);
			closeButton.setProperties({y:4, x:_totalWidth-closeButton.width-4 });
		}
		
		override protected function buildHeading():void{
			super.buildHeading();
			
			heading.setProperties({x:10});
		}
		
		override protected function buildDescription():void{
			super.buildDescription();
			
			description.setProperties({x:10, y:heading? heading.y + heading.height + 14 : 0});
		}
		override protected function buildNavigation():void{
			super.buildNavigation();
			
			if(pageNavigation) pageNavigation.setProperties({x:10, y:_totalHeight-pageNavigation.height - 20});
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
		protected function get overlayParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xFFFFFF];
			p.alphas = [.8];
			return p;
		}
		override protected function get headingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_BOLD;
			p.size = 24;
			return p;
		}
		
		override protected function get descriptionParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_MEDIUM;
			p.width = _totalWidth-20;
			p.autoSize = TextFieldAutoSize.LEFT;
			p.wordWrap = true;
			p.multiline = true;
			p.leading = 4;
			return p;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xffffff];
			p.alphas = [1];
			return p;
		} 
		// =================================================
		// ================ Core Handler
		// =================================================
		
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function getNavigation(		_list:XMLList, 
														_allowMultipleSelect:Boolean=false, 
														_hasSelectedState:Boolean=true, 
														_verticalAlign:String=null, 
														_autoInit:Boolean=true, 
														_autoDestroy:Boolean=true, 
														_maxWidth:Number=0		):CFM_SimpleNavigation{
			return new AppMainNavigation(_list, true, false ,null, _allowMultipleSelect, _autoDestroy, _maxWidth );
		}
		
		override protected function buildComplete():void{
			super.buildComplete();
			
			_container.setProperties({x:-_totalWidth*.5, y:-_totalHeight*.5});
			background.filters =  [_dropShadow];
			background.redraw(_totalWidth, _totalHeight, 0, 0);
		}
		override public function onResize():void{}
		
		override protected function onCloseClicked(e:CFM_ButtonEvent):void{
			dispatchEvent(new SharpWindowEvent(SharpWindowEvent.CLOSE_WINDOW,"",null));
		}
		
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}

		// =================================================
		// ================ Constructor
		// =================================================

		
		public function SharpPopupWindowTemplate(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
			_dropShadow = new DropShadowFilter();
			_dropShadow.alpha = .6;
			_dropShadow.distance = 5;
			_dropShadow.blurX = _dropShadow.blurY = 30;
			
			buildOverlay();
		}
		

	}
}
