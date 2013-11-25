//
//  HYShowRecipeViewControllerHeaderView.h
//  HyperRecipesClient
//
//  Created by Jad on 25/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFavoriteCheckbox.h"

@interface HYShowRecipeViewControllerHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *recipeImageView;
@property (nonatomic, weak) IBOutlet UILabel *recipeNameLabel;
@property (nonatomic, weak) IBOutlet HYFavoriteCheckbox *recipeFavoriteButton;

@end
