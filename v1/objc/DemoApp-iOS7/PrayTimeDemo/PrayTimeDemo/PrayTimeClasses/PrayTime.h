//--------------------- Copyright Block ----------------------
/*
 
 PrayTime.h: Prayer Times Calculator (ver 1.2)
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


typedef enum : int {
    Karachi = 0,                // University of Islamic Sciences, Karachi
    ISNA,                       // Islamic Society of North America (ISNA)
    MWL,                        // Muslim World League (MWL)
    Makkah,                     // Umm al-Qura, Makkah
    Egypt,                      // Egyptian General Authority of Survey
    Custom,                     // Custom Setting
    Tehran,                     // Institute of Geophysics, University of Tehran
    Jafari                      //Ithna Ashari
} CalcMethod;


typedef enum : NSUInteger {
    Fajr = 0,
    Sunrise,
    Dhuhr,
    Asr,
    Sunset,
    Maghrib,
    Isha
} Prays;

typedef enum : int {
    Shafii = 0,                 // Shafii (standard)
    Hanafi,                     // Hanafi
}AsrMethods;


typedef enum : int {
    None = 0,                   // No adjustment
    MidNight,                   // middle of night
    OneSeventh,                 // 1/7th of night
    AngleBased                  // angle/60th of night
}HighLatsMethod;


typedef enum : int {
    Time24 = 0,                 // 24-hour format
    Time12,                     // 12-hour format
    Time12NS,                   // 12-hour format with no suffix
    Float                       // floating ponumber
}TimeFormat;

#import <Foundation/Foundation.h>


@interface PrayTime : NSObject

@property (nonatomic) CalcMethod calcMethod;
@property (nonatomic) AsrMethods asrMethod;
@property (nonatomic) HighLatsMethod highLatsMethod;
@property (nonatomic) TimeFormat timeFormat;

@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic) double timeZone;

@property (nonatomic) double dhuhrMinutes;
@property (nonatomic) double JDate;


@property (nonatomic, retain) NSString *InvalidTime;

@property (nonatomic, assign) NSInteger numIterations;

@property (nonatomic, retain) NSMutableDictionary *methodParams;

@property (nonatomic, retain) NSMutableArray *prayerTimesCurrent;
@property (nonatomic, retain) NSMutableArray *offsets;
@property (nonatomic, retain) NSArray *timeNames;


//---------------------- Trigonometric Functions -----------------------
-(double) radiansToDegrees:(double)alpha;
-(double) DegreesToRadians:(double)alpha;
-(double) fixangle: (double)a;
-(double) fixhour: (double)a;
-(double)dsin: (double) d;
-(double)dcos: (double) d;
-(double)dtan: (double) d;
-(double)darcsin: (double) x;
-(double)darccos: (double) x;
-(double)darctan: (double) x;
-(double)darccot: (double) x;
-(double)darctan2: (double)y andX: (double) x;

//---------------------- Time-Zone Functions -----------------------
-(double)getTimeZone;
-(double)getBaseTimeZone;
-(double)detectDaylightSaving;

//---------------------- Julian Date Functions -----------------------
-(double) julianDate: (int)year andMonth:(int)month andDay:(int)day;
-(double)calcJD: (int)year andMonth:(int)month andDay:(int)day;

//---------------------- Calculation Functions -----------------------
-(NSMutableArray*)sunPosition: (double) jd;
-(double)equationOfTime: (double)jd;
-(double)sunDeclination: (double)jd;
-(double)computeMidDay: (double) t;
-(double)computeTime: (double)G andTime: (double)t;
-(double)computeAsr: (double)step andTime:(double)t;

//---------------------- Misc Functions -----------------------
-(double)timeDiff:(double)time1 andTime2:(double) time2;

//-------------------- Interface Functions --------------------
-(NSMutableArray*)getDatePrayerTimes:(int)year andMonth:(int)month andDay:(int)day;
-(NSMutableArray*)getPrayerTimes: (NSDateComponents*)date;


-(void)setDateForJdate:(NSDate *)date;
-(void)setCustomParams: (NSMutableArray*)params;
-(void)setFajrAngle:(double)angle;
-(void)setMaghribAngle:(double)angle;
-(void)setIshaAngle:(double)angle;
-(void)setMaghribMinutes:(double)minutes;
-(void)setIshaMinutes:(double)minutes;

-(NSString*)floatToTime24:(double)time;
-(NSString*)floatToTime12:(double)time andnoSuffix:(BOOL)noSuffix;
-(NSString*)floatToTime12NS:(double)time;

//---------------------- Compute Prayer Times -----------------------
-(NSMutableArray*)computeTimes:(NSMutableArray*)times;
-(NSMutableArray*)computeDayTimes;
-(NSMutableArray*)adjustTimes:(NSMutableArray*)times;
-(NSMutableArray*)adjustTimesFormat:(NSMutableArray*)times;
-(NSMutableArray*)adjustHighLatTimes:(NSMutableArray*)times;
-(double)nightPortion:(double)angle;
-(NSMutableArray*)dayPortion:(NSMutableArray*)times;
-(void)tune:(NSMutableDictionary*)offsets;
-(NSMutableArray*)tuneTimes:(NSMutableArray*)times;

@end
