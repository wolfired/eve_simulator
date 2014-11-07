package es.ui{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import es.ds.SkillConfig;
	
	import skin.Skin_SkillItem;
	
	public class SkillItem extends VisualContainer {
		
		private function get __txt_edit() : TextField { return _skin["_txt_edit"]; }
		private function get __txt_name() : TextField { return _skin["_txt_name"]; }
		private function get __txt_study() : TextField { return _skin["_txt_study"]; }
		
		private var _skill_cfg:SkillConfig;
		public function get skill_cfg():SkillConfig { return _skill_cfg; }
		
		public function set skill_cfg(value:SkillConfig):void{
			_skill_cfg = value;
			
			__txt_name.text = _skill_cfg.name + "x" + _skill_cfg.times;
			
			__txt_edit.textColor = Global.ins.isSkillInEdit(_skill_cfg.id) ? 0xFF0000 : 0x000000;
			__txt_study.textColor = Global.ins.isSkillInStudy(_skill_cfg.id) ? 0xFF0000 : 0x000000;
		}
		
		public function SkillItem(skin_clazz:Class = null){
			if(null == skin_clazz){
				skin_clazz = Skin_SkillItem;
			}
			super(skin_clazz);
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__txt_edit.removeEventListener(MouseEvent.CLICK, onEdit);
			__txt_study.removeEventListener(MouseEvent.CLICK, onStudy);
		}
		
		override protected function setup():void{
			super.setup();
			
			__txt_edit.addEventListener(MouseEvent.CLICK, onEdit);
			__txt_study.addEventListener(MouseEvent.CLICK, onStudy);
		}
		
		private function onEdit(event:MouseEvent):void{
			Global.ins.showSkillEditWindow(_skill_cfg);
		}
		
		private function onStudy(event:MouseEvent):void{
			Global.ins.studySkill(_skill_cfg);
		}
	}
}