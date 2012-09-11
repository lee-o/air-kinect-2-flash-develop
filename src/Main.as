package 
{
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceErrorEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceInfoEvent;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.mssdk.data.MSSkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lionel
	 */
	public class Main extends Sprite 
	{
		public static const KinectMaxDepthInFlash:uint = 200;

		private var device:Kinect;
		private var rgbBitmap:Bitmap;
		private var depthBitmap:Bitmap;

		private var rgbSkeletonContainer:Sprite;
		private var depthSkeletonContainer:Sprite;
		private var skeletonContainer:Sprite;

	
		

		
		private var chosenSkeletonId:int = -1;	
		public function Main():void 
		{
			if (Kinect.isSupported()) {
				trace("yoooooooooo");
				device = Kinect.getDevice();

				rgbBitmap = new Bitmap();
				addChild(rgbBitmap);

				depthBitmap = new Bitmap();
				addChild(depthBitmap);

				rgbSkeletonContainer = new Sprite();
				addChild(rgbSkeletonContainer);

				depthSkeletonContainer = new Sprite();
				addChild(depthSkeletonContainer);

				skeletonContainer = new Sprite();
				addChild(skeletonContainer);
				/*
				device.addEventListener(DeviceEvent.STARTED, kinectStartedHandler, false, 0, true);
				device.addEventListener(DeviceEvent.STOPPED, kinectStoppedHandler, false, 0, true);
				device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler, false, 0, true);
				
				device.addEventListener(DeviceInfoEvent.INFO, onDeviceInfo, false, 0, true);
				device.addEventListener(DeviceErrorEvent.ERROR, onDeviceError, false, 0, true);
*/
				//device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler, false, 0, true);
				device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, depthImageUpdateHandler, false, 0, true);
				device.addEventListener(DeviceEvent.STARTED, onStart);

				
				var settings:KinectSettings = new KinectSettings();
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_1280_960;
				settings.depthEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_1280_960;
				settings.depthShowUserColors = true;
				settings.skeletonEnabled = true;

				device.start(settings);
				
				

				//initUI(settings);

				addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			}
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			skeletonContainer.graphics.clear();
			for each(var user:User in device.usersWithSkeleton) {
				skeletonContainer.graphics.beginFill(0xff0000);
				//trace(user.hasSkeleton);
				//trace(user.position.world);
				//trace(user.head);
				/*
				if(user.leftHand){
				
				}
				*/
				for each(var joint:MSSkeletonJoint in user.skeletonJoints) {
					
					trace(joint.name);
					for each(var p:* in joint) {
							trace("++++++"+p.position.depth.x);
					}
					skeletonContainer.graphics.drawCircle(joint.position.depth.x, joint.position.depth.y, 20);
				}
			}
		}
		protected function depthImageUpdateHandler(event:CameraImageEvent):void {
			depthBitmap.bitmapData = event.imageData;
			//layout();
		}
		private function onStart(e:DeviceEvent):void 
		{
			trace("on start" +e);
		}
		
	}
	
}