package sharp.views.themeModule.carouselNavigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.themeModule.carouselNavigation.buttons.ArrowButton;
	
	public class ArrowNavigation extends SharpNavigationTemplate
	{
		
		private var label						:CFM_TextField;
		public var _roomIndex					:int;
		
		// =================================================
		// ================ Callable
		// =================================================
		public function positionAssets():void{
			label.x = buttonsVector[0].x + buttonsVector[0].width + 10;
			buttonsVector[1].x = label.x + label.width + 10;
		}
		
		public function updateLabel(_roomName:String):void{
			label.text = _roomName.toUpperCase();
		}

		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();	
			buildLabel();
		}
		
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new ArrowButton(_i, _tag.@id, _tag.@value, "", 4,4,false,false);
		}
		private function buildLabel():void{
			label = new CFM_TextField("ROOM NAME", labelParams);
			label.renderTo(this);
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		
		private function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.font = Vo.FONT_MEDIUM;
			p.size = 20;
			p.width = 170;
			p.wordWrap = true;
			p.align = "center";
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function ArrowNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
		}

	
	}
}