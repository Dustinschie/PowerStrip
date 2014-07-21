//
//  InfoCardPVC.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/20/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "InfoCardPVC.h"

@interface InfoCardPVC ()

@end

@implementation InfoCardPVC

+ (void)initialize
{
    if (self == InfoCardPVC.class) {
        UIPageControl *pageControl = UIPageControl.appearance;
        pageControl.pageIndicatorTintColor = UIColor.blackColor;
        pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    }
}

- (NSArray *)pageIdentifiers {
    return @[@"infoPage1", @"infoPage2", @"infoPage2"];
}

@end
