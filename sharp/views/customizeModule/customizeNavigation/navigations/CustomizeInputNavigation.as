package sharp.views.customizeModule.customizeNavigation.navigations
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import mx.core.mx_internal;
	
	import net.ored.util.out.Out;
	
	import sharp.events.FacebookPhotoEvent;
	import sharp.events.SharpButtonEvent;
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.AppMainButton;
	import sharp.views.appMainButton.SimpleRedButton;
	import sharp.views.appMainNavigation.AppMainNavigation;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.customizeModule.customizeNavigation.buttons.FacebookChooseButton;
	import sharp.views.customizeModule.customizeNavigation.buttons.FacebookPhotoThumbnail;
	import sharp.views.customizeModule.customizeNavigation.buttons.YoutubeBrowseButton;
	import sharp.views.customizeModule.event.CustomizeEvent;
	import sharp.views.themeModule.dropdownNavigation.buttons.StepIcon;
	
	public class CustomizeInputNavigation extends SharpNavigationTemplate
	{
		public var roomItem						:String;
		private var buttonWidth					:Number;
		private var background					:Shape;
		private var headingField				:CFM_TextField;
		private var facebookHeadingField		:CFM_TextField;
		private var subHeadingField				:CFM_TextField;
		private var inputOutline				:Shape;
		private var inputField					:CFM_TextField;
		private var enterNav					:AppMainNavigation;
		private var _inputValue					:String;
		private var fbChooseBtn					:FacebookChooseButton;
		private var ytBrowseBtn					:YoutubeBrowseButton;
		private var fbClearBtn					:AppMainButton;
		private var divider						:Shape;
		private var orDivider					:OrDivider;
		private var youtubeHolder				:Sprite;
		private var stepField					:CFM_TextField;
		private var instructionField			:CFM_TextField;
		private var stepNum						:CFM_TextField;
		private var invalidText					:CFM_TextField;
		public  var photoThumbnail				:FacebookPhotoThumbnail;
		private var photoThumbnailContainer		:CFM_ObjectContainer;
		private var slideshowInstruction		:CFM_ObjectContainer;
		private var slideshowStep				:CFM_TextField;
		private var emailInvalidText			:CFM_TextField;
		
		private var INPUT_FIELD_TEXT			:String;
		private var FONT_SIZE					:Number;
		private var INPUT_FIELD_HEIGHT			:Number;
		private var INPUT_FIELD_WIDTH			:Number;
		private var INPUT_FIELD_Y				:Number;
		private var BACKGROUND_HEIGHT			:Number;
		private var FACEBOOK_Y					:Number;
		private var MAX_CHARS					:Number;
		private var BACKGROUND_WIDTH			:Number;
		private var INPUT_WIDTH					:Number;
		private var INPUT_MULTILINE				:Boolean;
		private var CLEAR_PHOTO_X				:Number;
		private var THUMBCONTAINER_Y			:Number;
		
		private const DEFAULT_FADE				:Number = .5;
		
		public var id 							:String;
		
		// =================================================
		// ================ Callable
		// =================================================

		public function showPhoto(_imageUrl:String):void{
			
			if(list.@facebook == "true" && list.@id == Vo.customizeParams.listId) {
				fbChooseBtn.alpha = 0;
				fbChooseBtn.visible = false;
				TweenMax.to(fbClearBtn, .3, {autoAlpha:1});
				
				//Hide youtube panel
				if (youtubeHolder) showYoutubePanel(false);
				
				//Create PhotoThumbnail
				switch(Vo.customizeParams.listId){
					case "personalization":
						facebookHeadingField.text = "Current photo:";
						buildPhotoThumbnail(_imageUrl);
						break;

					case "enter_video":
						facebookHeadingField.text = "Current slideshow:";
						TweenMax.to(slideshowInstruction, .3, {autoAlpha:0});
						buildPhotoThumbnail(_imageUrl, true);
						break;
				}
				
			}
		}
		
		public function showInvalidText():void{
			TweenMax.to(invalidText, .3, {autoAlpha:1});
		}
		
		public function hideInvalidText():void{
			TweenMax.to(invalidText, .3, {autoAlpha:0});
		}
		
		public function showEmailInvalidText():void{
			TweenMax.to(emailInvalidText, .3, {autoAlpha:1});
		}
		
		public function hideEmailInvalidText():void{
			TweenMax.to(emailInvalidText, .3, {autoAlpha:0});
		}
		
		public function updateInputText(_txt:String):void{
			inputField.text = _txt;
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================

		override protected function build():void{
			
			super.build();	
			if(list.@facebook == "true") {				
				buildFacebookDivider();
				buildFacebookHeadings();
				buildFacebookChooseButton();
				buildSlideshowStep();
				buildFacebookClearButton();
				buildPhotoThumbnailContainer();
			}
			
			//Check if this navigate has youtube
			var hasYoutube:Boolean = list.item.step.length() > 0;
			
			if (hasYoutube) {
				youtubeHolder = new Sprite();
				this.addChild( youtubeHolder );
			}
			
			buildBackground();
			buildHeadings();
			if(list.item.subHeading.length() > 0) buildSubHeadings();
			buildInputField();
			buildEnterNav();
			positionAssets();
			
			// Create additional youtube panel
			if(hasYoutube) {
				buildYoutubeBrowseButton();
				buildYoutubeSteps();
				buildInvalidWarning();
			}
			
			if(id == "enter_email") buildEmailInvalidWarning();
		}
		
		override protected function buildButtons():void{
			
		}
		
		private function buildBackground():void{
			background = new Shape();
			background.graphics.lineStyle(1, 0xcdcdcd);
			background.graphics.beginFill(0xffffff);
			background.graphics.moveTo(0,0);
			background.graphics.lineTo(0,BACKGROUND_HEIGHT + Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(BACKGROUND_WIDTH,BACKGROUND_HEIGHT + Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(BACKGROUND_WIDTH,Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(buttonWidth,Vo.DROPDOWN_NECK_HEIGH);
			background.graphics.lineTo(buttonWidth,0);
			background.graphics.lineTo(0,0);
			this.addChildAt(background,0);
		}
		
		private function buildHeadings():void{
			var headingTxt:String = list.item.heading;
			headingField = new CFM_TextField(headingTxt, headingParams);
			headingField.renderTo( (youtubeHolder == null) ? this : youtubeHolder );
			headingField.x = Vo.DROPDOWN_PADDING;
			headingField.y = Vo.DROPDOWN_PADDING;
		}
		
		private function buildFacebookDivider():void{
			if(list.@id == "enter_video"){
				orDivider = new OrDivider();
				this.addChild(orDivider);
				orDivider.x = (BACKGROUND_WIDTH - orDivider.width)*.5;
				orDivider.y = FACEBOOK_Y - 34;
			}else{
				divider = new Shape();
				divider.graphics.lineStyle(1, Vo.GRAY_STROKE);
				divider.graphics.moveTo(0,0);
				divider.graphics.lineTo(BACKGROUND_WIDTH - (Vo.DROPDOWN_PADDING*2),0);
				this.addChild(divider);
				divider.x = (BACKGROUND_WIDTH - divider.width)*.5;
				divider.y = FACEBOOK_Y - 20;
			}
			
		}
		
		private function buildFacebookHeadings():void{
			var headingTxt:String = list.item.facebookHeading;
			facebookHeadingField = new CFM_TextField(headingTxt.replace("*", roomItem), headingParams);
			facebookHeadingField.renderTo(this);
			facebookHeadingField.x = Vo.DROPDOWN_PADDING;
			facebookHeadingField.y = FACEBOOK_Y;
		}

		private function buildSubHeadings():void{
			var subHeadingTxt:String = list.item.subHeading;
			subHeadingField = new CFM_TextField(subHeadingTxt, subHeadingParams);
			subHeadingField.renderTo(this);
			
			subHeadingField.x = Vo.DROPDOWN_PADDING;
			subHeadingField.y = headingField.y + headingField.height + 5;
		}
		
		
		private function buildInputField():void{
			inputOutline = new Shape();
			inputOutline.graphics.lineStyle(1, Vo.GRAY_STROKE);
			inputOutline.graphics.moveTo(0,0);
			inputOutline.graphics.lineTo(0,INPUT_FIELD_HEIGHT);
			inputOutline.graphics.lineTo(INPUT_FIELD_WIDTH,INPUT_FIELD_HEIGHT);
			inputOutline.graphics.lineTo(INPUT_FIELD_WIDTH,0);
			inputOutline.graphics.lineTo(0,0);
			( (youtubeHolder == null) ? this : youtubeHolder ).addChild(inputOutline);
			
			inputField = new CFM_TextField(INPUT_FIELD_TEXT, inputParams);
			inputField.renderTo( (youtubeHolder == null) ? this : youtubeHolder );
			inputField.alpha = DEFAULT_FADE;
		}
		

		private function buildSlideshowStep():void{

			slideshowInstruction = new CFM_ObjectContainer();
			slideshowInstruction.renderTo(this);
			
			slideshowInstruction.x = Vo.DROPDOWN_PADDING;
			slideshowInstruction.y = fbChooseBtn.y + fbChooseBtn.height + 15;
			
			instructionField = new CFM_TextField(list.item.instruction, instructionParams);
			instructionField.renderTo( slideshowInstruction );

			var stepArray:Array = new Array();
			var stepNumArray:Array = new Array();
			for(var i:int = 0; i<list.item.slideshowStep.length(); i++){	
				stepNum = new CFM_TextField(String(i+1) + ".", stepNumParams);
				stepNum.renderTo( slideshowInstruction );
				stepNumArray.push(stepNum);
				
				slideshowStep = new CFM_TextField(list.item.slideshowStep[i], stepParams);
				slideshowStep.renderTo( slideshowInstruction );
				slideshowStep.x = stepNum.width + 2;
				slideshowStep.y = instructionField.y + instructionField.height + 2
				stepArray.push(slideshowStep);
			}
			
			for(var j:int = 0; j<stepArray.length; j++){
				if(j>0) stepArray[j].y = stepArray[j-1].y + stepArray[j-1].height;
				stepNumArray[j].y = stepArray[j].y - 2;
			}
		}
		
		private function buildFacebookChooseButton():void{
			var buttonList:XMLList = list.item.navigation.button.(@value == "choose_photo");
			fbChooseBtn = new FacebookChooseButton(0,buttonList.@id, buttonList.@value, buttonList.label,6,-5,false,false);
			fbChooseBtn.renderTo(this);
			
			fbChooseBtn.x = Vo.DROPDOWN_PADDING + 2;
			fbChooseBtn.y = facebookHeadingField.y + facebookHeadingField.height + 15;	
		}
		
		private function buildFacebookClearButton():void{
			var buttonList:XMLList = list.item.navigation.button.(@value == "clear_photo");
			fbClearBtn = new AppMainButton(0,buttonList.@id, buttonList.@value, buttonList.label, 16, 7, false,false);
			fbClearBtn.scaleX = fbClearBtn.scaleY = Vo.SMALL_PAGE_NAV_SCALE;
			fbClearBtn.renderTo(this);
			fbClearBtn.alpha = 0;
			fbClearBtn.visible = false;
			fbClearBtn.x = CLEAR_PHOTO_X;
			fbClearBtn.y = BACKGROUND_HEIGHT - Vo.DROPDOWN_PADDING - 18;
		}
		
		private function buildEnterNav():void{
			enterNav = new AppMainNavigation(list.navigation.button,false,false);
			enterNav.renderTo(this);	
			enterNav.scaleX = enterNav.scaleY = Vo.SMALL_PAGE_NAV_SCALE;
		}
		private function buildYoutubeSteps():void{
			
			instructionField = new CFM_TextField(list.item.instruction, instructionParams);
			instructionField.renderTo( youtubeHolder );
			instructionField.x = Vo.DROPDOWN_PADDING;
			instructionField.y = inputOutline.y + inputOutline.height + 15;
			var stepArray:Array = new Array();
			var stepNumArray:Array = new Array();
			for(var i:int = 0; i<list.item.step.length(); i++){	
				stepNum = new CFM_TextField(String(i+1) + ".", stepNumParams);
				stepNum.renderTo( youtubeHolder );
				stepNum.x = Vo.DROPDOWN_PADDING;
				stepNumArray.push(stepNum);
				
				stepField = new CFM_TextField(list.item.step[i], stepParams);
				stepField.renderTo( youtubeHolder );
				stepField.x = Vo.DROPDOWN_PADDING + stepNum.width + 2;
				stepArray.push(stepField);
				
				stepField.y =  instructionField.y + instructionField.height + 5;
			}
			
			for(var j:int = 0; j<stepArray.length; j++){
				if(j>0) stepArray[j].y = stepArray[j-1].y + stepArray[j-1].height;
				stepNumArray[j].y = stepArray[j].y - 2;
			}
		}
		private function buildYoutubeBrowseButton():void{
			var buttonList:XMLList = list.item.button;
			ytBrowseBtn = new YoutubeBrowseButton(0,buttonList.@id, buttonList.@value, buttonList.label,6,5,false,false,buttonList.@href);
			ytBrowseBtn.renderTo( youtubeHolder );
			
			ytBrowseBtn.x = inputOutline.x + 10;
			ytBrowseBtn.y = inputOutline.y + (inputOutline.height - ytBrowseBtn.height)*.5;
			inputField.x = ytBrowseBtn.x + ytBrowseBtn.width + 8;
		}
		private function buildInvalidWarning():void{
			invalidText = new CFM_TextField(Vo.INVALID_TEXT, invalidParams);
			invalidText.renderTo( youtubeHolder );
			invalidText.x = inputOutline.x + inputOutline.width - invalidText.width + 3;
			invalidText.y = inputOutline.y + inputOutline.height + 5;
			invalidText.visible = false;
			invalidText.alpha = 0;
		}
		
		private function buildEmailInvalidWarning():void{
			emailInvalidText = new CFM_TextField(Vo.EMAIL_INVALID_TEXT, invalidParams);
			emailInvalidText.renderTo( this );
			emailInvalidText.x = inputOutline.x;
			emailInvalidText.y = inputOutline.y + inputOutline.height + 5;
			emailInvalidText.visible = false;
			emailInvalidText.alpha = 0;
		}
		
		private function buildPhotoThumbnailContainer():void{
			photoThumbnailContainer  = new CFM_ObjectContainer();
			photoThumbnailContainer.renderTo(this);
			photoThumbnailContainer.setProperties({x:(BACKGROUND_WIDTH - Vo.FACEBOOK_THUMB_WIDTH)*.5, y:facebookHeadingField.y + facebookHeadingField.height + THUMBCONTAINER_Y});
		}
		
		private function buildPhotoThumbnail(_imgUrl:String, slideshow:Boolean = false):void{
			
			photoThumbnail = new FacebookPhotoThumbnail(_imgUrl, slideshow);
			photoThumbnail.renderTo(photoThumbnailContainer);
			
		}
		// =================================================
		// ================ Workers
		// =================================================
		private function positionAssets():void{
			
			inputOutline.x = (BACKGROUND_WIDTH - inputOutline.width)*.5;
			inputOutline.y = (subHeadingField) ? subHeadingField.y + subHeadingField.height + 8 : headingField.y + headingField.height + 8;
			
			inputField.x = inputOutline.x + 5;
			inputField.y = inputOutline.y + INPUT_FIELD_Y;
			
			enterNav.x = BACKGROUND_WIDTH - enterNav.width - Vo.DROPDOWN_PADDING - 19;
			enterNav.y = BACKGROUND_HEIGHT - Vo.DROPDOWN_PADDING - 18;

		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		
		// =================================================
		// ================ Animation
		// =================================================
		
		private function showYoutubePanel(bool:Boolean):void{
			
			var isSlideshow:Boolean;
			
			if (bool){
				TweenMax.to(youtubeHolder, 0.4, {alpha:1, colorMatrixFilter:{amount:1}});
				isSlideshow = false;
			}else{
				TweenMax.to(youtubeHolder, 0.4, {alpha:.4, colorMatrixFilter:{colorize:0xffffff, amount:1}});	
				isSlideshow = true;
			}
			
			dispatchEvent(new CustomizeEvent(CustomizeEvent.CHECK_IS_SLIDESHOW, isSlideshow));
							
			youtubeHolder.mouseChildren = bool;
		}
		
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		private function get headingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = 0x222222;
			p.size = 16;
			p.font = Vo.FONT_MEDIUM;
			p.width = INPUT_FIELD_WIDTH;
			p.wordWrap = true;
			p.leading = 4;
			return p;
		}
		
		private function get subHeadingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = headingParams;
			p.color = Vo.RED;
			p.size = 15;
			return p;
		}
		
		private function get inputParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = headingParams;
			p.type = TextFieldType.INPUT;
			p.color = 0x333333;
			p.multiline = INPUT_MULTILINE;
			p.wordWrap = true;
			p.size = FONT_SIZE;
			p.maxChars = MAX_CHARS;
			p.width = INPUT_WIDTH;
			p.height = INPUT_FIELD_HEIGHT - 10;
			p.leading = 4;
			return p;
		}
		
		private function get stepNumParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = headingParams;
			p.size = 14;
			p.wordWrap = false;
			p.color = 0x333333;
			return p;
		}
		
		private function get stepParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = headingParams;
			p.size = 14;
			p.multiline = true;
			p.wordWrap = true;
			p.autoSize = TextFieldAutoSize.LEFT;
			p.width = 300;
			p.leading = 4;
			p.color = 0x333333;
			return p;
		}
		
		private function get instructionParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = stepParams;
			p.color = Vo.RED;
			p.size = 16;
			return p;
		}

		private function get invalidParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.RED;
			p.size = 12;
			p.font = Vo.FONT_MEDIUM;
			return p;
		}
		
		public function get inputValue():String
		{
			_inputValue = inputField.text;
			return _inputValue;
		}
		
		public function set inputValue(value:String):void
		{
			_inputValue = value;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		private function onYoutubeBrowseClicked(e:CFM_ButtonEvent):void{
			dispatchEvent(new SharpButtonEvent(SharpButtonEvent.YOUTUBE_BROWSE_CLICKED, e.id));
		}
		public function onNavClicked(e:CFM_NavigationEvent):void{
			dispatchEvent(new SharpDropdownEvent(SharpDropdownEvent.DROPDOWN_NAVIGATION_CLICKED,0,"",e.index,e.id));
		}
		private function onFacebookClicked(e:CFM_ButtonEvent):void{
			Vo.customizeParams.listId = list.@id;
			dispatchEvent(new SharpButtonEvent(SharpButtonEvent.FACEBOOK_CHOOSE_CLICKED, e.id));
		}
		private function onFieldChange(e:Event):void{
			
			if(id=="personalization" || id=="name_your_tailgate") inputField.text = inputField.text.toUpperCase();
			dispatchEvent(new CustomizeEvent(CustomizeEvent.INPUT_FIELD_CHANGE, false));
		}
		
		private function onFacebookClearClicked(e:CFM_ButtonEvent):void{
			
			//Show youtube panel
			if (youtubeHolder) showYoutubePanel(true);
			
			
			Vo.customizeParams.listId = list.@id;
//			TweenMax.allTo([photoBackground, photoPlaceholder, fbClearBtn], .3, {autoAlpha:0});

			TweenMax.to(fbClearBtn, .3, {autoAlpha:0});
			TweenMax.to(fbChooseBtn, .3, {autoAlpha:1});
			TweenMax.to(slideshowInstruction, .3, {autoAlpha:1});
			
			var headingTxt:String = list.item.facebookHeading;
			if(id == "personalization")
				facebookHeadingField.htmlText = headingTxt.replace("*", roomItem);
			else
				facebookHeadingField.htmlText = headingTxt;
			
			if(photoThumbnail)TweenMax.to(photoThumbnail, .2, {autoAlpha:0, onComplete:removePHotoThumbnail});
			
			dispatchEvent(new SharpButtonEvent(SharpButtonEvent.CLEAR_PHOTO_CLICKED, e.id));
		}
		
		private function removePHotoThumbnail():void{
			photoThumbnail.remove();
			photoThumbnail = null;
		}
		
		private function clearText(e:FocusEvent):void{
			if(invalidText) hideInvalidText();
			if(emailInvalidText) hideEmailInvalidText();
			if(inputField.text == INPUT_FIELD_TEXT) {
				inputField.text = "";
				inputField.alpha = 1;
			}
		}
		
		private function showText(e:FocusEvent):void{
			if(inputField.text == "") {
				inputField.text = INPUT_FIELD_TEXT;
				inputField.alpha = DEFAULT_FADE;
			}
		}
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function addListeners():void{
			super.addListeners();

			enterNav.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onNavClicked, false, 0, true);
			if(fbChooseBtn) fbChooseBtn.addEventListener(CFM_ButtonEvent.CLICKED, onFacebookClicked, false, 0, true);
			if(fbClearBtn) fbClearBtn.addEventListener(CFM_ButtonEvent.CLICKED, onFacebookClearClicked, false, 0, true);
			if(ytBrowseBtn) ytBrowseBtn.addEventListener(CFM_ButtonEvent.CLICKED, onYoutubeBrowseClicked, false, 0, true);
			inputField.addEventListener(Event.CHANGE, onFieldChange, false, 0, true);
			inputField.addEventListener(FocusEvent.FOCUS_IN, clearText, false, 0, true);
			inputField.addEventListener(FocusEvent.FOCUS_OUT, showText, false, 0, true);
		}
		
		override protected function removeListeners():void{
			super.removeListeners();
			enterNav.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onNavClicked);
			if(fbChooseBtn)fbChooseBtn.removeEventListener(CFM_ButtonEvent.CLICKED, onFacebookClicked);
			if(fbClearBtn) fbClearBtn.removeEventListener(CFM_ButtonEvent.CLICKED, onFacebookClearClicked);
			if(ytBrowseBtn) ytBrowseBtn.removeEventListener(CFM_ButtonEvent.CLICKED, onYoutubeBrowseClicked);
			inputField.removeEventListener(Event.CHANGE, onFieldChange);
			inputField.removeEventListener(FocusEvent.FOCUS_IN, clearText);
			inputField.removeEventListener(FocusEvent.FOCUS_OUT, showText);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function CustomizeInputNavigation(_buttonWidth:Number, _list:XMLList, _allowMultipleSelect:Boolean=false, _hasSelectedState:Boolean=true, _verticalAlign:String=null, _autoInit:Boolean=true, _autoDestroy:Boolean=true, _maxwidth:Number=0)
		{
			super(_list, _allowMultipleSelect, _hasSelectedState, _verticalAlign, _autoInit, _autoDestroy, _maxwidth);
			
			buttonWidth = _buttonWidth + Vo.BUTTON_SQUARE_SIZE;
			list = _list;
			id = list.@id;
			
			switch(String(list.@id)){
				case "personalization":
					INPUT_FIELD_TEXT = Vo.DEFAULT_TEAM_NAME;
					FONT_SIZE = 14;
					INPUT_WIDTH = 300;
					INPUT_FIELD_WIDTH = 310;
					INPUT_FIELD_HEIGHT = 40;
					INPUT_FIELD_Y = 12;
					BACKGROUND_HEIGHT = 340;
					BACKGROUND_WIDTH = 360;
					FACEBOOK_Y = 160;
					MAX_CHARS = 30;
					INPUT_MULTILINE = false;
					CLEAR_PHOTO_X = 110;
					THUMBCONTAINER_Y = -10;
					
					break;
				case "name_your_tailgate":
					INPUT_FIELD_TEXT = Vo.DEFAULT_TAILGATE_NAME;
					FONT_SIZE = 14;
					INPUT_WIDTH = 330;
					INPUT_FIELD_WIDTH = 340;
					INPUT_FIELD_HEIGHT = 40;
					INPUT_FIELD_Y = 12;
					BACKGROUND_HEIGHT = 150;
					BACKGROUND_WIDTH = 390;
					MAX_CHARS = 35;
					INPUT_MULTILINE = false;
					
					break;
				case "enter_video":
					INPUT_FIELD_TEXT = Vo.DEFAULT_YOUTUBE_URL;
					FONT_SIZE = 12;
					INPUT_WIDTH = 180;
					INPUT_FIELD_WIDTH = 310;
					INPUT_FIELD_HEIGHT = 60;
					INPUT_FIELD_Y = 7;
					BACKGROUND_HEIGHT = 580;
					BACKGROUND_WIDTH = 360;
					FACEBOOK_Y = 330;
					MAX_CHARS = 100;
					INPUT_MULTILINE = true;
					CLEAR_PHOTO_X = 80;
					THUMBCONTAINER_Y = 13;
					
					break;
				case "enter_email":
					INPUT_FIELD_TEXT = Vo.DEFAULT_EMAIL;
					FONT_SIZE = 14;
					INPUT_WIDTH = 280;
					INPUT_FIELD_WIDTH = 310;
					INPUT_FIELD_HEIGHT = 40;
					INPUT_FIELD_Y = 12;
					BACKGROUND_HEIGHT = 175;
					BACKGROUND_WIDTH = 360;
					MAX_CHARS = 35;
					INPUT_MULTILINE = false;
					
					break;
			}
		}
	}
}