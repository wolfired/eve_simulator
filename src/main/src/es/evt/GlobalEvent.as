package es.evt{
	import flash.events.Event;
	
	public class GlobalEvent extends Event{
		
		public static function trigger(event_type:String):void{
			var evt:GlobalEvent = new GlobalEvent(event_type);
			Global.ins.dispatchEvent(evt);
		}
		
		public static const EVT_SKILL_SET_UPDATE:String = "GlobalEvent_EVT_SKILL_SET_UPDATE";
		
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}