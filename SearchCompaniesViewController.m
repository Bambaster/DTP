//
//  SearchCompaniesViewController.m
//  dtp
//
//  Created by Lowtrack on 25.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "SearchCompaniesViewController.h"
#import "MZFormSheetController.h"


@interface SearchCompaniesViewController ()

@property (nonatomic, strong) NSArray * array_Companies;
@property (nonatomic, strong) NSArray * array_SearchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *search_Bar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchCompaniesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PFAgoraSansPro-Regular" size:18]];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isSearching = NO;
    NSString* path = [[NSBundle mainBundle] pathForResource: @"Companies" ofType: @"txt"];
    self.array_Companies = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@", "];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------

#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];

    
    self.array_SearchResults = [self.array_Companies filteredArrayUsingPredicate:resultPredicate];
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
      return [self.array_Companies count];
     }
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (isSearching) {
        cell.textLabel.text = [self.array_SearchResults objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [self.array_Companies objectAtIndex:indexPath.row];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"PFAgoraSansPro-Light" size:18.0]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString * cellText;
    if (isSearching) {
       cellText = [self.array_SearchResults objectAtIndex:indexPath.row];
    }
    else {
       cellText = [self.array_Companies objectAtIndex:indexPath.row];
    }
    NSMutableDictionary * dictCompany = [[NSMutableDictionary alloc] init];
    [dictCompany setValue:cellText forKey:@"ChooseCompany"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChooseCompany" object:nil userInfo:dictCompany];
    
    NSLog(@"cellText %@", cellText);

    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    
}

@end
