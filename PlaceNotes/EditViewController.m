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
        self.titleField.text = self.note.title;
        self.noteField.text = self.note.note;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegate function
- (IBAction)saveFormData:(id)sender {
    NSString *title = self.titleField.text;
    NSString *note = self.noteField.text;
    
    // If URL is correct, the data is sent to the delegate, else user is alerted
    if (note.length > 0 && title.length == 0) {
        [self.delegate didSaveNote:note];
    } else if (note.length > 0 && title.length > 0) {
        [self.delegate didSaveNote:note Title:title];
    } else {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Empty"
                                                                                     message:@"You can't create an empty note"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertViewController addAction:okButton];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

@end
