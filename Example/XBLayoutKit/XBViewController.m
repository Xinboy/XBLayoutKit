//
//  XBViewController.m
//  XBLayoutKit
//
//  Created by Xinboy on 12/05/2018.
//  Copyright (c) 2018 Xinboy. All rights reserved.
//

#import "XBViewController.h"

#import "CalendarView.h"

#import "PasswordView.h"

@interface XBViewController ()

@property (nonatomic, strong) CalendarView *calendar;

@property (nonatomic, strong) PasswordView *pwdView;

@end

@implementation XBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.calendar = [[CalendarView alloc] initWithFrame:CGRectMake(0, 300, 300, 300)];
    self.calendar.backgroundColor = [UIColor redColor];
    
//    [self.view addSubview:self.calendar];
    
    
    self.pwdView = [[PasswordView alloc] init];
    self.pwdView.frame = CGRectMake(0, 300, 300, 40);
    [self.pwdView frameWithNumberCount:4 NumberSpace:2];
    [self.view addSubview:self.pwdView];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
