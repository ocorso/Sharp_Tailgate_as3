package cfm.core.layout.table
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_BoxGraphics;
	import cfm.core.objects.CFM_Object;
	
	import flash.display.DisplayObject;
	
	import mx.utils.NameUtil;
	
	public class CFM_TableCell extends CFM_Object
	{
		protected var background:DisplayObject;
		protected var content:CFM_ObjectContainer;
		
		public var WIDTH:Number;
		public var HEIGHT:Number = 100;
		public var xml:XML;
		
		public function CFM_TableCell(_width:Number, _xml:XML)
		{
			WIDTH = _width;
			xml = _xml;
			
			super("FeatureColumn", true, true);
		}
		
		override protected function build():void{
			buildBackground();
			
			content = new CFM_ObjectContainer(true);
			content.renderTo(this);
			
			buildContent();
		}
		
		protected function buildBackground():void{
			background = new CFM_BoxGraphics({width:WIDTH,height:HEIGHT, color:0xFFFFFF, alpha:.5});
			CFM_BoxGraphics(background).renderTo(this);
		}
		
		protected function buildContent():void{}
	}
}