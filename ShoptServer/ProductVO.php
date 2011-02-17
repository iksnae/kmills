<?php
	
	class ProductVO
	{
		public $id;
		public $vendor;
		public $name;
		public $description;
		public $item_id;
		public $price;
		public $size;
		public $options;
		public $image;
		public $category;
		public $categories;
		public $tags;
		
		public function parse($row)
		{

			$this->id = $row['id'];	
			$this->vendor = $row['vendor'];	
			$this->name = $row['name'];
			$this->description = $row['description'];
			$this->item_id = $row['item_id'];
			$this->image = $row['image'];
			$this->size = $row['size'];
			
			$this->price = $row['price'];
			$this->option = $row['option'];
			$this->category = $row['category'];
			$this->tags = $row['tags'];
		
		}
	}

?>