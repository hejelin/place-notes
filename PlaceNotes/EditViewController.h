//
//  ViewController.h
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-04-22.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import <Parse/Parse.h>

@protocol EditViewControllerDelegate <NSObject>

- (void)didSaveNote:(NSString *)note Title:(NSString *)title;
- (void)didUpdateNote:(PFObject *)noteObj Note:(NSString *)note Title:(NSString *)title;

@optional - (void)didSaveNote:(NSString *)note;

@end

@interface EditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *noteField;

@property (nonatomic, strong) PFObject *note;

@property (weak, nonatomic) IBOutlet id<EditViewControllerDelegate> delegate;

@end

