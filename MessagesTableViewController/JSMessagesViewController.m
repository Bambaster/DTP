//
//  JSMessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import "SetShadow.h"
#import "Animations.h"
#import "MZFormSheetController.h"


#define OSVersionIsAtLeastiOS7  (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

#define INPUT_HEIGHT 125.0f

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate, MZFormSheetBackgroundWindowDelegate>

- (void)setup;

@property (nonatomic, strong) UILabel * label_ButtonTitle;
@property (nonatomic, strong) UILabel * label_TextPlaceholder;
@property (nonatomic,strong) NSString * string_Company;


@end

@implementation JSMessagesViewController

- (void)loadView
{
    [super loadView];
    [self fixFrame];
    isPlaceHolderHiden = NO;
}



- (void)fixFrame
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (OSVersionIsAtLeastiOS7 == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }else{
        frame.size.height -= 20 + 44;
    }
    
    self.view.frame = frame;
    self.view.bounds = frame;
}


#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self; 
	[self.view addSubview:self.tableView]; 
	
	UIButton* mediaButton = nil;

	
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);

    
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    self.inputToolBarView.textView.font = [UIFont fontWithName:@"PFAgoraSansPro-Light" size:16.0];
    self.inputToolBarView.textView.layer.sublayerTransform = CATransform3DMakeTranslation(1, 3, 0);
//    self.inputToolBarView.textView.text = @"Написать жалобу";
    self.inputToolBarView.textView.textColor = [UIColor blackColor];

    self.inputToolBarView.backgroundColor = [UIColor whiteColor];
    
    UIView * view_Gray_Line = [[UIView alloc] initWithFrame:CGRectMake (0.0f, 0, self.inputToolBarView.frame.size.width , 0.5f)];
    view_Gray_Line.backgroundColor = [UIColor lightGrayColor];
    [self.inputToolBarView addSubview:view_Gray_Line];
    
    if (kAllowsMedia)
    {
        UIImage* image = [UIImage imageNamed:@"PhotoIcon"];
        CGRect frame = CGRectMake(4, 0, image.size.width, image.size.height);
        CGFloat yHeight = (INPUT_HEIGHT - frame.size.height) / 2.0f;
        frame.origin.y = yHeight;
        
        // make the button
        mediaButton = [[UIButton alloc] initWithFrame:frame];
        [mediaButton setBackgroundImage:image forState:UIControlStateNormal];
        
        // button action
        [mediaButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }


//    [self.inputToolBarView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
//    [self.inputToolBarView.layer setShadowOpacity:9.9];
//    [self.inputToolBarView.layer setShadowRadius:1.0];
//    [self.inputToolBarView.layer setShadowOffset:CGSizeMake(0.1, 0.1)];
    
    UIPanGestureRecognizer *tapRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap_Close_Keyboard:)];
    [tapRecognizer setDelegate:self];
//    [tapRecognizer setNumberOfTapsRequired:1];
    [self.inputToolBarView addGestureRecognizer:tapRecognizer];
    
    UIView * tabbar_background = [[UIView alloc] initWithFrame:CGRectMake(0, ((self.view.frame.size.height)/2) + 170, size.width, 50)];
    tabbar_background.backgroundColor = [UIColor whiteColor];
//    tabbar_background.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
//    [self.self.inputToolBarView addSubview:tabbar_background];
    
    UIButton *sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width - 63.0f, 51.0f, 59.0f, 26.0f);
    [sendButton setTitleColor:[UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [sendButton.titleLabel setFont:[UIFont fontWithName:@"PFAgoraSansPro-Light" size:16.0]];

    [sendButton addTarget:self
                   action:@selector(sendPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setSendButton:sendButton];
    [self.view addSubview:tabbar_background];
    [self.view addSubview:self.inputToolBarView];
    
	if (kAllowsMedia)
	{
		// adjust the size of the send button to balance out more with the camera button on the other side.
		CGRect frame = self.inputToolBarView.sendButton.frame;
		frame.size.width -= 16;
		frame.origin.x += 16;
		self.inputToolBarView.sendButton.frame = frame;
		
		// add the camera button
//		[self.inputToolBarView addSubview:mediaButton];
        
		// move the tet view over это для текст вью
//		frame = self.inputToolBarView.textView.frame;
//		frame.origin.x += mediaButton.frame.size.width + mediaButton.frame.origin.x;
//		frame.size.width -= mediaButton.frame.size.width + mediaButton.frame.origin.x;
//		frame.size.width += 16;		// from the send button adjustment above
//		self.inputToolBarView.textView.frame = frame;
	}
	
    
    self.selectedMarks = [NSMutableArray new];
    
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    
    
    self.label_ButtonTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 51.0f, 280.0f, 26.0f)];
    self.label_ButtonTitle.text = @"Выбирите страховую компанию";
    self.label_ButtonTitle.textColor = [UIColor colorWithRed:23.0/255.0 green:129.0/255.0 blue:241.0/255.0 alpha:1.0];
    [self.label_ButtonTitle setFont:[UIFont fontWithName:@"PFAgoraSansPro-Light" size:16.0]];
    [self.inputToolBarView addSubview:self.label_ButtonTitle];

    
    self.label_TextPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 93.0f, 200.0f, 26.0f)];
    self.label_TextPlaceholder.text = @"Написать жалобу";
    self.label_TextPlaceholder.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    [self.label_TextPlaceholder setFont:[UIFont fontWithName:@"PFAgoraSansPro-Light" size:16.0]];
    [self.inputToolBarView addSubview:self.label_TextPlaceholder];
    
    
    
    //self.label_ButtonTitle.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
    
}


- (void)handleSingleTap_Close_Keyboard:(UIPanGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];

}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self scrollToBottomAnimated:NO];
    
    
    _originalTableViewContentInset = self.tableView.contentInset;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(show_companies) name:@"Show_Companies" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCompany_Button_Title:) name:@"ChooseCompany" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCompany_Button_Title_Normal) name:@"SetNormal" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Show_Companies" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChooseCompany" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SetNormal" object:nil];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - show companies

- (void) show_companies {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompaniesView"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
//    formSheet.cornerRadius = 8.0;
//    formSheet.portraitTopInset = 6.0;
    formSheet.shouldCenterVertically = YES;

//    formSheet.landscapeTopInset = 6.0;
    formSheet.presentedFormSheetSize = CGSizeMake(self.view.frame.size.width - 20, self.view.frame.size.height);
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
    
//    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
//        
//    }];
    
    NSLog(@"__%s__",__func__);
}

- (void) setCompany_Button_Title:(NSNotification*) notification  {
    
    
    self.string_Company = [notification.userInfo valueForKey:@"ChooseCompany"];
    self.label_ButtonTitle.text = self.string_Company;
    self.label_ButtonTitle.textColor = [UIColor whiteColor];
    self.inputToolBarView.sendButton.enabled = ([self.inputToolBarView.textView.text trimWhitespace].length > 0 && self.string_Company.length != 0);
    
}

- (void) setCompany_Button_Title_Normal  {
    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:0.4];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeForwards];
    [self.label_ButtonTitle.layer addAnimation:transitionAnimation forKey:@"FromRightAnimation"];
    self.label_ButtonTitle.text = @"Выбирите страховую компанию";
    self.label_ButtonTitle.textColor = [UIColor colorWithRed:23.0/255.0 green:129.0/255.0 blue:241.0/255.0 alpha:1.0];
    self.string_Company = @"";
    
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
}


- (void)cameraAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cameraPressed:)]){
        [self.delegate cameraPressed:sender];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleMediaType mediaType = [self.delegate messageMediaTypeForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d_%ld", type, bubbleStyle, hasTimestamp, hasAvatar, (long)row]; 
    
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone mediaType:mediaType
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
                [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                [cell setAvatarImageTarget:self.dataSource action:[self.dataSource avatarImageForIncomingMessageAction]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                [cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                [cell setAvatarImageTarget:self.dataSource action:[self.dataSource avatarImageForOutgoingMessageAction]];
                break;
        }
    }
    
	if (kAllowsMedia)
		[cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
    
    [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    [cell setBackgroundColor:tableView.backgroundColor];
    
    cell.isSelected = [self.selectedMarks containsObject:CellID] ? YES : NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d_%ld", type, bubbleStyle, hasTimestamp, hasAvatar, (long)row];
    
    if ([self.selectedMarks containsObject:CellID])// Is selected?
        [self.selectedMarks removeObject:CellID];
    else
        [self.selectedMarks addObject:CellID];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath]){
        return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }else{
        return [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend:(BOOL)isMedia
{
    if (!isMedia) {
        [self.inputToolBarView.textView setText:nil];
        [self textViewDidChange:self.inputToolBarView.textView];
    }
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated
{
	[self.tableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}


#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0 && self.string_Company.length != 0);
    
    Animations * anim = [Animations new];
    if ([textView.text trimWhitespace].length > 0 || !isPlaceHolderHiden) {
        [anim hide_Label_NoName:self.label_TextPlaceholder];
        isPlaceHolderHiden = YES;
    }
    else {
        [anim show_Label_NoName:self.label_TextPlaceholder];
        isPlaceHolderHiden = NO;

        
    }
    
    
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
    if ([self.inputToolBarView.textView.text isEqualToString:@"Написать жалобу"]) {
//
//        self.inputToolBarView.textView.text = @"";
//        self.inputToolBarView.textView.textColor = [UIColor blackColor];
    }
    
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
    if ([self.inputToolBarView.textView.text length] == 0) {
//        self.inputToolBarView.textView.text = @"Написать жалобу";
//        self.inputToolBarView.textView.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];

    }
    

}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.02f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height - self.inputToolBarView.frame.origin.y - inputViewFrame.size.height;
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

//- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
//{
//    CGRect inputViewFrame = self.inputToolBarView.frame;
//    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
//    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
//    self.inputToolBarView.frame = inputViewFrame;
//    
//    
//}

@end