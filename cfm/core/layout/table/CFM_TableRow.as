package cfm.core.layout.table
{
	import cfm.core.graphics.CFM_BoxGraphics;
	import cfm.core.objects.CFM_Object;
	
	import mx.utils.NameUtil;
	
	public class CFM_TableRow extends CFM_Object
	{
		protected var background:CFM_BoxGraphics;
		private const CELL_GUTTER:Number = 10;
		
		public var TOTAL_WIDTH:Number;
		public var CELLS_WIDTH:Number;
		
		public var cellList:XMLList;
		private var	cell:CFM_TableCell;
		public var currentCells:Array = [];
		
		public function CFM_TableRow(_width:Number, _cellList:XMLList)
		{
			TOTAL_WIDTH = _width;
			cellList = _cellList;
			CELLS_WIDTH = TOTAL_WIDTH - ((cellList.length()-1)*CELL_GUTTER)

			super("FeatureRow", true, true);
		}
		
		override protected function build():void{
			buildBackground();
			buildCells();
		}
		
		protected function buildBackground():void{
			background = new CFM_BoxGraphics({width:TOTAL_WIDTH,height:10, color:0x666666, alpha:.8});
			background.renderTo(this);
		}
		
		public function buildCells():void{
			for each(var c:XML in cellList){
				var index:Number = c.childIndex();

				cell = buildCell(CELLS_WIDTH*(cellList.length() > 1 ? c.@pwidth : 1),c);
				cell.renderTo(this);
				
				if(index > 0){
					cell.x = currentCells[index-1].x + currentCells[index-1].WIDTH + CELL_GUTTER;
				}
				
				currentCells.push(cell);
			}
			
			if(background) background.resize(TOTAL_WIDTH,this.height, 0,0);
		}
		
		protected function buildCell(_w:Number, _xml:XML):CFM_TableCell{
			return new CFM_TableCell( _w, _xml );
		}
	}
}