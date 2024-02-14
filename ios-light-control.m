//
//  ControlLight
//
//  Created by psalishol on 11/26/23.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVCaptureDevice.h>

#import "RCTTorchBrightnessControllerModule.h"

@implementation RCTTorchBrightnessControllerModule

// To export a module named TorchBrightnessController to the RN NativeModules.
// Please note that the same module name should be used in the android implementation
// So as to prevent having to create different implementation file for both ios and android.
RCT_EXPORT_MODULE(TorchBrightnessController);


// Export createCalenderEvent method in TorchBrightnessController.
// This method sets the brightness to the defined level
RCT_EXPORT_METHOD(setBrightness:(double)level  
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  RCTLogInfo(@"Pretending to set brightness to level %f", level);
  
  // Throw OutOfRange exception if the brightness level is negative or greater than 1
  if (level > 1 || level < 0.0) {
    // Reject the promise with the error
    reject(@"OutOfRangeException", @"brigtness level must be between 0.0 and 1.0", nil);
  }else {
    
    @try {
      AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
      
      if (device) {
        if ([device hasTorch] && [device isTorchAvailable]) {
          BOOL success = [device lockForConfiguration:nil];
          if (success) {
            // if the torch is currently active, set the level to the selected level
            if ([device isTorchActive]) {
              [device setTorchModeOnWithLevel:level error:nil];
            }else {
              // turn on torch
              [device setTorchMode:AVCaptureTorchModeOn];
              [device setTorchModeOnWithLevel:level error:nil];
            }
            
            
            if (level <= 0) {
              // set the torch mode to off
              [device setTorchMode:AVCaptureTorchModeOff];
            }
            
            [device unlockForConfiguration];
            
          }
          
        }else {
          
        }
        
        RCTLogInfo(@"Pretending to set brightness to level %@", device);
        
        resolve(@("done"));
      }
    } @catch (NSException *exception) {
      reject(@"Exception", @"error occured while trying to set brightness", nil);
    }
  }
}
//@implementation RCTTorchBrightnessControllerModule
//
//RCT_EXPORT_METHOD(createCalendarEvent:(NSString *)name location:(NSString *)location)
//{
// RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
//}

//RCT_EXPORT_MODULE(TorchBrightnessController);

// get
//RCT_EXPORT_METHOD(setBrightness: (double)brightness)
//{
//    RCTLogInfo(@"Trying to set brightness level to %@", brightness)
//
  
//  @try {
//    // Checks if the brightness given is more than or equal
//    // 0 and less than or equal (1). if the brightness is any less than 0.0 or greater than 1.0
//    // it throws an error.
//    if (brightness > 1 || brightness < 0){
//      NSException *exception = @"brightness out of range"
//      errorCallback(@[exception])
//    }else {
//      AVCaptureDevice *device = [AVCaptureDevice AdefaultDeviceWithMediaType:AVMediaTypeVideo];
//
//      if (device){
//        // checks if the device has torch and the torch is currently available for use.
//        if (device.hasTorch && device.isTorchAvailable) {
//          CGFloat intensity = brightness
//          [device setTorchModeOn: brightness error : nil]
//          sucessCallback()
//        }else{
//          NSException *exception = @"torch is currently not available for use or device has no torch"
//          // this is the main thing to be used in the whole of th
//          errorCallback(@[exception])
//        }
//      }else {
//        NSException *exception = @"device not found"
//        errorCallback(@[exception])
//      }
//    }
//  } @catch (NSException *exception) {
//    errorCallback(@[exception])
//  }
//}+ (NSString *)moduleName {
//}

@end
