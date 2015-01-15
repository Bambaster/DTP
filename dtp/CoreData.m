//
//  CoreData.m
//  LIFEHUCKS
//
//  Created by Lowtrack on 17.11.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import "CoreData.h"
#import "AppDelegate.h"

@implementation CoreData


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void) writeData: (NSString * ) entety_Name Value:(NSData *) value Key:(NSString *) key {
    
    NSLog(@"writeData");

    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newOrderDate = [NSEntityDescription insertNewObjectForEntityForName:entety_Name inManagedObjectContext:context];
    [newOrderDate setValue:value forKey:key];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (void) writeClass: (NSString * ) entety_Name Value:(NSString *) value Key:(NSString *) key {
    
    NSLog(@"writeData");
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newOrderDate = [NSEntityDescription insertNewObjectForEntityForName:entety_Name inManagedObjectContext:context];
    [newOrderDate setValue:value forKey:key];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}


- (NSMutableArray *) getClass: (NSString * ) entety_Name Key:(NSString *) key {
    
    
    NSMutableArray * classes = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entety_Name inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    //  NSLog(@"dictData - %@", dictData);
    
    
    for (NSManagedObject* obj in dictData) {
        
        
        
        [classes addObject:[obj valueForKey:key]];
        
        //    NSLog(@"obj - %@", [obj valueForKey:key]);
        
        
    }
    
    
    //  NSLog(@"favorits_GIF - %@", favorits_GIF);
    
    return classes;
    
}


- (NSMutableArray *) getData: (NSString * ) entety_Name Key:(NSString *) key {
    
    
    NSMutableArray * favorits_GIF = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entety_Name inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
  //  NSLog(@"dictData - %@", dictData);

    
    for (NSManagedObject* obj in dictData) {
        

            
            [favorits_GIF addObject:[obj valueForKey:key]];
            
        //    NSLog(@"obj - %@", [obj valueForKey:key]);

        
    }

    
  //  NSLog(@"favorits_GIF - %@", favorits_GIF);

    return favorits_GIF;
    
}



//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------

- (void) writeIndex: (NSString * ) entety_Name Value:(NSString *) value Key:(NSString *) key {
    
    NSLog(@"writeData");
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entety_Name inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    
    if ([dictData count] > 0) {
        NSUInteger counter = 0;
        id obj = [dictData objectAtIndex:counter];
        NSManagedObject *newSession = (NSManagedObject* ) obj;
        [newSession setValue:value forKey:key];

        
        
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    

    
}



- (NSString *) getIndex: (NSString * ) entety_Name Key:(NSString *) key {
    
    
    NSString * index = [[NSString alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entety_Name inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    //  NSLog(@"dictData - %@", dictData);
    
    
    int i = 0;
    for (NSManagedObject* obj in dictData) {
        
        if (i > 0) {
            
           index = [obj valueForKey:key];
            
            //    NSLog(@"obj - %@", [obj valueForKey:key]);
            
        }
        ++i;
        
        
        
        
    }
    
    
    //  NSLog(@"favorits_GIF - %@", favorits_GIF);
    
    return index;
    
}



//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------


- (void) clear_Entity: (NSString *) entity_value {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * requestData = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entity_value inManagedObjectContext:self.managedObjectContext];
    [requestData setEntity:entityData];
    NSError * requestError = nil;
    NSArray * dictData = [context executeFetchRequest:requestData error:&requestError];
    
    for (NSManagedObject *managedObject in dictData) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",context);
    }
    if (![context save:&requestError]) {
        
        
        NSLog (@"Error deleting %@ - error:%@",context,requestError);
        
    }

}



@end
