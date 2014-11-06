package{
	import flash.events.Event;
	
	public class GlobalEvent extends Event{
		
		public static function trigger(event_type:String):void{
			var evt:GlobalEvent = new GlobalEvent(event_type);
			Global.ins.dispatchEvent(evt);
		}
		
		public static const EVT_LOADED_SKILL_CONFIGS:String = "GlobalEvent_EVT_LOADED_SKILL_CONFIGS";
		
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}