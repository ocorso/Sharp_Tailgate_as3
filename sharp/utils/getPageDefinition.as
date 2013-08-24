package sharp.utils
{

	import flash.utils.getDefinitionByName;
	
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.customizeModule.CustomizePage;
	import sharp.views.galleryModule.GalleryPage;
	import sharp.views.themeModule.ThemePage;
	
	public function getPageDefinition(_index:Number, _xml:XML, _params:Object=null):SharpPageTemplate
	{
		ThemePage, CustomizePage, GalleryPage

		var pageClass:Class 	= getDefinitionByName("sharp.views." + _xml.@classname) as Class;
		var page:SharpPageTemplate 	= new pageClass(_index, _xml, _params);

		return page;
	}
}