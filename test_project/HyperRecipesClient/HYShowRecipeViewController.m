//
//  HYShowRecipeViewController.m
//  HyperRecipesClient
//
//  Created by Jad on 19/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYShowRecipeViewController.h"
#import "UINavigationController+HYAdditions.h"
#import "HYEditRecipeViewController.h"
#import "HYViewController.h"
#import "HYFavoriteCheckbox.h"
#import "HYConstants.h"
#import "HYShowRecipeViewControllerHeaderView.h"
#import "HYShowRecipeTableViewCell.h"
#import "UILabel+HYAdditions.h"

@interface HYShowRecipeViewController ()

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

@implementation HYShowRecipeViewController

@synthesize tableView = _tableView;

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = hyperOrangeColor;
    self.view.backgroundColor = hyperCellColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    [self setupHeader];
    [self.tableView reloadData];
}

- (void)setupHeader {
    HYShowRecipeViewControllerHeaderView * headerView = nil;
    if (self.tableView.tableHeaderView == nil) {
        NSString * nibName = NSStringFromClass([HYShowRecipeViewControllerHeaderView class]);
        self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    }
    headerView = (HYShowRecipeViewControllerHeaderView *) self.tableView.tableHeaderView;
    headerView.recipeNameLabel.text = self.recipe.name;
    headerView.recipeFavoriteButton.selected = [self.recipe isFavorite];
    headerView.recipeFavoriteButton.userInteractionEnabled = NO;
    headerView.recipeImageView.image = self.recipe.photo;
}

#pragma mark - UITableViewDataSource & Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    headerView.backgroundColor = hyperBlackColor;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width - 20, 20)];
    switch (section) {
        case 0:
            titleLabel.text = @"Difficulty";
            break;
        case 1:
            titleLabel.text = @"Description";
            break;
        case 2:
            titleLabel.text = @"Instructions";
            break;
        default:
            break;
    }

    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = hyperBlackColor;
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    
   [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRowAtIndexPath = 0.0;
    HYShowRecipeTableViewCell * showRecipeCell = (HYShowRecipeTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    heightForRowAtIndexPath = [showRecipeCell.label idealSize].height;
    return heightForRowAtIndexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = hyperCellColor;
}

#pragma mark - Cell Configuration
- (void)configureCell:(HYShowRecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            cell.label.text = self.recipe.formattedDifficulty;
            break;
        case 1:
            cell.label.text = self.recipe.desc;
            break;
        case 2:
            cell.label.text = self.recipe.instructions;
            break;
        default:
            break;
    }
    // Multi lines support
    cell.label.numberOfLines = 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYShowRecipeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYShowRecipeTableViewCell class])];
    if (!cell) {
        cell = [[HYShowRecipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HYShowRecipeTableViewCell class])];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Prepare Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UpdateRecipeSegueIdentifier"]) {
        UINavigationController * navigationController = segue.destinationViewController;
		HYEditRecipeViewController * editRecipeViewController = (HYEditRecipeViewController *) navigationController.topViewController;
        editRecipeViewController.recipe = self.recipe;
	}
}



@end
