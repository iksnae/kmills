<?php

	/**
	  DBUtil for WPServices
	  
	 
	 **/
	
	 
	 
	class DBUtil
	{

		function getDBCreds($site_id)
		{
		
			/**
			MySQL database credentials are stored in a formatted array
			
			**/
			
			// sample array. copy this entry then add to end of listed entries... 
			$db0= array('DB_NAME'=>'databasename', 'DB_USER'=>'username','DB_PASSWORD'=>'password','DB_HOST' =>'dbhost');
			
			
			///////////////////////////////////////////////
			// add database credentials below this line.//
			///////////////////////////////////////////////
			$db1 = array('DB_NAME'=>'iksnaec1_wrdp6',   'DB_USER'=>'iksnaec1_wrdp6',   'DB_PASSWORD'=>'3T1qx1FSg62e',  'DB_HOST' =>'localhost');
			$db2 = array('DB_NAME'=>'iksnaec1_hustlr',   'DB_USER'=>'iksnaec1_hustlr',   'DB_PASSWORD'=>'m4k3m0n3y',  'DB_HOST' =>'localhost');
			$db3 = array('DB_NAME'=>'iksnaec1_wrdp5', '  DB_USER'=>'iksnaec1_wrdp5',   'DB_PASSWORD'=>'FRg4Dg9[FVTL',  'DB_HOST' =>'localhost');
			$db4 = array('DB_NAME'=>'iksnaec1_hhw4dmi', 'DB_USER'=>'iksnaec1_hhw4dmi', 'DB_PASSWORD'=>'M4k3M0n3y',     'DB_HOST' =>'localhost');
			$db5 = array('DB_NAME'=>'iksnaec1_wrdp1',   'DB_USER'=>'iksnaec1_wrdp1',   'DB_PASSWORD'=>'lXeoRQwd{rs5',  'DB_HOST' =>'localhost');
			$db6 = array('DB_NAME'=>'iksnaec1_gs',   'DB_USER'=>'iksnaec1_gs',   'DB_PASSWORD'=>'gsadmin',  'DB_HOST' =>'localhost');
			$db7 = array('DB_NAME'=>'iksnaec1_shop',   'DB_USER'=>'iksnaec1_shopdev',   'DB_PASSWORD'=>'cwaZxb6aAzey',  'DB_HOST' =>'localhost');
			$db8 = array('DB_NAME'=>'iksnaec1_prodlist',   'DB_USER'=>'iksnaec1_shopdev',   'DB_PASSWORD'=>'cwaZxb6aAzey',  'DB_HOST' =>'localhost');
			
			//Added user hustlr with the password m4k3m0n3y.
		
			
			///////////////////////////////////////////////
			// add database credentials before this line.//
			///////////////////////////////////////////////
			
			
			
			
		
			/**
			 the credential arrays are stored by a unique string in the list array
			 - add database credential array to the list array to make available
			**/
			$list = array(
				
				'gs'=>$db1 ,
				'hustlr'=>$db2 ,
				'wpcms'=>$db3,
				'hhw'=>$db4,
				'iksnae'=>$db5,
				'gs2'=>$db6,
				'shopt'=>$db7,
				'prodlist'=>$db8
				
			);
			
			
		
			
			
			
			return $list[$site_id];
		}
		
	} // END class 

?>