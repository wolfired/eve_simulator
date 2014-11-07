package es.ui{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class VisualObject extends Sprite{
		
		protected var _skin:DisplayObjectContainer;
		
		public function VisualObject(skin_clazz:Class = null){
			if(null == skin_clazz){
				skin_clazz = Sprite;
			}
			_skin = this.addChild(new skin_clazz()) as DisplayObjectContainer;
			_skin.mouseEnabled = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			this.setup();
		}
		
		private function onRemovedFromStage(event:Event):void{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.cleanup();
		}
		
		protected function setup():void{
			
		}
		
		protected function cleanup():void{
			
		}
	}
}