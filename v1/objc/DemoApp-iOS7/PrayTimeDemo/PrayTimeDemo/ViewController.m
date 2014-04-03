//
//  ViewController.m
//  PrayTimeDemo
//
//  Created by Ibrahim Qraiqe on 03/04/14.
//  Copyright (c) 2014 Ibrahim Qraiqe. All rights reserved.
//

#import "ViewController.h"
#import "PrayTime.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *prays;
}


@property (weak, nonatomic) IBOutlet UILabel *placeLbl;
@property (weak, nonatomic) IBOutlet UITableView *praysTableView;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    PrayTime *prayTime = [[PrayTime alloc]init];
    //Place latitude and longituse EXAMPLE MAKKA SAUDIA ARABIA
    prayTime.lat = 21.4167;
    prayTime.lng = 39.8167;
    
    //Prays Adjusment if any
    prayTime.offsets = [NSMutableArray arrayWithObjects:
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:0], nil];
    
    //Place Time Zone + DST
    prayTime.timeZone = 3+0;//0 is The day light saving value for Suadia Arabia
    //Time Format
    prayTime.timeFormat = Time12;
    //Calculation Method
    prayTime.calcMethod = Makkah;
    //High Latitude places SPecaial places like norway in North
    prayTime.highLatsMethod = None;
    //Asr calculation method
    prayTime.asrMethod = Shafii;
    //Set the calculation day
    [prayTime setDateForJdate:[NSDate date]];

    NSMutableArray *array = [NSMutableArray array];
    for (NSString *prayTimeString in [prayTime computeDayTimes]) {
        NSString *timeName = [prayTime.timeNames objectAtIndex:[[prayTime computeDayTimes] indexOfObject:prayTimeString]];
        NSDictionary *dict = @{@"prayTimeString":prayTimeString,
                               @"timeName":timeName};
        [array addObject:dict];
    }
    prays = [array copy];
    
    
    self.placeLbl.text = [NSString stringWithFormat:@"Makkah Saudi Arabia Accurate Prayer Times for %@",[[NSDate date]description]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return prays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *dict = [prays objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"timeName"];
    cell.detailTextLabel.text = [dict objectForKey:@"prayTimeString"];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
