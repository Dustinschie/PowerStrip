//
//  SwitchesViewController.h
//  PowerStrip
//
//  Created by Dustin Schie on 7/19/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "MSPageViewControllerPage.h"
#import "CardView.h"

@interface SwitchesViewController : MSPageViewControllerPage
@property (strong, nonatomic) IBOutlet UIView *outletView;
@property (strong, nonatomic) IBOutlet CardView *cardView;
- (void)twoStateButtonAction:(id)sender;
@end
