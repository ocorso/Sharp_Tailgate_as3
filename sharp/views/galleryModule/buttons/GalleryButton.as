package sharp.views.galleryModule.buttons
{
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpButtonTemplate;
	
	public class GalleryButton extends SharpButtonTemplate
	{
		private var imageUrl				:String;
		private var userName				:String;
		private var userNameField			:CFM_TextField;
		private var thumb					:ContentDisplay;
		private var imagePreloader			:ImagePreloader;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function buildLabel():void{
			super.buildLabel();
			label.text = labelText;
		}
		override protected function build():void{
			super.build();
			buildImagePreloader();
			buildImage();
			buildUserName();
		}
		private function buildImage():void{
			var loader:ImageLoader = new ImageLoader(imageUrl, 
				{
					container:labelContainer,
					noCache:true,
					width:Vo.GALLERY_THUMB_WIDTH,
					height:Vo.GALLERY_THUMB_HEIGHT,
					onComplete:onImageLoad
				});
			loader.load();
		}
		
		private function buildUserName():void{
			userNameField = new CFM_TextField("by: " + userName, userNameParams);
			userNameField.renderTo(labelContainer);
			label.y = Vo.GALLERY_THUMB_HEIGHT + 6;
			userNameField.y = label.y + label.height-2;
		}
		
		private function buildImagePreloader():void{
			imagePreloader = new ImagePreloader();
			labelContainer.addChild(imagePreloader);
			imagePreloader.x = (Vo.GALLERY_THUMB_WIDTH - imagePreloader.width)*.5;
			imagePreloader.y = (Vo.GALLERY_THUMB_WIDTH - imagePreloader.height)*.5;
		}
		
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onImageLoad(event:LoaderEvent):void {
			thumb = event.target.content;
			if(labelContainer.contains(imagePreloader))labelContainer.removeChild(imagePreloader);
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.font = Vo.FONT_MEDIUM;
			p.size = 14;
			p.width = Vo.GALLERY_THUMB_WIDTH;
			p.wordWrap = true;
			return p;
		}
		
		private function get userNameParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = 0x646464;
			p.font = Vo.FONT_ARIAL;
			p.size = 12;
			return p;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.alphas = [0];
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function resizeGraphics():void{
			_hitWidth = Vo.GALLERY_THUMB_WIDTH;
			_hitHeight = Vo.GALLERY_THUMB_HEIGHT + 25;
			super.resizeGraphics();
		}
		
		override protected function toOverState():void{
		}
		
		override protected function toOutState(_tween:Boolean=true):void{
		}
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function GalleryButton(_userName:String, _index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null, _active:Boolean=true, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, _active, _autoInit, _autoDestroy);
			imageUrl = _value;
			userName = _userName;
			
			if(!_labelText) _labelText = "MY TAILGATE";	

		}
	}
}