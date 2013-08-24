package cfm.core.buttons
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.objects.CFM_Object;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_SimpleButtonParams;
	
	import cfm.core.events.CFM_ButtonEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	[Event(name="clicked", type="com.cfm.moble.events.CFM_ButtonEvent")]
	[Event(name="selected", type="com.cfm.moble.events.CFM_ButtonEvent")]
	[Event(name="deSelected", type="com.cfm.moble.events.CFM_ButtonEvent")]
	
	public class CFM_SimpleButtonNew extends CFM_Object
	{
		protected var container						:CFM_ObjectContainer;
		protected var backgroundContainer			:CFM_ObjectContainer;
		protected var labelContainer				:CFM_ObjectContainer;
		
		protected var _selected						:Boolean = false;
		protected var _isActive						:Boolean = true;
		protected var _disabled						:Boolean;
		
		protected var background					:CFM_Graphics;
		protected var hit							:CFM_Graphics;
		
		protected var _hitWidth						:Number;
		protected var _hitHeight					:Number;
		
		protected var _currentPosition				:Point = new Point(0,0);
		
		protected var _label						:MovieClip;
		protected var _params						:CFM_SimpleButtonParams;
		
		public function CFM_SimpleButtonNew( $label:MovieClip, $params:CFM_SimpleButtonParams, $autoInit:Boolean=true, $autoDestroy:Boolean=true )
		{
			super( "CFM_mobileButton_" +  $params.id , $autoInit, $autoDestroy );
			
			_label 	= $label
			_params = $params;
		}
		
		public function activate():void{
			_isActive = true;
			TweenMax.to(container, 0, {autoAlpha:1});
		}
		
		public function deActivate():void{
			_isActive = false;
			TweenMax.to(container, 0, {autoAlpha:0});
		}
		
		override protected function build():void{
			buildContainers();
			buildBackground();
			buildLabel();
			buildHit();
			
			if(!_isActive) deActivate();
		}
		
		override protected function addListeners():void{
			if(!hit.hasEventListener(MouseEvent.MOUSE_DOWN))
				hit.addEventListener(MouseEvent.MOUSE_DOWN, down, false, 0, true);
			
			if(!hit.hasEventListener(MouseEvent.MOUSE_UP))
				hit.addEventListener(MouseEvent.MOUSE_UP, up, false, 0, true);
			
			hit.buttonMode = true;
			hit.mouseChildren = true;
		}
		
		override protected function removeListeners():void{	
			if(hit.hasEventListener(MouseEvent.MOUSE_DOWN))
				hit.removeEventListener(MouseEvent.MOUSE_DOWN, down);
			
			if(hit.hasEventListener(MouseEvent.MOUSE_UP))
				hit.removeEventListener(MouseEvent.MOUSE_UP, up);
		
			hit.buttonMode = false;
			hit.mouseChildren = false;
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
			labelContainer.setProperties({x:_params.paddingH, y:_params.paddingV});
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
			labelContainer.addChild(_label);
		}
		
		/**
		 * Override if you want to change the overall size of the whole button. Everything is sized based on the <_hitWidth> and <_hitHeight> properties 
		 * 
		 */		
		protected function setHitDimensions():void{
			_hitWidth = int(labelContainer.width + (_params.paddingH*2));
			_hitHeight = int(labelContainer.height + (_params.paddingV*2));
		}
		
		protected function buildHit():void{
			hit = new CFM_Graphics(new CFM_GraphicsParams({colors:[0xFFFFFF]}));
			hit.renderTo(container);
			hit.setProperties({buttonMode:true, alpha:0});
		}
		
		override protected function buildComplete():void{
			setHitDimensions();
			resizeGraphics();
			
			toUpState(false);
			toUnselectedState(false);
		}
		
		protected function resizeGraphics():void{
			if(background) background.redraw(_hitWidth, _hitHeight,background.params.x, background.params.y);
			if(hit) hit.redraw(_hitWidth, _hitHeight,hit.params.x,hit.params.y);
		}
		
		public function up(e:MouseEvent):void{
			toUpState();
			
			dispatchClicked();

			if(_params.href && _params.href != ""){
				openLink();
			} else {
				if(_params.hasSelectState){
					if(!_selected)
						select(true);
					else 
						deselect(true);
				}
			}
		}
		
		public function down(e:MouseEvent):void{
			toDownState();
		}
		
		/**
		 * Override to customize the rollover state 
		 * 
		 */		
		protected function toDownState(_tween:Boolean = true):void{
			killTweens();
			
			TweenMax.to(labelContainer, .2, {tint:0xFFFFFF, ease:Linear.easeNone});
			TweenMax.to(backgroundContainer, .2, {alpha:1, ease:Linear.easeNone});
		}
		
		/**
		 * Override to customize the rollout state
		 * @param _tween
		 * 
		 */		
		protected function toUpState(_tween:Boolean = true):void{
			killTweens();
			
			TweenMax.to(labelContainer, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
			TweenMax.to(backgroundContainer, _tween ? .2 : 0, {alpha:.1, ease:Linear.easeNone});
		}
		
		/**
		 * Override to customize the selected state 
		 * 
		 */		
		protected function toSelectedState(_tween:Boolean = true):void{
			toDownState(_tween);
		}
		
		/**
		 * Override to customize the unselected state 
		 * 
		 */		
		protected function toUnselectedState(_tween:Boolean = true):void{
			toUpState(_tween);
		}
		
		protected function killTweens():void{
			TweenMax.killTweensOf(labelContainer);
			TweenMax.killTweensOf(backgroundContainer);
		}
		
		public function select(_dispatch:Boolean = true):void{
			_selected = true;
			toSelectedState();
			
			if(!_params.doesToggle)
				disable();
			
			if(_dispatch)
				dispatchSelected();
		}
		
		public function deselect(_dispatch:Boolean = true):void{
			_selected = false;
			toUnselectedState();
			
			if(_params.doesToggle)
				enable();
			
			if(_dispatch)
				dispatchDeSelected();
		}
		
		public function enable():void{
			_disabled = false;
			addListeners();
		}
		
		public function disable():void{
			_disabled = true;
			removeListeners();
		}
		
		
		protected function openLink():void{
			navigateToURL(new URLRequest(_params.href), "_blank");
		}
		
		protected function dispatchClicked():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.CLICKED, _params.index, _params.id, _params.value, !_selected));
		}
		
		protected function dispatchSelected():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.SELECTED, _params.index, _params.id, _params.value, _selected));
		}
		
		protected function dispatchDeSelected():void{
			dispatchEvent(new CFM_ButtonEvent(CFM_ButtonEvent.DE_SELECTED, _params.index, _params.id, _params.value, _selected));
		}
		
				
		public function get disabled():Boolean{return _disabled;}
		
		public function get hitHeight():Number{return _hitHeight;}
		
		public function get hitWidth():Number{return _hitWidth;}
		
		public function get buttonId():String{return _params.id;}
		
		public function get buttonIndex():Number{return _params.index;}
		
		public function get buttonValue():String{return _params.value;}
		
		public function get selected():Boolean{return _selected;}
		
		public function get currentPosition():Point{return _currentPosition;}
		public function set currentPosition(value:Point):void{_currentPosition = value;}

	}
}