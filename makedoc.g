if fail = LoadPackage("AutoDoc", "2019.07.24") then
    Error("AutoDoc version 2019.07.24 or newer is required.");
fi;

AutoDoc(rec(gapdoc:=rec(scan_dirs:=["doc/gapdoc","lib"])));
