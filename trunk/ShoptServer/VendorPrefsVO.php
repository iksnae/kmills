<?php
	class VendorPrefsVO
	{
		public $vendor_id;
		public $vendor_name;
		public $vendor_email;
		public $vendor_logo;
		public $vendor_description;
		public $active;
		public $status;
		
		
			
		public function parse($row)
		{
			
			$this->vendor_id= $row['vendor_id'];
			$this->vendor_name= $row['vendor_name'];
			$this->vendor_email= $row['vendor_email'];
			$this->vendor_logo= $row['vendor_logo'];
			$this->vendor_description= $row['vendor_description'];
			$this->active= $row['active'];
			$this->status= $row['status'];
			
	
		
		}
	}

?>