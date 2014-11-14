package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import by.blooddy.crypto.serialization.JSON;
	
	import es.ds.DragData;
	import es.ds.SkillConfig;
	import es.evt.GlobalEvent;
	import es.ui.SkillEditWindow;
	import es.ui.SkillOutlineWindow;
	import es.ui.SkillStudyWindow;
	import es.ui.VisualContainer;
	import es.ui.VisualObject;

	public final class Global extends EventDispatcher{
		private static var OFFSET:uint = 0;
		
		public static const SKILL_TYPE:Array = [
			{label:"-", id:0},
			{label:"导弹", id:1},
			{label:"导航学", id:2},
			{label:"电子系统", id:3},
			{label:"飞船操控学", id:4},
			{label:"改装件", id:5},
			{label:"工程学", id:6},
			{label:"行星管理", id:7},
			{label:"护盾", id:8},
			{label:"军团管理", id:9},
			{label:"科学", id:10},
			{label:"领导学", id:11},
			{label:"贸易学", id:12},
			{label:"扫描", id:13},
			{label:"社会学", id:14},
			{label:"射击学", id:15},
			{label:"神经增强", id:16},
			{label:"生产", id:17},
			{label:"锁定系统", id:18},
			{label:"无人机", id:19},
			{label:"装甲", id:20},
			{label:"资源处理", id:21},
			{label:"子系统", id:22}
		];
		
		public static const ATTR_TYPE:Array = [
			{label:"-", id:0},
			{label:"感知", id:1},
			{label:"记忆", id:2},
			{label:"毅力", id:3},
			{label:"智力", id:4},
			{label:"魅力", id:5},
		];
		
		private static var _instance:Global;
		
		public static function get ins():Global {
			if(null == _instance){
				_instance = new Global();
			}
			
			return _instance;
		}
		
		private var _panel:Sprite;
		private var _skill_set:Array = [];
		private var _skill_set4edit:Array = [];
		private var _skill_set4study:Array = [];
		private var _skill_set4study_with_depend:Array = [];
		
		private var _max_skill_id:uint = 10000;
		
//		private var _skill_configs_dir:File = new File();
		private var _skill_configs_dir:File = new File("E:/workspace_git/eve_simulator/cfg");
		
		private var _skill_outline_window:SkillOutlineWindow;
		private var _skill_study_window:SkillStudyWindow;
		
		public function setup(panel:Sprite):void{
			_panel = panel;
			
			_skill_outline_window = new SkillOutlineWindow();
			_panel.addChild(_skill_outline_window);
			
			this.selectSkillConfigDir();
		}
		
		private function selectSkillConfigDir():void{
			_skill_configs_dir.addEventListener(Event.SELECT, onSelectDir);
			_skill_configs_dir.browseForDirectory("选择技能配置目录");
		}
		
		private function onSelectDir(event:Event):void{
			this.loadSkillConfigs();
		}
		
		private function loadSkillConfigs():void{
			var skill_configs_file:Array = _skill_configs_dir.getDirectoryListing();
			var skill_config_content:String;
			var skill_config:SkillConfig;
			for each (var skill_config_file:File in skill_configs_file) {
				skill_config_content = readFileContent(skill_config_file);
				skill_config = new SkillConfig().inject(decodeJSON(skill_config_content));
				
				_skill_set[skill_config.id] = skill_config;
				if(_max_skill_id < skill_config.id){
					_max_skill_id = skill_config.id;
				}
			}
			
			GlobalEvent.trigger(GlobalEvent.EVT_SKILL_SET_UPDATE);
		}
		
		public function showSkillEditWindow(skill_cfg:SkillConfig = null, editable:Boolean = true):void{
			if(null == skill_cfg){
				skill_cfg = new SkillConfig();
			}
			var sew:SkillEditWindow = _skill_set4edit[skill_cfg.id] as SkillEditWindow;
			
			if(null == sew){
				_skill_set4edit[skill_cfg.id] = sew = new SkillEditWindow();
			}
			
			if(null == sew.parent){
				sew.skill_cfg = skill_cfg;
				sew.editable = editable;
				
				var offset_x:Number = 243;
				var offset_y:Number = 0;
				sew.x = offset_x;// + OFFSET++ % 10 * 38;
				sew.y = offset_y;
				
				_panel.addChild(sew);
				
				GlobalEvent.trigger(GlobalEvent.EVT_SKILL_SET_UPDATE);
			}else{
				this.hideSkillEditWindow(skill_cfg.id);
			}
		}
		
		public function hideSkillEditWindow(skill_id:uint):void{
			var sew:SkillEditWindow = _skill_set4edit[skill_id] as SkillEditWindow;
			
			if(null != sew){
				_panel.removeChild(sew);
				delete _skill_set4edit[skill_id];
				
				GlobalEvent.trigger(GlobalEvent.EVT_SKILL_SET_UPDATE);
			}
		}
		
		public function showSkillStudyWindow():void{
			if(null == _skill_study_window){
				_skill_study_window = new SkillStudyWindow();
				
				var offset_x:Number = 243;
				var offset_y:Number = 378;
				_skill_study_window.x = offset_x;
				_skill_study_window.y = offset_y;
			}
			
			if(null == _skill_study_window.parent){
				_panel.addChild(_skill_study_window);
			}
		}
		
		public function getSkillConfig(skill_id:uint):SkillConfig{
			return _skill_set[skill_id];
		}
		
		public function isSkillInEdit(skill_id:uint):Boolean{
			return null != _skill_set4edit[skill_id];
		}
		
		public function isSkillInStudy(skill_id:uint):Boolean{
			return null != skill_set4study_with_depend[skill_id];
		}
		
		private function get skill_set4study_with_depend():Array{
			var f:Function = function(sc:SkillConfig):void{
				_skill_set4study_with_depend[sc.id] = sc;
				
				var depen_cfg:SkillConfig;
				for (var sck:String in sc.depend) {
					depen_cfg = _skill_set[sck];
					if(depen_cfg.getLevel4Study() < sc.depend[sck]){
						depen_cfg.setLevel4Study(sc.depend[sck]);
					}
					f(depen_cfg);
				}
			}
			
			_skill_set4study_with_depend.length = 0;
			for each (var temp_cfg:SkillConfig in _skill_set4study) {
				f(temp_cfg);
			}
			
			return _skill_set4study_with_depend;
		}
		
		public function cleanStudySkill():void{
			_skill_set4study.length = 0;
			
			for each (var skill_cfg:SkillConfig in _skill_set4study_with_depend) {
				skill_cfg.setLevel4Study(0);
			}
			_skill_set4study_with_depend.length = 0;
			
			GlobalEvent.trigger(GlobalEvent.EVT_SKILL_SET_UPDATE);
		}
		
		private function readFileContent(file:File):String{
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var content:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return content;
		}
		
		private function writeFileContent(file_path:String, content:String):void{
			var file:File = new File(file_path);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(content);
			fs.close();
		}
		
		public function saveSkill(skill_config:SkillConfig):void{
			if(null == _skill_set[skill_config.id]){
				skill_config.id = _max_skill_id += 10;
				
				_skill_set4edit[skill_config.id] = _skill_set4edit[0];
				delete _skill_set4edit[0];
			}
			_skill_set[skill_config.id] = skill_config;
			writeFileContent(_skill_configs_dir.nativePath + "\\" + skill_config.id, encodeJSON(skill_config));
			
			if(this.isSkillInStudy(skill_config.id)){
				if(skill_config.isMaxLevel()){
					this.studySkill(skill_config);
				}else{
					var depen_key:String;
					var depen_cfg:SkillConfig;
					for (depen_key in skill_config.depend) {
						depen_cfg = _skill_set[depen_key];
						depen_cfg.setLevel4Study(0);
					}
				}
			}
			
			GlobalEvent.trigger(GlobalEvent.EVT_SKILL_SET_UPDATE);
		}
		
		public function studySkill(skill_config:SkillConfig):void{
			if(null  == _skill_set4study[skill_config.id]){
				_skill_set4study[skill_config.id] = skill_config;
			}else{
				skill_config.setLevel4Study(0);
				delete _skill_set4study[skill_config.id];
			}
			
			GlobalEvent.trigger(GlobalEvent.EVT_SKILL_SET_UPDATE);
			
			if(null == _skill_study_window || null == _skill_study_window.parent){
				this.showSkillStudyWindow();
			}
		}
		
		public function searchSkill(key_word:String):Array{
			var result:Array = [];
			
			for each (var skill_config:SkillConfig in _skill_set) {
				if(-1 < skill_config.name.indexOf(key_word)){
					result.push(skill_config);
				}
			}
			
			return result;
		}
		
		public function encodeJSON(value:*):String{
			return by.blooddy.crypto.serialization.JSON.encode(value);
		}
		
		public function decodeJSON(value:String):*{
			return by.blooddy.crypto.serialization.JSON.decode(value);
		}
		
		public function get skill_arr():Array{
			var result:Array = [];
			for each (var skill_config:SkillConfig in _skill_set) {
				result.push(skill_config);
			}
			
			result.sort(function(fst:SkillConfig, snd:SkillConfig):int{
				if(fst.id >  snd.id){
					return 1;
				}
				return -1;
			});
			
			return result;
		}
		
		public function get study_arr():Array{
			var result:Array = [];
			for each (var skill_config:SkillConfig in skill_set4study_with_depend) {
				result.push(skill_config);
			}
			
			result.sort(function(fst:SkillConfig, snd:SkillConfig):int{
				if(fst.id >  snd.id){
					return 1;
				}
				return -1;
			});
			
			return result;
		}
		
		private const _drag_map:Dictionary = new Dictionary();
		public function enableDrag(target:VisualContainer, dd:DragData):void{
			if(null != _drag_map[target]){
				return;
			}
			
			_drag_map[target] = dd;
			target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function disableDrag(target:VisualContainer):void{
			if(null  == _drag_map[target]){
				return;
			}
			
			delete _drag_map[target];
			target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void{
			if(event.target != event.currentTarget){
				return;
			}
			var target:VisualObject = event.target as VisualObject;
			target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(event:MouseEvent):void{
			if(event.target != event.currentTarget){
				return;
			}
			var target:VisualObject = event.target as VisualObject;
			target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			var dd:DragData = _drag_map[target] as DragData;
			switch(dd.m){
				case 1:{
					target.startDrag();
					break;
				}
				case 2:{
					target.startDrag();
					break;
				}
				case 3:{
					target.startDrag();
					break;
				}
				default:{
					break;
				}
			}
		}
		
		private function onMouseUp(event:MouseEvent):void{
			if(event.target != event.currentTarget){
				return;
			}
			var target:VisualObject = event.target as VisualObject;
			target.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			target.stopDrag();
		}
	}
}