import std.file;
import std.stdio;
import std.string;

struct entry{
	long addr;
	short length;
}

entry readStringMeta(ubyte[] s){
	entry e;
	e.addr = s[0] + s[1]*256 - 1;// + s[2]*(256^^2) + s[3]*(256^^3); // FOR SOME REASON its -1. qbasic arrays start at 1, possibly!
	e.length = cast(short)(s[4] + s[5]*256); 
	writefln("%3s %3s %3s %3s, %3s %3s -- start: %s end: %s", s[0], s[1], s[2], s[3], s[4], s[5], s[1] + s[1]*256, e.addr + e.length);
	return e;
}

void main(string[] args) {
    
	
    // Define the substitution cipher mapping (ASCII chars)
    char[char] cipherMap;
    
	cipherMap['N'] = 'A';
	cipherMap['O'] = 'B';
	cipherMap['P'] = 'C';
	cipherMap['W'] = 'J';
	cipherMap['Z'] = 'M';
	cipherMap['\\'] = 'O';
	cipherMap['`'] = 'S';
	cipherMap['a'] = 'T';
	cipherMap['b'] = 'U';
	cipherMap['c'] = 'V';
	cipherMap['d'] = 'W';
	// e
	cipherMap['f'] = 'Y';
    cipherMap['g'] = 'Z'; // Zieg,  Zeug, Zu noch das Norge, Zehren
	// h, i, j, k, l, m
	cipherMap['n'] = 'a';
	cipherMap['o'] = 'b';
	cipherMap['p'] = 'c';
	cipherMap['q'] = 'd';
	cipherMap['r'] = 'e';
	cipherMap['s'] = 'f';
	cipherMap['t'] = 'g';
	cipherMap['u'] = 'h';
	cipherMap['v'] = 'i';
	cipherMap['w'] = 'j';
	cipherMap['x'] = 'k';
	cipherMap['y'] = 'l';
	cipherMap['z'] = 'm';
	cipherMap['{'] = 'n';
	cipherMap['|'] = 'o';
	cipherMap['}'] = 'p';
	cipherMap['4'] = '\'';
    cipherMap['5'] = '(';
    cipherMap['6'] = ')';
	cipherMap['7'] = '*';
	cipherMap['9'] = ',';
	cipherMap['<'] = 'A'; // A bonfire circle.
    cipherMap['~'] = 'q';
	cipherMap['['] = 'N';
    cipherMap[']'] = 'P'; // Fine Hamster? // "Releaves Pain"
    cipherMap['_'] = 'R'; // ROOM 
    cipherMap['-'] = ' ';
    cipherMap[';'] = '.';
    cipherMap[':'] = '-'; // run-down shack
    cipherMap['/'] = '"';
    cipherMap['.'] = '.';
    cipherMap['^'] = 'Q'; // i think
    cipherMap['>'] = '1'; //<------------
    cipherMap['?'] = '2'; // <----------??
    cipherMap['@'] = '3';
    cipherMap['='] = '0'; 
    cipherMap['A'] = '4';
    cipherMap['B'] = '5';    
    cipherMap['C'] = '6'; // gussed
    cipherMap['D'] = '7'; 
    cipherMap['E'] = '8'; 
    cipherMap['F'] = '9'; 
    cipherMap['G'] = ':';
	cipherMap['H'] = '\t'; // stinky congealed green sewage?[H]72?except it was stinkier.  Joe 
    cipherMap['L'] = '"'; // i think
    cipherMap['Q'] = 'D';
    cipherMap['R'] = 'E';
    cipherMap['S'] = 'F'; 
    cipherMap['T'] = 'G'; // ANGLE
    cipherMap['U'] = 'H'; // Fine Hamster
    cipherMap['V'] = 'I'; // i think
    cipherMap['X'] = 'K'; // Kennedy in lmtext.dat
    cipherMap['Y'] = 'L';
	// printable is 32 through 126 not including Extended ASCII
    cipherMap[cast(char)23] = '\n'; //ANOTHER NEWLINE
    cipherMap[cast(char)26] = '\n';  //IF WE KEEP NEWLINES.
	cipherMap[cast(char)27] = '/'; // Escape
	cipherMap[cast(char)127] = 'r'; // DEL or house in CP437
	cipherMap[cast(char)128] = 's'; // € placeholder
	cipherMap[cast(char)129] = 't'; // 
	cipherMap[cast(char)130] = 'u'; // ‚
	cipherMap[cast(char)131] = 'v'; // not specified, possibly 'ƒ'
	cipherMap[cast(char)132] = 'w'; // „
	cipherMap[cast(char)133] = 'x'; // …
	cipherMap[cast(char)134] = 'y'; // †
	cipherMap[cast(char)135] = 'z'; // ‡
	cipherMap[cast(char)136] = '4'; // ˆ
	cipherMap[cast(char)138] = '1'; // Š
	cipherMap[cast(char)139] = '3'; // ‹
	cipherMap[cast(char)140] = '6'; // Œ
	cipherMap[cast(char)144] = '5'; // 
	cipherMap[cast(char)145] = '0'; // ‘
	cipherMap[cast(char)148] = '6'; // ”
	cipherMap[cast(char)149] = '0'; // •
	cipherMap[cast(char)150] = '2'; // –
	cipherMap[cast(char)151] = '+'; // —
	cipherMap[cast(char)153] = '7'; // ™
	cipherMap[cast(char)154] = '_'; // š
	cipherMap[cast(char)155] = '#'; // ›
	cipherMap[cast(char)157] = '^'; // 
	cipherMap[cast(char)159] = ']'; // Ÿ
	cipherMap[cast(char)160] = '['; //  
	cipherMap[cast(char)161] = '1'; // ¡
	cipherMap[cast(char)162] = '1'; // ¢
	cipherMap[cast(char)163] = '5'; // £
	cipherMap[cast(char)164] = '2'; // ¤
	cipherMap[cast(char)167] = '2'; // §
	cipherMap[cast(char)169] = '7'; // ©
	cipherMap[cast(char)173] = '1'; // ­
	cipherMap[cast(char)174] = '4'; // ®
	cipherMap[cast(char)175] = '6'; // ¯
	cipherMap[cast(char)176] = '!'; // °
	cipherMap[cast(char)177] = '6'; // ±
	cipherMap[cast(char)179] = '3'; // ³
	cipherMap[cast(char)180] = '4'; // ´
	cipherMap[cast(char)181] = '4'; // µ
	cipherMap[cast(char)182] = '8'; // ¶
	cipherMap[cast(char)183] = ','; // ·
	cipherMap[cast(char)184] = '.'; // ¸
	cipherMap[cast(char)185] = '6'; // ¹
	cipherMap[cast(char)188] = '*'; // ¼
	cipherMap[cast(char)191] = '%'; // ¿
	cipherMap[cast(char)192] = '&'; // À
	cipherMap[cast(char)193] = ','; // Á
	cipherMap[cast(char)194] = '0'; // Â
	cipherMap[cast(char)195] = '1'; // Ã
	cipherMap[cast(char)196] = '5'; // Ä
	cipherMap[cast(char)197] = '3'; // Å
	cipherMap[cast(char)198] = '3'; // Æ
	cipherMap[cast(char)199] = '3'; // Ç
	cipherMap[cast(char)203] = '7'; // Ë
	cipherMap[cast(char)204] = '8'; // Ì
	cipherMap[cast(char)205] = '5'; // Í
	cipherMap[cast(char)208] = '2'; // Ð
	cipherMap[cast(char)211] = '4'; // Ó
	cipherMap[cast(char)212] = '5'; // Ô
	cipherMap[cast(char)214] = '8'; // Ö
	cipherMap[cast(char)215] = '2'; // ×
	cipherMap[cast(char)216] = '1'; // Ø
	cipherMap[cast(char)217] = '7'; // Ù
	cipherMap[cast(char)218] = '4'; // Ú
	cipherMap[cast(char)219] = '1'; // Û
	cipherMap[cast(char)220] = '4'; // Ü
	cipherMap[cast(char)221] = '5'; // Ý
	cipherMap[cast(char)222] = '('; // Þ
	cipherMap[cast(char)223] = '0'; // ß
	cipherMap[cast(char)225] = '$'; // á
	cipherMap[cast(char)226] = ')'; // â
	cipherMap[cast(char)227] = '2'; // ã
	cipherMap[cast(char)229] = '3'; // å
	cipherMap[cast(char)231] = '0'; // ç
	cipherMap[cast(char)232] = '6'; // è
	cipherMap[cast(char)234] = '7'; // ê
	cipherMap[cast(char)235] = '8'; // ë
	cipherMap[cast(char)237] = '1'; // í
	cipherMap[cast(char)240] = '7'; // ð
	cipherMap[cast(char)241] = '1'; // ñ
	cipherMap[cast(char)244] = '5'; // ô
	cipherMap[cast(char)245] = '2'; // õ
	cipherMap[cast(char)247] = '8'; // ÷
	cipherMap[cast(char)248] = '8'; // ø
	cipherMap[cast(char)249] = '2'; // ù
	cipherMap[cast(char)250] = ','; // ú
	cipherMap[cast(char)252] = '3'; // ü 
	cipherMap[cast(char)254] = '3'; // þ    
	bool[char] missing;
    
//	cipherMap[cast(char)95] = 'k'; // i think, this was an encoded phrase kILL yam?

	string decode(const char[] str){
		string output;
		foreach(c; str){
			if (c in cipherMap) {
                output ~= cipherMap[c];
            } else {
				missing[c] = true; 
   			}
		}
			
		return output;
		}

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
