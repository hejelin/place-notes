//
//  Note.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "Note.h"

@implementation Note

-(instancetype) initWithNote:(NSString *)note
                    Location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if (self) {
        self.note = note;
        self.location = location;
    }
    
    
    
    return self;
}

-(instancetype) initWithNote:(NSString *)note
                       Title:(NSString *)title
                    Location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if (self) {
        self.note = note;
        self.title = title;
        self.location = location;
    }
    
    return self;
}

-(BOOL)isEqual:(id)object {

    Note *note = (Note *) object;
    
    if (self.title == note.title && self.note == note.note) {
        return true;
    } else {
        return false;
    }
}


@end
