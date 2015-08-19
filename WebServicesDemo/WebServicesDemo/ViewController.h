//
//  ViewController.h
//  WebServicesDemo
//
//  Created by MANISH on 19/08/15.
//  Copyright (c) 2015 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate, NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnSynchronous;
@property (strong, nonatomic) IBOutlet UIButton *btnAsynch;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSMutableArray *arrPlaces;
@property (strong, nonatomic) NSMutableDictionary *dicTemp;
@property (strong, nonatomic) NSString *strTemp;
@property (strong, nonatomic) IBOutlet UITableView *tblLocations;


- (IBAction)makeAsynCall:(id)sender;

- (IBAction)makeSynchronousCall:(id)sender;
@end

