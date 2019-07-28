//
//  SMCameraController.h
//  SMAPP
//
//  Created by Sichen on 28/7/19.
//  Copyright © 2019 RXP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, SMCameraPosition) {
    SMCameraPositionRear,
    SMCameraPositionFront
};

typedef NS_ENUM(NSInteger, SMCameraFlash) {
    SMCameraFlashOff,
    SMCameraFlashOn,
    SMCameraFlashAuto
};

extern NSString *const SMCameraErrorDomain;
typedef NS_ENUM(NSInteger, SMCameraErrorCode) {
    SMCameraErrorCodeCameraPermission = 10,
    SMCameraErrorCodeMicrophonePermission = 11,
    SMCameraErrorCodeSession = 12,
    SMCameraErrorCodeVideoNotEnabled = 13
};

@interface SMCameraController : UIViewController

// Default is: SMCameraPositionFront
@property (nonatomic, readonly) SMCameraFlash flash;
// Default is: SMCameraFlashOff
@property (nonatomic, readonly) SMCameraPosition position;

// Call this method if you want to customize flash and position.
- (instancetype)initWithFlash:(SMCameraFlash)flash position:(SMCameraPosition)position;

// Default is: AVCaptureSessionPresetHigh.
// Make sure to call before calling - (void)start method, otherwise it would be late.
@property (nonatomic, copy) NSString *quality;
// Default is YES.
@property (nonatomic) BOOL tapToFocus;
// Default is YES.
@property (nonatomic, getter=isZoomingEnabled) BOOL zoomingEnabled;
// Fixess the orientation after the image is captured is set to Yes.
// see: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
@property (nonatomic) BOOL fixOrientationAfterCapture;

// Triggered on device change.
@property (nonatomic, copy) void (^onDeviceChange)(SMCameraController *camera, AVCaptureDevice *device);
// Triggered on any kind of error.
@property (nonatomic, copy) void (^onError)(SMCameraController *camera, NSError *error);

// Starts running the camera session.
- (void)start;
// Stops the running camera session. Needs to be called when the app doesn't show the view.
- (void)stop;

// Capture an image.
// exactSeenImage If set YES, then the image is cropped to the exact size as the preview. So you get exactly what you see.
// animationBlock you can create your own animation by playing with preview layer.
- (void)capture:(void (^)(SMCameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture exactSeenImage:(BOOL)exactSeenImage animationBlock:(void (^)(AVCaptureVideoPreviewLayer *))animationBlock;
- (void)capture:(void (^)(SMCameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture exactSeenImage:(BOOL)exactSeenImage;
- (void)capture:(void (^)(SMCameraController *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture;

// Changes the posiition of the camera (either back or front) and returns the final position.
- (SMCameraPosition)togglePosition;
// Update the flash mode of the camera. Returns true if it is successful. Otherwise false.
- (BOOL)updateFlashMode:(SMCameraFlash)cameraFlash;

// Checks if flash is avilable for the currently active device.
- (BOOL)isFlashAvailable;
// Checks is the front camera is available.
+ (BOOL)isFrontCameraAvailable;
// Checks is the rear camera is available.
+ (BOOL)isRearCameraAvailable;

@end
