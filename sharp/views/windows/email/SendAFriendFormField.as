package sharp.views.windows.email
{
	import cfm.core.ui.CFM_FormField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import flash.events.FocusEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sharp.model.vo.Vo;
	
	public class SendAFriendFormField extends CFM_FormField
	{
		private var _totalWidth			:Number;
		protected var value				:String;
		
		override public function validate():Boolean{
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
			
			if(valid || (value == "message" && input.text == defaultText)){
				noErrorState();
			} else {
				toErrorState();
			}
			
			return valid;
		}
		
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildBackground():void{
			super.buildBackground();
			background.filters = [new DropShadowFilter(3,90,0,.2,4,4,1,3,true)];
			
			if(value == "subject") background.alpha = 0;
		}
		// =================================================
		// ================ Workers
		// =================================================
		
		override protected function addListeners():void{
			if(value != "subject" && value != "message"){
				input.addEventListener(FocusEvent.FOCUS_IN, focusIn, false, 0, true);
				input.addEventListener(FocusEvent.FOCUS_OUT, focusOut, false, 0, true);
			}
		}
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		override protected function get inputParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams 	= super.inputParams;
			p.font 						= Vo.FONT_MEDIUM;
			p.size 						= 12;
			p.color 					= 0x333333;
			p.align 					= TextFormatAlign.LEFT;
			p.width 					= _totalWidth;
			if(value == "subject") p.type = TextFieldType.DYNAMIC;
			return p;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = super.backgroundParams;
			
			p.colors = [0xffffff];
			
			//p.width = 500;
			
			return p;
		}
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

		public function SendAFriendFormField(_value:String, $totalWidth:Number, _index:Number, _isEmail:Boolean=false, _required:Boolean=true, _password:Boolean=false, _defaultText:String="", __height:Number=Number.NaN, _labelText:String="", _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			_totalWidth = $totalWidth;
			value = _value;
			
			super(_index, _isEmail, _required, _password, _defaultText, __height, _labelText, _autoInit, _autoDestroy);
		}
	
	}
}