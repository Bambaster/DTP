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
@property (strong, nonatomic) API * api;


@end

@implementation AppDelegate
@synthesize api;


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
//    [self get_Incoming_Messawges];

    return YES;
}


- (void) get_Incoming_Messawges {
    CoreData * data = [CoreData new];
    NSArray *array = [[NSArray alloc] initWithArray:[data getData:MESSAGES Key:messages]];
    NSMutableArray * array_Input_Messawges = [[NSMutableArray alloc]init];
    int total_messages = array.count;
    __block int count_messages;

    [array enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        // do something with object
        NSDictionary *dict  = [NSKeyedUnarchiver unarchiveObjectWithData:object];
        if ([[dict valueForKey:@"direction"] isEqualToString:@"input"]) {
            
            [array_Input_Messawges addObject:[dict valueForKey:@"direction"]];
        }

        if (stop) {
            count_messages ++;
            if (count_messages == total_messages) {
                NSLog(@"count_messages == total_messages");
                NSLog(@"array_Input_Messawges.count == %d", array_Input_Messawges.count);
                NSLog(@"count_messages == %d", count_messages);
                NSLog(@"total_messages == %d", total_messages);

            }
        }

    }];
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

//    NSLog(@"didReceiveRemoteNotification userInfo%@", userInfo);

    NSDictionary * dict = [userInfo valueForKey:@"aps"];
    NSString * message = [dict valueForKey:@"alert"];
    NSString * direction = [dict valueForKey:@"direction"];

    NSMutableDictionary * dict_Message = [[NSMutableDictionary alloc] init];
    [dict_Message setObject:message forKey:@"message"];
    [dict_Message setObject:direction forKey:@"direction"];

    NSString * last_Date = [[NSUserDefaults standardUserDefaults] stringForKey:LAST_MESSAGE_DATE];
    NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
    NSString * last_Date_Value = [[last_Date componentsSeparatedByString:@" "]firstObject];
    NSString * current_Date_Value = [[current_Date componentsSeparatedByString:@" "]firstObject];
    if ([last_Date_Value isEqualToString:current_Date_Value]) {
        [dict_Message setObject:@"nodate" forKey:@"date"];
    }
    else {
        [dict_Message setObject:[NSDate date] forKey:@"date"];
    }
//    [dict_Message setValue:@"test" forKey:@"test"];
    NSLog(@"didReceiveRemoteNotification dict_Message %@", dict_Message);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict_Message];
    [self addMessages_To_CoreData:data];

}


- (void) get_unreceved_messages: (NSString *) message_ID {
    
    NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN], [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
    NSDictionary *parameters = @{@"action": @"getmessages",
                                 @"token": token,
                                 @"messageid": message_ID,};
    
    
    [[API sharedManager] get_request:parameters onSuccess:^(NSDictionary *answer) {

        NSLog(@"answer = %@", answer);

        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", message_ID] forKey:Last_Message_ID];
        NSLog(@"get_unreceved_messages message_ID: %@", [[NSUserDefaults standardUserDefaults]stringForKey:Last_Message_ID]);
        
//        NSDictionary * dict = [answer valueForKey:@"aps"];
//        NSString * message = [dict valueForKey:@"alert"];
//        NSString * direction = [dict valueForKey:@"direction"];
//        
//        NSMutableDictionary * dict_Message = [[NSMutableDictionary alloc] init];
//        [dict_Message setObject:message forKey:@"message"];
//        [dict_Message setObject:direction forKey:@"direction"];
//        
//        NSString * last_Date = [[NSUserDefaults standardUserDefaults] stringForKey:LAST_MESSAGE_DATE];
//        NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
//        NSString * last_Date_Value = [[last_Date componentsSeparatedByString:@" "]firstObject];
//        NSString * current_Date_Value = [[current_Date componentsSeparatedByString:@" "]firstObject];
//        if ([last_Date_Value isEqualToString:current_Date_Value]) {
//            [dict_Message setObject:@"nodate" forKey:@"date"];
//        }
//        else {
//            [dict_Message setObject:[NSDate date] forKey:@"date"];
//        }
//        //    [dict_Message setValue:@"test" forKey:@"test"];
//        NSLog(@"didReceiveRemoteNotification dict_Message %@", dict_Message);
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict_Message];
//        [self addMessages_To_CoreData:data];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
    }];
    



}


- (void) addMessages_To_CoreData: (NSData *) data_Messages {
    CoreData * data = [CoreData new];
    //    void (^clear_Messages_Block) (void);
    //    clear_Messages_Block = ^ {
    //        NSLog(@"clear_Messages_Block!!!");
    //        [data clear_Entity:MESSAGES];
    //    };
    //    clear_Messages_Block();
    [data writeData:MESSAGES Value:data_Messages Key:messages];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Incomming_Message" object:nil userInfo:nil];

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
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", @"1"] forKey:Last_Message_ID];

        
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
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
    NSDictionary *parameters = @{@"action": @"sessioncheck",
                                 @"token": token,};
    NSLog(@"JSON session_check parameters: %@", parameters);
    
    [[API sharedManager] get_request:parameters onSuccess:^(NSDictionary *answer) {
        
        self.answer = answer;
        NSLog(@"JSON session_check answer : %@", self.answer);
        if ([[self.answer valueForKey:@"answer"] isEqualToString:@"error"]) {
            [self get_session];
        }
        else {
            NSDictionary *versionDict = [self.answer valueForKey:@"db_version"];
            
            NSString * version = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:Version_Companies]];
            if ([version isEqualToString:[NSString stringWithFormat:@"%@",[versionDict valueForKey:@"companies"]]]) {
                NSLog(@"Version Companies is OK");
            }
            else {
                [self clear_Companies];
            }
            
            int las_message_count  = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:Last_Message_ID]] intValue];
            
            if (las_message_count == [[NSString stringWithFormat:@"%@",[self.answer valueForKey:@"maxMessageID"]]intValue]) {

                NSLog(@"las_message_count is OK %d",[[NSString stringWithFormat:@"%@",[self.answer valueForKey:@"maxMessageID"]]intValue]);
                
            }
            
            else {
                NSLog(@"las_message_count is not OK %d",[[NSString stringWithFormat:@"%@",[self.answer valueForKey:@"maxMessageID"]]intValue]);
                [self get_unreceved_messages:[NSString stringWithFormat:@"%@",[self.answer valueForKey:@"maxMessageID"]]];

            }
        }
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);

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
