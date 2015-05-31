//
//  NoteCell.m
//  PlaceNotes
//
//  Created by Elin Nilsson on 2015-05-30.
//  Copyright (c) 2015 Elin Nilsson. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)awakeFromNib {
    // Initialization code
    self.dateLabel.hidden = true;
    self.deleteButton.hidden = true;
    self.editButton.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.dateLabel.hidden = false;
    self.deleteButton.hidden = false;
    self.editButton.hidden = false;
}


@end
