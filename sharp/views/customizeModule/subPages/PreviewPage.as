package sharp.views.customizeModule.subPages
{
	import cfm.core.ui.CFM_DropdownMenu;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.customizeModule.customizeNavigation.CustomizeDropdownMenu;
	import sharp.views.customizeModule.customizeNavigation.buttons.ToolTipView;
	
	public class PreviewPage extends SharpPageTemplate
	{
		private var previewDropdownArray		:Array;
		private var dropdownButton 				:CustomizeDropdownMenu;
		private var tooltip						:ToolTipView;
		// =================================================
		// ================ Callable
		// =================================================
		public function showTooltip():void{
			tooltip.showTooltip();
		}
		public function hideTooltip():void{
			tooltip.hideTooltip();
		}
		public function showPreviewDropdown():void{
			heading.alpha = 0;
			heading.visible = false;
			heading.x = -50;
			TweenMax.to(heading, .5, {delay:.1, autoAlpha:1, x:Vo.MARGIN_LEFT - 5, ease:Cubic.easeOut});
			
			for (var j:String in previewDropdownArray){
				previewDropdownArray[j].x = previewDropdownArray[j].x - 30;
				TweenMax.to(previewDropdownArray[j], .3, {autoAlpha:1, x:previewDropdownArray[j].x + 30, delay:.2 + int(j)*.1, ease:Cubic.easeOut});
			}
			
		}
		
		public function closePreviewDropdown():void{
			for (var i:String in previewDropdownArray){
				if((previewDropdownArray[i] as CustomizeDropdownMenu).menuOpen) (previewDropdownArray[i] as CustomizeDropdownMenu).closeMenu();
			}
			
		}
		
		public function hidePreviewDropdown():void{
			for (var i:String in previewDropdownArray){
				TweenMax.to(previewDropdownArray[i], .3, {autoAlpha:0, delay:int(i)*.1});
			}
		}
		
		public function checkMenuOpen(_index:int):void{
			for (var j:String in previewDropdownArray){
				if(int(j) != _index) {
					if((previewDropdownArray[j] as CustomizeDropdownMenu).menuOpen) 
						(previewDropdownArray[j] as CustomizeDropdownMenu).closeMenu();
				}
			}
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			
			heading.y = heading.y + 10;
			buildPreviewDropdownNavigation();
			
			pageNavigation.scaleX = pageNavigation.scaleY = Vo.LARGE_PAGE_NAV_SCALE;
			pageNavigation.setProperties({x:(stage.stageWidth - pageNavigation.width) - 101, y:Vo.PAGE_NAVIGATION_Y_TOP});
			
			for (var j:int = 0; j<previewDropdownArray.length; j++){
				if(j>0) previewDropdownArray[j].x = previewDropdownArray[j-1].x + CFM_DropdownMenu(previewDropdownArray[j-1]).buttonWidth + Vo.MENU_BUTTON_SPACING;	
			}
			
			buildEmailTooltip();
		}
		
		private function buildPreviewDropdownNavigation():void{
			
			var i:Number = 0;
			previewDropdownArray = new Array();
			for each(var selectionItem:XML in xml.selection){
				if(selectionItem.@type == "input"){
					dropdownButton = new CustomizeDropdownMenu(selectionItem.@type, i,selectionItem.@id,selectionItem.@id,selectionItem.@heading,XMLList(selectionItem));
				}
				dropdownButton.x = Vo.MARGIN_LEFT;
				dropdownButton.y = Vo.DROPDOWN_MENU_Y - 10;
				dropdownButton.renderTo(_content);
				dropdownButton.visible = false;
				dropdownButton.alpha = 0;
				previewDropdownArray.push(dropdownButton);
				i++;
			}
		}
		
		public function buildEmailTooltip():void{
			
			tooltip = new ToolTipView(xml.tooltip, 250, 55);
			tooltip.renderTo(_content);
			var lastIndex:int = previewDropdownArray.length - 1;
			tooltip.x = previewDropdownArray[lastIndex].x + (CFM_DropdownMenu(previewDropdownArray[lastIndex]).buttonWidth - tooltip.width)*.5 + 15;
			tooltip.y = previewDropdownArray[lastIndex].y - tooltip.height - 8;
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
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function PreviewPage(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
		}
	}
}