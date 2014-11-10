package es.ui{
	import flash.text.TextField;
	
	import es.ds.SkillConfig;
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import skin.Skin_SkillItem4Study;

	public class SkillItem4Study extends SkillItem4Outline{
		private function get __sd_study_level() : Slider { return _skin["_sd_study_level"]; }
		private function get __txt_level() : TextField { return _skin["_txt_level"]; }
		
		public function SkillItem4Study(skin_clazz:Class=null){
			if(null == skin_clazz){
				skin_clazz = Skin_SkillItem4Study;
			}
			super(skin_clazz);
		}
		
		override public function set skill_cfg(value:SkillConfig):void{
			super.skill_cfg = value;
			
			__sd_study_level.minimum = _skill_cfg.level;
			this.setLevel();
		}
		
		public function get study_level():uint{
			return __sd_study_level.value;
		}
		
		public function setStudyLevel(level:uint):void{
			__sd_study_level.value = level;
			this.setLevel();
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__sd_study_level.removeEventListener(SliderEvent.CHANGE, onChange);
		}
		
		override protected function setup():void{
			super.setup();
			
			__sd_study_level.addEventListener(SliderEvent.CHANGE, onChange);
		}
		
		private function onChange(event:SliderEvent):void{
			this.setLevel();
		}
		
		private function setLevel():void{
			__txt_level.text = "Lv." + _skill_cfg.level + " >> " + __sd_study_level.value;
		}
	}
}