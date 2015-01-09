//
//  ProfileViewController.m
//  dtp
//
//  Created by Lowtrack on 18.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+ImagePickerCrop.h"
#import "AppConstant.h"
#import "UIImage+ImageEffects.h"
#import "SMPageControl.h"
#import "Animations.h"


@interface ProfileViewController ()
{
    UIView *rootView;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (strong, nonatomic) IBOutlet UITextField *textField_Name;
@property (strong, nonatomic) IBOutlet UITextField *textField_Phone;
@property (strong, nonatomic) IBOutlet UILabel *label_change_Photo_One;
@property (strong, nonatomic) IBOutlet UILabel *label_change_Photo_Two;
@property (strong, nonatomic) IBOutlet UILabel *label_NoName;
@property (strong, nonatomic) IBOutlet UIImageView *image_Avatar;
@property (strong, nonatomic) NSDictionary * answer;
- (IBAction)slider_Action_Possibility:(id)sender;
- (IBAction)Back_Action:(id)sender;
- (IBAction)change_Photo_Action:(id)sender;
- (IBAction)text_phone_changed:(id)sender;
- (IBAction)text_name_changed:(id)sender;
- (IBAction)show_instruktion_action:(id)sender;
- (IBAction)tap_view_Name:(UITapGestureRecognizer *)sender;

@end

@implementation ProfileViewController


//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
    rootView = self.navigationController.view;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [tapRecognizer setDelegate:self];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapRecognizer];
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    Animations * anim = [Animations new];
    self.textField_Name.text = [[NSUserDefaults standardUserDefaults] stringForKey:User_Name];
    if ([self.textField_Name.text length] > 0) {
        [anim hide_Label_NoName:self.label_NoName];
    }
    else {
        if (self.label_NoName.alpha == 0) {
        [anim show_Label_NoName:self.label_NoName];

        }
    }
//    [[NSUserDefaults standardUserDefaults] setObject:self.textField_Name.text forKey:User_Name];
//    [[NSUserDefaults standardUserDefaults] setObject:self.textField_Phone.text forKey:User_Telephone_Number];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [self upload_profile_name];
    
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

- (void) setView {
    Animations * anim = [Animations new];
    self.image_Avatar.layer.cornerRadius = self.image_Avatar.frame.size.width / 2;
    self.image_Avatar.clipsToBounds = YES;
    self.textField_Phone.text = [[NSUserDefaults standardUserDefaults] stringForKey:User_Telephone_Number];
    self.textField_Name.text = [[NSUserDefaults standardUserDefaults] stringForKey:User_Name];
    NSData* imageData = [[NSUserDefaults standardUserDefaults]objectForKey:User_Avatar];
    UIImage *imageAvatar = [[UIImage alloc]initWithData:imageData];
    self.image_Avatar.image = imageAvatar;
    [self checkImage];
    if ([self.textField_Name.text length] > 0) {
        [anim hide_Label_NoName:self.label_NoName];
    }
    else {
        
        [anim show_Label_NoName:self.label_NoName];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - set avatar 
- (IBAction)change_Photo_Action:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Установите ваш аватар"
                                                             delegate:self
                                                    cancelButtonTitle:@"Отменить"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Снять фото", @"Выбрать изображение", nil];
    
    [actionSheet showInView:self.view];
    [self.view endEditing:YES];

}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    UIImagePickerControllerSourceType sourceType = buttonIndex ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
    [self displayImagePickerWithSourceType:sourceType];
}

- (void) checkImage {
    
    if (self.image_Avatar.image == nil) {
        self.label_change_Photo_One.alpha = 1;
        self.label_change_Photo_Two.alpha = 1;
        self.image_Avatar.image = [UIImage imageNamed:@"avatar.png"];
        }
    
    else {
        self.label_change_Photo_One.alpha = 0;
        self.label_change_Photo_Two.alpha = 0;
        NSData * imageData = UIImagePNGRepresentation(self.image_Avatar.image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:User_Avatar];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.image_Avatar.image = [UIImage croppedImageWithImagePickerInfo:info];
    [self checkImage];
    [self upload_profile_avatar];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)displayImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - text fields 
- (IBAction)text_phone_changed:(id)sender {
    
    if ([self.textField_Phone.text length] == 16) {
        
        NSLog(@"[self.textField_Phone.text length] %d", [self.textField_Phone.text length]);
        
        [self.view endEditing:YES];
        [[NSUserDefaults standardUserDefaults] setObject:self.textField_Phone.text forKey:User_Telephone_Number];

    }
    
}

- (IBAction)text_name_changed:(id)sender {
    
    Animations * anim = [Animations new];
    if ([self.textField_Name.text length] > 0) {
        [anim hide_Label_NoName:self.label_NoName];
    }
    else {
        [anim show_Label_NoName:self.label_NoName];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField_Name) {
        [textField resignFirstResponder];
        [[NSUserDefaults standardUserDefaults] setObject:self.textField_Name.text forKey:User_Name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self upload_profile_name];
//        [self session_check];

        return NO;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.textField_Phone) {
        
    int length = [self getLength:textField.text];
    NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {

        
        if(range.length == 0)
            return NO;

    }
     if (length == 1) {
        
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"+7(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"+7%@",[num substringToIndex:1]];
    
    }
    
    
    else if (length == 2) {
        
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"+7(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"+7%@",[num substringToIndex:2]];
        
    }
    
     else if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"+7(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"+7%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        NSLog(@"%@",[num  substringToIndex:3]);
        NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"+7(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"+7(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    

    
    return YES;
        
        
    }
    
    else {

        
        if(range.length + range.location > self.textField_Name.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [self.textField_Name.text length] + [string length] - range.length;
        return (newLength > 14) ? NO : YES;
        
     return YES;

        
    }
    
    return YES;

}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"7" withString:@""];

    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"7" withString:@""];

    int length = [mobileNumber length];
    
    return length;
    
    
}
- (IBAction)tap_view_Name:(UITapGestureRecognizer *)sender {
    
    [self.textField_Name becomeFirstResponder];

}
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - info
- (IBAction)show_instruktion_action:(id)sender {
    
    [self showIntroWithCrossDissolve];
}


- (void)showIntroWithCrossDissolve {

    [self.view endEditing:YES];
    


         [self hideTabBar:self.tabBarController];
    
        EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage1"];
        page1.bgImage = [UIImage imageNamed:@"fon1.jpg"];
        
        EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage2"];
        page2.bgImage = [UIImage imageNamed:@"fon2.jpg"];
        
        EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage3"];
        page3.bgImage = [UIImage imageNamed:@"fon3.jpg"];
        
        EAIntroPage *page4 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage4"];
        page4.bgImage = [UIImage imageNamed:@"fon4.jpg"];
        
        EAIntroPage *page5 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage5"];
        page5.bgImage = [UIImage imageNamed:@"fon5.jpg"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4,page5]];
    intro.pageControlY = 70.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Закрыть" forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    // btn.backgroundColor = [UIColor colorWithRed:0/255 green:250/255 blue:255/255 alpha:0.50];
    
    btn.frame = CGRectMake(((self.view.frame.size.width / 2) -  125), (self.view.frame.size.height) - 20, 250, 50);
    
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

//    [self setTabBarVisible:![self tabBarIsVisible] animated:YES];
    
     [self showTabBar:self.tabBarController];

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

#pragma mark - hide tab bar

- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    Animations * anim = [Animations new];
    [anim hide_tabBar:tabbarcontroller.tabBar];
    
    
//    [tabbarcontroller.tabBar setHidden:YES];

}

- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
//    [tabbarcontroller.tabBar setHidden:NO];
    
    Animations * anim = [Animations new];
    [anim show_tabBar:tabbarcontroller.tabBar];
    
}


- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    

    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------


- (IBAction)slider_Action_Possibility:(id)sender {
    
    UISwitch *onoff = (UISwitch *) sender;
//    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    if (onoff.on) {
        NSLog(@"On");

    }
    
    else {
        
        NSLog(@"Off");

    }
    
}

- (IBAction)Back_Action:(id)sender {
    
    [self.tabBarController setSelectedIndex:0];
}












//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - API

- (void) session_check {
    NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN], [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
    NSDictionary *parameters = @{@"action": @"sessioncheck",
                            
                                 @"token": token,};
    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON: %@", self.answer);
        
        
        
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


- (void) upload_profile_name {
    
    NSString * name = [[NSUserDefaults standardUserDefaults]stringForKey:User_Name];
    NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN], [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
    
    NSLog(@"token - %@", token);
    if ([name length] == 0) {
        name = @"Аноним";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
    NSDictionary *parameters = @{@"action": @"register",
                                 @"username": name,
                                 @"mobilephone": [[NSUserDefaults standardUserDefaults]stringForKey:User_Telephone_Number],
                                 @"avatar": @"",
                                 @"token": token,};
    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        self.answer = (NSDictionary *)responseObject;
        NSLog(@"JSON: %@", self.answer);

        
        
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

- (void) upload_profile_avatar {
    NSString * name = [[NSUserDefaults standardUserDefaults]stringForKey:User_Name];
    NSString * token = [self md5:[NSString stringWithFormat:@"%@%@",@"test", [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]]];
    
    NSLog(@"token - %@", token);
    if ([name length] == 0) {
        name = @"Аноним";
    }
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
//    NSDictionary *parameters = @{@"action": @"register",
//                                 @"username": name,
//                                 @"mobilephone": [[NSUserDefaults standardUserDefaults]stringForKey:User_Telephone_Number],
//                                 @"avatar": @"",
//                                 @"token": token,};
//    [manager POST:Server_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //[[NSUserDefaults standardUserDefaults]stringForKey:TOKEN]
//    NSDictionary *parameters = @{@"action": @"sessionset",
//                                 @"hardwareid": @"test",};
//    [manager GET:Server_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSLog(@"JSON: %@", responseObject);
//        self.answer = (NSDictionary *)responseObject;
//        NSLog(@"JSON: %@", self.answer);
//        [[NSUserDefaults standardUserDefaults] setObject:[self.answer valueForKey:@"sessionid"] forKey:SESSION];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSLog(@"SESSION: %@", [[NSUserDefaults standardUserDefaults]stringForKey:SESSION]);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//    }];
    
    
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

@end
