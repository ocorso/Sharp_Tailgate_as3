package cfm.core.buttons
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.interfaces.buttons.CFM_IButton;
	import cfm.core.objects.CFM_Object;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	[Event(name="clicked", type="cfm.core.events.CFM_ButtonEvent")]
	[Event(name="selected", type="cfm.core.events.CFM_ButtonEvent")]
	[Event(name="deSelected", type="cfm.core.events.CFM_ButtonEvent")]
	[Event(name="over", type="cfm.core.events.CFM_ButtonEvent")]
	[Event(name="out", type="cfm.core.events.CFM_ButtonEvent")]
	
	public class CFM_SimpleButton extends CFM_Object implements CFM_IButton
	{
		protected var container						:CFM_ObjectContainer;
		protected var backgroundContainer			:CFM_ObjectContainer;
		protected var labelContainer				:CFM_ObjectContainer;
		
		protected var _selected						:Boolean = false;
		
		protected var selectState					:Boolean;
		protected var toggle						:Boolean;
		protected var _disabled						:Boolean;

		protected var background					:CFM_Graphics;
		protected var hit							:CFM_Graphics;
		protected var label							:CFM_TextField;
		
		protected var paddingH						:Number;
		protected var paddingV						:Number;
		protected var _buttonIndex					:Number;
		protected var _hitWidth						:Number;
		protected var _hitHeight						:Number;
		
		protected var _buttonId						:String;
		protected var _buttonValue					:String;
		protected var href							:String;
		protected var _currentPosition				:Point = new Point(0,0);
		public var isActive							:Boolean = true;
		protected var __labelText					:String;
		
		public function CFM_SimpleButton(_index:Number,_id:String,_value:String,_labelText:String,_paddingH:Number = 4,_paddingV:Number = 4,_toggle:Boolean = false,_selectState:Boolean = true,_href:String=null,_active:Boolean = true, _autoInit:Boolean=true,_autoDestroy:Boolean=true)
		{
			super("CFM_SimpleButton",_autoInit,_autoDestroy);
			
			_buttonIndex 							= _index;
			_buttonId 								= _id;
			_buttonValue 							= _value;
			paddingH 								= _paddingH;
			paddingV 								= _paddingV;
			toggle 									= _toggle;
			selectState 							= _toggle ? true : _selectState;
			href 									= _href;
			isActive								= _active;
			
			__labelText 							= _labelText;
		}
		
		public function activate():void{
			isActive = true;
			container.mouseChildren = true;
			container.mouseEnabled = true;
			TweenMax.to(container, 0, {autoAlpha:1});
		}
		
		public function deActivate():void{
			isActive = false;
			container.mouseChildren = false;
			container.mouseEnabled = false;
			TweenMax.to(container, 0, {autoAlpha:.5});
		}
		
		public function get currentPosition():Point{
			return _currentPosition;
		}
		
		override protected function build():void{
			buildContainers();
			buildBackground();
			buildLabel();
			buildHit();
			
			if(!isActive) deActivate();
		}
		
		override protected function addListeners():void{
			if(!hit.hasEventListener(MouseEvent.MOUSE_DOWN))
				hit.addEventListener(MouseEvent.MOUSE_DOWN, down, false, 0, true);
			
			hit.buttonMode = true;
			hit.mouseChildren = true;
				
			if(!hit.hasEventListener(MouseEvent.MOUSE_OVER))
				hit.addEventListener(MouseEvent.MOUSE_OVER, over, false, 0, true);
			
			if(!hit.hasEventListener(MouseEvent.MOUSE_OUT))
				hit.addEventListener(MouseEvent.MOUSE_OUT, out, false, 0, true);
		}
		
		override protected function removeListeners():void{	
			if(isActive){
				if(!toggle){
					if(hit.hasEventListener(MouseEvent.MOUSE_DOWN))
						hit.removeEventListener(MouseEvent.MOUSE_DOWN, down);
				
					hit.buttonMode = false;
					hit.mouseChildren = false;
				}
				
				if(hit.hasEventListener(MouseEvent.MOUSE_OVER))
					hit.removeEventListener(MouseEvent.MOUSE_OVER, over);
				
				if(hit.hasEventListener(MouseEvent.MOUSE_OUT))
					hit.removeEventListener(MouseEvent.MOUSE_OUT, out);		
			}
		}
		
		override public function get width():Number{return _hitWidth;}
		override public function get height():Number{return _hitHeight;}
		
		protected function buildContainers():void{
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			
			backgroundContainer = new CFM_ObjectContainer();
			backgroundContainer.renderTo(container);
			
			labelContainer = new CFM_ObjectContainer();
			labelContainer.renderTo(container);
			labelContainer.setProperties({x:paddingH, y:paddingV});
		}
		
		/**
		 * Override if you want to totally replace the contents of <backgroundContainer> 
		 * 
		 */		
		protected function buildBackground():void{
			background = new CFM_Graphics( backgroundParams );
			background.renderTo(backgroundContainer);
		}
		
		/**
		 * Override if you want to customize the <CFM_GraphicsParams> of the default <background>
		 * @return 
		 * 
		 */		
		protected function get backgroundParams():CFM_GraphicsParams{
			return new CFM_GraphicsParams();
		}
		
		/**
		 * Override if you want to toally replace the contents or positioning of <labelContainer> 
		 * 
		 */		
		protected function buildLabel():void{			
			label = new CFM_TextField(__labelText, labelParams);
			label.renderTo(labelContainer);
		}
		
		/**
		 * Override if you want to customize the <CFM_TextFieldParams> of the default <label>
		 * @return 
		 * 
		 */		
		protected function get labelParams():CFM_TextFieldParams{
			return new CFM_TextFieldParams({size:14, color:0x333333});
		}
		
		/**
		 * Override if you want to change the overall size of the whole button. Everything is sized based on the <_hitWidth> and <_hitHeight> properties 
		 * 
		 */		
		protected function setHitDimensions():void{
			_hitWidth = int(labelContainer.width + (paddingH*2));
			_hitHeight = int(labelContainer.height + (paddingV*2));
		}
		
		protected function buildHit():void{
			hit = new CFM_Graphics(new CFM_GraphicsParams({colors:[0xFFFFFF]}));
			hit.renderTo(container);
			hit.setProperties({buttonMode:true, alpha:0});
		}
		
		
		override protected function buildComplete():void{
			setHitDimensions();
			resizeGraphics();
			
			toOutState(false);
			toUnselectedState();
		}
		
		protected function resizeGraphics():void{
			if(background) background.redraw(_hitWidth, _hitHeight,background.params.x, background.params.y);
			if(hit) hit.redraw(_hitWidth, _hitHeight,hit.params.x,hit.params.y);
		}
		
		protected function over(e:MouseEvent):void{
			dispatchOver();
			toOverState();
		}
		
		protected function out(e:MouseEvent):void{
			dispatchOut();
			toOutState();
		}
		
		public function down(e:MouseEvent):void{

			if(!selectState){
				
				dispatchClicked();
				
				if(href && href != "")
					openLink();
			}else{
				if(_selected == true)
					deselect(true);
				else 
					select(true);
			}
		}
		
		protected function openLink():void{
			navigateToURL(new URLRequest(href), "_self");
		}
		
		protected function dispatchOver():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.OVER, _buttonIndex, _buttonId, _buttonValue, labelText, !_selected));
		}
		
		protected function dispatchOut():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.OUT, _buttonIndex, _buttonId, _buttonValue, labelText, !_selected));
		}
		
		protected function dispatchClicked():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.CLICKED, _buttonIndex, _buttonId, _buttonValue, labelText, !_selected));
		}
		
		protected function dispatchSelected():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.SELECTED, _buttonIndex, _buttonId, _buttonValue, labelText, _selected));
		}
		
		protected function dispatchDeSelected():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.DE_SELECTED, _buttonIndex, _buttonId, _buttonValue, labelText, _selected));
		}
		
		/**
		 * Override to customize the rollover state 
		 * 
		 */		
		protected function toOverState():void{
			killTweens();
			TweenMax.to(labelContainer, .2, {tint:0xFFFFFF, ease:Linear.easeNone});
			TweenMax.to(backgroundContainer, .2, {alpha:1, ease:Linear.easeNone});
		}
		
		/**
		 * Override to customize the rollout state
		 * @param _tween
		 * 
		 */		
		protected function toOutState(_tween:Boolean = true):void{
			killTweens();
			TweenMax.to(labelContainer, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
			TweenMax.to(backgroundContainer, _tween ? .2 : 0, {alpha:.1, ease:Linear.easeNone});
		}
		
		/**
		 * Override to customize the selected state 
		 * 
		 */		
		protected function toSelectedState():void{
			toOverState();
		}
		
		/**
		 * Override to customize the unselected state 
		 * 
		 */		
		protected function toUnselectedState():void{
			toOutState();
		}
		
		protected function disableOverOut():void{
			if(hit.hasEventListener(MouseEvent.MOUSE_OVER))
				hit.removeEventListener(MouseEvent.MOUSE_OVER, over);
			
			if(hit.hasEventListener(MouseEvent.MOUSE_OUT))
				hit.removeEventListener(MouseEvent.MOUSE_OUT, out);
		}
		
		protected function killTweens():void{
			TweenMax.killTweensOf(labelContainer);
			TweenMax.killTweensOf(backgroundContainer);
		}
		
		public function select(_dispatch:Boolean = true):void{
			if(!isActive)
				activate();

			if(selectState){
				_selected = true;
				toSelectedState();
				disable();

				if(_dispatch) 
					dispatchSelected();
			} else{
				if(_dispatch)
					dispatchClicked();
			}
		}
		
		public function deselect(_dispatch:Boolean = true):void{
			if(selectState){
				_selected = false;
				toUnselectedState();
			}
			
			enable();
			
			if(_dispatch)
				dispatchDeSelected();
		}
		
		public function updateLabel(_newLabel:String, updateSize:Boolean = true):void{
			if(_newLabel && _newLabel !="")
				if(label) label.text = _newLabel;
			
			if(updateSize){
				setHitDimensions();
				resizeGraphics();
			}
		}
		
		public function resetLabel(updateSize:Boolean = true):void{
			label.text = __labelText;
			
			if(updateSize){
				setHitDimensions();
				resizeGraphics();
			}
		}
	
		public function enable():void{
			_disabled = false;
			addListeners();
		}
		
		public function disable():void{
			_disabled = true;
			removeListeners();
		}
		
		public function set buttonIndex(_value:Number):void{_buttonIndex = _value;}
		
		public function get labelText():String{return __labelText;}
		public function get disabled():Boolean{return _disabled;}
		public function get hitHeight():Number{return _hitHeight;}
		public function get hitWidth():Number{return _hitWidth;}
		public function get buttonId():String{return _buttonId;}
		public function get buttonIndex():Number{return _buttonIndex;}
		public function get buttonValue():String{return _buttonValue;}
		public function get selected():Boolean{return _selected;}
	}
}