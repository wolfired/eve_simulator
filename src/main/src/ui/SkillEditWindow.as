package ui{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.Slider;
	import fl.data.DataProvider;
	import fl.events.SliderEvent;
	
	import skin.Skin_SkillEditWindow;

	public class SkillEditWindow extends VisualContainer{
		
		private function get __btn_cancel() : Button { return _skin["_btn_cancel"]; }
		private function get __btn_save() : Button { return _skin["_btn_save"]; }
		private function get __cb_attr_major() : ComboBox { return _skin["_cb_attr_major"]; }
		private function get __cb_attr_minor() : ComboBox { return _skin["_cb_attr_minor"]; }
		private function get __cb_type() : ComboBox { return _skin["_cb_type"]; }
		private function get __sd_level() : Slider { return _skin["_sd_level"]; }
		private function get __sd_times() : Slider { return _skin["_sd_times"]; }
		
		private function get __txt_desc() : TextField { return _skin["_txt_desc"]; }
		private function get __txt_id() : TextField { return _skin["_txt_id"]; }
		private function get __txt_level() : TextField { return _skin["_txt_level"]; }
		private function get __txt_name() : TextField { return _skin["_txt_name"]; }
		private function get __txt_times() : TextField { return _skin["_txt_times"]; }
		
		private var _skill_cfg:SkillConfig;
		
		public function SkillEditWindow(skin_clazz:Class=null){
			if(null == skin_clazz){
				skin_clazz = Skin_SkillEditWindow;
			}
			super(skin_clazz);
			
			__cb_type.dataProvider = new DataProvider(Global.SKILL_TYPE);
			__cb_attr_major.dataProvider = new DataProvider(Global.ATTR_TYPE);
			__cb_attr_minor.dataProvider = new DataProvider(Global.ATTR_TYPE);
			
			__txt_level.text = "Lv." + __sd_level.value;
			__txt_times.text = "x" + __sd_times.value;
		}
		
		override protected function setup():void{
			__cb_type.addEventListener(Event.CHANGE, onTypeChange);
			__sd_level.addEventListener(SliderEvent.CHANGE, onLevelChange);
			__sd_times.addEventListener(SliderEvent.CHANGE, onTimesChange);
			
			__btn_cancel.addEventListener(MouseEvent.CLICK, onCancel);
			__btn_save.addEventListener(MouseEvent.CLICK, onSave);
		}
		
		override protected function cleanup():void{
			__cb_type.removeEventListener(Event.CHANGE, onTypeChange);
			__sd_level.removeEventListener(SliderEvent.CHANGE, onLevelChange);
			__sd_times.removeEventListener(SliderEvent.CHANGE, onTimesChange);
			
			__btn_cancel.removeEventListener(MouseEvent.CLICK, onCancel);
			__btn_save.removeEventListener(MouseEvent.CLICK, onSave);
		}
		
		public function set skill_cfg(value:SkillConfig):void{
			if(null == value){
				value = new SkillConfig();
			}
			_skill_cfg = value;
			
			__txt_id.text = _skill_cfg.id.toString();
			
			__cb_type.selectedIndex = _skill_cfg.type;
			
			__txt_name.text = _skill_cfg.name;
			
			__sd_level.value = _skill_cfg.level;
			__txt_level.text = "Lv." + __sd_level.value;
			
			__sd_times.value = _skill_cfg.times;
			__txt_times.text = "x" + __sd_times.value;
			
			__cb_attr_major.selectedIndex = _skill_cfg.attr_major;
			__cb_attr_minor.selectedIndex = _skill_cfg.attr_minor;
			
			__txt_desc.text = _skill_cfg.desc;
		}
		
		private function onTypeChange(event:Event):void{
		}
		
		private function onLevelChange(event:SliderEvent):void{
			__txt_level.text = "Lv." + __sd_level.value;
		}
		
		private function onTimesChange(event:SliderEvent):void{
			__txt_times.text = "x" + __sd_times.value;
		}
		
		private function onCancel(event:MouseEvent):void{
			this.parent.removeChild(this);
		}
		
		private function onSave(event:MouseEvent):void{
			_skill_cfg.type = __cb_type.selectedItem.id;
			_skill_cfg.name = __txt_name.text;
			_skill_cfg.times = __sd_times.value;
			_skill_cfg.attr_major = __cb_attr_major.selectedIndex;
			_skill_cfg.attr_minor = __cb_attr_minor.selectedIndex;
			_skill_cfg.desc = __txt_desc.text;
			Global.ins.saveSkillConfig(_skill_cfg);
			
			GlobalEvent.trigger(GlobalEvent.EVT_LOADED_SKILL_CONFIGS);
		}
	}
}