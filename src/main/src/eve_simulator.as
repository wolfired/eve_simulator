package{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	[SWF(width="768", height="513")]
	public class eve_simulator extends Sprite{
		public function eve_simulator(){
			this.stage.align = StageAlign.LEFT;
			this.stage.quality = StageQuality.BEST;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Global.ins.setup(this);
		}
	}
}