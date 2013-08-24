package cfm.core.ui
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_FormEvent;
	import cfm.core.objects.CFM_Object;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import net.ored.util.out.Out;
	
	/**
	 * Accepts an <XMLList> of <field> tags. 
	 * the <value> property is what will be passed to the PHP emailer
	 * Passing a value to the <height> property will make it multiline.
	 * I'll tell you more later.
	 * 
	 * @example:
	 * <field required="yes" defaultText="Name" label="" value="fromName" email="yes" />
	 * 
	 * @author Jason Tordsen
	 * 
	 */	
	public class CFM_EmailForm extends CFM_Object
	{
		protected var container:CFM_ObjectContainer;
		protected var formFieldsList:XMLList;
		protected var formField:CFM_FormField;
		protected var fieldsArray:Array = [];
		protected var phpUrl:String;
		protected var sendVars:URLVariables;
		protected var FIELD_SPACING:Number = 8;
		
		public function CFM_EmailForm(_fields:XMLList, _phpUrl:String, _autoInit:Boolean = true, _autoDestroy:Boolean = true)
		{
			formFieldsList = _fields;
			phpUrl = _phpUrl;
			
			super("CFM_Form", _autoInit, _autoDestroy);
		}
		
		public function getField(_index:Number):CFM_FormField{
			return fieldsArray[_index];
		}
		
		protected override function build():void{
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			
			buildFields();
		}
		
		protected function buildFields():void{
			var i:Number = 0;
			
			for each(var fo:XML in formFieldsList){
				formField = buildField(fo.childIndex(), fo);
				formField.renderTo(container);
				
				if(i>0){
					formField.x = int(fieldsArray[i-1].x + fieldsArray[i-1].width + FIELD_SPACING);		
				
					if(i%2 == 0){
						formField.y = int(fieldsArray[i-1].y + fieldsArray[i-1].height + FIELD_SPACING);
						formField.x = 0;
					}else{
						formField.y = fieldsArray[i-1].y;
					}
				}
				
				fieldsArray.push(formField);
				i++;
			}
		}
		
		protected function buildField(_index:Number, _tag:XML):CFM_FormField{
			return new CFM_FormField(_index,_tag.@email == "yes" ? true : false, _tag.@required == "yes" ? true : false, _tag.@password == "yes" ? true : false, _tag.@defaultText, parseInt(_tag.@height) || Number.NaN, _tag.@label);
		}
		
		public function validateForm():Boolean{
			var valid:Boolean = true;
			
			for each(var f:CFM_FormField in fieldsArray)
				if(f.enabled && !f.validate()) 
					valid = false;
			
			return valid;
		}
		
		public function submitForm(_addParams:Object = null):void{
			if(validateForm())
				send(_addParams);
			else
				dispatchEvent(new CFM_FormEvent(CFM_FormEvent.VALIDATE_FORM,"",false));
		}
		
		public function resetForm():void{
			for each(var f:CFM_FormField in fieldsArray)
				f.reset();
		}
		
		protected function send(_addParams:Object = null):void{
			sendVars = new URLVariables();
						
			for (var i:Number =0; i <formFieldsList.length(); i++ )
				sendVars[formFieldsList[i].@value] = CFM_FormField(fieldsArray[i]).inputValue;
			
			if(_addParams)
				for (var s:String in _addParams) sendVars[s] = _addParams[s];
			
			var request:URLRequest = new URLRequest(phpUrl);
			var loader:URLLoader = new URLLoader();
			
			request.method = URLRequestMethod.POST;
			request.data = sendVars;
			
			Out.info(this, sendVars);

			loader.addEventListener(Event.COMPLETE, onSubmitComplete, false, 0, true);
			loader.load(request);
		}
		
		protected function onSubmitComplete(e:Event):void{
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onSubmitComplete);
			
			dispatchEvent( new CFM_FormEvent(CFM_FormEvent.SEND_COMPLETE, loader.data, false) );
		}
	}
}