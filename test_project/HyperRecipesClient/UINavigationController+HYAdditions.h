//
//  UINavigationController+HYAdditions.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HYAdditions)

- (void)setLeftBarButtonItemWithTitle:(NSString *)title target:(id)target andSelector:(SEL)selector;
- (void)setRightBarButtonItemWithTitle:(NSString *)title target:(id)target andSelector:(SEL)selector;

@end
