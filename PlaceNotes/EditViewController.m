//
//  ViewController.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.note != nil) {
        self.titleField.text = self.note[@"title"];
        self.noteField.text = self.note[@"note"];
    }
}

// Delegate function
- (IBAction)saveFormData:(id)sender {
    NSString *title = self.titleField.text;
    NSString *note = self.noteField.text;
    
    if (self.note != nil) {
        [self.delegate didUpdateNote:self.note Note:note Title:title];
    } else {
        // If title and note is correct, the data is sent to the delegate, else user is alerted
        if (note.length > 0 && title.length > 0) {
            [self.delegate didSaveNote:note Title:title];
        } else {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Empty"
                                                                                         message:@"You can't create an empty note, it has to have a title and note"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertViewController addAction:okButton];
        
            [self presentViewController:alertViewController animated:YES completion:nil];
        }
    }
}

@end
