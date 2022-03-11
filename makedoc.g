if fail = LoadPackage("AutoDoc", "2019.07.24") then
    Error("AutoDoc version 2019.07.24 or newer is required.");
fi;

AutoDoc(rec(
    gapdoc := rec(
        scan_dirs := ["./doc/gapdoc"],
        LaTeXOptions := rec(
            Options := "11pt",
            LateExtraPreamble :=
                """
                \usepackage{amsmath}
                %\usepackage{lmodern}
                \usepackage{graphicx}
                \usepackage{MnSymbol}
                \usepackage{longtable}
                \definecolor{FuncColor}{rgb}{0.0,0.0,0.0}
                \definecolor{RoyalGreen}{rgb}{0.0,0.0,0.0}
                \definecolor{RoyalRed}{rgb}{0.0,0.0,0.0}
                \definecolor{RoyalBlue}{rgb}{0.0,0.0,0.0}
                \definecolor{LightBlue}{rgb}{0.0,0.0,0.0}
                \definecolor{Chapter }{rgb}{0.0,0.0,0.0}
                """,
        ),
    ),
    scaffold := rec(
        TitlePage := false,
        includes := [
            "howto.xml",
            "theory.xml",
            "functions.xml",
            "demo.xml",
            "internals.xml",
        ],
        bib := "biblio", 
    ),
));
