/+

	[TODO]
	=================================================================================================	
		TEST: mostly all the same letter? reject.  "ZZZZZZZZZZZZxZ"
		TEST: all numbers? reject.     "533152135215"
		TEST: Minimum length for a total match. ".22" is meaningless.   ".22 caliber gun" isn't.
		TEST: English dictionary match (dict better not have JUNK IN IT, also CASE?)
		TEST: valid cases? upper, lower, mixed? Usually you're not going to see "UnDeRsTaNdAbLe"
	
	
	-- CASE insensitivity
	
	https://www.reddit.com/r/rust/comments/1cfprzs/nlp_determining_if_a_string_might_be_an_english/
		"dictionary search with a trei, you can find the DISTANCE to a valid word" even if they're mispelled.
		
		TWO (or more) cases:
			- swapped letter  	(c instead of k)
			- swapped order   	(takl instead of talk)
			- extra letter, 	(talkk)
			- repeated letter.    	(tanlk -- talk?, tank? dubious!)
			- others issues? just wrong letters?   talkiqng  	
			- extra spaces?  talk ing				(this blows our word boundaries to hell!) 
	
	
			--> SPELL CORRECTORS are doing the DETECTION phase!
			https://norvig.com/spell-correct.html
			
			
			Although we still need special pattern cases for things like
				- functions() however they're encoded in an executable/dll/debug symbol library
				- filename+extensions
				- ip addresses? (that should be a super simple grep though,  10.0.0.1,  127.0.0.1)
				- file paths?
				
			dob.exe example:
				COMSPEC=\COMMAND.COM		(strings found this)

			often times we could just start with STRINGS and then prune the bad matches. Not sure if strings is super eager and we only need to prune, or we can find ones it cannot.
			
			https://github.com/redox-os/binutils-gdb/blob/master/binutils/strings.c
				is this old? doesn't exactly match my man page. maybe matches strings --help though.
	
	
	Q: how do we handle a rolling window where the match can be:
	
	
	203410n5ion235I am a taco person98539532
	|	           |			|
		  window1	window2
		  "I am a"
		  		"taco person"
		   | I am a taco person |   rolling window
		   |--------------------|   
	|--------------------|  "I am a"   
	 |--------------------| "I am a t"
	  |--------------------| "I am a ta"
	   |--------------------| "I am a tac"
	    |--------------------| "I am a taco"
	     |--------------------| "I am a taco "
	      |--------------------| "I am a taco p"
	       |--------------------| "I am a taco pe"
	        |--------------------| "I am a taco per" ... ETC   how do we know when to stop the rolling window as match?
	        	
	        	
	        	I mean if we don't running ""slower"" we can just run the match (with a max length) for every single character increase, and "deliever" the best match we find.
		  	

+/

import std.stdio;
import std.string;
import std.regex;
import std.math : log2;
import std.algorithm : canFind, count;
import std.conv : to;
import std.range : array;

// Function to clean non-ASCII characters (keep printable ASCII 32-126)
string cleanString(string input) {
    char[] result;
    foreach (c; input) {
        if (c >= 32 && c <= 126) {
            result ~= c;
        } else {
            result ~= ' ';
        }
    }
    return result.idup;
}

// Function to calculate Shannon entropy
double calculateEntropy(string word) {
    if (word.length < 2) return 0.0;
    
    int[char] charCount;
    foreach (c; word) {
        charCount[c]++;
    }
    
    double entropy = 0.0;
    foreach (count; charCount.values) {
        double probability = cast(double)count / word.length;
        entropy -= probability * log2(probability);
    }
    return entropy;
}

// Function to check if string is a human word
bool isHumanWord(string word) {
    word = word.strip(); // Remove whitespace
    if (word == "I")return true;
    if (word.toLower == "my")return true;
    if (word.toLower == "a")return true;
    if (word.toLower == "why")return true;
    if (word.length > 80) return false; // Max length check
    if (word.length < 2 || word.length > 20) return false;
    
    // Check for vowels
    if (!word.canFind!(c => "aeiouAEIOU".indexOf(c) != -1)) return false;
    
    // Not all numbers and not a file extension
    if (word.matchFirst(r"^[0-9]+$") || word.matchFirst(r"\.[a-zA-Z]{1,4}$")) return false;
    
    return true;
}

// Function to check if string is an acronym
bool isAcronym(string word) {
    word = word.strip();
    if (word.length > 80) return false; // Max length check
    return !word.matchFirst(r"^[A-Z]{2,8}$").empty;
}

// Function to check if string has a file extension
bool hasFileExtension(string word) {
    if (word.length > 80) return false; // Max length check
    return !word.matchFirst(r"\.[a-zA-Z]{1,4}$").empty;
    // TODO: only use common file extensions?
}

void main(string[] args) {
	bool doShowHidden = false;
	bool doShowOnlyMissing = false;
	if(args.length > 1){
		if(args[1] == "--show"){
			doShowHidden = true;
		}else if(args[1] == "--only"){
			doShowOnlyMissing = true;
		}else{
			writefln("args:");
			writefln(" --show - Show all matches, even if they don't tag anything like acroynyms");
			writefln(" --only - Only show non-matches");
		return;
		}
	}
    ulong totalLines = 0;
    ulong humanWords = 0;
    ulong acronyms = 0;
    ulong extensions = 0;
    ulong highEntropy = 0;
    
    
	import core.sys.posix.unistd : isatty;

    if (isatty(0)) { // stdin
        writeln("stdin is empty (terminal)");
    	return;
    } else {
    }

    // Process stdin line by line
    foreach (line; stdin.byLine) {
        totalLines++;
        string original = line.idup;
        string cleaned = cleanString(original);
        
//        writeln("Original: ", original);
  //      writeln("Cleaned:  ", cleaned);
        
        // Split on whitespace
        auto words = cleaned.split();
        
        foreach (word; words) {
            if (word.length > 80) {
                writeln("Skipped (too long, >80 chars): ", word);
                continue;
            }
            
            double entropy = calculateEntropy(word);       
            string labels = "";
            
            if (entropy > 2.5) {
                labels ~= format("[Entropy: %.6f] ", entropy);
                highEntropy++;
            }
            if (isHumanWord(word)) {
                labels ~= format("[Word] ");
                humanWords++;
            }            
            if (isAcronym(word)) {
                labels ~= format("[Acronym] ");
                acronyms++;
            }
            if (hasFileExtension(word)) {
                labels ~= format("[File Extension] ");
                extensions++;
            }
            if(doShowHidden && labels == ""){writefln("%-20s [%s]", word, "prunned"); continue;} 
            if(doShowOnlyMissing && labels == ""){writefln("%-20s [%s]", word, "prunned"); continue;}
//            if(labels == "")continue;
            if(!doShowHidden && !doShowOnlyMissing && labels != "") writefln("%-20s [%s]", word, labels);
        }
    }
    
    // Print summary
    writeln("\nAnalysis Summary:");
    writefln("Total lines processed: %d", totalLines);
    writefln("Human words found: %d", humanWords);
    writefln("Acronyms found: %d", acronyms);
    writefln("File extensions found: %d", extensions);
    writefln("High entropy strings found: %d", highEntropy);
}
