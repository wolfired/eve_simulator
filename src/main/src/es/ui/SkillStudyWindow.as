package es.ui{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import es.ds.DragData;
	import es.ds.SkillConfig;
	import es.evt.GlobalEvent;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	
	import skin.Skin_SkillStudyWindow;

	public class SkillStudyWindow extends Window{
		
		private function get __btn_clean() : Button { return _skin["_btn_clean"]; }
		private function get __btn_close() : Button { return _skin["_btn_close"]; }
		private function get __btn_sim() : Button { return _skin["_btn_sim"]; }
		
		private function get __lab_title() : TextField { return _skin["_lab_title"]; }
		
		private function get __sp() : ScrollPane { return _skin["_sp"]; }
		
		private var _spr:Sprite;
		private var _item_arr:Array = [];
		
		public function SkillStudyWindow(){
			super(Skin_SkillStudyWindow);
			
			__lab_title.mouseEnabled = false;
			
			_spr = new Sprite();
			__sp.source = _spr;
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__btn_clean.removeEventListener(MouseEvent.CLICK, onClean);
			__btn_close.removeEventListener(MouseEvent.CLICK, onClose);
			__btn_sim.removeEventListener(MouseEvent.CLICK, onSim);
			
			Global.ins.removeEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.disableDrag(this);
		}
		
		override protected function setup():void{
			super.setup();
			
			__btn_clean.addEventListener(MouseEvent.CLICK, onClean);
			__btn_close.addEventListener(MouseEvent.CLICK, onClose);
			__btn_sim.addEventListener(MouseEvent.CLICK, onSim);
			
			Global.ins.addEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.enableDrag(this, new DragData());
			
			this.showSkills();
		}
		
		private function onClean(event:MouseEvent):void{
			Global.ins.cleanStudySkill();
		}
		
		private function onClose(event:MouseEvent):void{
			Global.ins.cleanStudySkill();
			this.parent.removeChild(this);
		}
		
		private function onSim(event:MouseEvent):void{
			var tmp_arr:Array = Global.ins.study_arr;
			
			for each (var skill_cfg:SkillConfig in tmp_arr) {
				
			}
		}
		
		private function onSkillSetUpdate(event:GlobalEvent):void{
			this.showSkills();
		}
		
		private function showSkills():void{
			var tmp_arr:Array = Global.ins.study_arr;
			
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
				
				skill_item.x = offset_x + i % 2 * 220;
				skill_item.y = offset_y + Math.floor(i / 2) * 19;
			}
			__sp.update();
		}
	}
}