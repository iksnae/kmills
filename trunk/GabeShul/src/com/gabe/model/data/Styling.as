package com.gabe.model.data
{
	/**
	 * I wisth I'd thought of this earlier. It'd make the skinning easier to modify. 
	 * @author iksnae
	 * 
	 */	
	public class Styling
	{
		
		static private var _instance:Styling = null;
		static public function getInstance():Styling
		{
			if(_instance==null)_instance = new Styling():
			return _instance;
		}
	}
}