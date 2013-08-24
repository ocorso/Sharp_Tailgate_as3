package cfm.core.shapes
{
	import flash.display.Sprite;
	
	public class PauseIcon extends Sprite
	{
		private const _totalH:Number = 12;
		private const _totalW:Number = 10;
		private const _sideWidth:Number = 4;
		
		public function PauseIcon()
		{
			graphics.beginFill(0x444444,1);
			graphics.drawRect(0,0,_sideWidth,_totalH);
			graphics.drawRect(_totalW-_sideWidth, 0, _sideWidth,_totalH);
		}
	}
}