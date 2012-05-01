//
//  Hadith.m
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "Hadith.h"


@implementation Hadith

@dynamic hadith;
@dynamic narrated;
@dynamic volume;
@dynamic book;
@dynamic number;

void (^showAlertWithTitlesAndMessage)(id, NSString *, NSString *, NSString *) = ^(id obj, NSString *title, NSString *message, NSString *buttonTitle) 
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:title 
                          message:message
                          delegate:obj 
                          cancelButtonTitle:buttonTitle
                          otherButtonTitles: nil];
    [alert show];
};

NSInteger intSort(id num1, id num2, void *context)
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

+ (NSArray *)returnSortedArrayOfKeys:(NSMutableDictionary *) dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingFunction:intSort context:NULL];
    return sortedKeys;
}

+ (NSMutableArray *)hadithDataForBookNum:(NSNumber *)bookNum inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Hadith" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(book = %@)", bookNum];
    request.predicate = predicate;
	NSError *error = nil;
	NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];

    if (results == nil || error) {
        showAlertWithTitlesAndMessage(self, @"Error", @"An error was encountered.  Please try again.  Or report the error on app store app page.", @"OK"
                                      );
        return nil;
    } else {
        return results;
    }
}

+ (NSMutableArray *)hadithTextForHadithNumber:(NSInteger)hadithNumber andBookNum:(NSNumber *)bookNum inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Hadith" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(book = %@) AND (number = %@)", bookNum, [NSNumber numberWithInteger:hadithNumber]];
    request.predicate = predicate;
	NSError *error = nil;
	NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if (results == nil || error) {
        showAlertWithTitlesAndMessage(self, @"Error", @"An error was encountered.  Please try again.  Or report the error on app store app page.", @"OK"
                                      );
        return nil;
    } else {
        return results;
    }
}

+ (NSMutableDictionary *)bookNames:(NSInteger)volumeNumber inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSMutableDictionary *names = [[NSMutableDictionary alloc] init];
    enum BookNames bNames;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Hadith" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(volume = %@)", [NSNumber numberWithInteger:volumeNumber]];
    request.predicate = predicate;
    request.returnsDistinctResults = YES;
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:@"book"];  
	request.fetchBatchSize = 50;
    
	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:request error:&error];
    if (results == nil || error) {
        showAlertWithTitlesAndMessage(self, @"Error", @"An error was encountered.  Please try again.  Or report the error on app store app page.", @"OK"
                                      );
    } else {
        for (NSDictionary *name in results ) {
            bNames = [[name objectForKey:@"book"]intValue];
            
            switch (bNames) {
                case Revelation:
                    [names setValue:@"Revelation" forKey:[NSString stringWithFormat:@"%d",Revelation]];
                    break;
                case Belief:
                    [names setValue:@"Belief" forKey:[NSString stringWithFormat:@"%d",Belief]];
                    break;   
                case Knowledge:
                    [names setValue:@"Knowledge" forKey:[NSString stringWithFormat:@"%d",Knowledge]];
                    break;  
                case Ablutions:
                    [names setValue:@"Ablutions (Wudu')" forKey:[NSString stringWithFormat:@"%d",Ablutions]];
                    break;  
                case Bathing:
                    [names setValue:@"Bathing (Ghusl)" forKey:[NSString stringWithFormat:@"%d",Bathing]];
                    break;  
                case Menstrual:
                    [names setValue:@"Menstrual Periods" forKey:[NSString stringWithFormat:@"%d",Menstrual]];
                    break;  
                case Tayammum:
                    [names setValue:@"Rubbing hands and feet with dust (Tayammum)" forKey:[NSString stringWithFormat:@"%d",Tayammum]];
                    break; 
                case Prayers:
                    [names setValue:@"Prayers (Salat)" forKey:[NSString stringWithFormat:@"%d",Prayers]];
                    break;
                case Virtues:
                    [names setValue:@"Virtues of the Prayer Hall (Sutra of the Musalla)" forKey:[NSString stringWithFormat:@"%d",Virtues]];
                    break;
                case TimesPrayers:
                    [names setValue:@"Times of the Prayers" forKey:[NSString stringWithFormat:@"%d",TimesPrayers]];
                    break;
                case Adhaan:
                    [names setValue:@"Call to Prayers (Adhaan)" forKey:[NSString stringWithFormat:@"%d",Adhaan]];
                    break;
                case Characteristics:
                    [names setValue:@"Characteristics of Prayer" forKey:[NSString stringWithFormat:@"%d",Characteristics]];
                    break;
                case Friday:
                    [names setValue:@"Friday Prayer" forKey:[NSString stringWithFormat:@"%d",Friday]];
                    break;
                case FearPrayer:
                    [names setValue:@"Fear Prayer" forKey:[NSString stringWithFormat:@"%d",FearPrayer]];
                    break;
                case Eids:
                    [names setValue:@"The Two Festivals (Eids)" forKey:[NSString stringWithFormat:@"%d",Eids]];
                    break;
                case Witr:
                    [names setValue:@"Witr Prayer" forKey:[NSString stringWithFormat:@"%d",Witr]];
                    break;
                case Istisqaa:
                    [names setValue:@"Invoking Allah for Rain (Istisqaa)" forKey:[NSString stringWithFormat:@"%d",Istisqaa]];
                    break;
                case Eclipses:
                    [names setValue:@"Eclipses" forKey:[NSString stringWithFormat:@"%d",Eclipses]];
                    break;
                case Prostration:
                    [names setValue:@"Prostration During Recital of Qur'an" forKey:[NSString stringWithFormat:@"%d",Prostration]];
                    break;
                case AtTaqseer:
                    [names setValue:@"Shortening the Prayers (At-Taqseer)" forKey:[NSString stringWithFormat:@"%d",AtTaqseer]];
                    break;
                case Tahajjud:
                    [names setValue:@"Prayer at Night (Tahajjud)" forKey:[NSString stringWithFormat:@"%d",Tahajjud]];
                    break;
                case Actions:
                    [names setValue:@"Actions while Praying" forKey:[NSString stringWithFormat:@"%d",Actions]];
                    break;
                case Funerals:
                    [names setValue:@"Funerals (Al-Janaa'iz)" forKey:[NSString stringWithFormat:@"%d",Funerals]];
                    break;
                case Zakat:
                    [names setValue:@"Obligatory Charity Tax (Zakat)" forKey:[NSString stringWithFormat:@"%d",Zakat]];
                    break;
                case ZakatulFitr:
                    [names setValue:@"Obligatory Charity Tax After Ramadaan (Zakat ul Fitr)" forKey:[NSString stringWithFormat:@"%d",ZakatulFitr]];
                    break;
                case Hajj:
                    [names setValue:@"Pilgrimmage (Hajj)" forKey:[NSString stringWithFormat:@"%d",Hajj]];
                    break;
                case Umra:
                    [names setValue:@"Minor Pilgrammage (Umra)" forKey:[NSString stringWithFormat:@"%d",Umra]];
                    break;
                case PilgrimsPrevented:
                    [names setValue:@"Pilgrims Prevented from Completing the Pilgrimmage" forKey:[NSString stringWithFormat:@"%d",PilgrimsPrevented]];
                    break;
                case PenaltyOfHunting:
                    [names setValue:@"Penalty of Hunting while on Pilgrimmage" forKey:[NSString stringWithFormat:@"%d",PenaltyOfHunting]];
                    break;
                case VirtuesMadinah:
                    [names setValue:@"Virtues of Madinah" forKey:[NSString stringWithFormat:@"%d",VirtuesMadinah]];
                    break;
                case Fasting:
                    [names setValue:@"Fasting" forKey:[NSString stringWithFormat:@"%d",Fasting]];
                    break;
                case Taraweeh:
                    [names setValue:@"Praying at Night in Ramadaan (Taraweeh)" forKey:[NSString stringWithFormat:@"%d",Taraweeh]];
                    break;
                case Itikaf:
                    [names setValue:@"Retiring to a Mosque for Remembrance of Allah (I'tikaf)" forKey:[NSString stringWithFormat:@"%d",Itikaf]];
                    break;
                case SalesAndTrade:
                    [names setValue:@"Sales and Trade" forKey:[NSString stringWithFormat:@"%d",SalesAndTrade]];
                    break;
                case AsSalam:
                    [names setValue:@"Sales in which a Price is paid for Goods to be Delivered Later (As-Salam)" forKey:[NSString stringWithFormat:@"%d",AsSalam]];
                    break;
                case Hiring:
                    [names setValue:@"Hiring" forKey:[NSString stringWithFormat:@"%d",Hiring]];
                    break;
                case AlHawaala:
                    [names setValue:@"Transferance of a Debt from One Person to Another (Al-Hawaala)" forKey:[NSString stringWithFormat:@"%d",AlHawaala]];
                    break;
                case Representation:
                    [names setValue:@"Representation, Authorization, Business by Proxy" forKey:[NSString stringWithFormat:@"%d",Representation]];
                case Agriculture:
                    [names setValue:@"Agriculture" forKey:[NSString stringWithFormat:@"%d",Agriculture]];
                    break;
                case DistributionWater:
                    [names setValue:@"Distribution of Water" forKey:[NSString stringWithFormat:@"%d",DistributionWater]];
                    break;
                case Loans:
                    [names setValue:@"Loans, Payment of Loans, Freezing of Property, Bankruptcy" forKey:[NSString stringWithFormat:@"%d",Loans]];
                    break;
                case Luqaata:
                    [names setValue:@"Lost Things Picked up by Someone (Luqaata)" forKey:[NSString stringWithFormat:@"%d",Luqaata]];
                    break;
                case Oppressions:
                    [names setValue:@"Oppressions" forKey:[NSString stringWithFormat:@"%d",Oppressions]];
                    break;
                case Partnership:
                    [names setValue:@"Partnership" forKey:[NSString stringWithFormat:@"%d",Partnership]];
                    break;
                case Mortgaging:
                    [names setValue:@"Mortgaging" forKey:[NSString stringWithFormat:@"%d",Mortgaging]];
                    break;
                case ManumissionSlaves:
                    [names setValue:@"Manumission of Slaves" forKey:[NSString stringWithFormat:@"%d",ManumissionSlaves]];
                    break;
                case Gifts:
                    [names setValue:@"Gifts" forKey:[NSString stringWithFormat:@"%d",Gifts]];
                    break;
                case Witnesses:
                    [names setValue:@"Witnesses" forKey:[NSString stringWithFormat:@"%d",Witnesses]];
                    break;
                case Peacemaking:
                    [names setValue:@"Peacemaking" forKey:[NSString stringWithFormat:@"%d",Peacemaking]];
                    break;
                case Conditions:
                    [names setValue:@"Conditions" forKey:[NSString stringWithFormat:@"%d",Conditions]];
                    break;
                case Wasaayaa:
                    [names setValue:@"Wills and Testaments (Wasaayaa)" forKey:[NSString stringWithFormat:@"%d",Wasaayaa]];
                    break;
                case FightingCause:
                    [names setValue:@"Fighting for the Cause of Allah (Jihaad)" forKey:[NSString stringWithFormat:@"%d",FightingCause]];
                    break;
                case Khumus:
                    [names setValue:@"One-fifth of Booty to the Cause of Allah (Khumus)" forKey:[NSString stringWithFormat:@"%d",Khumus]];
                    break;
                case BeginningCreation:
                    [names setValue:@"Beginning of Creation" forKey:[NSString stringWithFormat:@"%d",BeginningCreation]];
                    break;
                case Prophets:
                    [names setValue:@"Prophets" forKey:[NSString stringWithFormat:@"%d",Prophets]];
                    break;
                case Companions:
                    [names setValue:@"Virtues and Merits of the Prophet (pbuh) and his Companions" forKey:[NSString stringWithFormat:@"%d",Companions]];
                    break;
                default:
                    [names setValue:@"CHAPTER 100" forKey:@"100"];
                    break;
            }
        }
    }
	
	return names;
}

+ (NSMutableDictionary *)bookNamesByData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context __attribute__((deprecated))
{
	NSMutableDictionary *names = [[NSMutableDictionary alloc] init];
    enum BookNames bNames;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Hadith" inManagedObjectContext:context];
	request.predicate = nil;
    request.returnsDistinctResults = YES;
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:@"book"];  
	request.fetchBatchSize = 50;
    
	NSError *error = nil;
	NSArray *results = [context executeFetchRequest:request error:&error];
    if (results == nil || error) {
        showAlertWithTitlesAndMessage(self, @"Error", @"An error was encountered.  Please try again.  Or report the error on app store app page.", @"OK"
                                      );
    } else {
        for (NSDictionary *name in results ) {
            bNames = [[name objectForKey:@"book"]intValue];
            
            switch (bNames) {
                case Revelation:
                    [names setValue:@"Revelation" forKey:[NSString stringWithFormat:@"%d",Revelation]];
                    break;
                case Belief:
                    [names setValue:@"Belief" forKey:[NSString stringWithFormat:@"%d",Belief]];
                    break;   
                case Knowledge:
                    [names setValue:@"Knowledge" forKey:[NSString stringWithFormat:@"%d",Knowledge]];
                    break;  
                case Ablutions:
                    [names setValue:@"Ablutions (Wudu')" forKey:[NSString stringWithFormat:@"%d",Ablutions]];
                    break;  
                case Bathing:
                    [names setValue:@"Bathing (Ghusl)" forKey:[NSString stringWithFormat:@"%d",Bathing]];
                    break;  
                case Menstrual:
                    [names setValue:@"Menstrual Periods" forKey:[NSString stringWithFormat:@"%d",Menstrual]];
                    break;  
                case Tayammum:
                    [names setValue:@"Rubbing hands and feet with dust (Tayammum)" forKey:[NSString stringWithFormat:@"%d",Tayammum]];
                    break; 
                case Prayers:
                    [names setValue:@"Prayers (Salat)" forKey:[NSString stringWithFormat:@"%d",Prayers]];
                    break;
                case Virtues:
                    [names setValue:@"Virtues of the Prayer Hall (Sutra of the Musalla)" forKey:[NSString stringWithFormat:@"%d",Virtues]];
                    break;
                case TimesPrayers:
                    [names setValue:@"Times of the Prayers" forKey:[NSString stringWithFormat:@"%d",TimesPrayers]];
                    break;
                case Adhaan:
                    [names setValue:@"Call to Prayers (Adhaan)" forKey:[NSString stringWithFormat:@"%d",Adhaan]];
                    break;
                case Characteristics:
                    [names setValue:@"Characteristics of Prayer" forKey:[NSString stringWithFormat:@"%d",Characteristics]];
                    break;
                case Friday:
                    [names setValue:@"Friday Prayer" forKey:[NSString stringWithFormat:@"%d",Friday]];
                    break;
                case FearPrayer:
                    [names setValue:@"Fear Prayer" forKey:[NSString stringWithFormat:@"%d",FearPrayer]];
                    break;
                case Eids:
                    [names setValue:@"The Two Festivals (Eids)" forKey:[NSString stringWithFormat:@"%d",Eids]];
                    break;
                case Witr:
                    [names setValue:@"Witr Prayer" forKey:[NSString stringWithFormat:@"%d",Witr]];
                    break;
                case Istisqaa:
                    [names setValue:@"Invoking Allah for Rain (Istisqaa)" forKey:[NSString stringWithFormat:@"%d",Istisqaa]];
                    break;
                case Eclipses:
                    [names setValue:@"Eclipses" forKey:[NSString stringWithFormat:@"%d",Eclipses]];
                    break;
                case Prostration:
                    [names setValue:@"Prostration During Recital of Qur'an" forKey:[NSString stringWithFormat:@"%d",Prostration]];
                    break;
                case AtTaqseer:
                    [names setValue:@"Shortening the Prayers (At-Taqseer)" forKey:[NSString stringWithFormat:@"%d",AtTaqseer]];
                    break;
                default:
                    [names setValue:@"CHAPTER 100" forKey:@"100"];
                    break;
            }
        }
    }
	
	return names;
}


@end
