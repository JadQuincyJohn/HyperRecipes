//
//  HYObject.h
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYObject : NSObject

#pragma mark Properties
@property (nonatomic, retain) NSDictionary *jsonDictionary;

#pragma mark Initializer
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary;

#pragma mark Static Initializer
+ (id)objectWithJsonDictionary:(NSDictionary *)jsonDictionary;

@end
