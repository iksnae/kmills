<?php
	class ImageVO
	{
		public $id;
		public $image_group;
		public $image_title;
		public $image_caption;
		public $image_path;
		public $image_width;
		public $image_height;
		
		public function parse($row)
		{
			$this->id = (int) $row['id'];	
			$this->image_group = (int) $row['image_group'];	
			$this->image_title = $row['image_title'];
			$this->image_caption = $row['image_caption'];
			$this->image_path = $row['image_path'];
			$this->image_group = $row['image_width '];
			$this->image_group = $row['image_height'];
		}
	}

?>