package sharp.views.themeModule
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.text.CFM_TextField;
	import cfm.core.ui.CFM_DropdownMenu;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.themeModule.carouselNavigation.ArrowNavigation;
	import sharp.views.themeModule.carouselNavigation.CarouselView;
	import sharp.views.themeModule.dropdownNavigation.DropdownMenu;
	import sharp.views.themeModule.dropdownNavigation.buttons.StepIcon;
	
	public class ThemePage extends SharpPageTemplate
	{
		private static const MARGIN_LEFT						:Number = 20;
		private static const DROPDOWN_TOP_Y						:Number = 60;
		private static const TITLE_X_GAP						:Number = 50;
		private static const STEP_TITLE_GAP						:Number = 7;
		private static const TITLE_DROPDOWN_GAP					:Number = 8;
		private static const DROPDOWN_X_SPACING					:Number = 232;
		private static const CAROUSEL_ARROW_GAP					:Number = -80;
		private static const CONTENT_Y							:Number = 45;
		
		private var stepIcon									:StepIcon;
		private var selectionTitle								:CFM_TextField;
		private var dropdown									:DropdownMenu;
		private var dropdownArray								:Array;
		private var carouselContainer							:CFM_ObjectContainer;
		private var tvSelectionContainer						:CFM_ObjectContainer;
		private var colorSelectionContainer						:CFM_ObjectContainer;
		private var carouselView								:CarouselView;
		private var arrowNav									:ArrowNavigation;

		// =================================================
		// ================ Callable
		// =================================================
		public function positionAssets():void{
			carouselContainer.setProperties({x:MARGIN_LEFT, y:DROPDOWN_TOP_Y});
			var dropdownY:Number = carouselContainer.y + carouselContainer.height - 10;
			tvSelectionContainer.setProperties({x:MARGIN_LEFT, y:dropdownY});
			colorSelectionContainer.setProperties({x:tvSelectionContainer.x + tvSelectionContainer.width + TITLE_X_GAP, y:tvSelectionContainer.y});
			
			var pageNavigationX:Number = (stage.stageWidth - pageNavigation.width)*.5 - 32;
			var pageNavigationY:Number = Vo.PAGE_NAVIGATION_Y_DOWN;
			pageNavigation.scaleX = pageNavigation.scaleY = Vo.LARGE_PAGE_NAV_SCALE;
			pageNavigation.setProperties({x:pageNavigationX, y:pageNavigationY});	
		}
		
		public function checkDropdownOpen(_index:int):void{
			for (var i:String in dropdownArray){
				if(int(i)+1 != _index) 
					(dropdownArray[i] as DropdownMenu).closeMenu();
				
			}
		}
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			buildContainers();
			buildDropdowns();
			buildCarousel();	
		}
		
		private function buildContainers():void{
			carouselContainer = new CFM_ObjectContainer();
			carouselContainer.renderTo(_content);
			
			tvSelectionContainer = new CFM_ObjectContainer();
			tvSelectionContainer.renderTo(_content);

			colorSelectionContainer = new CFM_ObjectContainer();
			colorSelectionContainer.renderTo(_content);

		}
		
		private function buildDropdowns():void{
			var i:Number = 0;
			dropdownArray = new Array();
			
			for each(var selectionItem:XML in xml.selection){
				
				var titleTxt:String = selectionItem.heading;
				
				selectionTitle = new CFM_TextField(titleTxt.toUpperCase(), selectionTitleParams);
				
				switch(i){
					case 0:
						stepIcon = new StepIcon("1");
						stepIcon.renderTo(carouselContainer);
						selectionTitle.renderTo(carouselContainer);
						stepIcon.x = MARGIN_LEFT;
						break;
					case 1:
						Out.info(this, selectionItem.navigation.@type);
						stepIcon = new StepIcon("2");
						stepIcon.x = MARGIN_LEFT;
						stepIcon.renderTo(tvSelectionContainer);
						dropdown = new DropdownMenu(selectionItem.navigation.@type,i,selectionItem.@id,selectionItem.@id,selectionItem.@heading,selectionItem.navigation);
						dropdown.renderTo(tvSelectionContainer);
						selectionTitle.renderTo(tvSelectionContainer);
						dropdown.x = stepIcon.x;
						break;
					case 2:
					case 3:
						stepIcon = new StepIcon("3");
						stepIcon.renderTo(colorSelectionContainer);
						stepIcon.x = MARGIN_LEFT;
						dropdown = new DropdownMenu(xml.colors.navigation.@type,i,selectionItem.@id,selectionItem.@id,selectionItem.@heading,xml.colors.navigation);
						dropdown.renderTo(colorSelectionContainer);
						selectionTitle.renderTo(colorSelectionContainer);
						dropdown.x = stepIcon.x;
						if(i == 3) dropdown.x = DROPDOWN_X_SPACING;
						
					    break;
				
				}
				if(dropdown){
					dropdown.scaleX = dropdown.scaleY = .95;
					dropdown.y = CONTENT_Y;
					dropdownArray.push(dropdown);
				}
				selectionTitle.x = stepIcon.x + stepIcon.width + STEP_TITLE_GAP;
				selectionTitle.y = stepIcon.y + 5;
				
				i++;
			}
			
		}
		
		private function buildCarousel():void{	
			var carouselXML:XMLList = xml.selection.(@type == "carousel").navigation;
			carouselView = new CarouselView(0,carouselXML.(@id == "carousel_photo")[0], null);
			carouselView.renderTo(carouselContainer);
			carouselView.x = -17;
			carouselView.y = CONTENT_Y - 13;
				
			arrowNav = new ArrowNavigation(carouselXML.(@id == "carousel_arrow").button,false,false);
			arrowNav.renderTo(carouselContainer);
			arrowNav.setProperties({x:carouselView.x + (carouselView.width - arrowNav.width)*.5 - 5, y:carouselView.y + carouselView.height + CAROUSEL_ARROW_GAP});
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		private function get selectionTitleParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = 0x000000;
			p.font = Vo.FONT_BOLD;
			p.size = 18;
			return p;
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
		public function ThemePage(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
		}
	}
}