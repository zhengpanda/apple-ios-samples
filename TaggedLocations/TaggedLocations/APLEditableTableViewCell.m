
/*
     File: APLEditableTableViewCell.m
 Abstract: Table view cell to present an editable text field to display tag names.
 The cell layout is mainly defined in the storyboard, but some Auto Layout constraints are redefined programmatically.
 
  Version: 2.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "APLEditableTableViewCell.h"

@interface APLEditableTableViewCell ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic) IBOutletCollection (NSLayoutConstraint) NSArray *originalConstraints;
@property (nonatomic) NSArray *contentViewConstraints;

@end



@implementation APLEditableTableViewCell

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    // Edit the text field should only be enabled when in editing mode.
    self.textField.enabled = editing;

    /*
     Auto Layout workaround:

     Constraints made in the storyboard to the superview of views in the content view are made instead to the table view cell itself. This means that when the cell enters the editing state the content is not properly moved out of the way of the editing icons (the content view is shrunk to move content out of the way).
    */

    // Remove original constraints.
    if (self.originalConstraints != nil) {
        [self removeConstraints:self.originalConstraints];
        self.originalConstraints = nil;
    }

    /*
     The constraints are different for editing/not editing, so create different visual format strings for each. Keep a reference to the constraints so they can be removed next time round.
    */
    
    // Remove any existing constraints from the content view.
    if (self.contentViewConstraints != nil) {
        [self.contentView removeConstraints:self.contentViewConstraints];
    }
    
    NSDictionary *viewBindingsDictionary = @{ @"textField" : self.textField };
    NSString *visualFormatString;
    if (editing) {
        visualFormatString = @"|-8-[textField]-|";
    }
    else {
        visualFormatString = @"|-[textField]-|";
    }

    // Create the new constraints.
    self.contentViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormatString options:0 metrics:nil views:viewBindingsDictionary];

    // Add the constraints to the content view.
    [self.contentView addConstraints:self.contentViewConstraints];
}


@end
