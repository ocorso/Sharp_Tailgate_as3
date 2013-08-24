package sharp.services
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Actor;
	
	import sharp.events.GalleryEvent;
	
	public class GalleryService extends Actor
	{
		private var galleryRoute				:String;
		private var galleryDetailUrl			:String;
		private var galleryLoader				:URLLoader;
		private var galleryDetailLoader			:URLLoader;
		private var galleryData					:XML;
		private var galleryDetailData			:XML;
		private var tid							:String;
		
		// =================================================
		// ================ Callable
		// =================================================
		public function getGalleryData(_baseUrl:String, _galleryRoute:String):void{
			Out.status(this, "_galleryRoute: " + _galleryRoute);
			galleryRoute = _galleryRoute;
			
			galleryLoader = new URLLoader();
			galleryLoader.load(new URLRequest(_baseUrl + _galleryRoute));
			galleryLoader.addEventListener(Event.COMPLETE, onGetGalleryData, false, 0, true);
		}
		
		public function getGalleryDetailData(_baseUrl:String, _tid:String):void{
			tid = _tid;
			
			Out.info(this, _baseUrl + "gallery/" + _tid);
			galleryDetailLoader = new URLLoader();
			galleryDetailLoader.load(new URLRequest(_baseUrl + "gallery/" + _tid));
			galleryDetailLoader.addEventListener(Event.COMPLETE, onGetGalleryDetailData, false, 0, true);
		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		private function onGetGalleryData(e:Event):void{
			
			galleryLoader.removeEventListener(Event.COMPLETE, onGetGalleryData);
			
			galleryData = XML(e.target.data);
			dispatch(new GalleryEvent(GalleryEvent.GOT_IMAGES_DATA, {galleryData:galleryData}));
		}
		
		private function onGetGalleryDetailData(e:Event):void{
			
			galleryDetailLoader.removeEventListener(Event.COMPLETE, onGetGalleryDetailData);
			galleryDetailData = XML(e.target.data);
			dispatch(new GalleryEvent(GalleryEvent.GOT_IMAGE_DETAIL_DATA, {galleryData:galleryData, galleryDetailData:galleryDetailData, tid:tid}));
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

		public function GalleryService()
		{
			super();
		}
	}
}