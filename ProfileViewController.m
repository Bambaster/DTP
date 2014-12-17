//
//  ProfileViewController.m
//  dtp
//
//  Created by Lowtrack on 18.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField_Name;

@property (strong, nonatomic) IBOutlet UITextField *textField_Phone;


- (IBAction)slider_Action_Possibility:(id)sender;

- (IBAction)Back_Action:(id)sender;

- (IBAction)change_Photo_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label_change_Photo_One;
@property (strong, nonatomic) IBOutlet UILabel *label_change_Photo_Two;
@property (strong, nonatomic) IBOutlet UILabel *label_NoName;
@property (strong, nonatomic) IBOutlet UIImageView *image_Avatar;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)slider_Action_Possibility:(id)sender {
}

- (IBAction)Back_Action:(id)sender {
}

- (IBAction)change_Photo_Action:(id)sender {
}
@end
