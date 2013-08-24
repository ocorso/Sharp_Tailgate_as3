package cfm.core.factories
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.events.CFM_PageEvent;
	import cfm.core.templates.CFM_PageTemplate;
	
	import flash.events.EventDispatcher;
	
	public class CFM_PageFactory extends EventDispatcher
	{
		public var prevPage:CFM_PageTemplate;
		public var currPage:CFM_PageTemplate;
		
		public var currentPageId:String;
		protected var pageChanging:Boolean = false;
		protected var pageWaiting:String = "";
		
		protected var pageContainer:CFM_ObjectContainer;
		protected var pageList:XMLList;
		
		public function CFM_PageFactory(_pageContainer:CFM_ObjectContainer, _pageList:XMLList)
		{
			pageList = _pageList;
			pageContainer = _pageContainer;
		}
		
		private function removeCurrentPageComplete(e:CFM_PageEvent):void{
			if(prevPage.hasEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE)){
				prevPage.removeEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, removeCurrentPageComplete);
			}
				
			prevPage.remove();
			removePageListeners(prevPage);
			
			prevPage = null;
			currPage = null;
		}
		
		private function transitionOutComplete(e:CFM_PageEvent):void{
			var page:CFM_PageTemplate = e.currentTarget as CFM_PageTemplate;
			
			page.removeEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, transitionOutComplete);
			page.addEventListener(CFM_PageEvent.DESTROY_COMPLETE, destroyPageComplete);
			page.remove();
		}
		
		private function destroyPageComplete(e:CFM_PageEvent):void{
			var page:CFM_PageTemplate = e.currentTarget as CFM_PageTemplate;
			
			removePageListeners(page);
			
			page = null;
		}
		
		protected function newPage(_params:Object = null):void{		
			var pxml:XML = pageList.(@id == currentPageId)[0];
			var index:Number = pxml.childIndex();
			
			currPage = getPage(index, pxml, _params);
			currPage.addEventListener(CFM_PageEvent.TRANSITION_IN_COMPLETE, buildPageComplete, false, 0, true);
			currPage.renderTo(pageContainer);
		}
		
		private function buildPageComplete(e:CFM_PageEvent):void{
			currPage.removeEventListener(CFM_PageEvent.TRANSITION_IN_COMPLETE, buildPageComplete);
			pageChanging = false;
			
			if(pageWaiting != ""){
				changePage(pageWaiting);
				pageWaiting = "";
			}
			
			addPageListeners(currPage);
		}
		
		private function onCloseClicked(e:CFM_PageEvent):void{
			dispatchEvent(new CFM_PageEvent(e.type,e.id, e.params));
			removeCurrentPage(true);
		}
		
		/**
		 * Override to pass a custom page. Must extend <CFM_PageTempate> 
		 * @param _index
		 * @param _pxml
		 * @param _params
		 * @return 
		 * 
		 */		
		protected function getPage(_index:Number, _pxml:XML, _params:Object):CFM_PageTemplate{
			return new CFM_PageTemplate(_index, _pxml, _params);
		}
		
		/**
		 * Override to add custom listeners to each page 
		 * 
		 */		
		protected function addPageListeners(_page:CFM_PageTemplate):void{
			_page.addEventListener(CFM_PageEvent.CLOSE_CLICKED, onCloseClicked, false, 0, true);
			_page.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onPageNavigationClicked, false, 0, true);
		}
		
		/**
		 * Override to add remove your custom listeners
		 *
		 */	
		protected function removePageListeners(_page:CFM_PageTemplate):void{
			if(_page.hasEventListener(CFM_PageEvent.CLOSE_CLICKED))
				_page.removeEventListener(CFM_PageEvent.CLOSE_CLICKED, onCloseClicked);
			
			if(_page.hasEventListener(CFM_NavigationEvent.BUTTON_CLICKED))
				_page.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onPageNavigationClicked);
		}
		
		public function removeCurrentPage(_tween:Boolean = true):void{
			if(currPage){
				prevPage = currPage;
				
				if(_tween){
					prevPage.addEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, removeCurrentPageComplete);
					prevPage.transitionOut(null);
				} else {
					removeCurrentPageComplete(null);
				}
			}
		}
		
		public function changePage(_id:String, _params:Object = null):void{
			if(pageChanging){
				pageWaiting = _id; 
				return;
			}
			
			if(currPage && currPage.id == _id){
				return;
			}
			
			pageChanging = true;
			currentPageId = _id;
			
			if(currPage){
				prevPage = currPage;
				prevPage.addEventListener(CFM_PageEvent.TRANSITION_OUT_COMPLETE, transitionOutComplete);
				prevPage.transitionOut(_params);
				
				newPage(_params);
			} else {
				newPage(_params);
			}
		}
		
		public function nextPage():void{
			var newIndex:Number = currPage ? (currPage.index+1) : 0;
			if (newIndex > pageList.length()-1) newIndex = pageList.length()-1;
			
			changePage(pageList[newIndex].@id);
		}
		
		public function previousPage():void{
			var newIndex:Number = currPage.index-1;
			if (newIndex < 0) newIndex = 0;
			
			changePage(pageList[newIndex].@id);
		}
		
		public function updateList(_list:XMLList, _removePage:Boolean = false):void{
			pageList = _list;
			if(_removePage) removeCurrentPage();
		}
		
		public function initCurrentPageContent():void{
			try{
				currPage.initContent();
			} catch(e:Error){
				//	trace(e);
			}
		}
		
		protected function onPageNavigationClicked(e:CFM_NavigationEvent):void{
			dispatchEvent(new CFM_NavigationEvent(e.type, e.index, e.id, e.value));
		}
	}
}