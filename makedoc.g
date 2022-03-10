if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;

AutoDoc("simpcomp",rec(gapdoc:=rec(scan_dirs:=["doc/gapdoc"])));
