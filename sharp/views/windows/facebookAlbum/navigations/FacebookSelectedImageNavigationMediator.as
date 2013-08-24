package sharp.views.windows.facebookAlbum.navigations
{
	import cfm.core.containers.CFM_ObjectContainer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.FacebookAlbumSideNavEvent;
	import sharp.events.FacebookPhotoEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.windows.facebookAlbum.buttons.FacebookSideNavThumbnail;
	
	
	
	public class FacebookSelectedImageNavigationMediator extends Mediator
	{
		
		[Inject]
		public var view									:FacebookSelectedImageNavigation;
		
		[Inject]
		public var _m:Model;		
		
		private var MAX_CHILDREN						:int = 5;
		private var MARGIN_BOTTOM						:int = 6;
		private var seletedItem							:CFM_ObjectContainer;
		private var last_y_axis							:Number;
		
		override public function onRegister():void{
			eventMap.mapListener(view, Event.ADDED, itemAdded, null, true, 0, true);
			eventMap.mapListener(view, MouseEvent.MOUSE_DOWN, itemMouseDown, null, true, 0, true);
			eventMap.mapListener(view, MouseEvent.MOUSE_UP, itemMouseUp, null, true, 0, true);
			eventMap.mapListener(view, Event.MOUSE_LEAVE, itemMouseUp, null, true, 0, true);
			
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, Event.ADDED, itemAdded);
			eventMap.unmapListener(view, MouseEvent.MOUSE_DOWN, itemMouseDown);
			eventMap.unmapListener(view, MouseEvent.MOUSE_UP, itemMouseUp);
			eventMap.unmapListener(view, Event.MOUSE_LEAVE, itemMouseUp);
		}
		
		private function itemAdded(e:Event):void{
			if (e.target.parent == view.thumbContainer) {
				
				// If nav holds more than max children value
				if (view.thumbContainer.numChildren > MAX_CHILDREN) {
					
					// Dispatch event to FacebookAlbumWindowMediator
					var lastChild:FacebookSideNavThumbnail = view.thumbContainer.getChildAt(MAX_CHILDREN-1) as FacebookSideNavThumbnail;
					dispatch(new FacebookAlbumSideNavEvent(FacebookAlbumSideNavEvent.DESELECT_PHOTO, lastChild.photoId));
					// Remove last image and pop arrray
					view.thumbContainer.removeChild(lastChild);
					Vo.customizeParams.photoIds.pop();
				}
				
				view.message.visible = false;
				
				// Add imageUrl to photoIds array
				Vo.customizeParams.photoIds.push((e.target as FacebookSideNavThumbnail).photoId);
				sortItems();			
			}
		}
		
		private function sortItems():void{
			for (var i:int = 0; i < view.thumbContainer.numChildren; i++){
				var item:Object = view.thumbContainer.getChildAt(i);
				item.y = (item.height + MARGIN_BOTTOM) * i;
				item.oy = item.y;
			}			
		}
		
		private function refreshIndex():void{
			var arr:Array = new Array();
			for (var i:int = 0; i < view.thumbContainer.numChildren; i++){
				var item:FacebookSideNavThumbnail = view.thumbContainer.getChildAt(i) as FacebookSideNavThumbnail;
				arr.push({obj:item, y:item.y});
			}				
			Vo.customizeParams.photoIds = [];
			arr.sortOn("y", Array.NUMERIC);			
			for (i = 0; i < arr.length; ++i) 
			{ 
				view.thumbContainer.setChildIndex(arr[i].obj , i);
				Vo.customizeParams.photoIds.push(arr[i].obj.photoId);
			} 
			sortItems();
		}
		
		
		private function itemMouseDown(e:MouseEvent):void{
			
			seletedItem = e.target.parent as FacebookSideNavThumbnail;
			if (e.target.name == "imageHolder") {
				var bound:Rectangle = new Rectangle(0,0,0,view.thumbContainer.height - seletedItem.height);
				seletedItem.startDrag(false, bound);
				var idx_last_item:DisplayObject = view.thumbContainer.getChildAt(view.thumbContainer.numChildren-1);
				if (seletedItem != idx_last_item) view.thumbContainer.swapChildren(seletedItem,idx_last_item);
				view.addEventListener(Event.ENTER_FRAME, detectCollision, false, 0, true);
			}
			else{
				itemRemove(seletedItem);
			}
		}
		
		private function itemMouseUp(e:MouseEvent):void{
			if (e.target.name == "imageHolder") {
				view.removeEventListener(Event.ENTER_FRAME, detectCollision);
				seletedItem.stopDrag();
				refreshIndex();
			}
		}
		
		private function itemRemove(btn:*):void{
			var item:FacebookSideNavThumbnail = btn as FacebookSideNavThumbnail;
			dispatch(new FacebookAlbumSideNavEvent(FacebookAlbumSideNavEvent.DESELECT_PHOTO, item.photoId));
			view.thumbContainer.removeChild(item);
			refreshIndex();
			if (view.thumbContainer.numChildren == 0) view.message.visible = true;
		}		
		
		private function detectCollision(e:Event):void{
			var y0:Number = seletedItem.y;
			var y1:Number = seletedItem.y + seletedItem.height;
			var isDraggingDown:Number = (y0 > last_y_axis) ? 1 : -1;
			
			for (var i:int = 0; i < view.thumbContainer.numChildren; i++){
				var item:Object = view.thumbContainer.getChildAt(i);
				if (item != seletedItem ){
					
					var center:Number = item.y + item.height/2;
					
					if (y0 < center && y1 > center)
						if (item.y == item.oy)
							item.y = item.oy - (item.height + MARGIN_BOTTOM) * isDraggingDown;
						else
							item.y = item.oy;
				}
			}
			last_y_axis = seletedItem.y;			
		}
		
		
		
		public function FacebookSelectedImageNavigationMediator()
		{
			super();
		}
	}
}