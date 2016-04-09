//
//  AppDelegate.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"gdUPaPvAoF1YG5VtPsTeColKbok50FPVERfwtMDv"
                  clientKey:@"VFnP34UKUm066mpfB5w0CsRNU2x64eySOGzbTwq7"];
    
    return YES;
}

@end
