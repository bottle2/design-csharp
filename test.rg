%%{
    machine test;
    main :=
    start: (("abc" | "d") ->mid | "def" ->final),
    mid: "def" ->final;
}%%
