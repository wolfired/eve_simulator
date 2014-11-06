package ui{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class VisualContainer extends Sprite{
		
		protected var _skin:DisplayObjectContainer;
		
		public function VisualContainer(skin_clazz:Class = null){
			if(null == skin_clazz){
				skin_clazz = Sprite;
			}
			_skin = this.addChild(new skin_clazz()) as DisplayObjectContainer;
			_skin.mouseEnabled = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.setup();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(event:Event):void{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			this.cleanup();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function setup():void{
			
		}
		
		protected function cleanup():void{
			
		}
		
		private function onMouseDown(event:MouseEvent):void{
			if(event.target != event.currentTarget){
				return;
			}
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(event:MouseEvent):void{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			this.startDrag();
		}
		
		private function onMouseUp(event:MouseEvent):void{
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			this.stopDrag();
		}
	}
}
