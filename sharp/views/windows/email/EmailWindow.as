package sharp.views.windows.email
{
	import cfm.core.events.CFM_FormEvent;
	import cfm.core.events.CFM_NavigationEvent;
	
	import com.adobe.serialization.json.JSON;
	
	import sharp.events.DataResponseEvent;
	import sharp.views.windows.SharpPopupWindowTemplate;
	
	public class EmailWindow extends SharpPopupWindowTemplate
	{
		private var emailFormXML				:XML;
		private var submitButtonXML				:XML;
		private var optInButtonXML				:XML;
		
		private var _emailForm					:SendAFriendForm;
		public var baseUrl						:String;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			pageNavigation.setProperties({x:_totalWidth - pageNavigation.width - 45});
		}
		override protected function buildBackground():void{
			super.buildBackground();
		}
		
		override protected function buildContent():void{
			emailFormXML 		= xml.email_form[0];
			optInButtonXML		= emailFormXML.opt[0];
			
			buildEmailForm();
		}
		
		private function buildEmailForm():void{
			_emailForm = new SendAFriendForm( _totalWidth, optInButtonXML, xml.email_form.field, baseUrl+"/email"  );
			_emailForm.renderTo(_content);	
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		override protected function addListeners():void{
			super.addListeners();
			
			_emailForm.addEventListener(CFM_FormEvent.SEND_COMPLETE, onSendComplete, false, 0, true);
		}
		
		override protected function removeListeners():void{
			super.removeListeners();
			
			_emailForm.removeEventListener(CFM_FormEvent.SEND_COMPLETE , onSendComplete);
		}
		// =================================================
		// ================ Handlers
		// =================================================
		override protected function buildComplete():void{
			super.buildComplete();
			
			_emailForm.setProperties({ x:heading.x + 5, y:description.y + description.height + 20});
		}
		
		private function onSendComplete(e:CFM_FormEvent):void{
			var response:Object = JSON.decode(e.result);
			
			dispatchEvent(new DataResponseEvent(DataResponseEvent.RESPONSE,response));
			//appModel.popupWindowFactory.changePage("response", response);
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		override protected function onNavigationClicked(e:CFM_NavigationEvent):void{			
			if(e.id == "send")
				_emailForm.submitForm({"title":params.tailgateName, "tid":params.tid});
		}
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function EmailWindow( _index:Number, _xml:XML, _params:Object )
		{
			super( _index, _xml, _params );
		}
		
	}
}