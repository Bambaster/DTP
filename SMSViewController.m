//
//  SMSViewController.m
//  dtp
//
//  Created by Lowtrack on 15.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "SMSViewController.h"
#import "Animations.h"
#import "AppConstant.h"
#import "UIView+Shake.h"


@interface SMSViewController ()
- (IBAction)button_Back_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textField_SMS;
- (IBAction)textField_SMS_Changed:(id)sender;



@property (strong, nonatomic) IBOutlet UIImageView *image_dot_1;
@property (strong, nonatomic) IBOutlet UIImageView *image_dot_2;
@property (strong, nonatomic) IBOutlet UIImageView *image_dot_3;
@property (strong, nonatomic) IBOutlet UIImageView *image_dot_4;

@property (strong, nonatomic) IBOutlet UIView *view_dots;



@end

@implementation SMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.textField_SMS becomeFirstResponder];
    self.textField_SMS.tintColor = [UIColor clearColor];

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
        
        if ([self.textField_SMS.text isEqualToString:TEST_SMS]) {
            NSLog(@"YES");
        }
        
        else {
            
            NSLog(@"NO");
            
            [self startShake:self.view_dots];
//
            
            int64_t delayInSeconds = 300;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [anim set_Dot_Empty:self.image_dot_1 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
                [anim set_Dot_Empty:self.image_dot_2 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
                [anim set_Dot_Empty:self.image_dot_3 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
                [anim set_Dot_Empty:self.image_dot_4 ImageName:[UIImage imageNamed:@"pinkodoff.png"]];
            });
//

            self.textField_SMS.text = @"";
            

        }
    }
    
}


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
@end
