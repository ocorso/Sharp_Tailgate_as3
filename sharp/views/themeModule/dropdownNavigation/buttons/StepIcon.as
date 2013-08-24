package sharp.views.themeModule.dropdownNavigation.buttons
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import sharp.model.vo.Vo;
	
	public class StepIcon extends CFM_ObjectContainer
	{
		
		private var circle						:CFM_Graphics;
		private var numberField					:CFM_TextField;
		private var number						:String;
		
		private const CIRCLE_SIZE				:Number = 28;
		private const CIRCLE_LINE_THICKNESS		:Number = 3;
		

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		private function buildCircle():void{
			circle = new CFM_Graphics(circleParams);
			circle.renderTo(this);
		}
		
		private function buildNumber():void{
			numberField = new CFM_TextField(number, numberParams);
			numberField.renderTo(this);
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		private function init():void{
			buildCircle();
			buildNumber();
			
			numberField.setProperties({x:circle.x + (circle.width-numberField.width)*.5 - 1, y:circle.y + (circle.height-numberField.height)*.5 - 3});
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
		private function get circleParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.circle = true;
			p.width = CIRCLE_SIZE;
			p.height = CIRCLE_SIZE;
			p.x = CIRCLE_SIZE*.5;
			p.y = CIRCLE_SIZE*.5;
			p.colors = [0xffffff];
			p.lineThickness = CIRCLE_LINE_THICKNESS;
			p.lineColor = Vo.BLACK;
			return p;
		}
		
		private function get numberParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = 0x000000;
			p.font = Vo.FONT_BOLD;
			p.size = 18;
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
		public function StepIcon(_number:String)
		{
			super(true);
			number = _number;
			init();
		}
		

	}
}