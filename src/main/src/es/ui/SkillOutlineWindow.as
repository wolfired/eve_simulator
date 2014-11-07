package es.ui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import es.ds.DragData;
	import es.ds.SkillConfig;
	import es.evt.GlobalEvent;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import skin.Skin_SkillOutlineWindow;
	
	public class SkillOutlineWindow extends Window{
		
		private function get __btn_new() : Button { return _skin["_btn_new"]; }
		private function get __btn_study() : Button { return _skin["_btn_study"]; }
		private function get __cb_type() : ComboBox { return _skin["_cb_type"]; }
		private function get __sp() : ScrollPane { return _skin["_sp"]; }
		
		private function get __lab_title() : TextField { return _skin["_lab_title"]; }
		
		private var _spr:Sprite;
		private var _item_arr:Array = [];
		
		public function SkillOutlineWindow(){
			super(Skin_SkillOutlineWindow);
			
			__lab_title.mouseEnabled = false;
			
			__cb_type.dataProvider = new DataProvider(Global.SKILL_TYPE);
			
			_spr = new Sprite();
			__sp.source = _spr;
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__btn_new.removeEventListener(MouseEvent.CLICK, onNew);
			__btn_study.removeEventListener(MouseEvent.CLICK, onStudy);
			__cb_type.removeEventListener(Event.CHANGE, onTypeChange);
			
			Global.ins.removeEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.disableDrag(this);
		}
		
		override protected function setup():void{
			super.setup();
			
			__btn_new.addEventListener(MouseEvent.CLICK, onNew);
			__btn_study.addEventListener(MouseEvent.CLICK, onStudy);
			__cb_type.addEventListener(Event.CHANGE, onTypeChange);
			
			Global.ins.addEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.enableDrag(this, new DragData());
		}
		
		private function onSkillSetUpdate(event:GlobalEvent):void{
			this.filterSkills();
		}
		
		private function onTypeChange(event:Event):void{
			this.filterSkills();
		}
		
		private function filterSkills():void{
			var l:uint = 0;
			var m:uint = 0;
			var r:uint = 0;
			
			var tmp_arr:Array = Global.ins.skill_arr.filter(function(item:*, index:int, array:Array):Boolean{
				++r;
				if(0 == __cb_type.selectedIndex || item.type == __cb_type.selectedIndex){
					if(0 < item.level){
						++l;
					}
					++m;
					return true;
				}
				return false;
			});
			__lab_title.text = "技能总揽 (" + l + "/" + m + "/" + r + ")";
			
			while(tmp_arr.length != _spr.numChildren){
				if(tmp_arr.length > _spr.numChildren){
					_item_arr.push(_spr.addChild(new SkillItem()));
				}else if(tmp_arr.length < _spr.numChildren){
					_spr.removeChild(_item_arr.pop());
				}
			}
			
			var skill_item:SkillItem;
			var offset_x:Number = 2.0;
			var offset_y:Number = 2.0;
			for (var i:int = 0; i < tmp_arr.length; ++i) {
				skill_item = _item_arr[i] as SkillItem;
				skill_item.skill_cfg = tmp_arr[i] as SkillConfig;
				
				skill_item.x = offset_x + i % 1 * 210;
				skill_item.y = offset_y + Math.floor(i / 1) * 19;
			}
			__sp.update();
		}
		
		private function onNew(event:MouseEvent):void{
			Global.ins.showSkillEditWindow();
		}
		
		private function onStudy(event:MouseEvent):void{
			Global.ins.showSkillStudyWindow();
		}
	}
}