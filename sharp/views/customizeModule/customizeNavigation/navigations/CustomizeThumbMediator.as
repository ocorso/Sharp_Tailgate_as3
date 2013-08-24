package sharp.views.customizeModule.customizeNavigation.navigations
{
	
	import cfm.core.events.CFM_NavigationEvent;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.model.Model;
	
	public class CustomizeThumbMediator extends Mediator
	{
		[Inject]
		public var view:CustomizeThumbNavigation;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			
			view.primaryColor = _m.themeParams.primaryColor;
			view.secondaryColor = _m.themeParams.secondaryColor;
		}
		
		
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
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
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function CustomizeThumbMediator()
		{
			super();
		}
	}
}