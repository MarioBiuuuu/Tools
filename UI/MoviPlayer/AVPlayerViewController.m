//
//  AVPlayerViewController.m
//  Player
//
//  Created by Zac on 15/11/6.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "AVPlayerViewController.h"
#import "UISlider+UISlider_touch.h"
#import "UIView+UIView_Frame.h"
#import "TransmitMessageViewController.h"

#import <RMUniversalAlert/RMUniversalAlert.h>
#import <AFNetworking/AFNetworking.h>

#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface AVPlayerViewController () {
    NSURLSessionDownloadTask *_downloadTask;
}

@property (nonatomic, strong) AFURLSessionManager *manager;

@property (strong, nonatomic) UIView                  *container;//播放器容器
@property (strong, nonatomic) AVPlayerItem            *playerItem;//播放对象

@property (nonatomic, strong) UIButton                *playButton;//播放/暂停按钮
@property (nonatomic, strong) UILabel                 *startTime;//当前播放时间
@property (nonatomic, strong) UILabel                 *endTime;//总时长
@property (nonatomic, strong) UISlider                *progress;//播放进度条
@property (nonatomic, strong) UISlider                *playableProgress;//加载进度条
@property (nonatomic, strong) UISlider                *volume;//音量
@property (nonatomic, strong) UIButton                *backButton;//返回按钮
@property (nonatomic, strong) UIView                  *backView;//按钮背景试图
@property (nonatomic, strong) UIImageView             *timaImage;//进度条拖动时间lable图片
@property (nonatomic, strong) UILabel                 *timeLabel;//进度条拖动时间lable
@property (nonatomic, retain) UISlider                *systemVolume;//系统音量
@property (nonatomic, assign) BOOL                    isSliding;//进度条是否被拖动(拖动的话则不受播放进度控制)
@property (nonatomic, strong) UIActivityIndicatorView *actiity;//小菊花
@property (nonatomic, assign) BOOL                    istouched;//暂停状态是由使用者手动触发的还是网络加载不畅出发的
@end

@implementation AVPlayerViewController{
    PanDirection direction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //  初始化播放器
    [self initPlayer];
    //  建立UI
    [self setupUI];
    //  添加触控事件
    [self addGesture];
    //  添加通知
    [self addNotification];
    //  监测网络
    [self chcekNetWorkStatus];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_downloadTask == nil) return;
    
    [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        
        _downloadTask = nil;
    }];
    [_downloadTask resume];
}

//  初始化播放器
- (void)initPlayer {
    if (!_player) {
        self.playerItem=[self getPlayItem:0];
        _player=[AVPlayer playerWithPlayerItem:self.playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:self.playerItem];
    }
}

//  获得播放媒介
-(AVPlayerItem *)getPlayItem:(int)videoIndex{
//    NSURL *url=[NSURL URLWithString:self.url];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.url];
    return playerItem;
}

-(void)setupUI{
    //  container
    self.container = [[UIView alloc]init];
    self.container.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.view addSubview:self.container];
    
    //创建播放器层
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame=self.container.frame;
    //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.container.layer addSublayer:playerLayer];
    
    //  backView
    self.backView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.backView.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    self.backView.userInteractionEnabled = YES;
    [self.view addSubview:self.backView];
    
    //  PlayButton
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateSelected];
    self.playButton.frame = CGRectMake(0, 0, 46, 46);
    self.playButton.center = CGPointMake(KScreenWidth / 2, KScreenHeight / 2);
    self.playButton.userInteractionEnabled = NO;
    [self.backView addSubview:self.playButton];
    
    //  startTime
    self.startTime = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 15 - 35 - 10 - 30, KScreenHeight - 45, 35, 15)];
    self.startTime.text = @"00:00";
    self.startTime.font = [UIFont systemFontOfSize:12];
    //    self.startTime.backgroundColor = [UIColor redColor];
    self.startTime.textColor = [UIColor whiteColor];
    [self.backView addSubview:self.startTime];
    
    //  /
    UILabel *gang = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 15 - 35 - 3, KScreenHeight - 46, 10, 15)];
    gang.text = @"/";
    gang.font = [UIFont systemFontOfSize:12];
    gang.textColor = [UIColor whiteColor];
    [self.backView addSubview:gang];
    
    //  endTime
    self.endTime = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 15 - 30, KScreenHeight - 45, 35, 15)];
    self.endTime.text = @"00:00";
    self.endTime.font = [UIFont systemFontOfSize:12];
    self.endTime.textColor = [UIColor whiteColor];
    [self.backView addSubview:self.endTime];
    
    // playalbeslider
    self.playableProgress =[[UISlider alloc]initWithFrame:CGRectMake(0, KScreenHeight - 15 - 15, KScreenWidth, 15)];
    //  滑块左侧颜色
    self.playableProgress.minimumTrackTintColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    //  滑块右侧颜色
    self.playableProgress.maximumTrackTintColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.5];
    UIImage *thumbImageEmp = [[UIImage alloc]init];
    [self.playableProgress setThumbImage:thumbImageEmp forState:UIControlStateNormal];
    [self.playableProgress setThumbImage:thumbImageEmp forState:UIControlStateSelected];
    self.playableProgress.userInteractionEnabled = NO;
    [self.view addSubview:self.playableProgress];
    
    //slider
    self.progress =[[UISlider alloc]initWithFrame:CGRectMake(0, KScreenHeight - 15 - 15, KScreenWidth, 15)];
    //  滑块左侧颜色
    self.progress.minimumTrackTintColor = [UIColor whiteColor];
    //  滑块右侧颜色
    self.progress.maximumTrackTintColor = [UIColor clearColor];
    UIImage *thumbImage0 = [UIImage imageNamed:@"Oval 1"];
    [self.progress setThumbImage:thumbImage0 forState:UIControlStateNormal];
    [self.progress setThumbImage:thumbImage0 forState:UIControlStateSelected];
    [self.progress addTarget:self action:@selector(valueChange:other:) forControlEvents:UIControlEventValueChanged];
    [self.progress addTapGestureWithTarget:self action:@selector(resetSlider)];
    [self.view addSubview:self.progress];
    
    //  backButton
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"navBackBtn"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(10, 25, 21, 36);
    self.backButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.backButton];
    
    //  timeImage
    self.timaImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ThumBut"]];
    self.timaImage.frame = CGRectMake(0, 0, 30, 12);
    self.timaImage.hidden = YES;
    [self.view addSubview:self.timaImage];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 12)];
    self.timeLabel.font = [UIFont systemFontOfSize:8];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.timaImage addSubview:self.timeLabel];
    
    self.actiity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _actiity.frame = CGRectMake(0, 0, 30, 30);
    _actiity.center = CGPointMake(KScreenWidth / 2, KScreenHeight / 2);
    [self.view addSubview:_actiity];
}

//  添加触控事件
- (void)addGesture {
    //  点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playClick)];
    [self.view addGestureRecognizer:tap];
    
    //  滑动事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    [self.view addGestureRecognizer:longPress];
}

- (void)longPressView:(UILongPressGestureRecognizer *)press {
//    self.player.rate = 0;
    self.istouched = YES;
    [self.player pause];
    self.playButton.selected = YES;
    [self playButtonAppear];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playButtonDisappear) object:nil];
    kWEAK_SELF;
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/file%@/%@", pathDocuments, [BTCommonTool getPhoneNumber], [[[NSString stringWithFormat:@"%@", self.url] componentsSeparatedByString:@"/"] lastObject]];
    BOOL isDonwload = [[NSFileManager defaultManager] fileExistsAtPath:createPath];
    if (isDonwload) {
        [RMUniversalAlert showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"发送给联系人"/*, @"收藏", @"保存至网盘"*/] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            
            if (buttonIndex == 2) {
                [weakSelf transmitMethod];
            } else if (buttonIndex != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertTool *alert = [[UIAlertTool alloc]init];
                    [alert showAlertView:self title:@"温馨提示" message:@"该功能正在开发中，敬请期待。" cancelButtonTitle:@"好的" otherButtonTitle:nil complete:nil cancle:nil];
                });
            }
            
        }];
    } else {
        [RMUniversalAlert showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存到本地", @"发送给联系人"/*, @"收藏", @"保存至网盘"*/] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            
            if (buttonIndex == 2) {
                [weakSelf downloadFileToDoc];
            } else if (buttonIndex == 3) {
                [weakSelf transmitMethod];
            } else if (buttonIndex != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertTool *alert = [[UIAlertTool alloc]init];
                    [alert showAlertView:self title:@"温馨提示" message:@"该功能正在开发中，敬请期待。" cancelButtonTitle:@"好的" otherButtonTitle:nil complete:nil cancle:nil];
                });
            }
            
        }];
    }
}

- (void)transmitMethod {
    EMChatVCDataModel *model = [[EMChatVCDataModel alloc] init];
    model.messageSize = [self.fileSize intValue];
    model.messageVoiceUrlPath = [NSString stringWithFormat:@"%@",self.url];
    model.messageDisplayName = self.displayName;
    model.messageType = 5;
    TransmitMessageViewController *transmitMessageVC = [[TransmitMessageViewController alloc] init];
    transmitMessageVC.destModel = model;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:transmitMessageVC];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    nav.navigationBar.barTintColor = BASE_COLOR;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)downloadFileToDoc {

    //远程地址
    NSURL *URL = self.url;
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    self.manager = manager;
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
           
            // 设置进度条的百分比
            
            //            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/file%@", pathDocuments, [BTCommonTool getPhoneNumber]];
        
        // 判断文件夹是否存在，如果不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSLog(@"FileDir is exists.");
        }
        
        //        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [createPath stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"path: %@",path);
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSLog(@"%@",error.localizedDescription);
        if (error && (![error.localizedDescription isEqualToString:@"已取消"] || error.code != -999)) {
           [showMessage showMessage:@"网络异常！"];
        } else if (error == nil) {
            [showMessage showMessage:@"下载完成！"];
        }
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSLog(@" file path :%@",imgFilePath);
        //        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
        //        self.imageView.image = img;
        
    }];
    [_downloadTask resume];
}

//  点击播放/暂停按钮
- (void)playClick {
    //  播放状态->暂停
    if (self.player.rate==1) {
        self.istouched = YES;
        [self.player pause];
        self.playButton.selected = YES;
        [self playButtonAppear];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playButtonDisappear) object:nil];
    //  暂停状态->播放
    }else {
        self.istouched = NO;
        self.playButton.selected = NO;
        [self.player play];
//        [self playButtonDisappear];
        [UIView animateWithDuration:0.3 animations:^{
            self.playButton.alpha = 0;
        }];
        [self performSelector:@selector(playButtonDisappear) withObject:nil afterDelay:3];
    }
}

//  控件出现(动画)
- (void)playButtonAppear {
    //  slider
    [UIView animateWithDuration:0.2 animations:^{
        self.progress.y = KScreenHeight -30;
        self.playableProgress.y = KScreenHeight -30;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.hidden = NO;
        self.backView.alpha = 1;
        self.playButton.alpha = 1;
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playButtonDisappear) object:nil];
    }completion:^(BOOL finished) {
    }];
}

//  控件消失(动画)
-(void)playButtonDisappear {
    if (self.playButton.selected) {
        return;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.progress.y = KScreenHeight -9;
        self.playableProgress.y = KScreenHeight -9;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
    }];
}

//  滑动事件
- (void)panAction:(UIPanGestureRecognizer *)pan {
    //  滑动速率
    CGPoint velocityPoint = [pan velocityInView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            self.isSliding = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playButtonDisappear) object:nil];
//            NSLog(@"x=%f, y=%f", velocityPoint.x, velocityPoint.y);
            //  判断滑动方向
            if (fabs(velocityPoint.x) > fabs(velocityPoint.y)) {
                direction = PanDirectionHorizontalMoved;
            }else {
                direction = PanDirectionVerticalMoved;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            switch (direction) {
                case PanDirectionHorizontalMoved:{
                    //  水平移动
                    self.progress.value += velocityPoint.x / 100000;
                    self.timaImage.hidden = NO;
                    self.timaImage.center = CGPointMake((KScreenWidth - 12)* self.progress.value + 6, self.progress.frame.origin.y - 15);
                    self.timeLabel.text = self.startTime.text;
                }
                case PanDirectionVerticalMoved:{
                    //  垂直移动
                    self.player.volume -= velocityPoint.y / 10000;   //  播放器音量
                    self.systemVolume.value = self.player.volume;         //  系统音量
//                    NSLog(@"%f",self.player.volume);
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
            self.isSliding = NO;
            [self performSelector:@selector(playButtonDisappear) withObject:self afterDelay:3];
            switch (direction) {
                case PanDirectionHorizontalMoved:{
                    //  水平移动 结束
                    [self resetSlider];
                    self.timaImage.hidden = YES;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    //  垂直移动结束
                    break;
                }
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)backButtonAction {
    [self turnBackPreviousViewController];
}

//  更新进度条位置并播放
- (void)resetSlider {
    CMTime dragedCMTime = CMTimeMake(self.progress.value * CMTimeGetSeconds([self.playerItem duration]), 1);
    [self.player pause];
    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        [self playClick];
    }];
}

//  拖动进度条
- (void)valueChange:(UISlider *)progress other:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    NSTimeInterval static currenttime;
    switch (touch.phase) {
            //  触摸开始
        case UITouchPhaseBegan:
            //            NSLog(@"start");
            self.isSliding = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playButtonDisappear) object:nil];
            break;
            //  触摸中
        case UITouchPhaseMoved:
            currenttime = self.progress.value * CMTimeGetSeconds([self.playerItem duration]);
            self.startTime.text = self.startTime.text = [self currentTimeToString:currenttime];
            self.timaImage.hidden = NO;
            self.timaImage.center = CGPointMake((KScreenWidth - 12)* self.progress.value + 6, self.progress.frame.origin.y - 15);
            self.timeLabel.text = self.startTime.text;
            break;
            //  触摸结束
        case UITouchPhaseEnded:
            //            NSLog(@"end");
            self.isSliding = NO;
            [self performSelector:@selector(playButtonDisappear) withObject:nil afterDelay:3];
            self.timaImage.hidden = YES;
            [self resetSlider];
            break;
        default:
            break;
    }
}

//  计算当前时间
- (NSString *)currentTimeToString:(NSTimeInterval)currentTime{
    NSInteger static minit;
    NSInteger static second;
    minit = currentTime / 60;
    second = currentTime - 60 * minit;
    return [NSString stringWithFormat:@"%02ld:%02ld", minit, second];
}

/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
//  播放完成
-(void)playbackFinished:(NSNotification *)notification{
    [self turnBackPreviousViewController];
}

- (void)turnBackPreviousViewController {
    [self.player pause];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissViewController:)]) {
        [self.delegate dismissViewController:self];
    }
    
}

#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    //这里设置每秒执行一次
    __weak typeof(self) weakSelf=self;  //设置self的弱应用放置block循环引用
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
//        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
            if (!weakSelf.isSliding) {
                weakSelf.progress.value = current/total;
            }
            weakSelf.startTime.text = [weakSelf currentTimeToString:current];
        }
    }];
}


/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        NSInteger minit;
        NSInteger second;
        if(status==AVPlayerStatusReadyToPlay){
            [self playClick];
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            minit = CMTimeGetSeconds(playerItem.duration) / 60;
            second = CMTimeGetSeconds(playerItem.duration) - 60 * minit;
            self.endTime.text = [NSString stringWithFormat:@"%02ld:%02ld", minit, second];
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f",totalBuffer);
        self.playableProgress.value = totalBuffer / 100;
        
        if (!_istouched) {
            if (self.player.rate==0) {
                [_actiity startAnimating];
            }else {
                [_actiity stopAnimating];
            }
        }
    }
}





/**
 *  切换选集，这里使用按钮的tag代表视频名称
 *
 *  @param sender 点击按钮对象
 */
//- (IBAction)navigationButtonClick:(UIButton *)sender {
//    [self removeNotification];
//    [self removeObserverFromPlayerItem:self.player.currentItem];
//    AVPlayerItem *playerItem=[self getPlayItem:sender.tag];
//    [self addObserverToPlayerItem:playerItem];
//    //切换视频
//    [self.player replaceCurrentItemWithPlayerItem:playerItem];
//    [self addNotification];
//}

- (void)chcekNetWorkStatus {
    
    UIAlertTool *alert = [[UIAlertTool alloc]init];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    kWEAK_SELF;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //status:
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                // 未知 -1
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                //未连接 0
                [alert showAlertView:self title:@"温馨提示" message:@"当前网络状态不佳，已退出播放" cancelButtonTitle:@"好的" otherButtonTitle:nil complete:^{
                    
                } cancle:^{
                    [weakSelf turnBackPreviousViewController];
                }];
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // 3G 1
                [weakSelf playClick];
                [alert showAlertView:self title:@"温馨提示" message:@"当前网络为蜂窝网络，会消耗您的流量，是否需要停止加载" cancelButtonTitle:@"退出播放" otherButtonTitle:@"继续加载" complete:^{
                    [weakSelf playClick];
                } cancle:^{
                    [weakSelf turnBackPreviousViewController];
                }];
                return ;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                // wifi 2
                
            }
                break;
            default:
                break;
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
    NSLog(@"AVPlyaer dealloc");
}


@end
