//
//  RJCell.m
//  TableViewController
//
//  Created by Kevin Muldoon & Tyler Fox on 10/5/13.
//  Copyright (c) 2013 RobotJackalope. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RJTableViewCell.h"

@interface RJTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation RJTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.titleLabel setNumberOfLines:1];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        
        self.bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bodyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.bodyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.bodyLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.bodyLabel setNumberOfLines:0];
        [self.bodyLabel setTextAlignment:NSTextAlignmentLeft];
        [self.bodyLabel setTextColor:[UIColor darkGrayColor]];
        [self.bodyLabel setBackgroundColor:[UIColor clearColor]];
        
        self.footnoteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.footnoteLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.footnoteLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [self.footnoteLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        [self.footnoteLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.footnoteLabel setNumberOfLines:1];
        [self.footnoteLabel setTextColor:[UIColor blackColor]];
        [self.footnoteLabel setBackgroundColor:[UIColor clearColor]];
        
        self.imageViewForGoldStar = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.imageViewForGoldStar setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.imageViewForGoldStar.contentMode = UIViewContentModeCenter;

        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bodyLabel];
        [self.contentView addSubview:self.footnoteLabel];
        [self.contentView addSubview:self.imageViewForGoldStar];

        [self updateFonts];
    }
    
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (self.didSetupConstraints) return;

    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0f
                                     constant:kLabelHorizontalInsets]];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                     constant:(kLabelHorizontalInsets / 2)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0f
                                     constant:-kLabelHorizontalInsets]];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeLeading
                                      multiplier:1.0f
                                      constant:kLabelHorizontalInsets]];
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.titleLabel
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:(kLabelHorizontalInsets / 4)]];
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0f
                                      constant:-kLabelHorizontalInsets]];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.footnoteLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.bodyLabel
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:(kLabelHorizontalInsets / 4)]];
    
    // Hang the footnoteLabel on right side of contentView
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.footnoteLabel
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0f
                                      constant:-kLabelHorizontalInsets]];
    
    // Whatever the bottom object is, but sure to attatch it to bottom of contentView so cell expands automatically.
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.footnoteLabel
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:-(kLabelHorizontalInsets / 2)]];
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // And for a bit of fanciness, how about a nice gold star placed at left of self.footnoteLabel
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.imageViewForGoldStar
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.footnoteLabel
                                      attribute:NSLayoutAttributeTop
                                      multiplier:1.0f
                                      constant:0.0f]];
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.imageViewForGoldStar
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.footnoteLabel
                                      attribute:NSLayoutAttributeLeading
                                      multiplier:1.0f
                                      constant:-4.0f]];
    

    self.didSetupConstraints = YES;
}

- (void)updateFonts
{
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    self.footnoteLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
