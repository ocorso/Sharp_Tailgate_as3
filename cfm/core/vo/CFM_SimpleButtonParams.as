package cfm.core.vo
{
	public class CFM_SimpleButtonParams
	{
		private var _index					:Number		= 0;
		private var _id						:String		= "blank";
		private var _value					:String		= "blank";
		private var _paddingH				:Number 	= 4;
		private var _paddingV				:Number 	= 4;
		private var _doesToggle				:Boolean 	= false;
		private var _hasSelectState			:Boolean 	= _doesToggle ? true : false;
		private var _href					:String		= null;
		
		public function CFM_SimpleButtonParams(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}

		public function get index():Number
		{
			return _index;
		}

		public function set index(value:Number):void
		{
			_index = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

		public function get paddingH():Number
		{
			return _paddingH;
		}

		public function set paddingH(value:Number):void
		{
			_paddingH = value;
		}

		public function get paddingV():Number
		{
			return _paddingV;
		}

		public function set paddingV(value:Number):void
		{
			_paddingV = value;
		}

		public function get doesToggle():Boolean
		{
			return _doesToggle;
		}

		public function set doesToggle(value:Boolean):void
		{
			_doesToggle = value;
		}

		public function get hasSelectState():Boolean
		{
			return _hasSelectState;
		}

		public function set hasSelectState(value:Boolean):void
		{
			_hasSelectState = value;
		}

		public function get href():String
		{
			return _href;
		}

		public function set href(value:String):void
		{
			_href = value;
		}
	}
}