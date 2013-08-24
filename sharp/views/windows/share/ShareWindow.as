package sharp.views.windows.share
{
	import cfm.core.events.CFM_NavigationEvent;
	
	import flash.external.ExternalInterface;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpWindowEvent;
	import sharp.views.windows.SharpPopupWindowTemplate;


	public class ShareWindow extends SharpPopupWindowTemplate
	{
		public function ShareWindow(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
			_totalWidth = 420;
			_totalHeight = 245;
		}
		
		override protected function build():void{
			super.build();
			heading.setProperties({y:10});
			description.setProperties({y:heading.y + heading.height + 10});
			pageNavigation.setProperties({x:15});
		}
	}
}