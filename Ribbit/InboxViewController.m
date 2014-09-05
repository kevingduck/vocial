//
//  InboxViewController.m
//  Ribbit
//
//  Created by Kevin Duck on 8/18/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "ImageViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
		
		PFUser *currentUser = [PFUser currentUser];
		if (currentUser) {
		} else {
			[self performSegueWithIdentifier:@"showLogin" sender:self];
		}
}

- (void) viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
	PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
	[query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
	[query orderByDescending:@"createdAt"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error %@ %@", error, [error userInfo]);
		} else {
			self.messages = objects;
			[self.tableView reloadData];
			NSLog(@"Got %d messages", [self.messages count]);
		}
	}];
	
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
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
		static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
		PFObject *message = [self.messages objectAtIndex:indexPath.row];
		cell.textLabel.text = [message objectForKey:@"senderName"];
		
		NSString *fileType = [message objectForKey:@"fileType"];
		if ( [fileType isEqualToString:@"image"] ) {
			cell.imageView.image = [UIImage imageNamed:@"icon_image"];
		} else {
			cell.imageView.image = [UIImage imageNamed:@"icon_video"];
		}
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
	NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];

	if ( [fileType isEqualToString:@"image"] ) {
			[self performSegueWithIdentifier:@"showImage" sender:self];
		} else {
            //file is video
            PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
            NSURL *fileURL = [NSURL URLWithString:videoFile.url];
            self.moviePlayer.contentURL = fileURL;
            [self.moviePlayer prepareToPlay];
            //add thumbnail while movie loads ... deprecated in iOS 7.0
            [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            
            //add it to the view controller so we can view it
            [self.view addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:YES];
            
		}
    
    //delete file from Parse
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"Recipients: %@", recipientIds);
    
    if ([recipientIds count] == 1) {
        [self.selectedMessage deleteInBackground];
    } else {
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }
}


- (IBAction)logout:(id)sender {
	[PFUser logOut];
	[self performSegueWithIdentifier:@"showLogin" sender:self];
	
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender	{
	if ( [segue.identifier isEqualToString:@"showLogin"] ) {
		[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
	} else if ([segue.identifier isEqualToString:@"showImage"]) {
		[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
		ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
		
		imageViewController.message = self.selectedMessage;
		
	}
}
@end
