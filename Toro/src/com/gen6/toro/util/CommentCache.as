package com.gen6.toro.util
{
	import com.adobe.utils.ArrayUtil;
	
	import mx.collections.ArrayCollection;
	
	import twitter.api.data.TwitterStatus;
	
	public class CommentCache
	{
		private var _maxComments : Number;
		private var _comments : ArrayCollection;
		
		public function CommentCache( maxComments : Number = 40 )
		{
			_maxComments = maxComments;					
		} 
		
		// takes a list of comments and returns a list of comments
		// that are new
		public function addComments( comments : ArrayCollection ) : ArrayCollection
		{
			// if this is the first set of comments, just return the list
			if( _comments == null )
			{
				_comments = new ArrayCollection( ArrayUtil.createUniqueCopy(comments.toArray()) );				
				return( new ArrayCollection(ArrayUtil.createUniqueCopy(_comments.toArray())) );				
			}			
			var newComments : ArrayCollection = new ArrayCollection();
			
			for( var i : Number = comments.length-1; i >= 0; i-- )
			{
				if( !containsID(comments[i].id) )
				{
					newComments.addItem( comments[i] );
					_comments.addItemAt( comments[i], 0 );
				}								
			}
						
			return( newComments );
		}
		
		public function containsID( commentID : Number ) : Boolean
		{
			for each( var existingComment : TwitterStatus in _comments )
			{
				if( existingComment.id == commentID )
				{
					return( true );
				}								
			}
			
			return( false );					
		}
	}
}