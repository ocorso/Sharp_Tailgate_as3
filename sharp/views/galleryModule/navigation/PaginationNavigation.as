package sharp.views.galleryModule.navigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import flash.events.Event;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.galleryModule.buttons.PaginationButton;
	
	public class PaginationNavigation extends CFM_SimpleNavigation
	{
		private var _label					:CFM_TextField;
		
		private var _totalPageNumber		:int;
		private var _currentPageNumber		:int;
	
		// =================================================
		// ================ Callable
		// =================================================

		public function update($pageNum:Number):void{
			_currentPageNumber = $pageNum;
			_updateLabel();
			checkButtons();	
		}
		// =================================================
		// ================ Create and Build
		// =================================================
		
		override protected function build():void{
			_buildLabel();
			super.build();
			
			_label.x = buttonsVector[0].x + buttonsVector[0].width + 20;
			buttonsVector[1].x 	= _label.x + _label.width + 21;
			checkButtons();
		}
		private function _buildLabel():void{
			_label = new CFM_TextField("1 of " + String(totalPageNumber), labelParams);
			_label.renderTo(this);
		}
		// =================================================
		// ================ Workers
		// =================================================

		public function checkButtons():void{
			if(totalPageNumber == 1){
				buttonsVector[0].visible = false;
				buttonsVector[1].visible = false;
			}else{
				buttonsVector[0].visible = true;
				buttonsVector[1].visible = true;
				if(currentPageNumber == 0){
					buttonsVector[0].visible = false;
					buttonsVector[1].visible = true;
				}else if(currentPageNumber ==  totalPageNumber-1){
					buttonsVector[1].visible = false;
					buttonsVector[0].visible = true;
				}else{
					buttonsVector[0].visible = true;
					buttonsVector[1].visible = true;
				}
			}

		}
		// =================================================
		// ================ Handlers
		// =================================================
		protected function _updateLabel($e:Event = null):void
		{
			if(totalPageNumber == 0) totalPageNumber = 1;
			var txt:String = String(currentPageNumber+1) + " of " + totalPageNumber;
			_label.text = txt;
			_label.x = buttonsVector[0].x + buttonsVector[0].width + 20;
			buttonsVector[1].x 	= _label.x + _label.width + 21;
		}
		
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
			p.size = 14;
			return p;
		}
		
		public function get totalPageNumber():int
		{
			return _totalPageNumber;
		}
		
		public function set totalPageNumber(value:int):void
		{
			_totalPageNumber = value;
		}
		
		public function get currentPageNumber():int
		{
			return _currentPageNumber;
		}
		
		public function set currentPageNumber(value:int):void
		{
			_currentPageNumber = value;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function buildButton(_i:Number, _tag:XML):CFM_SimpleButton{
			return new PaginationButton(_i, _tag.@id, _tag.value, _tag.label, 0,0,false,false);

		}

		// =================================================
		// ================ Constructor
		// =================================================

		public function PaginationNavigation(_list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxWidth:Number=0)
		{
  			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxWidth);
		}
	}
}