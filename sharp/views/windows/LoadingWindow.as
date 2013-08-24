package sharp.views.windows
{
	import cfm.core.vo.CFM_TextFieldParams;
	
	import sharp.model.vo.Vo;

	public class LoadingWindow extends SharpPopupWindowTemplate
	{
		
		private var imageLoader:ImagePreloader;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			buildLoader();
			description.setProperties({x:(_totalWidth - description.width)*.5, y:(_totalHeight - description.height)*.5 -100});
			imageLoader.x = (_totalWidth - imageLoader.width)*.5
			imageLoader.y = description.y + description.height + 5;
			background.visible = false;
			closeButton.visible = false;
		}

		private function buildLoader():void{
			imageLoader = new ImagePreloader();
			_content.addChild(imageLoader);
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		override protected function get descriptionParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.font = Vo.FONT_MEDIUM
			p.wordWrap = false;
			return p;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function LoadingWindow(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
			_totalWidth = 420;
			_totalHeight = 245;
		}
	}
}