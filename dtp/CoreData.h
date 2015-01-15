//
//  CoreData.h
//  LIFEHUCKS
//
//  Created by Lowtrack on 17.11.14.
//  Copyright (c) 2014 AR for YOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreData : NSObject

- (NSMutableArray *) getData: (NSString * ) entety_Name Key:(NSString *) key;
- (void) writeData: (NSString * ) entety_Name Value:(NSData *) value Key:(NSString *) key;


- (NSString *) getIndex: (NSString * ) entety_Name Key:(NSString *) key;
- (NSMutableArray *) getClass: (NSString * ) entety_Name Key:(NSString *) key;
- (void) writeIndex: (NSString * ) entety_Name Value:(NSString *) value Key:(NSString *) key;
- (void) writeClass: (NSString * ) entety_Name Value:(NSString *) value Key:(NSString *) key;


- (void) clear_Entity: (NSString *) entity_value;


@end
