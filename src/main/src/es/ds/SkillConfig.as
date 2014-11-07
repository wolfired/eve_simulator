package es.ds{
	public class SkillConfig{
		
		public var id:uint = 0;
		public var type:uint = 6;
		public var name:String = "";
		public var level:uint = 0;
		public var times:uint = 0;
		public var desc:String = "";
		public var attr_major:uint = 4;
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
	}
}