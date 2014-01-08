//
//  RJTableViewController.m
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

#import "RJTableViewController.h"
#import "RJModel.h"
#import "RJTableViewCell.h"

static NSString *CellIdentifier = @"CellIdentifier";
static CGFloat kLineSpacing = 10.0f;

@interface RJTableViewController ()
@property (strong, nonatomic) RJModel *model;
// This property is used to work around the constraint exception that is thrown if the
// estimated row height for an inserted row is greater than the actual height for that row.
// See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
@property (assign, nonatomic) BOOL isInsertingRow;
@end

@implementation RJTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Table View Controller";
        self.model = [[RJModel alloc] init];
        [self.model populateDataSource];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[RJTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UISegmentedControl *segmentedControl =  [[UISegmentedControl alloc] initWithItems:@[@"A-M", @"N-Z"]];
    [segmentedControl addTarget:self
                         action:@selector(segmentedControlSelectionDidChange:)
               forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSelectedSegmentIndex:0];
    [self segmentedControlSelectionDidChange:segmentedControl];

    self.navigationItem.titleView = segmentedControl;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clear:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRow:)];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)clear:(id)sender
{
    NSMutableArray *rowsToDelete = [NSMutableArray new];
    for (NSUInteger i = 0; i < [self.model.dataSource count]; i++) {
        [rowsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.model = [[RJModel alloc] init];
    
    [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
}

- (void)segmentedControlSelectionDidChange:(UISegmentedControl *)sender {
    
    [self.model filterDataSourceBySegmentIndex:sender.selectedSegmentIndex];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

- (void)addRow:(id)sender
{
    [self.model addSingleItemToDataSource];
    
    self.isInsertingRow = YES;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.model.dataSource count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.isInsertingRow = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell updateFonts];

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // IMPORTANT: This block of code must be duplicated within tableView:heightForRowAtIndexPath method
    
    // You can set the text of labels here, or comment out these three lines and uncomment the following lines...
    cell.titleLabel.text =  [self.model titleForIndex:indexPath.row];
    cell.bodyLabel.text =  [self.model bodyForIndex:indexPath.row];
    cell.footnoteLabel.text =  [self.model footnoteForIndex:indexPath.row];
    
    
    // ...uncomment the following lines to experiment with leading of bodyLabel using kLineSpacing defined at top of class.
    /*
     cell.titleLabel.text =  [self.model titleForIndex:indexPath.row];
     
     NSString *bodyText = [self.model bodyForIndex:indexPath.row];
     NSMutableAttributedString *bodyAttributedText = [[NSMutableAttributedString alloc] initWithString:bodyText];
     NSMutableParagraphStyle *bodyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
     [bodyParagraphStyle setLineSpacing:kLineSpacing];
     [bodyAttributedText addAttribute:NSParagraphStyleAttributeName value:bodyParagraphStyle range:NSMakeRange(0, bodyText.length)];
     cell.bodyLabel.attributedText = bodyAttributedText;
     
     cell.footnoteLabel.text =  [self.model footnoteForIndex:indexPath.row];
     */
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Add a gold star here, or don't.
    cell.imageViewForGoldStar.image = [UIImage imageNamed:@"goldStar"];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell updateFonts];
    
    //
    // It is unfortunate making autoLayout work with UITableView/UITableCell requires a duplication of building of strings in
    // – tableView:heightForRowAtIndexPath: as well as method tableView:cellForRowAtIndexPath: So be aware if you see unexpected
    // behavior, check to see the building of titleText and bodyText is identical in both methods.
    //
    NSString *titleText = [self.model titleForIndex:indexPath.row];
    NSMutableAttributedString *titleAttributedText = [[NSMutableAttributedString alloc] initWithString:titleText];
    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [titleParagraphStyle setLineSpacing:3.0f];
    [titleAttributedText addAttribute:NSParagraphStyleAttributeName value:titleParagraphStyle range:NSMakeRange(0, titleText.length)];
    cell.titleLabel.attributedText = titleAttributedText; // Yes, darned silly to set leading of a single line textField but we aim for consistancy.

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // IMPORTANT: This block of code must be duplicated within tableView:cellForRowAtIndexPath method
    
    // You can set the text of labels here, or comment out these three lines and uncomment the following lines...
    cell.titleLabel.text =  [self.model titleForIndex:indexPath.row];
    cell.bodyLabel.text =  [self.model bodyForIndex:indexPath.row];
    cell.footnoteLabel.text = [self.model footnoteForIndex:indexPath.row];

   
    // ...uncomment the following lines to experiment with leading of bodyLabel using kLineSpacing defined at top of class.
    /*
    cell.titleLabel.text =  [self.model titleForIndex:indexPath.row];

    
    NSString *bodyText = [self.model bodyForIndex:indexPath.row];
    NSMutableAttributedString *bodyAttributedText = [[NSMutableAttributedString alloc] initWithString:bodyText];
    NSMutableParagraphStyle *bodyParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [bodyParagraphStyle setLineSpacing:kLineSpacing];
    [bodyAttributedText addAttribute:NSParagraphStyleAttributeName value:bodyParagraphStyle range:NSMakeRange(0, bodyText.length)];
    cell.bodyLabel.attributedText = bodyAttributedText;


    
    cell.footnoteLabel.text =  [self.model footnoteForIndex:indexPath.row];
    */
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    cell.bodyLabel.preferredMaxLayoutWidth = tableView.bounds.size.width - (kLabelHorizontalInsets * 2.0f);
    
    // No, you don't need to use an NSAttributedString, but it's helpful if you want to adjust leading (line spacing).
    // So if you simply want to use a regular string with default leading, comment out the text above and uncomment
    // the following code, keeping in mind you'll need to duplicate building of string in method tableView:heightForRowAtIndexPath:
    /*
     cell.bodyLabel.text = [self.model bodyForIndex:indexPath.row];
     cell.titleLabel.text = [self.model titleForIndex:indexPath.row];
     */
    
    // Update Constraints here
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
    
    /*
     // Found this code to cause issue where the cell contentView would not compress to the cells contents.
    // Update Constraints here
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // Do the initial layout pass of the cell's contentView & subviews
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    // Since we have multi-line labels, set the preferredMaxLayoutWidth now that their width has been determined,
    // and then do a second layout pass so they can take on the correct height
    cell.bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.bodyLabel.frame);
    [cell.contentView layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
    */
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isInsertingRow) {
        // A constraint exception will be thrown if the estimated row height for an inserted row is greater
        // than the actual height for that row. In order to work around this, we return the actual height
        // for the the row when inserting into the table view.
        // See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
        return [self tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 500.0f;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //
    // I've notice a bug when rotating iOS device. Cells with multi-line labels will not compress when entering landscape mode
    // leaving a lot of extra white space at top and bottom of the cell.  Must circle back and correct this behavior. Suspect
    // this is happening in tableView:estimatedHeightForRowAtIndexPath which may need to be re-called programatically.
    //
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView updateConstraintsIfNeeded];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
