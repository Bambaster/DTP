//
//  SearchCompaniesViewController.m
//  dtp
//
//  Created by Lowtrack on 25.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "SearchCompaniesViewController.h"

@interface SearchCompaniesViewController ()

@property (nonatomic, strong) NSArray * array_Companies;
@property (nonatomic, strong) NSArray * array_SearchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *search_Bar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchCompaniesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString * companies_String = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"Companies" ofType: @"rtf"] usedEncoding:NSStringEncodingConversionAllowLossy error:nil];
    self.array_Companies = [companies_String componentsSeparatedByString:@","];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------

#pragma mark - UISearchBarDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"searchText %@", searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarSearchButtonClicked");

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"searchBarCancelButtonClicked");

}

////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
#pragma mark - table view

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     
     
      return [self.array_Companies count];
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.array_Companies objectAtIndex:indexPath.row];
    return cell;
}

@end
