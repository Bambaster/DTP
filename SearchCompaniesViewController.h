//
//  SearchCompaniesViewController.h
//  dtp
//
//  Created by Lowtrack on 25.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCompaniesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    BOOL isSearching;
    
}

@end
