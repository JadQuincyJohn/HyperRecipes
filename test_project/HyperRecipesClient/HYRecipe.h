//
//  HYRecipe.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYObject.h"

#define kRecipeIdKey @"id"
#define kRecipeNameKey @"name"
#define kRecipeDifficultyKey @"difficulty"
#define kRecipeDescriptionKey @"description"
#define kRecipeInstructionsKey @"instructions"
#define kRecipeFavoriteKey @"favorite"
#define kRecipePhotoKey @"photo"
#define kRecipeUrlKey @"url"


@interface HYRecipe : HYObject

#pragma mark - Properties
@property (nonatomic, readonly) NSNumber * identifier;
@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSNumber * difficulty;
@property (nonatomic, readonly) NSString * description;
@property (nonatomic, readonly) NSString * instructions;
@property (nonatomic, readonly) NSNumber * favorite;
@property (nonatomic, readonly) UIImage * photo;

@end
