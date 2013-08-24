package sharp.views.customizeModule.itemCanvas
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.graphics.CFM_Graphics;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	
	import net.ored.util.out.Out;
	
	public class DraggableItemCanvas extends CFM_ObjectContainer
	{
		private var _transformManager			:TransformManager;
		private var _item						:DraggableItem;
		private var _currentItems				:Array;
		private var _itemMask					:CFM_Graphics;
		
		// =================================================
		// ================ Callable
		// =================================================
		public function updateItem(_color1:uint, _color2:uint, _imgUrl:String, _colorType:String):void{
			_item = new DraggableItem(_color1, _color2, _imgUrl, _colorType);
			_item.renderTo(this);
			_transformManager.addItem( _item );
			_item.x = (stage.stageWidth - _item.width)*.5;
			_item.y = 200;
			_item.scaleX = _item.scaleY = 0;
			TweenMax.to(_item, .5, {delay:.3, bezierThrough:[{scaleX:1.5, scaleY:1.5},{scaleX:1, scaleY:1}], alpha:1, ease:Cubic.easeOut});
			_currentItems.push(_item);
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		private function buildTransformManager():void{
			_transformManager = new TransformManager({allowDelete:true, scaleFromCenter:true,constrainScale:true, autoDeselect:true });
			
			_transformManager.addEventListener(TransformEvent.DELETE, onItemDelete, false, 0, true);
			_transformManager.addEventListener(TransformEvent.SELECTION_CHANGE, onItemSelected, false, 0, true);
			
			_transformManager.addEventListener(TransformEvent.MOVE, onItemTransform, false, 0, true);
			_transformManager.addEventListener(TransformEvent.ROTATE, onItemTransform, false, 0, true);
			_transformManager.addEventListener(TransformEvent.SCALE, onItemScale, false, 0, true);
			
			buildMask();
		}
		
		private function buildMask():void{
			_itemMask = new CFM_Graphics();
			_itemMask.width = 789;
			_itemMask.height = 650;
			_itemMask.renderTo(this);
			this.mask = _itemMask;
		}
		

		// =================================================
		// ================ Workers
		// =================================================
		private function init():void{
			_currentItems = new Array();
			buildTransformManager();
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onItemDelete(e:TransformEvent):void{
			var _item:TransformItem = e.items[0];
			var _itemIndex:Number = _currentItems.indexOf(_item);
			
			_currentItems.splice(_itemIndex,1);
		}
		
		private function onItemSelected(e:TransformEvent):void{
			var _item:TransformItem = e.items[0];
			var _itemIndex:Number = _currentItems.indexOf(_item);

		}
		private function onItemTransform(e:TransformEvent):void{
			var _item:TransformItem = e.items[0];
			var _itemIndex:Number = _currentItems.indexOf(_item);
			
		}
		private function onItemScale(e:TransformEvent):void{
			var _item:TransformItem = e.items[0];
			var _itemIndex:Number = _currentItems.indexOf(_item);
			
//			if(_item.scaleX > 1)
//				_item.scaleX = _item.scaleY = 1;
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function DraggableItemCanvas()
		{
			super(true);
			
			init();
		}
	}
}