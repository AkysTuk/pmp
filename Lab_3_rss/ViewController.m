//
//  ViewController.m
//  Lab_3_rss
//
//  Created by Admin on 25.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    NSURLConnection *_connection;
    NSMutableData *_data;
    NSArray *_topics;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error = nil;
    SMXMLDocument *xmlDoc = [SMXMLDocument documentWithData :_data error: &error];
    
    _topics = [[xmlDoc childNamed:@"channel" ]childrenNamed:@"item"];
    [_tableView reloadData];
    _data = nil;
    _connection = nil;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topics.count;
}

- (IBAction)downloadRss:(id)sender {
    NSString *urlString =
    @"http://images.apple.com/main/rss/hotnews/hotnews.rss";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"]; if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    SMXMLElement *item = _topics[indexPath.row]; cell.textLabel.text = [item childNamed:@"title"].value; return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMXMLElement *item = _topics[indexPath.row];
    NSString *urlString = [item childNamed:@"link"].value;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [NSMutableData data]; }

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data]; }


@end
