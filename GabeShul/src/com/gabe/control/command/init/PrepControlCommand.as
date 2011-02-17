package com.gabe.control.command.init
{

	
	import com.gabe.control.event.GabeShuEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepControlCommand extends SimpleCommand
	{
		public function PrepControlCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			Debug.log('EXECUTE: PrepControlCommand');
			
//			facade.registerCommand( WordPressEvent.LOAD_POST_DATA, 	LoadAllPostsCommand );
//			facade.registerCommand( WordPressEvent.POSTS_LOADED, 	RawPostsLoadedCommand );
//			facade.registerCommand( WordPressEvent.LOAD_META_DATA, 	GetMetaDataCommand);
//			facade.registerCommand( WordPressEvent.METADATA_LOADED, MetaDataLoadedCommand );
//			facade.registerCommand( WordPressEvent.PREP_COLLECTION,	PrepCollectionCommand );
//			facade.registerCommand( WordPressEvent.PRODUCTS_READY,	ProductsReadyCommand );
//			
			
			sendNotification(GabeShuEvent.READY);
		}
	}
}