package cfm.core.templates
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.events.CFM_PageEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.interfaces.util.CFM_IResize;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.objects.CFM_Object;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	
	import net.ored.util.out.Out;

	public class CFM_PageTemplate extends CFM_Object implements CFM_IResize
	{
		public var index:Number;
		public var id:String;
		
		protected var xml:XML;
		protected var _container:CFM_ObjectContainer;
		protected var _backgroundContainer:CFM_ObjectContainer;
		protected var _content:CFM_ObjectContainer;
		protected var params:Object;
		protected var active:Boolean = true;
		protected var closeButton:CFM_SimpleButton;
		
		protected var background:CFM_Graphics;
		
		protected var heading:CFM_TextField;
		protected var description:CFM_TextField;
		protected var pageNavigation:CFM_SimpleNavigation;
		
		public function CFM_PageTemplate(_index:Number, _xml:XML, _params:Object)
		{
			index = _index;
			id = _xml.@id;
			xml = _xml;
			params = _params;
			
			super("PageTemplate_" + _xml.@classname,true,true);
		}
		
		override protected function build():void{			
			_container = new CFM_ObjectContainer(true);
			_container.setProperties({alpha:0, visible:false});
			_container.renderTo(this);
			
			_backgroundContainer = new CFM_ObjectContainer();
			_container.addChild(_backgroundContainer);
			
			_content = new CFM_ObjectContainer();
			_content.y = _container.height + 10;
			_content.renderTo(_container);

			if(xml.heading.length() > 0) buildHeading();
			if(xml.description.length() > 0) buildDescription();
			if(xml.navigation.length() > 0) buildNavigation();
			if(xml.@close == "true") buildCloseButton();

			
			buildContent();
			buildBackground();
		}
		
		override protected function addListeners():void{
			super.addListeners();
			
			if(closeButton)
				closeButton.addEventListener(CFM_ButtonEvent.CLICKED, onCloseClicked, false, 0, true);
			
			if(pageNavigation){
				pageNavigation.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, false, 0, true);
				pageNavigation.addEventListener(CFM_NavigationEvent.BUTTON_SELECTED, onNavigationSelected, false, 0, true);
				pageNavigation.addEventListener(CFM_NavigationEvent.BUTTON_DESELECTED, onNavigationDeSelected, false, 0, true);
			}
		}
		
		override protected function buildComplete():void{
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.BUILD_COMPLETE));
			transitionIn();
		}
		
		override protected function removeListeners():void{
			super.removeListeners();
			
			if(closeButton)
				closeButton.removeEventListener(CFM_ButtonEvent.CLICKED, onCloseClicked);
			
			if(pageNavigation){
				pageNavigation.removeEventListener(CFM_NavigationEvent.BUTTON_SELECTED, onNavigationSelected);
				pageNavigation.removeEventListener(CFM_NavigationEvent.BUTTON_DESELECTED, onNavigationDeSelected);
				pageNavigation.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
			}
		}
		
		protected function buildBackground():void{
			background = new CFM_Graphics(backgroundParams);
			background.renderTo(_backgroundContainer);
		}
		
		protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.alphas = [.1];
			return p;
		}
		
		protected function buildHeading():void{
			heading = new CFM_TextField(xml.heading[0], headingParams);
			heading.renderTo(_content);
			heading.setProperties({x:-2});
		}
		
		protected function get headingParams():CFM_TextFieldParams{
			return new CFM_TextFieldParams({size:40});
		}
		
		protected function buildDescription():void{
			description = new CFM_TextField(xml.description[0], descriptionParams);
			description.renderTo(_content);
			description.setProperties({y:_content.height, x:-1});
		}
		
		protected function get descriptionParams():CFM_TextFieldParams{
			return new CFM_TextFieldParams({size:12});
		}
		
		protected function buildNavigation():void{
			pageNavigation = getNavigation(xml.navigation[0].button, false, false, null, true, true, 0);
			pageNavigation.renderTo(_content);
			pageNavigation.setProperties({y:_content.height + 14});
		}
		
		protected function getNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String = null, _autoInit:Boolean = true,_autoDestroy:Boolean = true, _maxwidth:Number = 0):CFM_SimpleNavigation{
			return new CFM_SimpleNavigation(_list,_allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit,_autoDestroy, _maxwidth);
		}
		
		protected function buildCloseButton():void{
			closeButton = new CFM_SimpleButton(0,"close","close","X",4,4,false,false);
			closeButton.renderTo(_container);
			closeButton.setProperties({x:_container.width-closeButton.width});
		}
		
		protected function buildContent():void{}		
		
		public function transitionIn():void{
			TweenMax.to(_container, .2,{delay:.2, autoAlpha:1, onComplete:transitionInComplete, ease:Linear.easeNone});
		}
		
		public function transitionInComplete():void{
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.TRANSITION_IN_COMPLETE));
			initContent();
		}
		
		public function initContent():void{}
		
		public function transitionOut(_newParams:Object):void{
			active = false;
			TweenMax.to(_container, .2,{autoAlpha:0, onComplete:transitionOutComplete, onCompleteParams:[_newParams], ease:Linear.easeNone});
		}
		
		public function transitionOutComplete(_newParams:Object):void{
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.TRANSITION_OUT_COMPLETE,id,_newParams));
		}
		
		protected function onCloseClicked(e:CFM_ButtonEvent):void{
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.CLOSE_CLICKED));
		}
		
		protected function onNavigationClicked(e:CFM_NavigationEvent):void{
			dispatchEvent(new CFM_NavigationEvent(e.type, e.index, e.id, e.value));
		}
		
		protected function onNavigationSelected(e:CFM_NavigationEvent):void{
			dispatchEvent(new CFM_NavigationEvent(e.type, e.index, e.id, e.value));
		}
		
		protected function onNavigationDeSelected(e:CFM_NavigationEvent):void{
			dispatchEvent(new CFM_NavigationEvent(e.type, e.index, e.id, e.value));
		}
		
		override public function destroy(e:Event):void{
			super.destroy(e);
			dispatchEvent(new CFM_PageEvent(CFM_PageEvent.DESTROY_COMPLETE));
		}
		
		public function onResize():void{
			if(closeButton)
				closeButton.setProperties({x:_container.width-closeButton.width});
		}
	}
}