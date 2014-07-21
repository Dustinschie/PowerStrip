//
//  InfoCell.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/20/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell
@synthesize idLabel         = _idLabel;
@synthesize durationLabel   = _durationLabel;
@synthesize countDownLabel  = _countDownLabel;
@synthesize circleView      = _circleView;

- (void)awakeFromNib
{
    [[circleView layer] setCornerRadius: [circleView frame].size.height / 2];
    [[circleView layer] setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
