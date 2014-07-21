//
//  PVController.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/19/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "PVController.h"

@implementation PVController

+ (void)initialize
{
    if (self == PVController.class) {
        UIPageControl *pageControl = UIPageControl.appearance;
        pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        pageControl.currentPageIndicatorTintColor =[UIColor blueColor];
    }
}

- (NSArray *)pageIdentifiers {
    return @[@"page2", @"page1"];
}
@end
