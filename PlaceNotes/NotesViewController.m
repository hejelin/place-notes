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

@interface NotesViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegate method, grab data and create new note
- (void)didSaveNote:(NSString *)note Title:(NSString *)title {
    
    NSLog(@"Setting location");
    [self.locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D coords = self.locationManager.location.coordinate;
    
    Note *noteObj;
    
    if (title != nil) {
        noteObj = [[Note alloc] initWithNote:note Title:title Location:coords];
    } else {
        noteObj = [[Note alloc] initWithNote:note Location:coords];
    }
    
    NSLog(@"Location set");
    
    NSLog(@"lat %f and long %f", coords.latitude, coords.longitude);
    
    if ([self.notes containsObject:noteObj]) {
        [self.notes replaceObjectAtIndex:[self.notes indexOfObjectIdenticalTo:noteObj] withObject:noteObj];
    } else {
        [self.notes addObject:noteObj];
    }
    
    [self.tableView reloadData];
    
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
    Note *note = self.notes[indexPath.row];
    
    // Konfigurera cellen
    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = note.note;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editSegue" sender:self.notes[indexPath.row]];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
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

@end
