//
//  HYRecipeViewController.m
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYEditRecipeViewController.h"
#import "UINavigationController+HYAdditions.h"
#import "HYRecipe.h"
#import "HYRecipesClient.h"
#import "Recipe.h"
#import "HYFavoriteCheckbox.h"

@interface HYEditRecipeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, weak) IBOutlet UIImageView *recipeImageView;
@property (nonatomic, weak) IBOutlet UITextField *recipeNameTextfield;
@property (nonatomic, weak) IBOutlet UITextField *recipeDescriptionTextfield;
@property (nonatomic, weak) IBOutlet UITextField *recipeInstructionsTextfield;
@property (nonatomic, weak) IBOutlet UISegmentedControl *recipeDifficultySegmentedControl;
@property (nonatomic, strong) UITextField *activeTextField;
@property (nonatomic, weak) IBOutlet HYFavoriteCheckbox *recipeFavoriteButton;

@end

@implementation HYEditRecipeViewController

@synthesize delegate = _delegate;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setRightBarButtonItemWithTitle:@"Done" target:self andSelector:@selector(doneButtonTapped:)];
    [self.navigationController setLeftBarButtonItemWithTitle:@"Cancel" target:self andSelector:@selector(cancelButtonTapped:)];
    if (self.create) {
        [self setTitle:@"Create"];
    }
    else {
        self.recipeNameTextfield.text = self.recipe.name;
        self.recipeDifficultySegmentedControl.selectedSegmentIndex = [self.recipe difficultyIndex];
        self.recipeInstructionsTextfield.text = self.recipe.instructions;
        self.recipeDescriptionTextfield.text = self.recipe.desc;
        self.recipeImageView.image = self.recipe.photo;
        self.recipeFavoriteButton.selected = [self.recipe isFavorite];
        [self setTitle:@"Edit"];
    }    
}

#pragma mark - Cancel button tapped
- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Form Validation
- (BOOL)formValid {
    return (self.recipeDifficultySegmentedControl.selectedSegmentIndex != -1 && ![self.recipeNameTextfield.text isEqualToString:@""]);
}

#pragma mark - Difficulty from UISegmentedControl value
- (NSInteger)difficulty {
    NSUInteger difficulty = NSNotFound;
    if (self.recipeDifficultySegmentedControl.selectedSegmentIndex != NSNotFound) {
        difficulty = self.recipeDifficultySegmentedControl.selectedSegmentIndex + 1;
    }
    return difficulty;
}

#pragma mark - Keyboard handling
#define kKeykoardHeight 160
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    // We add a toolbar to the textfield keyboard wih a button to resign it
    if(textField.inputAccessoryView == nil) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UIBarButtonItem *toolbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(keyboardShouldResign)];
        UIBarButtonItem *toolbarFlexibleWidthButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbar setTranslucent:YES];
        toolbar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        toolbar.items = @[toolbarFlexibleWidthButton,toolbarButton];
        textField.inputAccessoryView = toolbar;
    }
    
    [UIView animateWithDuration:0.250 animations:^{
        self.view.frame = CGRectMake(0, -kKeykoardHeight, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self keyboardShouldResign];
    return YES;
}

- (void)keyboardShouldResign {
    [self.activeTextField resignFirstResponder];
    [UIView animateWithDuration:0.250 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark - Photo picker
- (IBAction)takePictureButtonTapped:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        self.recipeImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }];
}

#pragma mark - Favorite button tapped
- (IBAction)favoriteButtonTapped:(HYFavoriteCheckbox *)checkbox {
    [checkbox check];
}

#pragma mark - Done button tapped
- (IBAction)doneButtonTapped:(id)sender {
    if ([self formValid]) {
        self.recipe.name = self.recipeNameTextfield.text;
        self.recipe.desc = self.recipeDescriptionTextfield.text;
        self.recipe.instructions = self.recipeInstructionsTextfield.text;
        self.recipe.difficulty = [NSNumber numberWithInt:self.recipeDifficultySegmentedControl.selectedSegmentIndex + 1];
        self.recipe.favorite = [NSNumber numberWithBool:self.recipeFavoriteButton.selected];
        self.recipe.photo = self.recipeImageView.image;
        
        // Add recipe
        if (self.create) {
            if ([self.delegate respondsToSelector:@selector(editViewController:didAddRecipe:)]) {
                [self.delegate editViewController:self didAddRecipe:self.recipe];
            }
            // Invoke add service
            [[HYRecipesClient sharedRecipesClient] startAddRecipeRequestWithRecipe:self.recipe success:^{
                
            } failure:^(NSError *error) {
                NSLog(@"Error : %@",[error description]);
            }];
        }
        // Update recipe
        else {
            NSError *error;
            if (![self.recipe.managedObjectContext save:&error]) {
                NSLog(@"Error : %@",[error description]);
                abort();
            }
            // Invoke update service
            [[HYRecipesClient sharedRecipesClient] startUpdateRecipeRequestWithRecipe:self.recipe success:^{
            } failure:^(NSError *error) {
                NSLog(@"Error : %@",[error description]);
            }];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hyper Recipes" message:@"Some info is missing" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
