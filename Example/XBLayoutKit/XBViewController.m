//
//  XBViewController.m
//  XBLayoutKit
//
//  Created by Xinboy on 12/05/2018.
//  Copyright (c) 2018 Xinboy. All rights reserved.
//

#import "XBViewController.h"

#import "CalendarView.h"

@interface XBViewController ()

@property (nonatomic, strong) CalendarView *calendar;

@end

@implementation XBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.calendar = [[CalendarView alloc] initWithFrame:CGRectMake(0, 300, 300, 300)];
    self.calendar.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.calendar];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
