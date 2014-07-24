//
//  SwitchesViewController.m
//  PowerStrip
//
//  Created by Dustin Schie on 7/19/14.
//  Copyright (c) 2014 Dustinschie. All rights reserved.
//


#import "SwitchesViewController.h"

//  Core API
#import <AVFoundation/AVFoundation.h>

//  CocoaPod
#import <ASOTwoStateButton.h>

//  Category
#import "UIView+Blur.h"
#import "NSString+hex.h"
#import "NSData+hex.h"

#define CONNECTING_TEXT @"Connecting..."
#define DISCONNECTING_TEXT @"Disconnecting…"
#define DISCONNECT_TEXT @"Disconnect"
#define CONNECT_TEXT @"Connect"


@interface SwitchesViewController () <UIAlertViewDelegate>
{
    UIAlertView         *alertView;
    CBCentralManager    *cm;
    UARTPeripheral      *currentPeripheral;
    NSArray             *connectedPeripherals;
    
    
}
@property (strong, nonatomic) AVAudioPlayer             *switchPlayer;
@property (strong, nonatomic) UIAlertView               *alertView;
@property (strong, nonatomic) UIActivityIndicatorView   *loading;
@end

@implementation SwitchesViewController

@synthesize outletView;
@synthesize switchPlayer;
@synthesize alertView;
@synthesize loading;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //  setup soundplayers
    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tap-mellow" ofType:@"aif"]];
    NSError *error = nil;
    switchPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL
                                                          error:&error];
    [switchPlayer prepareToPlay];
    
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
            [button setTitle: [@(tag) stringValue] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button setAlpha:0.75];
            //  set 'off state' image name
            [button setOffStateImageName:@"outlet"];
            //  set 'on state' image name
            [button setOnStateImageName:@"outletOff"];
            //  init animated button effect
            [button initAnimationWithFadeEffectEnabled:YES];
            //  set the tag for this button for use in selectors
            [button setTag:tag];
            /**
             *  add the IBActions
             *      1.  to handle Two-state Button
             *      2.  to handle a long press
             */
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
    //  add some skeudomorphicism
    for (int i = 0; i < cols; i++) {
        UIView *view = [UIView new];
        CGRect frm = [view frame];
        frm.size.width = offset / 2;
        frm.size.height = offset / 2;
        [view setFrame:frm];
        [view setAlpha:0.75];
        [view setCenter:CGPointMake((i + 0.5) * buttonSize, buttonSize  + offset)];
        [[view layer] setCornerRadius: offset / 4];
        [view setBackgroundColor:[UIColor whiteColor]];
        [[self outletView] addSubview:view];
    }
    
    cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _connectionMode = ConnectionModeUART;
    _connectionStatus = ConnectionStatusScanning;
    [self createAlertView];
    [alertView show];
    [self scanForPeripherals];

}

- (void)scanForPeripherals
{
    
    //Look for available Bluetooth LE devices
    
    //skip scanning if UART is already connected
    connectedPeripherals = [cm retrieveConnectedPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]];
    NSInteger count = [connectedPeripherals count];
    switch (count){
        case 0:
            [cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]
                                       options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
            break;
        case 1:
            //connect to first peripheral in array
            [self connectPeripheral:[connectedPeripherals objectAtIndex:0]];
            break;
            
        default:
        {
            int i = 0;
            for (CBPeripheral *cbp in connectedPeripherals) {
                NSString *name = [NSString stringWithFormat:@"%d\t%@", i, [cbp name]];
                [alertView addButtonWithTitle:name];
                i++;
            }
            break;
        }
    }
}

- (void)connectPeripheral:(CBPeripheral*)peripheral{
    
    //Connect Bluetooth LE device
    
    //Clear off any pending connections
    [cm cancelPeripheralConnection:peripheral];
    
    //Connect
    currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [cm connectPeripheral:peripheral
                  options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    
}

- (void)disconnect{
    
    //Disconnect Bluetooth LE device
    
    _connectionStatus = ConnectionStatusDisconnected;
    _connectionMode = ConnectionModeNone;
    
    [cm cancelPeripheralConnection:currentPeripheral.peripheral];
    
}



- (void) createAlertView
{
    //  setup AlertView
    alertView = [[UIAlertView alloc] initWithTitle:@"Loading"
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles: nil];
    
    // add activity indicator to alerView
    loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loading setFrame:CGRectMake(150, 150, 16, 16)];
    [alertView addSubview:loading];
    [alertView setDelegate:self];
}

- (IBAction)twoStateButtonAction:(id)sender
{
    BOOL state = ![sender isOn];
    NSInteger i = ((ASOTwoStateButton *) sender).tag;
    if (state) {
        NSLog(@"%ld is on", i);
        [switchPlayer play];
    } else {
        NSLog(@"%ld is off", i);
        [switchPlayer play];
    }
}

- (IBAction)outletLongPressed: (id)sender
{
    NSInteger i = [[(UILongPressGestureRecognizer *) sender view] tag];
    NSLog(@"%ld long press", i);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIAlertViewDelegate
- (void)alertViewCancel:(UIAlertView *)alertView
{
    
    NSLog(@"cancel pressed");
    if (_connectionStatus == ConnectionStatusConnected) {
        [self disconnect];
    } else if (_connectionStatus == ConnectionStatusScanning){
        [cm stopScan];
    }
    _connectionStatus = ConnectionStatusDisconnected;
    _connectionMode = ConnectionModeNone;
//    [alertView setHidden:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld button pressed", buttonIndex);
    //connect to first peripheral in array
    [self connectPeripheral:[connectedPeripherals objectAtIndex:buttonIndex]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"info_embed"]) {
        NSLog(identifier);
    }
}


#pragma mark CBCentralManagerDelegate


- (void) centralManagerDidUpdateState:(CBCentralManager*)central
{
    
    if (central.state == CBCentralManagerStatePoweredOn){
        
        //respond to powered on
    }
    
    else if (central.state == CBCentralManagerStatePoweredOff){
        
        //respond to powered off
    }
    
}


- (void) centralManager:(CBCentralManager*)central
  didDiscoverPeripheral:(CBPeripheral*)peripheral
      advertisementData:(NSDictionary*)advertisementData
                   RSSI:(NSNumber*)RSSI
{
    
    NSLog(@"Did discover peripheral %@", peripheral.name);
    
    [cm stopScan];
    
    [self connectPeripheral:peripheral];
}


- (void) centralManager:(CBCentralManager*)central
   didConnectPeripheral:(CBPeripheral*)peripheral
{
    
    if ([currentPeripheral.peripheral isEqual:peripheral]){
        
        if(peripheral.services){
            NSLog(@"Did connect to existing peripheral %@", peripheral.name);
            [currentPeripheral peripheral:peripheral didDiscoverServices:nil]; //already discovered services, DO NOT re-discover. Just pass along the peripheral.
        }
        
        else{
            NSLog(@"Did connect peripheral %@", peripheral.name);
            [currentPeripheral didConnect];
        }
    }
}


- (void) centralManager:(CBCentralManager*)central
didDisconnectPeripheral:(CBPeripheral*)peripheral
                  error:(NSError*)error
{
    
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    //respond to disconnected
    [self peripheralDidDisconnect];
    
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        [currentPeripheral didDisconnect];
    }
}

#pragma mark UARTPeripheralDelegate


- (void)didReadHardwareRevisionString:(NSString*)string{
    
    //Once hardware revision string is read, connection to Bluefruit is complete
    
    NSLog(@"HW Revision: %@", string);
    
    //Bail if we aren't in the process of connecting
    if (alertView == nil){
        return;
    }
    
    _connectionStatus = ConnectionStatusConnected;
    
    //UART mode
    if (_connectionMode == ConnectionModeUART){
        self.uartViewController = [[UARTViewController alloc]initWithDelegate:self];
        _uartViewController.navigationItem.rightBarButtonItem = infoBarButton;
        [_uartViewController didConnect];
    }
    
    //Dismiss Alert view & update main view
    [currentAlertView dismissWithClickedButtonIndex:-1 animated:NO];
    
    //Push appropriate viewcontroller onto the navcontroller
    UIViewController *vc = nil;
    
    if (_connectionMode == ConnectionModePinIO)
        vc = _pinIoViewController;
    
    else if (_connectionMode == ConnectionModeUART)
        vc = _uartViewController;
    
    if (vc != nil){
        [_navController pushViewController:vc animated:YES];
    }
    
    else
        NSLog(@"CONNECTED WITH NO CONNECTION MODE SET!");
    
    currentAlertView = nil;
    
    
}


- (void)uartDidEncounterError:(NSString*)error{
    
    //Dismiss "scanning …" alert view if shown
    if (currentAlertView != nil) {
        [currentAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    
    //Display error alert
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                   message:error
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
    
}


- (void)didReceiveData:(NSData*)newData{
    
    //Data incoming from UART peripheral, forward to current view controller
    
    //Debug
    //    NSString *hexString = [newData hexRepresentationWithSpaces:YES];
    //    NSLog(@"Received: %@", newData);
    
    if (_connectionStatus == ConnectionStatusConnected || _connectionStatus == ConnectionStatusScanning) {
        //UART
        if (_connectionMode == ConnectionModeUART) {
            //send data to UART Controller
            [_uartViewController receiveData:newData];
        }
        
        //Pin I/O
        else if (_connectionMode == ConnectionModePinIO){
            //send data to PIN IO Controller
            [_pinIoViewController receiveData:newData];
        }
    }
}


- (void)peripheralDidDisconnect{
    
    //respond to device disconnecting
    
    //if we were in the process of scanning/connecting, dismiss alert
    if (currentAlertView != nil) {
        [self uartDidEncounterError:@"Peripheral disconnected"];
    }
    
    //if status was connected, then disconnect was unexpected by the user, show alert
    UIViewController *topVC = [_navController topViewController];
    if ((_connectionStatus == ConnectionStatusConnected) &&
        ([topVC isMemberOfClass:[PinIOViewController class]] ||
         [topVC isMemberOfClass:[UARTViewController class]])) {
            
            //return to main view
            [_navController popToRootViewControllerAnimated:YES];
            
            //display disconnect alert
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Disconnected"
                                                           message:@"BLE peripheral has disconnected"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
            
            [alert show];
        }
    
    _connectionStatus = ConnectionStatusDisconnected;
    _connectionMode = ConnectionModeNone;
    
    //dereference mode controllers
    self.pinIoViewController = nil;
    self.uartViewController = nil;
    
    //make reconnection available after short delay
    [self performSelector:@selector(enableConnectionButtons) withObject:nil afterDelay:1.0f];
    
}


- (void)alertBluetoothPowerOff{
    
    //Respond to system's bluetooth disabled
    
    NSString *title     = @"Bluetooth Power";
    NSString *message   = @"You must turn on Bluetooth in Settings in order to connect to a device";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


- (void)alertFailedConnection{
    
    //Respond to unsuccessful connection
    
    NSString *title     = @"Unable to connect";
    NSString *message   = @"Please check power & wiring,\nthen reset your Arduino";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}
@end
