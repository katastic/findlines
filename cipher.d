import std.stdio;
import std.string;

void main(string[] args) {
    // Define the substitution cipher mapping (ASCII chars)
    char[char] cipherMap;
    cipherMap['a'] = 'T';
    cipherMap['u'] = 'h';
    cipherMap['v'] = 'i';
    cipherMap[cast(char)128] = 's'; // € as ASCII 128 (placeholder, adjust per code page)
    cipherMap[cast(char)134] = 'y'; // † as ASCII 134
    cipherMap['|'] = 'o';
    cipherMap[cast(char)130] = 'u'; // ‚ as ASCII 130
    cipherMap[cast(char)127] = 'r'; //  as ASCII 127 (DEL or house in CP437)
    cipherMap['o'] = 'b';
    cipherMap['r'] = 'e';
    cipherMap['q'] = 'd';
    cipherMap['z'] = 'm';
    cipherMap['n'] = 'a';
    cipherMap['x'] = 'k';
    cipherMap['c'] = 'V';
    cipherMap['{'] = 'n';
    cipherMap['y'] = 'l';
    cipherMap[cast(char)132] = 'w'; // „ as ASCII 132
    cipherMap['p'] = 'c';
    cipherMap['P'] = 'C'; // was c
    cipherMap['}'] = 'p';
    cipherMap[cast(char)129] = 't'; //  as ASCII 129
    cipherMap['\\'] = 'O';
    cipherMap['s'] = 'f';
    cipherMap['4'] = '\'';
    cipherMap['O'] = 'B';
    cipherMap['Z'] = 'M';
    cipherMap['N'] = 'A';
    cipherMap['w'] = 'j';
    cipherMap['f'] = 'Y'; // wrong?
    cipherMap['t'] = 'g';
    cipherMap['d'] = 'W';
    cipherMap['W'] = 'J';
    cipherMap['`'] = 'S';
    cipherMap['b'] = 'U';
//    cipherMap['_'] = 'D'; // ???? guess DOOM
//    cipherMap['@'] = 'z';
    cipherMap[cast(char)173] = '1';
    cipherMap[cast(char)208] = '2';
    cipherMap[cast(char)139] = '3';
    cipherMap[cast(char)136] = '4';
    cipherMap[cast(char)244] = '5';
    cipherMap[cast(char)175] = '6';
    cipherMap[cast(char)240] = '7';
    cipherMap[cast(char)204] = '8';
    cipherMap[cast(char)237] = '1';
    cipherMap[cast(char)194] = '0';
    cipherMap[cast(char)138] = '1';
    cipherMap[cast(char)245] = '2';
    cipherMap[cast(char)179] = '3';
    cipherMap[cast(char)174] = '4';
    cipherMap[cast(char)205] = '5';
    cipherMap[cast(char)177] = '6';
    cipherMap[cast(char)169] = '7';
    cipherMap[cast(char)214] = '8';
    cipherMap[cast(char)250] = ',';
    cipherMap[cast(char)133] = 'x';
    cipherMap[cast(char)241] = '1';
    cipherMap[cast(char)215] = '2';
    cipherMap[cast(char)199] = '3';
    cipherMap[cast(char)181] = '4';
    cipherMap[cast(char)163] = '5';
    cipherMap[cast(char)148] = '6';
    cipherMap[cast(char)217] = '7';
    cipherMap[cast(char)235] = '8';
    cipherMap[cast(char)184] = '.';
    cipherMap[cast(char)145] = '0';
    cipherMap[cast(char)161] = '1';
    cipherMap[cast(char)150] = '2';
    cipherMap[cast(char)197] = '3';
    cipherMap[cast(char)220] = '4';
    cipherMap[cast(char)212] = '5';
    cipherMap[cast(char)140] = '6';
    cipherMap[cast(char)153] = '7';
    cipherMap[cast(char)248] = '8';
    cipherMap[cast(char)27] = '/';
    cipherMap[cast(char)223] = '0';
    cipherMap[cast(char)216] = '1';
    cipherMap[cast(char)164] = '2';
    cipherMap[cast(char)198] = '3';
    cipherMap[cast(char)131] = 'v';
    
    cipherMap[cast(char)176] = '!';
cipherMap[cast(char)135] = 'z';
cipherMap[cast(char)155] = '#';
cipherMap[cast(char)225] = '$';
cipherMap[cast(char)191] = '%';
cipherMap[cast(char)157] = '^';
cipherMap[cast(char)192] = '&';
cipherMap[cast(char)188] = '*';
cipherMap[cast(char)222] = '(';
cipherMap[cast(char)226] = ')';
cipherMap[cast(char)154] = '_';
cipherMap[cast(char)151] = '+';
cipherMap[cast(char)160] = '[';
cipherMap[cast(char)159] = ']';
cipherMap[cast(char)219] = '1';
cipherMap[cast(char)227] = '2';
cipherMap[cast(char)254] = '3';
cipherMap[cast(char)218] = '4';
cipherMap[cast(char)196] = '5';
cipherMap[cast(char)232] = '6';
cipherMap[cast(char)234] = '7';
cipherMap[cast(char)182] = '8';
cipherMap[cast(char)183] = ',';
cipherMap[cast(char)231] = '0';
cipherMap[cast(char)195] = '1';
cipherMap[cast(char)249] = '2';
cipherMap[cast(char)229] = '3';
cipherMap[cast(char)211] = '4';
cipherMap[cast(char)221] = '5';
cipherMap[cast(char)185] = '6';
cipherMap[cast(char)203] = '7';
cipherMap[cast(char)247] = '8';
cipherMap[cast(char)193] = ',';
cipherMap[cast(char)149] = '0';
cipherMap[cast(char)162] = '1';
cipherMap[cast(char)167] = '2';
cipherMap[cast(char)252] = '3';
cipherMap[cast(char)180] = '4';
cipherMap[cast(char)144] = '5';
cipherMap['9'] = ',';

    
    
    
    
    //=[],[39]=['],[74]=[J],[65]=[A],[38]=[&],[3]=[],[66]=[B],[106]=[j],[7]=[],[101]=[e],[2]=[],[29]=[],[70]=[F],[133]=[�],[241]=[�],
    //[43]=[+],[61]=[=],[60]=[<],[199]=[�],[181]=[�],[96]=[`],[163]=[�],[94]=[^],[148]=[�],[42]=[*],[217]=[�],[76]=[L],[24]=[],[235]=[�],
    //[184]=[�],[6]=[],[145]=[�],[109]=[m],[161]=[�],[150]=[�],[215]=[�],[197]=[�],[99]=[c],[220]=[�],[73]=[I],[91]=[[],[212]=[�],
    //[40]=[(],[176]=[�],[14]=[],[22]=[],[4]=[],[32]=[ ],[58]=[:],[153]=[�],[50]=[2],[140]=[�],[248]=[�],[81]=[Q],[27]=[�],[223]=[�]
    //,[216]=[�],[164]=[�],[198]=[�],[234]=[�],[182]=[�],[77]=[M],[183]=[�],[231]=[�],[93]=[]],[28]=],[108]=[l],[229]=[�],[82]=[R],
    //[211]=[�],[221]=[�],[185]=[�],[203]=[�],[247]=[�],[23]=[],[193]=[�],[5]=[],[31]=[],[49]=[1],[149]=[�],[54]=[6],[162]=[�],[41]=[)],
    //[131]=[�],[167]=[�],[252]=[�],[180]=[�],[144]=[�],[126]=[~],[72]=[H],[36]=[$],[18]=[]
    
    cipherMap['V'] = 'I'; // i think
//    cipherMap['U'] = 'H'; // i think
    cipherMap['Y'] = 'L';
    cipherMap['R'] = 'E';
    cipherMap['~'] = 'q';
    cipherMap['U'] = 'H'; // Fine Hamster
    cipherMap[']'] = 'P'; // Fine Hamster? // "Releaves Pain"
    cipherMap['T'] = 'G'; // ANGLE
    cipherMap['_'] = 'R'; // ROOM 
 //   cipherMap['H'] = 'W';
//for(char i = 130; i < 140; i++)
  //  cipherMap[cast(char)i] = '0';

    // Hyphen and semicolon become spaces
    cipherMap['5'] = '(';
    cipherMap['6'] = ')';
    cipherMap['-'] = ' ';
    cipherMap[';'] = '.';
    cipherMap[':'] = '-'; // run-down shack
    cipherMap['S'] = 'F'; 
    cipherMap['/'] = '"';
    cipherMap['.'] = '.';
    cipherMap['Q'] = 'D';
    cipherMap['X'] = 'K'; // Kennedy in lmtext.dat
    cipherMap['>'] = '1'; //<------------
    cipherMap['?'] = '2'; // <----------??
    cipherMap['@'] = '3';
    cipherMap['A'] = '4';
    cipherMap['B'] = '5';
    
    cipherMap['C'] = '6'; // gussed
    
    cipherMap['D'] = '7'; 
    cipherMap['E'] = '8'; 
    cipherMap['F'] = '9'; 
    cipherMap['='] = '0'; 
    cipherMap['G'] = ':';
    cipherMap['L'] = '"'; // i think
    cipherMap['^'] = 'Q'; // i think
//    cipherMap[cast(char)2] = '2'; // maybe? 2 reports come from indians 
    
    cipherMap['g'] = 'Z'; // Zieg,  Zeug, Zu noch das Norge, Zehren
	// 69, 70, 62, 61, 64 all numbers
	// 62 is used twice in november. 11, 22, 33 can't be 33! 22 or 11.

	cipherMap['H'] = '\t'; // stinky congealed green sewage?[H]72?except it was stinkier.  Joe 
				// could it be bold rich text??? a tab???

	cipherMap['7'] = '*';
	cipherMap['<'] = 'A'; // A bonfire circle.
	//cipherMap[''] = '';
	//cipherMap[''] = '';

//    cipherMap[cast(char)26] = '\n';  IF WE KEEP NEWLINES
    cipherMap[cast(char)26] = ' '; // compressed mode
//    cipherMap['a'] = '\n';




    cipherMap[cast(char)23] = '\n'; //ANOTHER NEWLINE
	cipherMap[cast(char)91] = 'N';
//	cipherMap[cast(char)95] = 'k'; // i think, this was an encoded phrase kILL yam?

	bool[char] missing;

    // Read from stdin line by line
    foreach (line; stdin.byLine) {
        string input = line.idup; // Convert char[] to immutable string
        char[] decoded;
        // Process each character as ASCII
        foreach (char c; input) {
            // Apply the cipher mapping if the character is in the map, otherwise use '?'
            if (c in cipherMap) {
                decoded ~= cipherMap[c];
            } else {
				missing[c] = true; 
                decoded ~= '?';
                decoded ~= '[';
                decoded ~= c; //'?'; // Replace unmapped characters with '?'
                decoded ~= ']';
                decoded ~= format("%d", c); //'?'; // Replace unmapped characters with '?'
                decoded ~= '?';
            }
        }
        
    bool isASCIIx(const char c){
		if(c >= 32 && c <= 126)return true;
		return false; 
		}
	// Print the decoded line to console
	writeln(decoded);
	import std.algorithm, std.ascii;
	if(args.length > 1 && (args[1] == "-v" || args[1] == "--list")){
	foreach( c; missing.keys){
		if(!isASCIIx(c))writefln("cipherMap[cast(char)%d] = ''; \\\\ \'%s\'", c, c);
		else writefln("cipherMap[\'%s\'] = ''; \\\\ \'%d\'", c, c);
	}}
//		writef("[%d]=[%s],", c, c);	

    }
}
