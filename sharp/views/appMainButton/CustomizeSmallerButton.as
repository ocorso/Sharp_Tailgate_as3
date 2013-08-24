package sharp.views.appMainButton
{
	import cfm.core.vo.CFM_TextFieldParams;
	
	import flash.display.Shape;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class CustomizeSmallerButton extends AppMainButton
	{

		// =================================================
		// ================ Callable
		// =================================================
		override public function dropdownOpen():void{
			redIcon.rotation = -90;
			redIcon.x = greyBG.x + (greyBG.width - redIcon.width)*.5;
			redIcon.y = greyBG.y + (greyBG.height - redIcon.height)*.5 + redIcon.width + 3;
		}
		
		override public function dropdownClose():void{
			redIcon.rotation = 90;
			redIcon.x = greyBG.x + (greyBG.width - redIcon.width)*.5 + redIcon.width + 1;
			redIcon.y = greyBG.y + (greyBG.height - redIcon.height)*.5;
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
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
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_BOLD;
			p.color = 0xffffff;
			p.size = 13;
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function resizeGraphics():void{
			super.resizeGraphics();
			redIcon.scaleX = redIcon.scaleY = .85;
			redIcon.rotation = 90;
			redIcon.x = greyBG.x + (greyBG.width - redIcon.width)*.5 + redIcon.width + 1;
			
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function CustomizeSmallerButton(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			SQUARE_SIZE = Vo.BUTTON_SQUARE_SIZE;
		}

	}
}