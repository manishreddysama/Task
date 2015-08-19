//
//  ViewController.m
//  WebServicesDemo
//
//  Created by MANISH on 19/08/15.
//  Copyright (c) 2015 Demo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.arrPlaces = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)makeAsynCall:(id)sender {
	
	NSString *strURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/xml?location=-33.8670522,151.1957362&radius=50000&types=hospital&name=hospital&sensor=false&key=AIzaSyCOCyYJxZM7tew1JdCAEVVHLGczOabEWyk";
	NSURL *url = [NSURL URLWithString:strURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(conn)
	{
		NSLog(@"Connectd");
	}
	else{
		NSLog(@"Not connected");
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
	NSXMLParser *parseObj = [[NSXMLParser alloc] initWithData:_data];
	parseObj.delegate = self;
	[parseObj parse];
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	if(_arrPlaces)
	{
		self.arrPlaces = nil;
	}
	self.arrPlaces = [NSMutableArray array];
	NSLog(@"Parser Started!!!");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	
	NSLog(@"Parser End!!! %@", _arrPlaces);
	[_tblLocations reloadData];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	// NSLog(@"The start element name: %@", elementName);
	if([elementName isEqualToString:@"result"])
	{
		self.dicTemp = [NSMutableDictionary dictionary];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"name"])
	{
		[_dicTemp setObject:_strTemp forKey:@"Name"];
	}
	else if([elementName isEqualToString:@"vicinity"])
	{
		[_dicTemp setObject:_strTemp forKey:@"Vicinity"];
	}
	else if([elementName isEqualToString:@"lat"])
	{
		[_dicTemp setObject:_strTemp forKey:@"Latitude"];
	}
	else if([elementName isEqualToString:@"lng"])
	{
		[_dicTemp setObject:_strTemp forKey:@"Longtitude"];
	}
	else if([elementName isEqualToString:@"icon"])
	{
		[_dicTemp setObject:_strTemp forKey:@"Icon"];
	}
	else if([elementName isEqualToString:@"result"])
	{
		[_arrPlaces addObject:_dicTemp];
		self.dicTemp = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	self.strTemp = string;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"The error: %@", parseError);
}
- (IBAction)makeSynchronousCall:(id)sender {
	
	NSString *strURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/xml?location=-33.8670522,151.1957362&radius=50000&types=food&name=food&sensor=false&key=AIzaSyCOCyYJxZM7tew1JdCAEVVHLGczOabEWyk";
	NSURL *url = [NSURL URLWithString:strURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLResponse *response = nil;
	NSError *err = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	
	NSXMLParser *parseObj = [[NSXMLParser alloc] initWithData:data];
	parseObj.delegate = self;
	[parseObj parse];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrPlaces count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [_tblLocations dequeueReusableCellWithIdentifier:@"Cell"];
	NSDictionary *dic = [_arrPlaces objectAtIndex:indexPath.row];
	cell.textLabel.text = [dic objectForKey:@"Name"];
	cell.detailTextLabel.text = [dic objectForKey:@"Vicinity"];
	return cell;
}
@end
