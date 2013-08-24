package cfm.core.media
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.loaders.CFM_XMLLoader;
	import cfm.core.objects.CFM_Object;
	
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.media.SoundTransform;
	
	import flashx.textLayout.operations.PasteOperation;
	import cfm.core.events.CornerPinClipEvent;
	import cfm.core.ui.CFM_CornerPinClip;
	import cfm.core.vo.CFM_PersonlizedVideoDefinition;
	import cfm.core.events.ProgressiveSWFVideoEvent;
	
	public class CFM_PersonalizedVideoPlayer extends CFM_Object
	{
		private var __definition			:CFM_PersonlizedVideoDefinition;
		
		private var clipDataLoader			:CFM_XMLLoader;
		private var clipsList				:XMLList;
		private var clips					:Vector.<CFM_CornerPinClip>
		private var clipContainer			:CFM_ObjectContainer;
		private var autoPlay				:Boolean;
		private var currentVolume			:Number = 1;
		private var stransform				:SoundTransform;
		
		private var currentFrame:Number;
		
		private var video:CFM_ProgressiveSWFVideo;
		
		public function CFM_PersonalizedVideoPlayer(_definition:CFM_PersonlizedVideoDefinition, _autoPlay:Boolean, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			__definition = _definition;
			autoPlay = _autoPlay;
			
			currentFrame = 0;
			clips = new Vector.<CFM_CornerPinClip>();
			
			super("PersonalizedVideoPlayer", _autoInit, _autoDestroy);
		}
		
		override protected function build():void{
			clipContainer = new CFM_ObjectContainer();
			clipContainer.renderTo(this);
			
			stransform = new SoundTransform(1,0);
			
			video = new CFM_ProgressiveSWFVideo(baseURL + definition.videoUrl, autoPlay);
			video.soundTransform = stransform;
			video.renderTo(this);
						
			loadXMLData();
		}
		
		override protected function addListeners():void{
			video.addEventListener(ProgressiveSWFVideoEvent.RENDERING, render, false, 0, true);
		}
		
		private function loadXMLData():void{
			clipDataLoader = new CFM_XMLLoader(definition.xmlUrl, onXMLDataComplete, null);
		}
		
		private function onXMLDataComplete(_xml:XML):void{
			clipsList = _xml.clip;
			
			buildClips();
		}
		
		private function buildClips():void{			
			buildNextClip();
		}
		
		private function buildNextClip():void{
			var clip:CFM_CornerPinClip = new CFM_CornerPinClip(parseInt(clipsList[clips.length].@start), clipsList[clips.length].coord, getBitmapData(clipsList[clips.length]) );
			
			clip.addEventListener(CornerPinClipEvent.COMPLETE, buildClipComplete, false, 0, true);
			clips.push(clip);
			clip.renderTo(clipContainer);
		}
		
		private function cycleBitmap(_tag:XML):Boolean{
			if(_tag.@cycle && _tag.@cycle == "true")
				return true;
			else
			 	return false;
		}
		
		private function buildClipComplete(e:CornerPinClipEvent):void{
			var clip:CFM_CornerPinClip = CFM_CornerPinClip(e.currentTarget);
			
			clip.removeEventListener(CornerPinClipEvent.COMPLETE, buildClipComplete);
			
			if(buildClipsComplete)
				onBuildClipsComplete();
			else
				buildNextClip();
		}
		
		private function onBuildClipsComplete():void{			
			initVideo();
		}
		
		private function initVideo():void{			
			video.play();
		}
		
		private function render(e:ProgressiveSWFVideoEvent):void{			
			currentFrame = e.currentFrame;
			
			for each(var c:CFM_CornerPinClip in clips)
				c.update(currentFrame);
		}	
		
		override protected function removeListeners():void{
			if(video.hasEventListener(ProgressiveSWFVideoEvent.RENDERING))
				video.removeEventListener(ProgressiveSWFVideoEvent.RENDERING, render);
		}
		
		override public function destroy(e:Event):void{
			if(video)
				video.remove();
			
			for each(var c:CFM_CornerPinClip in clips)
				c.remove();
		}
		
		private function getBitmapData(_tag:XML):Vector.<BitmapData>{
			var list:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			if(_tag.@cycle && _tag.@cycle == "true"){
				return definition.bitmapDataList;				
			} else {
				if(definition.bitmapDataList.length > clips.length)
					list[0] = definition.bitmapDataList[clips.length];
				else
					list[0] = definition.bitmapDataList[definition.bitmapDataList.length-1];
			}
			
			return list;
		}
		
		private function get buildClipsComplete():Boolean{
			return clips.length == clipsList.length();
		}
		
		private function get baseURL():String
		{
			var ldrURL:Array=stage.loaderInfo.url.split("/");
			ldrURL.pop();
			var base:String=ldrURL.join("/")+"/";
			return base;
		}
		
		public function play():void{
			if(video) video.play();
		}
		
		public function pause():void{
			if(video) video.pause();
		}
		
		public function setVolume(_percent:Number):void{
			currentVolume = stransform.volume = _percent;
			
			applySoundTransform(); 
		}
		
		public function soundOff():void{
			stransform.volume = 0;
			
			applySoundTransform();
		}
		
		public function soundOn():void{
			stransform.volume = currentVolume;
			
			applySoundTransform();
		}
		
		private function applySoundTransform():void{
			if(video)
				video.soundTransform = stransform;
		}

		
		public function get definition():CFM_PersonlizedVideoDefinition{
			if(!__definition)
				__definition = new CFM_PersonlizedVideoDefinition();
			
			return __definition;
		}
	}
}