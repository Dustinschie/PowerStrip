//
//  InfoPVController.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/20/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "InfoPVController.h"
#import "InfoViewController.h"

@interface InfoPVController ()

@end

@implementation InfoPVController
+ (void)initialize
{
    if (self == InfoPVController.class) {
        UIPageControl *pageControl = UIPageControl.appearance;
        pageControl.pageIndicatorTintColor = UIColor.blackColor;
        pageControl.currentPageIndicatorTintColor = UIColor.redColor;
    }
}

- (NSArray *)pageIdentifiers {
    return @[@"infoPage1", @"infoPage2", @"infoPage2"];
}

//- (void)setUpViewController:(InfoViewController *)page
//                    atIndex:(NSInteger)index  {
//    [super setUpViewController:page atIndex:index];
//    
//    page.customData = [self dataForPageAtIndex:index];
//}

@end
