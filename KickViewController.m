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

@interface KickViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;
@property (strong, nonatomic) IBOutlet UITextView *textView_Message;

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
    
    self.delegate = self;
    self.dataSource = self;
    
    self.messageArray = [NSMutableArray array];
    
     
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(show_TabBar)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(hide_TabBar)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Show_Companies" object:nil];
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
//- (void) show_companies {
//    
//
//    NSLog(@"__%s__",__func__);
//}
//
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    int value = arc4random() % 1000;
    NSString *msgId = [NSString stringWithFormat:@"%d",value];
//    isUserMessage = YES;

    
    JSBubbleMessageType msgType;

    
    if(isUserMessage){


        self.sing = [SinglTone new];

        msgType = JSBubbleMessageTypeOutgoing;
        [JSMessageSoundEffect playMessageSentSound];
        isUserMessage = NO;
        NSString * string_Company = @"Росгосстрах";
        NSString * string_Type_Review = [[NSUserDefaults standardUserDefaults] stringForKey:Type_of_Review];

        NSString * string_Line = @"_______________________";
        NSString * total_review = [NSString stringWithFormat:@"%@\n%@\n%@\n\n,%@",string_Company,string_Type_Review, string_Line, text];

        NSString * last_Date = [[NSUserDefaults standardUserDefaults]
                                stringForKey:LAST_MESSAGE_DATE];
        NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
        NSString * last_Date_Value = [[last_Date componentsSeparatedByString:@" "]firstObject];
        NSString * current_Date_Value = [[current_Date componentsSeparatedByString:@" "]firstObject];


        if ([last_Date_Value isEqualToString:current_Date_Value]) {
            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
            
            [self.messageArray addObject:message];
            
            [self finishSend:NO];
            
            NSLog(@"last_Date_Value %@", last_Date_Value);
            NSLog(@"current_Date_Value %@", current_Date_Value);
            NSLog(@"current_Date %@", current_Date);

            NSLog(@"last_Date %@", last_Date);


            
            NSLog(@"isEqualToString");

            
            
        }
        
        else {
        
        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:total_review date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
        
        [self.messageArray addObject:message];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:LAST_MESSAGE_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self finishSend:NO];
            
            NSLog(@"!!isEqualToString");

            
        }

    }else{
        msgType = JSBubbleMessageTypeIncoming;
        [JSMessageSoundEffect playMessageReceivedSound];
        isUserMessage = YES;


        NSString * last_Date = [[NSUserDefaults standardUserDefaults]
                                stringForKey:LAST_MESSAGE_DATE];
        NSString * current_Date = [NSString stringWithFormat:@"%@", [NSDate date]];
        NSString * last_Date_Value = [[last_Date componentsSeparatedByString:@" "]firstObject];
        NSString * current_Date_Value = [[current_Date componentsSeparatedByString:@" "]firstObject];
        NSLog(@"current_Date_Value %@", current_Date_Value);
        
        if ([last_Date_Value isEqualToString:current_Date_Value]) {
            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:text date:nil msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
            
            [self.messageArray addObject:message];
            [self finishSend:NO];
        }
        
        else {
            
            MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:text date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:LAST_MESSAGE_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.messageArray addObject:message];
            [self finishSend:NO];
        }
        
//        
//        MessageData *message = [[MessageData alloc] initWithMsgId:msgId text:text date:[NSDate date] msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
        
        

        
    }
    


    



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



@end
