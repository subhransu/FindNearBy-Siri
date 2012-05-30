//
//  ViewController.m
//  FindNearBy
//
//  Created by Behera, Subhransu on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

/**
 * The login parameters should be specified in the following manner:
 * 
 * const unsigned char SpeechKitApplicationKey[] =
 * {
 *     0x38, 0x32, 0x0e, 0x46, 0x4e, 0x46, 0x12, 0x5c, 0x50, 0x1d,
 *     0x4a, 0x39, 0x4f, 0x12, 0x48, 0x53, 0x3e, 0x5b, 0x31, 0x22,
 *     0x5d, 0x4b, 0x22, 0x09, 0x13, 0x46, 0x61, 0x19, 0x1f, 0x2d,
 *     0x13, 0x47, 0x3d, 0x58, 0x30, 0x29, 0x56, 0x04, 0x20, 0x33,
 *     0x27, 0x0f, 0x57, 0x45, 0x61, 0x5f, 0x25, 0x0d, 0x48, 0x21,
 *     0x2a, 0x62, 0x46, 0x64, 0x54, 0x4a, 0x10, 0x36, 0x4f, 0x64
 * };
 * 
 * Please note that all the specified values are non-functional
 * and are provided solely as an illustrative example.
 * 
 */

const unsigned char SpeechKitApplicationKey[] = {INSERT_YOUR_APPLICATION_KEY_HERE};

@interface ViewController ()

@end

@implementation ViewController
@synthesize voiceRecognizer, stationsArray, restaurantsArray, resultArray;
static BOOL isRecordingOn;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    resultTextView.layer.cornerRadius = 8;
    resultTableView.layer.cornerRadius = 8;
    
    isRecordingOn = NO;
    
    /**    
     * The login parameters should be specified in the following manner:
     *
     *  [SpeechKit setupWithID:@"ExampleSpeechKitSampleID"
     *                    host:@"ndev.server.name"
     *                    port:1000
     *                  useSSL:NO
     *                delegate:self];
     *
     * Please note that all the specified values are non-functional
     * and are provided solely as an illustrative example.
     */ 
    
    [SpeechKit setupWithID:INSERT_YOUR_APPLICATION_ID_HERE
                      host:INSERT_YOUR_HOST_ADDRESS_HERE
                      port:INSERT_YOUR_HOST_PORT_HERE
                    useSSL:NO
                  delegate:self];
    
    stationArray = [[NSMutableArray alloc] initWithObjects:
                    @"One-North",
                    @"Bounavista", 
                    @"Kentridge", 
                    @"Commonwealth", 
                    @"Queenstown", 
                    nil];
    
    restaurantArray = [[NSMutableArray alloc] initWithObjects:
                       @"Pasta-Mania", 
                       @"Koryo Restaurant",
                       @"Thai Express",
                       @"Kopitiam", 
                       @"Penang Place", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

# pragma mark - methods for speech kit

-(IBAction)listenBtnTapped:(id)sender {
    if (!isRecordingOn) {
        isRecordingOn = YES;
        self.voiceRecognizer = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType 
                                                        detection:SKShortEndOfSpeechDetection 
                                                         language:@"en_US" 
                                                         delegate:self];
    }
}

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer {
    [listenBtn setTitle:@"Listening..." forState:UIControlStateNormal];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer {
    [listenBtn setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results {
    
    long resultCount = [results.results count];
    
    if (resultCount > 0) {
        resultTextView.text = results.firstResult;
        
        if ([results.firstResult.capitalizedString  isEqualToString:@"Station"] || 
            [results.firstResult.capitalizedString  isEqualToString:@"Stations"]) {
            
            resultArray = [[NSMutableArray alloc] initWithArray:stationArray];
        }
        
        else if ([results.firstResult.capitalizedString  isEqualToString:@"Restaurant"] || 
                 [results.firstResult.capitalizedString  isEqualToString:@"Restaurants"]) {
            resultArray = [[NSMutableArray alloc] initWithArray:restaurantArray];
        }
        
        else {
            if (resultArray && [resultArray count] > 0) {
                [resultArray removeAllObjects];
            }
        }
    }
    
    [resultTableView reloadData];
    
    NSLog(@"result is %@", results.firstResult);
    
    [listenBtn setTitle:@"Listen" forState:UIControlStateNormal];
    isRecordingOn = NO;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion {
    
    resultTextView.text = suggestion;
    
    if (resultArray && [resultArray count] > 0) {
        [resultArray removeAllObjects];
    }
    
    [resultTableView reloadData];

    [listenBtn setTitle:@"Listen" forState:UIControlStateNormal];
    isRecordingOn = NO;
}


                                
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *informationIdentifier = @"RequesterInformation";
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                  reuseIdentifier:informationIdentifier]; 
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];        
    cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
    
    return cell;
}                                
                                
                                
@end
