//
//  HYRecipeTableViewCell.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYRecipeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView * favoriteImageView;

@end
