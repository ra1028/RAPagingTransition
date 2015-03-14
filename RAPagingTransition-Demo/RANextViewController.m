//
//  RANextViewController.m
//  RAAlternationTransition-Demo
//
//  Created by Ryo Aoyama on 3/14/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

#import "RANextViewController.h"
#import "RAPagingTransition.h"

@interface RANextViewController ()
@property (nonatomic, strong) UIButton *popButton;
@end

@implementation RANextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.popButton.center = self.view.center;
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor greenColor];
    
    self.popButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.popButton.frame = CGRectMake(0, 0, 100, 50);
    [self.popButton setTitle:@"Pop" forState:UIControlStateNormal];
    [self.popButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.popButton addTarget:self action:@selector(popToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.popButton atIndex:0];
}

- (void)popToPreviousView
{
    self.transition.interactionEnabled = false;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
