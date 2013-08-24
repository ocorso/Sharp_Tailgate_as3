package
{	
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.loaders.CFM_SWFLoader;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Sine;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	
	public class SharpPreloader extends Sprite
	{
		private var _loader:CFM_SWFLoader;
		private var _percentField:CFM_TextField;
		private var _swfUrl:String;
		//private var _carAnimation:CarLoader;
		
		private var _loaderComplete:Boolean = false;
		private var _timeOutComplete:Boolean = false;
		
		private var _loadPercent:Number = 0;
		private var _timeoutTime:Number = 3;
		private var _grad:CFM_Graphics = new CFM_Graphics();
		private var _skip:Boolean = false;
		private var _tvAnimation:TV_Animation;

		private var _like_status								:Boolean = false;
		
		public function SharpPreloader()
		{
			TweenMax.delayedCall(_timeoutTime, onTimeoutComplete);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_like_status 	= Number(this.loaderInfo.parameters.like_status) == 1 ? true : false;
			_swfUrl 		= this.loaderInfo.parameters.baseUrl+this.loaderInfo.parameters.swfurl;
			
			Out.info(this, _swfUrl);
			//_swfUrl = "Sharp.swf";
			
			_grad = new CFM_Graphics(_gradParams);
			_grad.renderTo(this);
			_grad.visible = false
			
			_loader = new CFM_SWFLoader(_swfUrl,onLoadProgress,onLoadComplete,"ownDomain");
			_loader.renderTo(this);
			
			_tvAnimation = new TV_Animation();
			_tvAnimation.x = (stage.stageWidth-_tvAnimation.width)*.5;
			_tvAnimation.y = ((stage.stageHeight-_tvAnimation.height)*.5) - 80;
			addChild(_tvAnimation);
			_tvAnimation.visible = false;
			
			_percentField = new CFM_TextField("00", percentParmas);
			_percentField.renderTo(this);
			_percentField.setProperties({x:(stage.stageWidth-_percentField.width)*.5 - 5, y:(stage.stageHeight*.5)-_percentField.height - 95});
			_percentField.visible = false;
			_percentField.alpha = 0;
			TweenMax.delayedCall(.5,transitionIn);
		}
		
		private function get _gradParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.height = stage.stageHeight*.5;
			p.y = stage.stageHeight*.5 - 100;
			p.width = stage.stageWidth;
			p.colors = [0xEEEEEE,0xCCCCCC];
			p.alphas = [.5,.5];
			return p;
		}
		
		private function transitionIn():void{
			if(_loadPercent < .95){
				_grad.visible = true
				_percentField.visible = true;
				_tvAnimation.visible = true;
				
				TweenMax.from(_grad, .6, {alpha:0, scaleY:0, delay:.4, y:stage.stageHeight });
				TweenMax.from(_tvAnimation, .5, {delay:.5, ease:Cubic.easeOut, x:stage.stageWidth, onComplete:startTV});
				
			} else {
				_skip = true;
				TweenMax.killDelayedCallsTo(onTimeoutComplete);
				onTimeoutComplete();
			}
		}
		
		private function startTV():void{
			_tvAnimation.gotoAndPlay(2);
			TweenMax.to(_percentField, .3, {delay:.2, alpha:1});
		}
		
		private function stopTV():void{
			_tvAnimation.gotoAndPlay("back");
		}
		
		private function onTimeoutComplete():void{
			_timeOutComplete = true;
			
			if(_loaderComplete)
				transitionOut();
		}
		
		private function onLoadProgress(_percent:Number):void{
			_loadPercent = _percent;
			
			var percentText:String = String(Math.round(_percent*100));
			
			if(percentText.length == 1)
				percentText = "0" + percentText;
			
			if(percentText.length < 3)
				_percentField.text = percentText;
		}
		
		private function onLoadComplete():void{
			_loaderComplete = true;
			
			if(_timeOutComplete)
				transitionOut();
		}
		
		private function transitionOut():void{
			if(_skip){
				initMovie();
			}else {
				TweenMax.delayedCall(.2,stopTV);
				_percentField.text = "99";
				TweenMax.to(_percentField, .4, {delay:.1, alpha:0});
				TweenMax.to(_grad, 1, {ease:Cubic.easeInOut, alpha:0, scaleY:0, delay:.5, y:stage.stageHeight , onComplete:initMovie});
			}
		}
		
		private function initMovie():void{
			destroy();
			
			TweenMax.delayedCall(.2,_loader.movie.init, [_like_status, stage.loaderInfo.parameters.baseUrl, stage.loaderInfo.parameters.tid]);
		}
		
		private function destroy():void{
			removeChild(_tvAnimation);
			removeChild(_percentField);
			removeChild(_grad);
		}
		
		private function get percentParmas():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.size = 80;
			p.color = 0xEEEEEE;
			p.font = Vo.FONT_MYRIAD;
			return p;
		}
	}
}