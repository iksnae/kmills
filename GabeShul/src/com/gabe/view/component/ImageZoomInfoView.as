﻿package com.gabe.view.component {			import flash.display.MovieClip;	import flash.text.TextField;
			public class ImageZoomInfoView extends MovieClip {		public var full_txt:TextField;		public var scale_txt:TextField;		public var thumb_txt:TextField;				public function ImageZoomInfoView() {			// constructor code			thumb_txt = scale_txt = full_txt = new TextField();		}	}	}