package es.ds{
	public class SkillConfig{
		
		public var id:uint = 0;
		public var type:uint = 22;
		public var name:String = "";
		public var times:uint = 1;
		public var desc:String = "";
		public var attr_major:uint = 4;
		public var attr_minor:uint = 2;
		public var depend:Object = {};
		
		private var _level:uint;
		public function get level():uint { return _level; }
		
		public function set level(value:uint):void{
			_level = value;
			
			_level4study = _level4study < _level ? _level : _level4study;
		}
		
		private var _level4study:uint = 0;
		public function getLevel4Study():uint{
			return _level4study;
		}
		public function setLevel4Study(value:uint):void{
			_level4study = value;
			_level4study = _level4study < _level ? _level : _level4study;
		}
		
		public function SkillConfig(){
		}
		
		public function inject(src:Object):SkillConfig{
			for (var key:String in src) {
				this[key] = src[key];
			}
			
			return this;
		}
		
		public function isMaxLevel():Boolean{
			return 5 == level;
		}

		public function isDependOn(skill_id:uint):Boolean{
			return null != this.depend[skill_id];
		}
		
		public function time(major:uint, minor:uint):Number{
			var points:Number = (0 == _level4study ? 0 : clac_points(_level4study)) - (0 == level ? 0 : clac_points(level));
			
			var m:Number = major + minor / 2;
			
			return points / m;
		}
		
		private function clac_points(lv:uint):Number{
			return Math.ceil(Math.pow(2.0, (5.0 * lv - 3.0) / 2.0) * 125.0 * times);
		}
	}
}