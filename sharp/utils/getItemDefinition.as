package sharp.utils
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	public function getItemDefinition(_class:String):MovieClip
	{
		
		Balloon, Cups, Finger, Helmet, Lamp, Banner, PomPom
		
		var itemClass:Class 	= getDefinitionByName(_class) as Class;
		var item:MovieClip 	= new itemClass() as MovieClip;
		
		return item;
	}
}