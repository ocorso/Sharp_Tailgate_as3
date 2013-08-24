package cfm.core.layout.table
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_BoxGraphics;
	import cfm.core.objects.CFM_Object;
	
	public class CFM_Table extends CFM_Object
	{
		protected var background:CFM_BoxGraphics;
		
		public var MARGIN:Number = 8;
		public var ROW_SPACING:Number = 2;
		public var WIDTH:Number = 270;
		
		//protected var xml:XML;
		protected var rowsList:XMLList;
		protected var row:CFM_TableRow;
		protected var currentRows:Array = [];
		protected var container:CFM_ObjectContainer;
		
		public function CFM_Table(_rowList:XMLList)
		{
			//xml = _xml;
			rowsList = _rowList;
			super("FeaturePanel", true, true);
		}
		
		override protected function build():void{
			container = new CFM_ObjectContainer(true);
			container.renderTo(this);
			
			buildBackground();
		
			buildRows();
		}
		
		protected function buildBackground():void{
			background = new CFM_BoxGraphics({width:WIDTH,height:10, color:0x666666, alpha:1});
			background.renderTo(container);
		}
		
		protected function buildRows():void{
			var index:Number = 0;
			for each(var r:XML in rowsList){
				row = buildRow(WIDTH-(MARGIN*2), r.control);
				row.renderTo(container);
				
				if(index > 0){
					row.y = currentRows[index-1].y + currentRows[index-1].height + ROW_SPACING;
				} else {
					row.y = MARGIN;
				}
				
				row.x = MARGIN;
				
				currentRows.push(row);
				index++;
			}
			
			if(background) background.resize(WIDTH,container.height+MARGIN, 0,0);
		}
		
		protected function buildRow(_width:Number, _cellList:XMLList):CFM_TableRow{
			return new CFM_TableRow(_width,_cellList);
		}
	}
}