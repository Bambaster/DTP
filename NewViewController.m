//
//  NewViewController.m
//  dtp
//
//  Created by Lowtrack on 12.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import "NewViewController.h"
#import "NewsTableViewCell.h"

@interface NewViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary * dict_server_answer;


@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dict_server_answer = [[NSMutableDictionary alloc] init];
    [self.dict_server_answer setValue:@"NEWS TITLE" forKey:@"count"];
    [self.dict_server_answer setValue:@"NEWS BODY" forKey:@"count"];
    [self.dict_server_answer setValue:@"count 1010" forKey:@"count"];
    [self.dict_server_answer setValue:@"today 10:20" forKey:@"count"];

    NSLog(@"self.dict_server_answer %@",self.dict_server_answer);

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     NSLog(@"__%s__",__func__);

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return self.dict_server_answer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.label_News_Title.text = [[self.dict_server_answer valueForKey:@"count"] objectAtIndex:indexPath.row];
//    cell.label_News_Body.text = [[self.dict_server_answer valueForKey:@"count"]objectAtIndex:indexPath.row];
//    cell.label_News_Date.text = [[self.dict_server_answer valueForKey:@"count"]objectAtIndex:indexPath.row];
//    cell.label_Reviews_Count.text = [[self.dict_server_answer valueForKey:@"count"]objectAtIndex:indexPath.row];



    
    
    
    
    
    return cell;
}





@end
