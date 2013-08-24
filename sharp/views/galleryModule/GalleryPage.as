package sharp.views.galleryModule
{
	import cfm.core.events.CFM_DropdownMenuEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.loaders.CFM_XMLLoader;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.events.Event;
	
	import mx.events.DropdownEvent;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.customizeModule.customizeNavigation.CustomizeDropdownMenu;
	import sharp.views.galleryModule.navigation.GalleryFilterDropdownMenu;
	import sharp.views.galleryModule.navigation.GalleryNavigation;
	import sharp.views.galleryModule.navigation.PaginationNavigation;
	import sharp.views.windows.gallery.GalleryWindow;
	
	public class GalleryPage extends SharpPageTemplate
	{
		private var galleryNav						:SharpNavigationTemplate;
		private var galleryShadeUp					:GalleryShade;
		private var galleryShadeDown				:GalleryShade;
		private var filterDropdown					:CustomizeDropdownMenu;
		private var paginationNav					:PaginationNavigation;
		private var label							:CFM_TextField;
		private var filterXMLLoader					:CFM_XMLLoader;
		private var _totalPage						:String;
		private var _noImageText					:CFM_TextField;
		
		// =================================================
		// ================ Callable
		// =================================================

		override protected function build():void{
			super.build();

			buildShades();
			buildPagination();
			buildLabel();
			buildFilterDropdown();
			buildNoImageText();
			
			heading.alpha = 0;
			heading.visible = false;
			heading.x = Vo.MARGIN_LEFT - 5;
			TweenMax.to(heading, .5, {autoAlpha:1, x:Vo.MARGIN_LEFT - 5, ease:Cubic.easeOut});
		}
		
		override protected function buildNavigation():void{
			super.buildNavigation();
			pageNavigation.scaleX = pageNavigation.scaleY = Vo.SMALL_PAGE_NAV_SCALE;
			pageNavigation.setProperties({x:stage.stageWidth - pageNavigation.width, y:heading.y + heading.height + 12});
			pageNavigation.alpha = 0;
			pageNavigation.visible = false;
		}
		
		public function getFilterXML(_route:String):void{
			filterXMLLoader = new CFM_XMLLoader(_route, onFilterXMLComplete, onFilterXMLProgress);
		}

		public function updateGallery(_data:XML):void{
			galleryNav = new GalleryNavigation(_data.images.item,false,false,null,true,true,800);
			galleryNav.renderTo(_content, 0);
			galleryNav.setProperties({x:Vo.MARGIN_LEFT, y:galleryShadeUp.y + galleryShadeUp.height});
			galleryNav.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, galleryClicked);
			GalleryNavigation(galleryNav).showButton();
			hideNoImageText();
		}
		public function removeGallery():void{
			if(galleryNav) galleryNav.remove();	
		}
		// =================================================
		// ================ Create and Build
		// =================================================

		
		private function buildShades():void{
			galleryShadeUp = new GalleryShade();
			_content.addChild(galleryShadeUp);
			
			galleryShadeDown = new GalleryShade();
			_content.addChild(galleryShadeDown);	
			
			galleryShadeUp.y = 170;
			galleryShadeDown.y = 965;
		}
		
		private function buildPagination():void{
			paginationNav = new PaginationNavigation(xml.pagination[0].navigation.button);
			paginationNav.renderTo(_content);
			paginationNav.x = ((stage.stageWidth - paginationNav.width)*.5)-35;
			paginationNav.y = 980;
			//paginationNav.y = 80;
		}
		
		private function buildLabel():void{
			label = new CFM_TextField("FILTER BY:", labelParams);
			label.renderTo(this);
			label.setProperties({x:heading.x + 5, y:pageNavigation.y + 15});
		}

		private function buildFilterDropdown():void{
			filterDropdown = new GalleryFilterDropdownMenu("list",0,"filter","filter","Filter",xml.selection.navigation);
			filterDropdown.renderTo(_content);
			filterDropdown.setProperties({x:label.x + label.width + 17, y:pageNavigation.y});
			filterDropdown.visible = false;
			filterDropdown.alpha = 0;
		}
		
		private function buildNoImageText():void{
			_noImageText = new CFM_TextField("No image uploaded yet.", noImageTextParams);
			_noImageText.renderTo(_content);
			_noImageText.setProperties({x:(stage.stageWidth - _noImageText.width)*.5, y:500});
			_noImageText.visible = false;
			_noImageText.alpha = 0;
		}

		// =================================================
		// ================ Workers
		// =================================================
		private function showNoImageText():void{
			TweenMax.to(_noImageText, .2, {autoAlpha:1});
		}
		
		private function hideNoImageText():void{
			TweenMax.to(_noImageText, .2, {autoAlpha:0});
		}


		// =================================================
		// ================ Handlers
		// =================================================
		private function galleryClicked(e:CFM_NavigationEvent):void{
			dispatchEvent(new SharpNavigationEvent(SharpNavigationEvent.GALLERY_CLICKED,e.index,e.id));
		}
		private function onFilterXMLProgress(_percent:Number):void{
			
		}
		private function onFilterXMLComplete(_xml:XML):void{
			
			TweenMax.to(pageNavigation, .3, {autoAlpha:1});
			TweenMax.to(filterDropdown, .3, {autoAlpha:1});

			if(_xml){
				updateGallery(_xml);
				totalPage = _xml.images.@total_pages;
				if(totalPage == "0") showNoImageText();
				paginationNav.currentPageNumber = 0;
				paginationNav.totalPageNumber = Number(totalPage);
				paginationNav.update(0);
				paginationNav.x = ((stage.stageWidth - paginationNav.width)*.5)-35;
				dispatchEvent(new Event(Event.COMPLETE));
			}	
		}
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		private function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.font = Vo.FONT_MEDIUM;
			p.size = 16;
			return p;
		}
		
		private function get noImageTextParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.font = Vo.FONT_MEDIUM;
			p.size = 14;
			return p;
		}
		
		public function set totalPage(value:String):void
		{
			_totalPage = value;
		}
		
		public function get totalPage():String{
			return _totalPage;
		}

		// =================================================
		// ================ Core Handler
		// =================================================

		// =================================================
		// ================ Overrides
		// =================================================

		// =================================================
		// ================ Constructor
		// =================================================

		public function GalleryPage(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
		}
	}
}