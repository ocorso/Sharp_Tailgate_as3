package sharp.views.appTemplate
{
	import cfm.core.buttons.CFM_SimpleButton;
	
	import com.greensock.TweenMax;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class SharpButtonTemplate extends CFM_SimpleButton
	{

		
		public function SharpButtonTemplate(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);

		}
		
		override protected function openLink():void{
			navigateToURL(new URLRequest(href), "_blank");
		}
		
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}
	}
}