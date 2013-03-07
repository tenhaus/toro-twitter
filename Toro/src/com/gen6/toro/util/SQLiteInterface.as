package com.gen6.toro.util
{
	import com.gen6.toro.entity.ConfigurationVO;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.filesystem.File;
	
	import mx.utils.ObjectUtil;
	
	public class SQLiteInterface
	{
		public static const DB_FILE_NAME : String = "toro.db";
		
		private var _conn : SQLConnection;
		private var _dbFile : File = File.applicationStorageDirectory.resolvePath( DB_FILE_NAME );
		
		public function SQLiteInterface() : void
		{
			_conn = new SQLConnection();
			
			try
			{
				_conn.open( _dbFile );
				initializeTables();
			}
			catch( error : SQLError )
			{
				trace( error.details );				
			}
		}
		
		private function initializeTables() : void
		{
			var stmt : SQLStatement = new SQLStatement();
			stmt.sqlConnection = _conn;
			
			var sql : String = "";
			sql += "create table if not exists comments (";
			sql += "id INTEGER PRIMARY KEY,";
			sql += "userId INTEGER,";
			sql += "created_at TEXT,";
			sql += "commentText TEXT,";
			sql += "souce TEXT,";
			sql += "truncated TEXT";
			sql += ")";
			
			stmt.text = sql;
			stmt.execute();
			
			sql = "";
			sql += "create table if not exists users (";
			sql += "id INTEGER PRIMARY KEY,";
			sql += "name TEXT,";
			sql += "screenName TEXT,";
			sql += "description TEXT,";
			sql += "location TEXT,";
			sql += "avatar BLOB";
			sql += ")";
			
			stmt.text = sql;
			stmt.execute();
			
			sql = "";
			sql += "create table if not exists config (";
			sql += "id INTEGER PRIMARY KEY AUTOINCREMENT,";
			sql += "name TEXT,";
			sql += "value TEXT";		
			sql += ")";
			
			stmt.text = sql;
			stmt.execute();
			
			sql = "select count(*) as count from config";
			stmt.text = sql;
			stmt.execute();
			
			var result : SQLResult = stmt.getResult();
			
			if( result.complete )
			{
				var count : Number = parseInt( result.data[0].count );
				
				// new database.  fill with defaults from ConfigurationVO
				var config : ConfigurationVO = new ConfigurationVO();
				
				if( count == 0 )
				{
					sql = "";
					sql = "insert into config ( name, value ) values ( 'sound', :value )";
					stmt.text = sql;
					stmt.parameters[":value"] = config.sound;
					stmt.execute();
					
					sql = "";
					sql = "insert into config ( name, value ) values ( 'notifications', :value )";
					stmt.text = sql;
					stmt.parameters[":value"] = config.notifications;
					stmt.execute();
				}
				
				//adding is notification placement.  we really need to fix this sucker to have it check for what's there and put in what's not
				//instead of just checking the number...that will kill us eventually.
				
				if( count == 2 )
				{
					sql = "";
					sql = "insert into config ( name, value ) values ( 'notificationPlacement', :value )";
					stmt.text = sql;
					stmt.parameters[":value"] = config.notificationPlacement;
					stmt.execute();					
				}
				
				if( count == 3 )
				{
					sql = "";
					sql = "insert into config ( name, value ) values ( 'retweetText', :value )";
					stmt.text = sql;
					stmt.parameters[":value"] = config.retweetText;
					stmt.execute();					
				}
			}
		}
		
		public function getConfigOptions() : ConfigurationVO
		{
			var config : ConfigurationVO = new ConfigurationVO();
			
			var sql : String = "select * from config";
			var stmt : SQLStatement = new SQLStatement();
			stmt.sqlConnection = _conn;			
			stmt.text = sql;
			
			stmt.execute();
			
			var result : SQLResult = stmt.getResult();
			
			if( result.complete )
			{
				for each( var item : Object in result.data )
				{
					switch( item.name )
					{
						case "sound" :
							config.sound = ToroUtil.parseBool( item.value );
							break;
							
						case "notifications" :
							config.notifications = ToroUtil.parseBool( item.value );
							break;
							
						case "notificationPlacement" :
							config.notificationPlacement = parseInt( item.value );
							break;
						case "retweetText" :
							config.retweetText = parseInt( item.value );
							break;
						default :
							break;
					}
				}							
			}
			
			return( config );
		}
		
		public function saveConfigOptions( value : ConfigurationVO ) : Boolean
		{
			var sql : String = "";
			var success : Boolean = true;
			var stmt : SQLStatement = new SQLStatement();
			stmt.sqlConnection = _conn;
			
			sql = "";
			sql = "update config set value = :value where name = 'sound'";
			stmt.text = sql;
			stmt.parameters[":value"] = value.sound;			
			stmt.execute();			
			success = success && stmt.getResult().complete;
			
			sql = "";
			sql = "update config set value = :value where name = 'notifications'";
			stmt.text = sql;
			stmt.parameters[":value"] = value.notifications;
			stmt.execute();
			success = success && stmt.getResult().complete;
			
			sql = "";
			sql = "update config set value = :value where name = 'notificationPlacement'";
			stmt.text = sql;
			stmt.parameters[":value"] = value.notificationPlacement;
			stmt.execute();
			success = success && stmt.getResult().complete;
			
			sql = "";
			sql = "update config set value = :value where name = 'retweetText'";
			stmt.text = sql;
			stmt.parameters[":value"] = value.retweetText;
			stmt.execute();
			success = success && stmt.getResult().complete;
								
			return( success );
		}
	}
}