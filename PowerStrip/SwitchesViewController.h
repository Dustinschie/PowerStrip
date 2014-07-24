//
//  SwitchesViewController.h
//  PowerStrip
//
//  Created by Dustin Schie on 7/19/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//

//  Core API
#import <CoreBluetooth/CoreBluetooth.h>

//  Cocoa Pod
#import "MSPageViewControllerPage.h"

//  My Classes
#import "CardView.h"
#import "UARTPeripheral.h"
#import "InfoCardPVC.h"


@interface SwitchesViewController : MSPageViewControllerPage
<CBCentralManagerDelegate, UARTPeripheralDelegate>
typedef enum {
    ConnectionModeNone  = 0,
    ConnectionModePinIO,
    ConnectionModeUART,
} ConnectionMode;

typedef enum {
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning,
    ConnectionStatusConnected,
} ConnectionStatus;

@property (nonatomic, assign) ConnectionMode                    connectionMode;
@property (nonatomic, assign) ConnectionStatus                  connectionStatus;
@property (strong, nonatomic) IBOutlet  UIView                  *outletView;
@property (strong, nonatomic) IBOutlet  CardView                *cardView;


- (IBAction)twoStateButtonAction:(id)sender;
- (IBAction)outletLongPressed: (id)sender;
@end
