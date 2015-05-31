//
//  NotesViewController.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "NotesViewController.h"
#import "EditViewController.h"
#import "Note.h"
#import <Parse/Parse.h>

@interface NotesViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic) NSInteger expandedCellIndex;

@end

@implementation NotesViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.expandedCellIndex = -1;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceFilterDidChange:) name:@"ChangedDistance" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:@"ChangedLocation" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesWereUpdated:) name:@"UpdatedNotes" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Empty cells won't be shown
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Authorize location usage
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
    }
    
    [self loadNotes];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
}

- (void)loadNotes {
    
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLocation:self.locationManager.location];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    [query whereKey:@"location" nearGeoPoint:userGeoPoint withinKilometers:0.3];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.notes removeAllObjects]; //TODO - check, hämta bara ny data
            self.notes = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Location manager delegate methods

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.currentLocation == currentLocation) {
        return;
    }
    
    _currentLocation = currentLocation;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedLocation"
                                                            object:nil];
    });
}


#pragma mark - EditViewController delegate methods

- (void)didSaveNote:(NSString *)note Title:(NSString *)title {
    
    CLLocationCoordinate2D coords = self.currentLocation.coordinate;
    
    // User location to Parse geopoint
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:coords.latitude
                           longitude:coords.longitude];
    
    // Parse note object
    PFObject *noteObj = [PFObject objectWithClassName:@"Note"];
    noteObj[@"title"] = title;
    noteObj[@"note"] = note;
    noteObj[@"location"] = currentPoint;
    [noteObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
    }];
    
    // Dispatch notification about created note
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedNotes" object:nil];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didUpdateNote:(PFObject *)noteObj Note:(NSString *)note Title:(NSString *)title {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    
    // Retrieve note object by Parse id, and update it
    [query getObjectInBackgroundWithId:noteObj.objectId
                                 block:^(PFObject *noteUpd, NSError *error) {
                                     if (!error) {
                                         noteUpd[@"title"] = title;
                                         noteUpd[@"note"] = note;
                                         [noteUpd saveInBackground];
                                     }
                                 }];
    
    // Dispatch notification about updated note
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedNotes" object:nil];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.notes.count == 0) {
        UILabel *noNotesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        noNotesLabel.text = @"You have no notes at this location";
        noNotesLabel.font = [UIFont  fontWithName:@"HelveticaNeue-Light" size:18.0];
        noNotesLabel.textColor = self.view.tintColor;
        noNotesLabel.numberOfLines = 0;
        noNotesLabel.textAlignment = NSTextAlignmentCenter;
        [noNotesLabel sizeToFit];
        self.tableView.backgroundView = noNotesLabel;
    } else {
        self.tableView.backgroundView = nil;
    }
    
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    PFObject *note = self.notes[indexPath.row];
    
    cell.textLabel.text = note[@"title"];
    cell.detailTextLabel.text = note[@"note"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.expandedCellIndex == indexPath.row) {
        self.expandedCellIndex = -1;
    }
    else {
        self.expandedCellIndex = indexPath.row;
//        [self.tableView cellForRowAtIndexPath:indexPath].subviews
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_expandedCellIndex == indexPath.row) {
        return 75;
    } else {
        return 150;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete object from Parse
        PFQuery *query = [PFQuery queryWithClassName:@"Note"];
        [query getObjectInBackgroundWithId:[[self.notes objectAtIndex:indexPath.row] objectId] block:^(PFObject *note, NSError *error) {
            [note deleteInBackground];
        }];
        
        [self.notes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (IBAction)deleteCell {
    // Delete object from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    [query getObjectInBackgroundWithId:[[self.notes objectAtIndex:self.expandedCellIndex] objectId] block:^(PFObject *note, NSError *error) {
        [note deleteInBackground];
    }];
    
    [self.notes removeObjectAtIndex:self.expandedCellIndex];
    [self loadNotes];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // If add, set delegate. If edit, set delegate and note to be edited.
    if ([segue.identifier isEqualToString:@"addSegue"]) {
        ((EditViewController *) segue.destinationViewController).delegate = self;
    } else if ([segue.identifier isEqualToString:@"editSegue"]) {
        ((EditViewController *) segue.destinationViewController).delegate = self;
        EditViewController *evc = (EditViewController *) segue.destinationViewController;
        evc.note = [self.notes objectAtIndex:self.expandedCellIndex];
    }
}

// Closes edit/add view if cancelled
- (IBAction)unwindToNotesView:(UIStoryboardSegue *)segue {
}

- (void)locationDidChange:(NSNotification *)note {
    [self loadNotes];
}

- (void)notesWereUpdated:(NSNotification *)note {
    [self loadNotes];
}

@end
