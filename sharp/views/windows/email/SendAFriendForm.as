package sharp.views.windows.email
{
	import cfm.core.ui.CFM_EmailForm;
	import cfm.core.ui.CFM_FormField;
	
	public class SendAFriendForm extends CFM_EmailForm
	{
		private var _totalWidth			:Number;
		
		//private var _optInButtonXML		:XML;
		//private var _optInButton		:OptInCheckbox;
		
		private var field				:XMLList;
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		override protected function buildFields():void{
			var i:Number = 0;
			FIELD_SPACING = 12;
			
			for each(var fo:XML in formFieldsList){
				formField = buildField(fo.childIndex(), fo);
				formField.renderTo(container);
				formField.setProperties({y:i>0?fieldsArray[i-1].y + fieldsArray[i-1].height + FIELD_SPACING : 0});
				fieldsArray.push(formField);
				i++;
			}
			//buildOptInCheckbox();
		}
		
		
		/*private function buildOptInCheckbox():void{
			_optInButton = new OptInCheckbox( 0, _optInButtonXML.@id, _optInButtonXML.@value, _optInButtonXML.label[0],4,4,true,true );
			_optInButton.setProperties({y:container.height + 10});
			_optInButton.renderTo(container);
		}*/
		
		override protected function buildField(_index:Number, _tag:XML):CFM_FormField{
			return new SendAFriendFormField(	_tag.@value,
				_totalWidth-120,
				_index,
				_tag.@email == "yes" ? true : false, 
				_tag.@required == "yes" ? true : false, 
				_tag.@password == "yes" ? true : false, 
				_tag.@defaultText, 
				parseInt(_tag.@height) || Number.NaN, 
				_tag.@label		);
		}	
		
		// =================================================
		// ================ Workers
		// =================================================
		override protected function send(_addParams:Object = null):void{
			var addParams:Object = _addParams ? _addParams : new Object();
			
			//addParams[_optInButton.buttonValue] = _optInButton.selected ? 1 : 0;
			
			super.send(addParams);
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

		public function SendAFriendForm($totalWidth:Number, $optInButtonXML:XML, _fields:XMLList, _phpUrl:String, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			_totalWidth 	= $totalWidth;
			//_optInButtonXML = $optInButtonXML;
			field 			= _fields;
			
			super(_fields, _phpUrl, _autoInit, _autoDestroy);
		}
		
	}
}