package es.ui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import es.ds.DragData;
	import es.ds.SkillConfig;
	import es.evt.GlobalEvent;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.Slider;
	import fl.data.DataProvider;
	import fl.events.SliderEvent;
	
	import skin.Skin_SkillEditWindow;

	public class SkillEditWindow extends VisualContainer{
		private function get __lab_title() : TextField { return _skin["_lab_title"]; }
		
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
		private function get __txt_search() : TextField { return _skin["_txt_search"]; }
		
		private function get __sp() : ScrollPane { return _skin["_sp"]; }
		
		private var _skill_cfg:SkillConfig;
		
		private var _spr:Sprite;
		private var _item_arr:Array = [];
		
		private var _depend4edit:Object;
		
		public function SkillEditWindow(){
			super(Skin_SkillEditWindow);
			
			__lab_title.mouseEnabled = false;
			
			__cb_type.dataProvider = new DataProvider(Global.SKILL_TYPE);
			__cb_attr_major.dataProvider = new DataProvider(Global.ATTR_TYPE);
			__cb_attr_minor.dataProvider = new DataProvider(Global.ATTR_TYPE);
			
			__txt_id.mouseEnabled = __txt_level.mouseEnabled = __txt_times.mouseEnabled = false;
			
			__txt_level.text = "Lv." + __sd_level.value;
			__txt_times.text = "x" + __sd_times.value;
			
			_spr = new Sprite();
			__sp.source = _spr;
		}
		
		override protected function setup():void{
			__cb_type.addEventListener(Event.CHANGE, onTypeChange);
			__sd_level.addEventListener(SliderEvent.CHANGE, onLevelChange);
			__sd_times.addEventListener(SliderEvent.CHANGE, onTimesChange);
			
			__btn_cancel.addEventListener(MouseEvent.CLICK, onCancel);
			__btn_save.addEventListener(MouseEvent.CLICK, onSave);
			
			__txt_search.addEventListener(KeyboardEvent.KEY_DOWN, onSearch);
			
			Global.ins.addEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.enableDrag(this, new DragData());
		}
		
		override protected function cleanup():void{
			__cb_type.removeEventListener(Event.CHANGE, onTypeChange);
			__sd_level.removeEventListener(SliderEvent.CHANGE, onLevelChange);
			__sd_times.removeEventListener(SliderEvent.CHANGE, onTimesChange);
			
			__btn_cancel.removeEventListener(MouseEvent.CLICK, onCancel);
			__btn_save.removeEventListener(MouseEvent.CLICK, onSave);
			
			__txt_search.removeEventListener(KeyboardEvent.KEY_DOWN, onSearch);
			
			Global.ins.removeEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.disableDrag(this);
		}
		
		public function set skill_cfg(value:SkillConfig):void{
			_skill_cfg = value;
			
			this.showInfo();
		}
		
		public function set editable(value:Boolean):void{
			__txt_name.mouseEnabled = value;
			__sd_level.mouseEnabled = __sd_times.mouseEnabled = value;
			__cb_type.mouseEnabled = __cb_attr_major.mouseEnabled = __cb_attr_minor.mouseEnabled = value;
			
			__btn_save.visible = value;
		}
		
		
		private function onSkillSetUpdate(event:GlobalEvent):void{
			this.showInfo();
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
			Global.ins.hideSkillEditWindow(_skill_cfg.id);
		}
		
		private function onSave(event:MouseEvent):void{
			_skill_cfg.type = __cb_type.selectedItem.id;
			_skill_cfg.name = __txt_name.text;
			_skill_cfg.level = __sd_level.value;
			_skill_cfg.times = __sd_times.value;
			_skill_cfg.attr_major = __cb_attr_major.selectedIndex;
			_skill_cfg.attr_minor = __cb_attr_minor.selectedIndex;
			_skill_cfg.desc = __txt_desc.text;
			_skill_cfg.depend = _depend4edit;
			Global.ins.saveSkill(_skill_cfg);
		}
		
		private function onSearch(event:KeyboardEvent):void{
			if(Keyboard.ENTER == event.keyCode){
				var search_arr:Array = Global.ins.searchSkill(__txt_search.text);
				this.showDepends(search_arr);
				__txt_search.text = "";
			}
		}
		
		private function showInfo():void{
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
			
			_depend4edit = {};
			for (var key:String in _skill_cfg.depend) {
				_depend4edit[key] = _skill_cfg.depend[key];
			}
			
			this.showDepends([]);
		}
		
		private function showDepends(extenal:Array):void{
			var tmp_arr:Array = this.getDependSkills();
			for each (var extenal_cfg:SkillConfig in extenal) {
				if(extenal_cfg.id != _skill_cfg.id && -1 == tmp_arr.indexOf(extenal_cfg)){
					tmp_arr.push(extenal_cfg);
				}
			}

			while(tmp_arr.length != _spr.numChildren){
				if(tmp_arr.length > _spr.numChildren){
					_item_arr.push(_spr.addChild(new SkillItem4Edit()));
				}else if(tmp_arr.length < _spr.numChildren){
					_spr.removeChild(_item_arr.pop());
				}
			}
			
			var skill_item:SkillItem4Edit;
			var skill_cfg:SkillConfig;
			var offset_x:Number = 2.0;
			var offset_y:Number = 2.0;
			for (var i:int = 0; i < tmp_arr.length; ++i) {
				skill_item = _item_arr[i] as SkillItem4Edit;
				skill_cfg = tmp_arr[i] as SkillConfig;
				skill_item.skill_cfg = skill_cfg;
				skill_item.depend4edit = _depend4edit;
				
				skill_item.x = offset_x + i % 2 * 220;
				skill_item.y = offset_y + Math.floor(i / 2) * 39;
			}
			__sp.update();
		}
		
		private function getDependSkills():Array{
			var result:Array = [];
			for (var skill_id_str:String in _depend4edit) {
				result.push(Global.ins.getSkillConfig(uint(skill_id_str)));
			}
			result.sort(function(fst:SkillConfig, snd:SkillConfig):int{
				if(fst.id >  snd.id){
					return 1;
				}
				return -1;
			});
			
			return result;
		}
	}
}