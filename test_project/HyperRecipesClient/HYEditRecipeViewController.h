//
//  HYRecipeViewController.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Recipe;
@class HYEditRecipeViewController;

#pragma mark - HYAddRecipeDelegate protocol
@protocol HYEditRecipeViewControllerDelegate<NSObject>
- (void)editViewController:(HYEditRecipeViewController *)controller didAddRecipe:(Recipe *)recipe;
@end

@interface HYEditRecipeViewController : UIViewController

@property (nonatomic, strong) Recipe * recipe;
@property (nonatomic, assign) BOOL create;
@property (nonatomic, weak) id <HYEditRecipeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
