//
//  SlipViewController.m
//  XBCodingRepo
//
//  Created by Xinbo Hong on 2018/4/11.
//  Copyright © 2018年 Xinbo Hong. All rights reserved.
//

#import "SlipViewController.h"

#define SELF_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface SlipViewController ()

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *mainView;

@end

@implementation SlipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slipViewPanGestureRecognizerAction:)];
    [self.view addGestureRecognizer:panGes];
    
    [self initAllSubviews];
}

#pragma mark - **************** Event response methods
- (void)slipViewPanGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    CGFloat xNew = point.x;
    self.mainView.frame = CGRectMake(xNew + self.mainView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [sender setTranslation:CGPointZero inView:self.view];
    
    //优化mainView无限在屏幕外移动
    __block CGRect rect = self.mainView.frame;
    if (self.rightView.isHidden) {
        //mainView视图在右边
        [UIView animateWithDuration:0.25 animations:^{
            if (rect.origin.x > SELF_WIDTH) {
                rect.origin.x = SELF_WIDTH;
            }
//            if (rect.origin.x > SELF_WIDTH / 3 * 2) {
//                rect.origin.x = SELF_WIDTH;
//            } else if (rect.origin.x < SELF_WIDTH / 3) {
//                rect.origin.x = 0;
//            }
            self.mainView.frame = rect;
        }];
    } else {
        //mainView视图在左边
        [UIView animateWithDuration:0.25 animations:^{
//            if (rect.origin.x < -SELF_WIDTH / 3 * 2) {
//                rect.origin.x = -SELF_WIDTH;
//            } else if (rect.origin.x > -SELF_WIDTH / 3) {
//                rect.origin.x = 0;
//            }
            if (rect.origin.x < -SELF_WIDTH) {
                rect.origin.x = -SELF_WIDTH;
            }
            
            self.mainView.frame = rect;
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.mainView.frame.origin.x > 0) {
        self.rightView.hidden = YES;
    } else if (self.mainView.frame.origin.x < 0) {
        self.rightView.hidden = NO;
    }
}
#pragma mark - **************** UIView frame / masonry methods
- (void)initAllSubviews {
    self.leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    
    self.rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    self.leftView.backgroundColor = [UIColor redColor];
    self.rightView.backgroundColor = [UIColor yellowColor];
    self.mainView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
    [self.view addSubview:self.mainView];
}
#pragma mark - **************** Getter and setter

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
