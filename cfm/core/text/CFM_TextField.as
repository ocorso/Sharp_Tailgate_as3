package cfm.core.text
{
	import cfm.core.vo.CFM_TextFieldParams;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CFM_TextField extends TextField
	{
		private var __text			:String;
		private var params			:CFM_TextFieldParams;
		private var format			:TextFormat = new TextFormat();
		
		public function CFM_TextField(_text:String, _params:CFM_TextFieldParams = null)
		{		
			__text 					= _text ? _text : "";
			params 					= _params ? _params : new CFM_TextFieldParams();
			
			init();
		}
		 
		private function init():void{
			format.font 				= params.fontName;
			format.color 				= params.color;
			format.size 				= params.size;
			format.leading 				= params.leading;
			format.indent 				= params.indent;
			format.letterSpacing 		= params.letterSpacing;
			format.align 				= params.align;
			format.underline 			= params.underline;
			format.leftMargin 			= params.leftMargin;
			format.rightMargin			= params.rightMargin;
			format.bullet				= params.bullet;
			format.url					= params.url;
			format.italic				= params.italic;
			format.tabStops				= params.tabStops;
		
			width 						= height = 2;
			defaultTextFormat 			= format;
			multiline					= params.multiline;
			displayAsPassword 			= params.displayAsPassword;
			embedFonts 					= params.embedFonts; 
			selectable 					= params.isInput ? true : params.selectable;
			antiAliasType 				= params.antiAliasType;
			wordWrap 					= params.wordWrap;
			autoSize 					= TextFieldAutoSize.LEFT;
			background					= !isNaN(params.backgroundColor) ? true : false;
			type 						= params.type;
			
			if(params.styleSheet)
				styleSheet = params.styleSheet;
			
			if(!params.isHtml || params.isInput)
				text = __text;
			else
				htmlText = __text;
			
			if(!isNaN(params.width))
				width = params.width;
			
			if(!isNaN(params.height))
				height = params.height;
			
			if(!isNaN(params.maxChars))
				maxChars = params.maxChars;
			
			if(!isNaN(params.backgroundColor))
				backgroundColor = params.backgroundColor;
			
			autoSize 					= !isNaN(params.height) ? TextFieldAutoSize.NONE : params.autoSize;
		}
		
		public function renderTo(_parent:DisplayObjectContainer):void{
			_parent.addChild(this);
		}
		
		public function remove():void{
			this.parent.removeChild(this);
		}
		
		public function setProperties(_prop:Object):void{
			for (var p:String in _prop){
				if(p=="x" || p=="y" || p=="width" || p=="height")
					this[p] = Math.round(_prop[p]); 
				else
					this[p] = _prop[p]; 
			}
		}
	}
}