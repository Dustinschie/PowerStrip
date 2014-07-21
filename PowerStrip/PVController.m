//
//  PVController.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/18/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "PVController.h"

@interface PVController ()

@end

@implementation PVController

+ (void)initialize
{
    if (self ==  PVController.class) {
        UIPageControl *pageControl = UIPageControl.appearance;
        [pageControl setPageIndicatorTintColor: [UIColor blackColor]];
        [pageControl setCurrentPageIndicatorTintColor: [UIColor redColor]];
    }
}

- (NSArray *)pageIdentifiers
{
    return @[@"page2", @"page1"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
