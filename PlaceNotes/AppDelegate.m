//
//  AppDelegate.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "AppDelegate.h"
#import "NotesViewController.h"
#import "Note.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    // Ladda in våra default links i masterViewControllern
    /*UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
    NotesViewController *notesViewController = (NotesViewController *)navController.topViewController;
    notesViewController.notes = [self defaultLinks].mutableCopy;*/
    
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"gdUPaPvAoF1YG5VtPsTeColKbok50FPVERfwtMDv"
                  clientKey:@"VFnP34UKUm066mpfB5w0CsRNU2x64eySOGzbTwq7"];
    
    
    // Register for Push Notitications
    /*UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];*/
    
    
    
    return YES;
}

- (NSArray *)defaultLinks {
    
    Note *firstNote = [[Note alloc] initWithNote:@"This is a first note" Title:@"Notetitle" Location:CLLocationCoordinate2DMake(63.8188147, 20.2901947)];
   
    Note *secondNote = [[Note alloc] initWithNote:@"This is a second note without title" Title:@"" Location:CLLocationCoordinate2DMake(63.8188147, 20.2901947)];
    
    return @[firstNote, secondNote];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
