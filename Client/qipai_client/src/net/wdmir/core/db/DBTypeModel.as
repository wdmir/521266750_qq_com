package net.wdmir.core.db
{
	public class DBTypeModel
	{
		private var _mode:String;
		
		public function get mode():String
		{
			return _mode;
		}
		
		private var _path:String;
		
		public var ver:String;
		public var sql:String;
		
		public function DBTypeModel(mode:String, path:String, ver:String, sql:String)
		{
			this._mode = mode;
			this._path = path;//.trim();
			this.ver = ver;
			this.sql = sql;
		}

		

	}
}