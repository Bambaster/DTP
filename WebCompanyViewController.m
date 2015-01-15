//
//  WebCompanyViewController.m
//  dtp
//
//  Created by Lowtrack on 10.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import "WebCompanyViewController.h"

@interface WebCompanyViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label_NavBar;

@end

@implementation WebCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_myWebView];
    self.view.autoresizesSubviews = YES;
    NSURL* url = [NSURL URLWithString:self.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
    self.label_NavBar.text = self.labelNavText;
//    [self.label_NavBar sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set self as the web view's delegate when the view is shown; use the delegate methods to toggle display of the network activity indicator.
    self.myWebView.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.myWebView stopLoading];	// In case the web view is still loading its content.
    self.myWebView.delegate = nil;	// Disconnect the delegate as the webview is hidden.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // Starting the load, show the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Finished loading, hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Load error, hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Report the error inside the webview.
    NSString* errorString = [NSString stringWithFormat:
                             @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 36pt; color: red;'>An error occurred:<br>%@</div></body></html>",
                             error.localizedDescription];
    [self.myWebView loadHTMLString:errorString baseURL:nil];
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end
