//
//  KickViewController.m
//  dtp
//
//  Created by Lowtrack on 20.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "KickViewController.h"
#import "MessageData.h"
#import "SinglTone.h"
#import "AppConstant.h"
#import "CoreData.h"

@interface KickViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;
@property (strong, nonatomic) IBOutlet UITextView *textView_Message;
@property (nonatomic,strong) NSString * string_Company;
@property (nonatomic,strong) NSString * string_Company_ID;
@property (strong, nonatomic) NSDictionary * answer;
@property (strong, nonatomic) NSArray *array_Saved_Messages;
@property (nonatomic, strong) NSArray * array_Companies;



@property (nonatomic,strong) SinglTone * sing;

@end

@implementation KickViewController

@synthesize messageArray;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testData];

    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"PFAgoraSansPro-Regular" size:20],
      NSFontAttributeName, nil]];
 //   self.title = @"Жаловаться";
    isUserMessage = NO;
    isMessageWithDate = NO;
    
    self.delegate = self;
    self.dataSource = self;
    self.messageArray = [[NSMutableArray alloc] init];
    CoreData * data = [CoreData new];
    NSArray *array = [[NSArray alloc] initWithArray:[data getData:COMPANIES Key:Company_Name]];
    self.array_Companies  = [NSKeyedUnarchiver unarchiveObjectWithData:[array objectAtIndex:0]];
    self.array_Saved_Messages = [[NSArray alloc] initWithArray:[data getData:MESSAGES Key:messages]];
    
    if (self.array_Saved_Messages.count > 0) {
        [self set_Saved_Messages_List:self.array_Saved_Messages];
    }
    
     
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(show_TabBar)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(hide_TabBar)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCompany:) name:@"ChooseCompany" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addMessage_FromPush) name:@"Incomming_Message" object:nil];


    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChooseCompany" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)testData{
    


//    MessageData *message1 = [[MessageData alloc] initWithMsgId:@"0001" text:@"test test test test test test test test test test test test test test test" date:[NSDate date] msgType:JSBubbleMessageTypeIncoming mediaType:JSBubbleMediaTypeText img:nil];
//    
//    [self.messageArray addObject:message1];
//    
//    MessageData *message2 = [[MessageData alloc] initWithMsgId:@"0002" text:nil date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing mediaType:JSBubbleMediaTypeImage img:@"demo1.jpg"];
//    
//    [self.messageArray addObject:message2];
//    
//    MessageData *message3 = [[MessageData alloc] initWithMsgId:@"0003" text:@"test test test test test test test test test" date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing mediaType:JSBubbleMediaTypeText img:nil];
//    
//    [self.messageArray addObject:message3];
}

////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
//
//#pragma mark - show companies
//
- (void) setCompany:(NSNotification*) notification  {
    
    
    self.string_Company = [[notification.userInfo valueForKey:@"ChooseCompany"] valueForKey:Company_Name];
    self.string_Company_ID = [NSString stringWithFormat:@"%@", [[notification.userInfo valueForKey:@"ChooseCompany"] valueForKey:Company_id]];
    NSLog(@"self.string_Company_ID - %@",self.string_Company_ID);

    
    
    //    nationalityField.text = [notification.userInfo valueForKey:@"CurrentNationality"];
    //
    //    [pop dismissPopoverAnimated:YES];
    //
    //    isPopActive = NO;
    
    
}
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate

- (void) addMessage_FromPush {
    JSBubbleMessageType msgType;
    CoreData * data = [CoreData new];
    NSArray *array = [[NSArray alloc] initWithArray:[data getData:MESSAGES Key:messages]];
    NSDictionary *dict  = [NSKeyedUnarchiver unarchiveObjectWithData:[array lastObject]];

    msgType = JSBubbleMessageTypeIncoming;
    NSString * msgId = @"2";
    NSString * total_review = [dict valueForKey:@"message"];
    
    if (![[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]]isEqualToString:@"nodate"]) {
        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:[dict valueForKey:@"date"] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
        [self.messageArray addObject:message];
        [self finishSend:YES];
    }
    
    else {
        
        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
        [self.messageArray addObject:message];
        [self finishSend:YES];
        
    }
    
}


- (void) set_Saved_Messages_List : (NSArray *) array{
    
    JSBubbleMessageType msgType;
    NSString * string_Company;
    NSString * string_Type_Review;
    NSString * text;

    for (NSData * data in array){
        NSDictionary *dict  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"dict set_Saved_Messages_List - %@", dict);
        
        if ([[dict valueForKey:@"direction"] isEqualToString:@"input"]) {
            
            msgType = JSBubbleMessageTypeIncoming;
            NSString * msgId = @"2";
            NSString * total_review = [dict valueForKey:@"message"];
            
            if (![[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]]isEqualToString:@"nodate"]) {
                MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:[dict valueForKey:@"date"] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
                [self.messageArray addObject:message];
                [self finishSend:YES];

            }
            
            else {
                
                MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
                [self.messageArray addObject:message];
                [self finishSend:YES];

            }
        }
             
        else {
                 
            msgType = JSBubbleMessageTypeOutgoing;
            string_Company = [self find_Company:[NSString stringWithFormat:@"%@", [dict valueForKey:@"companyid"]]];
            string_Type_Review = [self set_Type_Of_Review:[NSString stringWithFormat:@"%@", [dict valueForKey:@"isgood"]]];
            text = [dict valueForKey:@"message"];
            NSString * msgId = @"1";
            NSString * string_Line = @"_______________________";
            NSString * total_review = [NSString stringWithFormat:@"%@\n%@\n%@\n\n,%@",string_Company,string_Type_Review, string_Line, text];
            

            
            if (![[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]]isEqualToString:@"nodate"]) {
                
            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:[dict valueForKey:@"date"] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
                [self.messageArray addObject:message];
                [self finishSend:YES];

            }
            
            else {
                
            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
                [self.messageArray addObject:message];
                [self finishSend:YES];

            }
            
        }
        
    }
    
}



- (NSString *)find_Company:(NSString *)search_Index {
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"companyid.description contains[cd] %@",
                                    search_Index];
    NSArray * arrayResult = [self.array_Companies filteredArrayUsingPredicate:resultPredicate];
    NSString * result = [[arrayResult valueForKey:Company_Name] objectAtIndex:0];
    NSLog(@"result Company - %@", result);
    
    
    return result;
}

- (NSString *) set_Type_Of_Review: (NSString *) type {
    NSString * result;

    if ([type isEqualToString:@"1"]) {
        result = @"Отрицательный отзыв";
    }
    else {
        result = @"Положительный отзыв";
    }
    
    NSLog(@"result Type_Of_Reviw - %@", result);

    
    return result;

}



- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    int value = arc4random() % 1000;
    NSString *msgId = [NSString stringWithFormat:@"%d",value];
//    isUserMessage = YES;

    
    JSBubbleMessageType msgType;

    
//    if(isUserMessage){
      NSDictionary *parameters = [[NSDictionary alloc] init];
      NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN], [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
        msgType = JSBubbleMessageTypeOutgoing;
        [JSMessageSoundEffect playMessageSentSound];
        isUserMessage = NO;
    
//        NSDate * date_CurrentDate = [[NSDate alloc] init];
        NSString * string_Company = self.string_Company;
        NSString * string_Type_Review = [[NSUserDefaults standardUserDefaults] stringForKey:Type_of_Review];
        NSString * string_Line = @"_______________________";
        NSString * total_review = [NSString stringWithFormat:@"%@\n%@\n%@\n\n,%@",string_Company,string_Type_Review, string_Line, text];
        NSString * last_Date = [[NSUserDefaults standardUserDefaults] stringForKey:LAST_MESSAGE_DATE];
        NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
        NSString * last_Date_Value = [[last_Date componentsSeparatedByString:@" "]firstObject];
        NSString * current_Date_Value = [[current_Date componentsSeparatedByString:@" "]firstObject];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SetNormal" object:nil userInfo:nil];
        if ([last_Date_Value isEqualToString:current_Date_Value]) {
        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
            [self.messageArray addObject:message];
            [self finishSend:NO];
//            
//            NSLog(@"last_Date_Value %@", last_Date_Value);
//            NSLog(@"current_Date_Value %@", current_Date_Value);
//            NSLog(@"current_Date %@", current_Date);
//
//            NSLog(@"last_Date %@", last_Date);
//
//
//            
//            NSLog(@"isEqualToString");

            parameters = @{@"action": @"addmessage",
                                         @"companyid": self.string_Company_ID,
                                         @"isgood":[self type_Of_ReviwValue:string_Type_Review],
                                         @"message": text,
                                         @"date": @"nodate",
                                         @"direction": @"output",
                                         @"token": token,};
            NSLog(@"parameters: %@", parameters);
  
            
        }
        
        else {
        
        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
        
        [self.messageArray addObject:message];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:LAST_MESSAGE_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self finishSend:NO];
//        date_CurrentDate = [NSDate date];
        parameters = @{@"action": @"addmessage",
                           @"companyid": self.string_Company_ID,
                           @"isgood":[self type_Of_ReviwValue:string_Type_Review],
                           @"message": text,
                           @"date": [NSDate date],
                           @"direction": @"output",
                           @"token": token,};
            NSLog(@"parameters: %@", parameters);
            
            NSLog(@"!!isEqualToString");

            
        }
    
    string_Company = @"";
    self.string_Company = @"";

//    }
//    
//    
//    else{
//        msgType = JSBubbleMessageTypeIncoming;
//        [JSMessageSoundEffect playMessageReceivedSound];
//        isUserMessage = YES;
//
//
//        NSString * last_Date = [[NSUserDefaults standardUserDefaults]
//                                stringForKey:LAST_MESSAGE_DATE];
//        NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
//        NSString * last_Date_Value = [[last_Date componentsSeparatedByString:@" "]firstObject];
//        NSString * current_Date_Value = [[current_Date componentsSeparatedByString:@" "]firstObject];
//        NSLog(@"current_Date_Value %@", current_Date_Value);
//        
//        if ([last_Date_Value isEqualToString:current_Date_Value]) {
//            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:text date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
//            
//            [self.messageArray addObject:message];
//            [self finishSend:NO];
//        }
//        
//        else {
//            
//            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:text date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:LAST_MESSAGE_DATE];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self.messageArray addObject:message];
//            [self finishSend:NO];
//        }
//        
////        
////        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:text date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
//        
//        
//
//        
//    }
//    




    
//action=addmessage&companyid=1&isgood=1&message=nwtreb&token=d4ba1283f51bed83c266c5d584f0bebc


    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestOperation *requestOperation =
    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Your Business Operation.
//        NSLog(@"operation success: %@\n %@", operation, responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON addmessage: %@", self.answer);
        
        if ([[self.answer valueForKey:@"answer"] isEqualToString:@"ok"]) {

            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:parameters];
            [self addMessages_To_CoreData:data];
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



- (void) addMessages_To_CoreData: (NSData *) data_Messages {
    CoreData * data = [CoreData new];
//    void (^clear_Messages_Block) (void);
//    clear_Messages_Block = ^ {
//        NSLog(@"clear_Messages_Block!!!");
//        [data clear_Entity:MESSAGES];
//    };
//    clear_Messages_Block();
    [data writeData:MESSAGES Value:data_Messages Key:messages];
}


- (NSString *) type_Of_ReviwValue:(NSString *) string {
    NSString * result;

    if ([string isEqualToString:@"Положительный отзыв"]) {
        result = [NSString stringWithFormat:@"%@", @"1"];
        
        NSLog(@"Положительный - %@", result);

    }
    else {
        result = [NSString stringWithFormat:@"%@", @"0"];
        
        NSLog(@"Отрицательный - %@", result);

    }
    return result;
}



- (void)cameraPressed:(id)sender{
    
    [self.inputToolBarView.textView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Тест1",@"Тест2", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        case 1:{
            int value = arc4random() % 1000;
            NSString *msgId = [NSString stringWithFormat:@"%d",value];
            
            JSBubbleMessageType msgType;
            if((self.messageArray.count - 1) % 2){
                msgType = JSBubbleMessageTypeOutgoing;
                [JSMessageSoundEffect playMessageSentSound];
            }else{
                msgType = JSBubbleMessageTypeIncoming;
                [JSMessageSoundEffect playMessageReceivedSound];
            }
            
            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:nil date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeImage img:@"demo1.jpg"];
            
            
            [self.messageArray addObject:message];
            
            [self finishSend:YES];
        }
            break;
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = self.messageArray[indexPath.row];
    return message.messageType;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageData *message = self.messageArray[indexPath.row];
    return message.mediaType;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyAll;
}


- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyNone;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString * last_Date = [[NSUserDefaults standardUserDefaults]
//                             stringForKey:LAST_MESSAGE_DATE];
//    NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
//    
//    if ([last_Date isEqualToString:current_Date]) {
//        
//        NSLog(@"isEqualToString");
//
//        return NO;
//    }
//    
//    else {
//    
//        NSLog(@"!!isEqualToString");
//
//        return YES;
//        
//    }
//}


#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
   MessageData *message = self.messageArray[indexPath.row];


     return message.text;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = self.messageArray[indexPath.row];

    return message.date;
}

- (UIImage *)avatarImageForIncomingMessage
{
    
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (SEL)avatarImageForIncomingMessageAction
{
    return @selector(onInComingAvatarImageClick);
}

- (void)onInComingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (SEL)avatarImageForOutgoingMessageAction
{
    return @selector(onOutgoingAvatarImageClick);
}

- (void)onOutgoingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (UIImage *)avatarImageForOutgoingMessage
{
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults]objectForKey:User_Avatar];
    UIImage *imageAvatar = [[UIImage alloc]initWithData:imageData];
    return imageAvatar;
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageData *message = self.messageArray[indexPath.row];
    return [UIImage imageNamed:message.img];
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

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

@end
