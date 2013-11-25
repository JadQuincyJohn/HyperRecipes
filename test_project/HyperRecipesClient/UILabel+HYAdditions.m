//
//  UILabel+HYAdditions.m
//  HyperRecipesClient
//
//  Created by Jad on 25/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "UILabel+HYAdditions.h"

@implementation UILabel (HYAdditions)

#pragma mark - Ideal Size
- (CGSize) idealSize {
    if ([self.text isEqualToString:@""]) {
        return CGSizeZero;
    }
    else {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:self.text attributes:@
         {
         NSFontAttributeName: self.font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.frame.size.width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        rect.size.height = rect.size.height + 10;
        return rect.size;
    }
}

@end
