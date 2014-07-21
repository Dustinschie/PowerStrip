//
//  InfoCell.h
//  PowerStrip
//
//  Created by Dustin Schie on 7/20/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
{
    UILabel *idLabel;
    UILabel *durationLabel;
    UILabel *countDownLabel;
    UIView *circleView;

}
@property  (weak, nonatomic) IBOutlet UILabel *idLabel;
@property  (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property  (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property  (weak, nonatomic) IBOutlet UIView *circleView;

@end
