package es.ui{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import es.ds.DragData;
	import es.ds.SkillConfig;
	import es.evt.GlobalEvent;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import skin.Skin_SkillStudyWindow;

	public class SkillStudyWindow extends Window{
		
		private function get __btn_clean() : Button { return _skin["_btn_clean"]; }
		private function get __btn_close() : Button { return _skin["_btn_close"]; }
		private function get __btn_sim() : Button { return _skin["_btn_sim"]; }
		
		private function get __sd_g() : Slider { return _skin["_sd_g"]; }
		private function get __sd_j() : Slider { return _skin["_sd_j"]; }
		private function get __sd_l() : Slider { return _skin["_sd_l"]; }
		private function get __sd_m() : Slider { return _skin["_sd_m"]; }
		private function get __sd_y() : Slider { return _skin["_sd_y"]; }
		private function get __sd_z() : Slider { return _skin["_sd_z"]; }
		
		private function get __txt_g() : TextField { return _skin["_txt_g"]; }
		private function get __txt_j() : TextField { return _skin["_txt_j"]; }
		private function get __txt_l() : TextField { return _skin["_txt_l"]; }
		private function get __txt_m() : TextField { return _skin["_txt_m"]; }
		private function get __txt_y() : TextField { return _skin["_txt_y"]; }
		private function get __txt_z() : TextField { return _skin["_txt_z"]; }
		
		private function get __lab_title() : TextField { return _skin["_lab_title"]; }
		private function get __txt_time() : TextField { return _skin["_txt_time"]; }
		
		private function get __sp() : ScrollPane { return _skin["_sp"]; }
		
		private var _map:Array = [];
		private var _dic:Dictionary = new Dictionary();
		
		private var _spr:Sprite;
		private var _item_arr:Array = [];
		
		public function SkillStudyWindow(){
			super(Skin_SkillStudyWindow);
			
			__lab_title.mouseEnabled = false;
			
			_spr = new Sprite();
			__sp.source = _spr;
			
			_map[1] = __sd_g;
			_map[2] = __sd_j;
			_map[5] = __sd_m;
			_map[3] = __sd_y;
			_map[4] = __sd_z;
			
			_dic[__sd_g] = __txt_g;
			_dic[__sd_j] = __txt_j;
			_dic[__sd_m] = __txt_m;
			_dic[__sd_y] = __txt_y;
			_dic[__sd_z] = __txt_z;
			
			__txt_l.text = __txt_l.text.replace(/\d+/g, __sd_l.value);
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			__btn_clean.removeEventListener(MouseEvent.CLICK, onClean);
			__btn_close.removeEventListener(MouseEvent.CLICK, onClose);
			__btn_sim.removeEventListener(MouseEvent.CLICK, onSim);
			
			for (var sd:Slider in _dic) {
				sd.removeEventListener(SliderEvent.CHANGE, onAttrChange);
			}
			
			__sd_l.removeEventListener(SliderEvent.CHANGE, onLevelChange);
			
			Global.ins.removeEventListener(GlobalEvent.EVT_SKILL_SET_UPDATE, onSkillSetUpdate);
			Global.ins.disableDrag(this);
		}
		
		override protected function setup():void{
			super.setup();
			
			__btn_clean.addEventListener(MouseEvent.CLICK, onClean);
			__btn_close.addEventListener(MouseEvent.CLICK, onClose);
			__btn_sim.addEventListener(MouseEvent.CLICK, onSim);
			
			for (var sd:Slider in _dic) {
				sd.addEventListener(SliderEvent.CHANGE, onAttrChange);
			}
			
			__sd_l.addEventListener(SliderEvent.CHANGE, onLevelChange);
			
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
			var t:Number = 0.0;
			for each (var skill_item:SkillItem4Study in _item_arr) {
				t += skill_item.skill_cfg.time(
					(_map[skill_item.skill_cfg.attr_major] as Slider).value,
					(_map[skill_item.skill_cfg.attr_minor] as Slider).value)
			}
			
			var d:uint = t / 24 / 60;
			var h:uint = t % (24 * 60) / 60;
			var m:uint = t % 60;
			var s:uint = Math.ceil((t - d * 24 * 60 - h * 60 - m) * 60);
			
			var str:String = 0 == d ? "" : d + "天";
			str += 0 == h ? "" : h + "小时";
			str += 0 == m ? "" : m + "分钟";
			str += 0 == s ? "" : s + "秒";
			__txt_time.text = str;
		}
		
		private function onAttrChange(event:SliderEvent):void{
			var target:Slider = event.target as Slider;
			
			var txt:TextField = _dic[target] as TextField;
			
			txt.text = txt.text.replace(/\d+/g, target.value);
		}
		
		private function onLevelChange(event:SliderEvent):void{
			__txt_l.text = __txt_l.text.replace(/\d+/g, __sd_l.value);
			
			var tmp_arr:Array = Global.ins.study_arr;
			for each (var skill_cfg:SkillConfig in tmp_arr) {
				skill_cfg.setLevel4Study(__sd_l.value);
			}
			this.showSkills();
		}
		
		private function onSkillSetUpdate(event:GlobalEvent):void{
			this.showSkills();
		}
		
		private function showSkills():void{
			var tmp_arr:Array = Global.ins.study_arr;
			
			while(tmp_arr.length != _spr.numChildren){
				if(tmp_arr.length > _spr.numChildren){
					_item_arr.push(_spr.addChild(new SkillItem4Study()));
				}else if(tmp_arr.length < _spr.numChildren){
					_spr.removeChild(_item_arr.pop());
				}
			}
			
			var skill_item:SkillItem4Study;
			var offset_x:Number = 2.0;
			var offset_y:Number = 2.0;
			for (var i:int = 0; i < tmp_arr.length; ++i) {
				skill_item = _item_arr[i] as SkillItem4Study;
				skill_item.skill_cfg = tmp_arr[i] as SkillConfig;
				
				skill_item.x = offset_x + i % 2 * 220;
				skill_item.y = offset_y + Math.floor(i / 2) * 39;
			}
			__sp.update();
		}
	}
}