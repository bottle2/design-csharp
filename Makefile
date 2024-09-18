doc.pdf:doc.mom enum.cs
	pdfmom -Kutf8 $< > $@
trab2.pdf:trab2.mom
	pdfmom -Kutf8 $< > $@
serialization.cs:serialization.cs.tt
	t4 $< -o=$@
	clip.exe < $@
	cat $@
