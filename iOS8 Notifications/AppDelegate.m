//
//  AppDelegate.m
//  iOS8 Notifications
//
//  Created by David Gaeddert on 9/16/14.
//  Copyright (c) 2014 demo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // First, create an action
    UIMutableUserNotificationAction *acceptAction = [self createAction];
    
    // Second, create a category and tie those actions to it (only the one action for now)
    UIMutableUserNotificationCategory *inviteCategory = [self createCategory:@[acceptAction]];
    
    // Third, register those settings with our new notification category
    [self registerSettings:inviteCategory];
    
    // Now send ourselves a local notification
    [self sendLocalNotification];
    
    return YES;
}

- (UIMutableUserNotificationAction *)createAction {
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    // Given seconds, not minutes, to run in the background
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // If YES the actions is red
    acceptAction.destructive = NO;
    
    // If YES requires passcode, but does not unlock the device
    acceptAction.authenticationRequired = NO;
    
    return acceptAction;
}

- (UIMutableUserNotificationCategory *)createCategory:(NSArray *)actions {
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    // You can define up to 4 actions in the 'default' context
    // On the lock screen, only the first two will be shown
    // If you want to specify which two actions get used on the lockscreen, use UIUserNotificationActionContextMinimal
    [inviteCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
    
    // These would get set on the lock screen specifically
    // [inviteCategory setActions:@[declineAction, acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    return inviteCategory;
}

- (void)registerSettings:(UIMutableUserNotificationCategory *)category {
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    
    NSSet *categories = [NSSet setWithObjects:category, nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)sendLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Hey!";
    notification.category = @"INVITE_CATEGORY";
    
    // The notification will arrive in 5 seconds, leave the app or lock your device to see
    // it since we aren't doing anything to handle notifications that arrive while the app is open
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    // Get the notifications types that have been allowed, do whatever with them
    UIUserNotificationType allowedTypes = [notificationSettings types];
    
    NSLog(@"Registered for notification types: %u", allowedTypes);
    
    // You can get this setting anywhere in your app by using this:
    // UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        // handle it
        NSLog(@"Invite accepted! Handle that somehow...");
    }
    
    // Call this when you're finished
    completionHandler();
}


@end
