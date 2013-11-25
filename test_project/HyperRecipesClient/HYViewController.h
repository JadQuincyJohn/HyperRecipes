//
//  HYViewController.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HYEditRecipeViewController.h"
#import "iCarousel.h"

@interface HYViewController : UIViewController<NSFetchedResultsControllerDelegate, HYEditRecipeViewControllerDelegate, iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
