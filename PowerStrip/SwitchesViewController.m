//
//  SwitchesViewController.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/19/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SwitchesViewController.h"
#import <ASOTwoStateButton.h>
#import "UIView+Blur.h"


@interface SwitchesViewController ()
@property (strong, nonatomic) AVAudioPlayer *onPlayer;
@property (strong, nonatomic) AVAudioPlayer *offPlayer;
@end

@implementation SwitchesViewController

@synthesize outletView;
@synthesize onPlayer;
@synthesize offPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  setup soundplayers
    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tap-mellow" ofType:@"aif"]];
    NSError *error = nil;
    onPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [onPlayer prepareToPlay];
    soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tap-metallic" ofType:@"aif"]];
    offPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [offPlayer prepareToPlay];
    
    //  some variables needed for the outlet buttons
    NSInteger   cols = 4,
                rows = 2,
                buttonSize = [outletView frame].size.width / cols,
                tag = 0,
                offset = 10;
    //  set up all the outlet buttons
    for (int y = 0; y < rows; y++) {
        for (int x = 0; x < cols; x++) {
            // initialize button
            ASOTwoStateButton *button = [[ASOTwoStateButton alloc] initWithFrame: CGRectMake(x * buttonSize,
                                                                                             y * buttonSize + offset,
                                                                                             buttonSize,
                                                                                             buttonSize)];
            //  set 'off state' image name
            [button setOffStateImageName:@"outlet"];
            //  set 'on state' image name
            [button setOnStateImageName:@"outletOff"];
            //  init animated button effect
            [button initAnimationWithFadeEffectEnabled:YES];
            //  set the tag for this button for use in selectors
            [button setTag:tag];
            [button addTarget:self
                       action:@selector(twoStateButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer *gr = [UILongPressGestureRecognizer new];
            [gr addTarget:self action:@selector(outletLongPressed:)];
            [button addGestureRecognizer:gr];
            tag++;
            [outletView addSubview:button];
        }
    }
    for (int i = 0; i < cols; i++) {
        UIView *view = [UIView new];
        CGRect frm = [view frame];
        frm.size.width = offset / 2;
        frm.size.height = offset / 2;
        [view setFrame:frm];
        [view setCenter:CGPointMake((i + 0.5) * buttonSize, buttonSize  + offset)];
        [[view layer] setCornerRadius: offset / 4];
        [view setBackgroundColor:[UIColor whiteColor]];
        [[self outletView] addSubview:view];
    }
    
}
- (void)twoStateButtonAction:(id)sender
{
    BOOL state = ![sender isOn];
    int i = ((ASOTwoStateButton *) sender).tag;
    if (state) {
        NSLog(@"%d is on", i);
        [onPlayer play];
    } else {
        NSLog(@"%d is off", i);
        [offPlayer play];
    }
}

- (void)outletLongPressed: (id)sender
{
    int i = [[(UILongPressGestureRecognizer *) sender view] tag];
    NSLog(@"%d long press", i);
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
