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

# GAPDoc renders <Table> as a `tabular` inside a `center` environment, which
# LaTeX cannot break across pages. Render it as a `longtable` instead, which
# splits automatically; this way long tables need not be split by hand, which
# would look bad in the HTML and text versions of the manual.
GAPDoc2LaTeXProcs.Table := function(r, str)
  local cap, rows, pos;
  if (IsBound(r.attributes.Only) and r.attributes.Only <> "LaTeX") or
     (IsBound(r.attributes.Not) and r.attributes.Not = "LaTeX") then
    return;
  fi;
  if IsBound(r.attributes.Label) then
    Append(str, Concatenation("\\mbox{}\\label{", r.attributes.Label, "}"));
  fi;
  Append(str, Concatenation("\n\n\\begin{longtable}{", r.attributes.Align, "}\n"));
  # everything up to the first horizontal line, if any, becomes the table
  # header, which longtable then repeats on every page the table spans
  rows := "";
  GAPDoc2LaTeXContent(r, rows);
  pos := PositionSublist(rows, "\\hline\n");
  if pos <> fail then
    rows := Concatenation(rows{[1 .. pos + 6]}, "\\endhead\n",
                          rows{[pos + 7 .. Length(rows)]});
  fi;
  Append(str, rows);
  Append(str, "\\end{longtable}\n\n");
  cap := Filtered(r.content, a -> a.name = "Caption");
  if Length(cap) > 0 then
    Append(str, "\\begin{center}\n");
    GAPDoc2LaTeXProcs.Caption1(cap[1], str);
    Append(str, "\\end{center}\n\n");
  fi;
end;

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
