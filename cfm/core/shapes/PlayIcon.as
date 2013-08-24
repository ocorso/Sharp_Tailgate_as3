package cfm.core.shapes
{
	import flash.display.Shape;
	
	public class PlayIcon extends Shape
	{
		private const _totalH:Number = 12;
		private const _totalW:Number = 10;
		
		public function PlayIcon()
		{
			graphics.beginFill(0xFFFFFF,1);
			graphics.lineTo(_totalW,_totalH*.5);
			graphics.lineTo(0,_totalH);
		}
	}
}