//
//  SMSViewController.m
//  dtp
//
//  Created by Lowtrack on 15.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "SMSViewController.h"
#import "Animations.h"
//#import "AppConstant.h"
#import "UIView+Shake.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SetShadow.h"


@interface SMSViewController ()
- (IBAction)button_Back_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textField_SMS;
- (IBAction)textField_SMS_Changed:(id)sender;



@property (strong, nonatomic) IBOutlet UIImageView *image_dot_1;
@property (strong, nonatomic) IBOutlet UIImageView *image_dot_2;
@property (strong, nonatomic) IBOutlet UIImageView *image_dot_3;
@property (strong, nonatomic) IBOutlet UIImageView *image_dot_4;

@property (strong, nonatomic) IBOutlet UIView *view_dots;

@property (strong, nonatomic) NSDictionary * answer;
@property (strong, nonatomic) IBOutlet UIView *navBar;

@end

@implementation SMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.textField_SMS becomeFirstResponder];
    self.textField_SMS.tintColor = [UIColor clearColor];
    SetShadow * shadow = [SetShadow new];
    [shadow setShadow:self.navBar];
    NSLog(@"string_code_value - %@", self.string_code_value);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)button_Back_Action:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)textField_SMS_Changed:(id)sender {
    
    Animations * anim = [Animations new];
    
    if ([self.textField_SMS.text length] == 0) {
        [anim set_Dot_Empty:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
        [anim set_Dot_Empty:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
        [anim set_Dot_Empty:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
        [anim set_Dot_Empty:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
    }
    
    if ([self.textField_SMS.text length] == 1) {
        [anim set_Dot_full:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_Empty:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
        [anim set_Dot_Empty:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
        [anim set_Dot_Empty:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
    }
    if ([self.textField_SMS.text length] == 2) {
        [anim set_Dot_full:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_full:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_Empty:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
        [anim set_Dot_Empty:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
    }
    
    if ([self.textField_SMS.text length] == 3) {
        [anim set_Dot_full:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_full:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_full:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_Empty:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
    }
    
    if ([self.textField_SMS.text length] == 4) {
        [anim set_Dot_full:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_full:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_full:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        [anim set_Dot_full:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodon.png"]];
        
        
        NSLog(@"code - %@", [self md5:self.textField_SMS.text]);
        NSLog(@"string_code_value - %@", self.string_code_value);


        
        if ([[self md5:self.textField_SMS.text] isEqualToString:self.string_code_value]) {
            NSLog(@"YES %@", [self md5:self.string_code_value]);
            SinglTone * tone = [SinglTone singleton];
            [[NSUserDefaults standardUserDefaults] setObject:tone.phone_number forKey:User_Telephone_Number];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self get_session_TEST];
            
            [self get_session];
        }
        
        else {
            
            NSLog(@"NO");
            
            [self startShake:self.view_dots];
            int64_t delayInSeconds = 300;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [anim set_Dot_Empty:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
                [anim set_Dot_Empty:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
                [anim set_Dot_Empty:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
                [anim set_Dot_Empty:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
            });
            self.textField_SMS.text = @"";
        }
    }
    
}



//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

- (void) startShake:(UIView*)view
{
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(-7, 0);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(7, 0);
    
    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button" context:(__bridge void *)(view)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:4];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakeEnded:finished:context:)];
    
    view.transform = rightShake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void) shakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}





- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 4 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - go_to_appView

-(void) go_to_appView {
    UIStoryboard* storyBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *paneViewController = [storyBoard instantiateViewControllerWithIdentifier:@"tabBarView"];
    [self.navigationController pushViewController:paneViewController animated:YES];
}


//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - API

- (void) get_session_TEST{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
//    NSDictionary *parameters = @{@"action": @"sessionset",
//                                 @"hardwareid":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]],};
    [manager GET:Server_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON: %@", self.answer);
        [self get_session];
        
        
        
        
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

- (void) get_session {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
    NSDictionary *parameters = @{@"action": @"sessionset",
                                 @"hardwareid":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]],};
    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON: %@", self.answer);
        
        if ([self.answer valueForKey:@"sessionid"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[self.answer valueForKey:@"sessionid"] forKey:SESSION];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"SESSION: %@", [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]);
            [self go_to_appView];
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



//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------




#pragma mark - md5




- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    
    NSLog(@"md5test %@", output);
    
    return  output;
    
}



@end
