package sharp.views.facebookModule.vo
{
	import net.ored.util.out.Out;

	public class FacebookData
	{
		public var index						:Number;
		public var userId						:String;
		public var userName						:String;
		public var name							:String;
		public var photoSize					:String;
		public var photoUrl						:String;
		private var _friends					:Vector.<FacebookData>;
		private var _albums						:Array;
		public var authToken					:String;
		
		
		public function FacebookData(_index:Number, _id:String, _username:String, _name:String, _photoSize:String, $friends:Vector.<FacebookData>)
		{
			index 		= _index;
			userId 		= _id;
			userName 	= _name;
			name 		= _name
			photoSize 	= _photoSize;
			photoUrl 	= "http://graph.facebook.com/"+userId+"/picture?type="+photoSize;
			friends		= $friends;
		}
		
		public function isMyFriend(_userId:String):Boolean{
			var isFriend:Boolean = false;
			
			for each(var ud:FacebookData in _friends){
				if(ud.userId == _userId){
					isFriend = true;
					break;
				}
			}
			
			Out.status(this, "isMyFriend :: "+ isFriend);
			
			return isFriend;
		}
		
		public function isMe(_userId:String):Boolean{
			return userId == _userId;
		}
		
		public function set friends($value:Vector.<FacebookData>):void{
			_friends = $value;
		}

		public function get albums():Array
		{
			return _albums;
		}

		public function set albums(value:Array):void
		{
			_albums = value;
		}

	}
}