<?php
	class LogVO
	{
		public $id;
		public $date;
		public $action_type;
		public $header;
		public $body;
		
	
		
		public function parse($row)
		{
			$this->id = $row['id'];	
			$this->date = $row['date'];	
			$this->action_type = $row['action_type'];
			$this->header = $row['header'];
			$this->body = $row['body'];
		}
	}
?>