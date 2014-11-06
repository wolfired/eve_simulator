package ui{
	import flash.text.TextField;
	
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	
	import skin.Skin_SkillItem;
	
	public class SkillItem extends VisualContainer implements ICellRenderer{
		
		private function get __txt_name() : TextField { return _skin["_txt_name"]; }
		
		private var _data:SkillConfig;
		private var _listData:ListData;
		private var _selected:Boolean;
		
		public function SkillItem(skin_clazz:Class = null){
			if(null == skin_clazz){
				skin_clazz = Skin_SkillItem;
			}
			super(skin_clazz);
		}
		
		public function get data():Object{
			return _data;
		}
		
		public function set data(value:Object):void{
			_data = value as SkillConfig;
			
			__txt_name.text = _data.name + "x" + _data.times;
		}
		
		public function get listData():ListData{
			return _listData;
		}
		
		public function set listData(value:ListData):void{
			_listData = value;
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
		public function set selected(value:Boolean):void{
			_selected = value;
		}
		
		public function setMouseState(value:String):void{
			
		}
		
		public function setSize(w:Number, h:Number):void{
			
		}
	}
}