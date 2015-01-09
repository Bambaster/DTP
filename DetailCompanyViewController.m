//
//  DetailCompanyViewController.m
//  dtp
//
//  Created by Lowtrack on 05.01.15.
//  Copyright (c) 2015 AR for YOU. All rights reserved.
//

#import "DetailCompanyViewController.h"
#import "RJModel.h"
#import "RJTableViewCell.h"


static NSString *CellIdentifier = @"CellIdentifier";

@interface DetailCompanyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *image_backgroundImage;
@property (strong, nonatomic) IBOutlet UIView *view_mines_reviewCount;
@property (strong, nonatomic) IBOutlet UIView *view_plus_reviewCount;
- (IBAction)back:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *label_reviewPlus_count;
@property (strong, nonatomic) IBOutlet UILabel *label_reviewMinus_count;

@property (strong, nonatomic) RJModel *model;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@end

@implementation DetailCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.offscreenCells = [NSMutableDictionary dictionary];
    [self.tableView registerClass:[RJTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
    // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.tableView.allowsSelection = NO;
    
    NSLog(@"self.dataSource %@", self.dataSource);

    [self setView];
}

- (void) setView {
//    
//    self.minus_count = 130;
//    self.plus_count = 170;
    

    
    ////----------------------------------------------------------------------------------------
    ////----------------------------------------------------------------------------------------
    ////----------------------------------------------------------------------------------------
    
    self.label_reviewPlus_count.text = [NSString stringWithFormat:@"%d", self.plus_count];
    self.label_reviewMinus_count.text = [NSString stringWithFormat:@"%d", self.minus_count];
    
    if (self.minus_count >= self.view_mines_reviewCount.frame.size.width *4  || self.plus_count >= self.view_plus_reviewCount.frame.size.width * 4)
    {
        self.minus_count = self.minus_count/6;
        self.plus_count = self.plus_count /6;
    }
    
    else if (self.minus_count >= self.view_mines_reviewCount.frame.size.width *2  || self.plus_count >= self.view_plus_reviewCount.frame.size.width * 2)
    {
        self.minus_count = self.minus_count/4;
        self.plus_count = self.plus_count /4;
    }
    
   else if (self.minus_count >= self.view_mines_reviewCount.frame.size.width  || self.plus_count >= self.view_plus_reviewCount.frame.size.width)
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
    
    ////----------------------------------------------------------------------------------------
    ////----------------------------------------------------------------------------------------
    ////----------------------------------------------------------------------------------------

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




////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return [self.dataSource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell for this indexPath
    [cell updateFonts];
    NSDictionary *dataSourceItem = [[NSDictionary alloc] init];

        dataSourceItem = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.titleLabel.text =  [dataSourceItem valueForKey:@"title"];
    NSString *bioString = [dataSourceItem valueForKey:@"body"];
    
    if ([bioString length] < 50) {
        
        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n\n\n",bioString];
        
    }
    else if ([bioString length] > 50 && [bioString length] <100) {
        
        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n\n",bioString];
        
    }
    
    else if ([bioString length] > 100 && [bioString length] <150) {
        
        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n",bioString];
        
    }
    
    //    else if ([bioString length] > 150 && [bioString length] <200) {
    //
    //        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n",bioString];
    //
    //    }
    
    else {
        cell.bodyLabel.text = bioString;
    }
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This project has only one cell identifier, but if you are have more than one, this is the time
    // to figure out which reuse identifier should be used for the cell at this index path.
    NSString *reuseIdentifier = CellIdentifier;
    
    // Use the dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
    // it in the dictionary if one hasn't already been added for the reuse identifier.
    // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will result
    // in a memory leak as the cell is created but never returned from the tableView:cellForRowAtIndexPath: method!
    RJTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[RJTableViewCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    // Configure the cell for this indexPath
    [cell updateFonts];
    NSDictionary *dataSourceItem = [[NSDictionary alloc] init];

    dataSourceItem = [self.dataSource objectAtIndex:indexPath.row];
   cell.titleLabel.text =  [dataSourceItem valueForKey:@"title"];
    
    NSString *bioString = [dataSourceItem valueForKey:@"body"];
    
    if ([bioString length] < 50) {
        
        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n\n\n",bioString];
        
    }
    else if ([bioString length] > 50 && [bioString length] <100) {
        
        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n\n",bioString];
        
    }
    
    else if ([bioString length] > 100 && [bioString length] <150) {
        
        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n",bioString];
        
    }
    
    //    else if ([bioString length] > 150 && [bioString length] <200) {
    //
    //        cell.bodyLabel.text = [NSString stringWithFormat:@"%@\n",bioString];
    //
    //    }
    
    else {
        cell.bodyLabel.text = bioString;
    }
    
    //    cell.bodyLabel.text = [dataSourceItem valueForKey:@"body"];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // The cell's width must be set to the same size it will end up at once it is in the table view.
    // This is important so that we'll get the correct height for different table view widths, since our cell's
    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    // NOTE: if you are displaying a section index (e.g. alphabet along the right side of the table view), or
    // if you are using a grouped table view style where cells have insets to the edges of the table view,
    // you'll need to adjust the cell.bounds.size.width to be smaller than the full width of the table view we just
    // set it to above. See http://stackoverflow.com/questions/3647242 for discussion on the section index width.
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // If you are just returning a constant value from this method, you should instead just set the table view's
 // estimatedRowHeight property (in viewDidLoad or similar), which is even faster as the table view won't
 // have to call this method for every row in the table view.
 //
 // Only implement this method if you have row heights that vary by extreme amounts and you notice the scroll indicator
 // "jumping" as you scroll the table view when using a constant estimatedRowHeight. If you do implement this method,
 // be sure to do as little work as possible to get a reasonably-accurate estimate.
 
 // NOTE for iOS 7.0.x ONLY, this bug has been fixed by Apple as of iOS 7.1:
 // A constraint exception will be thrown if the estimated row height for an inserted row is greater
 // than the actual height for that row. In order to work around this, we need to return the actual
 // height for the the row when inserting into the table view - uncomment the below 3 lines of code.
 // See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
 //    if (self.isInsertingRow) {
 //        return [self tableView:tableView heightForRowAtIndexPath:indexPath];
 //    }
 
 return UITableViewAutomaticDimension;
 }
 */


////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------
////----------------------------------------------------------------------------------------



@end
