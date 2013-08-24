package cfm.core.interfaces.navigation
{
	public interface CFM_INavigation
	{
		function deActivateButtonByIndex(_index:Number)											:void
		function activateButtonByIndex(_index:Number)											:void
		function deActivateButtonById(_id:String)												:void
		function activateButtonById(_id:String)													:void
		function getButtonLabelText(_id:String)													:String
		function selectButtonById(_id:String, _dispatch:Boolean = false)						:void
		function changeButtonLabelById(_id:String, _label:String, updateSize:Boolean = true)	:void
		function resetButtonLabelById(_id:String)												:void
		function selectButton(_childIndex:Number, _dispatch:Boolean = false)					:void
	}
}