package ui{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import skin.Skin_SkillOutlineWindow;
	
	public class SkillOutlineWindow extends VisualContainer{
		
		private function get __btn_new() : Button { return _skin["_btn_new"]; }
		private function get __cb_type() : ComboBox { return _skin["_cb_type"]; }
		private function get __list() : List { return _skin["_list"]; }
		
		private function get __lab_title() : TextField { return _skin["_lab_title"]; }
		
		public function SkillOutlineWindow(skin_clazz:Class = null){
			if(null == skin_clazz){
				skin_clazz = Skin_SkillOutlineWindow;
			}
			super(skin_clazz);
			
			__lab_title.mouseEnabled = false;
			
			__cb_type.dataProvider = new DataProvider(Global.SKILL_TYPE);
			
			__list.setStyle("cellRenderer", SkillItem);
			__list.labelField = "name";
			__list.iconField = null;
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__cb_type.removeEventListener(Event.CHANGE, onTypeChange);
			
			__list.removeEventListener(ListEvent.ITEM_CLICK, onItemClick);
			__btn_new.removeEventListener(MouseEvent.CLICK, onNew);
			
			Global.ins.removeEventListener(GlobalEvent.EVT_LOADED_SKILL_CONFIGS, onLoadedSkillConfigs);
		}
		
		override protected function setup():void{
			super.setup();
			
			__cb_type.addEventListener(Event.CHANGE, onTypeChange);
			
			__list.addEventListener(ListEvent.ITEM_CLICK, onItemClick);
			__btn_new.addEventListener(MouseEvent.CLICK, onNew);
			
			Global.ins.addEventListener(GlobalEvent.EVT_LOADED_SKILL_CONFIGS, onLoadedSkillConfigs);
		}
		
		private function onLoadedSkillConfigs(event:GlobalEvent):void{
			this.filterSkills();
		}
		
		private function onTypeChange(event:Event):void{
			this.filterSkills();
		}
		
		private function filterSkills():void{
			var tmp_arr:Array = Global.ins.skill_arr.filter(function(item:*, index:int, array:Array):Boolean{
				if(0 == __cb_type.selectedIndex || item.type == __cb_type.selectedIndex){
					return true;
				}
				return false;
			});
			__list.dataProvider = new DataProvider(tmp_arr);
		}
		
		private function onItemClick(event:ListEvent):void{
			Global.ins.showSkillEditWindow(event.item as SkillConfig);
		}
		
		private function onNew(event:MouseEvent):void{
			Global.ins.showSkillEditWindow();
		}
	}
}