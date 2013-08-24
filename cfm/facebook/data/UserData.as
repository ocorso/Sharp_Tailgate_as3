package cfm.facebook.data
{
	public class UserData
	{
		public var index:Number;
		public var userId:String;
		public var userName:String;
		public var name:String;
		public var photoSize:String;
		public var photoUrl:String;
		
		public function UserData(_index:Number, _id:String, _username:String, _name:String, _photoSize:String = "square")
		{
			index = _index;
			userId = _id;
			userName = _name;
			name = _name
			photoSize = _photoSize;
			photoUrl = "http://graph.facebook.com/"+userId+"/picture?type="+photoSize;
		}
	}
}