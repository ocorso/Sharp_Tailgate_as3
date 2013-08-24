package sharp.utils
{
	import com.carlcalderon.arthropod.Debug;

	public class FacebookUtils
	{

		/**
		 * Converts JSON Object of Facebook Album data into XML that can be consumed by a CFM_SimpleNavigation
		 * Added attributes are:
		 * 		id				- photo id of the album's cover photo
		 * 		album_id		- id of the facebook album
		 * 		count			- number of photos within the album 
		 * @param $data			- JSON Object returned by facebook graph call.
		 * 
		 * @return 				- a new XMLList of the album data.
		 * 
		 */		
		public static function parseAlbumDataToNavXML($data:Array):XMLList{
			var s:String	= "<navigation>";
			for (var i:* in $data){
				
				if($data[i]['count'] > 0){//oc: don't let empty albums in the list.
					s 	+= "<button value='select-album' ";
					s	+= "id='"+ $data[i]['cover_photo'] +"'";
					s	+= " album_id='"+$data[i]['id']+"'";
					s	+= " count='"+ $data[i]['count'] +"'";
					s	+= "><label><![CDATA["+$data[i].name+"]]></label></button>";
				}
			}
			s+= "</navigation>";
			var xml:XML = new XML(s);
			
			return xml.children();
		}
		/**
		 * Converts JSON Object of Facebook Album data into XML that can be consumed by a CFM_SimpleNavigation
		 * Added attributes are:
		 * 		id				- photo id of the album's cover photo
		 * 		album_id		- id of the facebook album
		 * 		count			- number of photos within the album 
		 * @param $data			- JSON Object returned by facebook graph call.
		 * 
		 * @return 				- a new XMLList of the album data.
		 * 
		 */		
		public static function parseAlbumImagesToNavXML($data:Array):XMLList{
			var s:String	= "<navigation>";
			for (var i:* in $data){
				
				s 	+= "<button value='select-image' ";
				s	+= "id='"+ $data[i]['id'] +"'";
				s	+= "><label><![CDATA[]]></label></button>";
			}
			s+= "</navigation>";
			var xml:XML = new XML(s);
			
			return xml.children();
		}
		
		public static function getImageUrlForGalleryFromAlbumData($id:String, $imgs:Array):String{
			
			var url:String = "not found";
			
			for each(var o:Object in $imgs){
				if (o.id == $id){
					url = o.images[1].source;
					Debug.log(url);
					break;
				}
					
			}
			return url;
		}
	}
}