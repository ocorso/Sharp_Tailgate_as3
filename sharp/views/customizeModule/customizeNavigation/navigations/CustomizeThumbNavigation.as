package sharp.views.customizeModule.customizeNavigation.navigations
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.events.CFM_ScrollBarEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.navigation.CFM_SimpleNavigation;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import flash.display.Shape;
	
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.CustomizeSmallerButton;
	import sharp.views.appTemplate.SharpScrollbar;
	import sharp.views.customizeModule.customizeNavigation.buttons.CustomizeThumbButton;
	
	
	public class CustomizeThumbNavigation extends CFM_SimpleNavigation
	{
		
		private var buttonWidth					:Number;
		private var navId						:String;
		private var background					:Shape;
		private var navMask						:CFM_Graphics;
		private var scrollbar					:SharpScrollbar;
		private var MASK_HEIGHT					:Number;
		private var BACKGROUND_WIDTH			:Number = 342;
		private var imgUrl						:String;
		public var primaryColor					:uint;
		public var secondaryColor				:uint;
		
		private const BACKGROUND_HEIGHT			:Number = 316;
		private const THUMB_COLUMN				:int = 3;
		private const SCROLLBAR_WIDTH			:Number = 10;
		private const SCROLLBAR_HEIGHT			:Number = 50;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			
			super.build();	
			MASK_HEIGHT = (buttonsVector[0].height*THUMB_COLUMN) + (buttonSpacing*(THUMB_COLUMN-1)) + 3;
			buildMask();
			buildScrollBar();
			buildBackground();
		}
		
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			var imageUrl:String;
			var color1:uint;
			var color2:uint;
			if(_tag.@grayScale == "true"){
				color1 = primaryColor;
				color2 = secondaryColor;
			}else{
				imageUrl =  imgUrl + navId + "/" + _tag.@id + ".png";
			}
			return new CustomizeThumbButton(color1, color2, imageUrl, _i,_tag.@id,_tag.@value,_tag.label,0,0,false,false,_tag.@href);
		}
		
		private function buildBackground():void{
			background = new Shape();
			background.graphics.lineStyle(1, 0xcdcdcd);
			background.graphics.beginFill(0xffffff);
			background.graphics.moveTo(0,0);
			background.graphics.lineTo(0,BACKGROUND_HEIGHT + Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(BACKGROUND_WIDTH,BACKGROUND_HEIGHT + Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(BACKGROUND_WIDTH,Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(buttonWidth,Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(buttonWidth,0);
			background.graphics.lineTo(0,0);
			this.addChildAt(background,0);
		}
		
		private function buildMask():void{
			navMask = new CFM_Graphics();
			navMask.renderTo(this);
			navMask.width = BACKGROUND_WIDTH;
			navMask.height = MASK_HEIGHT;
			buttonContainer.mask = navMask;
		}
		
		private function buildScrollBar():void{

			scrollbar 		= new SharpScrollbar(MASK_HEIGHT,SCROLLBAR_HEIGHT,SCROLLBAR_WIDTH,true);
			addChild(scrollbar);
			scrollbar.renderTo(this);
			
			if(buttonContainer.height > MASK_HEIGHT){
				scrollbar.visible = true;
				buttonContainer.setProperties({x:Vo.DROPDOWN_PADDING, y:Vo.DROPDOWN_PADDING});
				
			}else{
				scrollbar.visible = false;
				BACKGROUND_WIDTH = BACKGROUND_WIDTH - Vo.DROPDOWN_PADDING;
				buttonContainer.setProperties({x:(BACKGROUND_WIDTH - buttonContainer.width)*.5, y:Vo.DROPDOWN_PADDING});
			}
			
			navMask.x		 = buttonContainer.x;
			navMask.y		 = buttonContainer.y;
			scrollbar.x 	 = buttonContainer.x + buttonContainer.width + 15;
			scrollbar.y 	 = buttonContainer.y;
			scrollbar.addEventListener(CFM_ScrollBarEvent.SCROLLING, onScroll, false, 0, true);
	
		}

		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onScroll(e:CFM_ScrollBarEvent):void{
			TweenMax.killTweensOf(buttonContainer);
			TweenMax.to(buttonContainer, .8, {ease:Sine.easeOut, y:navMask.y-((buttonContainer.height-navMask.height)*e.percent)});
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Interfaced
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

		public function CustomizeThumbNavigation(_imageUrl:String, _buttonWidth:Number, _navId:String, _list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			buttonSpacing = Vo.DROPDOWN_PADDING*.5 + 2;
			buttonWidth = _buttonWidth + Vo.BUTTON_SQUARE_SIZE;
			navId = _navId;
			imgUrl = _imageUrl;
		}
	}
}