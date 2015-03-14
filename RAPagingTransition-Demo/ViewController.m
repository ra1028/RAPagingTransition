//
//  ViewController.m
//  RAAlternationTransition-Demo
//
//  Created by Ryo Aoyama on 3/14/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

#import "ViewController.h"
#import "RAPagingTransition.h"

@interface ViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) RAPagingTransition *transition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
    self.transition.interactionEnabled = true;
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.delegate = nil;
    [super viewDidDisappear:animated];
}

- (void)configure
{
    self.navigationController.navigationBarHidden = YES;
    self.transition = [[RAPagingTransition alloc] initWithViewController:self];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"sample.jpg"];
    imageView.alpha = 0.8;
    self.transition.backgroundView = imageView;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.transition.interactionEnabled = false;
            return [self.transition pushTransitionAnimator];
        case UINavigationControllerOperationPop:
            return [self.transition popTransitionAnimator];
        default:
            return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return [self.transition interactiveTransitionAnimator];
}

@end
