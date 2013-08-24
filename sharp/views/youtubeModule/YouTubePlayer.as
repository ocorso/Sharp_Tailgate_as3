﻿/***************************** Manuel Gonzalez           ** design@stheory.com        ** www.stheory.com           ** www.codingcolor.com       ******************************/package sharp.views.youtubeModule{	import cfm.core.containers.CFM_ObjectContainer;	import cfm.core.events.CFM_VideoStreamEvent;	import cfm.core.graphics.CFM_Graphics;	import cfm.core.objects.CFM_Object;		import com.greensock.TweenMax;		import flash.display.Loader;	import flash.display.StageDisplayState;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.events.IOErrorEvent;	import flash.events.MouseEvent;	import flash.media.SoundMixer;	import flash.net.URLRequest;	import flash.system.Security;	import flash.system.System;		import net.ored.util.out.Out;		import sharp.model.vo.Vo;	import sharp.views.youtubeModule.event.YoutubeEvent;	import sharp.views.youtubeModule.vo.YoutubeData;
	
	public class YouTubePlayer extends CFM_ObjectContainer {				private var _youTubePlayer:Object;		private var _loader:Loader;		private var _container:*				private var progressRatio:Number; //returns the ratio difference between the bytes loaded and the bytes total, from 0 to 1, (usefull for the progress bar)		private var fullnessRatio:Number; //returns the ratio difference between the playhead and the total seconds, from 0 to 1, (usefull for the fullness bar)		private var playerStatus:String;				private var _youtubeData		:YoutubeData;				public var controlButton		:ControlButton;			private var videoHitArea		:CFM_Graphics;						public function YouTubePlayer(target:IEventDispatcher=null) {			//super(target);		}		/*		Method:createPlayer		*/		public function get youtubeData():YoutubeData
		{
			return _youtubeData;
		}		public function set youtubeData(value:YoutubeData):void
		{
			_youtubeData = value;
		}				public function buildControlButton(_stageWidth:Number, _stageHeight:Number):void{			if(!controlButton){				controlButton = new ControlButton();				addChild(controlButton);				controlButton.x = (_stageWidth - controlButton.width)*.5;				controlButton.y = (_stageHeight - controlButton.height)*.5;				controlButton.alpha = 0;				controlButton.visible = false;				controlButton.playIcon.visible = false;				controlButton.buttonMode = true;				controlButton.addEventListener(MouseEvent.CLICK, controlButtonClicked, false, 0, true);				controlButton.addEventListener(MouseEvent.ROLL_OVER, controlButtonOvered, false, 0, true);			}		}				public function buildHitArea(_stageWidth:Number, _stageHeight:Number):void{			videoHitArea = new CFM_Graphics();			videoHitArea.renderTo(_container);			videoHitArea.width = _stageWidth;			videoHitArea.height = _stageHeight*.7;			videoHitArea.visible = false;			videoHitArea.alpha = 0;			addRollover();		}		public function createPlayer():void 		{			_container = this;			var _loader:Loader = new Loader();			_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			_loader.load(new URLRequest(Vo.YOUTUBE_PLAYPATH));		}		/*		Method: duration		 Returns the duration in seconds of the currently playing video. 		 Note that getDuration() will return 0 until the video's metadata is loaded, 		 which normally happens just after the video starts playing.		*/		public function get duration():Number		{			return _youTubePlayer.getDuration();		}		/*		Method:videoUrl		 Returns the YouTube.com URL for the currently loaded/playing video.		*/		public function get videoUrl():String		{			return _youTubePlayer.getVideoUrl();		}   		/*		Method:embedCode		 Returns the embed code for the currently loaded/playing video. 		*/		public function get embedCode():String		{			return _youTubePlayer.getVideoEmbedCode();		}   				/*		Method: volume()		Returns the player's current volume, an integer between 0 and 100. 		Note that getVolume() will return the volume even if the player is muted.		*/		public function get volume():Number		{		 return _youTubePlayer.getVolume();		}				/*		Method: VideoBytesLoaded		Returns the number of bytes loaded for the current video.		*/		public function get VideoBytesLoaded():Number		{			return _youTubePlayer.getVideoBytesLoaded();		}    		/*		Method: VideoBytesTotal		Returns the size in bytes of the currently loaded/playing video.		*/		public function get VideoBytesTotal():Number		{			return _youTubePlayer.getVideoBytesTotal();		}    			/*		Method: VideoStartBytes		Returns the number of bytes the video file started loading from. 		Example scenario: the user seeks ahead to a point that hasn't loaded yet, 		and the player makes a new request to play a segment of the video that hasn't loaded yet.		*/		public function get VideoStartBytes():Number		{			return _youTubePlayer.getVideoStartBytes();		}   		/*		Method:PlayerState		Returns the state of the player. Possible values are unstarted (-1), ended (0), playing (1), 		paused (2), buffering (3), video cued (5).		*/		public function get PlayerState():Number		{		 	return _youTubePlayer.getPlayerState();		}    	/*		Method: CurrentTime		Returns the elapsed time in seconds since the video started playing.		*/		public function get CurrentTime():Number		{			return _youTubePlayer.getCurrentTime()		}     	/*		Method: PlaybackQuality		This function retrieves the actual video quality of the current video. 		It returns undefined if there is no current video. Possible return values are:		hd720, large, medium and small.		*/		public function get PlaybackQuality():String		{			return _youTubePlayer.getPlaybackQuality();		}		/*		Method: PlaybackQuality		This function sets the suggested video quality for the current video. 		The function causes the video to reload at its current position in the new quality. 		If the playback quality does change, it will only change for the video being played.		*/		public function set PlaybackQuality(suggestedQuality:String):void		{    		_youTubePlayer.setPlaybackQuality(suggestedQuality);		}    			//////////////////////////////////////////////////////////////////////////////////////////////				/*		Method: cueVideoById		Loads the specified video's thumbnail and prepares the player to play the video. 		The player does not request the FLV until playVideo() or seekTo() is called. 		*/		public function cueVideoById(_id:String, startSeconds:Number=0, suggestedQuality:String="default"):void		{			_youTubePlayer.cueVideoById(_id, startSeconds, suggestedQuality);		}		/*		Method:loadVideoById		Loads and plays the specified video. 		*/		public function loadVideoById(startSeconds:Number=0, suggestedQuality:String="default"):void		{			_youTubePlayer.loadVideoById(youtubeData.videoId, startSeconds, suggestedQuality);		}		/*		Method:cueVideoByUrl		Loads the specified video's thumbnail and prepares the player to play the video. 		The player does not request the FLV until playVideo() or seekTo() is called. 		*/		public function cueVideoByUrl(startSeconds:Number=0):void		{			_youTubePlayer.cueVideoByUrl(youtubeData.videoId, startSeconds);		}		/*		Method:playVideo		 Plays the currently cued/loaded video.		*/		public function playVideo():void		{			_youTubePlayer.playVideo();		}  		/*		Method:pauseVideo		Pauses the currently playing video.		*/		public function pauseVideo():void		{			_youTubePlayer.pauseVideo();		}    	/*		Method: stopVideo		Stops the current video. This function also cancels the loading of the video.		*/		public function stopVideo():void		{			_youTubePlayer.stopVideo();		}    	/*		Method: seekTo		Seeks to the specified time of the video in seconds. 		The seekTo() function will look for the closest keyframe before the seconds specified. 		This means that sometimes the play head may seek to just before the requested time, 		usually no more than ~2 seconds.		*/				public function seekTo(seconds:Number, allowSeekAhead:Boolean):void		{			_youTubePlayer.seekTo(seconds, allowSeekAhead);			playVideo();		}				/*		Method:		 Mutes the player.		*/		public function mute():void		{			_youTubePlayer.mute();		}   		/*		Method: unMute		Unmutes the player.		*/		public function unMute():void		{			_youTubePlayer.unMute();		}    		/*		Method: isMuted		Returns true if the player is muted, false if not.		*/		public function isMuted():Boolean		{			return _youTubePlayer.isMuted();		}    		/*		Method: setVolume		 Sets the volume. Accepts an integer between 0 and 100.		*/		public function setVolume(inVolume:Number):void		{			_youTubePlayer.setVolume(inVolume);		}    	/*		Method:setSize		Sets the size in pixels of the player. 		This method should be used instead of setting the width and height properties 		of the MovieClip. Note that this method does not constrain the proportions of 		the video player, so you will need to maintain a 4:3 aspect ratio. 		The default size of the chromeless SWF when loaded into another SWF is 320px by 240px 		and the default size of the embedded player SWF is 480px by 385px. 		*/		public function setSize(inWidth:Number, inHeight:Number):void		{			_youTubePlayer.setSize(inWidth, inHeight);		}     		/*		Method: loadVideoByUrl		This function, which loads and plays the specified video, 		has not yet been implemented for the ActionScript 3.0 Player API.		*/		public function loadVideoByUrl(mediaContentUrl:String, startSeconds:Number=0):void		{			_youTubePlayer.loadVideoByUrl(mediaContentUrl, startSeconds);		}						private function addRollover():void{			Out.info(this, "add rover");			videoHitArea.addEventListener(MouseEvent.MOUSE_MOVE, onPlayerOver, false, 0, true);			videoHitArea.addEventListener(MouseEvent.MOUSE_OUT, onPlayerOut, false, 0, true);		}				private function removeRollover():void{			if(videoHitArea){				videoHitArea.removeEventListener(MouseEvent.MOUSE_MOVE, onPlayerOver);				videoHitArea.removeEventListener(MouseEvent.MOUSE_OUT, onPlayerOut);			}			if(controlButton){				controlButton.removeEventListener(MouseEvent.CLICK, controlButtonClicked);				controlButton.removeEventListener(MouseEvent.MOUSE_MOVE, controlButtonOvered);			}					}				private function controlButtonClicked(e:MouseEvent):void{						Out.info(this, "clicked" + PlayerState);			dispatchEvent(new YoutubeEvent(YoutubeEvent.CONTROL_BUTTON_CLICKED, Vo.youtube));					}				private function controlButtonOvered(e:MouseEvent):void{			showControl();		}				private function onPlayerOver(e:MouseEvent):void{			showControl();		}				private function onPlayerOut(e:MouseEvent):void{			TweenMax.delayedCall(.3, hideControl);		}				public function showControl():void{			TweenMax.killDelayedCallsTo(hideControl);			TweenMax.to(controlButton, .3, {autoAlpha:1});		}				private function hideControl():void{			if(PlayerState == 1) TweenMax.to(controlButton, .3, {autoAlpha:0});		}		/*		Method: destroy		This function, which has not yet been implemented for the AS3 Player API, 		destroys the player instance. This method should be called before unloading 		the player SWF from your parent SWF.		*/		public function destroyVideo():void		{			if(_youTubePlayer) _youTubePlayer.destroy();		}		private function onLoaderInit(event:Event):void {			var player:Loader = Loader(event.target.loader);			_youTubePlayer = player.content;			_youTubePlayer.addEventListener("onReady", onPlayerReady);			_youTubePlayer.addEventListener("onError", onPlayerError);			_youTubePlayer.addEventListener("onStateChange", onPlayerStateChange);			_youTubePlayer.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);			_container.addChildAt(_youTubePlayer, 0);						_loader = null;		}		private function ioErrorHandler(event:IOErrorEvent):void {			dispatchEvent(new YoutubeEvent(YoutubeEvent.ON_IOERROR,youtubeData));        }		private function onPlayerReady(event:Event):void {			dispatchEvent(new YoutubeEvent(YoutubeEvent.ON_READY,youtubeData));		}		private function onPlayerError(event:Event):void {			dispatchEvent(new YoutubeEvent(YoutubeEvent.ON_ERROR,youtubeData));		}		private function onPlayerStateChange(event:Event):void {			if(PlayerState == 1) {				Out.info(this, "show hitarea");				videoHitArea.visible = true;			}			dispatchEvent(new YoutubeEvent(YoutubeEvent.ON_CHANGE,youtubeData));		}		private function onVideoPlaybackQualityChange(event:Event):void {			dispatchEvent(new YoutubeEvent(YoutubeEvent.ON_QUALITY_CHANGED,youtubeData));		}				public function trackProgress():void {						progressRatio = VideoBytesLoaded / VideoBytesTotal;			fullnessRatio = CurrentTime/duration;						dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.PROGRESS, fullnessRatio, progressRatio));						if(fullnessRatio == 1) dispatchEvent(new CFM_VideoStreamEvent(CFM_VideoStreamEvent.COMPLETE, fullnessRatio, progressRatio));		}				override public function destroy(e:Event):void{			super.destroy(e);			removeRollover();			destroyVideo();		}	}}