//
//  RAStartViewController.m
//  RAAlternationTransition-Demo
//
//  Created by Ryo Aoyama on 3/14/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

#import "RAStartViewController.h"
#import "RANextViewController.h"

@interface RAStartViewController ()
@property (nonatomic, strong) UIButton *pushButton;
@end

@implementation RAStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.pushButton.center = self.view.center;
}

- (void)configureView
{
    self.pushButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.pushButton.frame = CGRectMake(0, 0, 100, 50);
    [self.pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [self.pushButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pushButton addTarget:self action:@selector(pushToNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.pushButton atIndex:0];
}

- (void)pushToNextPage
{
    RANextViewController *controller = [[RANextViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
