//--------------------- Copyright Block ----------------------
/*
 
 PrayTime.m: Prayer Times Calculator (ver 1.2)
 Copyright (C) 2007-2010 PrayTimes.org
 
 Objective C Code By: Hussain Ali Khan
 Original JS Code By: Hamid Zarrabi-Zadeh
 
 License: GNU General Public License, ver 3
 
 TERMS OF USE:
 Permission is granted to use this code, with or
 without modification, in any website or application
 provided that credit is given to the original work
 with a link back to PrayTimes.org.
 
 This program is distributed in the hope that it will
 be useful, but WITHOUT ANY WARRANTY.
 
 PLEASE DO NOT REMOVE THIS COPYRIGHT BLOCK.
 
 */


#import "PrayTime.h"

//------------------------------------------------------------

@implementation PrayTime

-(void)setupCalculationMethods{
    self.methodParams = [[NSMutableDictionary alloc] initWithCapacity:8];
    //Karachi
    NSMutableArray *Kvalues = [[NSMutableArray alloc] init];
    [Kvalues addObject:[NSNumber numberWithInt:18]];
    [Kvalues addObject:[NSNumber numberWithInt:1]];
    [Kvalues addObject:[NSNumber numberWithInt:0]];
    [Kvalues addObject:[NSNumber numberWithInt:0]];
    [Kvalues addObject:[NSNumber numberWithInt:18]];
    
    
    [self.methodParams setObject:Kvalues forKey:[NSNumber numberWithInt:Karachi]];
    
    //ISNA
    NSMutableArray *Ivalues = [[NSMutableArray alloc] init];
    [Ivalues addObject:[NSNumber numberWithInt:15]];
    [Ivalues addObject:[NSNumber numberWithInt:1]];
    [Ivalues addObject:[NSNumber numberWithInt:0]];
    [Ivalues addObject:[NSNumber numberWithInt:0]];
    [Ivalues addObject:[NSNumber numberWithInt:15]];
    
    
    [self.methodParams setObject:Ivalues forKey:[NSNumber numberWithInt:ISNA]];
    
    
    //MWL
    NSMutableArray *Mvalues = [[NSMutableArray alloc] init];
    [Mvalues addObject:[NSNumber numberWithInt:18]];
    [Mvalues addObject:[NSNumber numberWithInt:1]];
    [Mvalues addObject:[NSNumber numberWithInt:0]];
    [Mvalues addObject:[NSNumber numberWithInt:0]];
    [Mvalues addObject:[NSNumber numberWithInt:17]];
    
    
    [self.methodParams setObject:Mvalues forKey:[NSNumber numberWithInt:MWL]];
    
    
    //Makkah
    NSMutableArray *Mavalues = [[NSMutableArray alloc] init];
    [Mavalues addObject:[NSNumber numberWithDouble:18.5]];
    [Mavalues addObject:[NSNumber numberWithInt:1]];
    [Mavalues addObject:[NSNumber numberWithInt:0]];
    [Mavalues addObject:[NSNumber numberWithInt:1]];
    [Mavalues addObject:[NSNumber numberWithInt:90]];
    
    
    [self.methodParams setObject:Mavalues forKey:[NSNumber numberWithInt:Makkah]];
    
    //Egypt
    NSMutableArray *Evalues = [[NSMutableArray alloc] init];
    [Evalues addObject:[NSNumber numberWithDouble:19.5]];
    [Evalues addObject:[NSNumber numberWithInt:1]];
    [Evalues addObject:[NSNumber numberWithInt:0]];
    [Evalues addObject:[NSNumber numberWithInt:0]];
    [Evalues addObject:[NSNumber numberWithDouble:17.5]];
    
    
    [self.methodParams setObject:Evalues forKey:[NSNumber numberWithInt:Egypt]];
    
    //Tehran
    NSMutableArray *Tvalues = [[NSMutableArray alloc] init];
    [Tvalues addObject:[NSNumber numberWithDouble:17.7]];
    [Tvalues addObject:[NSNumber numberWithInt:0]];
    [Tvalues addObject:[NSNumber numberWithDouble:4.5]];
    [Tvalues addObject:[NSNumber numberWithInt:0]];
    [Tvalues addObject:[NSNumber numberWithInt:14]];
    
    
    [self.methodParams setObject:Tvalues forKey:[NSNumber numberWithInt:Tehran]];
    
    
    //Custom
    NSMutableArray *Cvalues = [[NSMutableArray alloc] init];
    [Cvalues addObject:[NSNumber numberWithInt:18]];
    [Cvalues addObject:[NSNumber numberWithInt:1]];
    [Cvalues addObject:[NSNumber numberWithInt:0]];
    [Cvalues addObject:[NSNumber numberWithInt:0]];
    [Cvalues addObject:[NSNumber numberWithInt:17]];
    
    
    [self.methodParams setObject:Cvalues forKey:[NSNumber numberWithInt:Custom]];
    
    
    // Time Names
    self.timeNames = @[@"Fajr",@"Sunrise",@"Dhuhr",@"Asr",@"Sunset",@"Maghrib",@"Isha"];
    self.InvalidTime = @"-----";	 // The string used for invalid times
    
}

-(void)defaultSettings{
    self.calcMethod = Makkah;
    self.asrMethod = Shafii;
    self.highLatsMethod = MidNight;
    self.timeFormat = Time24;
    self.dhuhrMinutes = 0;		// minutes after mid-day for Dhuhr
    
    //--------------------- Technical Settings --------------------
    
    self.numIterations = 1;		// number of iterations needed to compute times
}
-(id)init{
	self = [super init];
	if(self){
        
        [self defaultSettings];
        [self setupCalculationMethods];
		
	}
	return self;
}

//---------------------- Trigonometric Functions -----------------------

// range reduce angle in degrees.
-(double) fixangle: (double) a {
	
	a = a - (360 * (floor(a / 360.0)));
	
	a = a < 0 ? (a + 360) : a;
	return a;
}

// range reduce hours to 0..23
-(double) fixhour: (double) a {
	a = a - 24.0 * floor(a / 24.0);
	a = a < 0 ? (a + 24) : a;
	return a;
}

// radian to degree
-(double) radiansToDegrees:(double)alpha {
	return ((alpha*180.0)/M_PI);
}

//deree to radian
-(double) DegreesToRadians:(double)alpha {
	return ((alpha*M_PI)/180.0);
}

// degree sin
-(double)dsin: (double) d {
	return (sin([self DegreesToRadians:d]));
}

// degree cos
-(double)dcos: (double) d {
	return (cos([self DegreesToRadians:d]));
}

// degree tan
-(double)dtan: (double) d {
	return (tan([self DegreesToRadians:d]));
}

// degree arcsin
-(double)darcsin: (double) x {
	double val = asin(x);
	return [self radiansToDegrees: val];
}

// degree arccos
-(double)darccos: (double) x {
	double val = acos(x);
	return [self radiansToDegrees: val];
}

// degree arctan
-(double)darctan: (double) x {
	double val = atan(x);
	return [self radiansToDegrees: val];
}

// degree arctan2
-(double)darctan2: (double)y andX: (double) x {
	double val = atan2(y, x);
	return [self radiansToDegrees: val];
}

// degree arccot
-(double)darccot: (double) x {
	double val = atan2(1.0, x);
	return [self radiansToDegrees: val];
}

//---------------------- Time-Zone Functions -----------------------

// compute local time-zone for a specific date
-(double)getTimeZone {
	NSTimeZone *timeZone = [NSTimeZone localTimeZone];
	double hoursDiff = [timeZone secondsFromGMT]/3600.0f;
	return hoursDiff;
}

// compute base time-zone of the system
-(double)getBaseTimeZone {
	
	NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
	double hoursDiff = [timeZone secondsFromGMT]/3600.0f;
	return hoursDiff;
	
}

// detect daylight saving in a given date
-(double)detectDaylightSaving {
	NSTimeZone *timeZone = [NSTimeZone localTimeZone];
	double hoursDiff = [timeZone daylightSavingTimeOffsetForDate:[NSDate date]];
	return hoursDiff;
}

//---------------------- Julian Date Functions -----------------------

// calculate julian date from a calendar date
-(double) julianDate: (int)year andMonth:(int)month andDay:(int)day {
	
	if (month <= 2)
	{
		year -= 1;
		month += 12;
	}
	double A = floor(year/100.0);
	
	double B = 2 - A + floor(A/4.0);
	
	double JD = floor(365.25 * (year+ 4716)) + floor(30.6001 * (month + 1)) + day + B - 1524.5;
    
	return JD;
}


// convert a calendar date to julian date (second method)
-(double)calcJD: (int)year andMonth:(int)month andDay:(int)day {
	double J1970 = 2440588;
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setWeekday:day]; // Monday
	//[components setWeekdayOrdinal:1]; // The first day in the month
	[components setMonth:month]; // May
	[components setYear:year];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date1 = [gregorian dateFromComponents:components];
	
	double ms = [date1 timeIntervalSince1970];// # of milliseconds since midnight Jan 1, 1970
	double days = floor(ms/ (1000.0 * 60.0 * 60.0 * 24.0));
	return J1970+ days- 0.5;
}

//---------------------- Calculation Functions -----------------------

// References:
// http://www.ummah.net/astronomy/saltime
// http://aa.usno.navy.mil/faq/docs/SunApprox.html


// compute declination angle of sun and equation of time
-(NSMutableArray*)sunPosition: (double) jd {
	
	double D = jd - 2451545;
	double g = [self fixangle: (357.529 + 0.98560028 * D)];
	double q = [self fixangle: (280.459 + 0.98564736 * D)];
	double L = [self fixangle: (q + (1.915 * [self dsin: g]) + (0.020 * [self dsin:(2 * g)]))];
	
	//double R = 1.00014 - 0.01671 * [self dcos:g] - 0.00014 * [self dcos: (2*g)];
	double e = 23.439 - (0.00000036 * D);
	double d = [self darcsin: ([self dsin: e] * [self dsin: L])];
	double RA = ([self darctan2: ([self dcos: e] * [self dsin: L]) andX: [self dcos:L]])/ 15.0;
	RA = [self fixhour:RA];
	
	double EqT = q/15.0 - RA;
	
	NSMutableArray *sPosition = [[NSMutableArray alloc] init];
	[sPosition addObject:[NSNumber numberWithDouble:d]];
	[sPosition addObject:[NSNumber numberWithDouble:EqT]];
	
	return sPosition;
}

// compute equation of time
-(double)equationOfTime: (double)jd {
	double eq = [[[self sunPosition:jd] objectAtIndex:1] doubleValue];
	return eq;
}

// compute declination angle of sun
-(double)sunDeclination: (double)jd {
	double d = [[[self sunPosition:jd] objectAtIndex:0] doubleValue];
	return d;
}

// compute mid-day (Dhuhr, Zawal) time
-(double)computeMidDay: (double) t {
	double T = [self equationOfTime:(self.JDate+ t)];
	double Z = [self fixhour: (12 - T)];
	return Z;
}

// compute time for a given angle G
-(double)computeTime: (double)G andTime: (double)t {
	
	double D = [self sunDeclination:(self.JDate+ t)];
	double Z = [self computeMidDay: t];
	double V = ([self darccos: (-[self dsin:G] - ([self dsin:D] * [self dsin:self.lat]))/ ([self dcos:D] * [self dcos:self.lat])]) / 15.0f;
    
	return Z+ (G>90 ? -V : V);
}

// compute the time of Asr
// Shafii: step=1, Hanafi: step=2
-(double)computeAsr: (double)step andTime:(double)t {
	double D = [self sunDeclination:(self.JDate+ t)];
	double G = -[self darccot : (step + [self dtan:ABS(self.lat-D)])];
	return [self computeTime:G andTime:t];
}

//---------------------- Misc Functions -----------------------


// compute the difference between two times
-(double)timeDiff:(double)time1 andTime2:(double) time2 {
	return [self fixhour: (time2- time1)];
}

//-------------------- Interface Functions --------------------


// return prayer times for a given date
-(NSMutableArray*)getDatePrayerTimes:(int)year andMonth:(int)month andDay:(int)day{
	
    
	self.JDate = [self julianDate:year andMonth:month andDay:day];
	
	double lonDiff = self.lng/(15.0 * 24.0);
	self.JDate = self.JDate - lonDiff;
	return [self computeDayTimes];
}

// return prayer times for a given date
-(NSMutableArray*)getPrayerTimes: (NSDateComponents*)date{
	
	NSInteger year = [date year];
	NSInteger month = [date month];
	NSInteger day = [date day];
	return [self getDatePrayerTimes:year andMonth:month andDay:day];
}


// set custom values for calculation parameters
-(void)setCustomParams: (NSMutableArray*)params {
	int i;
	id j;
	id Cust = [self.methodParams objectForKey: [NSNumber numberWithInt:Custom]];
	id cal = [self.methodParams objectForKey: [NSNumber numberWithInt:self.calcMethod]];
	for (i=0; i<5; i++)
	{
		j = [params objectAtIndex:i];
		if ([j isEqualToNumber: [NSNumber numberWithInt:-1]])
			[Cust replaceObjectAtIndex:i withObject:[cal objectAtIndex:i]] ;
		
		else
			[Cust replaceObjectAtIndex:i withObject:[params objectAtIndex:i]];
	}
	self.calcMethod = Custom;
}

// set the angle for calculating Fajr
-(void)setFajrAngle:(double)angle {
	NSMutableArray *params = [[NSMutableArray alloc] init];
	[params addObject:[NSNumber numberWithDouble:angle]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[self setCustomParams:params];
}

// set the angle for calculating Maghrib
-(void)setMaghribAngle:(double)angle {
	NSMutableArray *params = [[NSMutableArray alloc] init];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:0]];
	[params addObject:[NSNumber numberWithDouble:angle]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[self setCustomParams:params];
}

// set the angle for calculating Isha
-(void)setIshaAngle:(double)angle {
	NSMutableArray *params = [[NSMutableArray alloc] init];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:0]];
	[params addObject:[NSNumber numberWithDouble:angle]];
	[self setCustomParams:params];
}


// set the minutes after Sunset for calculating Maghrib
-(void)setMaghribMinutes:(double)minutes {
	NSMutableArray *params = [[NSMutableArray alloc] init];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:1]];
	[params addObject:[NSNumber numberWithDouble:minutes]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[self setCustomParams:params];
}

// set the minutes after Maghrib for calculating Isha
-(void)setIshaMinutes:(double)minutes {
	NSMutableArray *params = [[NSMutableArray alloc] init];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:-1]];
	[params addObject:[NSNumber numberWithDouble:1]];
	[params addObject:[NSNumber numberWithDouble:minutes]];
	[self setCustomParams:params];
}


// convert double hours to 24h format
-(NSString*)floatToTime24:(double)time {
	
	NSString *result = nil;
	
	if (isnan(time))
		return self.InvalidTime;
	
	time = [self fixhour:(time + 0.5/ 60.0)];  // add 0.5 minutes to round
	int hours = floor(time);
	double minutes = floor((time - hours) * 60.0);
	
	if((hours >=0 && hours<=9) && (minutes >=0 && minutes <=9)){
		result = [NSString stringWithFormat:@"0%d:0%.0f",hours, minutes];
	}
	else if((hours >=0 && hours<=9)){
		result = [NSString stringWithFormat:@"0%d:%.0f",hours, minutes];
	}
	else if((minutes >=0 && minutes <=9)){
		result = [NSString stringWithFormat:@"%d:0%.0f",hours, minutes];
	}
	else{
		result = [NSString stringWithFormat:@"%d:%.0f",hours, minutes];
	}
	return result;
}

// convert double hours to 12h format
-(NSString*)floatToTime12:(double)time andnoSuffix:(BOOL)noSuffix {
	
	if (isnan(time))
		return self.InvalidTime;
	
	time =[self fixhour:(time+ 0.5/ 60)];  // add 0.5 minutes to round
	double hours = floor(time);
	double minutes = floor((time- hours)* 60);
	NSString *suffix, *result=nil;
	if(hours >= 12) {
		suffix = @"PM";
	}
	else{
		suffix = @"AM";
	}
	//hours = ((((hours+ 12) -1) % (12))+ 1);
	hours = (hours + 12) - 1;
	int hrs = (int)hours % 12;
	hrs += 1;
	if(noSuffix == NO){
		if((hrs >=0 && hrs<=9) && (minutes >=0 && minutes <=9)){
			result = [NSString stringWithFormat:@"0%d:0%.0f %@",hrs, minutes, suffix];
		}
		else if((hrs >=0 && hrs<=9)){
			result = [NSString stringWithFormat:@"0%d:%.0f %@",hrs, minutes, suffix];
		}
		else if((minutes >=0 && minutes <=9)){
			result = [NSString stringWithFormat:@"%d:0%.0f %@",hrs, minutes, suffix];
		}
		else{
			result = [NSString stringWithFormat:@"%d:%.0f %@",hrs, minutes, suffix];
		}
		
	}
	else{
		if((hrs >=0 && hrs<=9) && (minutes >=0 && minutes <=9)){
			result = [NSString stringWithFormat:@"0%d:0%.0f",hrs, minutes];
		}
		else if((hrs >=0 && hrs<=9)){
			result = [NSString stringWithFormat:@"0%d:%.0f",hrs, minutes];
		}
		else if((minutes >=0 && minutes <=9)){
			result = [NSString stringWithFormat:@"%d:0%.0f",hrs, minutes];
		}
		else{
			result = [NSString stringWithFormat:@"%d:%.0f",hrs, minutes];
		}
	}
	return result;
	
}

// convert double hours to 12h format with no suffix
-(NSString*)floatToTime12NS:(double)time {
	return [self floatToTime12:time andnoSuffix:YES];
}

//---------------------- Compute Prayer Times -----------------------


// compute prayer times at given julian date
-(NSMutableArray*)computeTimes:(NSMutableArray*)times {
	
	NSMutableArray *t = [self dayPortion:times];
	
	id obj = [self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]];
	double idk = [[obj objectAtIndex:0] doubleValue];
	double Fajr    = [self computeTime:(180 - idk) andTime: [[t objectAtIndex:0] doubleValue]];
	double Sunrise = [self computeTime:(180 - 0.833) andTime: [[t objectAtIndex:1] doubleValue]];
	double Dhuhr   = [self computeMidDay: [[t objectAtIndex:2] doubleValue]];
	double Asr     = [self computeAsr:(1 + self.asrMethod) andTime: [[t objectAtIndex:3] doubleValue]];
	double Sunset  = [self computeTime:0.833 andTime: [[t objectAtIndex:4] doubleValue]];
	double Maghrib = [self computeTime:[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:2] doubleValue] andTime: [[t objectAtIndex:5] doubleValue]];
	double Isha    = [self computeTime:[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:4] doubleValue] andTime: [[t objectAtIndex:6] doubleValue]];
	
	NSMutableArray *Ctimes = [[NSMutableArray alloc] init];
	[Ctimes addObject:[NSNumber numberWithDouble:Fajr]];
	[Ctimes addObject:[NSNumber numberWithDouble:Sunrise]];
	[Ctimes addObject:[NSNumber numberWithDouble:Dhuhr]];
	[Ctimes addObject:[NSNumber numberWithDouble:Asr]];
	[Ctimes addObject:[NSNumber numberWithDouble:Sunset]];
	[Ctimes addObject:[NSNumber numberWithDouble:Maghrib]];
	[Ctimes addObject:[NSNumber numberWithDouble:Isha]];
	
	//Tune times here
	//Ctimes = [self tuneTimes:Ctimes];
	
	return Ctimes;
}

-(void)setDateForJdate:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    int year = [nowComponents year];
	int month = [nowComponents month];
	int day = [nowComponents day];
    
    self.JDate = [self julianDate:year andMonth:month andDay:day];
}
-(NSMutableArray*)computeDayTimes {
	
    
	//int i = 0;
	NSMutableArray *t1, *t2, *t3;
	NSMutableArray *times = [[NSMutableArray alloc] init]; //default times
	[times addObject:[NSNumber numberWithDouble:5.0]];
	[times addObject:[NSNumber numberWithDouble:6.0]];
	[times addObject:[NSNumber numberWithDouble:12.0]];
	[times addObject:[NSNumber numberWithDouble:13.0]];
	[times addObject:[NSNumber numberWithDouble:18.0]];
	[times addObject:[NSNumber numberWithDouble:18.0]];
	[times addObject:[NSNumber numberWithDouble:18.0]];
	
    int i;
	for (i=1; i<= self.numIterations; i++)
		t1 = [self computeTimes:times];
	
	t2 = [self adjustTimes:t1];
	
	t2 = [self tuneTimes:t2];
	
	//Set prayerTimesCurrent here!!
	self.prayerTimesCurrent = [[NSMutableArray alloc] initWithArray:t2];
	
	t3 = [self adjustTimesFormat:t2];
    
	return t3;
}

//Tune timings for adjustments
//Set time offsets
-(void)tune:(NSMutableDictionary*)offsetTimes{
    
	[self.offsets replaceObjectAtIndex:0 withObject:[offsetTimes objectForKey:@"fajr"]];
	[self.offsets replaceObjectAtIndex:1 withObject:[offsetTimes objectForKey:@"sunrise"]];
	[self.offsets replaceObjectAtIndex:2 withObject:[offsetTimes objectForKey:@"dhuhr"]];
	[self.offsets replaceObjectAtIndex:3 withObject:[offsetTimes objectForKey:@"asr"]];
	[self.offsets replaceObjectAtIndex:4 withObject:[offsetTimes objectForKey:@"sunset"]];
	[self.offsets replaceObjectAtIndex:5 withObject:[offsetTimes objectForKey:@"maghrib"]];
	[self.offsets replaceObjectAtIndex:6 withObject:[offsetTimes objectForKey:@"isha"]];
}

-(NSMutableArray*)tuneTimes:(NSMutableArray*)times{
	double off, time;
    int i;
	for(i=0; i<[times count]; i++){
		//if(i==5)
		//NSLog(@"Normal: %d - %@", i, [times objectAtIndex:i]);
		off = [[self.offsets objectAtIndex:i] doubleValue]/60.0;
		time = [[times objectAtIndex:i] doubleValue] + off;
		[times replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:time]];
		//if(i==5)
		//NSLog(@"Modified: %d - %@", i, [times objectAtIndex:i]);
	}
	
	return times;
}

// adjust times in a prayer time array
-(NSMutableArray*)adjustTimes:(NSMutableArray*)times {
	
	int i = 0;
	NSMutableArray *a; //test variable
	double time = 0, Dtime, Dtime1, Dtime2;
	
	for (i=0; i<7; i++) {
		time = ([[times objectAtIndex:i] doubleValue]) + (self.timeZone- self.lng/ 15.0);
		
		[times replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:time]];
		
	}
	
	Dtime = [[times objectAtIndex:2] doubleValue] + (self.dhuhrMinutes/ 60.0); //Dhuhr
    
	[times replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:Dtime]];
	
	a = [self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]];
	double val = [[a  objectAtIndex:1] doubleValue];
	
	if (val == 1) { // Maghrib
		Dtime1 = [[times objectAtIndex:4] doubleValue]+ ([[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:2] doubleValue]/60.0);
		[times replaceObjectAtIndex:5 withObject:[NSNumber numberWithDouble:Dtime1]];
	}
	
	if ([[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:3] doubleValue]== 1) { // Isha
		Dtime2 = [[times objectAtIndex:5] doubleValue] + ([[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:4] doubleValue]/60.0);
		[times replaceObjectAtIndex:6 withObject:[NSNumber numberWithDouble:Dtime2]];
	}
	
	if (self.highLatsMethod != None){
		times = [self adjustHighLatTimes:times];
	}
	return times;
}


// convert times array to given time format
-(NSMutableArray*)adjustTimesFormat:(NSMutableArray*)times {
	int i = 0;
	
	if (self.timeFormat == Float){
		return times;
	}
	for (i=0; i<7; i++) {
		if (self.timeFormat == Time12){
			[times replaceObjectAtIndex:i withObject:[self floatToTime12:[[times objectAtIndex:i] doubleValue] andnoSuffix:NO]];
		}
		else if (self.timeFormat == Time12NS){
			[times replaceObjectAtIndex:i withObject:[self floatToTime12:[[times objectAtIndex:i] doubleValue] andnoSuffix:YES]];
		}
		else{
			
			[times replaceObjectAtIndex:i withObject:[self floatToTime24:[[times objectAtIndex:i] doubleValue]]];
		}
	}
	return times;
}


// adjust Fajr, Isha and Maghrib for locations in higher latitudes
-(NSMutableArray*)adjustHighLatTimes:(NSMutableArray*)times {
	
	double time0 = [[times objectAtIndex:0] doubleValue];
	double time1 = [[times objectAtIndex:1] doubleValue];
	//double time2 = [[times objectAtIndex:2] doubleValue];
	//double time3 = [[times objectAtIndex:3] doubleValue];
	double time4 = [[times objectAtIndex:4] doubleValue];
	double time5 = [[times objectAtIndex:5] doubleValue];
	double time6 = [[times objectAtIndex:6] doubleValue];
	
	double nightTime = [self timeDiff:time4 andTime2:time1]; // sunset to sunrise
	
	// Adjust Fajr
	double obj0 =[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:0] doubleValue];
	double obj1 =[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:1] doubleValue];
	double obj2 =[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:2] doubleValue];
	double obj3 =[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:3] doubleValue];
	double obj4 =[[[self.methodParams objectForKey:[NSNumber numberWithInt:self.calcMethod]] objectAtIndex:4] doubleValue];
	
	double FajrDiff = [self nightPortion:obj0] * nightTime;
	
	if ((isnan(time0)) || ([self timeDiff:time0 andTime2:time1] > FajrDiff))
		[times replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:(time1 - FajrDiff)]];
	
	// Adjust Isha
	double IshaAngle = (obj3 == 0) ? obj4: 18;
	double IshaDiff = [self nightPortion: IshaAngle] * nightTime;
	if (isnan(time6) ||[self timeDiff:time4 andTime2:time6] > IshaDiff)
		[times replaceObjectAtIndex:6 withObject:[NSNumber numberWithDouble:(time4 + IshaDiff)]];
	
	
	// Adjust Maghrib
	double MaghribAngle = (obj1 == 0) ? obj2 : 4;
	double MaghribDiff = [self nightPortion: MaghribAngle] * nightTime;
	if (isnan(time5) || [self timeDiff:time4 andTime2:time5] > MaghribDiff)
		[times replaceObjectAtIndex:5 withObject:[NSNumber numberWithDouble:(time4 + MaghribDiff)]];
	
	return times;
}


// the night portion used for adjusting times in higher latitudes
-(double)nightPortion:(double)angle {
	double calc = 0;
	
	if (self.highLatsMethod == AngleBased)
		calc = (angle)/60.0f;
	else if (self.highLatsMethod == MidNight)
		calc = 0.5f;
	else if (self.highLatsMethod == OneSeventh)
		calc = 0.14286f;
	
	return calc;
}


// convert hours to day portions
-(NSMutableArray*)dayPortion:(NSMutableArray*)times {
	int i = 0;
	double time = 0;
	for (i=0; i<7; i++){
		time = [[times objectAtIndex:i] doubleValue];
		time = time/24.0;
		
		[times replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:time]];
		
	}
	return times;
}


@end