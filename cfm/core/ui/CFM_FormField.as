package cfm.core.ui
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.objects.CFM_Object;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class CFM_FormField extends CFM_Object
	{
		protected var MARGIN:int = 4;
		protected var _height:Number = Number.NaN;
		protected var backgroundContainer:CFM_ObjectContainer;
		protected var labelContainer:CFM_ObjectContainer;
		protected var errorContainer:CFM_ObjectContainer;
		
		public var background:CFM_Graphics;
		protected var error:CFM_Graphics;
		
		protected var label:CFM_TextField;
		protected var input:CFM_TextField;
	
		protected var defaultText:String;
		protected var labelTxt:String;
		protected var isEmail:Boolean;
		protected var tweenTime:Number;
		protected var isValid:Boolean = false;
		protected var index:Number;
		public var enabled:Boolean = true;
		protected var required:Boolean = true;
		protected var isPassword:Boolean = false;
		
		public function CFM_FormField(_index:Number, _isEmail:Boolean=false, _required:Boolean=true, _password:Boolean=false, _defaultText:String="", __height:Number = Number.NaN, _labelText:String="", _autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			defaultText = _defaultText;
			isEmail = _isEmail;
			index = _index;
			required = _required;
			isPassword = _password;
			labelTxt = _labelText;
			_height = __height;
			
			super("CFM_FormField",_autoInit, _autoDestroy);
		}
		
		public function get inputValue():String{return input.text;}
		
		protected override function build():void{
			backgroundContainer = new CFM_ObjectContainer();
			backgroundContainer.renderTo(this);
			
			labelContainer = new CFM_ObjectContainer();
			labelContainer.renderTo(this);
			
			errorContainer = new CFM_ObjectContainer();
			errorContainer.renderTo(this);
			
			buildBackground();
			buildError();
			
			buildLabel();
			buildInput();
			buildComplete();
			noErrorState();
		}
		
		protected function get inputParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.size = 10;
			p.leading = 3;
			p.letterSpacing = .2;
			p.type = TextFieldType.INPUT;
			p.width = 250;
			p.height = _height;
			p.autoSize = TextFieldAutoSize.NONE;
			p.wordWrap = isNaN(_height) ? false : true;
			return p;
		}
		
		public function reset():void{
			input.text = defaultText;
			isValid = validate();
		}
		
		protected function buildBackground():void{
			background = new CFM_Graphics(backgroundParams);
			background.renderTo(backgroundContainer);
		}
		
		protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			
			p.colors = [0x999999];
			p.alphas = [1];
			p.width = 10;
			p.height = 10;
			
			return p;
		}
				
		protected function buildError():void{
			error = new CFM_Graphics(errorParams);
			error.renderTo(errorContainer);
		}
		
		protected function get errorParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			
			p.colors = [0xFFFFFF];
			p.alphas = [.1];
			p.lineColor = 0xFF0000;
			p.lineThickness = 1;
			
			return p;
		}
		
		protected function buildInput():void{
			input = new CFM_TextField(defaultText, inputParams);
			input.renderTo(this);
			input.setProperties({x:background.x + MARGIN+1, y:MARGIN+1});
		}
		
		protected function buildLabel():void{
		   label = new CFM_TextField(labelTxt, labelParams);
		   label.renderTo(this);
		}
		
		protected function get labelParams():CFM_TextFieldParams{
			return new CFM_TextFieldParams({size:14, color:0x333333});
		}
		
		override protected function buildComplete():void{
			background.redraw(input.width+(MARGIN*2),input.height+(MARGIN*2),0,0);
			error.redraw(input.width+(MARGIN*2),input.height+(MARGIN*2),0,0);
			input.tabIndex = index;
			focusOut(null);
		}
		
		protected override function addListeners():void{
			input.addEventListener(FocusEvent.FOCUS_IN, focusIn, false, 0, true);
			input.addEventListener(FocusEvent.FOCUS_OUT, focusOut, false, 0, true);
		}
		
		protected function focusIn(e:FocusEvent):void{
			toFocusState();
			
			if(input.text == defaultText){
				input.text = "";
			}

			input.displayAsPassword = inputParams.displayAsPassword;
		}
		
		public function toErrorState():void{
			isValid = false;
			
			TweenMax.killTweensOf(errorContainer);
			TweenMax.to(errorContainer, .3, {autoAlpha:1});
		}
				
		protected function noErrorState():void{
			isValid = true;
			
			TweenMax.killTweensOf(errorContainer);
			TweenMax.to(errorContainer, .3, {autoAlpha:0});
		}
		
		protected function toFocusState():void{
			//TweenMax.killTweensOf(backgroundContainer);
			//TweenMax.to(backgroundContainer, tweenTime, {dropShadowFilter:{color:0, blurX:8, blurY:8, alpha:.4,amount:1, inner:true}});
		}
		
		protected function toUnFocusedState():void{
			//TweenMax.killTweensOf(backgroundContainer);
			//TweenMax.to(backgroundContainer, tweenTime, {dropShadowFilter:{color:0, blurX:2, blurY:2, alpha:.2,amount:1, inner:true}});
		}
		
		protected function focusOut(e:FocusEvent):void{
			toUnFocusedState();
			
			if(input.text == "" || input.text == defaultText){
				input.displayAsPassword = false;
				input.text = defaultText;
			}	
		}
		
		public function validate():Boolean{
			var valid:Boolean = true;
			
			if(required){
				if(input.text.length >= 1 && input.text != defaultText){
					if(isEmail){
						if(!validateEmail(input.text)){
							valid = false;
						}
					}
				} else {
					valid = false;
					toErrorState();
				}
			}
			
			if(!valid){
				toErrorState();
			} else {
				noErrorState();
			}
			
			return valid;
		}
		
		protected override function removeListeners():void{
			input.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
			input.removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
		}
		
		protected function validateEmail(_txt:String):Boolean{
			var v:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return v.test(_txt);
		}
		
		public function disable():void{
			backgroundContainer.alpha = .5;
			input.mouseEnabled = false;
			enabled = false;
		}
		
		public function enable():void{
			backgroundContainer.alpha = 1;
			input.mouseEnabled = true;
			enabled = true;
		}
	}
}