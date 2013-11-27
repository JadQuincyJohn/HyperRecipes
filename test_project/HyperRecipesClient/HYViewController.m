//
//  HYViewController.m
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYViewController.h"
#import "HYEditRecipeViewController.h"
#import "HYShowRecipeViewController.h"
#import "HYRecipesClient.h"
#import "HYRecipe.h"
#import "HYRecipeTableViewCell.h"
#import "Recipe.h"
#import "iCarousel.h"
#import "HYConstants.h"


@interface HYViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end

@implementation HYViewController

@synthesize carousel = _carousel;

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Fetch Recipe Data
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error :%@", [error description]);
        abort();
    }
    [self loadRecipesFromWebService];
    // Carousel Type
    self.carousel.type = iCarouselTypeCoverFlow;
    [self.carousel reloadData];
    // Table view background
    self.tableView.backgroundColor = hyperCellColor;
}

#pragma mark - Load Recipes from WS
- (void)loadRecipesFromWebService {
    [[HYRecipesClient sharedRecipesClient] startRecipesRequestWithSuccess:^(NSMutableArray *recipesArray) {
        
        NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundMOC.parentContext = self.managedObjectContext;

        [backgroundMOC performBlock:^{
            NSFetchRequest * allRecipes = [[NSFetchRequest alloc] init];
            [allRecipes setEntity:[NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:backgroundMOC]];
            [allRecipes setIncludesPropertyValues:NO];
            NSError * fetchAllError = nil;
            NSArray * recipes = [self.managedObjectContext executeFetchRequest:allRecipes error:&fetchAllError];
            // Delete recipes by getting the ids to remove
            NSMutableArray * array = [NSMutableArray array];
            for (NSManagedObject * recipe in recipes) {
                 [array addObject:recipe.objectID];
            }
            for (int i = 0; i < [array count]; i++) {
                NSManagedObject * recipe = [backgroundMOC objectWithID:[array objectAtIndex:i]];
                [backgroundMOC deleteObject:recipe];
            }
            
            // Create / Fill recipe data
            for (HYRecipe * rec in recipesArray) {
                Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:backgroundMOC];
                [newRecipe fillFromJSONRecipe:rec];
            }
            
            // Save insertions
            NSError *insertionError = nil;
            if (![backgroundMOC save:&insertionError]) {
                NSLog(@"Error %@: ", [insertionError description]);
                abort();
            }
            
            [backgroundMOC.parentContext performBlock:^{
                [self reloadData];
            }];
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error : %@",[error description]);
    }];
}

#pragma mark - Recipe access
- (Recipe *) recipeAtIndexPath:(NSIndexPath *) indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Cell Configuration
- (void)configureCell:(HYRecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Recipe *recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = recipe.name;
    cell.descriptionLabel.text = recipe.desc;
    
    UIImage * image = nil;
    if ([recipe isFavorite]) {
        image = [UIImage imageNamed:@"favorite_selected"];
    }
    cell.favoriteImageView.image = image;
}

#pragma mark - UITableViewDataSource & Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = hyperCellColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYRecipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYRecipeTableViewCell class])];
    if (!cell) {
        cell = [[HYRecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HYRecipeTableViewCell class])];
        UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        bView.backgroundColor = hyperOrangeColor;
        cell.selectedBackgroundView = bView;
        
        
        
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Background MOC
        NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundMOC.parentContext = self.managedObjectContext;
        // Save the identifier paramaeter
        NSNumber * identifierToDelete = [self recipeAtIndexPath:indexPath].identifier;
        Recipe * recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObjectID * recipeID = recipe.objectID;
        
        [backgroundMOC performBlock:^{
            NSManagedObject * recipe = [backgroundMOC objectWithID:recipeID];
            [backgroundMOC deleteObject:recipe];

            NSError *error;
            if (![backgroundMOC save:&error]) {
                NSLog(@"Error : %@",[error description]);
                abort();
            }
            [backgroundMOC.parentContext performBlock:^{
                [self reloadData];
            }];
        }];

        [[HYRecipesClient sharedRecipesClient] startDeleteRecipeRequestWithIdentifier:identifierToDelete success:^{
            NSLog(@"Success deleting recipe : %@", identifierToDelete);
        } failure:^(NSError *error) {
            NSLog(@"Error : %@",[error description]);
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.carousel scrollToItemAtIndex:indexPath.row animated:YES];
}

#pragma mark - NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Sorting descriptors
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
    }
	return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(HYRecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

#pragma mark Prepare segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowRecipeSegueIdentifier"]) {
		HYShowRecipeViewController * showRecipeViewController = (HYShowRecipeViewController *) segue.destinationViewController;
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
		showRecipeViewController.recipe = [self recipeAtIndexPath:indexPath];
	}
    else if ([segue.identifier isEqualToString:@"AddRecipeSegueIdentifier"]) {
        UINavigationController * navigationController = segue.destinationViewController;
        HYEditRecipeViewController * editRecipeViewController = (HYEditRecipeViewController *) navigationController.topViewController;
                
        NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [addingContext setParentContext:[self.fetchedResultsController managedObjectContext]];
        
        Recipe *recipe = (Recipe *)[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:addingContext];
        editRecipeViewController.recipe = recipe;
        editRecipeViewController.create = YES;
        editRecipeViewController.delegate = self;
        editRecipeViewController.managedObjectContext = addingContext;
	}
}

#pragma mark - HYEditRecipeViewControllerDelegate protocol
- (void)editViewController:(HYEditRecipeViewController *)controller didAddRecipe:(Recipe *)recipe {
    if (recipe) {

        NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundMOC.parentContext = self.managedObjectContext;
        
        [backgroundMOC performBlock:^{
            NSError *error;
            NSManagedObjectContext *addingManagedObjectContext = [controller managedObjectContext];
            if (![addingManagedObjectContext save:&error]) {
                NSLog(@"Error : %@", [error description]);
                abort();
            }
            
            if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
                NSLog(@"Error : %@", [error description]);
                abort();
            }
            
            [self.managedObjectContext performBlock:^{
                [self reloadData];
            }];
        }];
    }
}

#pragma mark - Reload Data
- (void) reloadData {
    [self.tableView reloadData];
    [self.carousel reloadData];
}

#pragma mark - iCarousel DataSource & Delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.tableView numberOfRowsInSection:0];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    Recipe * recipe = [self recipeAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 160.0f)];
        view.contentMode  = UIViewContentModeScaleAspectFit;
        ((UIImageView *)view).image = recipe.photo;
        view.tag = 1;
    }
    else {
        view = (UIView *)[view viewWithTag:1];
    }
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    [self.tableView reloadData];
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.carousel.currentItemIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Remove Carousel Item
- (void)removeItemAtIndex:(NSInteger)index {
    if (self.carousel.numberOfItems > 0)    {
        [self.carousel removeItemAtIndex:index animated:YES];
    }
}

@end
