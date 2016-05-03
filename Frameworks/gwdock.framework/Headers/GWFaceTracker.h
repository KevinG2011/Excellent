//
//  GWFaceTracker.h
//  gwdock
//	人脸追踪管理器,负责蓝牙设备的扫描连接,人脸追踪功能
//  Created by moon on 16/3/1.
//  Copyright © 2016年 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GWFaceTracker;
@protocol GWFaceTrackerDelegate <NSObject>
@optional
- (void)faceTrackerDidConnectDevice:(GWFaceTracker *)track;//连接上设备通知
- (void)faceTrackerDidDisconnectDevice:(GWFaceTracker *)track;//设备断开连接通知
@end

@interface GWFaceTracker : NSObject
@property(nonatomic,assign) id<GWFaceTrackerDelegate> delegate;
@property(nonatomic,assign) CGSize faceContainerSize;//人脸框所在的外层容器尺寸,默认为屏幕尺寸
@property(nonatomic,assign) BOOL useBackCamera;//是否是使用后置摄像头,默认为NO,即使用前置摄像头UIDeviceOrientationUnknown代表不固定,将会自动判断设备朝向.默认为UIDeviceOrientationUnknown

- (void)scanAndConnectDockDeviceWithTimeout:(NSTimeInterval)timeout completion:(void(^)(BOOL connect,NSError *error))completion;//扫描设备,并自动连接设备.完成后调用回调.error为连接失败的信息
- (BOOL)isDockDeviceConnected;//是否连接上设备
- (void)disconnectDockDevice;//断开设备连接
- (void)reconnectDockDeviceWithCompletion:(void(^)(BOOL connect,NSError *error))completion;//重新对上次的设备建立连接

- (void)startTrack;//开启人脸追踪
- (void)stopTrack;//停止人脸追踪
- (BOOL)isTracking;//是否正在人脸追踪

- (void)trackFaceRect:(CGRect)faceRect;//实时追踪人脸,使人脸中心点移动到外层容器中间区域
- (void)trackFaceRect:(CGRect)faceRect toTargetCenterRect:(CGRect)targetCenterRect;//实时追踪人脸,使人脸中心移动到targetCenterRect
- (void)trackNoFace;//没有人脸
@end
