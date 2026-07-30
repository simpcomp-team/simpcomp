if fail = LoadPackage("AutoDoc", "2019.07.24") then
    Error("AutoDoc version 2019.07.24 or newer is required.");
fi;

# We use \dtimes for the twisted product (e.g. in "S^2 \dtimes S^1"): a
# multiplication sign whose two lower arms are joined by a bar. It used to be
# taken from the MnSymbol package, but that is not part of a minimal TeX
# installation, and it is unknown to MathJax anyway. So we provide it
# ourselves, in each of the three output formats:
#  - for LaTeX by rotating \ltimes from amssymb (see LateExtraPreamble below),
#  - for the MathJax based HTML manual likewise, by rotating \ltimes via CSS
#    (note that MathJax 2 spells the macro \style, not \htmlStyle, and that
#    CSS rotates clockwise, hence -90deg where LaTeX uses 90),
#  - for the text and plain HTML manuals via the closest Unicode character,
#    U+2A31 MULTIPLICATION SIGN WITH UNDERBAR.
TEXTMTRANSLATIONS.dtimes := "⨱";
GAPDoc2HTMLProcs.Head1MathJax := ReplacedString(
    GAPDoc2HTMLProcs.Head1MathJax,
    "<head>\n",
    """<head>
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({TeX: {Macros: {dtimes: [
    "\\require{HTML}\\mathbin{\\style{display:inline-block;transform:rotate(-90deg)}{\\ltimes}}", 0]}}});
</script>
""");

AutoDoc(rec(
    gapdoc := rec(
        LaTeXOptions := rec(
            Options := "11pt",
            LateExtraPreamble :=
                """
                \usepackage{amsmath}
                %\usepackage{lmodern}
                \usepackage{graphicx}
                \usepackage{longtable}
                \newcommand{\dtimes}{\mathbin{\rotatebox[origin=c]{90}{$\ltimes$}}}
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
