package sharp.services
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Encoder;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Actor;
	
	import sharp.events.SubmitGalleryItemEvent;
	import sharp.model.vo.SubmitGalleryItemParams;
	
	public class ExportBitmapService extends Actor
	{
		private var _uploader:URLLoader;
		private var _p:SubmitGalleryItemParams;
		
		public function ExportBitmapService()
		{
			super();
		}
		
		public function saveImageToGallery($submitImageData:SubmitGalleryItemParams):void{
			Out.info(this, "saveImageToGallery" + $submitImageData.roomBitmap + $submitImageData.userEmail);
			
			_p 	= $submitImageData;
			
			//oc: largeImage
			var encoder			:PNGEncoder 	= new PNGEncoder();
			var bytes			:ByteArray		= encoder.encode( _p.forgroundBitmap.bitmapData );
			var encrypted1		:Base64Encoder 	= new Base64Encoder();
			encrypted1.encodeBytes(bytes);
			
			//oc: thumbImage
			var encoder2		:JPGEncoder 	= new JPGEncoder(80);
			var bytes2			:ByteArray		= encoder2.encode( _p.roomBitmap.bitmapData );
			var encrypted2		:Base64Encoder 	= new Base64Encoder();
			encrypted2.encodeBytes(bytes2);
			
			var _uploaderVars:URLVariables	= new URLVariables();
			_uploaderVars.thumbImage 	= encrypted2;
			_uploaderVars.largeImage 	= encrypted1;
			_uploaderVars.user_id		= _p.userId;
			_uploaderVars.full_name 	= _p.username;
			_uploaderVars.profile_pic 	= _p.photoUrl;
			_uploaderVars.media_id		= _p.mediaId;
			_uploaderVars.is_slideshow	= _p.isSlideshow;
			_uploaderVars.title			= _p.title;
			_uploaderVars.tv_size		= _p.tvSize;
			_uploaderVars.room_type		= _p.roomType;
			_uploaderVars.user_email	= _p.userEmail;
			
			var req:URLRequest 			= new URLRequest( _p.route );
			req.data 					= _uploaderVars;
			req.method 					= URLRequestMethod.POST;
			
			var _uploader:URLLoader 	=  new URLLoader();
			_uploader.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_uploader.load(req);

		}//end function
		
		private function _onComplete($e:Event):void{
			Out.status(this, "onComplete");
			
			var response:Object = new Object();
			var ldr:URLLoader	= $e.target as URLLoader;
			
			try{
				response = JSON.decode(ldr.data);
				
			}catch ($e:Error){
				Out.error(this, "um, there was like some kind of tokenizer error or something");
				response.payload = ldr.data;
				response.error = $e;
				for(var s:String in response){
					Out.debug(this," ::: "+ s +" ::: "+response[s]);
				}
			}
			
			if(response.image){
				Out.debug(this, "about to overwrite submitImageParams: "+response.image.tid)
				_p.tid	= response.image.tid;
			}
			
			//oc: show response window
			dispatch(new SubmitGalleryItemEvent(SubmitGalleryItemEvent.SAVE_IMAGE_COMPLETE,_p));
		}
		
		public function dropImage($submitImageData:SubmitGalleryItemParams, _tid:String):void{
			_p 	= $submitImageData;

			var req:URLRequest 			= new URLRequest( $submitImageData.dropRoute + _tid );
			var _uploader:URLLoader 	= new URLLoader();
			
			_uploader.addEventListener(Event.COMPLETE, _onDropComplete, false, 0, true);
			_uploader.load(req);
		}
		
		private function _onDropComplete($e:Event):void{
			Out.info(this, "drop image complete");
			
			dispatch(new SubmitGalleryItemEvent(SubmitGalleryItemEvent.DROP_IMAGE_COMPLETE,null));
		}
	}
}