package cfm.core.managers
{
	public class CFM_FontManager
	{
		[Embed(source='../../fonts/ROCKWELL.TTF', embedAsCFF="false", fontName='Rockwell', unicodeRange='U+0020-007E,U+00AE,U+2122,U+2022')]
		public static var Default:Class;
	}
}