doc.pdf:doc.mom enum.cs
	pdfmom -Kutf8 $< > $@
trab2.pdf:trab2.mom
	pdfmom -Kutf8 $< > $@
enum.cs:enum.cs.tt
	t4 $< -o=$@
	clip.exe < $@
	cat $@
