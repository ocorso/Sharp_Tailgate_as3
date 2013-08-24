package cfm.core.navigation 
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.interfaces.navigation.CFM_INavigation;
	import cfm.core.objects.CFM_Object;
	
	import com.greensock.TweenMax;
	
	import flash.geom.Point;
	
	import net.ored.util.out.Out;
	
	[Event(name="buttonClicked", type="cfm.core.events.CFM_NavigationEvent")]
	[Event(name="buttonSelected", type="cfm.core.events.CFM_NavigationEvent")]
	[Event(name="buttonDeSelected", type="cfm.core.events.CFM_NavigationEvent")]
	[Event(name="buttonOver", type="cfm.core.events.CFM_NavigationEvent")]
	[Event(name="buttonOut", type="cfm.core.events.CFM_NavigationEvent")]
	
	public class CFM_SimpleNavigation extends CFM_Object implements CFM_INavigation
	{
		protected var list					:XMLList;
		protected var buttonParams			:Object;
		protected var _buttonContainer		:CFM_ObjectContainer;
		protected var allowMultipleSelect	:Boolean;
		protected var hasSelectedState		:Boolean;
		protected var maxWidth				:Number = 0;
		protected var buttonSpacing			:Number = 4;
		protected var _buttonsVector			:Vector.<CFM_SimpleButton> = new Vector.<CFM_SimpleButton>();
		protected var buttonIds				:Array = [];
		protected var lastSelected			:CFM_SimpleButton;
		protected var verticalAlign			:String;
		protected var currentHeight			:Number;
		protected var currentWidth			:Number;
		
		public function CFM_SimpleNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String = null, _autoInit:Boolean = true,_autoDestroy:Boolean = true, _maxwidth:Number = 0)
		{
			super("CFM_Navigation", _autoInit, _autoDestroy);
			
			list 							= _list;
			allowMultipleSelect 			= _allowMultipleSelect;
			hasSelectedState 				= _allowMultipleSelect ? true : _hasSelectedState;
			verticalAlign 					= _verticalAlign;
			maxWidth						= _maxwidth;
		}
		
		protected override function build():void{
			buildButtons();
			reposition();
		}
		
		protected function reposition(_speed:Number = 0, _delay:Number = 0, _ease:Object = null, _exclude:CFM_SimpleButton = null):void{
			if(verticalAlign != null)
				positionVertical(_speed, _delay, _ease,_exclude);
			else
				positionHorizontal(_speed, _delay, _ease,_exclude);
		}
		
		protected function buildButtons():void{
			_buttonContainer = new CFM_ObjectContainer();
			_buttonContainer.renderTo(this);
			
			var i:Number = 0;
			
			for each(var bs:XML in list){
				var btn:CFM_SimpleButton = buildButton(i,bs);
				btn.renderTo(buttonContainer);
				_buttonsVector.push(btn);
				buttonIds.push(String(bs.@id));
				i++;
			}
		}
		
		protected function positionHorizontal(_speed:Number = 0, _delay:Number = 0, _ease:Object = null, _exclude:CFM_SimpleButton = null):void{			
			var i:Number = 0;
			
			for each(var o:CFM_SimpleButton in _buttonsVector){				
				 TweenMax.killTweensOf(o);
				 
				var newY:Number = i>0 ? _buttonsVector[i-1].currentPosition.y : 0;
				var newX:Number = i>0 ? _buttonsVector[i-1].currentPosition.x + _buttonsVector[i-1].width + buttonSpacing : 0;
				
				if(i>0 && !_buttonsVector[i-1].isActive){
					newX = _buttonsVector[i-1].x;
					newY = _buttonsVector[i-1].y;
				}
				
				if( maxWidth > 0 && (newX + o.width > maxWidth) ){
					newX = 0;
					newY = i>0   ? (_buttonsVector[i-1].currentPosition.y + _buttonsVector[i-1].height + buttonSpacing) : 0;
				}
				
				o.currentPosition.x = newX;
				o.currentPosition.y = newY;
				
				if(!_exclude || _exclude != o)
					TweenMax.to(o, _speed, {delay:_delay, ease:_ease, x:o.currentPosition.x, y:o.currentPosition.y});
			
				i++;
			}
			
			setCurrentSize();
		}
		
		public function setCurrentSize():void{
			currentHeight = _buttonsVector.length > 0 ? _buttonsVector[lowestButtonIndex].currentPosition.y + _buttonsVector[lowestButtonIndex].height : 0;
			currentWidth = _buttonsVector.length > 0 ? _buttonsVector[farRightButtonIndex].currentPosition.x + _buttonsVector[farRightButtonIndex].width : 0;
		}
		
		protected function positionVertical(_speed:Number = 0, _delay:Number = 0, _ease:Object = null, _exclude:CFM_SimpleButton = null):void{	
			var i:Number = 0;
			
			for each(var o:CFM_SimpleButton in _buttonsVector){				
				TweenMax.killTweensOf(o);
				
				var newX:Number = i>0 ? _buttonsVector[i-1].currentPosition.x : 0;
				var newY:Number = i>0 ? _buttonsVector[i-1].currentPosition.y + _buttonsVector[i-1].height + buttonSpacing : 0;
				
				if(i>0 && !_buttonsVector[i-1].isActive){
					newX = _buttonsVector[i-1].x;
					newY = _buttonsVector[i-1].y;
				}
				
				if( maxWidth > 0 && (newY + o.height > maxWidth) ){
					newY = 0;
					newX = i>0   ? (_buttonsVector[i-1].currentPosition.x + _buttonsVector[i-1].width + buttonSpacing) : 0;
				}
				
				switch(verticalAlign){
					case "center":
						newX = -o.width/2;
						break;
					case "right":
						newX = -o.width;
						break
				}
				
				o.currentPosition.x = newX;
				o.currentPosition.y = newY;
				
				if(!_exclude || _exclude != o)
					TweenMax.to(o, _speed, {delay:_delay, ease:_ease, x:o.currentPosition.x, y:o.currentPosition.y});
				
				i++;
			}
			
			setCurrentSize();
		}
		
		override protected function addListeners():void{
			for each(var o:CFM_SimpleButton in _buttonsVector){
				//if( !hasSelectedState ){
					o.addEventListener(CFM_ButtonEvent.CLICKED, buttonClicked, false, 0, true);
				//} else {
					o.addEventListener(CFM_ButtonEvent.SELECTED, buttonSelected, false, 0, true);
					o.addEventListener(CFM_ButtonEvent.DE_SELECTED, buttonDeSelected, false, 0, true);
				//}
				
				o.addEventListener(CFM_ButtonEvent.OVER, buttonOver, false, 0, true);
				o.addEventListener(CFM_ButtonEvent.OUT, buttonOut, false, 0, true);
			}
		}
		
		override protected function removeListeners():void{
			for each(var o:CFM_SimpleButton in _buttonsVector){
				if(o.hasEventListener(CFM_ButtonEvent.CLICKED))
					o.removeEventListener(CFM_ButtonEvent.CLICKED, buttonClicked);
				
				if(o.hasEventListener(CFM_ButtonEvent.SELECTED))
					o.removeEventListener(CFM_ButtonEvent.SELECTED, buttonSelected);
				
				if(o.hasEventListener(CFM_ButtonEvent.DE_SELECTED))
					o.removeEventListener(CFM_ButtonEvent.DE_SELECTED, buttonDeSelected);
				
				if(o.hasEventListener(CFM_ButtonEvent.OVER))
					o.removeEventListener(CFM_ButtonEvent.OVER, buttonOver);
				
				if(o.hasEventListener(CFM_ButtonEvent.OUT))
					o.removeEventListener(CFM_ButtonEvent.OUT, buttonOut);
			}
		}
		
		protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new CFM_SimpleButton(_i,_tag.@id,_tag.@value,_tag.label,4,4,allowMultipleSelect,hasSelectedState,_tag.@href);
		}
		
		protected function buttonClicked(e:CFM_ButtonEvent):void{
			dispatchEvent(new CFM_NavigationEvent(CFM_NavigationEvent.BUTTON_CLICKED,e.index, e.id, e.value));
		}
		
		protected function buttonOver(e:CFM_ButtonEvent):void{
			dispatchEvent(new CFM_NavigationEvent(CFM_NavigationEvent.BUTTON_OVER, e.index, e.id, e.value));
		}
		
		protected function buttonOut(e:CFM_ButtonEvent):void{
			dispatchEvent(new CFM_NavigationEvent(CFM_NavigationEvent.BUTTON_OUT, e.index, e.id, e.value));
		}
		
		protected function buttonSelected(e:CFM_ButtonEvent):void{
			if(lastSelected && hasSelectedState)
				if(!allowMultipleSelect/* && e.currentTarget != lastSelected*/) 
					lastSelected.deselect();
			dispatchEvent(new CFM_NavigationEvent(CFM_NavigationEvent.BUTTON_SELECTED,e.index, e.id, e.value));
			lastSelected = CFM_SimpleButton(e.currentTarget);
		}
		
		protected function buttonDeSelected(e:CFM_ButtonEvent):void{
			dispatchEvent(new CFM_NavigationEvent(CFM_NavigationEvent.BUTTON_DESELECTED,e.index, e.id, e.value));
		}
		
		public function deselectAll(except:Number = -1):void{
			var i:Number = 0;
			
			for each(var o:CFM_SimpleButton in _buttonsVector){
				if(i!=except)
					o.deselect();
				
				i++;
			}
			
			if(except == -1) lastSelected = null;
		}
		
		protected function getButtonValue(_id:String):String{
			return list[getIndexById(_id)].@value;
		}
		
		public function hasButton(_id:String):Boolean{
			return !(buttonIds.indexOf(String(_id)) == -1);
		}
		
		protected function getIndexById(_id:String):Number{
			var id:Number;
			var i:Number = 0;
			
			for each(var x:XML in list){
				if(x.@id == _id)
					id = i;
					
				i++;
			}
			
			return id;
		}
		
		public function deActivateButtonByIndex(_index:Number):void{
			if(_buttonsVector[_index]) _buttonsVector[_index].deActivate();
		}
		
		public function activateButtonByIndex(_index:Number):void{
			if(_buttonsVector[_index]) _buttonsVector[_index].activate();
		}
		
		public function deActivateButtonById(_id:String):void{
			var index:Number = getIndexById(_id);
			if(index>=0) _buttonsVector[index].deActivate();	
			reposition();
		}
		
		public function activateButtonById(_id:String):void{
			var index:Number = getIndexById(_id);
			if(index>=0) _buttonsVector[index].activate();
			reposition();
		}
		
		public function getButtonLabelText(_id:String):String{
			return CFM_SimpleButton(_buttonsVector[getIndexById(_id)]).labelText;
		}
		
		public function selectButtonById(_id:String, _dispatch:Boolean = false):void{
			var index:Number = getIndexById(_id);

			if(_buttonsVector[index] != lastSelected){
				selectButton(index,_dispatch);
			}
		}
		
		public function getButtonById(_id:String):CFM_SimpleButton{
			return _buttonsVector[getIndexById(_id)];
		}
		
		public function selectNext(_dispatch:Boolean = false):void{
			var nextIndex:Number = 0;
			var currIndex:Number = lastSelected.buttonIndex;
			
			if(lastSelected)
				nextIndex = currIndex+1;
			
			if(nextIndex > _buttonsVector.length-1)
				nextIndex = 0;
			
			if(nextIndex != currIndex)
				selectButton(nextIndex,_dispatch);
		}
		
		public function selectPrevious(_dispatch:Boolean = false):void{
			var prevIndex:Number = _buttonsVector.length-1;
			var currIndex:Number = lastSelected.buttonIndex;
			
			if(lastSelected)
				prevIndex = currIndex-1;
			
			if(prevIndex < 0)
				prevIndex = _buttonsVector.length-1;
			
			if(prevIndex != currIndex)
				selectButton(prevIndex,_dispatch);
		}
		
		public function changeButtonLabelById(_id:String, _label:String, updateSize:Boolean = true):void{
			var index:Number = getIndexById(_id);
			CFM_SimpleButton(_buttonsVector[index]).updateLabel(_label, updateSize);
		}
		
		public function resetButtonLabelById(_id:String):void{
			var index:Number = getIndexById(_id);
			CFM_SimpleButton(_buttonsVector[index]).resetLabel();
		}
		
		public function selectButton(_childIndex:Number, _dispatch:Boolean = false):void{
			deselectAll(_childIndex);
			
			var btn:CFM_SimpleButton = _buttonsVector[_childIndex];
			
			if(btn){
				btn.select(_dispatch);
				lastSelected = btn;
			}
		}
		
		protected function get widestButton():CFM_SimpleButton{
			var widestWidth:Number = -100000;
			var wbtn:CFM_SimpleButton;
			
			for each(var o:CFM_SimpleButton in _buttonsVector)
				if(o.width > widestWidth){
					widestWidth = o.width;
					wbtn = o;
				}
			
			return wbtn;
		}
		
		protected function get widestButtonWidth():Number{
			var widestWidth:Number = 0;
			
			for each(var o:CFM_SimpleButton in _buttonsVector)
				if(o.width > widestWidth)
					widestWidth = o.width;
			
			return widestWidth;
		}
		
		protected function get farRightButtonIndex():Number{
			var greatestX:Number = -100000;
			var index:Number = 0;
			
			for each(var o:CFM_SimpleButton in _buttonsVector)
				if(o.currentPosition.x > greatestX && o.isActive == true){
					greatestX = o.currentPosition.x;
					index = _buttonsVector.indexOf(o);
				}
			
			return index;
		}
		
		
		
		protected function get lowestButtonIndex():Number{
			var greatestY:Number = -100000;
			var index:Number = 0;
			
			for each(var o:CFM_SimpleButton in _buttonsVector)
				if(o.currentPosition.y > greatestY && o.isActive == true){
					greatestY = o.currentPosition.y;
					index = _buttonsVector.indexOf(o);
				}
			
			return index;
		}
		
		public function addButton(_tag:XML):void{
			list[list.length()] = _tag;
			
			var btn:CFM_SimpleButton = buildButton(list.length()-1,list[list.length()-1]);
			btn.renderTo(buttonContainer);
			_buttonsVector.push(btn);
			
			reposition();
		}
		
		protected function get lastButton():CFM_SimpleButton{
			return CFM_SimpleButton(_buttonsVector[_buttonsVector.length-1]);
		}
		
		override public function get width():Number{
			return buttonContainer.x + currentWidth;
		}
		
		override public function get height():Number{
			return buttonContainer.y + currentHeight;
		}
		
		public function get buttonContainer():CFM_ObjectContainer{
			return _buttonContainer;
		}

		public function get buttonsVector():Vector.<CFM_SimpleButton>
		{
			return _buttonsVector;
		}

	}
}