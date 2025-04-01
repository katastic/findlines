/+
    we could multithread certain things like checking against all words but ideally we should be structuring it in an efficent way, not hoping for extra power with an extra core.

    the problem

        dict of words
            >100000 words! 

        MULTIPLIED by checking every single starting place of a string!

        "Hello World!"  12 chars, 12 runs through 100,000 words! 12 million tests for ONE line!
         hello
          x
           x 
            x 
             x
              x
               world
                x
                 x
                  x
                   x
                    x

        note we're still testing characters even if we found a match that includes the NEXT characters!
+/

import std.stdio, std.conv;
import std.algorithm;
import std.ascii;
//                    import std.uni : isAlphaUni;
                    
import std.algorithm;
import std.string : representation;

import std.typecons;


bool boundedBy(double value, double min, double max){
    if(value < min)return false;
    if(value > max)return false;
    return true;
    }

import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.math;
import std.array;
import std.range;
import std.typecons;

// Function to calculate Shannon entropy of a string
double entropy(string input) {
    double entropyValue = 0.0;
    size_t len = input.length;

    // Use an associative array to count character frequencies
    int[string] freq;
    foreach (char c; input)
        freq[c.to!string]++;

    foreach (value; freq.byValue) {
        double p = cast(double)value / len;
        entropyValue -= p * log2(p);
    }

    return entropyValue;
}

ulong howManyValid(string s){
    ulong howMany = s.representation.filter!(c => c.isAlpha).count;
    return howMany;
    }

float percentValid(string s){
    float len = s.length;
    float howMany = howManyValid(s);
    return howMany/len;
}
import std.array;
import std.file;
import std.container;
import std.regex;

string[] words;
string[] extraWords = ["cfg", "txt", "ini"];

// Function to load words from dictionary file into a hash set
void loadDictionary(string filename="/usr/share/dict/american-english") {
    //string[] words;
    File f = File(filename);
    foreach (line; f.byLine) {
        words ~= line.strip().toLower.to!string;
        }
    words = words ~ extraWords;
    }


// Function to find dictionary words in the given text
string[] findWordsInText(string text) {
    if(words.length == 0)loadDictionary();
    string[] foundWords;
    
    foreach (word; words) {
        if (text.toLower.canFind(word)) {
            foundWords ~= word;
        }
    }
    
    return foundWords;
}

auto numWordsIn(string s){
    return findWordsInText(s).length;
}


bool isNumeric(dchar c) pure nothrow @nogc @safe{
    return (!isAlpha(c) && isAlphaNum(c));
}

float percentNumeric(string s) => s.representation.filter!(c => c.isNumeric).count / cast(float)s.length;
float percentNonASCII(string s) => s.representation.filter!(c => c.isControl).count / cast(float)s.length;
string onlyPrintable(string s) => cast(immutable(char)[])s.representation.filter!(c => c.isPrintable).array;
//to!string doesn't work, but .array does for collapsing the range into a bytes

void main(string[] args)
{
    if (args.length < 2)
    {
        writeln("Usage: ", args[0], " <filename>");
        return;
    }

    string filename = args[1];
    string currentSegment;
    int segmentNumber = 1;

    try
    {
        File file = File(filename, "r");
        
        while (!file.eof())
        {
            auto cap = file.rawRead(new char[1]);
            if(cap.length == 0)continue;
            char c = cast(char)cap[0];
            
            if (c == '\n' || c == '\0')
            {
                if (currentSegment.length > 2)  // Only print non-empty segments and >x chars
                {
                    string delimiterType = (c == '\n') ? "n" : "0";                    

                    bool hasLetters3 = false;
                    foreach (char ch; currentSegment)
                    {
                        if (isAlphaNum(ch))
                        {
                            hasLetters3 = true;
                            break;
                        }
                    }
  //                  if(!findWordsInText(currentSegment)){ /// If we have a dictionary word, we ALWAYS pass.
                        if(!hasLetters3)goto lastChance;
                        if(percentValid(currentSegment) < .1)goto lastChance;
                        if(percentNonASCII(currentSegment) > .5)goto lastChance;
                        if(!entropy(currentSegment).boundedBy(0, 4))goto lastChance;
                        if(percentNumeric(currentSegment) > .43)goto lastChance;
                        goto goodenough;

                        lastChance: //this is most expensive operation so we do it ONLY if we can't find any other justifications.
                        if(entropy(currentSegment).boundedBy(0, 4) && 
                            !findWordsInText(currentSegment))continue;
                        // there's a few tests we might want to do that could NEVER result in a word (all numbers) to quick terminate.
                    
                        goodenough:


//                    if(!currentSegment.any!isAlpha)break;
                    writefln("[%50s] %d (end:%3s, len:%3s) (valid%%:%4.2s,%4.2s) ΔS %3.2s %%# %3.2s", 
                            onlyPrintable(currentSegment), 
                            segmentNumber, 
                            delimiterType, 
                            currentSegment.length,
                            percentValid(currentSegment),
                            percentNonASCII(currentSegment),
                            entropy(currentSegment),
                            percentNumeric(currentSegment),
                            );
                }
                skip:
                currentSegment = "";
                segmentNumber++;
            }
            else
            {
                currentSegment ~= c;
            }
        }

        // Handle case where file doesn't end with newline or null
        if (currentSegment.length > 0)
        {
            writefln("Segment %d (no delimiter at end): %s", 
                    segmentNumber, 
                    currentSegment);
        }
        
        file.close();
    }
    catch (Exception e)
    {
        writeln("Error: ", e.msg);
    }
}