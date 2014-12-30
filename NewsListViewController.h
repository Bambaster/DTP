//
//  NewsListViewController.h
//  dtp
//
//  Created by Lowtrack on 26.12.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextViewDelegate>
{
    BOOL isSearching;
    
}


@end
