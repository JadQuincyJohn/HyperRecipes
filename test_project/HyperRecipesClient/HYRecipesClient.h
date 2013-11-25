//
//  HYRecipesClient.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "HYRecipe.h"
#import "Recipe.h"

// URLs
#define kHyperServerBaseURL @"http://hyper-recipes.herokuapp.com/"
#define kHyperRecipesURL @"recipes"

// Parsing
#define kHyperRecipeKey @"recipe"


@interface HYRecipesClient : AFHTTPClient

#pragma mark Singleton
+ (HYRecipesClient *)sharedRecipesClient;

#pragma mark - Get Recipes
- (void)startRecipesRequestWithSuccess:(void (^)(NSMutableArray * recipesArray))success failure:(void (^)(NSError *error))failure;
#pragma mark - Add Recipe
- (void)startAddRecipeRequestWithRecipe:(Recipe *)recipe success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
#pragma mark - Update Recipe
- (void)startUpdateRecipeRequestWithRecipe:(Recipe *)recipe success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
#pragma mark - Delete Recipe
- (void)startDeleteRecipeRequestWithIdentifier:(NSNumber *)identifier success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
