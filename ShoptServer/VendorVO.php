<?php
	class VendorVO
	{
		public $vid;
		public $key;
		
		
		public function parse($row)
		{

			$this->vid = $row['vid'];
			$this->key = $row['key'];
		}
	}

?>