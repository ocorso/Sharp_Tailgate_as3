package
{
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	import sharp.events.SharpAppEvent;
	
	[SWF(backgroundColor="#999999", width="810", height="840", frameRate="30", quality="HIGH")]
	
	public class SharpTailgate extends Sprite
	{
		
		private var _sharpContext		:SharpContext;
		private var whiteBG				:CFM_Graphics;
		
		public function SharpTailgate()
		{
			ORedUtils.turnOutOn();
			
			Out.info(this, "Welcome to Admin RSVP'S");
			if(stage){
				init(false, stage.loaderInfo.parameters.baseUrl, stage.loaderInfo.parameters.tid);
				Out.debug(this, "baseUrl: "+stage.loaderInfo.parameters.baseUrl);
				Out.warning(this, "tid: "+stage.loaderInfo.parameters.tid);
			}
		}
		
		public function init(likeStatus:Boolean, baseUrl:String, tid:String):void{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			whiteBG = new CFM_Graphics(whiteParams);
			whiteBG.renderTo(this);
			
			_sharpContext = new SharpContext(this);
			_sharpContext.dispatchEvent(new SharpAppEvent(SharpAppEvent.APP_STARTUP_COMPLETE, likeStatus, baseUrl, tid));
		}
		
		private function get whiteParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xffffff];
			p.width = stage.stageWidth;
			p.height = stage.stageHeight;
			return p;
		}
	}
}