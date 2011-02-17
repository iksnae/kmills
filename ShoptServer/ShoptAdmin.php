<?php
	
	include('DBUtil.php');
	include 'ProductVO.php';
	include 'ImageVO.php';
	include 'InventoryVO.php';
	include 'LogVO.php';
	include 'VendorVO.php';
	include 'ItemVO.php';
	
	
	/**
	Shopt Administrative service.
	This service provides methods for managing and accessing Shopt data
	**/
	class ShoptAdmin
	{
	
		/**
		 This method connects to the database.
		 Shared by other methods within this service.
		 **/
		protected function connect()
		{
			$d = new DBUtil();
			$arr = $d->getDBCreds('shopt');
			mysql_connect($arr['DB_HOST'], $arr['DB_USER'], $arr['DB_PASSWORD']) or die(mysql_error());
			mysql_select_db($arr['DB_NAME']) or die(mysql_error());
			return "connection successful";
		}
		
		public function  vendorLogin($username,$password)
		{
			$this->connect();
			$sql = "SELECT * FROM vendors WHERE `username`='".$username."' AND `password`='".$password."'";
			$query = mysql_query($sql) or die ("login failed!");
			
			return mysql_fetch_assoc($query);
			
		
		}
		
		public function checkZendMail()
		{
			set_include_path('/home/iksnaec1/public_html/zend/library');
			require_once 'Zend/Amf/Server.php';
			require_once "Zend/Amf/services/shopt/Client.php";
			$server = new Zend_Amf_Server();
			$server->setClass('Client');
			$response = $server->handle();
			return 'it works';//$response;
		}
		
		
		
		
		/**
		Add a new Product
		- this service method expects a ProducVO object
		**/
		public function addNewProduct($product)
		{
			$this->connect();
			$query = sprintf("insert into products(name,vendor,description,item_id,price,size,image,categories,tags) 
			values('%s','%s','%s','%s','%s','%s','%s','%s','%s')",
			mysql_real_escape_string($product->name),
			mysql_real_escape_string($product->vendor),
			mysql_real_escape_string($product->description),
			mysql_real_escape_string($product->item_id),
			mysql_real_escape_string($product->price),
			mysql_real_escape_string($product->size),
			mysql_real_escape_string($product->image),
			mysql_real_escape_string($product->categories),
			mysql_real_escape_string($product->tags));
			
			$rs = mysql_query($query) or die ("unable to add product!");
			
			return $product;
		}
		
		
		/**
		Add new Image
		- this service expects a ImageVO object
		**/
		public function addNewImage($image)
		{
			$this->connect();
			$query = sprintf("insert into images(image_group,image_title,image_caption,image_path,image_width,image_height)
			values('%s','%s','%s','%s','%s','%s')",
			mysql_real_escape_string($image->image_group),
			mysql_real_escape_string($image->image_title),
			mysql_real_escape_string($image->image_caption),
			mysql_real_escape_string($image->image_path),
			mysql_real_escape_string($image->image_width),
			mysql_real_escape_string($image->image_height));
			
			$rs = mysql_query($query) or die ("unable to add image!");
			
			return $image;
		}
		
		/**
		Add new Inventory
		- this service expects a InventoryVO object
		**/
		public function addNewInventory($inventory)
		{
			$this->connect();
			$query = sprintf("insert into inventory(product_id,quantity)
			values('%s','%s')",
			mysql_real_escape_string($inventory->product_id),
			mysql_real_escape_string($inventory->quantity));
					
			$rs = mysql_query($query) or die ("unable to add inventory!");
			
			return $inventory;
			
		}
		
		/**
		Add new Log
		- this service expects a LogVO object
		**/
		/*
public function addNewLog($log)
		{
			$this->connect();
			$query = sprintf("insert into log(date,actions_type,header,body)
			values('%s','%s','%s','%s')",
			date("c",mysql_real_escape_string($log->
			mysql_real_escape_string($log->date),
			mysql_real_escape_string($log->actions_type),
			mysql_real_escape_string($log->header),
			mysql_real_escape_string($log->body));
			$rs = mysql_query($query) or die ("unable to add log!");
			
			return $log;
			
		}
*/
		
		
		public function testAddNewProduct()
		{
			$prod = new ProductVO();
			$prod->vendor = 2;
			$prod->name = "fake name";
			$prod->description = "fake description";
			$prod->item_id = "fake item_id";
			$prod->price = 3.55;
			$prod->price = 3.55;
			$prod->size = "blue";
			$prod->image = "image";
			$prod->categories = "none";
			$prod->tags = "faketags";
			
			return $this->addNewProduct($prod);
		}
		
		public function testAddNewImage()
		{
			$img = new ImageVO();
			
			$img->image_group = 0;
			$img->image_title = "fake name";
			$img->image_caption = "fake description";
			$img->image_path = "http://www.wallpaper.com/galleryimages/17052105/gallery/01_parismotorshow_ef071010.jpg";
			$img->image_width = 300;
			$img->image_height = 400;
			
			return $this->addNewImage($img);
		}
		
		
		public function testAddNewInventory()
		{
			$inv = new InventoryVO();
			$inv->product_id = 10;
			$inv->quantity = 0;
			
			return $this->addNewInventory($inv);
		}
		
		public function testAddNewLog()
		{
			$log = new LogVO();
			$log->date = new DateTime();
			$log->action_type=0;
			$log->header="fake log header";
			$log->body="fake log body";
			
			return $this->addNewLog($log);
		}
		
		
		
		
		public function addProduct($name, $description, $item_id, $price, $size, $image, $categories, $tags)
		{
			$this->connect();
			
						
			$sqlQuery1="INSERT INTO `iksnaec1_shop`.`products` (`id`, `name`, `description`, `item_id`, `price`, `size`, `image`,`categories`,`tags`) VALUES (NULL, '".$name."', '".$description."', '".$item_id."', '".$price."', '".$size."', '".$image."', '".$categories."', '".$tags."')";
			$query1 = mysql_query($sqlQuery1);
			
			$sqlQuery2="INSERT INTO `iksnaec1_shop`.`log` (`id`, `date`, `action_type`, `header`, `body`) VALUES (NULL, NOW(), 0, 'item added', '".$name."')";
			$query2 = mysql_query($sqlQuery2);
			
			return $query2;
			
		}
		public function updateProduct($id, $name, $description, $item_id, $price, $size, $image, $categories, $tags)
		{
			$this->connect();
			
			$sqlQuery1="UPDATE  `iksnaec1_shop`.`products` SET  `name` =  '".$name."',`description` =  '".$description."', `item_id` =  '".$item_id."', `price` =  '".$price."', `size` =  '".$size."', `image` =  '".$image."', `categories` =  'new cat', `tags` =  '".$tags."' WHERE  `products`.`id` =".$id.";";
			$query1 = mysql_query($sqlQuery1);
			
			
			
			return $query1;
			
		}
		
		public function updateItemQuantity($product_id,$quantity)
		{
		
		}
		//DELETE FROM `iksnaec1_shop`.`products` WHERE `products`.`id` = 9
		public function removeProduct($id)
		{
			$this->connect();
			
			$sqlQuery="DELETE FROM `iksnaec1_shop`.`products` WHERE `products`.`id` = ".$id;
			$query = mysql_query($sqlQuery);
			
			
			return $query;
		}
		
		
		
		
		public function addToInventory($product_id,$quantity)
		{
			$this->connect();
			
			$sqlQuery="INSERT INTO `iksnaec1_shop`.`inventory` (`id`,`product_id`, `quantity`) VALUES (NULL, '".$product_id."', '".$quantity."')";
			$query = mysql_query($sqlQuery);
			
			
			$sqlQuery2="INSERT INTO `iksnaec1_shop`.`log` (`id`, `date`, `action_type`, `header`, `body`) VALUES (NULL, NOW(), 0, 'item added to inventory', 'product id: ".$product_id."')";
			$query2 = mysql_query($sqlQuery2);
			
			return $query;
		}
		
		public function removeItemFromInventory($id)
		{
		
		}
		
	
		
		
		public function addImage($image_group, $image_title, $image_caption,$image_path, $image_width,$image_height)
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
		
		
		
		
		
		public function removeImage($id)
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
		
		public function updateImage($id, $image_group, $image_title, $image_caption,$image_path, $image_width,$image_height)
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
		public function getLog()
		{
			$this->connect();
			
			$sql = "SELECT * FROM log";
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
	
	