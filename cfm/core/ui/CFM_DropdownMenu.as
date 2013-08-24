package cfm.core.ui
{	
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.events.CFM_DropdownMenuEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.objects.CFM_Object;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.events.Event;
	
	import net.ored.util.out.Out;
	
	public class CFM_DropdownMenu extends CFM_Object
	{
		public var ITEM_SPACING:Number = 23;
		public var ITEM_HOLDER_MARGIN:Number = 2;
		public var NAVIGATION_SPACING:Number = 10;
		
		public var navigationList:XMLList;
		
		public var itemHolder:CFM_ObjectContainer;
		public var itemHolderMask:CFM_Graphics;
		public var navigations:Array;
		
		public var button:CFM_SimpleButton;
		public var navigation:CFM_SimpleNavigation;
		public var menuOpen:Boolean = false;
		public var currentSelection:String;
		
		public var index:Number;
		public var value:String;
		public var id:String;
		public var labelText:String;
		public var _offsetHeight:Number = 0;
		
		public function CFM_DropdownMenu(_index:Number, _id:String, _value:String, _labelText:String, _navigationList:XMLList, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{			
			index = _index;
			labelText = _labelText;
			navigationList = _navigationList;
			currentSelection = labelText;
			id = _id;
			value = _value;
			
			super("CFM_DropdownMenu",_autoInit,_autoDestroy);
		}
		
		override protected function build():void{				
			button = getButton();
			button.renderTo(this);
			
			itemHolder = new CFM_ObjectContainer();
			itemHolder.renderTo(this);
			
			itemHolderMask = new CFM_Graphics(new CFM_GraphicsParams({width:10,height:10, colors:[0], alphas:[0]}));
			itemHolderMask.renderTo(this);
			
			itemHolder.mask = itemHolderMask;
			
			if(navigationList.length()>0) buildNavigations();
			
			itemHolder.setProperties({alpha:0, visible:false, y:button.hitHeight + ITEM_HOLDER_MARGIN});
			
			itemHolderMask.setProperties({scaleY:0, y:itemHolder.y});
		}
		
		public function get buttonWidth():Number{
			return button.width;
		}
		
		public function get buttonHeight():Number{
			return button.height;
		}
		
		public function selectButton(_dispatch:Boolean):void{
			button.select(_dispatch);
		}
		
		public function get offsetHeight():Number{
			return _offsetHeight;
		}
		
		public function buildNavigations():void{
			navigations = [];
			buildButtons();
			
			itemHolderMask.redraw(itemHolder.x + itemHolder.width+20, itemHolder.height + ITEM_HOLDER_MARGIN,0,0);
			_offsetHeight = itemHolder.height + ITEM_HOLDER_MARGIN;
		}
		
		public function buildButtons():void{
			var i:Number = 0;
			for each(var n:XML in navigationList){
				navigation = getNavigation(n.button);
				navigation.renderTo(itemHolder);
				navigation.setProperties({x:i>0 ? (navigations[i-1].x + navigations[i-1].width + NAVIGATION_SPACING) : 1});
				navigations.push(navigation);
				i++
			}
		}
		
		public function deselectAllItems(_exceptNavIndex:Number = -1, _exceptButtonIndex:Number = -1):void{
			for each(var n:CFM_SimpleNavigation in navigations)
			if(_exceptNavIndex != navigations.indexOf(n))
				n.deselectAll();
			else 
				n.deselectAll( _exceptButtonIndex );
		}
		
		public function selectItemById(_navigationIndex:Number, _id:String, _dispatch:Boolean = true):void{
			CFM_SimpleNavigation(navigations[_navigationIndex]).selectButtonById(_id, _dispatch);
		}
		
		protected function getButton():CFM_SimpleButton{
			return new CFM_SimpleButton(0,id, value,labelText,4,4,true,true,"") as CFM_SimpleButton;
		}
		
		protected function getNavigation(_buttonList:XMLList):CFM_SimpleNavigation{
			return new CFM_SimpleNavigation(_buttonList,false,false,"left") as CFM_SimpleNavigation;
		}
		
		override protected function addListeners():void{
			super.addListeners();
			
			for each(var n:CFM_SimpleNavigation in navigations){
				n.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, itemSelected, false, 0, true);
				n.addEventListener(CFM_NavigationEvent.BUTTON_SELECTED, itemSelected, false, 0, true);
			}
				

			button.addEventListener(CFM_ButtonEvent.SELECTED, buttonSelected, false, 0, true);
			button.addEventListener(CFM_ButtonEvent.DE_SELECTED, buttonDeSelected, false, 0, true);
		}
		
		public function openMenu(_dispatch:Boolean = false):void{
			menuOpen = true;
			
			TweenMax.to(itemHolder, 0, {autoAlpha:1});
			TweenMax.to(itemHolderMask, .4, {scaleY:1, ease:Cubic.easeOut});
			
			dispatchOpen();
			
			if(_dispatch) dispatchOpen();
		}
		
		protected function dispatchOpen():void{
			dispatchEvent(new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.OPEN_MENU, index, value, NaN, currentSelection));
		}
		
		public function closeMenu(_dispatch:Boolean = true):void{
			
			menuOpen = false;
			
			button.deselect();
			
			TweenMax.to(itemHolder, 0, {delay:.4, autoAlpha:0});
			TweenMax.to(itemHolderMask, .4, {scaleY:0,  ease:Cubic.easeOut});
			
			if(_dispatch) dispatchEvent(new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.CLOSE_MENU, index, value, NaN, currentSelection ));
		}
		
		public function buttonSelected(e:CFM_ButtonEvent):void{
			killTweens();
			
			if(!menuOpen) openMenu();

			//dispatchEvent( new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.ITEM_SELECTED, index, value, NaN, null));
		}
		
		public function buttonDeSelected(e:CFM_ButtonEvent):void{
			killTweens();
			
			if(menuOpen) closeMenu();
		}
		
		public function reset():void{
			killTweens();
			currentSelection = null;
			button.resetLabel(false);
			
			for each(var n:CFM_SimpleNavigation in navigations)
			n.selectButton(0,false);
			
			closeMenu(true);
		}
		
		protected function itemSelected(e:CFM_NavigationEvent):void{
			killTweens();
			
			updateSelection( CFM_SimpleNavigation(e.currentTarget).getButtonLabelText(e.id) );
			
			deselectAllItems(navigations.indexOf( CFM_SimpleNavigation(e.currentTarget) ), e.index);
			
			dispatchEvent( new CFM_DropdownMenuEvent(CFM_DropdownMenuEvent.ITEM_SELECTED, index, CFM_SimpleNavigation(e.currentTarget).getButtonLabelText(e.id), e.index, e.value));
		}
		
		public function updateSelection(_value:String):void{
			currentSelection = _value;
			button.updateLabel(_value,false);
		}
		
		public function killTweens():void{
			TweenMax.killTweensOf(itemHolder);
			TweenMax.killTweensOf(itemHolderMask);
		}
		
		override protected function removeListeners():void{
			super.removeListeners();
			
			for each(var n:CFM_SimpleNavigation in navigations){
				n.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, itemSelected);
				n.removeEventListener(CFM_NavigationEvent.BUTTON_SELECTED, itemSelected);
			}
			
			button.removeEventListener(CFM_ButtonEvent.SELECTED, buttonSelected);
			button.removeEventListener(CFM_ButtonEvent.DE_SELECTED, buttonDeSelected);
		}
		
		private function get itemLabelParams():Object{
			return {};
		}
		
		private function get buttonLabelParams():Object{
			return {};
		}
		
		override public function destroy(e:Event):void{
			killTweens();
			
			while(itemHolder.numChildren>0){
				itemHolder.removeChildAt(0);
			}
			
			super.destroy(e);
		}
	}
}