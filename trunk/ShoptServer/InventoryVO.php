<?php
	class InventoryVO
	{
		public $id;
		public $product_id;
		public $quantity;
	
		
		public function parse($row)
		{
			$this->id = (int) $row['id'];	
			$this->product_id = (int) $row['product_id'];	
			$this->quantity = $row['quantity'];
		}
	}
?>