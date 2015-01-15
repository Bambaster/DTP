//
//  ProfileViewController.h
//  dtp
//
//  Created by Lowtrack on 18.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"



@interface ProfileViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, EAIntroDelegate>


@property (strong, nonatomic) IBOutlet UIProgressView *progressView;


@end
