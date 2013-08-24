package sharp.views.customizeModule.customizeNavigation
{
	import cfm.core.events.CFM_DropdownMenuEvent;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.SharpDropdownEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.utils.ValidationUtils;
	import sharp.views.appMainButton.CustomizeSmallerButton;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeInputNavigation;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	
	public class CustomizeDropdownMediator extends Mediator
	{
		[Inject]
		public var view:CustomizeDropdownMenu;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			view.imageUrl = _m.imageUrl;
			
			eventMap.mapListener(view, CFM_DropdownMenuEvent.OPEN_MENU, onOpenMenu, null, false, 0, true);
			eventMap.mapListener(view, CFM_DropdownMenuEvent.CLOSE_MENU, onCloseMenu, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.OK_SELECTED, onOKSelectedMenu, null, false, 0, true);
			eventMap.mapListener(view, SharpDropdownEvent.ON_CLOSE_MENU, onOKSelectedMenu, null, false, 0, true);
			eventMap.mapListener(view, CFM_DropdownMenuEvent.ITEM_SELECTED, onItemSelected, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.OPEN_MENU, onOpenMenu);
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.CLOSE_MENU, onCloseMenu);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.OK_SELECTED, onOKSelectedMenu);
			eventMap.unmapListener(view, SharpDropdownEvent.ON_CLOSE_MENU, onOKSelectedMenu);
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.ITEM_SELECTED, onItemSelected);
		}
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		private function closeMenu(_type:String):void{
			view.hideMenu();
			(view.button as CustomizeSmallerButton).dropdownClose();
			
			if(_type == SharpDropdownEvent.OK_SELECTED){
				if(view.menuOpen) view.closeMenu(false);
			}
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		private function onCloseMenu(e:CFM_DropdownMenuEvent):void{
			view.hideMenu();
			(view.button as CustomizeSmallerButton).dropdownClose();
		}

		private function onOKSelectedMenu(e:SharpDropdownEvent):void{
			
			if(view.navigation is CustomizeInputNavigation)
				var isInput:Boolean = true
			else
				isInput = false;

			switch(e.menuValue){
				case "personalization":
					
					if(isInput && CustomizeInputNavigation(view.navigation).id == e.menuValue){
						closeMenu(e.type);
						
						if(e.itemValue!="")
							Vo.customizeParams.teamName = e.itemValue;
						else
							Vo.customizeParams.teamName = Vo.DEFAULT_TEAM_NAME;

						CustomizeInputNavigation(view.navigation).updateInputText(Vo.customizeParams.teamName);

						dispatch(new SharpDropdownEvent(SharpDropdownEvent.TEAMNAME_OK_SELECTED, e.menuIndex, e.menuValue, e.itemIndex, e.itemValue));
						dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
						_m.ga.trackInputOkDropdown(view.menuIndex, XMLList(_m.currentPageData));
					}
					
					
					break;
				case "name_your_tailgate":
					
					if(isInput && CustomizeInputNavigation(view.navigation).id == e.menuValue){
						closeMenu(e.type);
						
						if(e.itemValue!="")
							Vo.customizeParams.tailgateName = e.itemValue;
						else
							Vo.customizeParams.tailgateName = Vo.DEFAULT_TAILGATE_NAME;

						CustomizeInputNavigation(view.navigation).updateInputText(Vo.customizeParams.tailgateName);
						dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
						
						_m.ga.trackInputOkDropdown(view.menuIndex, XMLList(_m.currentPageData.preview));
					}
					
					
					break;
				case "enter_video":
					// Check if Okay pressed
					if(e.type == SharpDropdownEvent.OK_SELECTED){
						
						// Check if Youtube Video link textarea is not empty
						if(isInput && CustomizeInputNavigation(view.navigation).id == e.menuValue){
							
							//Check if navigation has thumbnail and avoid youtube video 
							var nav:CustomizeInputNavigation = (view.navigation as CustomizeInputNavigation);
							if (!nav.photoThumbnail){
								// Check itemValue (youtube link) is emptly, replace it w/ a default url
								if(e.itemValue!="")
									Vo.youtube.videoUrl = e.itemValue;
								else
									Vo.youtube.videoUrl = Vo.DEFAULT_YOUTUBE_URL;	
								CustomizeInputNavigation(view.navigation).updateInputText(Vo.youtube.videoUrl);	
								
								dispatch(new YoutubeEvent(YoutubeEvent.SAVE_VIDEO_ID, Vo.youtube));
								
								//Check if Youtube link is valid
								if(_m.youtube.valid){
									closeMenu(e.type);
									dispatch(new YoutubeEvent(YoutubeEvent.GET_VIDEO_ID, Vo.youtube));
									_m.ga.trackInputOkDropdown(view.menuIndex, XMLList(_m.currentPageData.preview));
								}else{
									if(isInput && CustomizeInputNavigation(view.navigation).id == e.menuValue)
										CustomizeInputNavigation(view.navigation).showInvalidText();
								}
							}
							else
								closeMenu(e.type);
						}
					}
					
					break;
				
					case "enter_email":
						if(isInput && CustomizeInputNavigation(view.navigation).id == e.menuValue){
							
							_m.hasEmail = ValidationUtils.validateEmail(e.itemValue);
							
							if(_m.hasEmail){
								closeMenu(e.type);
								
								if(e.itemValue!="")
									Vo.customizeParams.userEmail = e.itemValue;
								else
									Vo.customizeParams.tailgateName = Vo.DEFAULT_TAILGATE_NAME;
								
								CustomizeInputNavigation(view.navigation).updateInputText(Vo.customizeParams.userEmail);
								dispatch(new SharpDropdownEvent(SharpDropdownEvent.EMAIL_OK_SELECTED, e.menuIndex, e.menuValue, e.itemIndex, e.itemValue));
								dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
								
								_m.ga.trackInputOkDropdown(view.menuIndex, XMLList(_m.currentPageData.preview));

							}else{
								CustomizeInputNavigation(view.navigation).showEmailInvalidText();
							}
						}
					
					break;

			}

		}
		private function onOpenMenu(e:CFM_DropdownMenuEvent):void{
			view.showMenu();
			(view.button as CustomizeSmallerButton).dropdownOpen();
			
			dispatch(new SharpDropdownEvent(SharpDropdownEvent.DROPDOWN_SELECTED, e.menuIndex,e.menuValue, e.itemIndex, e.itemValue));
			
			_m.ga.trackDropdown(_m.currentPageId, e.menuValue);
		}
		
		private function onItemSelected(e:CFM_DropdownMenuEvent):void{
	
			if(e.menuValue != "personalization"){
				Vo.customizeParams.paramsIndex = e.menuIndex;
				Vo.customizeParams.paramsId = _m.customizeNavigationId(e.menuIndex);
				Vo.customizeParams.itemId = _m.customizeButtonId(e.menuIndex, e.itemIndex);	
				
				Vo.customizeParams.itemImageURL = _m.imageUrl + Vo.customizeParams.paramsId + "/" + Vo.customizeParams.itemId + ".png";
				Out.info(this, Vo.customizeParams.itemId);
				
				Vo.customizeParams.itemColorType = _m.customizeItemColor(e.menuIndex, e.itemIndex);	
				dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams)); 
				
				view.closeMenu();
				view.hideMenu();
				(view.button as CustomizeSmallerButton).centerLabel();
				
				dispatch(new SharpDropdownEvent(SharpDropdownEvent.CUSTOMIZE_DROPDOWN_ITEM_SELECTED, e.menuIndex,e.menuValue, e.itemIndex, e.itemValue));
				_m.ga.trackItemDropdown(e.menuIndex, e.itemIndex, XMLList(_m.currentPageData));
			}
			
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
		public function CustomizeDropdownMediator()
		{
			super();
		}
	}
}