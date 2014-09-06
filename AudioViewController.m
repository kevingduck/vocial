//
//  AudioViewController.m
//  Ribbit
//
//  Created by Kevin Duck on 9/3/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDuckOthers
                   error:nil];
    [self startRecordingAudio];
    
    PFFile *audioFile = [self.message objectForKey:@"file"];
    
    /*
    NSURL *audioFileURL = [[NSURL alloc] initWithString:audioFile.url];
    NSData *audioFileData = [NSData dataWithContentsOfURL:audioFileURL];
    NSString *senderName = [self.message objectForKey:@"senderName"];
    
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
    */
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    UIViewController *audioView = [[UIViewController alloc] init];
    
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Error: missing selector");
    }
    
    [self presentViewController:audioView animated:YES completion:nil];
}

- (void) timeout {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) startRecordingAudio {
    NSError *error = nil;
    
    NSURL *audioRecordingURL = [self audioRecordingPath];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
    
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        
        //prepare recorder and start recording automatically
        
        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record]) {
            NSLog(@"Started recording audio");
            
            //stop recording after five seconds
            [self performSelector:@selector(stopRecordingOnAudioRecorder:)
                       withObject:self.audioRecorder
                       afterDelay:5.0f];
        } else {
            NSLog(@"Couldn't record audio");
            self.audioRecorder = nil;
        }
    } else {
        NSLog(@"Failed to create an instance of the audio recorder.");
    }
}

- (NSURL *)audioRecordingPath {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentsFolderUrl =
    [fileManager URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil
                          create:NO
                           error:nil];
    return [documentsFolderUrl
            URLByAppendingPathComponent:@"Recording.m4a"];
}

- (NSDictionary *) audioRecordingSettings{
    return @{
             AVFormatIDKey : @(kAudioFormatAppleLossless),
             AVSampleRateKey : @(44100.0f),
             AVNumberOfChannelsKey : @1,
             AVEncoderAudioQualityKey : @(AVAudioQualityLow),
             };
}

- (void) stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder{
    /* Just stop the audio recorder here */
    [paramRecorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag{
    if (flag) {
        NSLog(@"Stopped recording process");
        NSError *playbackError = nil;
        NSError *readingError = nil;
        NSData *fileData = [NSData dataWithContentsOfURL:[self audioRecordingPath]
                              options:NSDataReadingMapped
                                error:&readingError];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                         error:&playbackError];
        
        if (self.audioPlayer != nil) {
            self.audioPlayer.delegate = self;
            
            //Prepare and start playing
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
                NSLog(@"Started playing recorded audio");
            } else {
                NSLog(@"Couldn't play recorded audio");
            }
            
            
        } else {
            NSLog(@"Failed to create audio player");
        }
    } else {
        NSLog(@"Stopping audio recording failed");
    }
    
    self.audioRecorder = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    if (flag){
        NSLog(@"Audio player stopped correctly.");
    } else {
        NSLog(@"Audio player did not stop correctly.");
    }
    if ([player isEqual:self.audioPlayer]){
        self.audioPlayer = nil;
    } else {
        /* This is not our player */
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    /* The audio session has been deactivated here */
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                       withOptions:(NSUInteger)flags{
    if (flags == AVAudioSessionInterruptionOptionShouldResume){
        [player play];
    }
}


- (void)send:(id)sender {
}

- (void)cancel:(id)sender {
}


@end
