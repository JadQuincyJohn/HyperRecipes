//
//  HYRecipe.m
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYRecipe.h"

@implementation HYRecipe

#pragma mark - Accessors
- (NSNumber *)identifier {
    return (NSNumber *)[self.jsonDictionary objectForKey:kRecipeIdKey];
}

- (NSString *)name {
    return (NSString *)[self.jsonDictionary objectForKey:kRecipeNameKey];
}

- (NSNumber *)difficulty {
    NSString * difficultyString = [self.jsonDictionary objectForKey:kRecipeDifficultyKey];
    NSString * difficultyChar = [difficultyString substringToIndex:1];
    return [NSNumber numberWithInteger:[difficultyChar integerValue]];
}

- (NSString *)description {
    return (NSString *)[self.jsonDictionary objectForKey:kRecipeDescriptionKey];
}

- (NSString *)instructions {
    return (NSString *)[self.jsonDictionary objectForKey:kRecipeInstructionsKey];
}

- (NSNumber *)favorite {
    NSNumber * favorite = @0;
    id num = [self.jsonDictionary objectForKey:kRecipeFavoriteKey];
    if (num && [num isKindOfClass:[NSNumber class]] && [num isEqualToNumber:@1]) {
        favorite = @1;
    }
    return favorite;
}

- (UIImage *)photo {
    NSDictionary * photoDict = (NSDictionary *)[self.jsonDictionary objectForKey:kRecipePhotoKey];
    UIImage * photo = nil;
    if (photoDict) {
        NSString * photoPath = [photoDict objectForKey:kRecipeUrlKey];
        if (photoPath && ![photoPath isKindOfClass:[NSNull class]]) {
            photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoPath]]];
        }
    }
    return photo;;
}



@end
