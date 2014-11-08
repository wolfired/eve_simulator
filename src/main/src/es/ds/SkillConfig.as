package es.ds{
	public class SkillConfig{
		
		public var id:uint = 0;
		public var type:uint = 12;
		public var name:String = "";
		public var level:uint = 0;
		public var times:uint = 1;
		public var desc:String = "";
		public var attr_major:uint = 5;
		public var attr_minor:uint = 2;
		public var depend:Object = {};
		
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
		
		public function time(level2study:uint, major:uint, minor:uint):uint{
			var points:uint = clac_points(level2study) - (0 == level ? 0 : clac_points(level));
			
			var m:uint = major + minor / 2;
			
			return points / m;
		}
		
		private function clac_points(lv:uint):uint{
			return Math.ceil(Math.pow(2.0, (5.0 * lv - 3.0) / 2.0) * 125.0 * times);
		}
	}
}