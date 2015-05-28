//
//  TableViewController.h
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface NotesViewController : UITableViewController <EditViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *notes;

@end
