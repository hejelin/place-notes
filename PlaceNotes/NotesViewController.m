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

@end

@implementation NotesViewController


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceFilterDidChange:) name:@"ChangedDistance" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:@"ChangedLocation" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesWereUpdated:) name:@"UpdatedNotes" object:nil];
    }
    
    return self;
}


- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
        NSLog(@"%@", self.currentLocation);
    }
    
    [self loadNotes];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
}

- (void)loadNotes {
    // User's location
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLocation:self.locationManager.location];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    [query whereKey:@"location" nearGeoPoint:userGeoPoint withinKilometers:1];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {  // The query failed
            NSLog(@"error in geo query!");
        } else {  // The query is successful
            [self.notes removeAllObjects];
            self.notes = [objects mutableCopy];
            [self.tableView reloadData];
            NSLog(@"loaded notes");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


// Delegate method, grab data and create new note
- (void)didSaveNote:(NSString *)note Title:(NSString *)title {
    NSLog(@"Sparar med titel %@ och note %@", title, note);
    
    CLLocationCoordinate2D coords = self.currentLocation.coordinate;
    
    // Create a PFGeoPoint using the user's location
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:coords.latitude
                           longitude:coords.longitude];
    
    // Create a PFObject using the Post class and set the values we extracted above
    PFObject *noteObj = [PFObject objectWithClassName:@"Note"];
    noteObj[@"title"] = title;
    noteObj[@"note"] = note;
    noteObj[@"location"] = currentPoint;
    [noteObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {  // Failed to save, show an alert view with the error message
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedNotes" object:nil];
    });
    
    NSLog(@"Saved new note");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didUpdateNote:(PFObject *)noteObj Note:(NSString *)note Title:(NSString *)title {
    NSLog(@"Uppdaterar id %@ med titel %@ och note %@", noteObj.objectId, title, note);

    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:noteObj.objectId
                                 block:^(PFObject *noteUpd, NSError *error) {
                                     noteUpd[@"title"] = title;
                                     noteUpd[@"note"] = note;
                                     [noteUpd saveInBackground];
                                 }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedNotes" object:nil];
    });
    
    NSLog(@"Updated note");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"NoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // Hämta data.
    PFObject *note = self.notes[indexPath.row];
    
    // Konfigurera cellen
    cell.textLabel.text = note[@"title"];
    cell.detailTextLabel.text = note[@"note"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editSegue" sender:self.notes[indexPath.row]];
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

    } /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
       // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       }   */
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addSegue"]) {
        // If segue from edit view, set self to delegate
        ((EditViewController *) segue.destinationViewController).delegate = self;
    } else if ([segue.identifier isEqualToString:@"editSegue"]) {
        ((EditViewController *) segue.destinationViewController).delegate = self;
        EditViewController *evc = (EditViewController *) segue.destinationViewController;
        evc.note = sender;
    }
}


// Closes edit view if cancelled
- (IBAction)unwindToNotesView:(UIStoryboardSegue *)segue {
}

- (void)distanceFilterDidChange:(NSNotification *)note {
    [self loadNotes];
}

- (void)locationDidChange:(NSNotification *)note {
    [self loadNotes];
}

- (void)notesWereUpdated:(NSNotification *)note {
    [self loadNotes];
}

@end
