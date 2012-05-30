//
//  ViewController.h
//  FindNearBy
//
//  Created by Behera, Subhransu on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>

@interface ViewController : UIViewController <SKRecognizerDelegate, UITableViewDataSource, UITableViewDelegate> {
    SKRecognizer *voiceRecognizer;
    
    IBOutlet UIButton *listenBtn;
    IBOutlet UITextView *resultTextView;
    IBOutlet UITableView *resultTableView;
    
    NSMutableArray *stationArray, *restaurantArray, *resultArray;
}

@property(nonatomic, strong) SKRecognizer *voiceRecognizer;
@property(nonatomic, strong) NSMutableArray *stationsArray, *restaurantsArray, *resultArray;

-(IBAction)listenBtnTapped:(id)sender;

@end
