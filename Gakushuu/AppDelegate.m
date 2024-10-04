//
//  AppDelegate.m
//  Gakushuu
//
//  Created by Popcorn on 2/7/22.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    KanjiDatabase *KanjiDatabaseInit = NULL;
    
    KanjiDatabaseInit = [KanjiDatabase GetInstance];
    
    [KanjiDatabaseInit Update];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Request permission to display notifications
     UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
     [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
         if (!error) {
             NSLog(@"Notification permission granted!");
         }
     }];
     
     center.delegate = self;
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {

}

@end
