//
//  HYRecipesClient.m
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYRecipesClient.h"
#import "HYRecipe.h"
#import "AFJSONRequestOperation.h"

@implementation HYRecipesClient

#pragma mark Singleton
static HYRecipesClient *sharedRecipesClient;

+ (void)initialize {
	static BOOL initialized = NO;
	if (!initialized) {
		initialized = YES;
		sharedRecipesClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kHyperServerBaseURL]];
        sharedRecipesClient.parameterEncoding = AFJSONParameterEncoding;
	}
}
+ (HYRecipesClient *)sharedRecipesClient {
	return sharedRecipesClient;
}

#pragma mark - Get Recipes
- (void)startRecipesRequestWithSuccess:(void (^)(NSMutableArray * recipesArray))success failure:(void (^)(NSError *error))failure {
    NSLog(@"startRecipesRequestWithSuccess start");

    NSString * urlString = [NSString stringWithFormat:@"%@%@",kHyperServerBaseURL,kHyperRecipesURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSLog(@"startRecipesRequestWithSuccess URL: %@",[[request URL] absoluteString]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSMutableArray * recipes = [NSMutableArray array];
                                                                                            [JSON enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
                                                                                                HYRecipe * recipe = [[HYRecipe alloc] initWithJsonDictionary:obj];
                                                                                                [recipes addObject:recipe];
                                                                                            }];
                                                                                            success(recipes);
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                                                    NSError *error, id JSON) {
                                                                                            failure(error);
                                                                                        }
                                         ];
    [self enqueueHTTPRequestOperation:operation];
    
}

#pragma mark - Add Recipe
- (NSMutableURLRequest *)addRecipeRequestWithParameters:(NSDictionary *)parameters {
    return [self requestWithMethod:@"POST" path:kHyperRecipesURL parameters:parameters];
}

- (void)startAddRecipeRequestWithRecipe:(Recipe *)recipe success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSLog(@"startAddRecipeRequestWithRecipe start");   
    NSDictionary *parameters = [recipe recipeToJSONRecipe];
    
    NSData *imageData = UIImageJPEGRepresentation(recipe.photo, 0.5);
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kHyperRecipesURL parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"recipe[photo]" fileName:[NSString stringWithFormat:@"%@.jpg",recipe.name]mimeType:@"image/jpeg"];
    }];
    
    NSLog(@"Request : %@", [[request URL] absoluteString]);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Update Recipe
- (void)startUpdateRecipeRequestWithRecipe:(Recipe *)recipe success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSLog(@"startUpdateRecipeRequestWithSuccess start");
    NSDictionary *parameters = [recipe recipeToJSONRecipe];
    
    NSData *imageData = UIImageJPEGRepresentation(recipe.photo, 0.5);
    NSString * path = [NSString stringWithFormat:@"%@/%@", kHyperRecipesURL, recipe.identifier] ;
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"PUT" path:path parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"recipe[photo]" fileName:[NSString stringWithFormat:@"%@.jpg",recipe.name]mimeType:@"image/jpeg"];
    }];
    
    NSLog(@"Request : %@", [[request URL] absoluteString]);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Delete Recipe
- (NSMutableURLRequest *)deleteRecipeRequestWithParameters:(NSDictionary *)parameters {
    NSString * path = [NSString stringWithFormat:@"%@/%@", kHyperRecipesURL, [parameters objectForKey:@"id"]];
    return [self requestWithMethod:@"DELETE" path:path parameters:nil];
}

- (void)startDeleteRecipeRequestWithIdentifier:(NSNumber *)identifier success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSLog(@"startDeleteRecipeRequestWithSuccess start");
    NSDictionary * parameters = [NSDictionary dictionaryWithObject:identifier forKey:@"id"];
    NSURLRequest *request = [self deleteRecipeRequestWithParameters:parameters];
    NSLog(@"Request : %@", [[request URL] absoluteString]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            success();
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                                                                                                   NSError *error, id JSON) {
                                                                                            failure(error);
                                                                                        }
                                         ];
    [self enqueueHTTPRequestOperation:operation];
}

@end
