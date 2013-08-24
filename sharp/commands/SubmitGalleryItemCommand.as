package sharp.commands
{
	import flash.events.Event;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.SubmitGalleryItemEvent;
	import sharp.model.Model;
	import sharp.model.vo.SubmitGalleryItemParams;
	import sharp.services.ExportBitmapService;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.facebookModule.service.FacebookService;
	import sharp.views.facebookModule.vo.WallPostParams;
	
	public class SubmitGalleryItemCommand extends Command
	{
		[Inject]
		public var submitEvent:SubmitGalleryItemEvent;
		
		[Inject]
		public var exportBitmapService:ExportBitmapService;
		
		[Inject]
		public var facebookService:FacebookService;
		
		[Inject]
		public var _m:Model;
		
		
		override public function execute():void{
			
			Out.status(this, "execute");
			
			switch(submitEvent.type){
				case SubmitGalleryItemEvent.SAVE_IMAGE_TO_GALLERY:
					//_m.submitImageParams 	= SubmitGalleryItemParams(submitEvent.params);
					Out.info(this, "save image to gallery");
					
					exportBitmapService.saveImageToGallery(_m.submitImageParams);
					break;
				case SubmitGalleryItemEvent.SAVE_IMAGE_COMPLETE:
					Out.debug(this, "SAVE_IMAGE_COMPLETE");
					//_m.submitImageParams 	= SubmitGalleryItemParams(submitEvent.params);
					_m.tid					= SubmitGalleryItemParams(submitEvent.params).tid;
					facebookService.postToWall(SubmitGalleryItemParams(submitEvent.params));
					break;
				
			}//end switch
			
		}//end function
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
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

		public function SubmitGalleryItemCommand()
		{
			super();
		}
	}
}