//
//  RAPagingTransition.m
//  RAPagingTransition-Demo
//
//  Created by Ryo Aoyama on 3/14/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

#import "RAPagingTransition.h"

@interface RAPagingTransition ()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) RAPagingInteractiveTransitionAnimator *interactiveTransition;

@end

@implementation RAPagingTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        [self setup];
        self.viewController = viewController;
    }
    return self;
}

- (void)setInteractionEnabled:(BOOL)interactionEnabled
{
    if (interactionEnabled) {
        NSAssert(self.viewController != nil, @"viewController was not set.");
        self.interactiveTransition = [RAPagingInteractiveTransitionAnimator new];
        self.interactiveTransition.viewController = self.viewController;
    }else {
        self.interactiveTransition = nil;
    }
}

- (void)setup
{
    self.transitionDuration = 0.25;
    self.pageSpacing = 30.0;
}

- (RAPagingPushTransitionAnimator *)pushTransitionAnimator
{
    self.interactiveTransition = nil;
    
    RAPagingPushTransitionAnimator *pushTransition = [RAPagingPushTransitionAnimator new];
    pushTransition.transitionDuration = self.transitionDuration;
    pushTransition.pageSpacing = self.pageSpacing;
    pushTransition.backgroundView = self.backgroundView;
    return pushTransition;
}

- (RAPagingPopTransitionAnimator *)popTransitionAnimator
{
    RAPagingPopTransitionAnimator *popTransition = [RAPagingPopTransitionAnimator new];
    popTransition.transitionDuration = self.transitionDuration;
    popTransition.pageSpacing = self.pageSpacing;
    popTransition.backgroundView = self.backgroundView;
    return popTransition;
}

- (RAPagingInteractiveTransitionAnimator *)interactiveTransitionAnimator
{
    return self.interactiveTransition;
}

@end



@interface RAPagingTransitionAnimator ()

- (void)applyAnimationWithContainer:(UIView *)container fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC completion:(void (^)())completion;

@end

@implementation RAPagingTransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        // initialize
        self.transitionDuration = 0.25;
        self.pageSpacing = 30.0;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    if (self.backgroundView) {
        [containerView insertSubview:self.backgroundView atIndex:0];
    }
    
    [self applyAnimationWithContainer:containerView fromVC:fromVC toVC:toVC completion:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)applyAnimationWithContainer:(UIView *)container fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC completion:(void (^)())completion
{
    // Needs override
    [container bringSubviewToFront:toVC.view];
    completion();
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2;
}

- (void)pagingAnimationWithFromView:(UIView *)fromView toView:(UIView *)toView reverse:(BOOL)reverse completion:(void (^)())completion
{
    CGFloat containerWidth = CGRectGetWidth(fromView.superview.bounds);
    CGFloat xOrigin = containerWidth + self.pageSpacing;
    toView.transform = CGAffineTransformMakeTranslation((reverse ? -xOrigin : xOrigin), 0);
    
    [UIView animateWithDuration:self.transitionDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toView.transform = CGAffineTransformIdentity;
        fromView.transform = CGAffineTransformMakeTranslation((reverse ? xOrigin : -xOrigin), 0);
    } completion:^(BOOL finished) {
        
        toView.transform = CGAffineTransformIdentity;
        fromView.transform = CGAffineTransformIdentity;
        if (self.backgroundView) {
            [self.backgroundView removeFromSuperview];
        }
        if (completion) {
            completion();
        }
    }];
}

@end



@implementation RAPagingPushTransitionAnimator

- (void)applyAnimationWithContainer:(UIView *)container fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC completion:(void (^)())completion
{
    [self pagingAnimationWithFromView:fromVC.view toView:toVC.view reverse:NO completion:completion];
}
@end



@implementation RAPagingPopTransitionAnimator

- (void)applyAnimationWithContainer:(UIView *)container fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC completion:(void (^)())completion
{
    [self pagingAnimationWithFromView:fromVC.view toView:toVC.view reverse:YES completion:completion];
}

@end



@interface RAPagingInteractiveTransitionAnimator ()

@property (nonatomic, weak) UIScreenEdgePanGestureRecognizer *leftEdgePangesture;

@end

@implementation RAPagingInteractiveTransitionAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.completionSpeed = 0.6;
        self.completionCurve = UIViewAnimationCurveLinear;
    }
    return self;
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    
    if (viewController) {
        UIScreenEdgePanGestureRecognizer *leftEdgePangesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePangesture:)];
        leftEdgePangesture.edges = UIRectEdgeLeft;
        [viewController.view addGestureRecognizer:leftEdgePangesture];
        self.leftEdgePangesture = leftEdgePangesture;
    }
}

- (void)dealloc
{
    if (self.viewController) {
        [self.viewController.view removeGestureRecognizer:self.leftEdgePangesture];
    }
}

- (void)handleLeftEdgePangesture:(UIScreenEdgePanGestureRecognizer *)pangesture
{
    if (!self.viewController) {
        return;
    }
    
    CGFloat percentage = [pangesture translationInView:self.viewController.view].x / CGRectGetWidth(self.viewController.view.bounds);
    percentage = MAX(0, MIN(1.0, percentage));

    switch (pangesture.state) {
        case UIGestureRecognizerStateBegan:
            
            [self.viewController.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            
            [self updateInteractiveTransition:percentage];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            
            if (percentage >= 0.4) {
                [self finishInteractiveTransition];
                [self.viewController.view removeGestureRecognizer:self.leftEdgePangesture];
            }else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end