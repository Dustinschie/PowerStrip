//
//  InfoTableVC.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/20/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

#import "InfoTableVC.h"
#import "InfoCell.h"
#import "InfoOutletSettingsVC.h"

@interface InfoTableVC ()
@property (strong, nonatomic) NSString *cellReuseName;
@end

@implementation InfoTableVC
@synthesize cellReuseName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellReuseName = @"cellID";
    [[self tableView] registerNib:[UINib nibWithNibName:@"InfoCell"
                                                 bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier:cellReuseName];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}
//----------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseName
                                                                 forIndexPath:indexPath];
    
    return cell;
}

//----------------------------------------------------------------------------------------------
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}
//----------------------------------------------------------------------------------------------
// Override to support lazy loading of cell
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoCell *iCell = (InfoCell *)cell;
//    [iCell setID: [NSString stringWithFormat:@"%d", indexPath.row]];
    [[iCell idLabel] setText:[NSString stringWithFormat:@"%d", indexPath.row]];
    [[[iCell circleView] layer] setCornerRadius: [[iCell circleView] frame].size.height / 2];
    NSLog(@"%d\t%f\t%f", indexPath.row, [[iCell circleView] frame].size.height, [[iCell circleView] frame].size.width);
}
//----------------------------------------------------------------------------------------------
// Override to support lazy loading of cell
- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"outletInfo" sender:[NSNumber numberWithInt:indexPath.row]];
}
//----------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Outlet\t\tDuration\t\t\tCount";
}
//----------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return the height that I want for the cell (the height of the cell in the nib)
    return 41;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if ([[segue identifier] isEqualToString:@"outletInfo"]) {
        InfoOutletSettingsVC *outletsettings = (InfoOutletSettingsVC *)[segue destinationViewController];
        NSString *title = [NSString stringWithFormat:@"%d", [sender integerValue]];
        [[outletsettings navigationItem] setTitle:title];
        
    }
}


@end
