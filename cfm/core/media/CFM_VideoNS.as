package cfm.core.media
{
	import cfm.core.events.CFM_VideoStreamEvent;
	import cfm.core.managers.CFM_VideoPlayerManager;
	import cfm.core.objects.CFM_Object;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[Event(name="progress", type="com.cfm.core.events.CFM_VideoStreamEvent")]
	[Event(name="ready", type="com.cfm.core.events.CFM_VideoStreamEvent")]
	[Event(name="complete", type="com.cfm.core.events.CFM_VideoStreamEvent")]
	
	public class CFM_VideoNS extends CFM_Object
	{
		private var videoURL		:String;
		private var connection		:NetConnection;
		private var stream			:NetStream;
		private var video			:Video;
		private var sound			:SoundTransform;
		private var cuePoints		:Array = [];
		private var startCuepoint	:Number = NaN;
		
		private var bufferFull		:Boolean = false;
		private var centerH			:Boolean;
		private var centerV			:Boolean;
		private var videoPaused		:Boolean = false;
		private var firstBuffer		:Boolean = false;
		private var loop			:Boolean;
		private var autoStart		:Boolean;
		
		private var client			:Object;
		private var metaData		:Object;
		private var cuePointWaiting	:Object = null;
		private var forceSize		:Object = null;
		public var isPlaying:Boolean = false;
		
		public var lastDecodedFrame:Number = 0;
		
		public function CFM_VideoNS(_centerH:Boolean = false, _centerV:Boolean = false, _forceSize:Object = null, _autoInit:Boolean = true,_autoDestroy:Boolean = true)
		{
			super("CFM_VideoPlayer",_autoInit,_autoDestroy);
			
			forceSize 				= _forceSize;
			centerH 				= _centerH;
			centerV 				= _centerV;
			sound 					= new SoundTransform(1);
			
			initConnection();
			
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		public function render(e:Event):void{
			if(stream && stream.decodedFrames > lastDecodedFrame){
				lastDecodedFrame = stream.decodedFrames;
				dispatchEvent(new Event("update"));
				//trace(stream.decodedFrames);
			}
		}
		
		public function currentFrame():Number{
			return stream.decodedFrames;
		}
		
		private function initConnection():void{
			connection = CFM_VideoPlayerManager.netConnection;
			
			if(connection.connected)
				connectStream();
			else
				throw new Error("connectStream:: Not Connected");
		}
		
		private function connectStream():void {
			client = new Object();
			client.onMetaData = ns_onMetaData;
			client.onCuePoint = ns_onCuePoint;
			
			stream = new NetStream(connection);
			stream.client = client;
			stream.bufferTime = 1;
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.soundTransform = sound;
			
			video = new Video();
			video.smoothing = true;
			video.visible = false;
			video.attachNetStream(stream);

			addChild(video);
		}
		
		public function play(_url:String, _startCuepoint:Number = NaN, _autoStart:Boolean = false, _loop:Boolean = false):Boolean{
			videoURL = _url;
			loop = _loop;
			autoStart = _autoStart;
			startCuepoint = _startCuepoint;
			bufferFull = false;
			firstBuffer = true;
			isPlaying = true;
			
			if(stream){
				stream.play(videoURL);
				return true;
			} else {
				return false;
			}
		}
		
		public function stop():void{
				pauseVideo();
				rewindVideo();
				isPlaying = false;
		}
		
		public function get ready():Boolean{
			return firstBuffer;
		}
		
		public function gotoCuePoint(_index:Number):void{
			var cuePointTime:Number = cuePoints[_index].time;
			var percent:Number = cuePointTime/metaData.duration;
			
			if( percent+.05 > stream.bytesLoaded/stream.bytesTotal){
				cuePointWaiting = {index:_index, percent:percent};
				dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.WAITING_FOR_CUEPOINT, percent));
			} else {
				stream.seek(metaData.duration*percent);
				dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.WAITING_FOR_CUEPOINT_COMPLETE, cuePointWaiting.percent));
				cuePointWaiting = null;
			}
		}
		
		private function ns_onMetaData(item:Object):void {
			if(!metaData){
				metaData = item;
				
				video.width = metaData.width;
				video.height = metaData.height;
				video.x = centerH ? -metaData.width/2 : 0;
				video.y = centerV ? -metaData.height/2 : 0;
				
				cuePoints = metaData.cuePoints;
				
				if(firstBuffer)
					videoReady(true);
			}
			
			if(forceSize){
				video.width = forceSize.width;
				video.height = forceSize.height;
			}
		}
		
		private function ns_onCuePoint(item:Object):void{
			dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.CUEPOINT,0,0,item));
		}
		
		private function netStatusHandler(event:NetStatusEvent):void{
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
				break;
				case "NetStream.Play.Start":
					dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.PLAY_START));
				break;
				case "NetStream.Buffer.Full":
					if(metaData)
						videoReady();
					
					firstBuffer = true;
				break;
				case "NetStream.Play.Stop":
					dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.COMPLETE));
					
					if(loop)
						stream.seek(0);
					else
						stream.pause();
						rewindVideo();
						
						isPlaying = false;
				break;
			}
		}
			
		public function videoReady(fromMeta:Boolean = false):void{
			if(!firstBuffer || fromMeta){
				if(!isNaN( startCuepoint ))
					gotoCuePoint(startCuepoint);
				
				if(!autoStart){
					stream.pause();
					stream.seek(0);
				}
				
				video.visible = true;
				dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.READY));
			}
		}
		
		public function pauseVideo():void{			
			if(stream){
				stream.pause();
				videoPaused = true;
			}
			
			isPlaying = false;
		}
		
		public function resumeVideo():void{						
			if(stream){
				stream.resume();
				videoPaused = false;
			}
			
			isPlaying = true;
		}
		
		public function rewindVideo():void{
			if(stream)
				stream.seek(0);
		}
		
		public function turnSoundOff():void{
			sound.volume = 0;
			
			if(stream)
				stream.soundTransform = sound;
		}
		
		public function turnSoundOn():void{
			sound.volume = 1;
			
			if(stream)
				stream.soundTransform = sound;
		}
		
		override public function destroy(e:Event):void{				
			if(stream){
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.pause();
				stream.close();
			}
			
			super.destroy(e);
		}
		
		public function get time():Number{
			return stream.time;
		}
		
		public function seekToPercent(_percent:Number):void{
			stream.seek(duration*_percent);
		}
		
		public function get duration():Number{return metaData.duration;}
	}
}