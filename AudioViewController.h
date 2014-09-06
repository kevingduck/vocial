//
//  AudioViewController.h
//  Ribbit
//
//  Created by Kevin Duck on 9/3/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioViewController.h"

@interface AudioViewController : UITableViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) PFObject *message;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
