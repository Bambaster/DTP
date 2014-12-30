//
//  NewsListViewController.m
//  dtp
//
//  Created by Lowtrack on 26.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//



#import "NewsListViewController.h"
#import "NewsTableViewCell.h"

@interface NewsListViewController ()

@property (nonatomic, strong) NSArray * array_Reviewws;
@property (nonatomic, strong) NSArray * array_SearchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *search_Bar;

@property (nonatomic, assign) CGFloat  row_heiht;


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] init];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PFAgoraSansPro-Regular" size:18]];

    self.array_Reviewws = [[NSArray alloc] initWithObjects:@"Откройте пerqtretqertq риложение", @"Откройте приложение Откройте приложение Откройте прилоertqwggжение Откройте wertwertertwerприложение Откройте приложение Откройте приложение", @"Откройте приложение Откройте приложениеОткройте приложение Откройте приложение Откройте приложение Откройте пqretqertwertриложение Откройте приложение Откройте приложение",@"Откройте приложtwerение Откройтwertwerterе пtwertриложениsdfgsdfgsdе Откройте приложение Откройте приложение Откроq erg erg erarafgйте приложение Откройте приложение Откройте приложение Откройте приложение Откройте приложение Откройте приложение Отtwertwertкройте приложение Откройтgsdfgе приложение Откройте приложение Откройте приложение Откройте приложение fgsdfgsdfgdfОткройте приложение Откройте приложение Отdfgsdfgsdfgкройте приложение Откройте приложение Откройте приложение 3 Откройте приложение Откройте приложение Откройте приложение Откройте приложение Открsdfgertqertойте приложение Откройте приложение 4 Откройте приложение Откройте приложение  5 5 sdfgsdfgsdfgткройте приложение Откройте прилdfsgsdfgsdfgsdfgожение Откройте приложение Откройте приложение Откройте приложение Откройтеwertwert приложение Откройте приложение 6 Откройте приложение 7 Откройте приложение Откройте приложение Откройте приложеwertwertние Отsdfgsdfgsdfgsdfgкройте приложеwertwerterие 11111", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isSearching = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

        
    });
    

}



////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------

#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    
    self.array_SearchResults = [self.array_Reviewws filteredArrayUsingPredicate:resultPredicate];
    if (searchBar.text.length == 0) {
        isSearching = NO;
    }
    else {
        isSearching = YES;
    }
    
    [self reload_TableView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    NSLog(@"searchBarSearchButtonClicked");
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    NSLog(@"searchBarCancelButtonClicked");
    
}

- (void) reload_TableView {
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}

////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
#pragma mark - table view



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) {
        return [self.array_SearchResults count];
    }
    else {
        return [self.array_Reviewws count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    NewsTableViewCell *cell = (NewsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];


    if (cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (isSearching) {
        cell.label_News.text = [self.array_SearchResults objectAtIndex:indexPath.row];
    }
    else {
        cell.textView_News.text = [self.array_Reviewws objectAtIndex:indexPath.row];

        cell.textView_News.frame = CGRectMake(66, 41, cell.textView_News.frame.size.width, [cell.self measureHeightOfUITextView:cell.textView_News]);
        
        NSLog(@"textSize.height %f ", [cell.self measureHeightOfUITextView:cell.textView_News]);


        self.row_heiht = [cell.self measureHeightOfUITextView:cell.textView_News];

//
//        UIFont *myFont = [UIFont fontWithName:@"PFAgoraSansPro-Light" size:14.0];
//        NSString *myText= [self.array_Reviewws objectAtIndex:indexPath.row];
//        CGSize maximumLabelSize = CGSizeMake(cell.label_News.frame.size.width, CGFLOAT_MAX);
//        
//        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
//        NSStringDrawingUsesLineFragmentOrigin;
//        
//        NSDictionary *attr = @{NSFontAttributeName: myFont};
//        CGRect labelBounds = [myText boundingRectWithSize:maximumLabelSize
//                                                options:options
//                                             attributes:attr
//                                                context:nil];
//        
//        CGSize textSize = labelBounds.size;
//        cell.label_News.frame = CGRectMake(70, 40, cell.label_News.frame.size.width, textSize.height);
//        cell.label_News.text = myText;
//        self.row_heiht = textSize.height;
        
//        NSLog(@"cell.label_News.frame.size.width %f ", cell.label_News.frame.size.width);
//        NSLog(@"textSize.height %f ", textSize.height);


    }
    


    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.row_heiht > 56) {
        return 100 + (self.row_heiht - 40);

    }
    
    else {
    
         return 100;
        
    }
}

//- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
//{
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        // This is the code for iOS 7. contentSize no longer returns the correct value, so
//        // we have to calculate it.
//        //
//        // This is partly borrowed from HPGrowingTextView, but I've replaced the
//        // magic fudge factors with the calculated values (having worked out where
//        // they came from)
//        
//        CGRect frame = textView.bounds;
//        
//        // Take account of the padding added around the text.
//        
//        UIEdgeInsets textContainerInsets = textView.textContainerInset;
//        UIEdgeInsets contentInsets = textView.contentInset;
//        
//        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
//        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
//        
//        frame.size.width -= leftRightPadding;
//        frame.size.height -= topBottomPadding;
//        
//        NSString *textToMeasure = textView.text;
//        if ([textToMeasure hasSuffix:@"\n"])
//        {
//            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
//        }
//        
//        // NSString class method: boundingRectWithSize:options:attributes:context is
//        // available only on ios7.0 sdk.
//        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
//        
//        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
//        
//        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                               attributes:attributes
//                                                  context:nil];
//        
//        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
//        return measuredHeight;
//    }
//    else
//    {
//        return textView.contentSize.height;
//    }
//}


@end
