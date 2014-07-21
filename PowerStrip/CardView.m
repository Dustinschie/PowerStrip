//
//  CardView.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/20/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void) setup
{
    if (self) {
        [[self layer] setCornerRadius:5];
        [[self layer] setMasksToBounds:YES];
        [[self layer] setBorderWidth:2];
        [[self layer] setBorderColor: [[UIColor darkGrayColor] CGColor]];
        NSLog(@"hello card");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
