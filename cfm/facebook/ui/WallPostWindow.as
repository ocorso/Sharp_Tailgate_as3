package cfm.facebook.ui
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.objects.CFM_Object;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	import cfm.facebook.FacebookSession;
	import cfm.facebook.vo.WallPostParams;
	
	import com.greensock.TweenMax;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	public class WallPostWindow extends CFM_Object
	{
		private var _session:FacebookSession;
		private var _params:WallPostParams;
		
		private var background:CFM_Graphics;
		
		private var profilePic:Sprite;
		private var image:Sprite;
		
		private var container:CFM_ObjectContainer;
		private var messageField:CFM_TextField;
		private var userName:CFM_TextField;
		private var linkNameField:CFM_TextField;
		private var captionField:CFM_TextField;
		private var descriptionField:CFM_TextField;
		private var postButton:CFM_SimpleButton;
		
		private var margin:Number = 10;
		
		public function WallPostWindow(__session:FacebookSession, __params:WallPostParams, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			_session = __session;
			_params = __params;
			
			super("WallPostWindow", _autoInit, _autoDestroy);
		}
		
		override protected function build():void{
			container = new CFM_ObjectContainer();
			container.renderTo(this);
			container.setProperties({x:margin, y:margin, visible:false, alpha:0});
			
			buildBackground();
			
			buildMessage();
			buildImage();
			buildLinkName();
			buildCaption();
			buildDescription();
			buildPostButton();
			
			setBackgroundSize();
		}
		
		public function update(_imageUrl:String, _newLinkUrl:String, _newLinkName:String):void{		
			_params.imageUrl = _imageUrl;
			_params.linkUrl = _newLinkUrl;
			_params.linkName = _newLinkName;
			
			buildImage();
			linkNameField.text = _params.linkName;
		}
		
		override protected function addListeners():void{
			postButton.addEventListener(CFM_ButtonEvent.CLICKED, onPostClicked, false, 0, true);
		}
		
		override protected function removeListeners():void{
			postButton.removeEventListener(CFM_ButtonEvent.CLICKED, onPostClicked);
		}
		
		public function updateSessionData():void{
			buildProfilePic();
			buildUserName();
		}
		
		public function show():void{
			killTweens();
			
			TweenMax.to(container, .3, {delay:.5, dropShadowFilter:{color:0, alpha:.5, blurX:18, blurY:18, distance:18}, autoAlpha:1});
		}
		
		public function hide():void{
			killTweens();
			
			TweenMax.to(container, .3, {dropShadowFilter:{color:0, alpha:0, blurX:0, blurY:0, distance:0, remove:true}, autoAlpha:0});
		}
		
		private function killTweens():void{
			TweenMax.killTweensOf(container);
		}
		
		private function buildBackground():void{
			background = new CFM_Graphics(backgroundParams);
			background.renderTo(container);
		}
		
		private function buildProfilePic():void{
			if(profilePic)
				if(container.getChildIndex(profilePic) != -1)
					container.removeChild(profilePic);
			
			//profilePic = _appModelodel.loaders.addImage( false, _session.userData.photoUrl,_session.userData.userName, 0, 45, 45);
			container.addChild(profilePic);
		}
		
		private function buildUserName():void{
			if(userName){
				userName.text = _session.userData.userName;
			} else {
				userName = new CFM_TextField(_session.userData.userName,baseTextParams);
				userName.renderTo(container);
				userName.setProperties({x:70});
			}
		}
		
		private function buildImage():void{
			if(image)
				if(container.getChildIndex(image) != -1)
					container.removeChild(image);
			
			//image = _appModelodel.loaders.addImage( false, _params.imageUrl,_params.title, 0, 90, 90, 70, messageField.y + messageField.height + 4);
			container.addChild(image);
		}
		
		private function buildMessage():void{
			messageField = new CFM_TextField(_params.message, messageTextParams);
			messageField.renderTo(container);
			messageField.setProperties({x:70, y:40});
		}
		
		private function buildLinkName():void{
			linkNameField = new CFM_TextField(_params.linkName, baseTextParams);
			linkNameField.renderTo(container);
			linkNameField.setProperties({x:image.x + 90 + 10, y:image.y});
		}
		
		private function buildCaption():void{
			captionField = new CFM_TextField(_params.caption, baseTextParams);
			captionField.renderTo(container);
			captionField.setProperties({x:linkNameField.x, y:linkNameField.y + linkNameField.height + 4 });
		}
		
		private function buildDescription():void{
			descriptionField = new CFM_TextField(_params.description, baseTextParams);
			descriptionField.renderTo(container);
			descriptionField.setProperties({x:linkNameField.x, y:captionField.y + captionField.height + 4});
		}
		
		private function buildPostButton():void{
			postButton = new CFM_SimpleButton(0,"post","post","Post",4,4,false,false);
			postButton.renderTo(container);
			postButton.setProperties({x:messageField.x + messageField.width - postButton.width, y:image.y + 90 - postButton.height});
		}
		
		private function setBackgroundSize():void{
			background.redraw(container.width + (margin*2), container.height + (margin*2), -margin,-margin);
			container.setProperties({x:-container.width*.5, y:-container.height*.5});
		}
		
		private function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.colors = [0xCCCCCC];
			p.corners = [10];
			return p;
		}
		
		private function get baseTextParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			return p;
		}
		
		private function get messageTextParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = baseTextParams;
			p.autoSize = TextFieldAutoSize.NONE;
			p.wordWrap = true;
			p.width = 300;
			p.height = 60;
			p.backgroundColor = 0xFFFFFF;
			return p;
		}
		
		private function onPostClicked(e:CFM_ButtonEvent):void{
			_session.postToWall(_params.linkUrl,_params.title,_params.description,_params.imageUrl,_params.caption);
		}
		
		public function get params():WallPostParams{
			return _params;
		}
	}
}