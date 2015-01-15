//
//  AppDelegate.m
//  dtp
//
//  Created by Lowtrack on 13.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConstant.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CoreData.h"


@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController * tabBarController;
@property (strong, nonatomic) NSDictionary * answer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
  //  [[UITabBar appearance] setTranslucent:NO];
  //  [[UITabBar appearance] setTintColor:[UIColor colorWithRed:227/255.0 green:180/255.0 blue:204/255.0 alpha:1]];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [self firstLunch];

    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    
    if (![[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]) {
        [[NSUserDefaults standardUserDefaults] setObject:[self deviceTokenWithData:newDeviceToken ] forKey:TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"newDeviceToken %@", [self deviceTokenWithData:newDeviceToken ]);
    }
    else {
        
        NSLog(@"All ready have DeviceToken");
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {


}

-(NSString *)deviceTokenWithData:(NSData *)data
{
    NSString *deviceToken = [[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    return deviceToken;
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cityconsultingllc.dtp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"dtp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"dtp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------


#pragma mark - First Lunch, Download data and Chek session



-(void) firstLunch {
    
    
    BOOL isFirstLunch = [[NSUserDefaults standardUserDefaults] boolForKey: @"FirstLunch"];
    if (!isFirstLunch) {

        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:Version_Companies];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:Version_Auto_Companies];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:Version_Cars];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: @"FirstLunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getCompanies];

        NSLog(@"First lunch start");
        
        
    }
    
    else {
        
        [self session_check];
    }
    
}


- (void) getCompanies {
    

    NSDictionary *parameters = @{@"action": @"getcompanies",};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
//        NSLog(@"JSON getCompanies : %@", self.answer);
        
        NSArray * array_Companies = [self.answer valueForKey:@"data"];
        
//        NSLog(@"array_Companies: %@", array_Companies);
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array_Companies];
        
        [self saveCompanies:data];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
}




- (void) session_check {
    NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN], [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
    NSDictionary *parameters = @{@"action": @"sessioncheck",
                                 @"token": token,};
    NSLog(@"JSON session_check parameters: %@", parameters);

    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON session_check: %@", self.answer);
        if ([[self.answer valueForKey:@"answer"] isEqualToString:@"error"]) {
            [self get_session];
        }
        else {
            
            NSString * version = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:Version_Companies]];
            NSDictionary *versionDict = [self.answer valueForKey:@"db_version"];
            if ([version isEqualToString:[NSString stringWithFormat:@"%@",[versionDict valueForKey:@"companies"]]]) {
                NSLog(@"Version Companies is OK");
            }
            else {
                
                [self clear_Companies];
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
}


- (void) saveCompanies: (NSData *) data_Companies {
    
    CoreData * data = [CoreData new];
    [data writeData:COMPANIES Value:data_Companies Key:Company_Name];
    
    
//    for (int i=0; i<[array_Companies count];i++) {
////
////        NSString * companyid = [NSString stringWithFormat:@"%@", [[array_Companies objectAtIndex:i] valueForKey:@"companyid"]];
////        NSString * companyname = [[array_Companies objectAtIndex:i] valueForKey:@"companyname"];
////
////        [data writeClass:COMPANIES Value:companyid Key:Company_id];
//        [data writeData:COMPANIES Value:[array_Companies objectAtIndex:i] Key:Company_Name];
//
//    }

}



- (void) get_session {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
    NSDictionary *parameters = @{@"action": @"sessionset",
                                 @"hardwareid":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]],};
    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON get_session APPDELEGATE: %@", self.answer);
        
        if ([self.answer valueForKey:@"sessionid"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[self.answer valueForKey:@"sessionid"] forKey:SESSION];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"SESSION: %@", [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]);
            [self session_check];
        }
        
        else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Что-то пошло не так, попробуйте еще раз"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
}





- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    NSLog(@"md5 output %@", output);
    
    return  output;
    
}



- (void) clear_Companies {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:COMPANIES inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    
    for (NSManagedObject *managedObject in dictData) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",context);
    }
    if (![context save:&requestError]) {
        
        
        NSLog (@"Error deleting %@ - error:%@",context,requestError);
        
    }
    
    [self getCompanies];
}

@end
