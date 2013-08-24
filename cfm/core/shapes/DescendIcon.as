package cfm.core.shapes
{
	import flash.display.Shape;
	
	public class DescendIcon extends Shape
	{
		private const _totalH:Number = 10;
		private const _totalW:Number = 12;
		
		public function DescendIcon()
		{
			graphics.beginFill(0xFFFFFF,1);
			graphics.moveTo(-_totalW*.5, -_totalH*.5);
			graphics.lineTo(_totalW*.5,-_totalH*.5);
			graphics.lineTo(0,_totalH*.5);
		}
	}
}