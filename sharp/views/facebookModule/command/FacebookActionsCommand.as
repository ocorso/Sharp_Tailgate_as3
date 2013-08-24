package sharp.views.facebookModule.command
{
	
	import flash.xml.XMLNode;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.model.Model;
	import sharp.services.ExportBitmapService;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.facebookModule.service.FacebookService;
	
	public class FacebookActionsCommand extends Command
	{
		public function FacebookActionsCommand()
		{
			super();
		}
		
		[Inject]
		public var service:FacebookService;

		[Inject]
		public var exportBitmapService:ExportBitmapService;
		
		[Inject]
		public var event:FacebookSessionEvent;
		
		[Inject]
		public var _m:Model;
		
		override public function execute():void{
			switch(event.type){
				case FacebookSessionEvent.POST_TO_WALL:
					break;
				case FacebookSessionEvent.POST_TO_WALL_SUCCESS:
					Out.status(this, "POST_TO_WALL_SUCCESS :: " + event.params.postId);
					
					_m.submitImageParams.postid = event.params.postId;
					
					service.savePostId(_m.submitImageParams);
				break;
				case FacebookSessionEvent.POST_TO_WALL_FAILED:
					Out.error(this, "POST_TO_WALL_FAILED :: DROPPING ID :: " + _m.tid);

					exportBitmapService.dropImage(_m.submitImageParams, _m.tid);
				break;
				case FacebookSessionEvent.LIKE_BUTTON_CLICKED:
					Out.status(this, "LIKE_BUTTON_CLICKED");
					
					var postId:String = _m.galleryDetailData.post_id[0].toString();
					var userId:String = _m.galleryDetailData.user_id[0].toString();
					
					var isMyFriend:Boolean = _m.facebook.isMyFriend( userId );
					var isMe:Boolean = _m.facebook.isMe( userId );
					
					if( !isMe && !isMyFriend || !postId ){
						postId = "";
					}
										
					var params:Object =  {
							isLiked: 			event.params.isLiked, 
							accessToken:		_m.facebook.authToken, 
							postId:				postId, 
							tid:				XML(_m.galleryDetailData).@tid, 
							addRoute:			_m.galleryDetailData.likes.add + "/" + _m.facebook.userId + "/" + postId, 
							removeRoute:		_m.galleryDetailData.likes.remove + "/" + _m.facebook.userId + "/" + postId
					};
					
					if( !postId || postId == "" ){
						params.addRoute +=	"/0"; 
						params.removeRoute += "/0";
					}
					
					service.like( params );
				break;
			}
		}
	}
}