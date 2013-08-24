package sharp.model.vo
{
	import flash.text.Font;
	
	import sharp.views.facebookModule.vo.WallPostParams;
	import sharp.views.youtubeModule.vo.YoutubeData;

	public class Vo
	{
		//configs
		public static const APP_CONFIG_URL						:String = "xml/config.xml";
		public static const IMAGES_URL							:String = "images/tailgate/";
		public static const GRAPH_URL							:String = "https://graph.facebook.com/";
		public static const YOUTUBE_PLAYPATH					:String = "http://www.youtube.com/apiplayer?version=3";
		
		public static const DEFAULT_TEAM_NAME					:String = "TEAM NAME!";
		public static const DEFAULT_TAILGATE_NAME				:String = "MY AT-HOME SHARP TAILGATE EXPERIENCE";
		public static const DEFAULT_EMAIL						:String = "Email address";
		public static const DEFAULT_YOUTUBE_URL					:String = "http://www.youtube.com/watch?v=bTP1jvJWxjA";
		
		public static const FIRST_PAGE							:String = "theme";
		public static const FIRST_ROOM							:Number = 0;
		public static const DEFAULT_TV							:Number = 3;
		public static const BUILD_DELAY							:Number = 0;
		
		//fonts
		public static const FONT_MEDIUM							:Font = new Ideal_Medium();
		public static const FONT_BOLD							:Font = new Ideal_Semibold();
		public static const FONT_ARIAL							:Font = new Arial();
		public static const FONT_MYRIAD							:Font = new Myriad;
		
		//general interface
		public static const MARGIN_TOP							:Number = 0;
		public static const MARGIN_LEFT							:Number = 11;
		public static const LOGOS_GAP							:Number = 25;
		public static const HEADING_Y							:Number = 80;
		public static const PAGE_NAVIGATION_Y_DOWN				:Number = 640;
		public static const PAGE_NAVIGATION_Y_TOP				:Number = 20;
		public static const LEFT_BUTTONS						:Array = ["start_over", "back", "clear_photo"];
		
		//colors
		public static const BLACK								:uint = 0x000000;
		public static const RED									:uint = 0xd72324;
		public static const DARK_RED							:uint = 0x9d0704;
		public static const GRAY_STROKE							:uint = 0xc7c7c7;
		public static const GRAY_TEXT							:uint = 0x646464;
		
		//theme view
		public static const CAROUSEL_TRANSIT_TIME				:Number = .5;
		
		//customize view
		public static const ROOM_IMAGE_WIDTH					:Number = 790;
		public static const ROOM_IMAGE_HEIGHT					:Number = 650;
		public static const ROOM_Y								:Number = 190;
		public static const PAGE_NAVIGATION_MARGIN_LEFT			:Number = 25;
		public static const MENU_BUTTON_SPACING					:Number = 35;
		public static const DROPDOWN_MENU_Y						:Number = 155;
		public static const BUTTON_SQUARE_SIZE 					:Number = 26;
		public static const SMALL_PAGE_NAV_SCALE				:Number = .8;
		public static const LARGE_PAGE_NAV_SCALE				:Number = 1.15;
		public static const DROPDOWN_NECK_HEIGH					:Number = 5;
		public static const DROPDOWN_PADDING  					:Number = 20;
		
		public static const FACEBOOK_THUMB_WIDTH				:Number = 133;
		public static const FACEBOOK_THUMB_HEIGHT				:Number = 85;
		
		public static const WINDOW_PADDING						:Number = 10;
		
		public static const INVALID_TEXT						:String = "Sorry, this URL is invalid!";
		public static const EMAIL_INVALID_TEXT					:String = "Sorry, this email is invalid!";
		
		//gallery
		public static const GALLERY_THUMB_WIDTH					:Number = 227;
		public static const GALLERY_THUMB_HEIGHT				:Number = 198;
		public static const SLIDESHOW_SPEED						:Number = 5000;
		
		public static var themeParams							:ThemeParams = new ThemeParams();
		public static var customizeParams						:CustomizeParams = new CustomizeParams();
		public static var youtube								:YoutubeData = new YoutubeData();
	}
}