//
//  Recipe.m
//  HyperRecipesClient
//
//  Created by Jad on 20/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "Recipe.h"
#import "HYRecipe.h"


@implementation Recipe

@dynamic name;
@dynamic desc;
@dynamic instructions;
@dynamic difficulty;
@dynamic photo;
@dynamic favorite;
@dynamic identifier;

#pragma mark - Formatters
- (NSUInteger)difficultyIndex {
    return [self.difficulty intValue] - 1;
}

- (NSString *)formattedDifficulty {
    NSString * formattedDifficulty = nil;
    switch ([self.difficulty intValue]) {
        case 1:
            formattedDifficulty = @"Easy";
            break;
        case 2:
            formattedDifficulty = @"Medium";
            break;
        case 3:
            formattedDifficulty = @"Hard";
            break;
        default:
            break;
    }
    return formattedDifficulty;
}

#pragma mark - Conversions
- (NSDictionary *) recipeToJSONRecipe {
    NSMutableDictionary * jsonDictionnary = [[NSMutableDictionary alloc] init];
    [jsonDictionnary setObject:self.name forKey:@"name"];
    [jsonDictionnary setObject:self.desc forKey:@"description"];
    [jsonDictionnary setObject:self.instructions forKey:@"instructions"];
    [jsonDictionnary setObject:self.difficulty forKey:@"difficulty"];
    [jsonDictionnary setObject:self.favorite forKey:@"favorite"];
    HYRecipe * jsonRecipe = [HYRecipe objectWithJsonDictionary:jsonDictionnary];
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:jsonRecipe.jsonDictionary,@"recipe", nil];
}

- (void) fillFromJSONRecipe:(HYRecipe *)jsonRecipe {
    self.identifier = jsonRecipe.identifier;
    self.difficulty = jsonRecipe.difficulty;
    self.name = jsonRecipe.name;
    self.desc = jsonRecipe.description;
    self.instructions = jsonRecipe.instructions;
    self.favorite = jsonRecipe.favorite;
    self.photo = jsonRecipe.photo;
}

#pragma mark - Utils
- (BOOL)isFavorite {
    return [self.favorite isEqualToNumber:@1];
}



@end
