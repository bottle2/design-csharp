TRAB2_CODE=Enum.cs Enum.cs.tt EnumTypesafe.cs Enum.java

doc.pdf:doc.mom enum.cs
	pdfmom -Kutf8 $< > $@
trab2.pdf:trab2.mom $(TRAB2_CODE)
	pdfmom -Kutf8 $< > $@
Enum.cs:Enum.cs.tt
	sed '/^\./d' $< | t4 -o=$@
	#t4 $< -o=$@
	clip.exe < $@
	cat $@
