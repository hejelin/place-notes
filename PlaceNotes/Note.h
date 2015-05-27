//
//  Note.h
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *note;
@property (nonatomic) CLLocationCoordinate2D location;

-(instancetype) initWithNote:(NSString *)note
                    Location:(CLLocationCoordinate2D)location;

-(instancetype) initWithNote:(NSString *)note
                       Title:(NSString *)title
                    Location:(CLLocationCoordinate2D)location;



@end
