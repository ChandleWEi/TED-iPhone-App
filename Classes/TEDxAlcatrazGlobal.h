/*
 The MIT License
 
 Copyright (c) 2010 Peter Ma
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the \"Software\"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
/*
 *  TEDxAlcatrazGlobal.h
 *  TEDxAlcatraz
 *
 *  Created by Michael May on 03/01/2011.
 *  Copyright 2011 Michael May. All rights reserved.
 *
 */

// A way to remove the debugging to the console from the app when not in debug build, making the app
// smaller and faster. It also adds the extra logging I have been meaning to drop in for ages which is 
// logging the function and line too. We could also add __FILE__ but we probably don't need it. 
// From http://iphoneincubator.com/blog/tag/nslog
// DLog is almost a drop-in replacement for DLog  
// DLog();
// DLog(@\"here\");  
// DLog(@\"value: %d\", x);  
// Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@\"%@\", aStringVariable);  
#ifdef DEBUG  
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else  
#define DLog(...)  
#endif 

#ifdef DEBUG 
#define DAssert(condition, desc) NSAssert(condition, desc)
#else
#define DAssert(condition, desc) 
#endif

@interface TEDxAlcatrazGlobal : NSObject

+(void)createTempPath;

+(NSString*)descriptionFromJSONData:(NSDictionary*)JSONDictionary;

+(NSDate*) getDateFromJSON:(NSString *)dateString;

+(UIImage*)imageForSpeaker:(NSDictionary*)speaker;

+(NSString*)nameStringFromJSONData:(NSDictionary*)JSONDictonary;

+(NSString*)photoURLFromJSONData:(NSDictionary*)JSONDictionary;
	
+(NSInteger)sessionFromJSONData:(NSDictionary*)JSONDictionary;

+(NSInteger)sessionIdFromJSONData:(NSDictionary*)JSONDictionary;

+(NSString *)sessionNameFromJSONData:(NSDictionary*)JSONDictionary;

+(NSDate *)sessionTimeFromJSONData:(NSDictionary*)JSONDictionary;

+(NSInteger)speakerIdFromJSONData:(NSDictionary*)JSONDictionary;

+(NSString*)tempPathForSpeakerImage:(NSDictionary*)speaker;

+(NSString*)titleFromJSONData:(NSDictionary*)JSONDictionary;

+(NSString*)twitterFromJSONData:(NSDictionary*)JSONDictionary;

+(NSString*)webSiteFromJSONData:(NSDictionary*)JSONDictionary;

#pragma local values from infolist
// returns the event id from the TEDxVenue dictionary in the Info.plist
+(NSUInteger)eventIdentifier;

// returns the email address from the TEDxVenue dictionary in the Info.plist
+(NSString*)emailAddress;

+(NSString*)eventHashTag;

+(NSString *)eventName;

+(NSString *)eventLocationAdddress;

+(NSString *)eventLocationName;

+(NSNumber *)eventLocationLatitude;

+(NSNumber *)eventLocationLongitude;

+(NSInteger)eventVersion : (NSInteger)eventId;

// returns the FusionTableCalls dictionary from the Info.plist, which contains all the webservice calls to fusion table
+(NSDictionary*)fusionTableDictionary;

// returns the subEvent id from the TEDxVenue dictionary in the Info.plist
// This is used for those event that contains multiple subevents, such as TEDxAsheville, TEDUniversity
+(NSUInteger)subEventIdentifier;

+(void)setEventIds:(int)RowId;

// returns the TEDxVenue dictionary from the Info.plist, which contains the venue id, address, etc
+(NSDictionary*)venueDictionary;

#pragma Constant Values

static NSString* const CURRENT_EVENT_ROWID = @"CurrentEventRowId";

static NSString* const EVENT_SPEAKER_DATA = @"SpeakerData";
static NSString* const EVENT_SESSION_DATA = @"SessionData";
static NSString* const EVENT_VERSION = @"Version";

static NSString* const SUB_EVENT_VERSION = @"SubEventVersion";
static NSString* const SUB_EVENT_SPEAKER_DATA = @"SubEventSpeakerData";
static NSString* const SUB_EVENT_SESSION_DATA = @"SubEventSessionData";

static NSString* const WEBSERVICE_ADDRESS = @"http://www.tedxapps.com/wsdl/TEDxService.svc/";
static NSString* const WEBSERVICE_GETEVENTVERSION = @"GetEventVersion";
static NSString* const WEBSERVICE_GETEVENTSESSIONBYEVENTID = @"GetSessionsByEventId";

static NSString* const WEBSERVICE_DEFAULTJSON = @"[{\"Description\":\"With the band Antony and the Johnsons, Antony tears at the heart with his astonishing voice. A busy musical collaborator, he's also an accomplished visual artist. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Antony\",\"LastName\":\"\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/antony_hegarty-over.jpg\",\"ScheduleDate\":\"\\/Date(1299114000000-0800)\\/\",\"Session\":7,\"SpeakerId\":162,\"Title\":\"Musician, visual artist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.antonyandthejohnsons.com\\/\"},{\"Description\":\"Anthony Atala asks, \\\"Can we grow organs instead of transplanting them?\\\" His lab at the Wake Forest Institute for Regenerative Medicine is doing just that -- engineering over 30 tissues and whole organs. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Anthony\",\"LastName\":\"Atala\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/anthony_atala-over.jpg\",\"ScheduleDate\":\"\\/Date(1299190500000-0800)\\/\",\"Session\":9,\"SpeakerId\":163,\"Title\":\"Surgeon\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.wfubmc.edu\\/Faculty\\/Atala-Anthony-J.htm\"},{\"Description\":\"Bruce Aylward is a Canadian physician and epidemiologist who heads the polio eradication programme at WHO, the Global Polio Eradication Initiative (GPEI). \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Bruce\",\"LastName\":\"Aylward\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/bruce_aylward-over.jpg\",\"ScheduleDate\":\"\\/Date(1299104100000-0800)\\/\",\"Session\":6,\"SpeakerId\":164,\"Title\":\"Epidemiologist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"\"},{\"Description\":\"Amina Az-Zubair is National Coordinator for Education for All, at Nigeria's ministry of education. She's taking a hard look at a failed system, and investing global funds to make it work. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Amina\",\"LastName\":\"Az-Zubair\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/amina_ibrahim-over.jpg\",\"ScheduleDate\":\"\\/Date(1299104100000-0800)\\/\",\"Session\":6,\"SpeakerId\":165,\"Title\":\"\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/news.bbc.co.uk\\/2\\/hi\\/programmes\\/from_our_own_correspondent\\/6908754.stm\"},{\"Description\":\"Maya Beiser commissions and performs radical new work for the cello. The founding cellist of the Bang on a Can All Stars, she's also collaborated with Shirin Neshat and others to produce groundbreaking multimedia concerts. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Maya\",\"LastName\":\"Beiser\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/maya_beiser-over.jpg\",\"ScheduleDate\":\"\\/Date(1299126600000-0800)\\/\",\"Session\":4,\"SpeakerId\":166,\"Title\":\"Cellist\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/cellogoddess\",\"WebSite\":\"http:\\/\\/mayabeiser.com\\/\"},{\"Description\":\"At the MIT Media Lab, Ed Boyden leads the Synthetic Neurobiology Group, which invents technologies to reveal how cognition and emotion arise from brain networks -- and to enable systematic repair of disorders such as epilepsy and PTSD. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Ed\",\"LastName\":\"Boyden\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/ed_boyden-over.jpg\",\"ScheduleDate\":\"\\/Date(1299190500000-0800)\\/\",\"Session\":9,\"SpeakerId\":167,\"Title\":\"Neuroengineer\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/eboyden3\",\"WebSite\":\"http:\\/\\/syntheticneurobiology.org\\/\"},{\"Description\":\"New York Times columnist David Brooks is the author of “Bobos In Paradise: The New Upper Class and How They Got There” and “On Paradise Drive: How We Live Now (and Always Have) in the Future Tense.” \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"David\",\"LastName\":\"Brooks\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/david_brooks-over.jpg\",\"ScheduleDate\":\"\\/Date(1299006000000-0800)\\/\",\"Session\":1,\"SpeakerId\":168,\"Title\":\"Columnist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/topics.nytimes.com\\/top\\/opinion\\/editorialsandoped\\/oped\\/columnists\\/davidbrooks\\/index.html\"},{\"Description\":\"In her book \\\"Gamestorming,\\\" Sunni Brown shows how using art and games can empower serious problem-solving. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Sunni\",\"LastName\":\"Brown\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/sunni_brown-over.jpg\",\"ScheduleDate\":\"\\/Date(1299017700000-0800)\\/\",\"Session\":2,\"SpeakerId\":169,\"Title\":\"Visualizer and gamestorming\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/sunnibrown\\/\",\"WebSite\":\"http:\\/\\/sunnibrown.com\\/\"},{\"Description\":\"The executive chef at Chicago's Moto restaurant, Homaro Cantu creates postmodern cuisine and futuristic food delivery systems. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Homaro\",\"LastName\":\"Cantu\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/homaro_cantu-over.jpg\",\"ScheduleDate\":\"\\/Date(1299027600000-0800)\\/\",\"Session\":3,\"SpeakerId\":170,\"Title\":\"Chef\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/homarocantu\",\"WebSite\":\"http:\\/\\/www.motorestaurant.com\\/\"},{\"Description\":\"David Christian teaches an ambitious world history course that tells the tale of the entire universe -- from the Big Bang 13 billion years ago to present day. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"David\",\"LastName\":\"Christian\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/david_christian-over.jpg\",\"ScheduleDate\":\"\\/Date(1299104100000-0800)\\/\",\"Session\":6,\"SpeakerId\":171,\"Title\":\"Historian\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.modhist.mq.edu.au\\/staff\\/davidchristian.html\"},{\"Description\":\"Beatrice Coron has developed a language of storytelling by papercutting multi-layered stories. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Beatrice\",\"LastName\":\"Coron\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/beatrice_coron-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":5,\"SpeakerId\":172,\"Title\":\"Papercutter artist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.beatricecoron.com\\/\"},{\"Description\":\"Antonio Damasio's research in neuroscience has shown that emotions play a central role in social cognition and decision-making. His work has also had a major influence on current understanding of the neural systems, which underlie memory, language and consciousness. He directs the USC Brain and Creativity Institute. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Antonio\",\"LastName\":\"Damasio\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/antonio_damasio-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":4,\"SpeakerId\":173,\"Title\":\"Neuroscientist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.usc.edu\\/schools\\/college\\/bci\\/\"},{\"Description\":\"When legendary film critic Roger Ebert lost his voice, he found another on Twitter and his blog, where he writes about creativity, race, politics and culture -- and as brilliantly as ever about film. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Roger\",\"LastName\":\"Ebert\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/roger_ebert-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":12,\"SpeakerId\":174,\"Title\":\"Film critic and blogger\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/ebertchicago\",\"WebSite\":\"http:\\/\\/rogerebert.suntimes.com\\/\"},{\"Description\":\"American artist Janet Echelman reshapes urban airspace with monumental, fluidly moving sculpture that responds to environmental forces including wind, water, and sunlight. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Janet\",\"LastName\":\"Echelman\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/janet_echelman-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":9,\"SpeakerId\":175,\"Title\":\"Artist\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/studioechelman\",\"WebSite\":\"http:\\/\\/www.echelman.com\\/\"},{\"Description\":\"Juan Enriquez thinks and writes about the profound changes that genomics and other life sciences will cause in business, technology, politics and society. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Juan\",\"LastName\":\"Enriquez\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/juan_enriquez-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":9,\"SpeakerId\":176,\"Title\":\"Futurist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.excelvm.com\\/\"},{\"Description\":\"Harvey V. Fineberg studies medical decisionmaking -- from how we roll out new medical technology, to how we cope with new illnesses and threatened epidemics. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Harvey\",\"LastName\":\"V. Fineberg\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/harvey_fineberg-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":11,\"SpeakerId\":177,\"Title\":\"Health policy expert\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.iom.edu\\/Global\\/Directory\\/Combo.aspx?staffid={E9714D98-F8EB-435D-B6D8-753A320585A7}&member\"},{\"Description\":\"As executive chair of the Ford Motor Company, William Clay Ford, Jr., is leading the company that put the world on wheels into the 21st century. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Bill\",\"LastName\":\"Ford\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/bill_ford-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":8,\"SpeakerId\":178,\"Title\":\"Executive chair, Ford Motor Co.\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/media.ford.com\\/article_display.cfm?article_id=93\"},{\"Description\":\"A passionate techie and a shrewd businessman, Bill Gates changed the world once, while leading Microsoft to dizzying success. Now he's set to do it again with his own style of philanthropy and passion for innovation. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Bill\",\"LastName\":\"Gates\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/bill_gates-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":6,\"SpeakerId\":179,\"Title\":\"Philanthropist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.gatesfoundation.org\\/annual-letter\\/2010\\/Pages\\/bill-gates-annual-letter.aspx\"},{\"Description\":\"Basil Jones and Adrian Kohler, of Handspring Puppet Company, bring the emotional complexity of animals to the stage with their life-size puppets. Their latest triumph: \\\"War Horse.\\\" \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Handspring\",\"LastName\":\"\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/handspring_puppet_company-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":1,\"SpeakerId\":180,\"Title\":\"Puppeteers\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.handspringpuppet.co.za\\/\"},{\"Description\":\"Kate Hartman creates devices and interfaces for humans, houseplants, and glaciers. Her work playfully questions the ways in which we relate and communicate. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Kate\",\"LastName\":\"Hartman\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/kate_hartman-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":10,\"SpeakerId\":181,\"Title\":\"Artist and technologist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.katehartman.com\\/index.php\"},{\"Description\":\"Shea Hembrey explores patterns from nature and myth. A childhood love of nature, and especially birdlife, informs his vision. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Shea\",\"LastName\":\"Hembrey\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/shea_hembrey-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":10,\"SpeakerId\":182,\"Title\":\"Artist and curator\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.sheahembrey.com\\/\"},{\"Description\":\"Dennis Hong is the founder and director of RoMeLa -- a Virginia Tech robotics lab that has pioneered several breakthroughs in robot design and engineering. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Dennis\",\"LastName\":\"Hong\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/dennis_hong-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":8,\"SpeakerId\":183,\"Title\":\"Roboticist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.romela.org\\/main\\/Robotics_and_Mechanisms_Laboratory\"},{\"Description\":\"Jack Horner and his dig teams have discovered the first evidence of parental care in dinosaurs, extensive nesting grounds, evidence of dinosaur herds, and the world’s first dinosaur embryos. He's now exploring how to build a dinosaur. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Jack\",\"LastName\":\"Horner\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/jack_horner-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":11,\"SpeakerId\":184,\"Title\":\"Dinosaur digger\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.museumoftherockies.org\\/Home\\/EXPLORE\\/Dinosaurs\\/PeopleinPaleo\\/JackHorner\\/tabid\\/389\\/Default.\"},{\"Description\":\"Teacher and musician John Hunter is the inventor of the World Peace Game (and the star of the new doc \\\"World Peace and Other 4th-Grade Achievements\\\"). \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"John\",\"LastName\":\"Hunter\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/john_hunter-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":12,\"SpeakerId\":185,\"Title\":\"Educator\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/worldpeacemovie\",\"WebSite\":\"http:\\/\\/theworldpeacegame.com\\/\"},{\"Description\":\"With a camera, a dedicated wheatpasting crew and the help of whole villages and favelas, 2011 TED Prize winner JR shows the world its true face. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"JR\",\"LastName\":\"\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/jr-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":7,\"SpeakerId\":186,\"Title\":\"Street artist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/blog.ted.com\\/2010\\/10\\/19\\/announcing-the-2011-ted-prize-winner-jr\\/\"},{\"Description\":\"A performing poet since she was 14 years old, Sarah Kay is the founder of Project V.O.I.C.E, teaching poetry and self-expression at schools across the United States. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Sarah\",\"LastName\":\"Kay\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/sarah_kay-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":10,\"SpeakerId\":187,\"Title\":\"Poet\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.project-voice.net\\/about-us\\/\"},{\"Description\":\"In 2004, Salman Khan, a hedge fund analyst, began posting math tutorials on YouTube. Six years later, he has posted more than 2.000 tutorials, which are viewed nearly 100,000 times around the world each day. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Salman\",\"LastName\":\"Khan\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/salman_kahn-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":6,\"SpeakerId\":188,\"Title\":\"Educator\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/khanacademy\",\"WebSite\":\"http:\\/\\/www.khanacademy.org\\/\"},{\"Description\":\"Aaron Koblin is an artist specializing in data and digital technologies. His work takes real world and community-generated data and uses it to reflect on cultural trends and the changing relationship between humans and technology. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Aaron\",\"LastName\":\"Koblin\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/aaron_koblin-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":3,\"SpeakerId\":189,\"Title\":\"Data artist\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/aaronkoblin\",\"WebSite\":\"http:\\/\\/www.aaronkoblin.com\\/\"},{\"Description\":\"Christina Lampe-Onnerud is a pioneer in the use of lithium-ion and other materials to deliver more powerful, longer-lasting, safer batteries for laptops, electric vehicles, utility energy storage and more. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Christina\",\"LastName\":\"Lampe-Onnerud\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/christina_lampe_onnerud-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":9,\"SpeakerId\":190,\"Title\":\"Energy expert\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.boston-power.com\\/\"},{\"Description\":\"Sarah Marquis rediscovers the link between humans and nature, one step at a time. She's been walking for the past 20 years (or 30,000km). Alone, she has survived in the most deserted places on Earth. Her latest expedition: Siberia to Australia. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Sarah\",\"LastName\":\"Marquis\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/sarah_marquis-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":1,\"SpeakerId\":191,\"Title\":\"Explorer\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/sarah_marquis\",\"WebSite\":\"http:\\/\\/www.sarahmarquis.ch\\/\"},{\"Description\":\"General Stanley McChrystal is the former commander of U.S. and International forces in Afghanistan. A four-star general, he is credited for creating a revolution in warfare that fuses intelligence and operations. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Stanley\",\"LastName\":\"McChrystal\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/stanley_mcchrystal-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":11,\"SpeakerId\":192,\"Title\":\"Military leader\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/jackson.yale.edu\\/\"},{\"Description\":\"Listening to Bobby McFerrin sing may be hazardous to your preconceptions. Side effects may include unparalleled joy, a new perspective on creativity, rejection of the predictable, and a sudden, irreversible urge to lead a more spontaneous existence. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Bobby\",\"LastName\":\"McFerrin\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/bobby_mcferrin-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":2,\"SpeakerId\":193,\"Title\":\"Musician\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"\"},{\"Description\":\"Singer\\/songwriter Jason Mraz wraps moments of self-reflection inside clever lyrics and pop melodies. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Jason\",\"LastName\":\"Mraz\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/jason_mraz-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":10,\"SpeakerId\":194,\"Title\":\"Musician\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/jason_mraz\",\"WebSite\":\"http:\\/\\/www.jasonmraz.com\\/\"},{\"Description\":\"Paul Nicklen photographs the creatures of the Arctic and Antarctic, generating global awareness about wildlife in these isolated and endangered environments. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Paul\",\"LastName\":\"Nicklen\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/paul_nicklen-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":2,\"SpeakerId\":195,\"Title\":\"\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.paulnicklen.com\\/\"},{\"Description\":\"Indra Nooyi is the chief architect of PepsiCo's multi-year growth strategy, Performance with Purpose, with the goal of sustainable growth and a healthier future for both people and planet. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Indra\",\"LastName\":\"Nooyi\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/indra_nooyi-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":5,\"SpeakerId\":196,\"Title\":\"Chair+CEO, PepsiCo\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.pepsico.com\\/\"},{\"Description\":\"Fiorenzo G. Omenetto's research spans nonlinear optics, nanostructured materials (such as photonic crystals and photonic crystal fibers), biomaterials and biopolymer-based photonics. Most recently, he's working on high-tech applications for silk. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Fiorenzo\",\"LastName\":\"Omenetto\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/fiorenzo_omenetto-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":9,\"SpeakerId\":197,\"Title\":\"Biomedical engineer\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/ase.tufts.edu\\/biomedical\\/unolab\\/home.html\"},{\"Description\":\"Rajesh Rao seeks to understand the human brain through computational modeling, on two fronts: developing computer models of our minds, and using tech to decipher the 4,000-year-old script of the Indus valley civilization. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Rajesh\",\"LastName\":\"Rao\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/rajesh_rao-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":11,\"SpeakerId\":198,\"Title\":\"Computational neuroscientist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.cs.washington.edu\\/homes\\/rao\\/\"},{\"Description\":\"Carlo Ratti directs the MIT SENSEable City Lab, which explores the \\\"real-time city\\\" by studying the way sensors and electronics relate to the built environment. He's opening a research center in Singapore as part of an MIT-led initiative on the Future of Urban Mobility. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Carlo\",\"LastName\":\"Ratti\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/carlo_ratti-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":3,\"SpeakerId\":199,\"Title\":\"Architect and engineer\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.carloratti.com\\/\"},{\"Description\":\"Deb Roy studies how children learn language, and designs machines that learn to communicate in human-like ways. Currently on sabbatical from MIT Media Lab, he's working with the AI company Bluefin Labs. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Deb\",\"LastName\":\"Roy\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/deb_roy-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":4,\"SpeakerId\":200,\"Title\":\"Cognitive scientist\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.media.mit.edu\\/cogmac\\/index.html\"},{\"Description\":\"Kathryn Schulz is the author of \\\"Being Wrong: Adventures in the Margin of Error,\\\" and writes \\\"The Wrong Stuff,\\\" a Slate series featuring interviews with high-profile people about how they think and feel about being wrong. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Kathryn\",\"LastName\":\"Schulz\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/kathryn_schulz-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":12,\"SpeakerId\":201,\"Title\":\"Wrongologist\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/wrongologist\",\"WebSite\":\"http:\\/\\/beingwrongbook.com\\/\"},{\"Description\":\"Morgan Spurlock makes documentary film and TV that is personal, political -- and, above all, deeply empathetic. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Morgan\",\"LastName\":\"Spurlock\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/morgan_spurlock-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":5,\"SpeakerId\":202,\"Title\":\"Filmmaker\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/morganspurlock\",\"WebSite\":\"http:\\/\\/morganspurlock.com\\/\"},{\"Description\":\"Daniel Tammet is the author of \\\"Born on a Blue Day,\\\" about his life with high-functioning autistic savant syndrome. He runs the language-learning site Optimnem, and his new book is \\\"Embracing the Wide Sky: A Tour Across the Horizons of the Mind.\\\" \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Daniel\",\"LastName\":\"Tammet\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/daniel_tammet-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":9,\"SpeakerId\":203,\"Title\":\"Linguist, educator\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/www.optimnem.co.uk\\/about.php\"},{\"Description\":\"Julie Taymor is a film, theater and opera director. Her latest film is \\\"The Tempest,\\\" with Helen Mirren. She's recently produced \\\"The Magic Flute\\\" at the Met, and created \\\"The Lion King\\\" and the new \\\"Spider-Man: Turn Off the Dark\\\" on Broadway. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Julie\",\"LastName\":\"Taymor\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/julie_taymor-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":5,\"SpeakerId\":204,\"Title\":\"Director, designer\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"\"},{\"Description\":\"Edward Tenner is an independent writer, speaker, and editor analyzing the cultural aspects of technological change. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Edward\",\"LastName\":\"Tenner\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/edward_tenner-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":8,\"SpeakerId\":205,\"Title\":\"Historian of technology and culture\",\"Topic\":\"\",\"Twitter\":\"\",\"WebSite\":\"http:\\/\\/edwardtenner.com\\/\"},{\"Description\":\"Despite receiving no formal training until age 18, Eric Whitacre is one of the most performed composers of his generation. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Eric\",\"LastName\":\"Whitacre\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/eric_whitacre-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":1,\"SpeakerId\":206,\"Title\":\"Composer, conductor\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/ericwhitacre\",\"WebSite\":\"\"},{\"Description\":\"Edith Widder combines her expertise in research and technological innovation with a commitment to stopping and reversing the degradation of our marine environment. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Edith\",\"LastName\":\"Widder\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/edith_widder-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":7,\"SpeakerId\":207,\"Title\":\"Deep-sea explorer\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/teamorca\",\"WebSite\":\"http:\\/\\/www.teamorca.org\\/\"},{\"Description\":\"With a background in molecular biology, biochemistry and phytoplankton physiology, Felisa Wolfe-Simon seeks to uncover the sequence of events that shaped the evolution of the modern oceans' phytoplankton and life itself. \",\"Email\":\"\",\"EventId\":0,\"Facebook\":\"\",\"FirstName\":\"Felisa\",\"LastName\":\"Wolfe-Simon\",\"PhotoUrl\":\"http:\\/\\/images.ted.com\\/images\\/ted\\/conference\\/TED2011\\/speakers\\/over\\/felisa_wolfe_simon-over.jpg\",\"ScheduleDate\":\"\\/Date(-62135568000000-0800)\\/\",\"Session\":4,\"SpeakerId\":208,\"Title\":\"Geobiochemist\",\"Topic\":\"\",\"Twitter\":\"http:\\/\\/twitter.com\\/#!\\/ironlisa\",\"WebSite\":\"http:\\/\\/www.ironlisa.com\\/\"}]";
@end
