import std.ascii;
import std.string;
import std.stdio;
import std.file;
import std.conv;


// names.dat 		ROT+5!!!
// book.dat 		ROT+13
// talk.dat 		+13
// rooomtext.dat 	13
// gina.dat 		13
// talkme.dat		ZERO!!
// lmtext.dat		13
// idemtext.dat		13

void main(string[] args) {
    // Check for correct number of command-line arguments
    if (args.length != 3) {
        writeln("Usage: ", args[0], " <input_file> <rot#>");
        return;
    }

    string inputFile = args[1];

    try {
        // Read the entire input file as a string
    ubyte[] data = cast(ubyte[]) read(inputFile);

        // Process each character and rotate letters by -13
        foreach (c; data) {
                write(cast(char)(c - to!int(args[2])));
        }

    } catch (FileException e) {
        writeln("Error accessing file: ", e.msg);
    } catch (Exception e) {
        writeln("Error: ", e.msg);
    }
}
