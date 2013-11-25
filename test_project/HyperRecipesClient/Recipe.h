//
//  Recipe.h
//  HyperRecipesClient
//
//  Created by Jad on 20/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HYRecipe.h"

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * identifier;

#pragma mark - Formatters
- (NSUInteger)difficultyIndex;
- (NSString *)formattedDifficulty;
#pragma mark - Conversions
- (NSDictionary *)recipeToJSONRecipe;
- (void) fillFromJSONRecipe:(HYRecipe *)jsonRecipe;
#pragma mark - Utils
- (BOOL)isFavorite;

@end
