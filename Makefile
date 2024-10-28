TRAB1_CODE=NextAfter.cs GeoJson.cs
TRAB2_CODE=Enum.cs Enum.cs.tt EnumTypesafe.cs Enum.java

all:doc.pdf trab2.pdf

doc.pdf:doc.mom $(TRAB1_CODE)
	pdfmom -Kutf8 $< > $@
trab2.pdf:trab2.mom $(TRAB2_CODE)
	pdfmom -Kutf8 $< > $@
Enum.cs:Enum.cs.tt
	sed '/^\./d' $< | t4 -o=$@
	#t4 $< -o=$@
	clip.exe < $@
	cat $@

CFLAGS=-std=c18 -Wpedantic -Wall -Wextra -g3 -fsanitize=address,undefined

mdmom:mdmom.c

mdmom.c:mdmom.rg
	ragel -G2 $<
