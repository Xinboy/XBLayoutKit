//
//  GuidePageView.m
//  GuideView
//
//  Created by Xinbo Hong on 2019/8/27.
//  Copyright © 2019 com.xinbo.pro. All rights reserved.
//

#import "GuidePageView.h"
#import "XB_GifImageOperation.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define kHIDDEN_TIME   3.0
#define kSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

@interface GuidePageView ()<UIScrollViewDelegate>

/// 引导页容器
@property (nonatomic, strong) UIScrollView *scrollView;
/// 进入首页按钮(左上角)
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIPageControl *imagePageControl;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger slideIntoNumber;

@property (nonatomic, strong) AVPlayerViewController *avPlayerController;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) MPMoviePlayerController *mpPlayerController;
#pragma clang diagnostic pop

@end



@implementation GuidePageView

- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden {
    self = [super initWithFrame:frame];
    if (self) {
        //默认为NO
        self.canSliderInto = NO;

        
         self.imageArray = imageNameArray;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.backgroundColor = [UIColor lightGrayColor];
        self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * imageNameArray.count, kSCREEN_HEIGHT);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.skipButton.frame = CGRectMake(kSCREEN_WIDTH * 0.8, kSCREEN_HEIGHT * 0.1, 50, 25);
        self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [self.skipButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.skipButton.layer.cornerRadius = self.skipButton.frame.size.height * 0.5;
        [self.skipButton addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.skipButton];
        
        
        // 添加在引导视图上的多张引导图片
            
        for (int i = 0; i < imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(kSCREEN_WIDTH * i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
            if ([[XB_GifImageOperation contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]]] isEqualToString:@"gif"]) {
                NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]];
                imageView = (UIImageView *)[[XB_GifImageOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
                [self.scrollView addSubview:imageView];
            } else {
                imageView.image = [UIImage imageNamed:imageNameArray[i]];
                [self.scrollView addSubview:imageView];
            }
            
            // 设置在最后一张图片上显示进入体验按钮
            if (i == imageNameArray.count - 1 && isHidden == YES) {
                imageView.userInteractionEnabled = YES;
                
                UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
                startButton.frame = CGRectMake(kSCREEN_WIDTH * 0.3, kSCREEN_HEIGHT * 0.8, kSCREEN_WIDTH * 0.4, kSCREEN_HEIGHT * 0.08);
                startButton.titleLabel.font = [UIFont systemFontOfSize:21];
                startButton.backgroundColor = [UIColor orangeColor];
                [startButton setTitle:@"开始体验" forState:UIControlStateNormal];
                [startButton setTitleColor:[UIColor colorWithRed:164 / 255.0 green:201 / 255.0 blue:67 / 255.0 alpha:1.0] forState:UIControlStateNormal];
                [startButton addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:startButton];
            }
        }
        
        // 设置引导页上的页面控制器
        self.imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH * 0.0, kSCREEN_HEIGHT * 0.9, kSCREEN_WIDTH * 1.0, kSCREEN_HEIGHT * 0.1)];
        self.imagePageControl.currentPage = 0;
        self.imagePageControl.numberOfPages = imageNameArray.count;
        self.imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.imagePageControl];
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 视频引导页进入按钮
        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kSCREEN_HEIGHT-30-40, kSCREEN_WIDTH-40, 40)];
        [movieStartButton.layer setBorderWidth:1.0];
        [movieStartButton.layer setCornerRadius:20.0];
        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [movieStartButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [movieStartButton setAlpha:0.0];
        
        
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 9.0) {
            
            self.avPlayerController = [[AVPlayerViewController alloc] init];
            self.avPlayerController.player = [[AVPlayer alloc] initWithURL:videoURL];
            self.avPlayerController.view.frame = frame;
            self.avPlayerController.showsPlaybackControls = NO;
            self.avPlayerController.view.userInteractionEnabled = YES;
            
            [self addSubview:self.avPlayerController.view];
            [self addSubview:movieStartButton];
            
            [self.avPlayerController.player play];
            
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            self.mpPlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            [self.mpPlayerController.view setFrame:frame];
            [self.mpPlayerController.view setAlpha:1.0];
            [self.mpPlayerController setControlStyle:MPMovieControlStyleNone];
            [self.mpPlayerController setRepeatMode:MPMovieRepeatModeOne];
            [self.mpPlayerController setShouldAutoplay:YES];
            [self.mpPlayerController prepareToPlay];
            
            [self addSubview:self.mpPlayerController.view];
            [self.mpPlayerController.view addSubview:movieStartButton];
#pragma clang diagnostic pop
        }
        
        
        
        [movieStartButton addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:kHIDDEN_TIME animations:^{
            [movieStartButton setAlpha:1.0];
        }];
    }
    return self;
}




#pragma mark - --- UIScrollViewDelegate ---
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (self.imageArray && page == self.imageArray.count - 1 && self.isCanSliderInto == NO) {
        [self skipAction:nil];
    }
    
    // 最后一页，支持滑动想右滑动
    if (self.imageArray && page == self.imageArray.count - 1 && self.isCanSliderInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self skipAction:nil];
            }
        }
    }
    
    if (self.imageArray && page < self.imageArray.count - 1 && self.isCanSliderInto == YES) {
        self.slideIntoNumber = 1;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 四舍五入,保证pageControl状态跟随手指滑动及时刷新
    [self.imagePageControl setCurrentPage:(int)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5f)];
}


#pragma mark - --- private functions ---
- (void)skipAction:(UIButton *)sender {
    [UIView animateWithDuration:kHIDDEN_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHIDDEN_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:1];
        });
    }];
}

- (void)removeGuidePage {
    NSLog(@"remove");
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
