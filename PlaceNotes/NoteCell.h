//
//  NoteCell.h
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-05-30.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *editButton;
@property (weak, nonatomic) IBOutlet UIView *deleteButton;

@end
