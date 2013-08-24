package cfm.core.media
{
	import cfm.core.events.ProgressiveSWFVideoEvent;
	import cfm.core.objects.CFM_Object;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Sine;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	public class CFM_ProgressiveSWFVideo extends CFM_Object
	{
		private var videoUrl:String;
		private var loader:Loader;
		private var request:URLRequest;
		private var movie:MovieClip;
		
		private var loadProgress:Number;
		private var preBufferPercent:Number = .2;
		private var buffer:Number = .05;
		private var playProgress:Number = 0;
		
		private var autoPlay:Boolean = false;
		private var bufferComplete:Boolean = false;
		private var loadingComplete:Boolean = false;
		private var waitingForBuffer:Boolean = false;
		private var isPlaying:Boolean = false;
		private var waitingToPlay:Boolean = false;
		
		public function CFM_ProgressiveSWFVideo(_url:String, _autoPlay:Boolean = false)
		{
			videoUrl = _url;	
			loader = new Loader();
			
			autoPlay = _autoPlay;
			
			super("ProgressiveSWFVideo");
		}
		
		override protected function build():void{
			var context:LoaderContext = new LoaderContext(); 
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			if(  videoUrl.indexOf("http") != -1 )
				context.securityDomain = SecurityDomain.currentDomain; 
			
			request = new URLRequest(videoUrl);
			
			loader.load(request, context);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			addChild(loader);
		}
		
		override protected function removeListeners():void{
			super.removeListeners();
			
			if(loader){
				if(loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
					
				if(loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			}
		}
		
		protected function onLoadProgress(e:ProgressEvent):void{
			loadProgress = e.bytesLoaded/e.bytesTotal;
			dispatchEvent(new ProgressiveSWFVideoEvent(ProgressiveSWFVideoEvent.PROGRESS, loadProgress, Number.NaN, playProgress));
			
			if(!movie && loader.content)
				movie = loader.content as MovieClip;
			
			if(!bufferComplete && loadProgress > preBufferPercent){
				bufferComplete = true;
				
				if(waitingToPlay || autoPlay)
					play();
			} else {
				if(waitingForBuffer && playProgress < (loadProgress-buffer))
					play();
			}
		}
		
		public function gotoFrame(_frame:int, _speed:Number = 0):void{
			if(movie && movie.framesLoaded >= _frame){
				TweenMax.to(movie, _speed, {ease:Sine.easeOut, frame:_frame});
			}else{
				movie.gotoAndStop(movie.framesLoaded);
			}
		}
		
		public function get totalFrames():Number{
			if(movie){
				return movie.totalFrames;
			}else {
				return 0;
			}
		}
		
		protected function onLoadComplete(e:Event):void{
			loadingComplete = true;
			
			if(!movie && loader.content)
				movie = loader.content as MovieClip;
			
			dispatchEvent(new ProgressiveSWFVideoEvent(ProgressiveSWFVideoEvent.COMPLETE, 1, movie.currentFrame, playProgress));
			
			if(autoPlay && !isPlaying || waitingToPlay)
				play();
		}
		
		public function play():void{
			if(movie){
				startRender();
				movie.play();
				waitingToPlay = false;
			}else{
				waitingToPlay = true;
				stopRender();
			}
		}
		
		public function pause():void{
			if(movie){
				movie.stop();
				stopRender();
			}
		}
		
		private function startRender():void{
			if(!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME, rendering, false, 0, true);
		}
		
		private function stopRender():void{
			if(hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, rendering);
		}
		
		private function rendering(e:Event):void{
			if( movie ){
				playProgress = movie.currentFrame/movie.totalFrames;
				
				if(isPlaying && playProgress > (loadProgress-buffer)){
					waitingForBuffer = true;
					pause();
				} else {
					dispatchEvent(new ProgressiveSWFVideoEvent(ProgressiveSWFVideoEvent.RENDERING, 1, movie.currentFrame, playProgress, true));
				}
				
				if(playProgress>=1)
					stopRender();
			}
		}
		
		override public function destroy(e:Event):void{
			super.destroy(e);
				
			if(loader){
				try{
					loader.close();
					loader.unloadAndStop(true);
				} catch(e:Error){
					trace(e);
				}
			}
		}
	}
}