#include <stdio.h>

static int heading_level = 0;

%%{
    machine markdown;

    action print_escaping {
        if ('"' == fc)
	    putchar('\\');
	putchar(fc);
    }

    action heading_count { heading_level++; }
    action heading_start { printf(".HEADING %d \"", heading_level); }
    action heading_end { putchar('"'); heading_level = 0; }

    EOL = '\r'? '\n';

    heading = ('#'+ $heading_count
               ' '  @heading_start
	       any+ $print_escaping
	      ) :> EOL %heading_end;

    paragraph = (any - EOL)+ $print_escaping;

    #pure = (any - "*_") | "\*" | "\_";
    #italic = '*' any? '*';
    #bold = "**" any* "**";
    #code_inline = '`' any* '`';
    #code_block = "```" EOL (any+ EOL)? "```" EOL;
    #code = code_inline | code_block;
    corpus = (heading | paragraph) EOL;
    #markdown = ".MD" EOL corpus ".MD OFF";
    ignored = any*;
    #main := ignored (EOL markdown EOL)* ignored;

    # .ME is uses by an_ext.tmac, but no problem.
    #main := (any* -- ".MS" EOL) ".MD" EOL
    #        (markdown) ".ME" EOL;
    markdown = heading*;
    #main := ((any+ EOL)? :>> markdown)* :>> (EOL any*);
    #main := (any+ EOL)? :>> (".MS" EOL) markdown ".ME" any*;
    main := (def: any+ cr: '\r'? lf: '\n')? :>
    ('.' -> ms1 | 'M' 'S' EOL)
    markdown ".ME" any*,
    ms1: (
        'M' -> ms2 |
	('\r' -> cr |
	'\n' -> lf |
	[^M\r\n] -> def) @{ printf(".%c", fc); }
    )
    ms2: (
        'S' ->ms3 |
	('\r' ->cr |
	'\n' ->lf |
	[^S\r\f] -> def) @{ printf(".M%c", fc); }
    ),
    ms3: (
        '\r'? '\n' ->markdown | [^
    );
}%%

int main(void)
{
    return 0;
}
