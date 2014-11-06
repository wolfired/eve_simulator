package{
	public class SkillConfig{
		
		public var id:uint = 0;
		public var type:uint = 1;
		public var name:String = "";
		public var level:uint = 0;
		public var times:uint = 0;
		public var desc:String = "";
		public var attr_major:uint = 1;
		public var attr_minor:uint = 3;
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