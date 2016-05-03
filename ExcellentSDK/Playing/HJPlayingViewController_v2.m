//
//  HJPlayingViewController_v2.m
//  living
//
//  Created by zero on 15/5/18.
//  Copyright (c) 2015年 MJHF. All rights reserved.
//

#import "HJPlayingViewController_v2.h"
#import <AVFoundation/AVFoundation.h>
#import "HJLiveErrorEndViewController.h"
#import "GLView.h"
#import "HJSeedIntf.h"
#import <UIImageView+WebCache.h>
#import "HJChatRoomMgr.h"
#import "HJHeartsEmitter.h"
#import "JQDealPraiseManager.h"
#import "HJUserListView.h"
#import "HJAnchorView.h"
#import "UserPrefs.h"
#import "JQDealPraiseViewController.h"
#import "HJChatController_v2.h"
#import "HJUserProfileView.h"
#import "HJPlayer.h"
#import "HJUserManager.h"
#import "UIImage+BlurredFrame.h"
#import "HJReplayIntf.h"
#import "Live.h"
#import "UIImage+WRCaptureImage.h"
#import "HJSeedIntf.h"
#import "Feeds.h"
#import "Feed.h"
#import "HJMyHomeViewController.h"
#import "HJCoinsTipsView.h"
#import "HJWalletCloudTextManager.h"
#import "HJBlockedManager.h"
#import "HJGiftListView.h"
#import "HJPurchaseViewController.h"
#import "HJLiveEndViewController.h"
#import "HJToastMgr.h"
#import "Global.h"
#import "HJPlayReporter.h"
#import "StatisticsManager.h"
#import "HJUserInfoCard.h"
#import "HJGiftEffectView.h"
#import "HJOfficialNoticeView.h"
#import "HJLiveLoadingTipView.h"
#import "HJPocketInterface.h"
#import "HJRedPacketViewController.h"
#import "HJSendRedEnvelopeViewController.h"
#import "HJRedPacketViewController.h"
#import "HJRedEnvelopeView.h"
#import "HJRedEnvelopeView.h"
#import "HJAnimView.h"
#import "HJWalletManager.h"
#import "HJShareData.h"
#import "HJShareView.h"
#import "HJScreenShotView.h"
#import "UIDevice+Ext.h"
#import "HJScreenShotView.h"
#import "LivingSwitchView.h"
#import "LivingSwitchObject.h"
#import "LiveGuideView.h"
#import "HJFeiPingAnimView.h"
#import "HJUserInfoCard.h"
#import "../Vendors/JPlayer/statistics_entry.h"
#import "NSString+md5.h"
#import "HJNetworkMgr.h"
#import "HJCheckInManager.h"
#import "HJMessageCenterManager.h"
#import "HJWalletInterface.h"
#import "HJGuardRankViewController.h"
#import "HJWalletInterface.h"
#import "HJGuardRankService.h"
#import "HJReappearManager.h"
#import "HJMessageCenterManager.h"
#import "LiveFeeds.h"
#import "HJHomeIntf.h"
#import "HJPlayingEndViewController.h"

#define threeDaysTiming @"threeDaysTiming"
#define watchBroadcastTiming @"watchBroadcastTiming"
#define whetherToSayLater @"whetherToSayLater"

#define DEBUG_PLAY_VIEW (0 && DEBUG)
#define DEBUG_PLAYER_CPU_BUG (0)

#define LoadStatusConnecting   10001
#define LoadStatusStop         10002

#define ANIMATE_DURATION    0.2
#define FLYSCREEN_HEIGHT      90

// 花椒豆的y值
#define HUAJIAO_COIN_VIEW_Y   65

// 弹幕单行高度
#define CELL_HEIGHT           23.2639999
// 弹幕cell间距
#define CELL_SPACING          1.5

#define kNOTIFICLOSEPLAYINGVC @"com.notifi.close.playingVC"

// "主播小助手：分享给好友，为主播加油助威吧～"出现时间间隔
#define LOCAL_MSG_SHOW_DURATION  5*60
#define LIVE_ASSISTANT_MSG       @"主播小助手: 分享给好友，为主播加油助威吧～"

// 分享提醒
#define SHARE_REMIND_SHOW_DURATION  3*60

/**
 3.5.1新增播放失败时重试的机制
 如果getFeedInfo接口返回失败 或者 （播放器连接超时失败时进行重试并且服务器没有返回1505或1506错误时）
 定义重试间隔 RETRY_INTERVAL 
 定义最大重试次数，当超过重试次数时，直接关闭
 */
#define RETRY_INTERVAL  5 //每5秒重试一次
#define RETRY_MAX_TIMES 5 //最多重试4次

// 拉取花椒币的重试机制
#define RETRY_COIN_INTERVAL  2 //每2秒重试一次
#define RETRY_COIN_MAX_TIMES 3 //最多重试3次

extern CGFloat mainHeight;

@interface HJPlayingViewController_v2 ()
<HJChatRoomDelegate, UIGestureRecognizerDelegate,HJUserInfoCardDelegate, UITextFieldDelegate, HJUserListViewDelegate, HJChatControllerDelegate, HJPlayerDelegate, HJAnchorViewDelegate,UIAlertViewDelegate, LivingSwitchViewDelegate, LivingSwitchViewDatSource,HJGiftEffectViewDelegate,HJFeiPingAnimViewDelegate,HJCoinsTipsViewDelegate,HJPlayingEndViewControllerDelegate>{
    BOOL isToSayLater;  // 从用户配置中取出，默认为yes
    NSDate *watchBroadcastTime;  //  看播开始时间
    BOOL cloudKeyIsShowScoreMessage; //  云控开关
}

@property (nonatomic,strong) UIView *iconView;
@property (nonatomic,strong) UIView *emptyView;
@property (strong, nonatomic) HJGiftListView *giftVIew;
@property (nonatomic) BOOL inPunishment;
@property (nonatomic) BOOL contentHidden;
//@property (nonatomic) NSInteger liveStartTime;
@property (nonatomic, assign)NSInteger playingTime;
@property (nonatomic, assign) BOOL redPocketSwitchOn;
@property (nonatomic, assign) BOOL mirrorIsShow;
@property (weak, nonatomic) IBOutlet UIButton *closeFullScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *danmuSwitchBtn;
@property (nonatomic, strong) HJRedEnvelopeView *redEnvelopeView;
@property (nonatomic, assign) BOOL currencySwitch;
@property (nonatomic, strong) NSTimer *localMsgTimer;
@property (nonatomic, strong) NSTimer *shareRemindTimer;
@property (nonatomic, weak) HJSendRedEnvelopeViewController *redEnvelopeVC;
/** 直播信息，liveid为必须字段 */
@property (nonatomic, strong) HJSeedLiveResponse *live;
/** 播主信息，可选 */
@property(nonatomic, strong) HJSeedAnchorResponse *anchor;
/** 切换房间的View */
@property (nonatomic, strong) LivingSwitchView *switchView;
/** 当前正在直播的index，相对列表switchData */
@property (nonatomic, assign) NSInteger curPlayIndex;
/** 用来判断是否第一次播放；如果是，在加载失败时，显示结束页，如果不是，则切换到下一个 */
@property (nonatomic, assign) BOOL isFirstPlay;
/** 记录当前滑动的方向，用于判断切换视频时，如果视频已结束，向前后向后选择下一个视频 */
@property (nonatomic, assign) SWITCH_DIRECTION direction;
/** 为了解决BUG433654 - 【看播】观看已结束的直播跳转到直播结束页会提示直播异常
 记录当前是否需要显示播放器的错误提示，如果在gettFeedInfo或已经显示了结束页面，则不提示
 */
@property (nonatomic, assign) BOOL canShowPlayerMessage;
/** 当播放结束时，重试的定时器 */
@property (nonatomic, strong) NSTimer *retryTimer;
/** 记录当前的重试次数 */
@property (nonatomic, assign) NSInteger retryTimes;
/** 如果播放失败，是否进行重试（当收到1505或1506时，不进行重试） */
@property (nonatomic, assign) BOOL shouldRetryWhenPlayFailed;
/** 3.6.0新增，从后台返回时，是否需要重新加载视频。当进入后台时，如果retryTimer有效，则把它置为YES，当从应用重新回到前台后，启动重试，并把它置为NO */
@property (nonatomic, assign) BOOL shouldRetryWhenBecomeActive;
@property (assign, nonatomic) BOOL guardInfoNotFound;
@property (nonatomic,assign) BOOL loadEnd;  // Default NO  --- > popular
@property (nonatomic,assign) BOOL more; //以前叫hasMore，为了充分暴露问题，改名为more
@property (nonatomic,strong) NSString *strOffset; //以前叫offset，为了充分暴露问题，改名为strOffset
/** 加载广场中推荐等数据时，一页的最小值，为了在播放页面切换时，视频数量不会太少 */
@property (nonatomic, assign) NSInteger defaultFeedCount;
@property (nonatomic, assign) int totalLives;
@property (nonatomic, assign) BOOL refreshing;     // default NO ;
@property (nonatomic,assign) BOOL moreNew; //新主播更多
@property (nonatomic,strong) NSString *strOffsetNew; //新主播偏移
@property (nonatomic, assign) NSInteger defaultNewFeedCount;//10, 每次拉取条数是defaultFeedCount的0.5
@property (nonatomic, assign) int totalNewLives;
//新加入的用户数据
@property (nonatomic,strong) NSMutableArray *newerDataArray;
@property (nonatomic, strong) NSMutableArray<LivingSwitchObject *> *switchData;
@property (nonatomic, assign) int maxSwitchCount; //加载最多为120
@property (nonatomic, assign) BOOL isPlayingSuccess;
// 拉取花椒币重试机制
@property (nonatomic, strong) NSTimer *retryCoinTimer; // 当播放结束时，重试的定时器
@property (nonatomic, assign) NSInteger retryCoinTimes; // 记录当前的重试次数

@property (nonatomic, strong) HJPlayingEndViewController *recommendLiveEndVc;

@end

@implementation HJPlayingViewController_v2 {
#pragma mark - 视频层
    /**
     * 视频层
     *  +默认图
     *  +视频
     */
    UIView *_videoContainer;
    /**
     * 缩略背景图
     */
    __weak IBOutlet UIImageView *_thumbImageView;
    
#pragma mark - 操作层
    /**
     * 操作层
     *  +飘心
     *  +聊天滚动屏
     *  +用户列表条
     *  +聊天输入框
     *  +分享按钮
     *  +发送按钮
     *  +点赞按钮
     *  +播主头像、台标、展开
     *  +加载滚动条
     */
    __weak IBOutlet UIView *_operationContainer;
    /**
     * 飘心(含飘心、点赞按钮)
     */
    JQDealPraiseViewController *_praiseController;
    /**
     * 聊天滚动屏
     */
    HJChatController_v2 *_chatController;
    /**
     * 用户列表条
     */
    HJUserListView *_userListView;
    /**
     * 花椒豆
     */
    HJCoinsTipsView *_coinsTipsView;
    /**
     * 花椒豆贡献榜
     */
//    HJCoinRankView * _coinsRankView;
    /**
     * 官方公幕、私幕
     */
    HJOfficialNoticeView *_officialNoticeView;
    /**
     * 礼物特效页面
     */
    HJGiftEffectView *giftEffectView;
    /**
     *飞屏
     */
    HJFeiPingAnimView *feiPingAnimView;
    /**
     * 分享按钮
     */
    UIButton *_shareButton;
    /**
     * 发送按钮
     */
    //    UIButton *_sendButton;
    
    /**
     * 播主头像、台标、展开
     */
    HJAnchorView *_anchorView;
    BOOL _firstTimeShowAnchorView;
    /**
     * 加载滚动条
     */
    UIView *_loadingView;
#pragma mark - 视频状态
    /**
     * 视频状态(如“加载动画”)
     */
    HJAnimView *_videoState;
#pragma mark - 关闭按钮
    __weak IBOutlet UIButton *giftBtn;
#pragma mark - 隐藏按钮
    UIButton *_hideButton;
#pragma mark - 结束直播层
    /**
     * 结束直播层
     */
    __weak IBOutlet UIView *_endContainer;
    
    /**
     * 返回首页按钮
     */
    __weak IBOutlet UIButton *_backHomeButton;
    /**
     * 结束观看人次
     */
    __weak IBOutlet UILabel *_endWatchCountLabel;
    /**
     * 结束赞数
     */
    __weak IBOutlet UILabel *_endPraiseCountLabel;
    /**
     * 观看人次
     */
    __weak IBOutlet UILabel *_endWatchTitleLabel;
    /**
     * 赞
     */
    __weak IBOutlet UILabel *_endPraiseTitleLabel;
    /**
     * 结束关注按钮
     */
    __weak IBOutlet UIButton *_endFollowButton;
#pragma mark - 个人信息
    NSString *_userId;
#pragma mark - 其他
    Feeds *_liveInfo;
    /** 是否已关注播主(结束页使用) */
    BOOL _followed;
    /** 打点：开始连接的时间 */
    NSTimeInterval _beginPlayTs;
    /** 打点：首次连接时长标识 */
    BOOL _reportConnectFirst;
    /** 开始卡顿的时间 */
    NSTimeInterval _beginConnectingTs;
    
    BOOL _playerPaused;
    BOOL _playerPausedSound;
    
    HJUserInfoCard *_userCard;
    // 视频是否暂停（主播离开时，会收到此消息）
    BOOL _isLivePause;
    int _livePauseTimeStamp;
    NSInteger _onlineCount;
    //观看人数
    NSInteger _watchCount;
    
    BOOL _globalGiftSwitch;
    
    NSString *_flyId;
    NSString *_flyAmount;
    NSString* qhiv_sid;
    
    BOOL _isFirstAppear;
}

#pragma mark - UI
- (void)viewDidLoad
{
    _globalGiftSwitch = [[[HJWalletCloudTextManager sharedManager] getStringForKey:GLOBAL_SWITCH_KEY defaultValue:@"0"] isEqualToString:@"1"];
    // 拉取双币云控状态
    self.currencySwitch = _BOOL([[HJWalletCloudTextManager sharedManager] getStringForKey:double_type_money_switch defaultValue:0]);
    
    [[StatisticsManager shareInstance] clickWithEventId:play_detail_succ];
    
    [super viewDidLoad];
    
    [self initLiveAndAnchorInfo];
    
    [self remoteControl];
    
    [self setupUI];
    
    [self createSwitchView];
    
    _isFirstPlay = YES;
    
    _loadEnd = NO;
    _more = NO;
    _strOffset = nil;
    _defaultFeedCount = 20;
    _totalLives = 0;
    _refreshing = NO;
    
    _moreNew = NO;
    _strOffsetNew = nil;
    _defaultNewFeedCount = 10;
    _totalNewLives = 0;
    
    _maxSwitchCount = 120;
    
    [HJChatRoomMgr sharedInstance].chatDelegate = self;
    _userId = [UserPrefs userID];
    _isFirstAppear = YES;
    
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.homeContainer addGestureRecognizer:tap];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundAction) name:ApplicationDidEnterBackgroundNotification object:nil];
    /******************监视手势滑动方向*****************/
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [_operationContainer addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [_operationContainer addGestureRecognizer:recognizer];
    
    // 聊天
    [self createChatController];
    [_operationContainer insertSubview:_chatController.view  belowSubview:self.buttonsContainer];
    _chatController.view.hidden = YES;
    
    // 初始化弹幕开关的状态
    self.danmuSwitchBtn.selected = [self readDanmuSwitcStatus];
    if (self.danmuSwitchBtn.selected) {
        _inputTextfield.placeholder = @"开启弹幕，1豆/条";
    } else {
        _inputTextfield.placeholder = @"说点什么吧";
    }
    
    cloudKeyIsShowScoreMessage = [[[HJWalletCloudTextManager sharedManager] getStringForKey:ENABLE_RATE_APPSTORE defaultValue:@"0"] intValue];
    isToSayLater = [[[NSUserDefaults standardUserDefaults] objectForKey:whetherToSayLater] boolValue];
    //  开始计时看播
    watchBroadcastTime = [NSDate date];
    
    [_inputTextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayer)             name:@"pause_Video_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWatchBroadcast)     name:@"dismiss_Video_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCenterStatusChanged) name:HJMessageCenterMessageStatusChangedNotification object:nil];
    
    //礼物下载完毕
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewGiftEffectIntoArray:) name:@"kDownloadGiftFinishNotification" object:nil];
    
    // 初始化定时器
    [self startLocalMsgTimer];
    [self startShareRemindTimer];
    
    [self loadNewLive:NO];
    
    [self messageCenterStatusChanged];
}

- (void)messageCenterStatusChanged
{
    NSInteger allMessageCount = [[HJMessageCenterManager sharedManager] numberOfUnreadMessageExceptSecretary];
    
    if (allMessageCount > 0)
        self.chatRedDotView.hidden = NO;
    else
        self.chatRedDotView.hidden = YES;
}
#pragma mark - Timers
- (void)startLocalMsgTimer {
    [self stopLocalMsgTimer];
    self.localMsgTimer = [NSTimer scheduledTimerWithTimeInterval:LOCAL_MSG_SHOW_DURATION target:self selector:@selector(loadLiveAssistantMsg) userInfo:nil repeats:YES];
}
- (void)stopLocalMsgTimer {
    if (self.localMsgTimer.valid) {
        [self.localMsgTimer invalidate];
        self.localMsgTimer = nil;
    }
}
- (void)startShareRemindTimer {
    [self stopShareRemindTimer];
    self.shareRemindTimer = [NSTimer scheduledTimerWithTimeInterval:SHARE_REMIND_SHOW_DURATION target:self selector:@selector(shareRemindShow) userInfo:nil repeats:NO];
}
- (void)stopShareRemindTimer {
    if (self.shareRemindTimer.valid) {
        [self.shareRemindTimer invalidate];
        self.shareRemindTimer = nil;
    }
}
- (void)shareRemindShow {
    [self stopShareRemindTimer];
    if ([self readShareRemindNeverShowStatus]) {
        return;
    }
    if (!self.buttonsContainer.hidden && self.closeFullScreenBtn.hidden) {
        self.shareRemindView.hidden = NO;
        self.shareRemindView.alpha = 1.0;
        self.shareRemindView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.3 animations:^{
            self.shareRemindView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.shareRemindView.alpha = 0;
                } completion:^(BOOL finished) {
                    self.shareRemindView.hidden = YES;
                }];
            });
        }];
        
    } else {
        [self startShareRemindTimer];
    }
}
- (void)pausePlayer
{
    [[HJPlayer player] pause];
    _playerPaused = YES;
}
-(void)initQHIVLog:(NSString*)sn
{
    /* 通知视频云SDK，点击播放或者采集开始前调用
     * @param id 每次播放或直播的唯一标识
     * @param uid 业务端用户体系的用户标识
     * @param bid 业务标识
     * @param pid "IOS"
     * @param ver 业务端版本号
     * @param os 手机OS版本号
     * @param net 网络类型
     * @param mid 设备唯一码
     * @param sn SN标识  采集端sn填NULL */
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMdd-HHmmss.SSS"];
    qhiv_sid=[NSString stringWithFormat:@"%@-%@",[UserPrefs userID],[df stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]]]];
    notify_user_start([qhiv_sid UTF8String],
                      [[UserPrefs userID] UTF8String],
                      "huajiao",
                      "live_huajiao_v2",
                      "IOS",
                      [[AppPrefs appVersion] UTF8String],
                      [[UIDevice currentDevice].systemVersion UTF8String],
                      [NSStringFromType([HJNetworkMgr getType]) UTF8String],
                      [[[AppPrefs deviceId] DS_md5] UTF8String],
                      [sn UTF8String]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [giftEffectView startGiftEffect];
    [feiPingAnimView resumeFeiping];
    [HJCheckInManager setShouldNotShow:YES];

    [[StatisticsManager shareInstance] beginPage:playPage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFollowAnchor:) name:FOLLOWANCHORNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_doClose) name:kNOTIFICLOSEPLAYINGVC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenShot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFollowState:) name:HJUserProfileFollowStatusChangedNotification object:nil];
    
    [self loadGiftView];
    [self.giftVIew loadCoinsWithIsReload:YES];
    
#if USING_WINDOW
    self.view.window.windowLevel = UIWindowLevelStatusBar + 1;
#else
    //    [UIApplication sharedApplication].statusBarHidden = YES;
#endif
    self.navigationController.navigationBarHidden = YES;
    
    if (_playerPaused) {
        [[HJPlayer player] resume];
        _playerPaused = NO;
    }
    // 刷新anchowInfo
    if (!_isFirstAppear) {
        [self refreshAnchorView];
    }
    _isFirstAppear = NO;
}

//个人页关注状态改变的时候修改卡片关注状态
- (void)refreshFollowState:(NSNotification *)notify
{
    if (_userCard && [_userCard respondsToSelector:@selector(showingInView)]) {
        if ([_userCard showingInView]) {
            HJUserProfilesResponse *userProfilesResponse = [notify.userInfo objectForKey:@"HJUserProfileFollowStatusChangedNotificationInfoKey"];
            if (userProfilesResponse.followed) {
                _userCard.followState = HJUserInfoCard_followed;
            }
            else
                _userCard.followState = HJUserInfoCard_follow;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWatchBroadcast) name:@"dismiss_Video_notification" object:nil];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
}

- (void)viewDidLayoutSubviews
{
    [self updateFramesWithKeyboardNotification:nil];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [giftEffectView cleanAllGift];
    [super viewWillDisappear:animated];
    [[StatisticsManager shareInstance] endPage:playPage];
#if !USING_WINDOW
    //    [UIApplication sharedApplication].statusBarHidden = NO;
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FOLLOWANCHORNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTIFICLOSEPLAYINGVC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [HJCheckInManager setShouldNotShow:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    DDLogInfo(@"");
    if([HJChatRoomMgr sharedInstance].chatDelegate == self) {
        [HJChatRoomMgr sharedInstance].chatDelegate = nil;
    }
    _chatController.delegate = nil;
    
    if(_anchorView != nil){
        [_anchorView removeObserver:self forKeyPath:@"frame"];
    }
    
//    [_anchorView stopTimer1];
//    [_anchorView stopTimer2];
    
    
    if(_coinsTipsView != nil){
        [_coinsTipsView removeObserver:self forKeyPath:@"coinsLabelSize"];
    }
    
//    [[HJPlayer player] stop];//此处为了保证viewController被释放时，播放器停止（因为很多网络请求会导致ViewController被引用，无法及时释放，正确方法是在所有的block里，使用弱引用）
}

#pragma mark --- HJCoinsTipsViewDelegate---
- (void)coinTipsViewDidBeTapped{
    DDLogInfo(@"UserAction");
    HJGuardRankViewController *guardRankVc = [[HJGuardRankViewController alloc] init];
    guardRankVc.userId = _anchor.uid;
    [self.navigationController pushViewController:guardRankVc animated:YES];
}

#pragma mark - 初始化界面
- (void)setupUI {    
    [self createVideoContainer];
    
    // 操作层
    [self createPriseController];
    
    // 关闭按钮
    [_closeButton setContentEdgeInsets:UIEdgeInsetsMake(5.5, 5.0, 4.5, 5.0)];
    
    // 用户列表条
    [self createUserListView];
#if DEBUG_PLAY_VIEW
    _userListView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.3];
#else
    _userListView.backgroundColor = [UIColor clearColor];
#endif
    
    // 输入框
    self.inPunishment = NO;
    
    // 隐藏按钮
    _hideButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_hideButton setImage:_IMAGE_(seedPlay_hidden)  forState:UIControlStateNormal];
    _hideButton.layer.cornerRadius = 3;
    [_hideButton addTarget:self action:@selector(onClickHideButton:) forControlEvents:UIControlEventTouchUpInside];
    [_hideButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_share"] forState:UIControlStateNormal];
    [_hideButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_share_press"] forState:UIControlStateHighlighted];
    
    self.contentHidden = NO;
    
    // 分享按钮
    _shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_shareButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.layer.cornerRadius = 3;
    
    [_shareBtn addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 发送弹幕按钮
    _sendButton.layer.cornerRadius = 3.0f;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton addTarget:self action:@selector(onClickSendButton) forControlEvents:UIControlEventTouchUpInside];
    
    // 花椒豆
    [_operationContainer addSubview:_coinsTipsView];
    
    // 官方公幕、私募
    [self creatOfficialNoticeView];
    [_operationContainer addSubview:_officialNoticeView];
    
    [_heartsEmitterContainer addSubview:_praiseController.heartsEmitter];
    _praiseController.heartsEmitter.translatesAutoresizingMaskIntoConstraints = NO;
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeLeft multiplier:1 constant:1]];
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeTop multiplier:1 constant:1]];
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeBottom multiplier:1 constant:1]];
    
    // 观众头像列表
    //    [_operationContainer addSubview:_userListView];
    [_userListContainer addSubview:_userListView];
    _userListView.translatesAutoresizingMaskIntoConstraints = NO;
    [_userListContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userListContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_userListView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_userListContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userListContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_userListView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_userListContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userListContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userListView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_userListContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userListContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userListView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    // 点赞按钮
    [_praiseBtnContainer addSubview:_praiseController.praiseCountBtn];
    _praiseController.praiseCountBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    // loading
    [self createVideoStateView];
    [self.homeContainer addSubview:_videoState];
    
    _isLivePause = NO;
    
    _operationContainer.hidden = NO;
    
    [self createAnchorView];
    [_operationContainer addSubview:_anchorView];
    
    //创建用户卡片
    [self createUserInfoCard];
    
    // 分享引导
    UIImage *image = [UIImage imageNamed:@"watch_share_remind"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image.size.height/2.0, 5, image.size.height/2.0, image.size.width-5);
    image = [image resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeTile];
    self.shareRemindBgImageView.image = image;
    
    NSDictionary *dic = [[HJWalletCloudTextManager sharedManager] getDictionaryForKey:playing_guide_share_text defaultValue:PLAYING_GUIDE_SHARE_TEXT_DEFAULT];
    if (dic[@"playing_share_remind_text"] && ![dic[@"playing_share_remind_text"] isEqualToString:@""]) {
        self.shareRemindLabel.text = _STR(dic[@"playing_share_remind_text"]);
    } else {
        self.shareRemindLabel.text = @"召唤小伙伴，为主播助威~";
    }
    
    // 私信小红点
    self.chatRedDotView.layer.cornerRadius = self.chatRedDotView.bounds.size.height/2;
    self.chatRedDotView.layer.masksToBounds = YES;
}

- (void)createSwitchView
{
    _switchView = [[LivingSwitchView alloc] initWithFrame:self.view.bounds];
    _switchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_switchView setDelegate:self];
    [_switchView setDataSource:self];
    [self.view insertSubview:_switchView atIndex:0];
    //    [self.view addSubview:_switchView];
}

- (void)createVideoContainer
{
    // 视频层
    _videoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _videoContainer.backgroundColor = [UIColor blackColor];
    [self.homeContainer insertSubview:_videoContainer belowSubview:_operationContainer];
    
    [_videoContainer addSubview:[HJPlayer player].glView];
    [HJPlayer player].glView.hidden = YES;
}

- (void)createPriseController
{
    //点赞飘心的view
    _praiseController = [[JQDealPraiseViewController alloc] init];
    _praiseController.liveId = _live.liveid;
    HJHeartsEmitter *heartsView = _praiseController.heartsEmitter;
    heartsView.userInteractionEnabled = NO;
#if DEBUG_PLAY_VIEW
    heartsView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.3];
#else
    heartsView.backgroundColor = [UIColor clearColor];
#endif
}

- (void)createVideoStateView
{
    if (!_videoState) {
        _videoState = [[HJAnimView alloc] initWithMyFrame:CGRectMake(0, (ScreenHeight-100)/2, ScreenWidth, 100)];
    }
}

- (void)createUserListView {
    if (!_userListView) {
        _userListView = [[HJUserListView alloc] initWithFrame:CGRectZero];
        _userListView.context = 0;
        _userListView.delegate = self;
        dispatch_block_t block = ^{
            if ([_userListView respondsToSelector:@selector(onAnchorInfoUpdate:)]) {
                [_userListView onAnchorInfoUpdate:_anchor];
            }
            if ([_chatController respondsToSelector:@selector(onAnchorInfoUpdate:)]) {
                [_chatController onAnchorInfoUpdate:_anchor];
            }
        };
        IMP_WSELF();
        _userListView.userListWillBeginScroll = ^{
            [wself.switchView setScrollEnabled:NO];
        };
        _userListView.userListDidEndScroll = ^{
            [wself.switchView setScrollEnabled:YES];
        };
        dispatch_main_sync_safe(block);
    }
}

- (void)createHuaJiaoCoinView
{
    if (!_coinsTipsView)
    {
        NSString *text = [[HJWalletCloudTextManager sharedManager] getStringForKey:AUDIENCE_COINS_TIPS_KEY defaultValue:AUDIENCE_COINS_TIPS_DEFAULT];
        text = [NSString stringWithFormat:text, _anchor.nickname];
        _coinsTipsView = [HJCoinsTipsView coinsTipsViewWithFrame:CGRectMake(5, HUAJIAO_COIN_VIEW_Y, KScreenWidth * 0.7, 0) Message:text coins:-1 isMe:NO];
        _coinsTipsView.isMessageHidden = YES;
        _coinsTipsView.delegate = self;
        [_coinsTipsView addObserver:self forKeyPath:@"coinsLabelSize"
                            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                            context:nil];
    }
}

- (void)creatOfficialNoticeView
{
    if (!_officialNoticeView) {
        _officialNoticeView = [[HJOfficialNoticeView alloc] initWithFrame:CGRectMake(10, 110, KScreenWidth * 0.65, 50)];
        _officialNoticeView.hidden = YES;
    }
}

- (void)createUserInfoCard
{
    HJUserInfoCard *infoCard = [HJUserInfoCard createUserInfoCard];
    infoCard.delegate = self;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    _userCard = infoCard;
}


- (void)createAnchorView
{
    if (!_anchorView) {
        _anchorView = [[HJAnchorView alloc] initWithFrame:CGRectMake(0, 15, KScreenWidth - 50 , 50)];
        [_anchorView addObserver:self forKeyPath:@"frame"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:nil];
        IMP_WSELF()
        _anchorView.goToMainPageBlock = ^(HJUserProfilesResponse *userProfilesResponse) {
            [wself gotoMainPageWith:userProfilesResponse];
        };
        _anchorView.gpsLocation = self.anchor.location;
        _anchorView.delegate = self;
        _anchorView.parentVC = self;
        _firstTimeShowAnchorView = NO;
    }
}

#pragma mark - load content
- (void)loadUserCoinData
{
    if (self.currencySwitch) {
        __weak typeof(self) wself = self;
        _retryCoinTimes ++;
        [[HJWalletInterface sharedIntfs] getIncomeWithUserID:_anchor.uid success:^(id result) {
            if ([result isKindOfClass:[HJUserWallet class]])
            {
                HJUserWallet *wallet = (HJUserWallet *)result;
                DDLogInfo(@"%@",wallet);
                _coinsTipsView.coins = (NSInteger)wallet.income_p;
            }
            else
                DDLogError(@"why???");
        } failure:^(NSError *error) {
            [wself startRetryLoadUserCoinData];// 重试
            DDLogError(@"%@",error);
        }];
    } else {
        [[HJPocketInterface sharedIntfs] getUserPocketWithUserID:_anchor.uid success:^(id result) {
            if ([result isKindOfClass:[HJUserWallet class]])
            {
                HJUserWallet *wallet = (HJUserWallet *)result;
                DDLogInfo(@"%@",wallet);
                _coinsTipsView.coins = (NSInteger)wallet.income;
            }
            else
                DDLogError(@"why???");
        } failure:^(NSError *error) {
            DDLogError(@"%@",error);
        }];
    }
}
#pragma mark - 3.6.1新增花椒币拉取重试机制
- (void)startRetryLoadUserCoinData {
    if (_retryCoinTimes > RETRY_COIN_MAX_TIMES) {
        [self stopRetryLoadUserCoinData];
        return;
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [_retryCoinTimer invalidate];
        _retryCoinTimer = [NSTimer scheduledTimerWithTimeInterval:RETRY_COIN_INTERVAL target:self selector:@selector(loadUserCoinData) userInfo:nil repeats:NO];
    });
}

- (void)stopRetryLoadUserCoinData {
    [_retryCoinTimer invalidate];
    _retryCoinTimer = nil;
}

#pragma mark <HJPlayerDelegate>
/**
 * 开始播放
 */
- (void)didPlayerStartPlaying:(HJPlayer *)player withLiveId:(NSString *)liveId
{
    if (![liveId isEqualToString:_live.liveid]) {
        return;
    }
    
    if (!_isPlayingSuccess) {
        if(g_debug_bShowLoadSpeed)
        {
            double elapsed=[[NSDate date] timeIntervalSince1970]-g_debug_dPlayTS;
            [HJToastMgr showToast:[NSString stringWithFormat:@"启动耗时:%3.2f秒",elapsed]];
        }
        _isPlayingSuccess = YES;
        [self statisticPreparingTime];
    }
    [HJReappearManager startReappearWithLiveid:_live.liveid page:reappearpagePlaying];
//    DDLogInfo(@"%@: 播放开始",_liveInfo.feed.sn);
    [self resumeLivingByStreamState]; //对谈谈可能丢消息的一个补救：有流过来，如果在暂停状态，就继续看播
    if (_beginConnectingTs > 0) {
        PlayReporter.stop_cnt += 1;
        PlayReporter.stop_time += [[NSDate date] timeIntervalSince1970] - _beginConnectingTs;
        _beginConnectingTs = 0;
    }
    [self showPlayView];
}

-(void)didBufferStarted:(HJPlayer *)player
{
    [self resumeLivingByStreamState]; //对谈谈可能丢消息的一个补救：有流过来，如果在暂停状态，就继续看播
}

/**
 * 连接失败
 */
- (void)player:(HJPlayer *)player didConnectedFailed:(NSError *)error {
    
    DDLogError(@"%@: 连接视频云失败: %@",_liveInfo.feed.sn, error);
    NSString* prompt=@"";
    
    BOOL shouldRetry = NO;
    switch (error.code) {
        case 1: // connection_timeout
            PlayReporter.close_type = 2;
            PlayReporter.close_reason = error.userInfo[@"reason"];
            [PlayReporter report];
            [PlayReporter stop];
            prompt=@"服务连接超时: 2001";
            shouldRetry = YES;
            break;
        
        case 2: // net_posa_jplayer_play_live_failed 如果无网络会到此处
            PlayReporter.close_type = 3;
            PlayReporter.close_reason = error.userInfo[@"reason"];
            [PlayReporter report];
            [PlayReporter stop];
            prompt=@"服务连接失败: 2002";
            shouldRetry = YES;
            break;
        
        case 3: // playerhandler_null
            PlayReporter.close_type = 3;
            PlayReporter.close_reason = error.userInfo[@"reason"];
            [PlayReporter report];
            [PlayReporter stop];
            prompt=@"2003";
            break;

        default:
            prompt=@"2099";
            break;
    }
    if (shouldRetry && _shouldRetryWhenPlayFailed) {
        [self startRetry];
    }
    if (_canShowPlayerMessage) {
        //如果已经显示了结束页，不再显示错误提示语
        [self performSelectorOnMainThread:@selector(doCloseWithPrompt:) withObject:prompt waitUntilDone:NO];
    }
}

/**
 * 连线中
 */
- (void)didPlayerConnecting:(HJPlayer *)player {
    DDLogInfo(@"%@: 连线中",_liveInfo.feed.sn);
    _beginConnectingTs = [[NSDate date] timeIntervalSince1970] - 3;
    if (!_isLivePause) {
        [self startLoading:LoadStatusStop];
        [[StatisticsManager shareInstance] clickWithEventId:@"play_connect_again"];
    }
}

- (void)didPlayerReady:(HJPlayer *)player
{
    DDLogInfo(@"%@: 播放器准备完成",_liveInfo.feed.sn);
    _chatController.view.hidden = NO;
}

#pragma mark ------ 计时3天 -------
- (BOOL)threeDaysCountdown{
    //    return YES;
    NSDate *date1 = [[NSUserDefaults standardUserDefaults] objectForKey:threeDaysTiming];
    NSDate *date2 = [NSDate date];
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];  // 秒
    int days=((int)time)/(3600*24);    // 天
    //  如果超过3天
    if (days>=3 && days<4) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark ------ 看播计时120分钟 -------
- (BOOL)watchBroadcastTimeCountdown{
    float totalTimeInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:watchBroadcastTiming] floatValue];
    float timeInterval = (int)totalTimeInterval/60;   // 分钟
    //  时长120分钟
    if (timeInterval>=120) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -------- 弹出评论对话框 ------
- (void)popUpMarkingDialog{
    //  评分界面
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请给我们力量!" message:@"有花椒陪伴的这段时间，你觉得花椒怎样" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我要给花椒点赞",@"还有待提升",@"再观察一段时间", nil];
    alertView.tag = 2000;
    [alertView show];
}

#pragma mark -
- (void)onClickHideButton:(id)sender {
    if ([_inputTextfield isFirstResponder]) {
        [_inputTextfield resignFirstResponder];
    }
    [self setContentHidden:!self.contentHidden animated:YES];
}

//- (void)updateDurationLabel {
//    NSInteger ts = [[NSDate date] timeIntervalSince1970];
//    ts = ts - self.liveStartTime;
//    if (ts < 0) {
//        ts = 0;
//    }
//    NSInteger MaxValue = 99 * 3600 + 59 * 60 + 59;
//    if (ts > MaxValue) {
//        ts = MaxValue;
//    }
//    self.playingTime = ts;
//}

- (void)showPlayView {
    [self stopLoading];
    //    [self updateDurationLabel];
    if([HJPlayer player].glView.isHidden){
        [HJPlayer player].glView.hidden = NO;
    }
    
    if(!_firstTimeShowAnchorView) {
        _firstTimeShowAnchorView = YES;
        //        if(!_anchor.followed){
        //         }
    }
    if ([_switchData count] && [LiveGuideView shouldShowGuideView]) {
        LiveGuideView *liveGuideView = [[LiveGuideView alloc] init];
        [liveGuideView setGuideContent:_LS(@"playing_guide_1") title2:_LS(@"playing_guide_2") title3:@"下滑清空屏幕"];
        [liveGuideView showTopGuide];
        [self.view addSubview:liveGuideView];
    }
}

- (void)loadGiftView{
    if (!_giftVIew) {
        _giftVIew = [[HJGiftListView alloc] initWithFrame:self.homeContainer.bounds];
        _giftVIew.feedID = _live.liveid;
        __weak typeof(self) weakself = self;
        __weak typeof(_chatController) weakchat = _chatController;
        _giftVIew.topUpAction = ^(){
            HJPurchaseViewController *purchaseVC = [[HJPurchaseViewController alloc] initWithNibName:@"HJPurchaseViewController" bundle:nil];
            [weakself.navigationController pushViewController:purchaseVC animated:YES];
        };
        _giftVIew.pushToLuckyMoney = ^(){
            [weakself pushRedEnvelopeController];
        };
        _giftVIew.giftListViewWillHid = ^(){
            [weakself.switchView setScrollEnabled:YES];
            weakchat.view.hidden = NO;
            weakself.buttonsContainer.hidden = NO;
        };
        _giftVIew.giftListViewWillShow = ^() {
            [weakself.switchView setScrollEnabled:NO];
            weakchat.view.hidden = YES;
            weakself.buttonsContainer.hidden = YES;
        };
    }
}

//anchorview delegate
- (void)View:(HJAnchorView *)view handleAction:(HJAnchorViewActionType)actiontype object:(id)sender
{
    switch (actiontype) {
        case HJAnchorView_Click_show_card:
        {
            DDLogInfo(@"UserAction");
            HJUserCardModel *userCardModel = sender;
            userCardModel.deviceMode = _liveInfo.feed.device;
            userCardModel.livingLocaiton = _liveInfo.feed.location;
            userCardModel.livingID = _live.liveid;
            userCardModel.comeType = HJUserCard_playing;
            _userCard.userCardModel = userCardModel;
            //防止多次点击
            [_userCard showInView:_operationContainer];
            [_switchView setScrollEnabled:NO];
            IMP_WSELF();
            _userCard.dismissBlock = ^(){
                [wself.switchView setScrollEnabled:YES];
            };
        }
            break;
        default:
            break;
    }
}

- (void)remoteControl {
#if SUB_VERSION
    if (_globalGiftSwitch) {
        [self createHuaJiaoCoinView];
        giftBtn.hidden = NO;
    }
    else{
        giftBtn.hidden = YES;
    }
#else
    [self createHuaJiaoCoinView];
#endif
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (!_thumbImageView.hidden || _inputTextfield.isFirstResponder || [_userCard isDescendantOfView:_operationContainer]) {
        return;
    }
    [_giftVIew hidden];
    if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) { //上滑
        DDLogInfo(@"UserAction");
        if (_contentHidden) {
            [self closeFullScreenBtnDidClick:_closeFullScreenBtn];
            _contentHidden = NO;
        }
    } else if (recognizer.direction==UISwipeGestureRecognizerDirectionDown) { //下滑
        DDLogInfo(@"UserAction");
        if (!_contentHidden) {
            [self onClickHideButton:nil];
            _contentHidden = YES;
        }
    }
//    if (_contentHidden) {
//        [self closeFullScreenBtnDidClick:_closeFullScreenBtn];
//        _contentHidden = NO;
//    } else {
//        [self onClickHideButton:nil];
//        _contentHidden = YES;
//    }
}

- (IBAction)commentBtnDidClick:(UIButton *)sender {
    DDLogInfo(@"UserAction");
    [_inputTextfield becomeFirstResponder];
}

- (IBAction)hidenBtnDidClick:(UIButton *)sender {
    DDLogInfo(@"UserAction");
    sender.selected = !sender.selected;
    [self onClickHideButton:sender];
}

- (IBAction)shareBtnDidClick:(UIButton *)sender {
    DDLogInfo(@"UserAction");
}

- (IBAction)giftBtnDidClick:(id)sender {
    DDLogInfo(@"UserAction");
    self.giftVIew.receiverID = _liveInfo.author.uid;
    [_giftVIew showInView:self.view];
}

//主要处理电话进入的逻辑
- (void)onAudioSessionEvent:(NSNotification *)notification{
    if(notification.name == AVAudioSessionInterruptionNotification) {
        NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
        NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
        if ([interruptionType isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]){
            [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
            [[HJPlayer player] stopByPhoneComing];
        } else {
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                if(qhiv_sid)
                    [[HJPlayer player] play:qhiv_sid];
                else
                    DDLogError(@"");
            }
        }
    }
}

#pragma mark - 设置frame
- (void)updateFramesWithKeyboardNotification:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.homeContainer convertRect:endFrameValue.CGRectValue fromView:nil];
    
    CGFloat offset = KScreenHeight - keyboardEndFrame.origin.y;
    if (!notif) {
        offset = 0;
    }
    
    CGRect rect = CGRectMake(5, _inputBar.frame.origin.y, _inputBar.frame.size.width, _inputBar.frame.size.height);
    CGFloat w = KScreenWidth - 60;
    CGFloat h = (CELL_HEIGHT+CELL_SPACING) * 5.6;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y - h - 8;
    if (offset == 0 && self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        _videoState.frame = CGRectMake(0, (KScreenHeight-100)/2, ScreenWidth, 100);
        _chatController.frame = CGRectMake(x, y, w, h);
        _buttonsContainer.hidden = NO;
        _operationContainer.transform = CGAffineTransformIdentity;
        _bottomMask.alpha = 1.0;
    } else {
        if (!self.shareRemindView.hidden) {
            self.shareRemindView.hidden = YES;
        }
        _videoState.frame = CGRectMake(0, (KScreenHeight-100)/2-100, ScreenWidth, 100);
        _chatController.frame = CGRectMake(x, y + 8, w, h);
        _buttonsContainer.hidden = YES;
        _bottomMask.alpha = 0.4;
        if (IosVersion < 8.0) {
            _operationContainer.transform = CGAffineTransformMakeTranslation(0, -offset * 2);
        }
        else
            _operationContainer.transform = CGAffineTransformMakeTranslation(0, -offset);
    }

    _coinsTipsView.frame = CGRectMake(0, HUAJIAO_COIN_VIEW_Y, KScreenWidth * 0.7, 0);
    
    [_operationContainer layoutIfNeeded];
    
    if(!self.inPunishment) {
        if (offset == 0) {
            _inputBar.hidden = YES;
        }else{
            _inputBar.hidden = NO;
        }
    }
}
- (void)onClickReportButton:(id)sender {
    [[StatisticsManager shareInstance] clickWithEventId:@"play_report_click"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:_LS(@"ReportAlert")
                                                   delegate:self
                                          cancelButtonTitle:_LS(@"OK")
                                          otherButtonTitles:_LS(@"Cancel"), nil];
    [alert show];
}

#pragma mark ----- UIAlertView 代理 ------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2000) {
        if (buttonIndex == 0)
        {   // 评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id988396858"]];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:whetherToSayLater];
            
            [[StatisticsManager shareInstance] clickWithEventId:rate_like];
        }
        else if (buttonIndex == 1)
        {   //拒绝
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:whetherToSayLater];
            NSString*msg=@"我们会继续努力~";
            [HJToastMgr showToast:msg];
            DDLogInfo(@"%@",msg);
            
            [[StatisticsManager shareInstance] clickWithEventId:rate_feedback];
        }else if (buttonIndex == 2)
        {   // 以后再说
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:whetherToSayLater];
            NSDate * senddate=[NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:watchBroadcastTiming];
            [[NSUserDefaults standardUserDefaults] setObject:senddate forKey:threeDaysTiming];
            
            [[StatisticsManager shareInstance] clickWithEventId:rate_later];
        }
        isToSayLater = [[[NSUserDefaults standardUserDefaults] objectForKey:whetherToSayLater] boolValue];  // 更新isToSayLater的值
        [self closeWatchBroadcast];  // 关闭看播页
    }else if(alertView.tag == 2008){
        if (buttonIndex == 1){
            HJPurchaseViewController *purchaseVC = [[HJPurchaseViewController alloc] initWithNibName:@"HJPurchaseViewController" bundle:nil];
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }
        
    }
    else if (alertView.tag == 2016) { // 踢出直播间
        if (buttonIndex == 0){
            [self onClickCloseButton:_closeButton];
        }
    }
    else{
        if (alertView.firstOtherButtonIndex == buttonIndex) {
            
        } else if (alertView.cancelButtonIndex == buttonIndex) {
            [[HJSeedIntf sharedIntfs] seed_reportWithRelateid:_live.liveid
                                                      success:^(id result) {
                                                          DDLogInfo(@"OK");
                                                          [[StatisticsManager shareInstance] clickWithEventId:@"play_report_succ"];
                                                          NSString*msg=_LS(@"ReportSuccess");
                                                          [HJToastMgr showToast:msg];
                                                          DDLogInfo(@"%@",msg);
                                                      }
                                                      failure:^(NSError *error) {
                                                          DDLogError(@"%@",error);
                                                          NSNumber *errKey = (NSNumber *)error.userInfo[@"_kCFStreamErrorCodeKey"];
                                                          if([errKey integerValue] == 8)
                                                          {
                                                              NSString*msg=_LS(@"ConnectFail");
                                                              [HJToastMgr showToast:msg];
                                                              DDLogInfo(@"%@",msg);
                                                          }
                                                          else
                                                          {
                                                              NSString*msg=_LS(@"ReportSuccess");
                                                              [HJToastMgr showToast:msg];
                                                              DDLogInfo(@"%@",msg);
                                                          }
                                                      }];
        }
    }
}

- (void)onKeyboardNotification:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    //
    // Get keyboard animation.
    
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = (UIViewAnimationCurve)curveValue.intValue;
    
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [self.homeContainer convertRect:endFrameValue.CGRectValue fromView:nil];
    
    
    CGFloat offset = KScreenHeight - keyboardEndFrame.origin.y;
    if (!notif) {
        offset = 0;
    }
    
//    self.inputBarBottomConstraint.constant = offset;
    
    //
    // Create animation.
    void (^animations)() = ^() {
        [self updateFramesWithKeyboardNotification:notif];
    };
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:animations
                     completion:^(BOOL f){
                         
                     }];
    
    if ([notif.name isEqual:UIKeyboardWillShowNotification]) { // 显示
        _inputBar.hidden = NO;
        
    } else if ([notif.name isEqual:UIKeyboardWillHideNotification]) { // 消失
        _inputBar.hidden = YES;
        
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _videoContainer.center = CGPointMake(CGRectGetMidX(self.homeContainer.bounds), CGRectGetMidY(self.homeContainer.bounds));
}

// 旋转完毕调整控件
- (void)didRotateLayoutSubviews {
    CGRect rect = CGRectMake(5, _inputBar.frame.origin.y, _inputBar.frame.size.width, _inputBar.frame.size.height) ;
    CGFloat w = KScreenWidth / 2;
    CGFloat h = rect.origin.y - 5 - 50;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y - 5 - h;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            if (!_inputTextfield.isFirstResponder) {
                _chatController.frame = CGRectMake(x, y + h/2, w, h/2);
            } else {
                _chatController.frame = CGRectMake(x, y, w, h);
            }
        } else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            _chatController.frame = CGRectMake(x, y, w, h);
        }
    }];
}


-(void)onFollowAnchor:(NSNotification *)notif{
    NSDictionary *attrDic = @{@"uid":_STR(_userId), @"liveid":_STR(self.live.liveid)};
    if([notif.name isEqual:FOLLOWANCHORNOTIFICATION]){
        [[StatisticsManager shareInstance] customTimeEvent:focuse_event customAttributes:attrDic];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:_anchorView]) {
        if ([keyPath isEqualToString:@"frame"]) {
            if ([change objectForKey:@"new"]) {
                self.userListWidthConstraint.constant = KScreenWidth - CGRectGetMaxX(_anchorView.frame) - 55;
            }
        }
    }
}

- (void)setAnchor:(HJSeedAnchorResponse *)anchor {
    _anchor = anchor;
    [_anchorView setLiveId:_live.liveid];
}

- (void)refreshAnchorView {
    IMP_WSELF();
    [[HJUserIntf sharedIntfs] user_getUserInfo:[_anchor uid]
                                       success:^(id result) {
                                           if (result) {
                                               HJUserProfilesResponse * response = result;
                                               if (![response.uid isEqualToString:wself.anchor.uid]) {
                                                   return ;
                                               }
                                               DDLogInfo(@"%@: %@",_liveInfo.feed.sn,response);
                                               _anchorView.userProfiles = response;
                                           }
                                           else
                                               DDLogError(@"%@: why???",_liveInfo.feed.sn);
                                       }
                                       failure:^(NSError *error) {
                                           DDLogError(@"%@: %@",_liveInfo.feed.sn,error);
                                       }];
}

- (void)setContentHidden:(BOOL)commentHidden animated:(BOOL)animated {
    _contentHidden = commentHidden;
    CGFloat alpha = 1.0;
    if(_contentHidden) {// 隐藏
        alpha = 0.0;
        [[StatisticsManager shareInstance] clickWithEventId:play_viewer_hide_comment];
        [_hideButton setImage:_IMAGE_(show_comments) forState:UIControlStateNormal];
        _closeFullScreenBtn.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _chatController.view.alpha = alpha;
            _inputBar.alpha = alpha;
            _userListView.alpha = alpha;
            _praiseController.praiseCountBtn.alpha = alpha;
            _praiseController.heartsEmitter.alpha = alpha;
            _shareBtn.alpha = alpha;
            giftBtn.alpha = alpha;
            _coinsTipsView.alpha = alpha;
            _commentBtn.alpha = alpha;
            _anchorView.alpha = alpha;
            _fullScreenBtn.alpha = alpha;
            _chatBtn.alpha = alpha;
            _topMask.alpha = alpha;
            _bottomMask.alpha = alpha;
            _shareRemindView.alpha = alpha;
            _screenShotBtn.alpha = alpha;
            _chatRedDotView.alpha = alpha;
            _closeFullScreenBtn.alpha = 1.0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            giftEffectView.hidden = YES;
            feiPingAnimView.hidden = YES;
            _chatController.view.hidden = YES;
            _inputBar.hidden = YES;
            _shareBtn.hidden = YES;
            _userListView.hidden = YES;
            giftBtn.hidden = YES;
            _praiseController.praiseCountBtn.hidden = YES;
            _praiseController.heartsEmitter.hidden = YES;
            _coinsTipsView.hidden = YES;
            _commentBtn.hidden = YES;
            _anchorView.hidden = YES;
            _fullScreenBtn.hidden = YES;
            _chatBtn.hidden = YES;
            _topMask.hidden = YES;
            _bottomMask.hidden = YES;
            _screenShotBtn.hidden = YES;
        }];
    }else { // 显示
        _closeButton.hidden = NO;
        [_hideButton setImage:_IMAGE_(hide_comments) forState:UIControlStateNormal];
        giftEffectView.hidden = NO;
        feiPingAnimView.hidden = NO;
        _chatController.view.hidden = NO;
        _inputBar.hidden = YES;
        _shareBtn.hidden = NO;

#if SUB_VERSION
        if (_globalGiftSwitch) {
            giftBtn.hidden = NO;
        }
#else
        giftBtn.hidden = NO;
#endif
        _userListView.hidden = NO;
        _praiseController.praiseCountBtn.hidden = NO;
        _praiseController.heartsEmitter.hidden = NO;
        _coinsTipsView.hidden = NO;
        _commentBtn.hidden = NO;
        _anchorView.hidden = NO;
        _fullScreenBtn.hidden = NO;
        _chatBtn.hidden = NO;
        _topMask.hidden = NO;
        _bottomMask.hidden = NO;
        _screenShotBtn.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _chatController.view.alpha = alpha;
            _inputBar.alpha = alpha;
            _shareBtn.alpha = alpha;
            giftBtn.alpha = alpha;
            _userListView.alpha = alpha;
            _praiseController.praiseCountBtn.alpha = alpha;
            _praiseController.heartsEmitter.alpha = alpha;
            _coinsTipsView.alpha = alpha;
            _commentBtn.alpha = alpha;
            _anchorView.alpha = alpha;
            _fullScreenBtn.alpha = alpha;
            _chatBtn.alpha = alpha;
            _topMask.alpha = alpha;
            _bottomMask.alpha = alpha;
            _shareRemindView.alpha = alpha;
            _screenShotBtn.alpha = alpha;
            _chatRedDotView.alpha = alpha;
            _closeFullScreenBtn.alpha = 0.0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _closeFullScreenBtn.hidden = YES;
        }];
    }
}

- (void)setContentHidden:(BOOL)commentHidden {
    _contentHidden = commentHidden;
    [self setContentHidden:commentHidden animated:NO];
}

- (void)setInPunishment:(BOOL)inPunishment {
    _inPunishment = inPunishment;
    _inputTextfield.userInteractionEnabled = !_inPunishment;
    
    _inputTextfield.returnKeyType = UIReturnKeySend;
    _inputTextfield.delegate = self;
    _inputTextfield.font = [UIFont systemFontOfSize:14];
    _inputTextfield.layer.cornerRadius = 3;
    if(_inPunishment) {
        //        UIColor *color = [UIColor colorWithWhite:0.0 alpha:0.6];
        UIColor *color = [UIColor lightGrayColor];
        _inputTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"您已被主播禁言" attributes:@{NSForegroundColorAttributeName:color}];
        //        _inputTextfield.background = [UIImage imageNamed:@"punishment_input_background"];
        //        _inputTextfield.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        UIImageView *iv = [[UIImageView alloc] initWithImage:_IMAGE_(punishment_lock)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.frame = CGRectMake(0, 0, 32, 15);
        _inputTextfield.leftView = iv;
        _inputTextfield.leftViewMode = UITextFieldViewModeAlways;
    }else {
        //        UIColor *color = [UIColor colorWithWhite:1.0 alpha:0.6];
        UIColor *color = [UIColor lightGrayColor];
        _inputTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"说点什么吧" attributes:@{NSForegroundColorAttributeName:color}];
        
    }
}

- (void)onTap:(UITapGestureRecognizer*)recognizer {

    [self.view endEditing:YES];
    ZILog(ZZLogChatModule, @"点赞");
    
    // Focus actions
//    CGPoint location = [recognizer locationInView:self.view];
    
    if([_anchorView beShownNow]) {
    }else {
        if (_inputTextfield.isFirstResponder) {
            [_inputTextfield resignFirstResponder];
        } else {
#if (!DEBUG_PLAYER_CPU_BUG)
            if (_coinsTipsView.isMessageHidden == NO) {
                _coinsTipsView.isMessageHidden = YES;
                return;
            }
            // 点赞
            [_praiseController birthOne];
#endif
        }
    }
}

- (void)pushRedEnvelopeController
{
    HJSendRedEnvelopeViewController *redEnvelopeVC = [[HJSendRedEnvelopeViewController alloc] init];
    self.redEnvelopeVC = redEnvelopeVC;
    _redEnvelopeVC.anchorAvatorImageURL = self.anchor.avatar;
    _redEnvelopeVC.anchorID = self.anchor.uid;
    _redEnvelopeVC.anchorName = self.anchor.nickname;
    _redEnvelopeVC.liveID = _liveInfo.feed.relateid;
    _redEnvelopeVC.userBalance = _giftVIew.balance;
    _redEnvelopeVC.onlineCount = _onlineCount;
    
    [self.navigationController pushViewController:_redEnvelopeVC animated:YES];
}

- (void)stopLoading {
    if (_anchorView.hidden != NO || _coinsTipsView.hidden != NO || _videoState.hidden != YES) {
        //暂停和主播中断用的一个view，直播中断的时候就不用hidden了
        if (!_isLivePause) {
            [_videoState stopAnim];
            [UIView animateWithDuration:0.15 animations:^{
                _videoState.alpha = 0;
                _thumbImageView.alpha = 0;
            } completion:^(BOOL finished) {
                _videoState.hidden = YES;
                _thumbImageView.hidden = YES;
            }];
        }
    }
}

- (void)startLoading:(NSInteger) status {
    if (status == LoadStatusConnecting) {
        _videoState.alpha = 1.0;
        _thumbImageView.alpha = 1.0;
        _videoState.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.hidden = NO;
        [self.homeContainer insertSubview:_thumbImageView belowSubview:_closeButton];
    } else if (status == LoadStatusStop) {
        _videoState.alpha = 1.0;
        _thumbImageView.alpha = 1.0;
        _videoState.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        // 高斯模糊
        UIImage *image = [[HJPlayer player] snapshotImage];
        CGRect frame =  (CGRect){0,0,image.size.width,image.size.height};
        image = [image applyLightEffectAtFrame:frame withBlurRadius:BLUR_RADIUS];
        if (image.size.width < image.size.height) {
            _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        } else {
            _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        _thumbImageView.image = image;
        _thumbImageView.hidden = NO;
        [self.homeContainer insertSubview:_thumbImageView aboveSubview:_videoContainer];
    }
    _videoState.hidden = NO;
    NSString* msg=_LS(@"playing_loading_tip") ;
    [_videoState startAnimWithType:HJAnimTypePlayConnect loadText:msg];
    DDLogInfo(@"%@: %@",_liveInfo.feed.sn,msg);
    if ([_inputTextfield isFirstResponder]) {//在显示主播离开或加载中时，关闭键盘
        [_inputTextfield resignFirstResponder];
    }
}

- (void)_doLoadingAnimation {
    
}

- (void)showRedEnvelopeView:(HJRedPacketData *)data
{
    __block UIView *bgView = [[UIView alloc]initWithFrame:KScreenRect];
    __block UIView *cbgView = [[UIView alloc]initWithFrame:KScreenRect];
    
    __weak typeof(self) weakSelf = self;
    _redEnvelopeView = [[HJRedEnvelopeView alloc] initWithRedPacketData:data isAnchor:NO];
    _redEnvelopeView.closeBlock = ^(){
        [bgView removeFromSuperview];
        [cbgView removeFromSuperview];
        bgView = nil;
        cbgView = nil;
        [weakSelf.redEnvelopeView dismiss];
        weakSelf.redEnvelopeView = nil;
    };
    
    cbgView.backgroundColor = [UIColor clearColor];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [cbgView addSubview:bgView];
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:cbgView];
    [keywindow addSubview:_redEnvelopeView];
    [keywindow bringSubviewToFront:_redEnvelopeView];
}

- (void)createChatController
{
    if (!_chatController) {
        _chatController = [[HJChatController_v2 alloc] init];
        _chatController.delegate = self;
        _chatController.sourceType = HJChatControllerSourceTypePlay;
        _chatController.roomID = self.live.liveid;
        _chatController.anchorID = _anchor.uid;
        __weak typeof(self) weakSelf = self;
        _chatController.tappedOnTheViewBlock = ^{
            if (weakSelf.inputTextfield.isFirstResponder) {
                [weakSelf.inputTextfield resignFirstResponder];
            }
        };
        _chatController.redPacketTapActionBlock = ^(HJRedPacketData *data){
            if (weakSelf.inputTextfield.isFirstResponder) {
                [weakSelf.inputTextfield resignFirstResponder];
            }
            [weakSelf showRedEnvelopeView:data];
        };
        [_chatController loadHistoryMessages];
    }
}

#pragma mark -

-(void)onPlayFailed:(NSString*)prompt
{
    _liveInfo = nil;
    // 异常
    PlayReporter.close_type = 3;
    PlayReporter.close_reason = @"request_live_play_result_error";
    [PlayReporter report];
    [PlayReporter stop];
    [self performSelectorOnMainThread:@selector(doCloseWithPrompt:) withObject:prompt waitUntilDone:NO];
}

//获取飞屏礼物
- (void)getFlyScreenList
{
    NSString *token = [UserPrefs token];
    NSDictionary *dic = @{@"token":_STR(token),
                          @"platform":@"2",
                          @"start":@(0),
                          @"length":@(1000),
                          @"version":@(1)};
    [[HJServices new] paymentPostWithurl:@"/flyscreen/getFlyscreenList"
                                    host:@"payment.huajiao.com"
                              parameters:dic
                                  AESKey:@"DPF5HCBTSJXZVKQX" completion:^(id result) {
                                      if ([result isKindOfClass:[NSDictionary class]]) {
                                          NSArray *dataList = result[@"flyscreen_list"];
                                          if (dataList != nil && dataList.count > 0) {
                                              NSDictionary *data = [dataList objectAtIndex:0];
                                              _flyId = _STR(data[@"flyid"]);
                                              _flyAmount = _STR(data[@"amount"]);
                                              
                                              if (self.danmuSwitchBtn.selected) {
                                                  if (StringIsNullOrEmpty(_flyAmount)) {
                                                      _flyAmount = @"1";
                                                  }
                                                  _inputTextfield.placeholder = Format_Str(@"开启弹幕，%@豆/条",_flyAmount) ;
                                              } else {
                                                  _inputTextfield.placeholder = @"说点什么吧";
                                              }
                                          }
                                      }
                                  }
                                 failure:^(NSError *error) {
                                     
                                 }];
}

BOOL g_debug_bPlayOnly=NO;
BOOL g_debug_bShowLoadSpeed=NO;
double g_debug_dPlayTS=0;

- (void)play {
    
    if(g_debug_bPlayOnly==NO)
        [self getFlyScreenList];
    
    if(g_debug_bShowLoadSpeed)
        g_debug_dPlayTS=[[NSDate date] timeIntervalSince1970];
    
    _shouldRetryWhenPlayFailed = YES;
    _isPlayingSuccess = NO;
    _retryTimes ++;
    
    _beginPlayTs = [[NSDate date] timeIntervalSince1970];
    [HJPlayer player].glView.hidden = YES;

    if(g_debug_bPlayOnly==NO)
        [self startLoading:LoadStatusConnecting];
    DDLogInfo(@"play:%@",_live.liveid);

    BOOL playerStarted=NO;
    if(_live.sn && _live.sn.length>0)
    {
        [self initQHIVLog:_live.sn];
        [HJPlayer player].delegate = self;
        HJSeedLiveServerResponse* si=[[HJSeedLiveServerResponse alloc] init];
        si.sn = _live.sn;
        si.liveid = _live.liveid;
        si.relayId = _live.liveid;
        [HJPlayer player].liveServerInfo =si;
        DDLogInfo(@"%@: 启动播放器",_live.sn);
        [[HJPlayer player] play:qhiv_sid];
        if(g_debug_bPlayOnly==NO)
        {
            DDLogInfo(@"%@: 加入房间",_live.sn);
            [self joinRoom];
            DDLogInfo(@"%@: 播放开始 <liveid:%@>",_live.sn,_live.liveid);
        }
        playerStarted=YES;
    }
    else
        DDLogWarn(@"");
    
    if(g_debug_bPlayOnly==YES) //仅用于测试开播速度
        return;

    IMP_WSELF();
    [[HJSeedIntf sharedIntfs] seed_getLiveServerWithID:_live.liveid    //这个调用的作用已经改变了，现在仅用于服务端统计观众数量，可以不用关心其返回值
                                               success:^(id result) {
                                               }
                                               failure:^(NSError *error) {
                                               }];
    _canShowPlayerMessage = NO;
    [[HJSeedIntf sharedIntfs] seed_getResourceInfo:wself.live.liveid
                                           success:^(id result) {
                                               if (![result isKindOfClass:[Feeds class]]) {
                                                   return ;
                                               }
                                               Feeds *feeds = result;
                                               wself.canShowPlayerMessage = YES;
                                               if (!wself || feeds==nil || feeds.feed==nil || ![feeds.feed.relateid isEqualToString:wself.live.liveid]) {
                                                   return ;
                                               }
                                               _liveInfo = feeds;
                                               if(feeds.type==FeedTypeLive) {
                                                   DDLogInfo(@"%@: 直播信息获取成功: %@",_liveInfo.feed.sn, feeds);
                                                   [_anchor modifyFromAuthor:feeds.author];
                                                   _anchorView.userProfiles = [HJUserProfilesResponse userProfilesWithAnchor:feeds.author];
                                                   [_anchorView setTitle:_anchor.nickname];
                                                   if (feeds.author.verified && feeds.author.verifiedInfo.realname.length) {
                                                       [_anchorView setTitle:feeds.author.verifiedInfo.realname];
                                                   }
                                                   _praiseController.totalCount = feeds.feed.praises.integerValue;
                                                   _userListView.playedCount = _INTEGER(feeds.feed.watches);
                                                   // Update the UI at the first time
                                                   [self updateOnlineCount:0 watchCount:_userListView.playedCount];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(),^{
                                                       if ([_userListView respondsToSelector:@selector(onAnchorInfoUpdate:)]) {
                                                           [_userListView onAnchorInfoUpdate:_anchor];
                                                       }
                                                       if ([_chatController respondsToSelector:@selector(onAnchorInfoUpdate:)]) {
                                                           [_chatController onAnchorInfoUpdate:_anchor];
                                                       }
                                                       if ([_anchorView respondsToSelector:@selector(onAnchorInfoUpdate:)]) {
                                                           [_anchorView onAnchorInfoUpdate:_anchor];
                                                       }
                                                   });
                                                   
                                                   if(playerStarted==NO)
                                                   {
#ifdef DEBUG
                                                       UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注意" message:@"如果代码跑到这里说明服务器没有给sn，会影响看播打开速度" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                       [alert show];
#endif
                                                       [self initQHIVLog:_liveInfo.feed.sn];

                                                       [HJPlayer player].delegate = self;
                                                       HJSeedLiveServerResponse* si=[[HJSeedLiveServerResponse alloc] init];
                                                       si.sn = _liveInfo.feed.sn;
                                                       si.liveid = _live.liveid;
                                                       si.relayId = _live.liveid;
                                                       [HJPlayer player].liveServerInfo = si;
                                                       DDLogInfo(@"%@: 启动播放器",_liveInfo.feed.sn);
                                                       [[HJPlayer player] play:qhiv_sid];
                                                       DDLogInfo(@"%@: 加入房间",_liveInfo.feed.sn);
                                                       [self joinRoom];
                                                       DDLogInfo(@"%@: 播放开始 <liveid:%@>",_liveInfo.feed.sn,_live.liveid);
                                                   }
                                               }
                                               else if(feeds.type==FeedTypeReplay)
                                               {
                                                   if ([wself.switchData count] == 1 || wself.isFirstPlay)
                                                   {
                                                       wself.shouldRetryWhenPlayFailed = NO;
                                                       [wself stopRetry];
                                                       [wself stopRetryLoadUserCoinData];
                                                       
                                                       [wself dealWithPlayEnd:_liveInfo hasReplayData:YES];
                                                       return ;
                                                   }
                                                   else
                                                   {
                                                       [wself switchToNextLive];//如果大于1，切换到下一个直播
                                                   }
                                                   DDLogInfo(@"%@: 直播已经结束",_liveInfo.feed.sn);
                                               }
                                               else
                                               {
                                                   [wself onPlayFailed:@"1001"];
                                                   DDLogError(@"%@:",_liveInfo.feed.sn);
                                               }
                                               wself.isFirstPlay = NO;
                                           }
                                           failure:^(NSError *error){
                                               if (error.code == 1505 || error.code == 1506) { // 直播已结束或直播已删除
                                                   DDLogError(@"%@:直播已结束或删除",_liveInfo.feed.sn);
                                                   if ([wself.switchData count] == 1 || wself.isFirstPlay) {
                                                       //直播已删除
                                                       if(error.code == 1506){
                                                           [wself dealWithPlayEnd:_liveInfo hasReplayData:NO];
                                                       }else{
                                                           [wself dealWithPlayEnd:_liveInfo hasReplayData:YES];
                                                       }                                                   } else {
                                                       [wself switchToNextLive];//如果大于1，切换到下一个直播
                                                   }
                                                   wself.shouldRetryWhenPlayFailed = NO;
                                                   [wself stopRetry];
                                                   [wself stopRetryLoadUserCoinData];
                                               }
                                               else if(error.code<0)
                                               {
                                                   DDLogError(@"%@:%@",_liveInfo.feed.sn,error);
                                                   [wself onPlayFailed:[NSString stringWithFormat:@"%@(%d)",error.localizedDescription, (int)error.code]];
                                                   [wself startRetry];
                                               }
                                               else
                                               {
                                                   // 异常
                                                   DDLogError(@"%@:%@",_liveInfo.feed.sn,error);
                                                   [wself onPlayFailed:@"1002"];
                                                   wself.shouldRetryWhenPlayFailed = NO;
                                                   [wself stopRetry];
                                                   [wself stopRetryLoadUserCoinData];
                                               }
                                               DDLogError(@"%@: %@",_liveInfo.feed.sn,error);
                                           }];
}

-(void)doCloseWithPrompt:(NSString*)prompt {
    NSString*msg=[NSString stringWithFormat:@"直播异常: %@", prompt];
    [HJToastMgr showLiveToast:msg];
    DDLogInfo(@"%@: %@",_liveInfo.feed.sn,msg);
    //    [self _doClose];
}

- (void)_doClose {
    DDLogInfo(@"播放关闭");
//    if(_anchorView != nil){
//        [_anchorView removeObserver:self forKeyPath:@"frame"];
//    }
//    
//    if(_coinsTipsView != nil){
//        [_coinsTipsView removeObserver:self forKeyPath:@"coinsLabelSize"];
//    }
    if (_recommendLiveEndVc != nil) {
        [self.recommendLiveEndVc.view removeFromSuperview];
        [self.recommendLiveEndVc removeFromParentViewController];
        _recommendLiveEndVc = nil;
    }
    
    if (giftEffectView != nil) {
        [giftEffectView closeView];
        giftEffectView = nil;
    }
    
    if (feiPingAnimView != nil) {
        [feiPingAnimView closeView];
        feiPingAnimView = nil;
    }
    
    if (_videoState != nil) {
        [_videoState stopAnim];
        _videoState = nil;
    }
    
    [HJUserProfileView dismiss];
    dispatch_async(dispatch_get_main_queue(),^{
        if (_onClickCloseButtonBlock) {
            _onClickCloseButtonBlock(_anchor, _pageType);
        }
    });
}

- (void)stop
{
    [HJReappearManager stopReappear];
    DDLogInfo(@"");
    if(qhiv_sid)
        notify_user_stop([qhiv_sid UTF8String]);
    [[HJChatRoomMgr sharedInstance] quitRoom];
    [_chatController resetMessages:nil];
    
//    [_praiseController cleanData];
    [_praiseController.heartsEmitter removeFromSuperview];
    [_praiseController.praiseCountBtn removeFromSuperview];
    [_praiseController cleanData];
    _praiseController.heartsEmitter = nil;
    _praiseController.praiseCountBtn = nil;
    
    [_userListView clear];
    
    [_anchorView resetAnchorView];
    [_anchorView setTitle:nil];
    [_anchorView setLiveTime:nil];
    
    [giftEffectView removeFromSuperview];
    giftEffectView = nil;
    
    [feiPingAnimView removeFromSuperview];
    feiPingAnimView = nil;
    
    [_inputTextfield resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[HJPlayer player].glView removeFromSuperview];
    [HJPlayer player].glView.hidden = YES;
    [[HJPlayer player] stop];
    [HJPlayer player].delegate = nil;
    
    
    [_giftVIew hidden];
    _coinsTipsView.isMessageHidden = YES;
}

- (void)preRelease {
    DDLogInfo(@"");
    [super preRelease];
    [self stop];
}

-(void)statisticWatchingTime
{
    if (_beginPlayTs<=0) {
        return;
    }
    
    int watchTime = [[NSDate date] timeIntervalSince1970] - _beginPlayTs;
    if (watchTime < 0) {
        watchTime = 0;
    }
    NSDictionary *attrDic = @{watch_time_event_startTime:@(_beginPlayTs),
                              watch_time_event_watchaTime:@(watchTime),
                              watch_time_event_liveid:_STR(self.live.liveid),
                              watch_time_event_uid:_STR(_userId)};
    [[StatisticsManager shareInstance] customTimeEvent:living_watch_time_event customAttributes:attrDic];
}

-(void)statisticPreparingTime
{
    if (_beginPlayTs<=0) {
        return;
    }
    
    int prepareTime = [[NSDate date] timeIntervalSince1970] - _beginPlayTs;
    if (prepareTime < 0) {
        prepareTime = 0;
    }
    HJNetworkType networkType = [HJNetworkMgr getType];
    NSString *networkTypeStr;
    switch (networkType) {
        case kNetworkType2G:
            networkTypeStr = @"2G";
            break;
            
        case kNetworkType3G:
            networkTypeStr = @"3G";
            break;
            
        case kNetworkType4G:
            networkTypeStr = @"4G";
            break;
            
        case kNetworkTypeWifi:
            networkTypeStr = @"wifi";
            break;
            
        case kNetworkTypeWWAN:
            networkTypeStr = @"WWAN";
            break;
            
        case kNetworkTypeUnknown:
        default:
            networkTypeStr = @"unknownNetwork";
            break;
    }
    NSDictionary *attrDic = @{play_start_time_event_timecost:@(prepareTime),
                              play_start_time_event_liveid:_STR(self.live.liveid),
                              play_start_time_event_network:_STR(networkTypeStr)};
    
    [[StatisticsManager shareInstance] customTimeEvent:live_play_start_time_event customAttributes:attrDic];
    [self statisticPlayingSuccessEvent];
}

-(void)statisticPlayingSuccessEvent
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"HH"];
    NSString *hourStr = [dataFormatter stringFromDate:date];
    
    NSString *positionStr = _statisData[@"position"];
    NSInteger positionIdx;
    if (!positionStr) {
        positionIdx = -1;
    }else if([_statisData[@"from"] hasPrefix:@"TAB"] || _curPlayIndex ==0){
        positionIdx = [positionStr integerValue]+_curPlayIndex;
    }else{
        //focus
        positionIdx = _curPlayIndex-1;
    }
    
    NSDictionary *attrDic = @{play_success_event_from:_STR(_statisData[@"from"]),
                              play_success_event_playId:_STR(_live.liveid),
                              play_success_event_anchorId:_STR(_anchor.uid),
                              play_success_event_watcherId:_STR(_userId),
                              play_success_event_position:_STR([NSNumber numberWithInteger:positionIdx]),
                              play_success_event_hour:_STR(hourStr),
                              play_success_event_cover:_STR([_switchData objectAtIndex:_curPlayIndex].imageUrl)};
    
    [[StatisticsManager shareInstance] customTimeEvent:live_play_success_event customAttributes:attrDic];
}

#pragma mark - 3.5.1新增重试机制
- (void)replay
{
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground) {
        _shouldRetryWhenBecomeActive = YES;//如果在后台，则不进行重试。等应用从后台返回时，再开始重试
        return;
    }
    [self play];
    [self loadUserCoinData];
}

- (void)startRetry
{
    if (_retryTimes > RETRY_MAX_TIMES) {
        [self onClickCloseButton:nil];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [_retryTimer invalidate];
        _retryTimer = [NSTimer scheduledTimerWithTimeInterval:RETRY_INTERVAL target:self selector:@selector(replay) userInfo:nil repeats:NO];
    });
}

- (void)stopRetry
{
    [_retryTimer invalidate];
    _retryTimer = nil;
}


#pragma mark - fullScreenBtn
- (IBAction)fullScreenBtnDidClick:(UIButton *)sender {
    [self onClickHideButton:sender];
}

#pragma mark - closeFullScreenBtn
- (IBAction)closeFullScreenBtnDidClick:(UIButton *)sender {
    [self onClickHideButton:sender];
    [[StatisticsManager shareInstance] clickWithEventId:play_watch_close_fullScreen];
}
#pragma mark - button
- (IBAction)screenShotBtnDidClick:(id)sender {
    DDLogInfo(@"UserAction");
    [self screenShot];
}
- (IBAction)chatBtnDidClick:(id)sender {
    DDLogInfo(@"UserAction");
    [HJMessageCenterManager sharedManager].backViewController = self;
    [HJMessageCenterManager sharedManager].keyboardSelector = @selector(onKeyboardNotification:);
    [[HJMessageCenterManager sharedManager] showHalfWindowOfMessageCenterRootController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (IBAction)onClickCloseButton:(id)sender {
    DDLogInfo(@"UserAction");
    [self stopRetry];
    [self stopRetryLoadUserCoinData];
    [self stopLocalMsgTimer];
    [self stopShareRemindTimer];
    [_chatController stopCheckDanmuRate];
    if (isToSayLater && cloudKeyIsShowScoreMessage)
    {
        NSTimeInterval timeInterval=[[NSDate date] timeIntervalSinceDate:watchBroadcastTime];
        float previousTotal = [[[NSUserDefaults standardUserDefaults] objectForKey:watchBroadcastTiming] floatValue];
        [[NSUserDefaults standardUserDefaults] setObject:@(previousTotal+timeInterval) forKey:watchBroadcastTiming];
        if ([self watchBroadcastTimeCountdown]&&[self threeDaysCountdown]) {
            [self popUpMarkingDialog];
        }
        else{
            [self closeWatchBroadcast];
        }
    }else
    {
        [self closeWatchBroadcast];
    }
}

- (IBAction)redPacketBtnDidClick:(id)sender {
    [self pushRedEnvelopeController];
}
- (IBAction)neverRemindBtnDidClick:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.shareRemindView.alpha = 0;
    } completion:^(BOOL finished) {
        self.shareRemindView.hidden = YES;
        [self saveShareRemindNeverShowStatus:YES];
    }];
}
// 保存分享引导气泡是否"不再提醒"
- (void)saveShareRemindNeverShowStatus:(BOOL)status {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *keyStr = [NSString stringWithFormat:@"%@ShareRemindNeverShowStatus", [UserPrefs userID]];
    [defaults setBool:status forKey:keyStr];
    [defaults synchronize];
}
// 读取分享引导气泡"不再提醒"状态
- (BOOL)readShareRemindNeverShowStatus {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *keyStr = [NSString stringWithFormat:@"%@ShareRemindNeverShowStatus", [UserPrefs userID]];
    BOOL status = [defaults boolForKey:keyStr];
    return status;
}
- (void)closeWatchBroadcast{
    [self.view endEditing:YES];
    //如果是横屏，则强制为竖屏模式
    if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    
    [self statisticWatchingTime];
    [[StatisticsManager shareInstance] clickWithEventId:@"play_exit"];
    
    PlayReporter.close_type = 1;
    PlayReporter.close_reason = @"on_click_close";
    [PlayReporter report];
    [PlayReporter stop];
    [self _doClose];
}

- (IBAction)mirrorBtnDidClick:(UIButton *)sender {
    [[HJPlayer player] mirrorView:!self.mirrorIsShow];
    self.mirrorIsShow = !self.mirrorIsShow;
    if (self.mirrorIsShow) {
        NSString*msg=@"镜像画面";
        DDLogInfo(@"%@",msg);
        [HJToastMgr showToast:msg];
        [[StatisticsManager shareInstance] clickWithEventId:play_watch_open_mirror];
    } else {
        NSString*msg=@"正常画面";
        DDLogInfo(@"%@",msg);
        [HJToastMgr showToast:msg];
        [[StatisticsManager shareInstance] clickWithEventId:play_watch_close_mirror];
    }
}

- (IBAction)danmuSwitcBtnDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self saveDanmuSwitcStatus:sender.selected];
    if (sender.selected) {
        if (StringIsNullOrEmpty(_flyAmount)) {
            _flyAmount = @"1";
        }
        _inputTextfield.placeholder = Format_Str(@"开启弹幕，%@豆/条",_flyAmount) ;
    } else {
        _inputTextfield.placeholder = @"说点什么吧";
    }
}
// 保存弹幕开关状态
- (void)saveDanmuSwitcStatus:(BOOL)status {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *keyStr = [NSString stringWithFormat:@"%@danmuSwitcStatus", [UserPrefs userID]];
    [defaults setBool:status forKey:keyStr];
    [defaults synchronize];
}
// 读取弹幕开关状态
- (BOOL)readDanmuSwitcStatus {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *keyStr = [NSString stringWithFormat:@"%@danmuSwitcStatus", [UserPrefs userID]];
    BOOL status = [defaults boolForKey:keyStr];
    return status;
}
#pragma mark - 分享
- (void)onClickShareButton:(id)sender {
    DDLogInfo(@"UserAction");
    if (!self.shareRemindView.hidden) {
        self.shareRemindView.hidden = YES;
    }
    HJShareData *data = [HJShareData new];
    data.relatedID = _liveInfo.feed.relateid;
    data.authorID = _liveInfo.author.uid;
    data.type = _liveInfo.type;
    data.pageName = HJSharePageNameLiving;
    data.imageUrlString = _liveInfo.feed.image;
    data.nickName = _liveInfo.author.nickname;
    data.feedTitle = _liveInfo.feed.title;
    data.messageType = HJShareMessageTypeLink;
    [HJShareView showWithShareData:data];
}

- (void)onClickSendButton {
    DDLogInfo(@"UserAction");
    NSString* content=[[_inputTextfield text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![content isEqualToString:@""]) {
        //飞屏按钮是否打开
        if ([self readDanmuSwitcStatus]) {

            if (_giftVIew.balance>0) {
                //如果没有获取到flyid就重新获取
                if (StringNotNullAndEmpty(_flyId)) {
                    [[StatisticsManager shareInstance] customTimeEvent:play_comment_sent_click customAttributes:@{@"liveid":_STR(self.live.liveid)}];
                    

                    [[HJSeedIntf sharedIntfs] seed_chatMessage:content inLive:_live.liveid giftId:_flyId success:^(id result){
                        DDLogInfo(@"OK");
                        _giftVIew.balance -= _INT(_flyAmount);
                        
                        _inputTextfield.text = @"";
                        
                        HJChatMessage *message = [HJChatMessage new];
                        message.time = [[NSDate date] timeIntervalSince1970];
                        message.type = HJChatMsgTypeChatMessage;
                        HJChatUser *cUser = [HJChatUser new];
                        HJUserProfile *uProfile = [UserPrefs userProfile];
                        cUser.uid = uProfile.userID;
                        cUser.nickname = uProfile.nickname;
                        cUser.level = uProfile.level;
                        cUser.exp = uProfile.exp;
                        cUser.avatar = uProfile.avatar;
                        cUser.isVerified = uProfile.isVerified;
                        cUser.verifiedInfo = uProfile.verifiedInfo;
                        message.user = cUser;
                        message.content = content;
                        message.roomid = _live.liveid;
                        
                        [self initFeiPingAnimView];
                        [feiPingAnimView startFeiPing:message];
                        
                        if ([_chatController respondsToSelector:@selector(room:didRecieveMessage:)]) {
                            [_chatController room:_live.liveid didRecieveMessage:message];
                        }
                        
                        NSDictionary *attrDic = @{@"uid":_STR(_liveInfo.author.uid), @"liveID":_STR(self.live.liveid),@"viewerID":_STR(_userId)};
                        [[StatisticsManager shareInstance] customTimeEvent:record_feiping_send customAttributes:attrDic];
                    }failure:^(NSError *error) {
                        if (error.code == 1615) {
                            [HJToastMgr showToast:@"您已被主播拉黑"];
                        } else if (error.code == 1616) { // 命中反垃圾
                            _inputTextfield.text = @"";
                        } else if (error.code == 1612) { // 被禁言
                            [HJToastMgr showToast:@"您已被禁言"];
                        }
                        DDLogError(@"%@",error);
                    }];
                }else{
                    [HJToastMgr showToast:@"发送失败,请重试"];
                     [self getFlyScreenList];
                }
            }else{
                if ([UIAlertController class]) {
                    [self.inputTextfield resignFirstResponder];
                    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"余额不足"
                                                                                    message:@"当前余额不足，充值才可以继续发送，是否去充值"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    IMP_WSELF()
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [wself.inputTextfield resignFirstResponder];
                        HJPurchaseViewController *purchaseVC = [[HJPurchaseViewController alloc] initWithNibName:@"HJPurchaseViewController" bundle:nil];
                        [wself.navigationController pushViewController:purchaseVC animated:YES];
                    }];
                    [alert addAction:confirm];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"余额不足" message:@"当前余额不足，充值才可以继续送礼，是否去充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 2008;
                    [alert show];
                }
                [[StatisticsManager shareInstance] clickWithEventId:gift_show_no_enough_dialog];
            }
        }else{
            [[StatisticsManager shareInstance] customTimeEvent:play_comment_sent_click customAttributes:@{@"liveid":_STR(self.live.liveid)}];
            
            [[HJSeedIntf sharedIntfs] seed_chatMessage:content inLive:_live.liveid success:^(id result){
                DDLogInfo(@"OK");
                _inputTextfield.text = @"";
                
                HJChatMessage *message = [HJChatMessage new];
                message.time = [[NSDate date] timeIntervalSince1970];
                message.type = HJChatMsgTypeChatMessage;
                HJChatUser *cUser = [HJChatUser new];
                HJUserProfile *uProfile = [UserPrefs userProfile];
                cUser.uid = uProfile.userID;
                cUser.nickname = uProfile.nickname;
                cUser.level = uProfile.level;
                cUser.exp = uProfile.exp;
                cUser.avatar = uProfile.avatar;
                cUser.isVerified = uProfile.isVerified;
                cUser.verifiedInfo = uProfile.verifiedInfo;
                message.user = cUser;
                message.content = content;
                message.roomid = _live.liveid;
                if ([_chatController respondsToSelector:@selector(room:didRecieveMessage:)]) {
                    [_chatController room:_live.liveid didRecieveMessage:message];
                }
                
            }failure:^(NSError *error) { // 已被拉黑
                if (error.code == 1615) {
                    [HJToastMgr showToast:@"您已被主播拉黑"];
                } else if (error.code == 1616) { // 命中反垃圾
                    _inputTextfield.text = @"";
                } else if (error.code == 1612) { // 被禁言
                    [HJToastMgr showToast:@"您已被禁言"];
                }
                DDLogError(@"%@",error);
            }];
        }
    }
}

- (void)initFeiPingAnimView
{
    if(!feiPingAnimView){
        feiPingAnimView = [[HJFeiPingAnimView alloc] initWithFrame:CGRectMake(0, KScreenHeight - FLYSCREEN_HEIGHT - (mainHeight - 15), KScreenWidth, 81)];
        feiPingAnimView.delegate = self;
        if (giftEffectView) {
            [_operationContainer insertSubview:feiPingAnimView belowSubview:giftEffectView];
        }else{
            [_operationContainer insertSubview:feiPingAnimView belowSubview:self.buttonsContainer];
        }
    }
    feiPingAnimView.hidden = _contentHidden;
}

- (void)initGiftEffectView
{
    if(!giftEffectView){
        giftEffectView = [[HJGiftEffectView alloc] initWithMyFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - FLYSCREEN_HEIGHT - (mainHeight - 15)) withType:1];
        giftEffectView.delegate = self;
        [_operationContainer insertSubview:giftEffectView belowSubview:self.buttonsContainer];
    }
    giftEffectView.hidden = _contentHidden;
}

- (IBAction)onClickBackHomeButton:(id)sender {
    PlayReporter.close_type = 1;
    PlayReporter.close_reason = @"on_click_live_end_back_home";
    [PlayReporter report];
    [PlayReporter stop];
    [self _doClose];
}

- (void)loadLiveAssistantMsg {
    HJSystemMessageData *systemMessageData = [[HJSystemMessageData alloc] init];
    NSDictionary *dic = [[HJWalletCloudTextManager sharedManager] getDictionaryForKey:playing_guide_share_text defaultValue:PLAYING_GUIDE_SHARE_TEXT_DEFAULT];
    if (dic[@"playing_assistant_guide"] && ![dic[@"playing_assistant_guide"] isEqualToString:@""]) {
        systemMessageData.content = _STR(dic[@"playing_assistant_guide"]);
    } else {
        systemMessageData.content = LIVE_ASSISTANT_MSG;
    }
    [_chatController loadLocalMsgWith:systemMessageData];
}

#pragma mark <HJChatRoomDelegate>
/**
 * 收到用户分享主播直播消息
 */
- (void)room:(NSString *)roomID didRecieveShareMessage:(HJShareMessage *)shareMessage {
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if (shareMessage) {
        if ([_chatController respondsToSelector:@selector(room:didRecieveShareMessage:)]) {
            [_chatController room:roomID didRecieveShareMessage:shareMessage];
        }
    }
}
/**
 * 收到管理员/反垃圾/反作弊消息
 */
- (void)room:(NSString *)roomID didRecieveAdminMessage:(HJAdminMessage *)adminMessage {
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if (adminMessage.text.length && adminMessage.sysname.length) {
        if ([_chatController respondsToSelector:@selector(room:didRecieveAdminMessage:)]) {
            [_chatController room:roomID didRecieveAdminMessage:adminMessage];
        }
    }
}
/**
 * 收到红包
 */
- (void)room:(NSString *)roomID didRecieveRedPacketReward:(HJRedPacketReward *)redPacketReward {
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if (redPacketReward) {
        if (!self.currencySwitch) {
            _coinsTipsView.coins = (NSInteger)redPacketReward.host_income;
        }
    }
    if ([_chatController respondsToSelector:@selector(room:didRecieveRedPacketReward:)]) {
        [_chatController room:roomID didRecieveRedPacketReward:redPacketReward];
    }
}
/**
 * 收到实时激励
 */
- (void)room:(NSString *)roomID didRecieveActiveReward:(HJActiveReward *)reward {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if(reward.amount) {
        if (self.currencySwitch) {
            _coinsTipsView.coins = (NSInteger)reward.income_p;
        } else {
            _coinsTipsView.coins = (NSInteger)reward.income;
        }
        NSString *action = reward.action;
        //分享后模拟一个连发效果
        if (StringNotNullAndEmpty(action) && [action isEqualToString:@"share_heart"]) {
            [self performSelector:@selector(sendShareGift:) withObject:reward afterDelay:1];
        }
        
        if ([_chatController respondsToSelector:@selector(room:didRecieveActiveReward:)]) {
            [_chatController room:roomID didRecieveActiveReward:reward];
        }
    }
#endif
}

- (void)sendShareGift:(HJActiveReward *)reward
{
    [self initGiftEffectView];
    //模拟出一个礼物对象
    HJGiftReward *giftReward = [[HJGiftReward alloc] init];
    
    giftReward.sender = reward.sender;
    
    HJGiftInfo *giftInfo = [[HJGiftInfo alloc] init];
    giftInfo.icon = @"share_gift";
    giftInfo.giftname = @"分享之心";
    giftInfo.repeatID = Format_Str(@"@%f%d",[[NSDate  date] timeIntervalSince1970],rand());
    
    NSMutableDictionary *giftProperty = [NSMutableDictionary dictionary];
    [giftProperty setValue:@"1" forKey:@"repeatGift"];
    giftInfo.giftProperty = giftProperty;
    
    giftReward.giftInfo = giftInfo;
    
    [giftEffectView startGift:giftReward];
}

/**
 * 收到礼物
 */
- (void)room:(NSString *)roomID didRecieveGiftReward:(HJGiftReward *)giftReward {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if(giftReward) {
        if([giftReward.receiver.uid isEqualToString:[UserPrefs userID]]){
            self.giftVIew.balance = giftReward.receiver_balance;
        }
        if ([giftReward.receiver.uid isEqualToString:_liveInfo.author.uid]) {
            if (self.currencySwitch) {
                _coinsTipsView.coins = (NSInteger)giftReward.receiver_income_p;
            } else {
                _coinsTipsView.coins = (NSInteger)giftReward.receiver_income;
            }
        }
        else if ([giftReward.sender.uid isEqualToString:_liveInfo.author.uid]) {
            
        }
        if ([_chatController respondsToSelector:@selector(room:didRecieveGiftReward:)]) {
            giftReward.liveid = _liveInfo.author.uid;
            [_chatController room:roomID didRecieveGiftReward:giftReward];
        }
        
        if ([_userListView respondsToSelector:@selector(room:didRecieveGiftReward:)]) {
            giftReward.liveid = _liveInfo.author.uid;
            [_userListView room:roomID didRecieveGiftReward:giftReward];
        }
        
        [self initGiftEffectView];
        if([giftReward.receiver.uid isEqualToString:self.anchor.uid])
            [giftEffectView startGift:giftReward];
    }
#endif
}

#pragma HJGiftEffectViewDelegate HJFeiPingAnimViewDelegate
- (void)openUserCardView:(HJChatUser *)chatUser
{
    //打开用户卡片
    [self showUserProfile:chatUser];
    
    NSDictionary *attrDic = @{@"uid":_STR(_liveInfo.author.uid), @"liveID":_STR(self.live.liveid),@"viewerID":_STR(_userId)};
    [[StatisticsManager shareInstance] customTimeEvent:record_viewer_click_feiping customAttributes:attrDic];
}

/**
 * 收到公幕/私幕消息
 */
- (void)room:(NSString *)roomID didRecieveOfficialNotice:(HJOfficialNotice *)officialNotice {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if(officialNotice) {
        _officialNoticeView.officialNotice = officialNotice;
    }
#endif
}

/**
 * 收到点赞消息
 */
- (void)room:(NSString *)roomID didRecievePraise:(HJUserPraiseData *)praiseData {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    [_praiseController receivePraiseData:praiseData];
    //    [self.temperature setPraise:(NSInteger)_praiseController.totalCount time:(NSInteger)self.playingTime];
#endif
}

/**
 * 收到聊天消息
 */
- (void)room:(NSString *)roomID didRecieveMessage:(HJChatMessage *)chatMessage membersCount:(NSUInteger)membersCount {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }

    //飞屏
    if(chatMessage.gift != 0){
        if ([chatMessage.user.uid isEqualToString:_userId]) {
            return;
        }
        [self initFeiPingAnimView];
        [feiPingAnimView startFeiPing:chatMessage];
        
        if ([_chatController respondsToSelector:@selector(room:didRecieveMessage:)]) {
            [_chatController room:roomID didRecieveMessage:chatMessage];
        }
    }else{
        if ([chatMessage.user.uid isEqualToString:_userId]) {
            return;
        }
        if ([_chatController respondsToSelector:@selector(room:didRecieveMessage:)]) {
            [_chatController room:roomID didRecieveMessage:chatMessage];
        }
    }
#endif
}

/**
 * 收到房间成就消息
 */
- (void)room:(NSString *)roomID didRecieveAchievement:(NSInteger)count {
#if (!DEBUG_PLAYER_CPU_BUG)
    //    if (![roomID isEqualToString:_live.liveid]) {
    //        return;
    //    }
    //    if ([_chatController respondsToSelector:@selector(room:didRecieveAchievement:)]) {
    //        [_chatController room:roomID didRecieveAchievement:count];
    //    }
#endif
}

/**
 * 收到用户进入通知
 */
- (void)room:(NSString *)roomID didRecieveUserJoin:(HJChatUser *)user membersCount:(NSUInteger)membersCount watches:(NSUInteger)watches{
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if ([_chatController respondsToSelector:@selector(room:didRecieveUserJoin:membersCount:watches:)]) {
        [_chatController room:roomID didRecieveUserJoin:user membersCount:(NSUInteger)membersCount watches:(NSUInteger)watches];
    }
    [_userListView room:roomID didRecieveUserJoin:user membersCount:(NSUInteger)membersCount watches:(NSUInteger)watches];
#endif
}

/**
 * 收到用户禁言通知
 */
- (void)room:(NSString *)roomID didReceivePunishment:(HJChatUser *)user {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if(user.uid.length) {
        if ([_chatController respondsToSelector:@selector(room:didReceivePunishment:)]) {
            [_chatController room:roomID didReceivePunishment:user];
        }
    }
#endif
}

/**
 * 收到关注主播消息
 */
- (void)room:(NSString *)roomID didReceiveFollowOwnerMessage:(HJChatUser *)user {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if(user.uid.length) {
        if ([user.uid isEqualToString:_userId]) {
            int i;
            i = 0;
        }
        HJChatFollowMassage* folowMassage = (HJChatFollowMassage*) user;
        if ([folowMassage.follower.uid isEqualToString:self.anchor.uid]) {
            folowMassage.isAnchorFollower = YES;
        }
        else{
            folowMassage.isAnchorFollower = NO;
        }
        
        if([[UserPrefs userID] isEqualToString:user.uid]) {
        }
        if ([_chatController respondsToSelector:@selector(room:didReceiveFollowOwnerMessage:)]) {
            [_chatController room:roomID didReceiveFollowOwnerMessage:user];
        }
    }
    
#endif
}

/**
 * 收到游客进入通知
 */
- (void)room:(NSString *)roomID didRecieveGuestJoin:(NSString *)userID membersCount:(NSUInteger)membersCount watches:(NSUInteger)watches{
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if ([_chatController respondsToSelector:@selector(room:didRecieveGuestJoin:membersCount:watches:)]) {
        [_chatController room:roomID didRecieveGuestJoin:userID membersCount:membersCount watches:watches];
    }
    
    [_userListView room:roomID didRecieveGuestJoin:userID membersCount:membersCount watches:watches];
#endif
}

/**
 * 收到用户退出通知
 */
- (void)room:(NSString *)roomID didRecieveUserQuit:(NSString *)userID membersCount:(NSUInteger)membersCount {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    [_userListView room:roomID didRecieveUserQuit:userID membersCount:membersCount];
#endif
}

/**
 * 总人数更新
 */
- (void)room:(NSString *)roomID didNumberOfAllUsersChanged:(NSInteger)number {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    //    ZILog(ZZLogChatModule, @"刷新总人数");
    [_userListView room:roomID didNumberOfAllUsersChanged:number];
#endif
}

/**
 * 收到直播暂停消息
 */
- (void)room:(NSString *)roomID didRecieveLivePauseNotice:(HJLivePauseResumeNotice *)notice
{
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    UIImage *image = [[HJPlayer player] snapshotImage];
    CGRect frame =  (CGRect){0,0,image.size.width,image.size.height};
    image = [image applyLightEffectAtFrame:frame withBlurRadius:BLUR_RADIUS];
    if (image.size.width < image.size.height) {
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    _thumbImageView.hidden = NO;
    _thumbImageView.alpha = 1.0;
    [self.homeContainer insertSubview:_thumbImageView aboveSubview:_videoContainer];
    _thumbImageView.image = image;
    
    [_videoState stopAnim];
    _videoState.hidden = NO;
    _videoState.alpha = 1.0;
    [_videoState bringSubviewToFront:self.homeContainer];
    [_videoState startAnimWithType:HJAnimTypePlayPause loadText:@"主播暂时离开，请稍候..."];
    if ([_inputTextfield isFirstResponder]) {//在显示主播离开或加载中时，关闭键盘
        [_inputTextfield resignFirstResponder];
    }
    
    _isLivePause = YES;
    _livePauseTimeStamp=time(0);
}

-(void)resumeLivingByStreamState
{
    if(_isLivePause && time(0)-_livePauseTimeStamp>2) //因为有可能流在主播暂停后的两秒内还继续过来，对两秒内的流不响应
    {
        [self resumeLiving];
    }
}

-(void)resumeLiving
{
    _thumbImageView.hidden = YES;
    
    if (!Is320x480hScreen()) {      // 理解上这行代码是不用加的，会使iphone4，4s手机压扁，为了保险起见，在4，4s手机上不用这一行
        [HJPlayer player].glView.frame=(CGRect){0,0,KScreenWidth,KScreenHeight};
    }
    
    [_videoState stopAnim];
    _videoState.hidden = YES;
    
    _isLivePause = NO;
}
/**
 * 收到等级更新
 */
- (void)room:(NSString *)roomID didRecieveUserLevelChange:(HJUserLevelChange *)levelChange {
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if(levelChange) {
        //判断是否需要飞屏
//        if (_INT(levelChange.level) >= 10) {
//            NSString *flyContent = Format_Str(@"撒花！恭喜%@升级至%@级！",levelChange.nickname, levelChange.level);
//            
//            HJChatMessage *message = [HJChatMessage new];
//            message.time = [[NSDate date] timeIntervalSince1970];
//            message.type = HJChatMsgTypeChatMessage;
//            HJChatUser *cUser = [HJChatUser new];
//            cUser.uid = levelChange.uid;
//            cUser.nickname = levelChange.nickname;
//            cUser.level = levelChange.level;
//            cUser.avatar = @"app_icon";
//            message.user = cUser;
//            message.content = flyContent;
//            message.roomid = self.live.liveid;
//            message.isMasterUpgrade = YES;
//            
//            [self initFeiPingAnimView];
//            [feiPingAnimView startFeiPing:message];
//        }
        
        if ([_chatController respondsToSelector:@selector(room:didRecieveUserLevelChange:)]) {
            [_chatController room:roomID didRecieveUserLevelChange:levelChange];
        }
    }
}

/**
 * 收到直播继续消息
 */
- (void)room:(NSString *)roomID didRecieveLiveResumeNotice:(HJLivePauseResumeNotice *)notice
{
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    [self resumeLiving];
}
/**
 * 收到踢人消息
 */
- (void)room:(NSString *)roomID didRecieveKickOut:(HJKickOut *)kickOut {
    if (![roomID isEqualToString:_live.liveid]) {
        return;
    }
    if (!kickOut) {
        return;
    }
    if ([kickOut.userid isEqualToString:[UserPrefs userID]]) { // 本地客户端被踢
        [[HJPlayer player] stop];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您被主播踢出直播间" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 2016;
        [alert show];
    } else { // 别人被踢
        if ([_chatController respondsToSelector:@selector(room:didRecieveKickOut:)]) {
            [_chatController room:roomID didRecieveKickOut:kickOut];
        }
    }
}
/**
 * 加入房间成功
 */
- (void)didJoinRoomSucceed:(NSString *)roomID {
#if (!DEBUG_PLAYER_CPU_BUG)
    if (roomID==nil || ![roomID isEqualToString:_live.liveid]) {
        return;
    }
    [_userListView didJoinRoomSucceed:roomID];
#endif
}

- (void)didJoinRoomSucceedWithInfo:(HJRoomInfos *) info
{
#if (!DEBUG_PLAYER_CPU_BUG)
    if (info==nil || info.roomid==nil || ![info.roomid isEqualToString:_live.liveid]) {
        return;
    }
    [_userListView didJoinRoomSucceedWithInfo:info];
#endif
}

/**
 * 聊天连接中断
 */
- (void)didChatRoomLostConnection:(NSString *)roomID {
//    if (![roomID isEqualToString:_live.liveid]) {
//        return;
//    }
}

/**
 * 直播结束
 */
#pragma mark - 直播结束  跳到结束页
- (void)didSeedEnd:(HJSeedEndData *)seedEndData {
    ZILog(ZZLogChatModule, @"直播结束: %@",seedEndData);
    if (seedEndData==nil || ![seedEndData.roomid isEqualToString:_live.liveid]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    _redEnvelopeVC.isLivingFinished = YES;
    [_redEnvelopeView closeRedEnvelope:nil];
    
    [HJUserProfileView dismiss];
    
    [self statisticWatchingTime];
    // 获取截图
    //    UIImage *snap = [[HJPlayer player] snapshotImage];
    
    [self stopLoading];
    
    [self stop];
    
    BOOL kicked = (seedEndData.type != 0); // 运营停播
#pragma mark - 修改
    
    [[HJMessageCenterManager sharedManager] tapOnWindowAction];
    
//    _operationContainer.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:khidShareviewNotification object:nil];
    
    [self dealWithPlayEnd:_liveInfo hasReplayData:YES];
    
    if (kicked) {
        [[StatisticsManager shareInstance] clickWithEventId:record_cutdown];
    }
}

/**
 * 错误处理
 */
- (void)room:(NSString *)roomID
 handleError:(HJRoomErrorCode)errorCode {
    DDLogError(@"聊天错误码: %d",(int)errorCode);
    if(errorCode == HJRoomErrorCodeKicked)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HJToastMgr showToast:@"主播已禁止你进入此直播间"];
            [self closeWatchBroadcast];
        });
    }
    
    if (roomID==nil || ![roomID isEqualToString:_live.liveid]) {
        return;
    }
    
    if (errorCode == HJRoomErrorCodeJoinRoomFailed) {
        dispatch_async(dispatch_get_main_queue(),^{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(joinRoom) object:nil];
            [self performSelector:@selector(joinRoom) withObject:nil afterDelay:10];
        });
    }
}

#pragma mark <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == _operationContainer
        || touch.view == _chatController.view
        || touch.view == _userListView
        //        || [_temperature.subviews containsObject:touch.view.superview]
        //        || [_temperature.subviews containsObject:touch.view]
        || [touch.view isKindOfClass:[UITableViewCell class]]
        || [touch.view.superview isKindOfClass:[UITableViewCell class]]
        || touch.view == giftEffectView
        ) {
        return YES;
    }
    return NO;
}

#pragma mark <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _inputTextfield.textColor = [UIColor blackColor];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _inputTextfield.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _inputTextfield) {
        //        if ([string isEqualToString:@"\n"]) { //按回车
        //            [self onClickSendButton];
        //            return YES;
        //        }
        
        if([self readDanmuSwitcStatus])
        {
            if(string.length > 0 && textField.text.length > 30)
            {
                return NO;
            }
        }
        else
        {
            if (string.length>0 && textField.text.length > 200) {
                return NO;
            }
        }
    }
    
    
    return YES;
}
- (void) textFieldChanged:(UITextField *)textField
{
    if (textField == _inputTextfield)
    {
        if([self readDanmuSwitcStatus])
        {
            NSString *lang =[[textField textInputMode] primaryLanguage];
            if([lang isEqualToString:@"zh-Hans"])
            {
                UITextRange *selectedRange = [textField markedTextRange];
                UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
                if(!position)
                {
                    if(textField.text.length >20)
                    {
                        textField.text = [textField.text substringToIndex:20];
                    }
                }
            }
            else
            {
                
                if(textField.text.length > 20)
                {
                    textField.text = [textField.text substringToIndex:20];
                }
            }

        }
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickSendButton];
    return YES;
}

#pragma mark - UIApplicationNotification
- (void)screenShot{
    [[HJMessageCenterManager sharedManager] tapOnWindowAction];
    [self.view endEditing:YES];
    _userListView.hidden = YES;
    _closeButton.hidden = YES;
    _thumbImageView.hidden = YES;
    _userCard.hidden = YES;
    UIImage *watermark = [UIImage imageNamed:@"live_watermark"];
    CGSize size = self.view.frame.size;
    IMP_WSELF();
    [HJScreenShotView shotScreenInView:_operationContainer withWatermark:watermark atRect:CGRectMake(size.width - watermark.size.width - 15, 31, watermark.size.width, watermark.size.height) page:HJScreenshotPagePlaying roomid:_liveInfo.feed.relateid didtakesnapshot:^(UIImage *image) {
        __strong typeof(wself) strongself = wself;
        if (strongself != nil) {
            strongself -> _userListView.hidden = NO;
            strongself -> _closeButton.hidden = NO;
            strongself -> _userCard.hidden = NO;
        }
    }];
}

- (void)onApplicationNotification:(NSNotification *)n {
    
    if(n.name == UIApplicationDidEnterBackgroundNotification) {
        if ([self.retryTimer isValid]) {
            _shouldRetryWhenBecomeActive = YES;
            [self stopRetry];
        }
        [giftEffectView cleanAllGift];
        [feiPingAnimView cleanAllFeiPing];
        [self statisticWatchingTime];
        [[HJPlayer player] enterIntoBackground];
        //        [[HJPlayer player] pause];
        [NSThread sleepForTimeInterval:0.5];
        if(qhiv_sid)
            notify_user_background([qhiv_sid UTF8String]);
    }else if(n.name == UIApplicationDidBecomeActiveNotification) {
        if (_shouldRetryWhenBecomeActive) {
            _shouldRetryWhenBecomeActive = NO;
            [self startRetry];
        }
        [giftEffectView startGiftEffect];
        [feiPingAnimView resumeFeiping];
        ////停止直播、看播
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"pause_Video_notification" object:nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"pause_Replay_notification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];

        _beginPlayTs = [[NSDate date] timeIntervalSince1970];
        //        [[HJPlayer player] resume];
        
        [[HJPlayer player] backToFront];
        if(qhiv_sid)
            notify_user_foreground([qhiv_sid UTF8String]);
        //        if(isCallComing){
        //            //删除glview
        //            NSArray *mViews = [_videoContainer subviews];
        //            for (UIView *view in mViews) {
        //                [view removeFromSuperview];
        //            }
        //            //重新添加glview
        //            [_videoContainer addSubview:[HJPlayer player].glView];
        //            [HJPlayer player].glView.hidden = NO;
        //            isCallComing = NO;
        //        }
    }else if(n.name == UIApplicationWillResignActiveNotification) {
        //        [[HJPlayer player] pause];
        [self.view endEditing:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        [[HJPlayer player] enterIntoBackground];
        [NSThread sleepForTimeInterval:0.5];
        if(qhiv_sid)
            notify_user_background([qhiv_sid UTF8String]);
    }
}

- (void)userListView:(HJUserListView *)listView didClickUser:(HJChatUser *)user {
    DDLogInfo(@"UserAction");
    if(_inputTextfield.isFirstResponder) {
        [_inputTextfield resignFirstResponder];
        
    }
    [self showUserProfile:user];
}

- (void)updateOnlineCount:(NSInteger)onlineCount watchCount:(NSInteger)watchCount
{
    _onlineCount = onlineCount;
    _watchCount = watchCount;
    NSString *countString = [NSString stringWithFormat:_LS(@"playing_watch_num"), (long)watchCount];
    [_anchorView setLiveTime:countString];
}


- (void)chatController:(HJChatController_v2 *)controller didClickUser:(HJChatUser *)user {
    DDLogInfo(@"UserAction:%@", user.uid);
    if(_inputTextfield.isFirstResponder) {
        [_inputTextfield resignFirstResponder];
    }
    [self showUserProfile:user];
}

-(UIView *)emptyView{
    if (_emptyView == nil) {
        UIView *iconView  = [[UIView alloc] init];
        // iconView.image = [UIImage imageNamed: [UserPrefs userProfile].avatar];
        iconView.frame = (CGRect){0,0,10,0};
        
        _emptyView = iconView;
    }
    
    return _emptyView;
}

-(UIView *)iconView{
    if (_iconView == nil) {
        NSString *uid = [UserPrefs userID];
        NSString *roomId = [[HJChatRoomMgr sharedInstance] roomID];
        UIColor* color=kColorRamdon([uid integerValue]+[roomId integerValue]);
        
        CGFloat height = _inputTextfield.frame.size.height;
        UIImageView *iconView  = [[UIImageView alloc] init];
        UIView *view = [[UIView alloc ] init];
        view.frame = (CGRect){0,0,height +10,height};
        
        UIView *maskView = [[UIView alloc ] init];
        maskView.frame = (CGRect){0,0,height,height};
        maskView.backgroundColor = color;
        maskView.alpha = 0.4;
        [iconView sd_setImageWithURL:[NSURL URLWithString:[UserPrefs userProfile].avatar]];
        iconView.frame =  (CGRect){0,0,height,height};
        
        [view  addSubview:iconView];
        [view addSubview:maskView];
        iconView.tintColor = color;
        _iconView = view;
    }
    return _iconView;
}

- (void)updateEndFollowButton {
    if (_followed) { // 关注
        [_endFollowButton setBackgroundImage:[UIImage imageNamed:@"btnw_new"] forState:UIControlStateNormal];
        [_endFollowButton setBackgroundImage:[UIImage imageNamed:@"btnwpress_new"] forState:UIControlStateHighlighted];
        [_endFollowButton setTitle:@" 已关注" forState:UIControlStateNormal];
        [_endFollowButton setImage:[UIImage imageNamed:@"icocancel"] forState:UIControlStateNormal];
        [_endFollowButton setImage:[UIImage imageNamed:@"icocancel"] forState:UIControlStateHighlighted];
        [_endFollowButton setTitleColor:[UIColor colorForHex:@"4d4d4d"] forState:UIControlStateNormal];
    } else { // 取消关注
        [_endFollowButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
        [_endFollowButton setTitle:@" 关注主播" forState:UIControlStateNormal];
        [_endFollowButton setBackgroundImage:[UIImage imageNamed:@"btnpress"] forState:UIControlStateHighlighted];
        [_endFollowButton setImage:[UIImage imageNamed:@"ico_add"] forState:UIControlStateNormal];
        [_endFollowButton setImage:[UIImage imageNamed:@"ico_add"] forState:UIControlStateHighlighted];
        [_endFollowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)joinRoom {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(joinRoom) object:nil];
    [[HJChatRoomMgr sharedInstance] joinRoom:_live.liveid];
}

#pragma mark - HJAnchorViewDelegate
- (void)mainPageAction:(HJUserProfilesResponse *)userProfile
{
    //    [self onClickCloseButton:nil];
    DDLogInfo(@"UserAction");
    [self gotoMainPageWith:userProfile];
}
- (void)tellHimAction:(HJUserProfilesResponse *)userProfile
{
    DDLogInfo(@"UserAction");
    [self tellHim:userProfile];
}

//改变plaingvc中feed的关注状态
- (void)changeFeedFocusStatus:(BOOL)isFocused
{
    _liveInfo.author.followed = isFocused;
}

- (void)gotoMainPageWith:(HJUserProfilesResponse*)userProfile
{
    DDLogInfo(@"UserAction");
    [[HJPlayer player] pause];
    _playerPaused = YES;
    
    HJMyHomeViewController *profileVc = [HJMyHomeViewController new];
    profileVc.userInfo = userProfile;
    profileVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:profileVc animated:YES];
}

- (void)showUserProfile:(HJChatUser*)user
{
    //防止多次点击
    if (!_closeButton.isHidden) {
        DDLogInfo(@"UserAction");
        [_userCard showInView:_operationContainer];
        [_switchView setScrollEnabled:NO];
        IMP_WSELF();
        _userCard.dismissBlock = ^(){
            [wself.switchView setScrollEnabled:YES];
        };
        HJUserCardModel *userCardModel = nil;
        HJUserCardModelObject *modelobj = [[HJUserCardModelObject alloc]init];
        modelobj.livingID = _live.liveid;
        modelobj.comeType = HJUserCard_playing;
        if ([user.uid isEqualToString:[UserPrefs userID]]) {
            modelobj.deviceModel = [UIDevice mobileName];
            userCardModel = [HJUserCardModel userCardModelWithHJChatUser:user userCardModelObject:modelobj];
        } else {
            modelobj.deviceModel = _liveInfo.feed.device;
            userCardModel = [HJUserCardModel userCardModelWithHJChatUser:user userCardModelObject:modelobj];
        }
        userCardModel.livingID = @"";//不传LivingId,以免在关注非主播时发送到房间消息
        _userCard.userCardModel = userCardModel;
    }
}

- (void)tellHim:(HJUserProfilesResponse*)userProfile
{
    DDLogInfo(@"UserAction");
    if(_inPunishment) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您在黑名单，不能发言" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        if (![userProfile.nickname isEqualToString:@""] && userProfile.nickname != nil) {
            NSString *atString = [NSString stringWithFormat:@"@%@ " , userProfile.nickname];
            
            _inputTextfield.text = atString;
            [_inputTextfield becomeFirstResponder];
            
        }
    }
}

- (void)userCard:(UIView *)view handleAction:(HJUserCardACTIONTYPE)actionType object:(id)object
{
    switch (actionType) {
        case HJUserCard_CLICK_gift:
        {
            DDLogInfo(@"UserAction");
            self.giftVIew.receiverID = _userCard.userCardModel.uid;
            self.giftVIew.feedID = _live.liveid;
            [_giftVIew showInView:self.homeContainer];
        }
            break;
            case HJUserCard_CLICK_tellhim:
        {
            DDLogInfo(@"UserAction");
            HJUserCardModel *cardModel = object;
            if (![cardModel.nickname isEqualToString:@""] && cardModel.nickname!=nil) {
                NSString *atString = [NSString stringWithFormat:@"@%@ " , cardModel.nickname];
                _inputTextfield.text = atString;
                [_inputTextfield becomeFirstResponder];
                [_userCard dismiss];
            }
        }
            break;
        case HJUserCard_CLICK_follow_success:
        {
            DDLogInfo(@"UserAction");
            if ([object isKindOfClass:[NSString class]]) {
                [_anchorView updateAnchorViewFrameWithuID:object followed:YES];
            }
        }
            break;
//        case HJUserCard_CLICK_unfollow_success:
//        {
//            if ([object isKindOfClass:[NSString class]]) {
//                [_anchorView updateAnchorViewFrameWithuID:object followed:NO];
//            }
//        }
//            break;
        default:
            break;
    }
}

#pragma mark - 获取当前播放的视频信息
- (NSString *)getCurrentLiveId
{
    LivingSwitchObject *object = [_switchData objectAtIndex:_curPlayIndex];
    return object.liveid;
}

- (NSString *)getCurrentUserId
{
    LivingSwitchObject *object = [_switchData objectAtIndex:_curPlayIndex];
    return object.userid;
}

- (void)initLiveAndAnchorInfo
{
    //由于现在接口传入的是LivingSwitchObject 需要把它转成Live和Anchor
    LivingSwitchObject *object = [_switchData objectAtIndex:_curPlayIndex];
    
    HJSeedLiveResponse *live = [[HJSeedLiveResponse alloc] init];
    live.liveid = object.liveid;
    live.sn = object.sn;
    [self setLive:live];
    
    HJSeedAnchorResponse *anchor = [[HJSeedAnchorResponse alloc] init];
    anchor.uid = object.userid;
    [self setAnchor:anchor];
}

#pragma mark - LivingSwitchViewDatSource
- (NSInteger)numberOfItemsInLivingSwitchView:(LivingSwitchView *)switchView
{
    return [_switchData count];
}

- (NSString *)livingSwitchView:(LivingSwitchView *)switchView imageURLAtIndex:(NSInteger)index
{
    LivingSwitchObject *object = [_switchData objectAtIndex:index];
    return object.imageUrl;
}

#pragma mark - LivingSwitchViewDelegate
- (void)livingSwitchView:(LivingSwitchView *)switchView didHideItemAtIndex:(NSInteger)index
{
    [self stop];
    [self.homeContainer removeFromSuperview];
    
    [self stopShareRemindTimer];
}

- (void)livingSwitchView:(LivingSwitchView *)switchView didShowItemAtIndex:(NSInteger)index inView:(LivingSwitchCell *)cell
{
    
    NSInteger feedCount = [self.feedData count];
     NSInteger newerJoinCount = [self.newerDataArray count];
    NSInteger sumCount = self.switchData.count;
    if ((newerJoinCount + feedCount) > sumCount ) {
        
        NSMutableArray *tempSwitchData = [NSMutableArray array];
        [tempSwitchData addObjectsFromArray:self.feedData];
        for (int i = 0; i < self.newerDataArray.count; i++) {
            int j = i * 2 + 3;
            if (j <= tempSwitchData.count) {
                [tempSwitchData insertObject:self.newerDataArray[i] atIndex:j];
            }else{
                break;
            }
        }
        
        LivingSwitchObject *currentSwitchObj = [self.switchData objectAtIndex:index];
        NSInteger tempPlayIndex = [tempSwitchData indexOfObject:currentSwitchObj];
        
        if (tempPlayIndex > tempSwitchData.count || tempPlayIndex == NSNotFound ) {
            tempPlayIndex = 0;
        }
        
        self.switchData = tempSwitchData;
        
        [_switchView setPlayIndex:tempPlayIndex];
        return;
    }
    
    [self startShareRemindTimer];
    
    NSString *event = @"";
    if (_curPlayIndex < index) {
        _direction = SWITCH_DIRECTION_RIGHT;
        event = @"live_swipe_next";
    } else {
        if (_curPlayIndex > index) {
            _direction = SWITCH_DIRECTION_LEFT;
        }
        event = @"live_swipe_pre";
    }
    
    if ((_curPlayIndex > [_switchData count] - 10) && [_switchData count] < 120) {
        [self loadMoreLive:_more];
    }
    
    NSString *curLiveId = _live.liveid;
    NSString *curUid = _anchor.uid;
    
    self.homeContainer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [cell.viewForLive addSubview:self.homeContainer];
    
    [cell.viewForLive addConstraint:[NSLayoutConstraint constraintWithItem:cell.viewForLive attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.homeContainer attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [cell.viewForLive addConstraint:[NSLayoutConstraint constraintWithItem:cell.viewForLive attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.homeContainer attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [cell.viewForLive addConstraint:[NSLayoutConstraint constraintWithItem:cell.viewForLive attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.homeContainer attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [cell.viewForLive addConstraint:[NSLayoutConstraint constraintWithItem:cell.viewForLive attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.homeContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    _curPlayIndex = index;
    UIImage *blurImage = cell.imageView.image;
    NSString *imageUrl = [_switchData objectAtIndex:_curPlayIndex].imageUrl;
    [_thumbImageView setImage:[UIImage imageNamed:@"live_default_cover"]];
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:blurImage];

    [self reinitPlayerAndStartPlay];
    
    NSString *nextLiveId = _live.liveid;
    NSString *nextUid = _anchor.uid;
    if (curLiveId && curUid && nextLiveId && nextUid && _userId && ![curLiveId isEqualToString:nextLiveId]) {
        NSDictionary *params = @{@"liveID":_STR(curLiveId), @"nextLiveID":_STR(nextLiveId), @"uid":_STR(curUid), @"nextHostUID":_STR(nextUid), @"viewerID":_STR(_userId)};
        [[StatisticsManager shareInstance] customTimeEvent:event customAttributes:params];
    }
}

- (void)reinitPlayerAndStartPlay
{
    [self stopRetry];
    [self stopRetryLoadUserCoinData];
    _retryTimes = 0;
    _retryCoinTimes = 0;
    
    _isLivePause = NO;
    [self initLiveAndAnchorInfo];
    [_videoContainer addSubview:[HJPlayer player].glView];
    [self play];
    [HJChatRoomMgr sharedInstance].chatDelegate = self;
    _chatController.roomID = self.live.liveid;
    [_chatController resetCheckDanmuRate];
    [_coinsTipsView resetCoins];
    [self loadUserCoinData];
    
    _giftVIew.feedID = _live.liveid;
    
    [self createPriseController];
    // 飘心层
    [_heartsEmitterContainer addSubview:_praiseController.heartsEmitter];
    _praiseController.heartsEmitter.translatesAutoresizingMaskIntoConstraints = NO;
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeLeft multiplier:1 constant:1]];
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeTop multiplier:1 constant:1]];
    [_heartsEmitterContainer addConstraint:[NSLayoutConstraint constraintWithItem:_heartsEmitterContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_praiseController.heartsEmitter attribute:NSLayoutAttributeBottom multiplier:1 constant:1]];
    
    _praiseController.heartsEmitter.hidden = !_closeFullScreenBtn.hidden;
    
    // 点赞按钮
    [_praiseBtnContainer addSubview:_praiseController.praiseCountBtn];
    _praiseController.praiseCountBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_praiseBtnContainer addConstraint:[NSLayoutConstraint constraintWithItem:_praiseBtnContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_praiseController.praiseCountBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

#pragma mark - 显示直播结束或切换到下一个直播
- (void)switchToNextLive
{
    DDLogInfo(@"UserAction");
    LivingSwitchObject *current = [_switchData objectAtIndex:_curPlayIndex];
    if ([self.newerDataArray containsObject:current]) {
        [self.newerDataArray removeObject:current];
    }
    if ([self.feedData containsObject:current]) {
         NSMutableArray *temp = [NSMutableArray arrayWithArray:self.feedData];
        [temp removeObject:current];
        self.feedData = temp;
    }
    
    [self.switchData removeObjectAtIndex:_curPlayIndex];
    
    //根据滑动方向，切换到上一个或下一个
    if (_direction == SWITCH_DIRECTION_RIGHT) {
        if (_curPlayIndex >= [_switchData count]) {
            _curPlayIndex = [_switchData count] - 1;
        }
    } else {
        _curPlayIndex = _curPlayIndex-1;
        if (_curPlayIndex < 0) {
            _curPlayIndex = [_switchData count] - 1;
        }
    }

    [_switchView setPlayIndex:_curPlayIndex];
}

/***
 * 处理结束页面
 * feeds
 *
 **/
- (void)dealWithPlayEnd:(Feeds *)feeds hasReplayData:(BOOL)hasReplayData
{
    _canShowPlayerMessage = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[HJPlayer player] stop];//此处增加一个停止播放的方法，是因为刚结束的视频，使用Player和sn仍然可以播放，但在getFeed方法里，它已经结束了。
    
    Author *author;
    NSInteger mWatchCount = _watchCount;
    if (feeds == nil || feeds.author == nil) {
        if (self.switchData != nil && self.switchData.count > 0 && _curPlayIndex<self.switchData.count) {
            LivingSwitchObject *switchData = [self.switchData objectAtIndex:_curPlayIndex];
            author = [[Author alloc] init];
            author.uid = switchData.userid;
            author.avatar = switchData.imageUrl;
        }
    }else{
        author = feeds.author;
        int temp = _INT(feeds.feed.watches);
        if (temp > mWatchCount) {
            mWatchCount = temp;
        }
    }
    self.recommendLiveEndVc = [[HJPlayingEndViewController alloc] initWithAuthor:author audienceCount:mWatchCount];
    IMP_WSELF();
    self.recommendLiveEndVc.onClickCloseButtonBlock = ^{
        wself.pageType = 2;
        [wself onClickCloseButton:wself.closeButton];
    };
    //防止再次进入replayend
    self.isFirstPlay = YES;
    self.recommendLiveEndVc.delegate = self;
    [self.view addSubview:self.recommendLiveEndVc.view];
    self.recommendLiveEndVc.view.frame = self.view.bounds;
    [self addChildViewController:self.recommendLiveEndVc];
    
//    if (hasReplayData) {
//        NSDictionary *params = nil;
//        if (feeds.feed.image) {
//            params = [NSDictionary dictionaryWithObjectsAndKeys:feeds.feed.image, @"image", nil];
//        }
//        [HJADManager handleURL:[NSString stringWithFormat:REDIRECT_REPLAY,feeds.feed.relateid] WithDic:params];
//    }else{
//        self.recommendLiveEndVc = [[HJPlayingEndViewController alloc] initWithAuthor:feeds.author];
//        IMP_WSELF();
//        self.recommendLiveEndVc.onClickCloseButtonBlock = ^{
//            [wself onClickCloseButton:wself.closeButton];
//        };
//        self.recommendLiveEndVc.delegate = self;
//        [self.view addSubview:self.recommendLiveEndVc.view];
//        self.recommendLiveEndVc.view.frame = self.view.bounds;
//        [self addChildViewController:self.recommendLiveEndVc];
////        
////        HJLiveEndViewController *liveEndVc = [[HJLiveEndViewController alloc] initWithRelativeId:_live.liveid type:HJPageTypePlay];
////        liveEndVc.feeds = _liveInfo;
////        IMP_WSELF();
////        liveEndVc.onClickCloseButtonBlock = ^{
////            [wself onClickCloseButton:wself.closeButton];
////        };
////        [self.view addSubview:liveEndVc.view];
////        liveEndVc.view.frame = self.view.bounds;
////        [self addChildViewController:liveEndVc];
//    }
}

#pragma HJPlayingEndViewControllerDelegate
- (void)redirectToPlayingVc:(Feeds *)mFeed
{
    if (mFeed) {
        [self.recommendLiveEndVc.view removeFromSuperview];
        [self.recommendLiveEndVc removeFromParentViewController];
        
        LivingSwitchObject *switchObject = [[LivingSwitchObject alloc] initWithLiveid:mFeed.feed.relateid
                                                                                andSN:mFeed.feed.sn
                                                                            andUserid:mFeed.author.uid
                                                                          andImageUrl:mFeed.author.avatar];
        self.feedData = [NSArray array];
        [self.newerDataArray removeAllObjects];
        _switchData = [NSMutableArray arrayWithObject:switchObject];
        _curPlayIndex = 0;
        [_switchView setPlayIndex:0];
    }
}

- (void)redirectToUserCenter:(NSString *)userId
{
    if (StringNotNullAndEmpty(userId)) {
        [HJADManager handleURL:[NSString stringWithFormat:@"huajiao://asdf/profile?userid=%@",userId] WithDic:nil];
    }
}

//- (void)showEndControllerWithFeeds:(Feeds *)feeds
//{
//    _canShowPlayerMessage = NO;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
//    [[HJPlayer player] stop];//此处增加一个停止播放的方法，是因为刚结束的视频，使用Player和sn仍然可以播放，但在getFeed方法里，它已经结束了。
//    HJLiveEndViewController *liveEndVc = [[HJLiveEndViewController alloc] initWithRelativeId:_live.liveid type:HJPageTypePlay];
//    liveEndVc.feeds = _liveInfo;
//    IMP_WSELF();
//    liveEndVc.onClickCloseButtonBlock = ^{
//        [wself onClickCloseButton:wself.closeButton];
//    };
//    [self.view addSubview:liveEndVc.view];
//    liveEndVc.view.frame = self.view.bounds;
//    [self addChildViewController:liveEndVc];
//}


#pragma mark - loadMore
-(void)loadMoreLive:(BOOL)isMore{
    
    if (_refreshing == YES) {
        return;
    }
    
    if (self.feedsName == nil) {
        if (self.switchData.count > 1) {
            
        }
        return;
    }
    
    _refreshing = YES;
    
    if ([self.feedsName isEqualToString:@"home"]) {
        [[HJHomeIntf sharedIntfs] home_getNewsFeedsOffset:isMore?_STR(self.strOffset):nil Complete:^(id result) {
            
            [self handleLoadResult:result isMore:isMore];
            
        } failured:^(NSError *error) {
            _refreshing = NO;
        }];
    }else{
      BOOL isSuccess = [[HJSeedIntf sharedIntfs] feed_getFeeds:isMore?_STR(self.strOffset):nil
                                            num:(int)_defaultFeedCount
                                           name:self.feedsName?:@"live"
                                        success:^(id result){
                                            
                                            [self handleLoadResult:result isMore:isMore];
                                        }
                                        failure:^(NSError*error){
                                            //为了保证体验，此处延迟返回
                                            //                                        [wself.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
                                            _refreshing = NO;
                                        }];
        if (isSuccess == NO) {
            _refreshing = NO;
        }
        
    }
}

- (void)handleLoadResult:(id)result isMore:(BOOL)isMore
{
    if (![result isKindOfClass:[LiveFeeds class]]) {
        _refreshing = NO;
        return ;
    }
    
    if (self.switchData.count == 0) {
        _refreshing = NO;
        return;
    }
    
    LiveFeeds* resp=result;
    _totalLives = [resp.total intValue];
    _more = [resp.more charValue];
    self.strOffset = _STR(resp.offset);

    NSArray *oldFeedData = self.feedData;
    NSMutableArray *listArr = [NSMutableArray array];
    if ([resp isKindOfClass:[LiveFeeds class]]) {
        
        if (resp.feeds.count> 0) {
            for (Feeds *r0 in resp.feeds) {
                
                BOOL isContain = NO;
                for (LivingSwitchObject* switchObj in oldFeedData) {
                    if ([switchObj.liveid isEqualToString:r0.feed.relateid]) {
                        isContain = YES;
                        break;
                    }
                }
                
                if (r0.type == FeedTypeLive && isContain == NO) {
                    [listArr addObject:r0];
                }
            }
        }
    }

    
    NSInteger index = 0;
    
    NSMutableArray *temp = [NSMutableArray array];
    
    [temp addObjectsFromArray:oldFeedData];
    for (NSInteger i=index; i<[listArr count]; i++) {
        Feeds *feedData = [listArr objectAtIndex:i];
        if (feedData.type == FeedTypeLive) {
            [temp addObject:[[LivingSwitchObject alloc] initWithLiveid:feedData.feed.relateid
                                                                 andSN:feedData.feed.sn
                                                             andUserid:feedData.author.uid
                                                           andImageUrl:feedData.feed.image]];
        }
    }
    
    self.feedData = temp;
    
    _refreshing = NO;
    
    //只有热门采用新数据加载
    if ([self.feedsName isEqualToString:@"live"]) {
        
        [self loadNewLive:_moreNew];
        
    }
}



//加载新主播
-(void)loadNewLive:(BOOL)isMore{
    
    //取消loadNewLive
    return;
    
    if (self.feedsName == nil || [self.feedsName isEqualToString:@"live"] == NO) {
        return;
    }
    
    if (_refreshing == YES) {
        return;
    }
    
    NSInteger feedDataCount = self.feedData.count;
    NSInteger newdataCount = self.newerDataArray.count;
    NSInteger needCount = feedDataCount /2.0 - newdataCount;
    if (needCount > 0) {
        _defaultNewFeedCount = needCount;
    }else{
        return;
    }
    
    _refreshing = YES;
    
    //TODO：需要更改为新接口
    BOOL isSuccess = [[HJSeedIntf sharedIntfs] feed_getFeeds:isMore?_STR(self.strOffsetNew):nil
                                                         num:(int)_defaultNewFeedCount
                                                        name:@"topboy"
                                                     success:^(id result){
                                                         
                                                         [self handleNewLoadResult:result isMore:isMore];
                                                     }
                                                     failure:^(NSError*error){
                                                         //为了保证体验，此处延迟返回
                                                         //                                        [wself.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
                                                         _refreshing = NO;
                                                     }];
    if (isSuccess == NO) {
        _refreshing = NO;
        
    }
    
    
}

- (void)handleNewLoadResult:(id)result isMore:(BOOL)isMore
{
    if (![result isKindOfClass:[LiveFeeds class]]) {
        _refreshing = NO;
        return ;
    }
    
    LiveFeeds* resp=result;
    _totalNewLives = [resp.total intValue];
    _moreNew = [resp.more charValue];
    self.strOffsetNew = _STR(resp.offset);
    
    //                                            LivingSwitchObject *currentSwitchObj = self.switchData[0];
    
    NSArray *oldFeedData = self.newerDataArray;
    NSMutableArray *listArr = [NSMutableArray array];
    if ([resp isKindOfClass:[LiveFeeds class]]) {
        
        if (resp.feeds.count> 0) {
            for (Feeds *r0 in resp.feeds) {
                
                BOOL isContain = NO;
                for (LivingSwitchObject* switchObj in oldFeedData) {
                    if ([switchObj.liveid isEqualToString:r0.feed.relateid]) {
                        isContain = YES;
                        break;
                    }
                }
                
                if (r0.type == FeedTypeLive && isContain == NO) {
                    [listArr addObject:r0];
                }
            }
        }
    }
    
    
    NSInteger index = 0;
    
    NSMutableArray *temp = [NSMutableArray array];
    
    [temp addObjectsFromArray:oldFeedData];
    for (NSInteger i=index; i<[listArr count]; i++) {
        Feeds *feedData = [listArr objectAtIndex:i];
        if (feedData.type == FeedTypeLive) {
            [temp addObject:[[LivingSwitchObject alloc] initWithLiveid:feedData.feed.relateid
                                                                 andSN:feedData.feed.sn
                                                             andUserid:feedData.author.uid
                                                           andImageUrl:feedData.feed.image]];
        }
    }
    
    self.newerDataArray = temp;
    
    _refreshing = NO;
    
}

-(void)setFeedData:(NSArray<LivingSwitchObject *> *)feedData
{
    if (self.switchData == nil && self.switchData.count == 0) {
        self.switchData = [feedData mutableCopy];
    }
    _feedData = feedData;
}

@end
