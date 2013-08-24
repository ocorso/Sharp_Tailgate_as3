package sharp.views.windows.response
{
	import net.ored.util.out.Out;
	import sharp.views.windows.SharpPopupWindowTemplate;

	
	public class ResponseWindow extends SharpPopupWindowTemplate
	{
		public function ResponseWindow(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
			if(_params.title){
				xml.heading[0] = _params.title;
				xml.description[0] = _params.message;
			}
			
			_totalWidth = 420;
			_totalHeight = 245;
			
			
		}
		
		override protected function build():void{
			super.build();
			heading.setProperties({y:10});
			if(description) description.setProperties({y:heading.y + heading.height + 10});
			if(pageNavigation) pageNavigation.setProperties({x:_totalWidth - pageNavigation.width - 45});
		}
	}
}