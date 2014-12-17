//
//  ViewController.m
//  dtp
//
//  Created by Lowtrack on 13.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"
#import "SMPageControl.h"
#import "SetShadow.h"
#import "AppConstant.h"


@interface ViewController ()
{
    UIView *rootView;
}

@property (strong, nonatomic) IBOutlet UIView *navBar;

@property (strong, nonatomic) IBOutlet UILabel *label_Main;
@property (strong, nonatomic) IBOutlet UILabel *label_info_one;
@property (strong, nonatomic) IBOutlet UILabel *label_info_two;

@property (strong, nonatomic) IBOutlet UILabel *label_seven;
@property (strong, nonatomic) IBOutlet UITextField *textField_Phone_number;

- (IBAction)phone_number_changed:(id)sender;
- (IBAction)button_Cancel_Action:(id)sender;
- (IBAction)button_Next_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button_Next_Outlet;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];

    NSLog(@"viewDidLoad %@", [[NSUserDefaults standardUserDefaults]
                                       stringForKey:User_Telephone_Number]);
    NSString * tel_number = [[NSUserDefaults standardUserDefaults]
                             stringForKey:User_Telephone_Number];
    if (tel_number) {
        [self go_to_appView];
    }
    
    else {
    
    [self setView];
    rootView = self.navigationController.view;
    [self showIntroWithCrossDissolve];
        
    }
    



}

- (void) setView {
    SetShadow * shadow = [SetShadow new];
    [shadow setShadow:self.navBar];
    
    self.navBar.alpha = 0;
    self.label_Main.alpha = 0;
    self.label_info_one.alpha = 0;
    self.label_info_two.alpha = 0;
    self.label_seven.alpha = 0;
    self.textField_Phone_number.alpha = 0;
     if ([self.textField_Phone_number.text length] == 15) {
        self.button_Next_Outlet.enabled = YES;
    }
     else {
    self.button_Next_Outlet.enabled = 0;
     }
    [self.textField_Phone_number resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - info

- (void)showIntroWithCrossDissolve {
    
    EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage1"];
    page1.bgImage = [self blurWithGPUImage:[UIImage imageNamed:@"fon1.jpg"]];
    
    EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage2"];
    page2.bgImage = [self blurWithGPUImage:[UIImage imageNamed:@"fon2.jpg"]];
    
    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage3"];
    page3.bgImage = [self blurWithGPUImage:[UIImage imageNamed:@"fon3.jpg"]];
    
    EAIntroPage *page4 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage4"];
    page4.bgImage = [self blurWithGPUImage:[UIImage imageNamed:@"fon4.jpg"]];
    
    EAIntroPage *page5 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage5"];
    page5.bgImage = [self blurWithGPUImage:[UIImage imageNamed:@"fon5.jpg"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4, page5]];
    
    intro.pageControlY = 70.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Начать" forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
   // btn.backgroundColor = [UIColor colorWithRed:0/255 green:250/255 blue:255/255 alpha:0.50];

    btn.frame = CGRectMake(((self.view.frame.size.width / 2) -  125), (self.view.frame.size.height) - 70, 250, 50);

    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.layer.borderWidth = 1.0f;
//    btn.layer.cornerRadius = 5;
//    btn.layer.borderColor = [[UIColor clearColor] CGColor];
    intro.skipButton = btn;

    
    [intro setDelegate:self];

    [intro showInView:rootView animateDuration:0.3];
}

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    
    Animations * anim = [Animations new];
    [anim set_First_View:self.navBar F_Label:self.label_Main S_Label:self.label_info_one T_Label:self.label_info_two Seven_Label:self.label_seven Text_Field:self.textField_Phone_number];
    
    int64_t delayInSeconds = 400;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [self.textField_Phone_number becomeFirstResponder];

    });
    
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - set blur

- (UIImage *)blurWithGPUImage:(UIImage *)sourceImage
{
    return [sourceImage applyBlurWithRadius:7 tintColor:[UIColor clearColor] saturationDeltaFactor:1.5 maskImage:nil];
    
    
}
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------


- (IBAction)phone_number_changed:(id)sender {
    

    if ([self.textField_Phone_number.text length] < 15) {
        self.button_Next_Outlet.enabled = NO;
    }
    
    else if ([self.textField_Phone_number.text length] == 15) {
        self.button_Next_Outlet.enabled = YES;
    }

}

- (IBAction)button_Cancel_Action:(id)sender {
    NSLog(@"button_Cancel_Action %@", [[NSUserDefaults standardUserDefaults]
                  stringForKey:User_Telephone_Number]);
    [self showIntroWithCrossDissolve];
    [self setView];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@""] forKey:User_Telephone_Number];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (IBAction)button_Next_Action:(id)sender {
    
    NSLog(@"button_Next_Action %@", [[NSUserDefaults standardUserDefaults]
                  stringForKey:User_Telephone_Number]);


    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"+7%@", self.textField_Phone_number.text] forKey:User_Telephone_Number];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = YES;
    if (string.length != 0) {
        NSMutableString *text = [NSMutableString stringWithString:[[textField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
        [text insertString:@"(" atIndex:0];

        
        if (text.length > 3)
            [text insertString:@") " atIndex:4];

        
        if (text.length > 8)
            [text insertString:@"-" atIndex:9];

        if (text.length > 11)
            [text insertString:@"-" atIndex:12];
        

        textField.text = text;
    }
    
    int limit = 14;
    return !([textField.text length]>limit && [string length] > range.length);
    
    return result;
}



#pragma mark - go_to_appView 

-(void) go_to_appView {
    
    UIStoryboard* storyBoard =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *paneViewController = [storyBoard instantiateViewControllerWithIdentifier:@"tabBarView"];
    
    [self.navigationController pushViewController:paneViewController animated:NO];
}

@end
