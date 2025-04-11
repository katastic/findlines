# NOTE: newline backslash continue must be LAST letter (no tabs, spaces, etc!)
# grab strings
strings -f *.dat | \
# remove non-printable
tr -c "[:print:]" "\n" | \
# use sed equivalent of grep color match filename start of string but keep rest of it
sed 's/^[^:]*\([^:]*\)/\x1b[31m\0\x1b[39m/'  

# match format is start of string:             myfile.h:the rest of the string
#| grep -P ".*?:" --color
#  | sed 's/^[^:]*\([^:]*\)/\x1b[31m\0\x1b[39m/' courtesy of chatgpt
# or perl4 -pe 's/^([^:]*)(?=:)/\e[31m\1\e[39m/' 
