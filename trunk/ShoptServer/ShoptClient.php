<?php
	
	include('DBUtil.php');
	include 'ProductVO.php';
	include 'ImageVO.php';
	
	class ShoptClient
	{
	
	
		protected function connect()
		{
			$d = new DBUtil();
			$arr = $d->getDBCreds('shopt');
			mysql_connect($arr['DB_HOST'], $arr['DB_USER'], $arr['DB_PASSWORD']) or die(mysql_error());
			mysql_select_db($arr['DB_NAME']) or die(mysql_error());
		}
		
		
		public function getInventory()
		{
			$this->connect();
			$sql = "SELECT * FROM inventory";
			$query = mysql_query($sql);
			$result = array();
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_object($query))
				{
					$result[] = $row;
				}
				mysql_free_result($query);
			}
			return $result;
		}
		
		
		
		
		
		
		public function getImages()
		{
			$this->connect();
			$sql = "SELECT * FROM images";
			$query = mysql_query($sql);
			$result = array();
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_assoc($query))
				{
					$image = new ImageVO();
					$image->parse($row);
					array_push($result,$product);
				}
			}
			return $result;
		}
		
		
		
		
		
		
		public function getPreferences()
		{
			$this->connect();
			$sql = "SELECT * FROM preferences";
			$query = mysql_query($sql);
			$result = array();
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_object($query))
				{
					$result[] = $row;
				}
				mysql_free_result($query);
			}
			return $result;
		}
		
		
		
		
		public function getAllProducts()
		{
			
			
			$this->connect();
			$sql = "SELECT * FROM products";
			$query = mysql_query($sql);
			$result = array();
			
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_assoc($query))
				{
				
					$product = new ProductVO();
					$product ->parse($row);
					array_push($result,$product);
				}
			}
			return $result;
		}
		
		
		
		
		public function getVendorProducts($vendor)
		{
			
			
			$this->connect();
			$sql = "SELECT * FROM products WHERE vendor=".$vendor;
			$query = mysql_query($sql);
			$result = array();
			
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_assoc($query))
				{
				
					$product = new ProductVO();
					$product ->parse($row);

	
					array_push($result,$product);
					
				}
			}
			return $result;
		}
		
		
		
		
		public function getAllImages()
		{
			$this->connect();
			$sql = "SELECT * FROM images";
			$query = mysql_query($sql);
			$result = array();
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_object($query))
				{
					$result[] = $row;
				}
				mysql_free_result($query);
			}
			return $result;
		}
		
		
		
		
		
		
		public function getImageGroup($group_id)
		{
			$this->connect();
			$sql = "SELECT * FROM images WHERE `image_group`='".$group_id."'";
			$query = mysql_query($sql);
			$result = array();
			if(mysql_num_rows($query) > 0)
			{
				while($row = mysql_fetch_object($query))
				{
					$result[] = $row;
				}
				mysql_free_result($query);
			}
			return $result;
		}
		
		
	}