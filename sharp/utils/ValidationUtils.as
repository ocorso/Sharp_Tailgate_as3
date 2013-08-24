package sharp.utils
{
	import flash.net.URLVariables;

	public class ValidationUtils
	{
		public function ValidationUtils()
		{
		}
		
		public static function validateYoutubeURL(_url:String):URLVariables{
			var s:String = unescape( _url.substring(_url.indexOf("?")+1) );
			var vars:URLVariables = new URLVariables(s);
			
			return vars;
		}
		
		public static function validateEmail(_txt:String):Boolean{
			var v:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return v.test(_txt);
		}
	}
}