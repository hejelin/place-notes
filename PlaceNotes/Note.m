//
//  Note.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize title;
@synthesize note;
@synthesize objectId;

-(instancetype) initWithPFObject:(PFObject *)obj {
    self = [super init];
    
    self.objectId = obj[@"objectId"];
    self.note = obj[@"note"];
    self.title = obj[@"title"];
    
    return self;
}

- (BOOL)isEqual:(id)object {
    
    if (self.objectId == ((PFObject *) object)[@"objectId"]) {
        return true;
    } else {
        return false;
    }
}

- (BOOL)isUpdated:(id)object {
    if (self.objectId == ((Note *)object).objectId && (self.title != title || self.note != note)) {
        return true;
    } else {
        return false;
    }
}


@end