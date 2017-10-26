//
//  Hadith.h
//  HadithViewer
//
//  Created by Mohammad Quraishi on 3/25/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Hadith : NSManagedObject {
//NSMutableDictionary *bookNames;

enum BookNames {Revelation=1,Belief,Knowledge,Ablutions,Bathing,Menstrual,Tayammum,Prayers,Virtues,TimesPrayers,Adhaan,Characteristics,Friday,FearPrayer,Eids,Witr,Istisqaa,Eclipses,Prostration,AtTaqseer,Tahajjud,Actions,Funerals,Zakat,ZakatulFitr,Hajj,Umra,PilgrimsPrevented,PenaltyOfHunting,VirtuesMadinah,Fasting,Taraweeh,Itikaf,SalesAndTrade,AsSalam,Hiring,AlHawaala,Representation,Agriculture,DistributionWater,Loans,Luqaata,Oppressions,Partnership,Mortgaging,ManumissionSlaves,Gifts,Witnesses,Peacemaking,Conditions,Wasaayaa,FightingCause,Khumus,BeginningCreation,Prophets,Companions,CompanionsProphet,Ansaar,AlMaghaazi,Tafseer,VirtuesQuran,Nikaah,Divorce,SupportingFamily,Food,Aqiqa,Hunting,AlAdha,Drinks,Patients,Medicine,Dress,AlAdab,AskingPermission,Invocations,ArRiqaq,AlQadar,OathsVows,UnfulfilledOaths,AlFaraaid,Hudood,PunishmentDisbelievers,AdDiyat,DealingApostates,Ikraah,Tricks,InterpretationDreams,Afflictions,Ahkaam,Wishes,TruthfulPerson,HoldingFastSunnah,Tawheed};
}

@property (nonatomic, strong) NSString * hadith;
@property (nonatomic, strong) NSString * narrated;
@property (nonatomic, strong) NSNumber * volume;
@property (nonatomic, strong) NSNumber * book;
@property (nonatomic, strong) NSNumber * number;

+ (NSMutableArray *)hadithDataForBookNum:(NSNumber *)bookNum inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSMutableDictionary *)bookNames:(NSInteger)volumeNumber inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSMutableDictionary *)bookNamesByData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context __attribute((deprecated));
+ (NSMutableArray *)hadithTextForHadithNumber:(NSInteger)hadithNumber andBookNum:(NSNumber *)bookNum inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)returnSortedArrayOfKeys:(NSMutableDictionary *) dictionary;

@end
