#include <stdbool.h>
#include <stdio.h>

static int heading_level = 0;

static unsigned char buffer[1000] = {0};
static int buffer_len = 0;

%%{
    machine common;
    alphtype unsigned char;

    EOL = '\n' | "\r\n";
    # TODO I'm not caring about macOS users right now...

    action copy { putchar(fc); }
}%%

%%{
    machine section;
    alphtype unsigned char;

    include common;

    action wdot { putchar('.'); }
    action wm { printf(".M"); }
    action ws { printf(".MS"); }

    action init { md_init(); }
    action end { md_end(); }
    action pdot { md_push('.'); }
    action pm { md_push('.'); md_push('M'); }
    action pe { md_push('.'); md_push('M'); md_push('E'); }
    action pfc { md_push(fc); }

    main :=
    start: ('.' ->ms1 | (EOL ->start | [^.\r\n] ->ignore)       $copy),
    ignore:             (EOL ->start |  [^\r\n] ->ignore)       $copy,
    ms1:   ('M' ->ms2 | (EOL ->start | [^M\r\n] ->ignore) >wdot $copy),
    ms2:   ('S' ->ms3 | (EOL ->start | [^S\r\n] ->ignore) >wm   $copy),
    ms3:             (EOL %init ->markdown_beg | [^\r\n] >ws $copy ->ignore),
    markdown_beg: ('.' ->ms4 | (EOL ->markdown_beg | [^.\r\n] ->markdown_mid) $pfc),
    markdown_mid:     (EOL ->markdown_beg |  [^\r\n] ->markdown_mid)       $pfc,
    ms4: ('M' ->ms5 | (EOL ->markdown_beg | [^M\r\n] ->markdown_mid) >pdot $pfc),
    ms5: ('E' ->ms6 | (EOL ->markdown_beg | [^E\r\n] ->markdown_mid) >pm   $pfc),
    ms6: (EOL %end ->start | [^\r\n] >pe $pfc ->markdown_mid);

    # XXX I really want to rename everything.
    # Why is this so ugly.

    write data noerror nofinal noentry;
}%%

%%{
    machine markdown;
    alphtype unsigned char;
    variable cs md_cs;

    include common;

    action print_escaping {
        if ('"' == fc)
	    putchar('\\');
	putchar(fc);
    }

    action heading_count { heading_level++; }
    action heading_start { printf(".HEADING %d \"", heading_level); }
    action heading_end { putchar('"'); heading_level = 0; }

    heading = ('#'{1,6} $heading_count
               ' '      @heading_start
	       any+     $print_escaping
	      ) :> EOL %heading_end;

    action do_i { printf("\\fI"); }
    action do_b { printf("\\fB"); }
    action prev { printf("\\fP"); }
    action code_on  { printf("\\*[CODE]"); }
    action code_off { printf("\\*[CODE X]"); }

    action backslash { putchar('\\'); }

    asterisk_span = ([^*\\\r\n] $copy | ('\\' ('*' | [^*\r\n] @backslash) @copy))+;

    italic = ('*'  asterisk_span >do_i '*' ) %prev;
    bold   = ("**" asterisk_span >do_b "**") %prev;

    icode  = ('`' [^`\r\n]+ $copy '`') >code_on @code_off;

    formatted = bold | italic | icode
              | ([^`*\\\r\n] $copy | ('\\' ([`*] | [^`*\r\n] @backslash) @copy))+;

    action zero { buffer[0] = '\0'; buffer_len = 0; }
    action buf { buffer[buffer_len++] = fc; buffer[buffer_len] = '\0'; }

    # XXX I quit here. Fuck. What about the PREFIX option of .PDF_LINK ?

    ilink = '[' @zero [^\r\n\]] $buf "](" [^\r\n)];

    # TODO link, and... headings and lists?
    # TODO multi-line italic, bold and inline code?

    action pp { puts(".PP"); }

    paragraph = (formatted+ EOL $copy)+ >pp;

    paragraphs = paragraph (EOL+ paragraph)*;

    main := EOL* paragraphs? EOL*;

    write data noerror nofinal noentry;
}%%

static int md_cs;

static void md_exec(unsigned char *p, unsigned char *pe)
{
    unsigned char *eof = NULL;
    (void)eof;
    %% write exec;
}

static void md_init(void)            { %%{ write init; }%%  }
static void md_push(unsigned char c) { md_exec(&c, &c + 1); }
static void md_end (void)            { md_exec(NULL, NULL); }

int main(void)
{
    int cs;
    %% machine section;
    %% write init;
    for (int c; (c = getchar()) != EOF; )
    {
        unsigned char *p = &(unsigned char){c};
        unsigned char *pe = p + 1;
        %% write exec;
    }
    return 0;
}
