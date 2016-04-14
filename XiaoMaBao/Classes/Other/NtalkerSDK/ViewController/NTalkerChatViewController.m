
//
//  UIXNChatViewController.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//
//type=1:文本消息；
//type=2:图片消息；
//type=4:文件消息；
//type=5:系统消息；subtype=2:发起页/subtype=5:商品详情/subtype=7:ERP+语言消息
//type=6:语音消息；
//

#import "NTalkerChatViewController.h"

#import "NTalkerTextLeftTableViewCell.h"//
#import "NTalkerTextRightTableViewCell.h"
#import "NTalkerVoiceLeftTableViewCell.h"
#import "NTalkerVoiceRightTableViewCell.h"
#import "NTalkerImageLeftTableViewCell.h"
#import "NTalkerImageRightTableViewCell.h"//

#import "HPGrowingTextView.h"
#import "NTalkerEmojiScrollView.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
//==========================================
#import "XNUserBasicInfo.h"
#import "XNUtilityHelper.h"
#import "NTalkerLeaveMsgViewController.h"
#import "XNSDKCore.h"
#import "XNChatLaunchPageMessage.h"
#import "XNTextMessage.h"
#import "XNImageMessage.h"
#import "XNVoiceMessage.h"
#import "XNEvaluateMessage.h"
#import "XNProductionMessage.h"
#import "XNErpMessage.h"
#import "XNEvaluateView.h"
#import "XNGoodsInfoView.h"
#import "XNGoodsInfoModel.h"
#import "XNChatBasicUserModel.h"
#import "XNChatKefuUserModel.h"

#import "XNShowBigView.h"
#import "XNEvaluateCell.h"

#import "XNShowProductWebController.h"

////设置版本号

#define kFWChangeServerChating  @"kFWChangeServerChatingNotification"
#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define margonX    6.4  //tabbar控件水平间隙宽度

//设置NavigationBar背景颜色
#define ntalker_navigationBarColor  [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]
//设置NavigationBar  Title字体颜色
#define ntalker_navigationBarTitleColor  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]

//留言提交按钮
#define leaveMesagerightItemButtonColor             [UIColor colorWithRed:13/255.0 green:94/255.0 blue:250/255.0 alpha:1.0]
//留言界面背景
#define leaveMesageBackGroundColor             [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]

//inputTextView  picLabel  cameraLabel  usefulLabel  evaluationLabel titleImage
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]
//recordButton  lineView
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
//lineView1  lineView2   lineView3
#define ntalker_lineColor                [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]
#define ntalker_viewBackGroundColor      [UIColor whiteColor]
//聊天界面背景色
//#define chatBackgroundColor              [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define chatBackgroundColor              [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define listCellContentTextSelectedColor [UIColor blueColor]
#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]

#define chatFunctionBackgroundColor      [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]

#define chatCommentTitleColor            [UIColor blackColor]
#define chatCommentCancelBtnColor        [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]
#define chatCommentOkBtnColor            [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]
#define chatCommentItemColor             [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define chatCommentItemSelectedColor     [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]
#define chatListCellLineViewColor        [UIColor colorWithRed:207/255.0 green:210/255.0 blue:213/255.0 alpha:0.7]

@interface NTalkerChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate,HPGrowingTextViewDelegate,UIXNEmojiScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,XNNotifyInterfaceDelegate,XNEvaluateDelagate,XNResendTextMsgDelegate,XNResendVoiceMsgDelegate,XNResendImageMsgDelegate,XNJumpProductDelegate,XNTapSuperLinkDeleate>
{
    //通信实例
    
    //全局参数
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
    
    //聊天主界面元素
    UILabel *titleLabel;
    UITableView *chatTableView;
    NSMutableArray *chatArray;
    UILabel *VersionLable;//显示版本号
    
    //    NSMutableArray *sendMessageArray;//放开的
    NSMutableArray *picUploadArray;//
    
    BOOL scrollToBottom;
    
    
    //输入框界面元素
    UIView *inputView;
    UIImageView *inputTextViewBg;
    HPGrowingTextView *inputTextView;
    
    UIButton *voiceButton;//语音
    UIButton *voiceButtonS;//语音选中
    UIButton *faceButton;//表情
    UIButton *faceButtonS;//表情选中
    UIButton *functionKeyButton;//其他功能
    
    UIView *functionView;//其他功能的视图
    NTalkerEmojiScrollView *emojiScrollView;//表情的视图
    
    BOOL reactionKeyboard;//zjia判断键盘时机
    BOOL keyBoardHide;
    float inputTextHeight;
    
    NSString *_alreadyText;
    NSString *_alreadyTextV;
    
    //录制语音界面元素和参数
    UIButton *recordButton;
    UIImageView *voiceRecordImageView;
    UIImageView *voiceRecordTooShort;
    
    NSTimer *recordTimer;
    NSString *_voiceMsgID;
    BOOL cancelRecord;
    BOOL voiceSendAlready;
    BOOL canRecordNow;
    float recordAudioTime;
    int startRecordButton;
    int canRemoveTipView;
    BOOL upAlready;//0601
    
    //播放语音的参数
    NSTimer *voiceTimer;
    int currentVoiceImage;
    
    NSMutableDictionary *holdingMessageIDsDic;//去重？
#pragma mark - 评价 字符串与存储数组
    NSString *remarkStr;
    NSArray *remarkArray;
    UIAlertView *tipAlertView;
    
    UIButton *evaluationButton;//评价按钮
    
    //    int ceshiTimer;
    //    UIWebView *webView;
    UIWebView *goodsWebView;
}

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, retain)AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)AVAudioRecorder *audioRecorder;
@property (nonatomic, retain)NSString *alreadyText;
@property (nonatomic, retain)NSString *alreadyTextV;
@property (nonatomic, retain)NSString *voiceMsgID;
@property (nonatomic, strong) UIView *unknowHeaderView;
//=======================================================
@property (nonatomic, strong) UILabel *promptView;

@property (nonatomic, assign) BOOL needPop;
@property (nonatomic, assign) BOOL evaluated;
@property (nonatomic, assign) BOOL couldEvaluted;
@property (nonatomic, assign) BOOL alreadyShowEvaTag;

//连接状态
@property (nonatomic, assign) NSInteger currentStatus;
@property (nonatomic, strong) NSString *currentKufuId;//当前客服


@property (nonatomic, strong) NSMutableDictionary *judgeDupDict;

@property (nonatomic, strong) XNProductionMessage *productMessage;
@property (nonatomic, strong) XNChatLaunchPageMessage *launchPageMessage;

@end

@implementation NTalkerChatViewController
@synthesize audioPlayer;
@synthesize audioRecorder;
@synthesize voiceMsgID=_voiceMsgID;
@synthesize alreadyText=_alreadyText;
@synthesize alreadyTextV=_alreadyTextV;

- (id)init{
    if (self=[super init]) {
        
        self.settingid = @"";
        
        self.pushOrPresent=YES;
        
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        ceshiTimer=0;
        
        
        autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY=kFWFullScreenHeight>680?kFWFullScreenHeight/568:1.0;
        
        scrollToBottom = YES;
        upAlready=YES;
        
        chatArray = [[NSMutableArray alloc] init];
        //      sendMessageArray = [[NSMutableArray alloc] init];//放开的
        picUploadArray = [[NSMutableArray alloc] init];//放开的
        
        iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        inputTextHeight = 34;//
        
        holdingMessageIDsDic=[[NSMutableDictionary alloc] init];
        reactionKeyboard=NO;//zjia
        canRecordNow=YES;
        startRecordButton=0;
        canRemoveTipView=0;
    }
    return self;
}

- (void)configureBackButton
{
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_back_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chatEnterBackground)];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

- (void)chatEnterBackground
{
    [[XNSDKCore sharedInstance] chatIntoBackGround:_settingid];
    [self backFoward];
}

- (void)configureCancelButton
{
    UIBarButtonItem *closeBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_close_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelChat)];
    self.navigationItem.rightBarButtonItem = closeBtnItem;
}

- (void)cancelChat
{
    if (_couldEvaluted && _currentStatus ==9) {
        if ([inputTextView isFirstResponder]) {
            [inputTextView resignFirstResponder];
        }
        [XNEvaluateView addEvaluateViewWithFrame:CGRectMake(10, 75, kFWFullScreenWidth - 20, kFWFullScreenHeight - 130) delegate:self];
        
        _needPop = YES;
    } else {
        [self endChat];
    }
}

- (void)configureGoodsInfo
{
    if ([_productInfo.appGoods_type isEqualToString:@"0"] ||
        !_productInfo.appGoods_type.length) {
        return;
    }
    
    if (!_productInfo.goods_imageURL.length &&
        !_productInfo.goodsPrice.length &&
        !_productInfo.goodsTitle.length &&
        !_productInfo.goods_id.length &&
        !_productInfo.goods_showURL.length) {
        return;
    }
    
    XNGoodsInfoView * goodsInfoView = [[XNGoodsInfoView alloc] initWithFrame:CGRectMake(3, 64, CGRectGetWidth(self.view.frame) - 6, 90) andGoodsInfoModel:_productInfo andDelegate:self];
    goodsInfoView.tag = 9090;
    if ([_productInfo.appGoods_type isEqualToString:@"3"]) {
        goodsInfoView.backgroundColor = [UIColor whiteColor];
    } else {
        goodsInfoView.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:goodsInfoView];
    //    chatTableView.contentSize = CGSizeMake(CGRectGetWidth(chatTableView.frame), CGRectGetHeight(chatTableView.frame) - CGRectGetHeight(goodsInfoView.frame));
}

- (void)productInfoShowFailed
{
    UIView *goodsView = [self.view viewWithTag:9090];
    chatTableView.tableHeaderView = goodsView;
    [chatTableView reloadData];
}

- (void)productInfoSuccess
{
    UIView *goodsView = [self.view viewWithTag:9090];
    if (goodsView) {
        goodsView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)jumpByProductURL
{
    if (_productInfo.goods_URL.length) {
        XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
        ctrl.productURL = _productInfo.goods_URL;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
#pragma mark ----- 字符串 访问 ok
    //    NSLog(@"33545___%@",self.str);
    
    //初始化全局基本变量
    [self initData];
    //
    
    self.title = @"在线客服";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self configureBackButton];
    [self configureCancelButton];
//    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
//    self.navigationController.navigationBar.alpha = 1.0;
    [self initBasicInfo];
    
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, kFWFullScreenHeight-49) style:UITableViewStylePlain];
    [chatTableView setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
    chatTableView.delegate = self;
    
    chatTableView.dataSource = self;
    [chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:chatTableView];
    //
    
    [self initInputBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinishedAndNoSend:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self configureGoodsInfo];
    [self setPromptView];
    
    [XNSDKCore sharedInstance].delegate = self;
    [[XNSDKCore sharedInstance] startChatWithSessionid:_settingid kefuId:_kefuId isSingle:_isSingle];
    
    [self initUIWithFMDB];
}

- (void)setPromptView
{
    self.promptView = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kFWFullScreenWidth, 30)];
    self.promptView.backgroundColor = [self colorWithHexString:@"fff6ca"];
    self.promptView.text = @"正在连接客服";
    self.promptView.textAlignment = NSTextAlignmentCenter;
    self.promptView.textColor = [self colorWithHexString:@"666666"];
    [self.view addSubview:_promptView];
}

- (void)initInputBar{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppearance:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    inputView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight-49, kFWFullScreenWidth,49)];
    [inputView setUserInteractionEnabled:YES];
    [inputView setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
    [self.view addSubview:inputView];
    
    UIView *inputlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, 0.5)];
    [inputlineView setBackgroundColor:ntalker_textColor2];
    [inputView addSubview:inputlineView];
    
    //    CGFloat margonX =(kFWFullScreenWidth-84-204*autoSizeScaleX)/5;//水平间隙宽度
    //语音按钮
    voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(margonX, 11, 28, 28)];
    voiceButton.hidden=NO;
    [voiceButton addTarget:self action:@selector(voiceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_voice_btn.png"] forState:UIControlStateNormal];
    [inputView addSubview:voiceButton];
    
    voiceButtonS = [[UIButton alloc] initWithFrame:CGRectMake(margonX, 11, 28, 28)];
    voiceButtonS.hidden=YES;
    [voiceButtonS addTarget:self action:@selector(voiceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButtonS setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_keyboard_btn.png"] forState:UIControlStateNormal];
    [inputView addSubview:voiceButtonS];
    
    voiceRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kFWFullScreenWidth-151*autoSizeScaleX)/2,(kFWFullScreenHeight-151*autoSizeScaleX-49)/2, 151*autoSizeScaleX, 151*autoSizeScaleX)];
    voiceRecordTooShort = [[UIImageView alloc] initWithFrame:CGRectMake((kFWFullScreenWidth-151*autoSizeScaleX)/2,(kFWFullScreenHeight-151*autoSizeScaleX-49)/2, 151*autoSizeScaleX, 151*autoSizeScaleX)];
    [voiceRecordTooShort setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_tooShort.png"]];
    //文本输入框背景
    CGFloat inputTextViewW = kFWFullScreenWidth-116;
    inputTextViewBg=[[UIImageView alloc] initWithFrame:CGRectMake((28+2*margonX), 7, inputTextViewW , 36)];
    UIImage *stretchImage = [[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_btn.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:16];
    UIImage *stretchSelectedImage = [[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_btn_selected.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:16];
    [inputTextViewBg setImage:stretchImage];
    [inputView addSubview:inputTextViewBg];
    //文本输入框
    inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake((28+2*margonX), 7, inputTextViewW  ,36)];
    [inputTextView setBackgroundColor:[UIColor clearColor]];
    inputTextView.delegate = self;
    [inputTextView setReturnKeyType:UIReturnKeySend];
    inputTextView.enablesReturnKeyAutomatically = YES;
    inputTextView.minNumberOfLines = 1;
    inputTextView.maxNumberOfLines = 3;
    if (iphone6P) {
        inputTextView.font = [UIFont systemFontOfSize:19];
    } else if (iphone6){
        inputTextView.font = [UIFont systemFontOfSize:17];
    } else {
        inputTextView.font = [UIFont systemFontOfSize:15];
    }
    [inputTextView setTextColor:ntalker_textColor];
    [inputView addSubview:inputTextView];
    //按住说话
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake((28+2*margonX), 7, inputTextViewW ,36)];
    recordButton.hidden=YES;
    [recordButton setBackgroundImage:stretchImage forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchSelectedImage forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(recordStarting:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordWillGoOnAndSend:) forControlEvents:UIControlEventTouchDragEnter];
    [recordButton addTarget:self action:@selector(recordWillFinishedAndNoSend:) forControlEvents:UIControlEventTouchDragExit];
    [recordButton addTarget:self action:@selector(recordFinishedAndSend:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordFinishedAndNoSend:) forControlEvents:UIControlEventTouchUpOutside];
    //    [recordButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchCancel];
    
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [recordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [recordButton setTitleColor:ntalker_textColor2 forState:UIControlStateNormal];
    [recordButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    recordButton.exclusiveTouch=YES;
    [inputView addSubview:recordButton];
    
    faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inputTextView.frame)+margonX, 11, 28, 28)];
    
    faceButton.hidden=NO;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_face_btn.png"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(faceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:faceButton];
    
    faceButtonS = [[UIButton alloc] initWithFrame:CGRectMake(faceButton.frame.origin.x, 11, 28, 28)];
    faceButtonS.hidden=YES;
    [faceButtonS setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_keyboard_btn.png"] forState:UIControlStateNormal];
    [faceButtonS addTarget:self action:@selector(faceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:faceButtonS];
    //加号按钮
    functionKeyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(faceButton.frame)+margonX, 11, 28, 28)];
    functionKeyButton.hidden=NO;
    [functionKeyButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_more_btn.png"] forState:UIControlStateNormal];
    [functionKeyButton addTarget:self action:@selector(functionKey:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:functionKeyButton];
    
    //    functionKeyButtonS = [[UIButton alloc] initWithFrame:CGRectMake(286, 10.5, 28, 28)];
    //    functionKeyButtonS.hidden=YES;
    //    [functionKeyButtonS setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_keyboard_btn.png"] forState:UIControlStateNormal];
    //    [functionKeyButtonS addTarget:self action:@selector(functionKey:) forControlEvents:UIControlEventTouchUpInside];
    //    [inputView addSubview:functionKeyButtonS];
    
    emojiScrollView = [[NTalkerEmojiScrollView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight, kFWFullScreenWidth, 216*autoSizeScaleY)];
    emojiScrollView.emojiDelegate=self;
    emojiScrollView.backgroundColor = [self colorWithHexString:@"f3f3f7"];
    [self.view addSubview:emojiScrollView];
    
    NSArray *arr = @[
                     @{@"bgImage":@"ntalker_pic_btn.png",
                       @"hBgImage":@"ntalker_pic_btn_selected.png",
                       @"SEL":@"picFunction:",
                       @"title":@"图片"},
                     
                     @{@"bgImage":@"ntalker_camera_btn.png",
                       @"hBgImage":@"ntalker_camera_btn_selected.png",
                       @"SEL":@"cameraFunction:",
                       @"title":@"相机"},
                     
                     @{@"bgImage":@"ntalker_value_btn.png",
                       @"hBgImage":@"ntalker_value_btn_selected.png",
                       @"SEL":@"evaluationFunction:",
                       @"title":@"评价"}
                     ];
    
    functionView = [[UIView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight, kFWFullScreenWidth, (140.0/736.0)*kFWFullScreenHeight)];
    functionView.backgroundColor = [self colorWithHexString:@"f3f3f7"];
    [self.view addSubview:functionView];
    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        UIButton *picButton = [[UIButton alloc] initWithFrame:CGRectMake(34 + ((140.0/414.0)*kFWFullScreenWidth)*i, ((20.0/736.0) * kFWFullScreenHeight)*(i/3 + 1), (70.0/414.0)*kFWFullScreenWidth, (70.0/414.0)*kFWFullScreenWidth)];
        
        [picButton setImage:[UIImage imageNamed:[@"NTalkerUIKitResource.bundle" stringByAppendingPathComponent:dict[@"bgImage"]]] forState:UIControlStateNormal];
        [picButton setImage:[UIImage imageNamed:[@"NTalkerUIKitResource.bundle" stringByAppendingPathComponent:dict[@"hBgImage"]]] forState:UIControlStateHighlighted];
        [picButton addTarget:self action:NSSelectorFromString(dict[@"SEL"]) forControlEvents:UIControlEventTouchUpInside];
        [functionView addSubview:picButton];
        
        UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(picButton.frame), CGRectGetMaxY(picButton.frame) + 7, CGRectGetWidth(picButton.frame), 14*autoSizeScaleY)];
        [cameraLabel setBackgroundColor:[UIColor clearColor]];
        [cameraLabel setTextAlignment:NSTextAlignmentCenter];
        [cameraLabel setFont:[UIFont systemFontOfSize:(13.0/414.0)*kFWFullScreenWidth]];
        [cameraLabel setTextColor:[self colorWithHexString:@"666666"]];
        cameraLabel.text=dict[@"title"];
        [functionView addSubview:cameraLabel];
        
        if (i == 2) {
            picButton.tag = 1090;
            picButton.enabled = NO;
            cameraLabel.tag = 1091;
        }
    }
    
    //加号视图
    //    functionView = [[UIView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight, kFWFullScreenWidth, 216*autoSizeScaleY)];
    //    [functionView setBackgroundColor:chatFunctionBackgroundColor];
    //    [self.view addSubview:functionView];
    //    //横线1
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, 0.5)];
    [lineView setBackgroundColor:ntalker_textColor2];
    [functionView addSubview:lineView];
}

/**
 *  加载URL
 *
 *  @param urlString      传入的URL
 *
 *  @return 无
 */
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    //    NSLog(@"213132___%@",urlString);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [goodsWebView loadRequest:request];
}


- (void)tapGestureFunction:(id)sender {
    if (keyBoardHide) {
        if (functionKeyButton.selected || faceButton.hidden) {
            [chatTableView reloadData];
            functionKeyButton.selected=NO;
            faceButton.hidden=NO;
            faceButtonS.hidden=YES;
            __block CGRect inputViewFrame=inputView.frame;
            CGPoint offset=[chatTableView contentOffset];
            CGRect tableFrame =  chatTableView.frame;
            float height = tableFrame.size.height;
            tableFrame.size.height = kFWFullScreenHeight-inputViewFrame.size.height;
            chatTableView.frame = tableFrame;
            chatTableView.contentOffset = offset;
            
            [UIView animateWithDuration:0.25 animations:^{
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(tableFrame.size.height-height)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(tableFrame.size.height-height));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
                
                CGRect emojiViewFrame = emojiScrollView.frame;
                emojiViewFrame.origin.y = kFWFullScreenHeight;
                emojiScrollView.frame = emojiViewFrame;
                
                CGRect functionViewFrame = functionView.frame;
                functionViewFrame.origin.y = kFWFullScreenHeight;
                functionView.frame=functionViewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
    } else if([inputTextView isFirstResponder]){
        [chatTableView reloadData];
        [inputTextView resignFirstResponder];
    }
    //消除复制按钮
    NSArray *cellArr = [chatTableView visibleCells];
    for (UIView *view in cellArr) {
        if ([view isKindOfClass:[NTalkerTextLeftTableViewCell class]]) {
            NTalkerTextLeftTableViewCell *leftTextCell = (NTalkerTextLeftTableViewCell *)view;
            if (!leftTextCell.publicButton.hidden) {
                [leftTextCell.publicButton removeFromSuperview];
            }
        } else if ([view isKindOfClass:[NTalkerTextRightTableViewCell class]]) {
            NTalkerTextRightTableViewCell *rightTextCell = (NTalkerTextRightTableViewCell *)view;
            if (!rightTextCell.publicButton.hidden) {
                [rightTextCell.publicButton removeFromSuperview];
            }
        }
    }
}

- (void)keyboardWillAppearance:(NSNotification *)notification{
    
    keyBoardHide = NO;
    if (faceButton.hidden) {
        faceButton.hidden=NO;
        faceButtonS.hidden=YES;
    } else if (functionKeyButton.selected){
        functionKeyButton.selected=NO;
    }
    
    CGRect keyboardBounds;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    float keyboardHeight = keyboardBounds.size.height;
    int goUp=0;
    __block CGRect tableFrame = chatTableView.frame;
    __block CGRect inputViewFrame = inputView.frame;
    CGPoint offset = chatTableView.contentOffset;
    float height=tableFrame.size.height;
    float aheight=kFWFullScreenHeight-keyboardHeight-inputViewFrame.size.height;
    if (height<aheight) {
        goUp=0;
    } else if(height>aheight){
        goUp = 1;
    } else{
        goUp = 2;
    }
    
    if (0==goUp) {
        tableFrame.size.height = aheight;
        chatTableView.frame=tableFrame;
        [chatTableView setContentOffset:offset];
    }
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        if (0==goUp) {
            inputViewFrame.origin.y = kFWFullScreenHeight-keyboardHeight-inputViewFrame.size.height;
            inputView.frame = inputViewFrame;
            
            if (offset.y-(aheight-height)>=0) {
                chatTableView.contentOffset=CGPointMake(0, offset.y-(aheight-height));
            } else {
                chatTableView.contentOffset=CGPointMake(0, 0);
            }
        } else if (1==goUp) {
            inputViewFrame.origin.y = kFWFullScreenHeight-keyboardHeight-inputViewFrame.size.height;
            inputView.frame = inputViewFrame;
            
            CGSize contentSize = chatTableView.contentSize;
            if (contentSize.height<=0) {
                
            } else if (offset.y+height<=contentSize.height) {
                chatTableView.contentOffset=CGPointMake(0, offset.y+height-aheight);
            } else if (contentSize.height>=aheight){
                chatTableView.contentOffset=CGPointMake(0, contentSize.height-aheight);
            } else {
                
            }
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                CGRect tableFrame =  chatTableView.frame;
                tableFrame.size.height = aheight;
                chatTableView.frame = tableFrame;
            }
        } else {
            
        }
        
        CGRect emojiViewFrame = emojiScrollView.frame;
        emojiViewFrame.origin.y = kFWFullScreenHeight;
        emojiScrollView.frame = emojiViewFrame;
        
        CGRect functionViewFrame = functionView.frame;
        functionViewFrame.origin.y = kFWFullScreenHeight;
        functionView.frame=functionViewFrame;
    } completion:^(BOOL finished) {
        if (1==goUp) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                CGRect tableFrame =  chatTableView.frame;
                tableFrame.size.height = aheight;
                chatTableView.frame = tableFrame;
            }
        }
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    if (!keyBoardHide) {
        __block CGRect inputViewFrame=inputView.frame;
        CGPoint offset=[chatTableView contentOffset];
        CGRect tableFrame =  chatTableView.frame;
        float height = tableFrame.size.height;
        tableFrame.size.height = kFWFullScreenHeight-inputViewFrame.size.height;
        chatTableView.frame = tableFrame;
        chatTableView.contentOffset = offset;
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height;
            inputView.frame = inputViewFrame;
            
            if (offset.y-(tableFrame.size.height-height)>=0) {
                chatTableView.contentOffset=CGPointMake(0, offset.y-(tableFrame.size.height-height));
            } else {
                chatTableView.contentOffset=CGPointMake(0, 0);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)faceButtonFunction:(UIButton *)sender{
    
    if (_currentStatus != 9) {
        if (_promptView) {
            [self addSimpleAlertView:_promptView.text];
        } else {
            [self addSimpleAlertView:@"正在请求客服"];
        }
        return;
    }
    
    if (voiceButton.hidden) {
        voiceButton.hidden = NO;
        voiceButtonS.hidden = YES;
        recordButton.hidden=YES;
        
        //        inputTextView.hidden=NO;//展开
        //        inputTextViewBg.hidden = NO;//展开
        
        if (self.alreadyTextV!=nil && ![self.alreadyTextV isEqualToString:@""]) {
            inputTextView.text = self.alreadyTextV;
            self.alreadyTextV=@"";
        }
    } else if (functionKeyButton.selected) {
        functionKeyButton.selected=NO;
    }
    if (sender == faceButton) {
        faceButton.hidden=YES;
        faceButtonS.hidden=NO;
        keyBoardHide = YES;
        [inputTextView resignFirstResponder];
        int goUp=0;
        __block CGRect inputViewFrame=inputView.frame;
        __block CGRect tableFrame = chatTableView.frame;
        float bHeight = tableFrame.size.height;
        float aHeight = kFWFullScreenHeight-inputViewFrame.size.height-emojiScrollView.frame.size.height;
        if (bHeight<aHeight) {
            goUp=0;
        } else if(bHeight>aHeight){
            goUp = 1;
        } else{
            goUp = 2;
        }
        if (0==goUp) {
            CGPoint offset = [chatTableView contentOffset];
            tableFrame.size.height = aHeight;
            chatTableView.frame=tableFrame;
            [chatTableView setContentOffset:offset];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint offset = chatTableView.contentOffset;
            
            CGRect emojiViewFrame = emojiScrollView.frame;
            
            if (0==goUp) {
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-emojiViewFrame.size.height;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(aHeight-bHeight)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(aHeight-bHeight));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
            } else if(1==goUp){
                
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-emojiViewFrame.size.height;
                inputView.frame = inputViewFrame;
                
                CGSize contentSize = chatTableView.contentSize;
                
                if (contentSize.height<=0) {
                    
                } else if (offset.y+bHeight<=contentSize.height) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y+bHeight-aHeight);
                } else if (contentSize.height>=aHeight){
                    chatTableView.contentOffset=CGPointMake(0, contentSize.height-aHeight);
                } else {
                    
                }
            }
            
            emojiViewFrame.origin.y = kFWFullScreenHeight-emojiViewFrame.size.height;
            emojiScrollView.frame = emojiViewFrame;
            
            CGRect functionViewFrame = functionView.frame;
            functionViewFrame.origin.y = kFWFullScreenHeight;
            functionView.frame=functionViewFrame;
        } completion:^(BOOL finished) {
            if (1==goUp) {
                tableFrame.size.height = aHeight;
                chatTableView.frame=tableFrame;
            }
        }];
    } else {
        faceButtonS.hidden=YES;
        faceButton.hidden = NO;
        [inputTextView becomeFirstResponder];
    }
}
- (void)functionKey:(UIButton *)sender{
    
    if (_currentStatus != 9) {
        if (_promptView) {
            [self addSimpleAlertView:_promptView.text];
        } else {
            [self addSimpleAlertView:@"正在请求客服"];
        }
        return;
    }
    
    if (voiceButton.hidden) {
        voiceButton.hidden = NO;
        voiceButtonS.hidden=YES;
        recordButton.hidden=YES;
        if (self.alreadyTextV!=nil && ![self.alreadyTextV isEqualToString:@""]) {
            inputTextView.text = self.alreadyTextV;
            self.alreadyTextV=@"";
        }
    } else if (faceButton.hidden) {
        faceButton.hidden = NO;
        faceButtonS.hidden=YES;
    }
    functionKeyButton.selected=!functionKeyButton.selected;
    if (functionKeyButton.selected) {
        keyBoardHide = YES;
        [inputTextView resignFirstResponder];
        int goUp=0;
        CGRect inputViewFrame=inputView.frame;
        __block CGRect tableFrame = chatTableView.frame;
        float bHeight = tableFrame.size.height;
        float aHeight =  kFWFullScreenHeight-inputViewFrame.size.height-functionView.frame.size.height;
        if (bHeight<aHeight) {
            goUp = 0;
        } else if(bHeight>aHeight){
            goUp = 1;
        } else{
            goUp = 2;
        }
        if (0==goUp) {
            CGPoint offset = [chatTableView contentOffset];
            tableFrame.size.height = aHeight;
            chatTableView.frame=tableFrame;
            [chatTableView setContentOffset:offset];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint offset = chatTableView.contentOffset;
            
            CGRect emojiViewFrame = emojiScrollView.frame;
            
            if (0==goUp) {
                CGRect inputViewFrame = inputView.frame;
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-functionView.frame.size.height;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(aHeight-bHeight)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(aHeight-bHeight));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
            } else if(1==goUp){
                CGRect inputViewFrame = inputView.frame;
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-functionView.frame.size.height;
                inputView.frame = inputViewFrame;
                
                CGSize contentSize = chatTableView.contentSize;
                if (contentSize.height<=0) {
                    
                } else if (offset.y+bHeight<=contentSize.height) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y+bHeight-aHeight);
                } else if (contentSize.height>=aHeight){
                    chatTableView.contentOffset=CGPointMake(0, contentSize.height-aHeight);
                } else {
                    
                }
            }
            emojiViewFrame.origin.y = kFWFullScreenHeight;
            emojiScrollView.frame = emojiViewFrame;
            
            CGRect functionViewFrame = functionView.frame;
            functionViewFrame.origin.y = kFWFullScreenHeight-functionViewFrame.size.height;
            functionView.frame=functionViewFrame;
        } completion:^(BOOL finished) {
            if (goUp==1) {
                tableFrame.size.height = aHeight;
                chatTableView.frame=tableFrame;
            }
        }];
    } else {
        [inputTextView becomeFirstResponder];
    }
}
- (void)picFunction:(UIButton *)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picture = [[UIImagePickerController alloc] init];
        picture.delegate = self;
        picture.allowsEditing=NO;//YES->NO
        picture.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picture animated:YES completion:^{
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"设备不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}
- (void)cameraFunction:(UIButton *)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提　示"
                                                            message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:camera animated:YES completion:^{
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"设备不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)evaluationFunction:(UIButton *)sender{
    
    [XNEvaluateView addEvaluateViewWithFrame:CGRectMake(10, 75, kFWFullScreenWidth - 20, kFWFullScreenHeight - 130) delegate:self];
}

- (void)voiceButtonFunction:(UIButton *)sender {
    
    if (_currentStatus != 9) {
        if (_promptView) {
            [self addSimpleAlertView:_promptView.text];
        } else {
            [self addSimpleAlertView:@"正在请求客服"];
        }
        return;
    }
    
    if (sender == voiceButton) {
        //语音
        voiceButton.hidden = YES;
        voiceButtonS.hidden = NO;
        if (![inputTextView.text isEqualToString:@""] && inputTextView.text!=nil) {
            self.alreadyTextV = inputTextView.text;
            inputTextView.text=@"";
        }
        if (inputTextView.isFirstResponder) {
            [chatTableView reloadData];
            keyBoardHide = NO;
            [inputTextView resignFirstResponder];
        } else if (faceButton.hidden || functionKeyButton.selected){
            [chatTableView reloadData];
            faceButton.hidden=NO;
            faceButtonS.hidden=YES;
            functionKeyButton.selected=NO;
            
            CGRect tableFrame = chatTableView.frame;
            float bHeight = tableFrame.size.height;
            float aHeight = kFWFullScreenHeight-49;
            CGPoint offset = [chatTableView contentOffset];
            tableFrame.size.height = aHeight;
            chatTableView.frame=tableFrame;
            [chatTableView setContentOffset:offset];
            [UIView animateWithDuration:0.25 animations:^{
                CGRect inputViewFrame=inputView.frame;
                inputViewFrame.origin.y = kFWFullScreenHeight-49;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(aHeight-bHeight)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(aHeight-bHeight));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
                CGRect emojiViewFrame = emojiScrollView.frame;
                emojiViewFrame.origin.y = kFWFullScreenHeight;
                emojiScrollView.frame = emojiViewFrame;
                
                CGRect functionViewFrame = functionView.frame;
                functionViewFrame.origin.y = kFWFullScreenHeight;
                functionView.frame=functionViewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        recordButton.hidden=NO;
    } else {
        //键盘
        voiceButtonS.hidden=YES;
        voiceButton.hidden = NO;
        if (self.alreadyTextV!=nil && ![self.alreadyTextV isEqualToString:@""]) {
            inputTextView.text = self.alreadyTextV;
            self.alreadyTextV = @"";
        }
        [inputTextView becomeFirstResponder];
        recordButton.hidden=YES;
    }
}


//数据源方法
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return 30;
    return chatArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //<----------------------提取全局变量－调用数据库查询方法-------------------------------------->
    //提取全局变量
    //提取全局变量
    //    NTalkrChatMessage *chatObject = [[NTalkerChatMessage alloc] init];
    
    
    //<-----------------以下内容没改------------------------>
    if (indexPath.row <chatArray.count) {
        
        XNBaseMessage *chatObject = [chatArray objectAtIndex:indexPath.row];//
        BOOL hide=NO;
        
        if (indexPath.row>0) {
            XNBaseMessage *lastChat = [chatArray objectAtIndex:indexPath.row-1];
            long long cha = chatObject.msgtime - lastChat.msgtime;
            if (cha<120000) {
                hide=YES;
            }
        }
        
        if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
            if (MSG_TYPE_TEXT==chatObject.msgType) {
                //文本
                
                static NSString *leftTextCellIndentifier = @"leftTextCellIndentifierSelf";
                
                NTalkerTextLeftTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:leftTextCellIndentifier];
                
                if (!cell) {
                    
                    cell = [[ NTalkerTextLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftTextCellIndentifier];
                    
                    cell.delegate = self;
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                }
                
                [cell setChatTextMessageInfo:chatObject hidden:hide];
                
                return cell;
            }
            else if (MSG_TYPE_PICTURE == chatObject.msgType)
            {
                
                static NSString *leftImageCellIndentifier = @"leftImageCellIndentifierSelf";
                
                NTalkerImageLeftTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:leftImageCellIndentifier];
                
                if (!cell) {
                    
                    cell = [[ NTalkerImageLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftImageCellIndentifier];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                }
                
                cell.contentBtn.tag = indexPath.row;
                
                [cell.contentBtn addTarget:self action:@selector(viewBigPicture:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell setChatImageMessageInfo:chatObject hidden:hide];
                
                return cell;
                
            }
            else if (chatObject.msgType == MSG_TYPE_VOICE)
            {
                {
                    
                    static NSString *leftVoiceCellIndentifier = @"leftVoiceCellIndentifierSelf";
                    
                    
                    NTalkerVoiceLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftVoiceCellIndentifier];
                    
                    if (!cell) {
                        
                        cell = [[NTalkerVoiceLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftVoiceCellIndentifier];
                        
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
                        [cell setBackgroundColor:[UIColor clearColor]];
                        
                    }
                    
                    [cell setChatVoiceMessageCell:chatObject hidden:hide];
                    
                    cell.tapControl.tag = indexPath.row;
                    
                    [cell.tapControl addTarget:self action:@selector(turnOnVoice:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //                                [cell.tapControl addTarget:self action:@selector(tapControlHightlighted:) forControlEvents:UIControlEventTouchDown];
                    
                    return cell;
                    
                }
            }
        } else {
            if (MSG_TYPE_TEXT==chatObject.msgType) {
                static NSString*rightTextCellIndentifier = @"rightTextCellIndentifierSelf";
                NTalkerTextRightTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:rightTextCellIndentifier];
                if (!cell) {
                    cell = [[ NTalkerTextRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightTextCellIndentifier];
                    cell.delegate = self;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                }
                
                [cell setChatTextMessageInfo:chatObject hidden:hide];
                
                return cell;
            }
            else if (MSG_TYPE_PICTURE == chatObject.msgType)
            {
                static NSString*rightImageCellIndentifier = @"rightImageCellIndentifierSelf";
                NTalkerImageRightTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:rightImageCellIndentifier];
                if (!cell) {
                    cell = [[ NTalkerImageRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightImageCellIndentifier];
                    cell.delegate = self;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
                cell.contentBtn.tag = indexPath.row;
                [cell.contentBtn addTarget:self action:@selector(viewBigPicture:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell setChatImageMessageInfo:chatObject hidden:hide];
                
                return cell;
                
            }
            else if (chatObject.msgType == MSG_TYPE_VOICE)
            {
                {
                    //语音消息
                    static NSString *rightVoiceCellIndentifier = @"rightVoiceCellIndentifierSelf";
                    
                    NTalkerVoiceRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightVoiceCellIndentifier];
                    if (!cell) {
                        cell = [[NTalkerVoiceRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightVoiceCellIndentifier];
                        cell.delegate = self;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell setBackgroundColor:[UIColor clearColor]];
                    }
                    [cell setChatVoiceMessageCell:chatObject hidden:hide];
                    cell.tapControl.tag = indexPath.row;
                    [cell.tapControl addTarget:self action:@selector(turnOnVoice:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    //                [cell.tapControl addTarget:self action:@selector(tapControlHightlighted:) forControlEvents:UIControlEventTouchDown];
                    return cell;
                }
            }
            else if (chatObject.msgType == MSG_TYPE_SYSTEM_EVALUATE)
            {
                static NSString *evaluateCellIndentifier = @"XNEvaluateCell";
                XNEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluateCellIndentifier];
                if (!cell) {
                    cell = [[XNEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateCellIndentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell configureAnything:chatObject];
                return cell;
            }
        }
    } else {
        static NSString *chatingIdentifier = @"NtalkerChatingIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatingIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatingIdentifier];
            [cell setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }
    return nil;
}

//图片变大//hjia
- (void)viewBigPicture:(UIButton *)sender{
    //    NSLog(@"点击了图片来放大 -----  %ld",(long)sender.tag);
    if([inputTextView isFirstResponder]){
        [inputTextView resignFirstResponder];
    }
    [self stopPlayVoiceImage];
    [self stopRecordVoiceMsg];
    XNImageMessage *chatObject = [chatArray objectAtIndex:sender.tag];
    //    chatObject.messageBody=imageObject ;//
    UIImageView *contImageView =[[UIImageView alloc] init];
    NSString *path=@"";
    // 得到documents目录下fileName文件的路径
    path = [XNUtilityHelper getConfigFile:[NSString stringWithFormat:@"%@.jpg",chatObject.msgid]];
    
    //    NSLog(@"打印图片地址-0000000kuaikuaikuai----:%@",path);
    //
    //    NSLog(@"打印图片地址0000000kuaikuaikuai----:%@",imageObject.img_sourcepath);//
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        //  path = chatObject.content;
        //  path=imageObject.img_oldfile;//文件存储路径？
        //  转换&amp;
        path =[chatObject.pictureSource stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        //  path =imageObject.img_path;
        
        //        NSLog(@"打印图片地址1111kuaikuaikuai----:%@",path);//
    }
    
    //用户发来信息
    CGFloat y = 0.0;
    if ([chatObject.userid rangeOfString:self.userId].location !=NSNotFound) {
        //        NSLog(@"右-------");
        //右边图片
        NTalkerImageRightTableViewCell*ImageCell = (NTalkerImageRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        contImageView = ImageCell.contentImage;
        CGRect frame1 = [self.view convertRect:ImageCell.frame fromView:chatTableView];
        y = frame1.origin.y;
        CGRect frame = CGRectMake(contImageView.frame.origin.x, contImageView.frame.origin.y + y - 44 - 20, contImageView.frame.size.width, contImageView.frame.size.height);
        [XNShowBigView showBigWithFrames:frame andCtrl:0 andImageList:[NSArray arrayWithObjects:path, nil] andClickedIndex:0 andOffsetBlock:nil];
    }
    //客户发来信息
    else{
        //左图片
        //        NSLog(@"左------");
        NTalkerImageLeftTableViewCell *ImageCell = (NTalkerImageLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        contImageView = ImageCell.contentImage;
        //0527gai
        path =[chatObject.pictureSource stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        CGRect frame1 = [self.view convertRect:ImageCell.frame fromView:chatTableView];
        y = frame1.origin.y;
        CGRect frame = CGRectMake(contImageView.frame.origin.x, contImageView.frame.origin.y + y - 44 - 20, contImageView.frame.size.width, contImageView.frame.size.height);
        [XNShowBigView showBigWithFrames:frame andCtrl:0 andImageList:[NSArray arrayWithObjects:path, nil] andClickedIndex:0 andOffsetBlock:nil];
        
        //  path =imageObject.img_path;
        //        NSLog(@"打印图片地址左左1111kuaikuaikuai----:%@",path);//
    }
    
}

#pragma mark - UITableViewDelegate

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<chatArray.count) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
        
    } else {
        if (iphone6P) {
            return 20;
        } else if(iphone6){
            return 17;
        } else {
            return 15;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//播放语音消息//zjia
- (void)turnOnVoice:(UIControl *)sender{
    
    XNBaseMessage *chatObject = [chatArray objectAtIndex:sender.tag];
    //客服发来语音
    if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
        //客服
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        UIImage *contentBgImageSelected =[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left_selected.png"];
        [voiceCell.tapControl setBackgroundImage:[contentBgImageSelected stretchableImageWithLeftCapWidth:20 topCapHeight:33] forState:UIControlStateNormal];
        
        
        
        //用户发来语音
    }else{
        
    }
    
    [self performSelector:@selector(stopSelectedImage:) withObject:[NSNumber numberWithInteger:sender.tag] afterDelay:0.5];
    NSInteger row = [self stopPlayVoiceImage];
    if (sender.tag != row){
        //开始播放新的语音
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        XNVoiceMessage *chatObject = [chatArray objectAtIndex:sender.tag];//zjia
        //        NTalkerVoiceChatMessage*voiceObject =chatObject.messageBody;//zjia
        
        NSString *path = [XNUtilityHelper getConfigFile:[NSString stringWithFormat:@"%@.wav",chatObject.msgid]];
        NSFileManager *FileManager = [NSFileManager defaultManager];
        if ([FileManager fileExistsAtPath:path]) {
            NSError *error;
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:&error];
            if (error) {
                //                                [OMGToast showWithText:@"音频文件播放失败" topOffset:kTipTopOffset duration:1.5];
            } else {
                player.numberOfLoops = 0;
                [player setVolume:1.0];
                self.audioPlayer = player;
                [self.audioPlayer setDelegate:self];
                [self.audioPlayer play];
                [self beginPlayVoice:sender.tag];
            }
        } else {
            if (![chatObject.mp3URL isEqualToString:@""] && chatObject.mp3URL !=nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    NSData *voiceData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[chatObject.mp3URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:NSDataReadingUncached error:&error];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (!error) {
                            NSError *playError;
                            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:voiceData error:&playError];
                            if (!playError) {
                                player.numberOfLoops = 0;
                                [player setVolume:1.0];
                                self.audioPlayer = player;
                                [self.audioPlayer setDelegate:self];
                                [self.audioPlayer play];
                                [self beginPlayVoice:sender.tag];
                            }
                        }
                    });
                });
            }
        }
    }else{
        
    }
}
//结束选中背景图片 //zjia
- (void)stopSelectedImage:(id)tag{
    XNBaseMessage *chatObject = [chatArray objectAtIndex:[tag integerValue]];
    
    //客服发来信息
    if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
        
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[tag integerValue] inSection:0]];
        UIImage *contentBgImageSelected =[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left.png"];
        [voiceCell.tapControl setBackgroundImage:[contentBgImageSelected stretchableImageWithLeftCapWidth:18 topCapHeight:33] forState:UIControlStateNormal];
        
        //用户发来信息
    }else{
        
        NTalkerVoiceRightTableViewCell *voiceCell = (NTalkerVoiceRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[tag integerValue] inSection:0]];
        UIImage *contentBgImageSelected =[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_right.png"];
        [voiceCell.tapControl setBackgroundImage:[contentBgImageSelected stretchableImageWithLeftCapWidth:17 topCapHeight:33] forState:UIControlStateNormal];
        
    }
}
//开始播放语音//zjia
- (void)beginPlayVoice:(NSInteger)tag{
    //    NSLog(@"开始播放语音");
    currentVoiceImage = 2;
    voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(voiceMessageImageChanging) userInfo:[NSNumber numberWithInteger:tag] repeats:YES];
    XNBaseMessage *chatObject= [chatArray objectAtIndex:tag];
    //客服发来信息
    if ([chatObject.userid rangeOfString:self.userId].location ==NSNotFound&& ![[NSString stringWithFormat:@"%lu",chatObject.sendStatus] boolValue]) {
        
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag  inSection:0]];
        
        chatObject.sendStatus = 1;
        voiceCell.tipView.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentChatingViewChangedUnreadNum" object:chatObject];
    }
}
//语音图片改变 //zjia
- (void)voiceMessageImageChanging{
    
    XNBaseMessage *chatObject =  [chatArray objectAtIndex:[(NSNumber *)voiceTimer.userInfo integerValue]];
    if (currentVoiceImage<0) {
        currentVoiceImage = 2;
    }else if(currentVoiceImage==3){
        currentVoiceImage = 2;
        currentVoiceImage--;
        return;
    }
    //客服发来语音
    if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
        
        //客服
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell*)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)voiceTimer.userInfo integerValue] inSection:0]];
        voiceCell.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"NTalkerUIKitResource.bundle/ntalker_left_sound%d.png",currentVoiceImage]];
        
        //用户发来语音
    }else{
        
        NTalkerVoiceRightTableViewCell *voiceCell = (NTalkerVoiceRightTableViewCell*)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)voiceTimer.userInfo integerValue] inSection:0]];
        
        //访客
        voiceCell.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"NTalkerUIKitResource.bundle/ntalker_sound%d.png",currentVoiceImage]];
        
    }
    
    //    //用户发来信息
    //    if ([chatObject.userid rangeOfString:self.userid].location !=NSNotFound)  {
    //
    //       NSVoiceRightTableViewCell *voiceCell = (NSVoiceRightTableViewCell*)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)voiceTimer.userInfo integerValue] inSection:0]];
    //
    //        //访客
    //        voiceCell.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ntalker_sound%d.png",currentVoiceImage]];
    //    } else {
    //        //客服
    //        NSVoiceLeftTableViewCell *voiceCell = (NSVoiceLeftTableViewCell*)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)voiceTimer.userInfo integerValue] inSection:0]];
    //        voiceCell.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ntalker_left_sound%d.png",currentVoiceImage]];
    //    }
    currentVoiceImage--;
}



#pragma mark - Record Voice Message
- (void)canRecordNowParam{
    
    canRecordNow=YES;
}
- (void)canRemoveShortTip:(NSNumber *)number{
    
    canRecordNow=NO;
    if (canRemoveTipView<=number.intValue){
        
        [voiceRecordTooShort removeFromSuperview];
        recordButton.userInteractionEnabled = YES;
        inputTextView.hidden = NO;
        [recordButton setHighlighted:NO];//0601放开
        // [recordButton setSelected:NO];
        recordButton.enabled=upAlready;//0601
        canRecordNow=YES;
    }
}
- (void)recordStarting:(UIButton *)sender{
    
    upAlready=NO;//0601
    recordButton.userInteractionEnabled = NO;
    if (canRecordNow) {
        startRecordButton=1;
        
        canRecordNow=NO;
        [self performSelector:@selector(canRecordNowParam) withObject:nil afterDelay:1.0];
        [self stopPlayVoiceImage];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        //
                        if (startRecordButton>0) {
                            //
                            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
                            [audioSession setActive:YES error:nil];
                            self.voiceMsgID = [self getNowTimeWithLongType];
                            NSString *path =[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
                            NSDictionary *setting=[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                                   nil];
                            //启动计时器
                            [self recordAudioTimerStart];
                            if (self.audioRecorder) {
                                //
                                if (self.audioRecorder.isRecording) {
                                    //
                                    [audioRecorder stop];
                                }
                                self.audioRecorder=nil;
                            }
                            audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:path]  settings:setting error:nil];
                            audioRecorder.meteringEnabled = YES;
                            [audioRecorder prepareToRecord];
                            //开始录音
                            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
                            [[AVAudioSession sharedInstance] setActive:YES error:nil];
                            [audioRecorder record];
                        }else{
                            
                            if (!voiceRecordTooShort.superview || voiceRecordTooShort.superview != self.view) {
                                [self.view addSubview:voiceRecordTooShort];
                                inputTextView.hidden = YES;
                            }
                            canRemoveTipView++;
                            [self performSelector:@selector(canRemoveShortTip:) withObject:[NSNumber numberWithInt:canRemoveTipView] afterDelay:1.0];
                        }
                    }else{
                        
                        [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许访问您的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                        
                    }
                });
            }];
        } else {
            
            [self recordAudioTimerStart];
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [audioSession setActive:YES error:nil];
            self.voiceMsgID = [self getNowTimeWithLongType];
            NSString *path =[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
            
            NSDictionary *setting=[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
            if (audioRecorder) {
                if (audioRecorder.isRecording) {
                    [audioRecorder stop];
                }
                audioRecorder=nil;
            }
            audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:path]  settings:setting error:nil];
            audioRecorder.meteringEnabled = YES;
            [audioRecorder prepareToRecord];
            //开始录音
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [audioRecorder record];
        }
    }else{
        if (!voiceRecordTooShort.superview || voiceRecordTooShort.superview != self.view) {
            [self.view addSubview:voiceRecordTooShort];
            inputTextView.hidden = YES;
        }
        canRemoveTipView++;
        [self performSelector:@selector(canRemoveShortTip:) withObject:[NSNumber numberWithInt:canRemoveTipView] afterDelay:1.0];
    }
}
- (void)recordFinishedAndSend:(UIButton *)sender{
    upAlready=YES;//0601
    sender.enabled=YES;//0601
    startRecordButton--;
    
    recordButton.userInteractionEnabled = YES;
    
    if (voiceSendAlready) {
        
    } else {
        
        voiceSendAlready=YES;
        if (self.audioRecorder) {
            
            if ([self.audioRecorder isRecording]) {
                [self.audioRecorder stop];
            }
            self.audioRecorder=nil;
        }
        if (recordTimer && recordTimer.isValid){
            
            [recordTimer invalidate];
            recordTimer=nil;
        }
        if (voiceRecordImageView.superview==self.view) {
            
            [voiceRecordImageView removeFromSuperview];
        }
        NSString *wavPath=[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
        
        
        NSString *amrPath=[self getConfigFile:[NSString stringWithFormat:@"%@c.amr",self.voiceMsgID]];
        
        //录音不到一秒
        if (recordAudioTime<0.9) {
            //删除文件
            //            NSLog(@"2121212121");
            if ([[NSFileManager defaultManager] fileExistsAtPath:wavPath]) {
                //                NSLog(@"3838383838");
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:wavPath error:&error];
                if (error) {
                    //                    XN_Log(@"remove voice file error:%@",[error description]);
                }
            }
            //#warning speak too short
            
            if (!voiceRecordTooShort.superview || voiceRecordTooShort.superview != self.view) {
                [self.view addSubview:voiceRecordTooShort];
                inputTextView.hidden = YES;
                
            }
            canRemoveTipView++;
            [self performSelector:@selector(canRemoveShortTip:) withObject:[NSNumber numberWithInt:canRemoveTipView] afterDelay:1.0];
            return;
        }
        //        else{
        //            NSLog(@"2323232323");
        //
        //        }
        
        XNVoiceMessage *voiceMessage = [[XNVoiceMessage alloc] init];
        voiceMessage.voiceLength = (NSInteger)roundf(recordAudioTime);
        voiceMessage.voiceLocal = amrPath;
        voiceMessage.msgid = [NSString stringWithFormat:@"%@c",self.voiceMsgID];
        [VoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
        [self sendMessage:voiceMessage resend:NO];
        
        //        NTalkerChatMessage *chatMessage = [[NTalkerChatMessage alloc] init];
        //        chatMessage.userid=_userid;
        //        chatMessage.username=_username;
        //        chatMessage.siteid=_siteid;
        //        chatMessage.settingid=_settingid;
        //        chatMessage.time = self.voiceMsgID;
        //        chatMessage.messageid = [NSString stringWithFormat:@"%@c",self.voiceMsgID];
        //
        //        self.voiceMsgID=@"";
        //        chatMessage.msgStatus = @"unsend";
        //        chatMessage.type=6;
        //
        //        NTalkerVoiceChatMessage *voiceChatMessage=[[NTalkerVoiceChatMessage alloc] init];
        //        voiceChatMessage.sound_extension=amrPath;
        //        //zjia
        //        voiceChatMessage.sound_length=[NSString stringWithFormat:@"%.0f",roundf(recordAudioTime)];//注意
        ////        NSLog(@"voiceChatMessage.sound_length=======%@",voiceChatMessage.sound_length);
        //        chatMessage.messageBody=voiceChatMessage;
        //
        //        [VoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
        //
        //        [self sendChatMessageWithChatMessage:chatMessage];
        ////        [holdingMessageIDsDic setObject:[NSNumber numberWithUnsignedInteger:chatArray.count-1] forKey:chatMessage.messageid];
        //
        ////        [chatTableView reloadData];//jia
        //
        //       //<<<<<<<<0523
        //        if (chatArray.count<5) {
        //            [chatTableView reloadData];
        //        } else{
        //            [chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:chatArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        //        }
        //        //>>>>>>>>>>>>
        ////
        //        [self scrollToTableViewBottom:YES];//zjia
        
        
    }
}
- (void)recordFinishedAndNoSend:(id)sender{
    upAlready=YES;//0601
    startRecordButton--;
    
    if (voiceSendAlready) {
        
    } else {
        
        [self stopRecordVoiceMsg];
    }
}
- (void)recordWillFinishedAndNoSend:(UIButton *)sender{
    
    recordButton.userInteractionEnabled = YES;
    
    cancelRecord=YES;
    [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending.png"]];
}
- (void)recordWillGoOnAndSend:(UIButton *)sender{
    
    cancelRecord = NO;
}
- (void)recordAudioTimerStart{
    
    if (recordTimer && recordTimer.isValid) {
        
        [recordTimer invalidate];
        recordTimer=nil;
    }
    cancelRecord=NO;
    voiceSendAlready=NO;
    recordAudioTime = 0.0;
    if (voiceRecordTooShort.superview==self.view) {
        
    }
    [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_volume1.png"]];
    [self.view addSubview:voiceRecordImageView];
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(recordTimerFunction) userInfo:nil repeats:YES];
}
- (void)recordTimerFunction{
    if (self.audioRecorder.isRecording) {
        recordAudioTime+=0.1;
        if (!cancelRecord && recordAudioTime<50) {
            [self.audioRecorder updateMeters];
            //-160表示完全安静，0表示最大输入值
            float metersValue = [self.audioRecorder peakPowerForChannel:0];
            int volume=0;
            if (metersValue>-3) {
                volume=7;
            }else if (metersValue>-5){
                volume=6;
            }else if (metersValue>-8){
                volume=5;
            }else if (metersValue>-11){
                volume=4;
            }else if (metersValue>-15){
                volume=3;
            }else if (metersValue>-20){
                volume=2;
            }else {
                volume=1;
            }
            [voiceRecordImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"NTalkerUIKitResource.bundle/ntalker_record_volume%d.png",volume]]];
        } else if(!cancelRecord){
            if (recordAudioTime >= 50.0 && recordAudioTime<51.0) {
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending9.png"]];
            } else if (recordAudioTime >= 51.0 && recordAudioTime<52.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending8.png"]];
            } else if (recordAudioTime >= 52.0 && recordAudioTime<53.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending7.png"]];
            } else if (recordAudioTime >= 53.0 && recordAudioTime<54.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending6.png"]];
            } else if (recordAudioTime >= 54.0 && recordAudioTime<55.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending5.png"]];
            } else if (recordAudioTime >= 55.0 && recordAudioTime<56.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending4.png"]];
            } else if (recordAudioTime >= 56.0 && recordAudioTime<57.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending3.png"]];
            } else if (recordAudioTime >= 57.0 && recordAudioTime<58.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending2.png"]];
            } else if (recordAudioTime >= 58.0 && recordAudioTime<59.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending1.png"]];
            } else if (recordAudioTime >= 59.0 && recordAudioTime<60.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending0.png"]];
            } else {
                //                NSLog(@"超时，发送");
                [self recordFinishedAndSend:nil];
            }
        }
        //0707 超时发送
        else if (cancelRecord && recordAudioTime>=60){
            [self recordFinishedAndSend:nil];
        }
    }
}
//停止播放语音时的图片
- (NSInteger)stopPlayVoiceImage{
    NSInteger row=-1;
    if ([voiceTimer isValid] && voiceTimer) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
            self.audioPlayer.delegate = nil;
        }
        row = [(NSNumber *)voiceTimer.userInfo integerValue];
        [voiceTimer invalidate];
        voiceTimer = nil;
        currentVoiceImage = 0;
        
        //17hao
        XNBaseMessage *chatObject =[chatArray objectAtIndex:row];
        
        //客服
        if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
            //客服
            NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            voiceCell.contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_left_sound0.png"];
        }else {
            //用户发来信息
            NTalkerVoiceRightTableViewCell *voiceCell = (NTalkerVoiceRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            voiceCell.contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_sound0.png"];//0708   0
        }
        
        
        
        //        //用户发来信息
        //        if ([chatObject.userid rangeOfString:self.userid].location !=NSNotFound) {
        //            NSVoiceRightTableViewCell *voiceCell = (NSVoiceRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        //            voiceCell.contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_sound.png"];
        //        } else {
        //            //客服
        //            NSVoiceLeftTableViewCell *voiceCell = (NSVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        //            voiceCell.contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_left_sound0.png"];
        //            }
        
    }
    return row;
}
- (void)stopRecordVoiceMsg{
    
    if (recordTimer && recordTimer.isValid) {
        
        [recordTimer invalidate];
        recordTimer=nil;
    }
    if (self.audioRecorder && self.audioRecorder.isRecording) {
        
        if (self.audioRecorder.isRecording) {
            [self.audioRecorder stop];
            NSString *wavPath=[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
            //删除文件
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:wavPath]) {
                
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:wavPath error:&error];
                if (error) {
                    //                    NSLog(@"remove voice file error:%@",[error description]);
                }
            }
        }
        self.audioRecorder = nil;
    }
    cancelRecord=NO;
    voiceSendAlready=NO;
    recordAudioTime = 0.0;
    if (voiceRecordImageView.superview==self.view) {
        
        [voiceRecordImageView removeFromSuperview];
    }
}
-(void)changeAudioPlayModel:(BOOL)sender{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (sender) {
        //设置下扬声器模式
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    }else{
        //设置听筒模式
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    [audioSession setActive:YES error:nil];
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlayVoiceImage];
}
- (void)selectedEmoji:(NSString *)emoji{
    if (!emoji) {
        //发送
        if (inputTextView.text.length>0) {
            if (inputTextView.text.length>=4) {
                NSString *lastCharactorR = [inputTextView.text substringWithRange:NSMakeRange(inputTextView.text.length-1, 1)];
                NSString *lastCharactorL = [inputTextView.text substringWithRange:NSMakeRange(inputTextView.text.length-4, 1)];
                if ([lastCharactorR isEqualToString:@"]"] && [lastCharactorL isEqualToString:@"["]) {
                    NSString *emojiString = [inputTextView.text substringWithRange:NSMakeRange(inputTextView.text.length-4, 4)];
                    if ([[NTalkerEmojiScrollView getAllEmoji] containsObject:emojiString]) {
                        inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-4];
                    } else {
                        inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
                    }
                } else {
                    inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
                }
            }else{
                inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
            }
        }
    }else {
        inputTextView.text = [NSString stringWithFormat:@"%@%@",inputTextView.text,emoji];
    }
}

-(void)sendEmoji{
    [self growingTextViewShouldReturn:inputTextView];
}

#pragma mark - navigationBar function
- (void)openMenuOfServerList{
    [self tapGestureFunction:nil];
    float offsetX = self.view.frame.origin.x;
    if (0 == offsetX) {
        offsetX = kFWFullScreenWidth;
        reactionKeyboard=NO;
    } else {
        offsetX = 0;
        reactionKeyboard=YES;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(offsetX, 0, kFWFullScreenWidth, kFWFullScreenHeight)];
    }];
}


#pragma mark - UIInputTextView

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    if (_currentStatus != 9) {
        if (_promptView) {
            [self addSimpleAlertView:_promptView.text];
        } else {
            [self addSimpleAlertView:@"正在请求客服"];
        }
        return NO;
    }
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    self.alreadyText= growingTextView.text;
    if (self.alreadyText.length==0) {
        [emojiScrollView setSendBtnStatus:NO];
    } else {
        [emojiScrollView setSendBtnStatus:YES];
    }
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""] && range.length>0) {
        if (range.location+range.length==self.alreadyText.length && range.length==1) {
            if ([[self.alreadyText substringWithRange:NSMakeRange(self.alreadyText.length-1, 1)] isEqualToString:@"]"]) {
                if (self.alreadyText.length>=4 && [[self.alreadyText substringWithRange:NSMakeRange(self.alreadyText.length-4, 1)] isEqualToString:@"["]) {
                    NSString *emojiString = [self.alreadyText substringWithRange:NSMakeRange(self.alreadyText.length-4, 4)];
                    if ([[NTalkerEmojiScrollView getAllEmoji] containsObject:emojiString]) {
                        growingTextView.text = [self.alreadyText substringWithRange:NSMakeRange(0, self.alreadyText.length-3)];
                    }
                }
            }
        } else if (range.location+range.length==self.alreadyText.length){
            
        }
    }
    return YES;
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    //如果输入一行就设置为原来高度
    if (height==34 || height==37 || height==39) {
        height=34;
        CGRect textviewframe = growingTextView.frame;
        textviewframe.size.height=34;
        [growingTextView setFrame:textviewframe];
    }
    float offHeight = height-inputTextHeight;
    inputTextHeight = height;
    
    CGRect inputViewFrame = inputView.frame;
    inputViewFrame.origin.y = inputViewFrame.origin.y-offHeight;
    inputViewFrame.size.height = inputViewFrame.size.height+offHeight;
    inputView.frame = inputViewFrame;
    
    [inputTextViewBg setFrame:CGRectMake(40.8, 7, kFWFullScreenWidth-116 , height)];//
    
    CGPoint offset = chatTableView.contentOffset;
    CGRect tableViewFrame=chatTableView.frame;
    if (offHeight>0) {
        //变小了
        CGSize contentSize = chatTableView.contentSize;
        if (contentSize.height<=0) {
        } else if (offset.y+tableViewFrame.size.height-offHeight<=contentSize.height) {
            chatTableView.contentOffset=CGPointMake(0, offset.y+offHeight);
        } else if (contentSize.height>=tableViewFrame.size.height-offHeight){
            chatTableView.contentOffset=CGPointMake(0, contentSize.height-tableViewFrame.size.height+offHeight);
        } else {
            
        }
        
        tableViewFrame.size.height = tableViewFrame.size.height-offHeight;
        chatTableView.frame=tableViewFrame;
    } else {
        //变大了
        tableViewFrame.size.height = tableViewFrame.size.height-offHeight;
        chatTableView.frame = tableViewFrame;
        if (offset.y+offHeight>=0) {
            chatTableView.contentOffset=CGPointMake(0, offset.y+offHeight);
        } else {
            chatTableView.contentOffset=CGPointMake(0, 0);
        }
    }
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    
    //发送
    //去除两端空格
    NSString *temptext =[growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![temptext isEqualToString:@""]) {
        NSString *content = growingTextView.text;
        growingTextView.text = @"";
        
        XNTextMessage *textMessage = [[XNTextMessage alloc] init];
        textMessage.textMsg = content;
        
        [self sendMessage:textMessage resend:NO];
        //        [holdingMessageIDsDic setObject:[NSNumber numberWithUnsignedInteger:chatArray.count-1] forKey:chatMessage.messageid];
        
        [chatTableView reloadData];
        [self scrollToTableViewBottom:YES];//zjia
        //将新消息添加到消息队列
        
    }else{
        //提示发送信息不能为空
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提　示" message:@"发送信息不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        // [alter release];
    }
    return YES;
}
- (void)scrollToTableViewBottom:(BOOL)animated{
    if ([chatArray count]>0) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[chatArray count] inSection:0];
        [chatTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (![info allKeys].count) {
        return;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    
    //裁剪调整相机图片
    NSString *msgid = [XNUtilityHelper getNowTimeInterval];
    UIImage *fixImage = [self fixOrientationWithImage:image];
    NSString *imagePath=[self fileOfPressedImage:fixImage withName:msgid];
    
    
    XNImageMessage *imageMessage = [[XNImageMessage alloc] init];
    imageMessage.pictureLocal = imagePath;
    imageMessage.msgid = msgid;
    
    [self sendMessage:imageMessage resend:NO];
    
    [chatTableView reloadData];
    
    [self scrollToTableViewBottom:YES];
}

#pragma mark - Tool Function
-(UIImage *) fixOrientationWithImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (NSString *)fileOfPressedImage:(UIImage *)image withName:(NSString *)fileName{
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@.jpg", fileName];
    NSString *_image_Path=[self getConfigFile:imagelocalName_s];
    
    CGSize imageSize = image.size;
    if (imageSize.width>640) {
        imageSize.height = imageSize.height/(imageSize.width/640);
        imageSize.width = 640;
        UIGraphicsBeginImageContext(imageSize);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *pressSizeData = UIImageJPEGRepresentation(scaledImage, 1);
        if (pressSizeData.length>80*1024){
            pressSizeData = UIImageJPEGRepresentation(scaledImage, 0.3);
        }
        [pressSizeData writeToFile:_image_Path atomically:YES];
        return _image_Path;
    }
    NSData *pressSizeData=UIImageJPEGRepresentation(image, 1);
    if (pressSizeData.length>80*1024){
        pressSizeData = UIImageJPEGRepresentation(image, 0.3);
    }
    [pressSizeData writeToFile:_image_Path atomically:YES];
    return _image_Path;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, newRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}
- (NSString *)getConfigFile:(NSString *)fileName
{
    //读取documents路径:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//得到documents的路径，为当前应用程序独享
    NSString *documentD = [paths objectAtIndex:0];
    NSString *configFile = [documentD stringByAppendingPathComponent:fileName]; //得到documents目录下fileName文件的路径
    return configFile;
}
- (NSString *) getNowTimeWithLongType{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
}


//停止播放语音
- (void)stop
{
    self.audioPlayer.currentTime = 0;  //当前播放时间设置为0
    [audioPlayer stop];
    self.audioPlayer=nil;
}

-(void)backFoward{
    //（如果正在播放）停止播放语音
    [self stop];
    [self tapGestureFunction:nil];
    if (self.pushOrPresent) {
        int count=(int)self.navigationController.viewControllers.count;
        int stack=count-1;
        for (int i=count-1; i>=0; i--) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:i];
            if ([viewController isKindOfClass:[NTalkerChatViewController class]]) {
                stack=i;
                break;
            }
        }
        if (stack>0) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:stack-1];
            [self.navigationController popToViewController:viewController animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)endChat{
    //（如果正在播放）停止播放语音
    [[XNSDKCore sharedInstance] closeChatViewSessionid:_settingid];
    [self stop];
    [self tapGestureFunction:nil];
    if (self.pushOrPresent) {
        int count=(int)self.navigationController.viewControllers.count;
        int stack=count-1;
        for (int i=count-1; i>=0; i--) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:i];
            if ([viewController isKindOfClass:[NTalkerChatViewController class]]) {
                stack=i;
                break;
            }
        }
        if (stack>0) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:stack-1];
            [self.navigationController popToViewController:viewController animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1909:{
            switch (buttonIndex) {
                case 0:{
                    
                    break;
                }
                case 1:{
                    [self evaluationFunction:nil];
                    break;
                }
            }
            break;
        }
        case 7686:{
            switch (buttonIndex) {
                case 0:{
                    [self endChat];
                    break;
                }
                case 1:{
                    
                    break;
                }
            }
            break;
        }
        case 1188:{
            switch (buttonIndex) {
                case 1:{
                    NTalkerLeaveMsgViewController *ctrl = [[NTalkerLeaveMsgViewController alloc] init];
                    ctrl.siteId = [XNUtilityHelper siteidfromSettingid:_settingid];
                    ctrl.settingId = _settingid;
                    ctrl.responseKefu = _currentKufuId;
                    ctrl.pageTitle = _pageTitle;
                    ctrl.pageURLString = _pageURLString;
                    [self.navigationController pushViewController:ctrl animated:YES];
                    break;
                }
                case 2:{
                    [self endChat];
                    break;
                }
                default:{
                    
                    break;
                }
            }
            break;
        }
        default:{
            
        }
    }
}

- (void)logoutLeaveMsgViewController {
    [self endChat];
}

-(void)predictChat{
    
}
- (void)remarkChat{
    
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self tapGestureFunction:nil];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentSize.height<scrollView.contentOffset.y+scrollView.frame.size.height+60) {
        scrollToBottom=YES;
    } else {
        scrollToBottom=NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == -64) {
        [self refresh];
    }
    if (scrollView.contentSize.height<scrollView.contentOffset.y+scrollView.frame.size.height+60) {
        scrollToBottom=YES;
    } else {
        scrollToBottom=NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)dealloc{
    //    NSLog(@"UIXNChatViewController dealloc");
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initUIWithFMDB
{
    //
    CGFloat contentOffset = chatTableView.contentSize.height?:chatTableView.frame.size.height;
    dispatch_queue_t dbQueue = dispatch_queue_create("dbQueue", 0);
    dispatch_async(dbQueue, ^{
        NSMutableArray *arr = [[XNSDKCore sharedInstance] messageFromDBByNum:20 andOffset:chatArray.count];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (arr.count) {
                [chatArray insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
                [chatTableView reloadData];
                UIView *view = [self.view viewWithTag:9090];
                if (chatTableView.contentSize.height >= chatTableView.frame.size.height) {
                    [chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height - contentOffset + view.frame.size.height) animated:NO];
                }
            }
            [self stopRefresh];
        });
    });
}

- (void)stopRefresh
{
    UIView *goodsView =[self.view viewWithTag:9090];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, CGRectGetHeight(goodsView.frame))];
    view.backgroundColor = [UIColor clearColor];
    chatTableView.tableHeaderView = view;
}

- (void)refresh
{
    UIView *goodsView =[self.view viewWithTag:9090];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, CGRectGetHeight(goodsView.frame)+23)];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake((CGRectGetWidth(chatTableView.frame) - 25)/2, goodsView.frame.size.height + 5, 25, 25);
    [activityView startAnimating];
    [view addSubview:activityView];
    [chatTableView setTableHeaderView:view];
    
    [self initUIWithFMDB];
}

#pragma mark =====================SDKCORE=======================

- (void)initBasicInfo
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    self.userId = basicInfo.uid;
    
    if ([_productInfo.clientGoods_Type isEqualToString:@"0"]) {
        return;
    } else if ([_productInfo.clientGoods_Type isEqualToString:@"1"]) {
        self.productMessage = [[XNProductionMessage alloc] init];
        self.productMessage.goodsId = _productInfo.goods_id;
    } else if ([_productInfo.clientGoods_Type isEqualToString:@"2"]) {
        self.productMessage = [[XNProductionMessage alloc] init];
        self.productMessage.productInfoURL = _productInfo.goods_showURL;
    }
    
    if (_pageTitle.length || _pageURLString.length) {
        self.launchPageMessage = [[XNChatLaunchPageMessage alloc] init];
        self.launchPageMessage.pageURLString = _pageURLString;
        self.launchPageMessage.pageTitle = _pageTitle;
    }
}

- (void)sendMessage:(XNBaseMessage *)message resend:(BOOL)resend
{
    [[XNSDKCore sharedInstance] sendMessage:message resend:resend];
}

- (void)sendErpMessage:(NSString *)erpParam
{
    XNErpMessage *erpMessage = [[XNErpMessage alloc] init];
    erpMessage.erpParam = _erpParams;
    [self sendMessage:erpMessage resend:NO];
}

#pragma mark =================初始化变量====================

- (void)initData
{
    self.judgeDupDict = [[NSMutableDictionary alloc] init];
}

- (void)promtEvaluateSuccess
{
    if (_alreadyShowEvaTag) {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"评价提交成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    alertView.tag = 1203;
    [alertView show];
    
    _alreadyShowEvaTag = YES;
}

- (BOOL)duplicateMessage:(XNBaseMessage *)message
{
    BOOL duplicate = NO;
    for (XNBaseMessage *chatMessage in chatArray) {
        if ([chatMessage.msgid isEqualToString:message.msgid]) {
            [chatArray replaceObjectAtIndex:[chatArray indexOfObject:chatMessage] withObject:message];
            duplicate = YES;
            [chatTableView reloadData];
            break;
        }
    }
    return duplicate;
}

- (void)message:(XNBaseMessage *)message
{
    //两层去重
    if ([chatArray containsObject:message]) {
        [chatTableView reloadData];
    } else if (![self duplicateMessage:message]) {
        if (message.msgType != MSG_TYPE_PICTURE &&
            message.msgType != MSG_TYPE_TEXT &&
            message.msgType != MSG_TYPE_VOICE &&
            message.msgType != MSG_TYPE_SYSTEM_EVALUATE) {
            return;
        } else if ([message isKindOfClass:[XNEvaluateMessage class]]) {
            if (![chatArray containsObject:message]) {
                [chatArray addObject:message];
                [chatTableView reloadData];
                [self scrollToTableViewBottom:YES];
            }
            return;
        }
        
        if ([XNUtilityHelper isKefuUserid:message.userid]) {
            //            UIButton *button = [self.navigationItem.titleView subviews][0];
            //            [button setTitle:message.externalname forState:UIControlStateNormal];
            self.title = message.externalname.length?message.externalname:@"在线客服";
            self.currentKufuId = message.userid;
        }
        
        [chatArray addObject:message];
        [chatTableView reloadData];
        [self scrollToTableViewBottom:YES];
    }
}

- (void)gotoLeaveMsgCtrl:(UITapGestureRecognizer *)sender
{
    NTalkerLeaveMsgViewController *ctrl = [[NTalkerLeaveMsgViewController alloc] init];
    ctrl.siteId = [XNUtilityHelper siteidfromSettingid:_settingid];
    ctrl.settingId = _settingid;
    ctrl.responseKefu = _currentKufuId;
    ctrl.pageTitle = _pageTitle;
    ctrl.pageURLString = _pageURLString;
    [self.navigationController pushViewController:ctrl animated:YES];
}

/*
 -1==失败
 2 ==建立连接成功
 4 ==请求客服成功
 9 ==建立会话成功
 */
- (void)connectStatus:(NSInteger)status
{
    
    if (status != 9) {
        if (inputTextView.isFirstResponder) {
            [inputTextView resignFirstResponder];
        }
    }
    
    self.promptView.hidden = NO;
    _currentStatus = status;
    switch (status) {
        case -1:{
            self.promptView.text = @"连接客服失败,点击进入留言";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLeaveMsgCtrl:)];
            self.promptView.userInteractionEnabled = YES;
            [self.promptView addGestureRecognizer:tap];
            break;
        }
        case 2:{
            //            self.promptView.text = @"正在请求客服";
            break;
        }
        case 4:{
            //            self.promptView.text = @"正在建立会话";
            break;
        }
        case 9:{
            self.promptView.hidden = YES;
            [self sendMessage:_productMessage resend:NO];
            [self sendMessage:_launchPageMessage resend:NO];
            //            [self sendErpMessage:_erpParams];
            break;
        }
    }
}

- (void)currentWaitingNum:(NSInteger)num
{
    self.promptView.text = [NSString stringWithFormat:@"抱歉,人数过多,您当前排在第%ld位,点击留言",num + 1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLeaveMsgCtrl:)];
    self.promptView.userInteractionEnabled = YES;
    [self.promptView addGestureRecognizer:tap];
}

- (void)requestEvaluate:(NSString *)userName
{
    _alreadyShowEvaTag = NO;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in [keyWindow subviews]) {
        if ([[view subviews][0] isKindOfClass:[XNEvaluateView class]]) {
            return;
        }
    }
    
    //    UIButton *button = [self.navigationItem.titleView subviews][0];
    //    [button setTitle:userName forState:UIControlStateNormal];
    self.title = userName;
    if ([inputTextView isFirstResponder]) {
        [inputTextView resignFirstResponder];
    }
    [XNEvaluateView addEvaluateViewWithFrame:CGRectMake(10, 75, kFWFullScreenWidth - 20, kFWFullScreenHeight - 130) delegate:self];
}

- (void)submitMessage:(NSDictionary *)dict evaluateView:(XNEvaluateView *)evaluateView
{
    XNEvaluateMessage *message = [[XNEvaluateMessage alloc] init];
    message.score = [dict[EVALUATEVALUE] unsignedIntegerValue];
    message.evaluateContent = dict[EVALUATECONTENT];
    message.proposal = dict[EVALUATESUGGEST];
    message.solveStatus = dict[EVALUATESTATUS];
    [self sendMessage:message resend:NO];
    [evaluateView removeFromSuperview];
    
    if (_needPop) {
        [self performSelector:@selector(endChat) withObject:nil afterDelay:1.0];
    }
}

- (void)cancel:(XNEvaluateView *)evaluateView
{
    _needPop = NO;
    [evaluateView removeFromSuperview];
}

/*
 couldEvaluate 是否可以评价
 evaluated 是否评价过
 */
- (void)sceneChanged:(BOOL)couldEvaluate andEvaluted:(BOOL)evaluated
{
    _couldEvaluted = couldEvaluate;
    _evaluated = evaluated;
    
    UIButton *button = (UIButton *)[functionView viewWithTag:1090];
    UILabel *label = (UILabel *)[functionView viewWithTag:1091];
    
    if (!button) return;
    
    if (couldEvaluate) {
        button.enabled = YES;
    } else {
        button.enabled = NO;
    }
    
    if (evaluated) {
        label.text = @"已评价";
    }
}

- (void)userList:(XNChatBasicUserModel *)user
{
    if ([user isKindOfClass:[XNChatKefuUserModel class]]) {
        XNChatKefuUserModel *kefu = (XNChatKefuUserModel *)user;
        self.title = kefu.externalname.length?kefu.externalname:@"在线客服";
        self.currentKufuId = user.userid;
    }
}

#pragma mark ===================resend=====================

- (void)resendTextMsg:(XNTextMessage *)textMessage
{
    [self resendMessage:textMessage];
}

- (void)resendVoiceMsg:(XNVoiceMessage *)voiceMessage
{
    [self resendMessage:voiceMessage];
}

- (void)resendImageMsg:(XNImageMessage *)imageMessage
{
    [self resendMessage:imageMessage];
}

- (void)resendMessage:(XNBaseMessage *)message
{
    if (![chatArray containsObject:message]) {
        return;
    }
    
    [chatArray removeObject:message];
    [chatArray addObject:message];
    [self sendMessage:message resend:YES];
    [chatTableView reloadData];
    [self scrollToTableViewBottom:YES];
}

- (void)toWebViewBySuperLink:(NSString *)link
{
    if (link.length) {
        XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
        ctrl.productURL = link;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void)jumpToWebViewByLink:(NSString *)linkString
{
    if (linkString.length) {
        XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
        ctrl.productURL = linkString;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark ====================other=====================

- (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(1.0)];
}

- (void)addSimpleAlertView:(NSString *)message
{
    if ([message isEqualToString:@"连接客服失败,点击进入留言"]) {
        message = @"请求客服失败,您可以";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"进入留言",@"关闭会话", nil];
        alertView.tag = 1188;
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"正在请求客服"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

@end

