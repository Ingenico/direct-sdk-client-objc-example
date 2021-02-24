//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "IDNetworkingActivityLogger.h"
#import "IDStartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Uncomment the following two statement to enable logging of requests and responses
    // [[IDNetworkingActivityLogger sharedLogger] startLogging];
    // [[IDNetworkingActivityLogger sharedLogger] setLogLevel: IDLoggerLevelDebug];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];

    IDStartViewController *shop = [[IDStartViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shop];

    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
