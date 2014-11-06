package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import by.blooddy.crypto.serialization.JSON;
	
	import ui.SkillEditWindow;
	import ui.SkillOutlineWindow;

	public final class Global extends EventDispatcher{
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
		private var _max_skill_id:uint = 10000;
		private var _skill_configs_dir:File = new File();
		
		public function setup(panel:Sprite):void{
			_panel = panel;
			_panel.addChild(new SkillOutlineWindow());
			
			this.selectSkillConfigDir();
		}
		
		private function selectSkillConfigDir():void{
			_skill_configs_dir.addEventListener(Event.SELECT, loadSkillConfigs);
			_skill_configs_dir.browseForDirectory("选择技能配置目录");
		}
		
		private function loadSkillConfigs(event:Event):void{
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
			
			GlobalEvent.trigger(GlobalEvent.EVT_LOADED_SKILL_CONFIGS);
		}
		
		public function showWindow(w:Sprite):void{
			
		}
		
		public function showSkillEditWindow(skill_cfg:SkillConfig = null):void{
			var sew:SkillEditWindow = new SkillEditWindow();
			sew.skill_cfg = skill_cfg;
			_panel.addChild(sew);
		}
		
		public function readFileContent(file:File):String{
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var content:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return content;
		}
		
		public function writeFileContent(file_path:String, content:String):void{
			var file:File = new File(file_path);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(content);
			fs.close();
		}
		
		public function saveSkillConfig(skill_config:SkillConfig):void{
			if(null == _skill_set[skill_config.id]){
				skill_config.id = _max_skill_id += 10;
			}
			_skill_set[skill_config.id] = skill_config;
			writeFileContent(_skill_configs_dir.nativePath + "\\" + skill_config.id, encodeJSON(skill_config));
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
			
			result.sort(function(fst:Object, snd:Object):int{
				if(fst.id >  snd.id){
					return 1;
				}
				return -1;
			});
			
			return result;
		}
	}
}