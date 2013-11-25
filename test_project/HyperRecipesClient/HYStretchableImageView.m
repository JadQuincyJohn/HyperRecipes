//
//  HYStretchableImageView.m
//  HyperRecipesClient
//
//  Created by Jad on 22/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYStretchableImageView.h"

@implementation HYStretchableImageView

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if(self) {
        UIImage *stretchedBackgroundImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [self setImage:stretchedBackgroundImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImage *stretchedBackgroundImage = [self.image stretchableImageWithLeftCapWidth:self.image.size.width/2 topCapHeight:self.image.size.height/2];
    [self setImage:stretchedBackgroundImage];
}

@end
