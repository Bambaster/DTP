//
//  DetailCompanyViewController.m
//  dtp
//
//  Created by Lowtrack on 05.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import "DetailCompanyViewController.h"

@interface DetailCompanyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *image_backgroundImage;
@property (strong, nonatomic) IBOutlet UIView *view_mines_reviewCount;
@property (strong, nonatomic) IBOutlet UIView *view_plus_reviewCount;
- (IBAction)back:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *label_reviewPlus_count;
@property (strong, nonatomic) IBOutlet UILabel *label_reviewMinus_count;


@end

@implementation DetailCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setView];
}

- (void) setView {
//    
//    self.minus_count = 130;
//    self.plus_count = 170;
    
    self.label_reviewPlus_count.text = [NSString stringWithFormat:@"%d", self.plus_count];
    self.label_reviewMinus_count.text = [NSString stringWithFormat:@"%d", self.minus_count];

    
    if (self.minus_count >= self.view_mines_reviewCount.frame.size.width  || self.plus_count >= self.view_plus_reviewCount.frame.size.width)
    {
        self.minus_count = self.minus_count/2;
        self.plus_count = self.plus_count /2;
    }
    
    self.label_Name_Company.text = self.company_name;
    UIImageView * mines_Reviews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.minus_count, self.view_mines_reviewCount.frame.size.height)];
    mines_Reviews.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    UIImageView * plus_Reviews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.plus_count, self.view_plus_reviewCount.frame.size.height)];
    plus_Reviews.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1];
    [self.view_mines_reviewCount addSubview:mines_Reviews];
    [self.view_plus_reviewCount addSubview:plus_Reviews];

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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
