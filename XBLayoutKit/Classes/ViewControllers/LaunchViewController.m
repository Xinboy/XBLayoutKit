//
//  LuaViewController.m
//  XBKit
//
//  Created by Xinbo Hong on 2018/8/16.
//  Copyright © 2018年 Xinbo. All rights reserved.
//

//未完成
#import "LaunchViewController.h"
#import <SDWebImage.h>

#import "XBCategoryKit.h"

@interface LaunchViewController ()

@property (nonatomic, strong) UIViewController *rootVC;

@property (nonatomic, assign) ShowType type;
#pragma mark --- 广告 ---
@property (nonatomic, strong) NSTimer *adTimer;

@property (nonatomic, strong) UIImageView *adImageView;

@property (nonatomic, strong) UILabel *timeLabel;

#pragma mark --- 广告 ---
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation LaunchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (self.type) {
        case ShowTypeAD:
            [self setupAdUI];
            self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(initTimer) userInfo:nil repeats:true];
            self.nextButton.hidden = true;
            break;
        case ShowTypeNewVersion:
            [self setupNetVersionUI];
            break;
    }
}

#pragma mark --- Public Methods ---
#pragma mark --- Target Methods ---
#pragma mark --- Private Methods ---
- (instancetype)initWithRootVC:(UIViewController *)rootVC viewControllerType:(ShowType)showType {
    
    self = [super init];
    if (self) {
        self.rootVC = rootVC;
        self.type = showType;
        
        self.adTime = 3;
        self.canSkipAd = true;
    }
    return self;
}

#pragma mark --- 广告页 ---
- (void)setupAdUI {
    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.frame = self.view.bounds;
    self.adImageView.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdVC:)];
    [self.adImageView addGestureRecognizer:tap];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.frame = CGRectMake(self.view.frame.size.width - 120, 40, 100, 40);
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.layer.masksToBounds = true;
    self.timeLabel.layer.cornerRadius = 12.0;
    
    
    if (self.isCanSkipAd) {
        self.timeLabel.userInteractionEnabled = true;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToRootVC:)];
        [self.adImageView addGestureRecognizer:tap1];
    } else {
        self.timeLabel.userInteractionEnabled = false;
    }
    
    [self.view addSubview:self.adImageView];
    [self.view addSubview:self.timeLabel];
}

- (void)initTimer {
    if (self.isCanSkipAd) {
        self.timeLabel.text = [NSString stringWithFormat:@"跳过(%1f)",self.adTime];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"剩余(%1f)",self.adTime];
    }
    self.adTime--;
    if (self.adTime < 0) {
        [self.adTimer invalidate];
        self.view.window.rootViewController = self.rootVC;
    }
}

- (void)pushToRootVC {
    if (self.adTimer != nil) {
        [self.adTimer invalidate];
        self.adTimer = nil;
    }
    self.view.window.rootViewController = self.rootVC;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    @weakify(self)
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed: self.localImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.view addSubview:self.timeLabel];
        [self.view bringSubviewToFront:self.timeLabel];
        [self.adTimer fire];
        self.adImageView.image = image;
    }];
}

- (void)pushToAdVC:(UITapGestureRecognizer *)sender {
    [self.adTimer invalidate];
    
}

#pragma mark --- 新版本介绍 ---
- (void)setupNetVersionUI {
    UIScrollView *pageView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    pageView.pagingEnabled = true;
    pageView.showsHorizontalScrollIndicator = false;
    pageView.showsVerticalScrollIndicator = false;
    pageView.bounces = false;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    BOOL isUrlImage = false;
    if (self.imagesURLArray.count == 0 &&self.imagesLocalArray.count != 0) {
        tempArray = self.imagesLocalArray.mutableCopy;
        isUrlImage = false;
    }
    if (self.imagesURLArray.count != 0) {
        tempArray = self.imagesURLArray.mutableCopy;
        isUrlImage = true;
    }
    //加载本地图片
    pageView.contentSize = CGSizeMake(self.view.frame.size.width * tempArray.count, self.view.frame.size.height);
    for (int i = 0; i < tempArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        if (isUrlImage) {
            [imageView sd_setImageWithURL:tempArray[i] placeholderImage:nil];
        } else {
            imageView.image = [UIImage imageNamed:tempArray[i]];
        }
        
        if (i == tempArray.count - 1) {
            [imageView addSubview:self.nextButton];
        }
        [pageView addSubview:imageView];
    }
    [self.view addSubview:pageView];
    [self.view addSubview:self.pageControl];
}

-(UIButton *)nextButton {
    if (!_nextButton) {
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextButton.frame = CGRectMake(self.view.frame.size.width / 2 - 60, self.view.frame.size.height - 120, 120, 40);
        self.nextButton.tintColor = [UIColor lightGrayColor];
        [self.nextButton setImage:[UIImage imageNamed:@"进入应用"] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(pushToRootVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIPageControl *)pageControl {
    if (_pageControl) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width - 40, self.view.frame.size.width, 40)];
        self.pageControl.currentPage = 0;
        //设置当前页指示器的颜色
        self.pageControl.currentPageIndicatorTintColor =[UIColor blueColor];
        //设置指示器的颜色
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
