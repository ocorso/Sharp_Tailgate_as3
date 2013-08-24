package sharp.commands
{

	import flashx.textLayout.elements.BreakElement;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.GalleryEvent;
	import sharp.model.Model;
	import sharp.services.GalleryService;
	import sharp.views.facebookModule.service.FacebookService;
	
	public class GalleryCommand extends Command
	{
		[Inject]
		public var event:GalleryEvent;
		
		[Inject]
		public var service:GalleryService;
		
		[Inject]
		public var facebookService:FacebookService;
		
		[Inject]
		public var _m:Model;
		
		public function GalleryCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case GalleryEvent.GET_IMAGES_DATA:
					service.getGalleryData(_m.baseUrl, event.params.route);
					break;
				case GalleryEvent.GOT_IMAGES_DATA:
					_m.galleryData = event.params.galleryData;
					break;
				case GalleryEvent.GET_IMAGE_DETAIL_DATA:
					Out.info(this, "command get image detail data")
					service.getGalleryDetailData(_m.baseUrl, event.params.tid);
					break;
				case GalleryEvent.GOT_IMAGE_DETAIL_DATA:
					_m.galleryDetailData = event.params.galleryDetailData;
					break;
			}
		}
	}
}