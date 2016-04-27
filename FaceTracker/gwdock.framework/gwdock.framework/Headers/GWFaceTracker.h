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
@property(nonatomic,assign) BOOL useBackCamera;//是否是使用后置摄像头,默认为NO,即使用前置摄像头

/**
 *  扫描设备,并自动连接设备.完成后调用回调.
 *
 *  @param timeout    扫描超时时间,单位为秒,0代表不超时,此时会一直扫描.
 *  @param completion 超时没有扫描到设备,或者连接上设备时回调.error为失败信息
 */
- (void)scanAndConnectDockDeviceWithTimeout:(NSTimeInterval)timeout completion:(void(^)(BOOL connect,NSError *error))completion;

- (BOOL)isDockDeviceConnected;//是否连接上设备
- (void)disconnectDockDevice;//断开设备连接
- (void)reconnectDockDeviceWithCompletion:(void(^)(BOOL connect,NSError *error))completion;//重新对上次的设备建立连接

- (void)startTrack;//开启人脸追踪
- (void)stopTrack;//停止人脸追踪,同时停止设备转动
- (BOOL)isTracking;//是否正在人脸追踪

/**
 *  实时追踪人脸,使人脸中心点移动到外层容器中间区域(faceContainerSize中间区域)
 *
 *  @param faceRect 人脸在外层容器中的区域.该 CGRect 不需要考虑手机横屏时的情况,内部会自动进行朝向适应
 */
- (void)trackFaceRect:(CGRect)faceRect;

/**
 *  实时追踪人脸,使人脸中心移动到targetCenterRect
 *
 *  @param faceRect         人脸在外层容器中的区域.该 CGRect 不需要考虑手机横屏时的情况,内部会自动进行朝向适应
 *  @param targetCenterRect  人脸中心点要移动的区域
 */
- (void)trackFaceRect:(CGRect)faceRect toTargetCenterRect:(CGRect)targetCenterRect;

/**
 *  通知没有追踪到人脸
 */
- (void)trackNoFace;
@end
