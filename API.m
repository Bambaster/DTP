//
//  API.m
//  dtp
//
//  Created by Lowtrack on 30.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "API.h"

@interface API ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@end

@implementation API


+ (API*) sharedManager {
    
    static API* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[API alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
       
        NSURL* url = [NSURL URLWithString:Server_URL];

        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        
    }
    return self;
}

- (void) get_request:(NSDictionary*) params
                    onSuccess:(void(^)(NSDictionary* answer)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    

    [self.requestOperationManager GET:Server_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
                                  NSLog(@"JSON: %@", responseObject);
         
                                  NSDictionary * dict_response  = (NSDictionary *)responseObject;

                                  
                                  if (success) {
                                      success(dict_response);
                                  }
                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
    
}




//- (NSDictionary *) get_request: (NSDictionary *) parameters {
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSLog(@"JSON: %@", responseObject);
//        self.answer = (NSDictionary *)responseObject;
//        NSLog(@"JSON get_session APPDELEGATE: %@", self.answer);
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//    }];
//    
//    
//    return self.answer;
//    
//    
//}

/* 
 NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN], [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
 NSDictionary *parameters = @{@"action": @"getmessages",
 @"token": token,
 @"messageid": message_ID,};
 
 
 [[API sharedManager] get_request:parameters onSuccess:^(NSDictionary *answer) {
 
 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", message_ID] forKey:Last_Message_ID];
 
 NSLog(@"get_unreceved_messages message_ID: %@", [[NSUserDefaults standardUserDefaults]stringForKey:Last_Message_ID]);
 NSDictionary * dict = [answer valueForKey:@"aps"];
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
 } onFailure:^(NSError *error, NSInteger statusCode) {
 NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
 }];
 
 */



@end
