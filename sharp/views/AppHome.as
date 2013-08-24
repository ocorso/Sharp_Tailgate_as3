package sharp.views
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.factories.CFM_WindowFactory;
	
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpWindowEvent;
	import sharp.model.vo.Vo;
	import sharp.utils.getPageDefinition;
	import sharp.utils.getPopupWindowDefinition;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.themeModule.ThemePage;
	import sharp.views.windows.SharpPopupWindowTemplate;
	
	public class AppHome extends CFM_ObjectContainer
	{
		private var sharpLogo					:SharpLogo;
		private var aquosLogo					:AquosLogo;
	
		private var _pageContainer				:CFM_ObjectContainer;
		private var _windowContainer			:CFM_ObjectContainer;
		
		private var _currentPage				:SharpPageTemplate;
		private var _currentWindow				:SharpPopupWindowTemplate;
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		

		public function buildLogos():void{
			sharpLogo = new SharpLogo();
			addChild(sharpLogo);

			sharpLogo.x = Vo.MARGIN_LEFT;
			sharpLogo.y = Vo.MARGIN_TOP;
			
			TweenMax.from(sharpLogo, .5, {alpha:0});
		}
		
		public function changePage(_pageData:XML):void{
			if(currentPage) currentPage.remove();
			_currentPage = getPageDefinition(0,_pageData);
			_currentPage.renderTo(_pageContainer);
		}
		
		public function changeWindow(_windowData:XML, _params:Object):void{
			if(currentWindow) currentWindow.remove();
			_currentWindow = getPopupWindowDefinition(0,_windowData, _params);
			_currentWindow.renderTo(_windowContainer);
			_currentWindow.resize(stage.stageWidth, stage.stageHeight);
		}

		public function buildContainers():void{
			_pageContainer = new CFM_ObjectContainer();
			_pageContainer.renderTo(this);
			
			_windowContainer = new CFM_ObjectContainer();
			_windowContainer.renderTo(this);
			_windowContainer.setProperties({x:stage.stageWidth*.5, y:stage.stageHeight*.5});
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

		public function get currentPage():SharpPageTemplate{
			return _currentPage;
		}
		
		public function get currentWindow():SharpPopupWindowTemplate{
			return _currentWindow;
		}

		
		// =============x====================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function AppHome()
		{
			super(true);

		}

	}
}