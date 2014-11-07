package es.ds{
	public class DragData{
		public var m:uint;
		public var t:*;
		public var p:*;
		public var d:*;
		
		public function DragData(m:uint = 1, t:* = null, p:* = null, d:* = null){
			this.m = m;
			this.t = t;
			this.p = p;
			this.d = d;
		}
	}
}