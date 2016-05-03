//
//  HJPlayingViewController_v2.h
//  living
//
//  Created by Lijia on 15/5/18.
//  Copyright (c) 2015年 MJHF. All rights reserved.
//

#import "DSViewController.h"
@class LivingSwitchObject;
@class HJSeedAnchorResponse;
@class HJReplay;
typedef void(^HJPlayingToReplayBlock)(HJReplay *replay);
//pagetype 1为聊天 2为结束页面
typedef void(^HJPlayingToChat)(HJSeedAnchorResponse *anchor, NSInteger pageType);

@class HJSeedLiveResponse;
@class HJSeedAnchorResponse;
@interface HJPlayingViewController_v2 : DSViewController

/** 播放页面跳转到回放页面 */
@property(nonatomic, strong) HJPlayingToReplayBlock toReplayBlock;

/** 关闭按钮点击事件 */
@property(nonatomic, strong) HJPlayingToChat onClickCloseButtonBlock;

/** 来自聊天室 */
@property(nonatomic, assign) NSInteger pageType;

/** 用来做高斯模糊的图 */
@property (nonatomic, strong) UIImage *blurImage;
@property (weak, nonatomic) IBOutlet UIView *homeContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBarBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *inputBar;
@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *topMask;
@property (weak, nonatomic) IBOutlet UIImageView *bottomMask;
@property (weak, nonatomic) IBOutlet UIView *userListContainer;
@property (weak, nonatomic) IBOutlet UIView *praiseBtnContainer;
@property (weak, nonatomic) IBOutlet UIView *heartsEmitterContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userListWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainer;
@property (weak, nonatomic) IBOutlet UIView *shareRemindView;
@property (weak, nonatomic) IBOutlet UIImageView *shareRemindBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *shareRemindLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenShotBtn;
@property (weak, nonatomic) IBOutlet UIView *chatRedDotView;

/** 存储左右切换直播时，存储的供切换的数据 */
@property (nonatomic, strong) NSArray<LivingSwitchObject *> *feedData;

/**
 *  存储数据源类型
 *  home : [HJHomeIntf sharedIntfs] home_getNewsFeedsOffset
 *  live/latest/discover : [HJSeedIntf sharedIntfs] feed_getFeeds
 */
@property (nonatomic, strong) NSString *feedsName;
@property (nonatomic, strong) NSDictionary *statisData;

@end
