//
//  RAPagingTransition.h
//  RAPagingTransition-Demo
//
//  Created by Ryo Aoyama on 3/14/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAPagingPushTransitionAnimator, RAPagingPopTransitionAnimator, RAPagingInteractiveTransitionAnimator;

@interface RAPagingTransition: NSObject

@property (nonatomic, assign) CFTimeInterval transitionDuration; /* Default is 0.25 */
@property (nonatomic, assign) CGFloat pageSpacing; /* Default is 30.0 */
@property (nonatomic, strong) UIView *backgroundView; /* Default is nil */
@property (nonatomic, assign) BOOL interactionEnabled; /* Default is NO */

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (RAPagingPushTransitionAnimator *)pushTransitionAnimator;
- (RAPagingPopTransitionAnimator *)popTransitionAnimator;
- (RAPagingInteractiveTransitionAnimator *)interactiveTransitionAnimator;

@end


/**
 *  Apply Non-Animation. It's base class.
 **/
@interface RAPagingTransitionAnimator: NSObject
<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CFTimeInterval transitionDuration; /* Default is 0.25 */
@property (nonatomic, assign) CGFloat pageSpacing; /* Default is 30.0 */
@property (nonatomic, strong) UIView *backgroundView; /* Default is nil */

@end

/**
 *  Apply Push-Animation.
 **/
@interface RAPagingPushTransitionAnimator: RAPagingTransitionAnimator

@end

/**
*   Apply Pop-Animation.
**/
@interface RAPagingPopTransitionAnimator: RAPagingTransitionAnimator

@end

/**
*   Interractive transition.
**/
@interface RAPagingInteractiveTransitionAnimator : UIPercentDrivenInteractiveTransition;

@property (nonatomic, weak) UIViewController *viewController;

@end