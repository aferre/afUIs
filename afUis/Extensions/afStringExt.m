//
//  afStringExt.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 14/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afStringExt.h"


@implementation NSString(afStringExt)

- (BOOL) isEmpty{
	if (!self || [self isEqual:nil] || [self isEqualToString:@""]) 
		return YES;
	return NO;
}

- (NSString *) reducedString{
	NSString *s = [NSString stringWithString:self];
	
	//s = [s stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"è" withString:@"e"];
	s = [s stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
	s = [s stringByReplacingOccurrencesOfString:@"ë" withString:@"e"];
	s = [s stringByReplacingOccurrencesOfString:@"ê" withString:@"e"];
	s = [s stringByReplacingOccurrencesOfString:@"à" withString:@"a"];
	s = [s stringByReplacingOccurrencesOfString:@"â" withString:@"a"];
	s = [s stringByReplacingOccurrencesOfString:@"ï" withString:@"i"];
	s = [s stringByReplacingOccurrencesOfString:@"î" withString:@"i"];
	s = [s stringByReplacingOccurrencesOfString:@"ö" withString:@"o"];
	s = [s stringByReplacingOccurrencesOfString:@"ô" withString:@"o"];
	s = [s stringByReplacingOccurrencesOfString:@"ü" withString:@"u"];
	s = [s stringByReplacingOccurrencesOfString:@"ù" withString:@"u"];
	s = [s stringByReplacingOccurrencesOfString:@"û" withString:@"u"];
	s = [s stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
	s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"et"];
	/*s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"?" withString:@""];
	*/
	return s;
}

+ (NSString *)stringFromDate:(NSDate *)theDate
withLocalIdentifier:(NSString *)li
andDateFormat:(NSString *)dformat{
	
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:li];
	
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setLocale:usLocale];
	[df setDateFormat:dformat];
	[usLocale release];
	return [df stringFromDate:theDate];
}

-(NSString *)base64{
    
    return [NSString base64EncodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

+(NSString *)base64EncodeData:(NSData *)data{
    //Point to start of the data and set buffer sizes
    int inLength = [data length];
    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp;
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
    
    /* http://en.wikipedia.org/wiki/Base64
     Text content   M           a           n
     ASCII          77          97          110
     8 Bit pattern  01001101    01100001    01101110
     
     6 Bit pattern  010011  010110  000101  101110
     Index          19      22      5       46
     Base64-encoded T       W       F       u
     */
    
    
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;                  
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;                          
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer); 
    return pictemp;
}


@end
