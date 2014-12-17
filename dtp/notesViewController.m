//
//  notesViewController.m
//  Book Aero
//
//  Created by Lowtrack on 28.07.14.
//  Copyright (c) 2014 City Consulting LLC. All rights reserved.
//

#import "notesViewController.h"

@interface notesViewController ()

@end

@implementation notesViewController
@synthesize image;



- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    // подписаться на нотификацию
    
    NSMutableDictionary * dictSEX = [[NSMutableDictionary alloc] init];
  //  [dictSEX setValue:sexString forKey:@"sex"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMessages" object:nil userInfo:dictSEX];
    
    // воспроизвести нотификацию
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method:) name:@"ShowNotification" object:nil];

    
    //вызов метода через время
    [self performSelector:@selector(method) withObject:nil afterDelay:0.5];
    
    // colour [UIColor colorWithRed:61/255 green:71/255 blue:81/255 alpha:1.0];


}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[pop dismissPopoverAnimated:YES];
    
}

- (void) method {
    
    
}

- (void) method:(NSNotification*) notification  {
    
    
    //self.nationality = [notification.userInfo valueForKey:@"CurrentNationality"];
    
//    nationalityField.text = [notification.userInfo valueForKey:@"CurrentNationality"];
//    
//    [pop dismissPopoverAnimated:YES];
//    
//    isPopActive = NO;
    
    
}

- (void) main_queue{

dispatch_async(dispatch_get_main_queue(), ^{
    

    
});
    
}


- (void) timeInterval {
    
    int64_t delayInSeconds = 200;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
    });
    
    
    
}


//отписаться от нотификации
//- (void)dealloc {
//	
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}


//cформировать массив из core data

- (void) crateArrayFromData {
    
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CityAllAirCSV"];
    NSError * requestError = nil;
    
    NSArray * dictData = [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    //  NSLog(@"arrayCSV - %@", totalCSVData);
    int i = 0;
    for (NSManagedObject* obj in dictData) {
        
        if (i > 0) {
            
            NSMutableArray * totalArrayENG = [[NSMutableArray alloc] init];
            
            [totalArrayENG addObject:[obj valueForKey:@"dataCSV"]];
            //       NSLog(@"totalArrayENG - %@", [obj valueForKey:@"dataCSV"]);
            
            
            
        }
        ++i;
        
        
        
        
    }
    
}

//запись в core data


- (void) writeToCoreData {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:@"OrederArray" inManagedObjectContext:context];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    
    if ([dictData count] > 0) {
        NSUInteger counter = 0;
        id obj = [dictData objectAtIndex:counter];
        NSManagedObject *newOrderDate = (NSManagedObject* ) obj;
        [newOrderDate setValue:@"value" forKey:@"minDate"];


        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
    else {
        
        NSManagedObject *newOrderDate = [NSEntityDescription insertNewObjectForEntityForName:@"OrederArray" inManagedObjectContext:context];
        [newOrderDate setValue:@"value" forKey:@"minDate"];

        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }

    }
    
}



//получить данные из Core Data

- (void) getPassCount {
    
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:@"PassangersCount" inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    
    if ([dictData count] > 0 ) {
        
        NSUInteger counter = 0;
        id obj = [dictData objectAtIndex:counter];
        NSManagedObject *passCountValue = (NSManagedObject* ) obj;
        
        //pasangersLabel.text = [passCountValue valueForKey:@"pssCount"];
        NSString * passCount = [passCountValue valueForKey:@"pssCount"];
        
        
        
        NSLog(@"totalACB DATA - %@", passCount);
        
        
        
        
    }
    
    
    
    
}

- (void) NsstringFormat {
    
  //  UITextRange* selectedRange = [self.textField selectedTextRange]; //пределы анализа заданного текста
//    NSInteger cursorOffset = [self.textField offsetFromPosition:0 toPosition:selectedRange.start]; //пределы анализа строки
//    NSString* text = @"";
//    NSString* substring = [text substringToIndex:cursorOffset];
//    NSString* code2 = [[substring componentsSeparatedByString:@" "] lastObject];
//    NSString* city2 = [[substring  componentsSeparatedByString:@","] firstObject];
//    NSString* secObg2 = [[substring  componentsSeparatedByString:@","] lastObject];
//    NSString* spase = [[secObg2  componentsSeparatedByString:@" - "] firstObject];
//    
//    NSString *city = [city2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *code = [code2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *country = [spase stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark - animations

- (void) animations {
    
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionMoveIn];
    [transitionAnimation setDuration:0.5f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    

//        
//        [labelDate.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
//        labelDate.text = [newOrderDate valueForKey:@"day"];
    
}



#pragma mark - create cyrcle 

- (void) createCyrcle {
    
    
    image.layer.cornerRadius = image.frame.size.width / 2;
    image.layer.borderWidth = 1.0f;
    image.layer.borderColor = [UIColor colorWithRed:200.0/225.0 green:200.0/225.0 blue:200.0/225.0 alpha:1.0].CGColor;;
    image.clipsToBounds = YES;
    
    // plus set in storyboard - aspect fit
}








// loadTableWithAnimation {
    
//    - (void)viewDidAppear:(BOOL)animated
//    {
//        [super viewDidAppear:animated];
//        
//
//        
//        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
//    }



//glow effect

//	imadekay.layer.shadowColor = [UIColor colorWithRed:(225/255.f) green:(225/255.f) blue:(255/255.f) alpha:1.0].CGColor;
//    imadekay.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//    imadekay.layer.shadowRadius = 7.0;
//    imadekay.layer.shadowOpacity = 10.4;
//    imadekay.layer.masksToBounds = NO;






//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
//               ^{
//                   
//                   dispatch_async(dispatch_get_main_queue(),
//                                  ^{    //back on main thread
//                                      
//                                      [self.tableViewCell reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
//                                      
//                                      
//                                  });});


//   totalSegment_dep_apt_nameString = [totalSegment_dep_apt_nameString stringByReplacingOccurrencesOfString:@"\"" withString:@""];

// ячейка конкретная
// eventsMapTableViewCell *cell = (eventsMapTableViewCell *)[self.tableViewEvents cellForRowAtIndexPath:indexPath];


#pragma mark - screen size 


/*

CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

if (iOSDeviceScreenSize.height == iphone5) {
 
 } 
 
 
 if (iOSDeviceScreenSize.height == iphone4)
 {
 
 }
 
 
 */



- (void) go_to_next_view {
    /*
    
UIStoryboard* storyBoard =  [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

requestViewViewController *paneViewController = [storyBoard instantiateViewControllerWithIdentifier:@"Tickets"];

[self.navigationController pushViewController:paneViewController animated:YES];

    */
}

#pragma mark - user Defoults 

/*
 set
 [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"parkingCount"];
 
	[[NSUserDefaults standardUserDefaults] synchronize];
 
 
 get 
 
 NSString *savedValue = [[NSUserDefaults standardUserDefaults]
 stringForKey:@"parkingCount"];
 
 
 */
@end
