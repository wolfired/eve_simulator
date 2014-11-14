package es.ui{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import skin.Skin_SkillItem4Edit;

	public class SkillItem4Edit extends SkillItem4Outline{
		private function get __sd_depend_level() : Slider { return _skin["_sd_depend_level"]; }
		
		private function get __txt_depend() : TextField { return _skin["_txt_depend"]; }
		private function get __txt_depend_level() : TextField { return _skin["_txt_depend_level"]; }
		
		private var _depend4edit:Object;
		
		public function SkillItem4Edit(skin_clazz:Class=null){
			if(null == skin_clazz){
				skin_clazz = Skin_SkillItem4Edit;
			}
			super(skin_clazz);
		}
		
		public function set depend4edit(value:Object):void{
			_depend4edit = value;
			
			this.showLevel();
			this.mark();
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__sd_depend_level.removeEventListener(SliderEvent.CHANGE, onChange);
			__txt_depend.removeEventListener(MouseEvent.CLICK, onDepend);
		}
		
		override protected function setup():void{
			super.setup();
			
			__sd_depend_level.addEventListener(SliderEvent.CHANGE, onChange);
			__txt_depend.addEventListener(MouseEvent.CLICK, onDepend);
		}
		
		private function onChange(event:SliderEvent):void{
			if(null != _depend4edit[_skill_cfg.id]){
				_depend4edit[_skill_cfg.id] = __sd_depend_level.value;
			}
			this.showLevel();
		}
		
		private function onDepend(event:MouseEvent):void{
			if(null != _depend4edit[_skill_cfg.id]){
				delete _depend4edit[_skill_cfg.id];
			}else{
				_depend4edit[_skill_cfg.id] = __sd_depend_level.value;
			}
			this.mark();
		}
		
		private function showLevel():void{
			if(null != _depend4edit[_skill_cfg.id]){
				__sd_depend_level.value = _depend4edit[_skill_cfg.id];
				__txt_depend_level.text = "Lv." + _depend4edit[_skill_cfg.id];
			}else{
				__txt_depend_level.text = "Lv." + __sd_depend_level.value;
			}
		}
		
		private function mark():void{
			__txt_depend.textColor = null != _depend4edit[_skill_cfg.id] ? 0xFF0000 : 0x000000;
		}
	}
}