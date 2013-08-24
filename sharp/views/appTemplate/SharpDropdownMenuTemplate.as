package sharp.views.appTemplate
{
	import cfm.core.ui.CFM_DropdownMenu;
	
	import com.greensock.TweenMax;
	
	public class SharpDropdownMenuTemplate extends CFM_DropdownMenu
	{
		public function SharpDropdownMenuTemplate(_index:Number, _id:String, _value:String, _labelText:String, _navigationList:XMLList, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _navigationList, _autoInit, _autoDestroy);
		}
		
		override public function remove():void{
			super.remove();
			TweenMax.killChildTweensOf(this);
		}
	}
}