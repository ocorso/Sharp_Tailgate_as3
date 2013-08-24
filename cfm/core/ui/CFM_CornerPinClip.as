package cfm.core.ui
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.objects.CFM_Object;
	
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import cfm.core.events.CornerPinClipEvent;
	
	public class CFM_CornerPinClip extends CFM_Object
	{
		private var coordList:XMLList;
		private var framesData:Vector.<Array> = new Vector.<Array>();
		private var uvmap:Vector.<Number>;
		private var triangles:Vector.<int>;
		private var verticies :Vector.<Number>;
		
		private var startFrame:int;
		private var currentBitmapIndex:Number = 0;
		private var currentBitmapData:BitmapData;
		private var bitmapDataList:Vector.<BitmapData>;
		private var shapeContainer:CFM_ObjectContainer;
		
		private var maxBlur:Number = 4;
		private var blur:BlurFilter = new BlurFilter(maxBlur,maxBlur);
		
		private var ul:Point = new Point(10,10);
		private var ur:Point = new Point(100,10);
		private var ll:Point = new Point(10,100);
		private var lr:Point = new Point(100,100);
		
		private var currentFrame:int = 0;
		
		public function CFM_CornerPinClip(_startFrame:int, _coordList:XMLList, _bitmapDataList:Vector.<BitmapData>, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			startFrame = _startFrame;
			coordList = _coordList;
			bitmapDataList = _bitmapDataList;
			
			uvmap = new Vector.<Number>()
			uvmap.push(0,0, 1,0, 0,1, 1,1);
			
			triangles    = new Vector.<int>();
			triangles.push(0,1,2, 1,3,2);
			
			verticies = new Vector.<Number>();
			
			super("CornerPinClip", _autoInit, _autoDestroy);
		}
		
		override protected function build():void{
			shapeContainer = new CFM_ObjectContainer();
			shapeContainer.renderTo(this);
			
			parseFrames();
			
			setBitmapData(currentBitmapIndex);
			
			if(bitmapDataList.length > 1)
				initNextBitmap();
		}
		
		private function initNextBitmap():void{
			TweenMax.to(shapeContainer, .5, {delay:6, autoAlpha:0, onComplete:nextBitmap});
		}
		
		private function nextBitmap():void{
			currentBitmapIndex++;
			
			if(currentBitmapIndex > bitmapDataList.length-1)
				currentBitmapIndex = 0;
			
			setBitmapData(currentBitmapIndex);
			
			TweenMax.to(shapeContainer, .5, {autoAlpha:1, onComplete:initNextBitmap});
		}
		
		public function parseFrames():void{				
			for each(var f:XML in coordList){
				var points:Array = [];
				
				for each(var p:String in String(f).split(";")){
					var vals:Array = p.split(",");
					points.push(new Point(vals[0], vals[1]));
				}
				
				framesData.push(points);
			}
			
			buildFramesComplete();
		}
		
		public function buildFramesComplete():void{
			dispatchEvent(new CornerPinClipEvent(CornerPinClipEvent.COMPLETE, 1));
		}
		
		private function setBitmapData(_index:Number):void{
			currentBitmapData = bitmapDataList[_index];
		}
		
		override public function destroy(e:Event):void{
			super.destroy(e);
			
			TweenMax.killTweensOf(shapeContainer);
		}
		
		public function update(_frame:Number = Number.NaN):void{	
			if(!isNaN(_frame))
				currentFrame = _frame-startFrame-1;
			
			if(!currentBitmapData)
				currentBitmapData = bitmapDataList[currentBitmapIndex];
			
			if(currentFrame >= 0 && currentFrame <= framesData.length-1){
				for(var i:Number = 0 ;i<8; i++)
					verticies[i] =  framesData[currentFrame][Math.floor(i*.5)][i%2 == 0 ? "x" : "y"];
				
				shapeContainer.graphics.clear();
				shapeContainer.graphics.beginBitmapFill( currentBitmapData, null, false, true ); 
				shapeContainer.graphics.drawTriangles( verticies, triangles, uvmap);
				
				if(coordList[currentFrame].@blur && !isNaN(coordList[currentFrame].@blur))
					blur.blurX = blur.blurY = maxBlur*coordList[currentFrame].@blur;
				else
					blur.blurX = blur.blurY = 0;
				
				shapeContainer.filters = [blur];
			}
		}
	}
}