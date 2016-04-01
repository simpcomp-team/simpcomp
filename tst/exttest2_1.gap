# test
fl:=[];
n:=SCLibSize(SCLib);
for i in [1..n] do
  c:=SCLib.Load(i);
  if SCHasBoundary(c) then continue; fi;
  isM:=SCIsManifold(c);
  f:=SCFVector(c);
  hom:=SCHomology(c);
  Print(i,": ",SCName(c),"\n");
  d:=SC(SCFacets(c));
  e:=SC(SCFacets(c));
  g:=SC(SCFacets(c));

  tmp:=SCHomology(d);
  if not tmp = hom then
    Error("hom: ",hom," <> ",tmp,"\n");
  fi;
  
  tmp:=SCIsManifold(d);
  if not tmp = isM then
    Error("isM: ",isM," <> ",tmp,"\n");
  fi;

  tmp:=SCFVector(e);
  if not tmp = f then
    Error("F: ",f," <> ",tmp,"\n");
  fi;

  if isM <> false then
    tmp:=SCBistellarIsManifold(e);
    if not tmp = isM then
      Error("bIsM: ",isM," <> ",tmp,"\n");
    fi;
  fi;

  Print("engstroem: \t",SCMorseSpec(g,10,SCMorseEngstroem),"\n");
  Print("UST: \t\t",SCMorseSpec(g,10,SCMorseUST),"\n");
  Print("random: \t",SCMorseSpec(g,10,SCMorseRandom),"\n");
  Print("randomlex: \t",SCMorseSpec(g,10,SCMorseRandomLex),"\n");
  Print("randomrevlex: \t",SCMorseSpec(g,10,SCMorseRandomRevLex),"\n\n");

od;
