//
//  HYFavoriteCheckbox.h
//  HyperRecipesClient
//
//  Created by Jad on 22/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYFavoriteCheckbox : UIButton


@property (nonatomic, assign, getter = isChecked) BOOL checked;

- (void)setChecked:(BOOL)checked;
- (void)check;
@end
