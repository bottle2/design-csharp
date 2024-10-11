#include <stdbool.h>
#include <stdio.h>

static int heading_level = 0;

%%{
    machine markdown;
    alphtype unsigned char;

    action print_escaping {
        if ('"' == fc)
	    putchar('\\');
	putchar(fc);
    }

    action heading_count { heading_level++; }
    action heading_start { printf(".HEADING %d \"", heading_level); }
    action heading_end { putchar('"'); heading_level = 0; }

    EOL = '\n' | "\r\n"; # | '\r'; The three horsemen.
    # TODO I don't want to care about macOS users right now.
    # For now, I think mixed line endings will work.

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
    #markdown = heading*;
    #main := ((any+ EOL)? :>> markdown)* :>> (EOL any*);
    #main := (any+ EOL)? :>> (".MS" EOL) markdown ".ME" any*;
    #main := (def: any+ cr: '\r'? lf: '\n')? :>
    #('.' -> ms1 | 'M' 'S' EOL)
    #markdown ".ME" any*,
    #ms1: (
    #    'M' -> ms2 |
    #    ('\r' -> cr |
    #    '\n' -> lf |
    #    [^M\r\n] -> def) @{ printf(".%c", fc); }
    #)
    #ms2: (
    #    'S' ->ms3 |
    #    ('\r' ->cr |
    #    '\n' ->lf |
    #    [^S\r\f] -> def) @{ printf(".M%c", fc); }
    #),
    #ms3: (
    #    '\r'? '\n' ->markdown | [^
    #);

    action copy { putchar(fc); }
    action wdot { putchar('.'); }
    action wm { printf(".M"); }
    action ws { printf(".MS"); }
    action we { printf(".ME"); }

    main :=
    start: ('.' ->ms1 | EOL $copy ->start | [^\r\n.] $copy ->ignore),
    ignore:          (EOL $copy ->start | [^\r\n] $copy ->ignore),
    ms1: ('M' ->ms2 | EOL >wdot $copy ->start | [^M\r\n] >wdot $copy ->ignore),
    ms2: ('S' ->ms3 | EOL >wm $copy ->start | [^S\r\n] >wm $copy ->ignore),
    ms3:             (EOL ->markdown_beg | [^\r\n] >ws $copy ->ignore),
    markdown_beg: (EOL $copy ->markdown_beg | '.' ->ms4 | [^.\r\n] ->markdown_mid),
    markdown_mid: (EOL ->markdown_beg | [^\r\n] ->markdown_mid),
    ms4: ('M' ->ms5 | EOL ->markdown_beg | [^M\r\n] ->markdown_mid),
    ms5: ('E' ->ms6 | EOL ->markdown_beg | [^E\r\n] ->markdown_mid),
    ms6: (EOL ->start | [^\r\n] ->markdown_mid);
}%%

%% write data noerror nofinal noentry;

int main(void)
{
    int cs;
    %% write init;
    for (int c; (c = getchar()) != EOF; )
    {
        unsigned char *p = &(unsigned char){c};
        unsigned char *pe = p + 1;
        %% write exec;
    }
    return 0;
}
