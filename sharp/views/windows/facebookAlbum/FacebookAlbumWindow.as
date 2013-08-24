package sharp.views.windows.facebookAlbum
{
	import cfm.core.events.CFM_ScrollBarEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.navigation.CFM_SimpleNavigation;
	
	import com.adobe.serialization.json.JSON;
	import com.carlcalderon.arthropod.Debug;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.utils.FacebookUtils;
	import sharp.views.appMainButton.AppMainButton;
	import sharp.views.appTemplate.SharpScrollbar;
	import sharp.views.windows.SharpPopupWindowTemplate;
	import sharp.views.windows.facebookAlbum.navigations.FacebookAlbumNavigation;
	import sharp.views.windows.facebookAlbum.navigations.FacebookPhotoNavigation;
	import sharp.views.windows.facebookAlbum.navigations.FacebookSelectedImageNavigation;
	
	public class FacebookAlbumWindow extends SharpPopupWindowTemplate
	{
		private const BACKGROUND_WIDTH 				:Number = 750;
		private const BACKGROUND_HEIGHT				:Number = 500;
		private const SCROLLBAR_WIDTH				:Number = 10;
		private const SCROLLBAR_HEIGHT				:Number = 130;
		private const MASK_HEIGHT					:Number = 330;
		private const MASK_HEIGHT_PHOTO				:Number = 350;
		private const MARGIN						:Number = 20;
		
		private var   MAX_NAV_WIDTH					:Number;
		public var    multiSelect					:Boolean; //Support multiple selection
		
		private var _authToken						:String;
		private var _albumList						:XMLList;
		private var _photoList						:XMLList;
		private var _albumId						:String;
		public var albumNav							:FacebookAlbumNavigation;
		public var photoNav							:FacebookPhotoNavigation;
		public var sideNav							:FacebookSelectedImageNavigation;
		public var sideNavOkBtn						:AppMainButton;
		private var navMask							:CFM_Graphics;
		private var scrollbar						:SharpScrollbar;
		private var scrollTarget					:CFM_SimpleNavigation;
		private var _photosArr						:Array;
		private var photoPreloader					:ImagePreloader;
		private var photoloader						:URLLoader;
		// =================================================
		// ================ Callable
		// =================================================

		public function swicthStatus(_status:String):void{
			switch(_status){
				case "album":
					showAlbumView();
					break;
				case "photo":
					showPhotoView();
					break;
			}
		}

		// =================================================
		// ================ Create and Build
		// =================================================
		
		override protected function build():void{
			super.build();
			
			buildAlbumNav();
			buildMask();
			
			heading.setProperties({x:MARGIN + 20, y:MARGIN + 10});
			albumNav.setProperties({x:heading.x+5, y:heading.y + heading.height + 27});
			
			if (multiSelect) buildSideNav();
			
			buildScrollBar(albumNav);
			
			pageNavigation.visible = false;
			pageNavigation.alpha = 0;
			
			photoPreloader = new ImagePreloader();
			_content.addChild(photoPreloader);
			photoPreloader.x = _totalWidth*.5 - photoPreloader.width;
			photoPreloader.y = _totalHeight*.5;
			photoPreloader.visible = false;

		}
		
		public function buildAlbumNav():void{
			albumNav = new FacebookAlbumNavigation(albumList,authToken,false,true,null,true,true,MAX_NAV_WIDTH);
			albumNav.renderTo(_content);
			albumNav.showButton();
		}
		
		public function getPhotoList():void{
			var albumUrl:String;

			_photosArr = new Array();
			albumUrl = Vo.GRAPH_URL + albumId + "/photos?limit=0&access_token="+ authToken;
			
			photoPreloader.visible = true;

			Debug.log(albumUrl, Debug.LIGHT_BLUE);
			
			photoloader = new URLLoader();
			photoloader.load(new URLRequest(albumUrl));
			photoloader.addEventListener(Event.COMPLETE, onGetAlbumUrl, false, 0, true);
		}
		
		private function onGetAlbumUrl(e:Event):void{
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetAlbumUrl);
			
			var data:Object = JSON.decode(loader.data);
			_photosArr		= data.data;
			
			photoList 		= FacebookUtils.parseAlbumImagesToNavXML(_photosArr);
			photoNav 		= new FacebookPhotoNavigation(photoList,authToken,multiSelect,true,null,true,true,MAX_NAV_WIDTH);
			photoNav.renderTo(_content);
			photoNav.setProperties({x:albumNav.x, y:heading.y + heading.height + 27});
			photoNav.showButton();
			navMask.height 	= MASK_HEIGHT_PHOTO;
			photoNav.mask 	= navMask;
			buildScrollBar(photoNav);
			photoPreloader.visible = false;
		}
		
		private function buildMask():void{
			navMask = new CFM_Graphics();
			navMask.renderTo(_content);
			navMask.width = MAX_NAV_WIDTH;
			navMask.height = MASK_HEIGHT;
			albumNav.mask = navMask;
		}
		
		private function buildScrollBar(_target:CFM_SimpleNavigation):void{			
			scrollTarget = _target;			
			scrollbar = new SharpScrollbar(navMask.height,SCROLLBAR_HEIGHT,SCROLLBAR_WIDTH,true);
			scrollbar.renderTo(_content);
			
			if(scrollTarget.height > MASK_HEIGHT){
				scrollbar.visible = true;
				
			}else{
				scrollbar.visible = false;
			}

			navMask.x		 = scrollTarget.x;
			navMask.y		 = scrollTarget.y;
			scrollbar.x 	 = MAX_NAV_WIDTH - MARGIN + 40;
			scrollbar.y 	 = scrollTarget.y;
			scrollbar.addEventListener(CFM_ScrollBarEvent.SCROLLING, onScroll, false, 0, true);	
		}
		
		private function buildSideNav():void{
			Out.info(this, "Build side Nav");
			sideNav = new FacebookSelectedImageNavigation();
			sideNav.renderTo(_content);
			sideNav.setProperties({x:MAX_NAV_WIDTH + 70, y: heading.y + heading.height + 30});
				
			sideNavOkBtn = new AppMainButton(1, "ok", "ok", "OK", 16, 7,false, false);
			sideNavOkBtn.renderTo(_content);
			sideNavOkBtn.setProperties({x:MAX_NAV_WIDTH + 70, y: heading.y});
			sideNavOkBtn.alpha = 0;
			sideNavOkBtn.visible = false;
		}

		// =================================================
		// ================ Workers
		// =================================================
		private function showPhotoView():void{
			albumNav.visible = false;
			albumNav.alpha = 0;
			removeScrollBar();
			getPhotoList();
			heading.text = "Choose a photo";
			
			pageNavigation.setProperties({x:heading.x + heading.width + 34, y:heading.y});

			TweenMax.to(pageNavigation, .2, {autoAlpha:1, delay:.5});			
		}
		
		private function showAlbumView():void{
			photoPreloader.visible = false;
			photoloader.removeEventListener(Event.COMPLETE, onGetAlbumUrl);
			if(photoNav) photoNav.remove();
			removeScrollBar();

			TweenMax.to(albumNav, .3, {autoAlpha:1});
			albumNav.x = heading.x + 5;
			albumNav.y = heading.y + heading.height + 27;
			
			buildScrollBar(albumNav);
			navMask.height = MASK_HEIGHT;
			albumNav.mask = navMask;
			heading.text = "Choose an album";
			albumNav.deselectAll();
			pageNavigation.visible = false;
			pageNavigation.alpha = 0;
			albumNav.showButton();
		}
		
		private function removeScrollBar():void{
			if(_content.contains(scrollbar)) scrollbar.remove();
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		private function onScroll(e:CFM_ScrollBarEvent):void{
			TweenMax.killTweensOf(scrollTarget);
			TweenMax.to(scrollTarget, .8, {ease:Sine.easeOut, y:navMask.y-((scrollTarget.height-navMask.height)*e.percent)});
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		public function get authToken():String{return _authToken;}
		public function set authToken(value:String):void{_authToken = value;}

		public function get albumList():XMLList{return _albumList;}
		public function set albumList(value:XMLList):void{_albumList = value;}
		
		public function get photoList():XMLList{return _photoList;}
		public function set photoList(value:XMLList):void{_photoList = value;}
		
		public function get albumId():String{return _albumId;}
		public function set albumId(value:String):void{_albumId = value;}
		
		public function get backButton():CFM_SimpleNavigation{
			return pageNavigation;
		}
		
		public function get facebookType():String{
			return params.facebookType;
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

		public function FacebookAlbumWindow(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
			_totalWidth	 = BACKGROUND_WIDTH;
			_totalHeight = BACKGROUND_HEIGHT;
			
			Out.status(this, "FACEBOOK TYPE: "+ Vo.customizeParams.listId);
			
			//Erase photoId array
			Vo.customizeParams.photoIds = [];	
			
			switch (Vo.customizeParams.listId) {
				case "personalization":
					MAX_NAV_WIDTH = 700;
					multiSelect = false;
					break;
				case "enter_video":
					MAX_NAV_WIDTH = 530;
					multiSelect = true;				
					break;
			}
		}
	}
}