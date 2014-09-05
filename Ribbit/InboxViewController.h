//
//  InboxViewController.h
//  Ribbit
//
//  Created by Kevin Duck on 8/18/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

- (IBAction)logout:(id)sender;

@end
