doc.pdf:doc.mom enum.cs
	pdfmom -Kutf8 $< > $@
enum.cs:enum.cs.t4
	t4 $< -o=$@
	clip.exe < $@
