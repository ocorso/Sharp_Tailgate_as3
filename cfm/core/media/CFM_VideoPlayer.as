package cfm.core.media
{
	
	import cfm.core.events.CFM_VideoPlayerEvent;
	import cfm.core.objects.CFM_Object;
	import cfm.core.text.CFM_TextField;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.GlowFilter;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.flash_proxy;
	import flash.utils.setTimeout;
	
	import org.osmf.net.NetClient;
	
	public class CFM_VideoPlayer extends CFM_Object
	{
		private var videoURL:String;
		private var connection:NetConnection;
		public var stream:NetStream;
		public var loop:Boolean;
		public var autoStart:Boolean;
		public var video:Video;
		public var sound:SoundTransform;
		public var bufferFull:Boolean = false;
		public var centerH:Boolean;
		public var centerV:Boolean;
		public var startCuepoint:Number = NaN;
		public var waitingForCuepoint:Boolean = false;
		public var waitingForCuepointIndex:Number = NaN;
		public var waitingForCuepointPercent:Number = NaN;
		public var cuePoints:Array = [];
		public var metaData:Object;
		public var videoPaused:Boolean = false;
		public var firstBuffer:Boolean = false;
		public var client:Object;
		
		public function CFM_VideoPlayer(	_url:String, 
											_autoStart:Boolean = false, 
											_loop:Boolean = false, 
											_autoInit:Boolean = true, 
											_autoDestroy:Boolean = true, 
											_centerH:Boolean = false, 
											_centerV:Boolean = false, 
											_startCuepoint:Number = NaN	)
		{
			super("CFM_VideoPlayer",_autoInit,_autoDestroy);
			
			startCuepoint = _startCuepoint;
			videoURL = _url;
			loop = _loop;
			autoStart = _autoStart;
			centerH = _centerH;
			centerV = _centerV;
			
			sound = new SoundTransform(1);
			
			connection = CFM_VideoPlayerManager.netConnection;
			
			if(connection.connected){
				connectStream();
			} else {
				throw new Error("connectStream:: Not Connected");
			}
		}
		
		private function connectStream():void {
			var client:Object = new Object();
			client.onMetaData = ns_onMetaData;
			client.onCuePoint = ns_onCuePoint;
			
			stream = new NetStream(connection);
			stream.client = client;
			stream.bufferTime = 2;
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.soundTransform = sound;
			
			video = new Video();
			video.smoothing = true;
			video.visible = false;
			video.attachNetStream(stream);
			addChild(video);
			
			stream.play(videoURL);
		}
		
		private function startRender(e:Event):void{
			dispatchEvent(new CFM_VideoPlayerEvent(CFM_VideoPlayerEvent.PROGRESS, stream.time/metaData.duration));
			
			if(waitingForCuepoint){
				trace("waitingForCuepoint == " + stream.bytesLoaded/stream.bytesTotal + "---" + waitingForCuepointPercent);
				if(stream.bytesLoaded/stream.bytesTotal > waitingForCuepointPercent+.05){
					gotoCuePoint(waitingForCuepointIndex);
				}
			}
		}
		
		public function gotoCuePoint(_index:Number):void{
			var cuePointTime:Number = cuePoints[_index].time;
			var percent:Number = cuePointTime/metaData.duration;
			
			if( percent+.05 > stream.bytesLoaded/stream.bytesTotal){
				trace("gotoCuepoint - failed - " + percent);
				waitingForCuepoint = true;
				waitingForCuepointPercent = percent;
				waitingForCuepointIndex = _index;
				dispatchEvent(new CFM_VideoPlayerEvent(CFM_VideoPlayerEvent.WAITING_FOR_CUEPOINT, percent));
			} else {
				trace("gotoCuepoint - passed - " + percent);
				stream.seek(metaData.duration*percent);
				dispatchEvent(new CFM_VideoPlayerEvent(CFM_VideoPlayerEvent.WAITING_FOR_CUEPOINT_COMPLETE, waitingForCuepointPercent));
				waitingForCuepoint = false;
				waitingForCuepointIndex = NaN;
				waitingForCuepointPercent = NaN;
			}
		}
		
		private function ns_onMetaData(item:Object):void {
			if(!metaData){
				trace("ns_onMetaData::: " + item.duration);
				
				metaData = item;
				
				video.width = metaData.width;
				video.height = metaData.height;
				video.x = centerH ? -metaData.width/2 : 0;
				video.y = centerV ? -metaData.height/2 : 0;
				
				cuePoints = metaData.cuePoints;
				
				
				if(firstBuffer){
					videoReady(true);
				}
			}
		}
		
		private function ns_onCuePoint(item:Object):void{
			dispatchEvent(new CFM_VideoPlayerEvent(CFM_VideoPlayerEvent.CUEPOINT,0,0,item));
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					trace("NetStream.Play.StreamNotFound: " + videoURL);
					break;
				case "NetStream.Play.Start":
					trace("NetStream.Play.Start");
					break;
				case "NetStream.Buffer.Full":
					trace("NetStream.Buffer.Full");
					if(metaData){
						videoReady();
					}
					
					firstBuffer = true;
					break;
				case "NetStream.Play.Stop":
					trace("NetStream.Play.Stop");
					dispatchEvent(new CFM_VideoPlayerEvent(CFM_VideoPlayerEvent.COMPLETE));
					if(loop){
						stream.seek(0);
					} else {
						rewindVideo(true);
					}
					break;
			}
		}
			
		public function videoReady(fromMeta:Boolean = false):void{
			if(!firstBuffer || fromMeta){
				if(!isNaN( startCuepoint )){
					gotoCuePoint(startCuepoint);
				}
				
				if(!autoStart){
					stream.pause();
					stream.seek(0);
				}
				
				video.visible = true;
				addEventListener(Event.ENTER_FRAME, startRender);
				
				dispatchEvent(new CFM_VideoPlayerEvent(CFM_VideoPlayerEvent.READY));
			}
		}
		
		public function pauseVideo():void{
			if(stream){
				stream.pause();
				videoPaused = true;
			}
		}
		
		public function resumeVideo():void{
			if(stream){
				stream.resume();
				videoPaused = false;
			}
		}
		
		public function rewindVideo(pause:Boolean = false):void{
			if(stream){
				stream.seek(0);
				
				if(pause){
					stream.pause();
				}
			}
		}
		
		public function turnSoundOff():void{
			sound.volume = 0;
			if(stream){
				stream.soundTransform = sound;
			}
		}
		
		public function turnSoundOn():void{
			sound.volume = 1;
			if(stream){
				stream.soundTransform = sound;
			}
		}
		
		protected function startDestroy():void{
			trace("destroying videoplayer [" + videoURL + "]" );
			removeEventListener(Event.ENTER_FRAME, startRender);
			
			if(stream){
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.pause();
				stream.close();
			}
		}
	}
}