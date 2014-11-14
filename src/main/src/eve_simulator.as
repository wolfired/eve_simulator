package{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	import es.ui.VisualLayer;
	
	[SWF(width="1024", height="661")]
	public class eve_simulator extends VisualLayer{
		public function eve_simulator(){
			this.stage.align = StageAlign.LEFT;
			this.stage.quality = StageQuality.BEST;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Global.ins.setup(this);
		}
	}
}