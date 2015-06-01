//
//  Note.h
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Note : PFObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, strong) NSString *objectId;


- (instancetype)initWithPFObject:(PFObject *) obj;
- (BOOL)isUpdated:(id)object;

@end
