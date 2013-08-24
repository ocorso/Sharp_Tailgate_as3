package sharp.utils
{
	import flash.utils.getDefinitionByName;
	
	import net.ored.util.out.Out;
	
	import sharp.views.windows.LoadingWindow;
	import sharp.views.windows.SharpPopupWindowTemplate;
	import sharp.views.windows.email.EmailWindow;
	import sharp.views.windows.gallery.GalleryWindow;
	import sharp.views.windows.response.ResponseWindow;
	import sharp.views.windows.share.ShareWindow;
	

	public function getPopupWindowDefinition(_index:Number, _xml:XML, _params:Object=null):SharpPopupWindowTemplate
	{
		GalleryWindow, ResponseWindow, ShareWindow, EmailWindow, LoadingWindow
		
		var windowClass:Class = getDefinitionByName("sharp.views.windows." + _xml.@classname) as Class
		var window:SharpPopupWindowTemplate = new windowClass(_index, _xml, _params);
		
		return window;
	}
}