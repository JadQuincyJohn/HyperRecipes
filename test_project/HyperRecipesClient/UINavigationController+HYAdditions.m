//
//  UINavigationController+HYAdditions.m
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "UINavigationController+HYAdditions.h"
#import "HYConstants.h"

@implementation UINavigationController (HYAdditions)

- (void)setCustomLeftButton:(UIButton *)leftButton withTarget:(id)target andSelector:(SEL)selector {
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.topViewController.navigationItem setLeftBarButtonItem:barBackButtonItem animated:YES];
}

- (void)setLeftBarButtonItemWithTitle:(NSString *)title target:(id)target andSelector:(SEL)selector {
    UIButton *customLeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [customLeftButton setTitleColor:hyperOrangeColor forState:UIControlStateNormal];
    customLeftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [customLeftButton setFrame:CGRectMake(0, 0, 60, 44)];
    [customLeftButton setTitle:title forState:UIControlStateNormal];
    [self setCustomLeftButton:customLeftButton withTarget:target andSelector:selector];
}

- (void)setCustomRightButton:(UIButton *)rightButton withTarget:(id)target andSelector:(SEL)selector {
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.topViewController.navigationItem setRightBarButtonItem:barBackButtonItem animated:YES];
}

- (void)setRightBarButtonItemWithTitle:(NSString *)title target:(id)target andSelector:(SEL)selector {
    UIButton *customRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [customRightButton setTitleColor:hyperOrangeColor forState:UIControlStateNormal];
    customRightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [customRightButton setFrame:CGRectMake(0, 0, 60, 44)];
    [customRightButton setTitle:title forState:UIControlStateNormal];
    [self setCustomRightButton:customRightButton withTarget:target andSelector:selector];
}

@end
