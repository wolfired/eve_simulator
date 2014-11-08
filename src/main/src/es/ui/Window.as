package es.ui{
	import flash.events.MouseEvent;

	public class Window extends VisualContainer{
		public function Window(skin_clazz:Class=null){
			super(skin_clazz);
		}
		
		override protected function cleanup():void{
			super.cleanup();
			
			this.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		override protected function setup():void{
			super.setup();
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void{
			this.parent.addChild(this);
		}
	}
}