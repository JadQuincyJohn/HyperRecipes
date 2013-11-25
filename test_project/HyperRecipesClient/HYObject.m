//
//  HYObject.m
//  HyperRecipesClient
//
//  Created by Jad on 18/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYObject.h"

@implementation HYObject

@synthesize jsonDictionary = _jsonDictionary;
- (void)setJsonDictionary:(NSDictionary *)jsonDictionary {
	if (![_jsonDictionary isEqualToDictionary:jsonDictionary]) {
		_jsonDictionary = jsonDictionary;
	}
}

#pragma mark - Initializer
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
	self = [super init];
	if (self) {
		self.jsonDictionary = jsonDictionary;
	}
	return self;
}

#pragma mark - Static Initializer
+ (HYObject *)objectWithJsonDictionary:(NSDictionary *)jsonDictionary {
	return [[self alloc] initWithJsonDictionary:jsonDictionary];
}

@end
