package cfm.core.shapes
{
	import flash.display.Shape;
	
	public class VolumeIcon extends Shape
	{
		private const _totalH:Number = 12;
		private const _totalW:Number = 11;
		
		private const _squareH:Number = 6;
		private const _squareW:Number = 7;
		
		private const _wingHeight:Number = (_totalH-_squareH)*.5;	
		
		public function VolumeIcon()
		{
			graphics.beginFill(0x444444);
			
			graphics.moveTo(0,_wingHeight);
			graphics.lineTo(_squareW,_wingHeight);
			graphics.lineTo(_totalW,0);
			graphics.lineTo(_totalW,_totalH);
			graphics.lineTo(_squareW,_squareH+_wingHeight);
			graphics.lineTo(0,_squareH+_wingHeight);
			graphics.lineTo(0,_wingHeight);
		}
	}
}