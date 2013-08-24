package sharp.views.windows.email
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormatAlign;
	
	public class OptInCheckbox extends CFM_SimpleButton
	{
		
		protected var checkBox		:CFM_Graphics;
		//protected var checkIcon		:CheckIcon;
		
		public function OptInCheckbox(_index:Number, _id:String, _value:String, _labelText:String, _paddingH:Number=4, _paddingV:Number=4, _toggle:Boolean=false, _selectState:Boolean=true, _href:String=null)
		{
			super(_index, _id, _value, _labelText, _paddingH, _paddingV, _toggle, _selectState, _href, true);
		}
		
		/*override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = super.backgroundParams;
			p.alphas = [0];
			return p;
		}
		
		override protected function get labelParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = super.labelParams;
			p.font = new Verdana();
			p.size = 12;
			p.color = appModel.uiManager.DESCRIPTION_TEXT_COLOR;
			p.align = TextFormatAlign.LEFT;
			return p;
		}
		
		override protected function buildLabel():void{
			super.buildLabel();
			buildCheckBox();
			label.x = checkBox.width + 5;
			label.y = -2;
		}
		*/
		private function buildCheckBox():void{
			checkBox = new CFM_Graphics(checkBoxParams);
			checkBox.renderTo(labelContainer);
			checkBox.filters = [new DropShadowFilter(3,90,0,.2,4,4,1,3,true)];
			
			/*checkIcon = new CheckIcon();
			labelContainer.addChild(checkIcon);
			checkIcon.x = (checkBox.width - checkIcon.width)*.5 +3;
			checkIcon.y = -5;
			checkIcon.visible =false;*/
		}
		
		protected function get checkBoxParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			
			p.colors 	= [0xffffff];
			p.lineColor = 0x888888;
			p.width 	= 15;
			p.height 	= 15;
			
			return p;
		}

		override protected function toOverState():void{
			killTweens();
			//TweenMax.to(labelContainer, .2, {tint:appModel.uiManager.HEADER_BUTTON_OVER_COLOR, ease:Linear.easeNone});
		}
		
		override protected function toOutState(_tween:Boolean = true):void{
			killTweens();
			//TweenMax.to(labelContainer, _tween ? .2 : 0, {removeTint:true, ease:Linear.easeNone});
		}
		override protected function toSelectedState():void{
			super.toSelectedState();
			//checkIcon.visible = true;
		}
		
		override protected function toUnselectedState():void{
			super.toUnselectedState();
			//checkIcon.visible = false;
		}
		
	}
}