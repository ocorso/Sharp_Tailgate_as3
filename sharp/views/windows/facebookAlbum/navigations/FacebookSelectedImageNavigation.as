package sharp.views.windows.facebookAlbum.navigations
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.interfaces.util.CFM_IResize;
	import cfm.core.managers.CFM_ResizeManager;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormatAlign;
	
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.AppMainButton;
	
	public class FacebookSelectedImageNavigation extends CFM_ObjectContainer
	{
		
		public var thumbContainer			:CFM_ObjectContainer;
		public var message					:CFM_TextField;
		
		public function FacebookSelectedImageNavigation(_autoDestroy:Boolean=true)
		{
			super(_autoDestroy);
			
			thumbContainer = new CFM_ObjectContainer;
			thumbContainer.renderTo(this);
			
			var param:CFM_TextFieldParams = new CFM_TextFieldParams({size:12, leading:4, font:Vo.FONT_MEDIUM, color:0x333333, bullet:true, multiline:true, wordWrap:true, width:170, align:TextFormatAlign.LEFT});
			
			message = new CFM_TextField("Choose up to 5 photos for slideshow\n<br/>You can drag a photo to arrage or tap x button to remove a photo from the list", param);
			message.renderTo(this);
			message.x = -50;
		}
		
	}
}