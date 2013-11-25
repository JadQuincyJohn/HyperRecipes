//
//  HYFavoriteCheckbox.m
//  HyperRecipesClient
//
//  Created by Jad on 22/11/2013.
//  Copyright (c) 2013 Inertia. All rights reserved.
//

#import "HYFavoriteCheckbox.h"

@implementation HYFavoriteCheckbox

- (void)setChecked:(BOOL)checked {
	if (_checked != checked) {
		_checked = checked;
		[self setSelected:_checked];
	}
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

#pragma mark - Check
- (void)check {
    self.checked = !self.checked;
    [self setSelected:self.checked];
}


@end
