################################################################################
##
##  simpcomp / DMT.gi
##
##  Functions for discrete Morse theory, manifold recognition 
##  and simply connectivity testing
##
##  $Id$
##
################################################################################

################################################################################
##<#GAPDoc Label="SCHasseDiagram">
## <ManSection>
## <Func Name="SCHasseDiagram" Arg="c"/>
## <Returns>two lists of lists upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes the Hasse diagram of <C>SCSimplicialComplex</C> object 
## <Arg>c</Arg>. The Hasse diagram is returned as two sets of lists. The first
## set of lists contains the upward part of the Hasse diagram, the second
## set of lists contains the downward part of the Hasse diagram.
## <P/>
## The <M>i</M>-th list of each set of lists represents the incidences between
## the <M>(i-1)</M>-faces and the <M>i</M>-faces. The faces are given by their 
## indices of the face lattice.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> HD:=SCHasseDiagram(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHasseDiagram,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)
  local downward, upward, i, j, k, base, idx, d, fl;

  fl := SCFaceLatticeEx(c);
  if fl = fail then
    return fail;
  fi;

  upward:=[];
  downward:=[];
  for i in [1..Size(fl)-1] do
    upward[i]:=List([1..Size(fl[i])],x->[]);
    downward[i]:=List([1..Size(fl[i+1])],x->[]);
  od;

  for k in [2..Size(fl)] do
    d:=Size(fl[k][1]);
    idx:=[];  
    for i in [1..d] do
      idx[i]:=[1..d];
      Remove(idx[i],i);
    od;
    for i in [1..Size(fl[k])] do
      for j in [1..d] do
        base:=fl[k][i]{idx[j]};
        Add(upward[k-1][PositionSorted(fl[k-1],base)],i);
        Add(downward[k-1][i],PositionSorted(fl[k-1],base));
      od;
    od;
  od;
  return [upward,downward];
end);

#########################################################
### Three methods to compute discrete Morse functions ###
#########################################################

SCIntFunc.SCMorseEngstroemEx:=function(c,missing)
  local f, cone, dl, ll, size, v, face, i, critical, tmp,
    SCMorseEngstroemEx, SCNumCells, SCLinkLat, SCDelLat,
    SCStarLat,SCMinLink,SCIsCone,SCLexo,SCMorseCone;

  critical:=[];

  SCNumCells:=function(c)
    # don't forget to include emptyset
    return Sum(List(c,x->Size(x)))+1;
  end;

  SCLinkLat:=function(c,v)
    local count, j, i, ii, linklat, idx, temp, cc;
  
    linklat:=[];
    for i in [2..Size(c)] do
      linklat[i-1]:=[];
      count:=0;
      temp:=[];
      for ii in c[i] do
        idx:=Position(ii,v);
        if idx = fail then continue; fi;
        cc:=ShallowCopy(ii);
        Remove(cc,idx);
        Add(linklat[i-1],cc);
      od;
    od;
    if [] in linklat then
      linklat:=Difference(linklat,[[]]);
    fi;
    return linklat;
  end;


  SCDelLat:=function(c,v)
    local l;
    l:=List(c,y->Filtered(y,x->not v in x));
    if [] in l then
      l:=Difference(l,[[]]);
    fi;
    return l; 
  end;


  SCStarLat:=function(c,v)
    local l;
    l:=List(c,y->Filtered(y,x->v in x));
    if [] in l then
      l:=Difference(l,[[]]);
    fi;
    return l;
  end;


  SCMinLink:=function(c)
    local minlink,minsize,v;

    minlink:=c[1][1][1];
    minsize:=SCNumCells(SCLinkLat(c,minlink));
    for v in c[1] do
      if SCNumCells(SCLinkLat(c,v[1]))<minsize then
        minlink:=v[1];
        minsize:=SCNumCells(SCLinkLat(c,v[1]));
      fi;
    od;
    return minlink;
  end;

  SCIsCone:=function(c)
    local v,size;
    size:=SCNumCells(c);
    for v in c[1] do
      if 2*(SCNumCells(SCLinkLat(c,v[1])))=size then
        return v[1];
        fi;
    od;
    return false;
  end;
  
  SCLexo:=function(c,cell)
    local pos;
    if cell = [] then return 1; fi;
  
    pos:=Position(c[Size(cell)],cell);
    if pos = fail then
      return fail;
    fi;
    return SCNumCells(c{[1..Size(cell)-1]})+pos;
  end;

  SCMorseCone:=function(c)
    local v,dl,i,face,f,half,ctr;
    f:=[];
    v:=SCIsCone(c);
    if v = false then
      return fail;
    fi;
    dl:=SCDelLat(c,v);
    half:=SCNumCells(dl);
    f[1]:=[v];
    f[half+1]:=[];
    ctr:=1;  
    for i in [1..Size(dl)] do
      for face in dl[i] do
        ctr:=ctr+1;
        f[ctr]:=Union(face,[v]);
        f[ctr+half]:=face;
      od;
    od;
    
    return f;
  end;

  if c = [] then 
    if missing <> [] then 
      Add(critical,missing);
    fi;
    return [[missing],critical];
  fi;

  f:=[];
  cone:=SCIsCone(c);
  # c is a cone
  if cone <> false then
    f:=SCMorseCone(c);
    return [List(f,x->Union(x,missing)),critical]; 
  fi;
  
  # c is not a cone  
  v:=SCMinLink(c);
  ll:=SCLinkLat(c,v);
  dl:=SCDelLat(c,v);
  size:=SCNumCells(dl)-1;

  tmp:=SCIntFunc.SCMorseEngstroemEx(dl,missing);
  f{[1..size+1]}:=tmp[1];
  Append(critical,tmp[2]);
  tmp:=SCIntFunc.SCMorseEngstroemEx(ll,Union(missing,[v]));
  f{[size+2..size+SCNumCells(ll)+1]}:=tmp[1];
  Append(critical,tmp[2]);
  
  return [List(f,x->Union(x,missing)),critical]; 
end;

################################################################################
##<#GAPDoc Label="SCMorseEngstroem">
## <ManSection>
## <Func Name="SCMorseEngstroem" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following the Engstroem method by reducing 
## the input complex to smaller complexes defined by minimal link and deletion 
## operations. See <Cite Key="Engstroem09DiscMorseFuncFourierTrans" /> for 
## details.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> f:=SCMorseEngstroem(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseEngstroem,
function(cc)
  local c,tmp,critical,SCMorseEngstroemEx;
  c:=SCFaceLattice(cc);
  tmp:=SCIntFunc.SCMorseEngstroemEx(c,[]);
  critical:=[tmp[1][1]];
  Append(critical,tmp[2]);
  return [tmp[1],critical];
end);


SCIntFunc.morseRandom:=function(cc,mode,coll)
  local fl,i,j,iii,free,r,R,upward,downward,Morse,critical,pairedFace,
    available,tmp,pos,remainder,start;

  tmp:=SCHasseDiagram(cc);
  fl:=SCFaceLattice(cc);
  upward:=SCIntFunc.DeepCopy(tmp[1]);
  downward:=SCIntFunc.DeepCopy(tmp[2]);
  available:=List([1..Size(fl)],i->[1..Size(fl[i])]);
  Morse:=[];
  critical:=[];

  for iii in Reversed([1..(Size(fl)-1)]) do
    free:=[];
    for i in [1..Size(upward[iii])] do
      if Size(upward[iii][i]) = 1 then
        Add(free,i);
      fi;
    od;
    while available[iii+1] <> [] do
      if free=[] then
        # if in collapsibility mode this should not happen
        if coll then
          # build remaining complex
          remainder:=[];
          for j in [1..iii+1] do
            for i in available[j] do
              if j > Size(upward) or upward[j][i] = [] then
                Add(remainder,fl[j][i]);
              fi;
            od;
          od;
          return SC(remainder);
        fi;
        if mode = 0 then
          r:=RandomList(available[iii+1]);
          Remove(available[iii+1],Position(available[iii+1],r));
        elif mode = 1 then
          r:=available[iii+1][1];
          Remove(available[iii+1],1);
        elif mode = 2 then
          r:=available[iii+1][Size(available[iii+1])];
          Remove(available[iii+1],Size(available[iii+1]));
        fi;
        R:=downward[iii][r];
        # update upward Hasse diagram
        for i in R do
          Remove(upward[iii][i],Position(upward[iii][i],r));
          if Size(upward[iii][i]) = 1 then
            Add(free,i);
          fi;
        od;
        # keep track of Morse function
        Add(Morse,fl[iii+1][r]);
        Add(critical,fl[iii+1][r]);
      else
        if mode = 0 then
          r:=RandomList(free);
          Remove(free,Position(free,r));
        elif mode = 1 then
          r:=free[1];
          Remove(free,1);
        elif mode = 2 then
          r:=free[Size(free)];
          Remove(free,Size(free));
        fi;
        pairedFace:=upward[iii][r][1];
        # keep track of Morse function
        Add(Morse,fl[iii][r]);
        Add(Morse,fl[iii+1][pairedFace]);
        Remove(available[iii],Position(available[iii],r));
        Remove(available[iii+1],Position(available[iii+1],pairedFace));
        R:=downward[iii][pairedFace];
        # update upward Hasse diagram
        for i in R do
          Remove(upward[iii][i],Position(upward[iii][i],pairedFace));
          if Size(upward[iii][i]) = 1 then
            Add(free,i);
          elif Size(upward[iii][i]) = 0 then
            pos:=Position(free,i);
            if pos <> fail then
              Remove(free,pos);
            fi;
          fi;
        od;
        if iii > 1 then
          R:=downward[iii-1][r];
        else
          R:=[];
        fi;
        for i in R do
          Remove(upward[iii-1][i],Position(upward[iii-1][i],r));
        od;
      fi;
    od;
  od;
  for i in available[1] do
    Add(Morse,fl[1][i]);
    Add(critical,fl[1][i]);
  od;
  Morse:=Reversed(Morse);
  if coll then
    return SC(critical);
  else
    return [Morse,critical];
  fi;
end;


################################################################################
##<#GAPDoc Label="SCMorseRandom">
## <ManSection>
## <Func Name="SCMorseRandom" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following Lutz and Benedetti's random
## discrete Morse theory approach: Faces are paired with free co-dimension one 
## faces until now free faces remain. Then a critical face is removed at random.
## See <Cite Key="Benedetti13RandomDMT" /> for details.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> f:=SCMorseRandom(c);;
## gap> Size(f[2]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseRandom,
function(cc)
    return SCIntFunc.morseRandom(cc,0,false);
end);


################################################################################
##<#GAPDoc Label="SCMorseRandomLex">
## <ManSection>
## <Func Name="SCMorseRandomLex" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following Adiprasito, Benedetti and Lutz' 
## lexicographic random
## discrete Morse theory approach. See <Cite Key="Benedetti13RandomDMT" />, 
## <Cite Key="Adiprasito14RDMTII" /> for details.
## <Example><![CDATA[
## gap> c := SCSurface(3,true);;
## gap> f:=SCMorseRandomLex(c);;
## gap> Size(f[2]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseRandomLex,
function(cc)
    local verts,sh,morse;

    verts:=SCVertices(cc);
    sh:=Shuffle(SCIntFunc.DeepCopy(SCVertices(cc)));
    SCRelabel(cc,sh);
    # delete old Hasse diagram
    cc:=SC(SCFacets(cc));
    morse:=SCIntFunc.morseRandom(cc,1,false);
    SCRelabel(cc,verts);

    return morse;
end);


################################################################################
##<#GAPDoc Label="SCMorseRandomRevLex">
## <ManSection>
## <Func Name="SCMorseRandomRevLex" Arg="complex"/>
## <Returns>two lists of small integer lists upon success, <C>fail</C> 
## otherweise.</Returns>
## <Description>
## Builds a discrete Morse function following Adiprasito, Benedetti and Lutz' 
## reverse lexicographic random
## discrete Morse theory approach. See <Cite Key="Benedetti13RandomDMT" />, 
## <Cite Key="Adiprasito14RDMTII" /> for details.
## <Example><![CDATA[
## gap> c := SCSurface(5,false);;
## gap> f:=SCMorseRandomRevLex(c);;
## gap> Size(f[2]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseRandomRevLex,
function(cc)
    local verts,sh,morse;
  
    verts:=SCVertices(cc);
    sh:=Shuffle(ShallowCopy(SCVertices(cc)));
    SCRelabel(cc,sh);
    # delete old Hasse diagram
    cc:=SC(SCFacets(cc));
    morse:=SCIntFunc.morseRandom(cc,2,false);
    SCRelabel(cc,verts);

    return morse;

end);


SCIntFunc.SCMorseVec:=function(critical)
  local f, elm, max;

  max:=Maximum(List(critical,x->Size(x)));
  f:=List([1..max],x->0);

  for elm in critical do
    f[Size(elm)]:=f[Size(elm)]+1;
  od;
  return f;
end;


################################################################################
##<#GAPDoc Label="SCCollapseGreedy">
## <ManSection>
## <Meth Name="SCCollapseGreedy" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm to collapse the simplicial complex 
## <Arg>complex</Arg>. 
## See also <Ref Meth="SCCollapseLex" /> and <Ref Meth="SCCollapseRevLex" />.
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]}; 
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], 
##   [ 10, "T^2 (VT)" ], [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> bdtorus:=SCDifference(torus,SC([torus.Facets[1]]));;
## gap> coll:=SCCollapseGreedy(bdtorus);
## gap> coll.Facets;
## [ [ 3, 6 ], [ 3, 7 ], [ 5, 6 ], [ 5, 7 ], [ 6, 7 ] ]
## gap> sphere:=SCBdSimplex(4);;                              
## gap> bdsphere:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap> coll:=SCCollapseGreedy(bdsphere);
## gap> coll.Facets;                     
## [ [ 5 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCollapseGreedy,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
  local coll;
  coll:=SCIntFunc.morseRandom(complex,0,true);
  if(SCName(complex)<>fail) then
    SCRename(coll,Concatenation("collapsed version of ",SCName(complex)));
  fi;
  if SCDim(coll) = 0 and SCFVector(coll) = [1] then
    SetSCIsCollapsible(complex,true);
  fi;
  return coll;
end);


################################################################################
##<#GAPDoc Label="SCCollapseLex">
## <ManSection>
## <Meth Name="SCCollapseLex" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm in lexicographical order to collapse 
## the simplicial complex <Arg>complex</Arg>. See also 
## <Ref Meth="SCCollapseGreedy" /> and <Ref Meth="SCCollapseRevLex" />.
## <Example><![CDATA[
## gap> s:=SCSurface(1,true);;
## gap> s:=SCDifference(s,SC([SCFacets(s)[1]]));;
## gap> coll:=SCCollapseGreedy(s);
## gap> coll.Facets;
## gap> sphere:=SCBdSimplex(4);;                              
## gap> ball:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap> coll:=SCCollapseLex(ball);
## gap> coll.Facets;                     
## [ [ 5 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCollapseLex,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
  local coll;
  coll:=SCIntFunc.morseRandom(complex,1,true);
  if(SCName(complex)<>fail) then
    SCRename(coll,Concatenation("collapsed version of ",SCName(complex)));
  fi;
  if SCDim(coll) = 0 and SCFVector(coll) = [1] then
    SetSCIsCollapsible(complex,true);
  fi;
  return coll;
end);


################################################################################
##<#GAPDoc Label="SCCollapseRevLex">
## <ManSection>
## <Meth Name="SCCollapseRevLex" Arg="complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## Employs a greedy collapsing algorithm in reverse lexicographical order to 
## collapse the simplicial complex <Arg>complex</Arg>. 
## See also <Ref Meth="SCCollapseGreedy" /> and <Ref Meth="SCCollapseLex" />.
## <Example><![CDATA[
## gap> s:=SCSurface(1,true);;
## gap> s:=SCDifference(s,SC([SCFacets(s)[1]]));;
## gap> coll:=SCCollapseGreedy(s);
## gap> coll.Facets;
## gap> sphere:=SCBdSimplex(4);;                              
## gap> ball:=SCDifference(sphere,SC([sphere.Facets[1]]));;
## gap> coll:=SCCollapseRevLex(ball);
## gap> coll.Facets;                     
## [ [ 5 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCollapseRevLex,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
  local coll;
  coll:=SCIntFunc.morseRandom(complex,2,true);
  if(SCName(complex)<>fail) then
    SCRename(coll,Concatenation("collapsed version of ",SCName(complex)));
  fi;
  if SCDim(coll) = 0 and SCFVector(coll) = [1] then
    SetSCIsCollapsible(complex,true);
  fi;
  return coll;
end);



################################################################################
##<#GAPDoc Label="SCMorseUST">
## <ManSection>
## <Func Name="SCMorseUST" Arg="complex"/>
## <Returns>a random Morse function of a simplicial complex and a list of 
## critical faces.</Returns>
## <Description>
## Builds a random Morse function by removing a uniformly sampled spanning tree 
## from the dual 1-skeleton followed by a collapsing approach.
## <Arg>complex</Arg> needs to be a closed weak pseudomanifold for this to work.
## For details of the algorithm, see <Cite Key="Paixao143SphereRec" />.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> f:=SCMorseUST(c);;
## gap> Size(f[2]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseUST,
function(cc)

    local c,i,iii,free,r,R,upward,downward,f,HD,
    Morse,critical,idx,pairedFace,ctr,available,
    tmp,pos,fl,dim,v,visited,USPTop,vColl,eColl,e,l,mx,
    edgeVals,vals,relVals;

        c:=SCFaceLattice(cc);
      HD:=SCIntFunc.DeepCopy(SCHasseDiagram(cc));
      available:=List([1..Size(c)],x->[1..Size(c[x])]);
      Morse:=[];
      f:=List([1..Size(c)],x->0);
      critical:=[];

  if ForAny(HD[1][Size(HD[1])],x->Size(x) < 2) then
    Info(InfoSimpcomp,2,"SCMorseUST: first argument has boundary or is not a ",
      "weak pseudomanifold, try other heuristic.");
    return fail;
  fi;

  v := Random(available[Size(available)]);
  Add(critical,c[Size(c)][v]);
  Add(Morse,c[Size(c)][v]);
  f[Size(f)]:=f[Size(f)]+1;
  Remove(available[Size(available)],
    PositionSorted(available[Size(available)],v));

  visited := [v];
  USPTop:=[];
  # choose new vertex
  while Size(visited) < Size(c[Size(c)]) do
    v:=Random(available[Size(available)]);
    vColl := [];
    eColl := [];
    # start random walk from v to USP
    while not v in visited do
      Add(vColl,v);
      e := Random(HD[2][Size(HD[2])][v]);
      Add(eColl,e);
      v := HD[1][Size(HD[1])][e][(Position(HD[1][Size(HD[1])][e],v) mod 2) + 1];
    od;
    # erase loops
    tmp:=[];
    while vColl <> [] do
      l:=Positions(vColl,vColl[1]);
      mx := Size(l);
      Add(visited,vColl[l[mx]]);
      Add(tmp,c[Size(c)][vColl[l[mx]]]);
      Add(tmp,c[Size(c)-1][eColl[l[mx]]]);
      Add(USPTop,eColl[l[mx]]);
      Remove(available[Size(available)],
        PositionSorted(available[Size(available)],vColl[l[mx]]));
      eColl:=eColl{[l[mx]+1..Size(eColl)]};
      vColl:=vColl{[l[mx]+1..Size(vColl)]};
    od;
    Append(Morse,Reversed(tmp));
  od; 

  for e in USPTop do
    R := HD[2][Size(HD[2])-1][e];
    for i in R do
      pos:=PositionSorted(HD[1][Size(HD[1])-1][i],e);
      if pos <> fail then
        Remove(HD[1][Size(HD[1])-1][i],pos);
      fi;
    od;    
    Unbind(HD[2][Size(HD[2])-1][e]);
    Remove(available[Size(available)-1],
      PositionSorted(available[Size(available)-1],e));
  od;

  upward:=HD[1];
  downward:=HD[2];

  for iii in Reversed([1..(Size(c)-2)]) do
    free := [];
    for i in [1..Size(upward[iii])] do
      if IsBound(upward[iii][i]) and Size(upward[iii][i]) = 1 then
        Add(free,i);
      fi;
    od;
    while available[iii+1] <> [] do
        if free=[] then
            f[iii+1]:=f[iii+1]+1;
            r:=RandomList(available[iii+1]);
            Remove(available[iii+1],PositionSorted(available[iii+1],r));
            R:=downward[iii][r];
            # update upward Hasse diagram
            for i in R do
          Remove(upward[iii][i],Position(upward[iii][i],r));
          if Size(upward[iii][i]) = 1 then
              Add(free,i);
          fi;
            od;
            # keep track of Morse function
            Add(Morse,c[iii+1][r]);
            Add(critical,c[iii+1][r]);
        else
            r:=RandomList(free);
            Remove(free,Position(free,r));
            pairedFace:=Random(upward[iii][r]);
            # keep track of Morse function
            Add(Morse,c[iii][r]);
            Add(Morse,c[iii+1][pairedFace]);
            Remove(available[iii],PositionSorted(available[iii],r));
            Remove(available[iii+1],
              PositionSorted(available[iii+1],pairedFace));
            R:=downward[iii][pairedFace];
            # update upward Hasse diagram
            for i in R do
          Remove(upward[iii][i],Position(upward[iii][i],pairedFace));
          if Size(upward[iii][i]) = 1 then
              Add(free,i);
          elif upward[iii][i] = [] then
              pos:=Position(free,i);
              if pos <> fail then
            Remove(free,pos);
              fi;
          fi;
  
            od;
      if iii > 1 then
        R:=downward[iii-1][r];
        for i in R do
            Remove(upward[iii-1][i],Position(upward[iii-1][i],r));
        od;
      fi;
        fi;
    od;
   od;
   for i in available[1] do
     Add(Morse,c[1][i]);
     Add(critical,c[1][i]);
     f[1]:=f[1]+1;
   od;
  Morse:=Reversed(Morse);
  return [Morse,critical];
end);


################################################################################
##<#GAPDoc Label="SCMorseSpec">
## <ManSection>
## <Func Name="SCMorseSpec" Arg="complex, iter [, morsefunc]"/>
## <Returns>a list upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes <Arg>iter</Arg> versions of a discrete Morse function of 
## <Arg>complex</Arg> using a randomised 
## method specified by <Arg>morsefunc</Arg> (default choice is 
## <Ref Func="SCMorseRandom"/>,
## other randomised methods available are <Ref Func="SCMorseRandomLex"/>
## <Ref Func="SCMorseRandomRevLex"/>, and <Ref Func="SCMorseUST"/>). The
## result is referred to by the Morse spectrum of <Arg>complex</Arg> and is 
## returned in form of a list containing all Morse vectors sorted by number of 
## critical points together with the actual vector of critical points and how 
## often they ocurred (see <Cite Key="Benedetti13RandomDMT" /> for details).
## <Example><![CDATA[
## gap> c:=SCSeriesTorus(2);;
## gap> f:=SCMorseSpec(c,30);
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCSeriesHomologySphere(2,3,5);;
## gap> f:=SCMorseSpec(c,30,SCMorseRandom);
## gap> f:=SCMorseSpec(c,30,SCMorseRandomLex);
## gap> f:=SCMorseSpec(c,30,SCMorseRandomRevLex);
## gap> f:=SCMorseSpec(c,30,SCMorseUST);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMorseSpec,
function(arg)

  local i,f,Spec,s,Vec,pos,c,morsefunc,iter,tmp;

  if Size(arg) > 3 or Size(arg) < 2 then
    Info(InfoSimpcomp,2,"SCMorseSpec: no. of arguments must be 2 or 3.");
    return fail;
  fi;

  if Size(arg) = 2 then
    c:=arg[1];
    iter:=arg[2];
    morsefunc:=SCMorseUST;
  elif Size(arg) = 3 then
    c:=arg[1];
    iter:=arg[2];
    morsefunc:=arg[3];
  fi;

  if not SCIsSimplicialComplex(c) or not IsPosInt(iter) then
    Info(InfoSimpcomp,2,"SCMorseSpec: first argument must be of type ",
      "SCSimplicialComplex, second argument must be a positive integer.");
    return fail;
  fi;

  Spec:=[];
  Vec:=[];
  for i in [1..iter] do
    tmp:=morsefunc(c);
    f:=SCIntFunc.SCMorseVec(tmp[2]);
    pos:=Position(Vec,f);
    if pos = fail then
      Add(Vec,f);
      Add(Spec,[Sum(f),f,1]);
    else
      Spec[pos][3]:=Spec[pos][3]+1;
    fi;
  od;
  Sort(Spec);
  return Spec;
end);


SCIntFunc.SCSimplexBdry:=function(delta)
  local face,coeffs,a,chain;

  a:=1;
  chain:=[];
  coeffs:=[];
  for face in Reversed(Combinations(delta,Size(delta)-1)) do
    Add(chain,face);
    Add(coeffs,a);
    a:=a*(-1);
  od;
  return [chain,coeffs];    
end;


SCIntFunc.SCBdry:=function(chain)
  local elm,tmp,bdry,coeffs,filt,i,SCSimplexBdry;

  bdry:=[];
  coeffs:=[];
  for elm in chain do
    tmp:=SCIntFunc.SCSimplexBdry(elm[1]);
    for i in tmp[1] do
      if i in bdry then
        coeffs[Position(bdry,i)]:=
          coeffs[Position(bdry,i)]+tmp[2][Position(tmp[1],i)]*elm[2];
      else
        Add(bdry,i);
        Add(coeffs,tmp[2][Position(tmp[1],i)]*elm[2]);
      fi;
    od;
  od;

  filt:=Filtered([1..Size(bdry)],x->coeffs[x]<>0);
  return List(filt,x->[bdry[x],coeffs[x]]);
end;

SCIntFunc.SCAddCrits:=function(sum1,sum2)
  local i;
  for i in [1..Length(sum1)] do
    sum1[i][2]:=sum1[i][2]+sum2[i][2];
  od;
  return sum1;
end;

SCIntFunc.SCAddCrit:=function(sum,chain)
  local i;
  for i in [1..Length(sum)] do
    if sum[i][1]=chain[1] then
      sum[i][2]:=sum[i][2]+chain[2];
      return sum;
    fi;
  od;
  Info(InfoSimpcomp,2,"SCIntFunc.SCAddCrit: second argument must correspond ",
    "to an item in first argument.");
  return fail;
end;

SCIntFunc.SCFindGradientPaths:=function(f,orFace,crits,dict)
  local out,i,sum,gradPaths,matchedFace,matchedFaceBdry,outChain,
    check,dictCopy,SCGradient;
  # f    =  [Morse function, list of critical points]
  # orFace  =  [starting face to compute gradient paths,multiplicity]
  # crits    =  list of critical points one dimension down
  # dict    =  dictionary containing all [face,gradient paths] pairs
  #      that are already known  

  # discrete gradient, takes an (i-)face and computes the unique matched 
  # (i+1)-face
  SCGradient:=function(f,face)
    local i,pos,matching,bdry,SCSimplexBdry;

    f:=f[1];
    pos:=Position(f,face);
    matching:=[];
    for i in [1..pos-1] do
      if not IsSubset(f[i],face) or not Size(f[i]) = Size(face)+1 then 
        continue; 
      fi;
      matching:=f[i];
      break;
    od;
    if matching = [] then
      return 0;
    else
      bdry:=SCIntFunc.SCSimplexBdry(matching);
      pos:=Position(bdry[1],face);
      return [matching,(-1)*bdry[2][pos]];
    fi;
  end;

  dictCopy:=dict;
  
  # if gradient paths from 'orFace' downwards are already known, return
  check:=LookupDictionary(dictCopy,orFace);
  if check<>fail then
    return [ShallowCopy(check),dictCopy];
  fi;

  # new chain
  sum:=List(crits,x->[x,0]);
  # gradient of current face (returns oriented face [face,mult])
  matchedFace:=SCGradient(f,orFace[1]);
  # if current face is unmatched
  if matchedFace=0 then
    # add [orFace,empty chain] to dictionary
    AddDictionary(dictCopy,orFace,sum);
    # add [-orFace,empty chain] to dictionary
    AddDictionary(dictCopy,[orFace[1],-1*orFace[2]],
      List(sum,x->[x[1],-1*x[2]]));
    return [sum,dictCopy]; 
  # if current face has a matched face
  else
    # propagate orientation / multiplicity
    matchedFace[2]:=matchedFace[2]*orFace[2];
    # compute boundary
    matchedFaceBdry:=SCIntFunc.SCBdry([matchedFace]);
    # remove original face (-> outgoing discrete gradient flow \Phi, 
    # coming from 'orFace')
    # outChain = \Phi (orFace) 
    outChain:=Filtered(matchedFaceBdry,x->x[1]<>orFace[1]);
  fi;
  for i in [1..Size(outChain)] do
    # elm is critical face
    if outChain[i][1] in crits then
      # note: outChain[x][2] is \pm 1 for all x
      sum:=SCIntFunc.SCAddCrit(sum, outChain[i]);
    else
      # new grad paths and new sum
      gradPaths:=SCIntFunc.SCFindGradientPaths(f,outChain[i],crits,dict);
      # add gradpath to dictionary
      dictCopy:=gradPaths[2];
      # update sum
      sum:=SCIntFunc.SCAddCrits(sum,gradPaths[1]);
    fi;
  od;

  # update dictionary and sum
  AddDictionary(dictCopy,orFace,sum);
  AddDictionary(dictCopy,[orFace[1],-1*orFace[2]],List(sum,x->[x[1],-1*x[2]]));
  return [sum,dictCopy];
end;

SCIntFunc.SCMorseBdryOperator:=function(f,dimension)
  local i,ii,iii,tau,faces,new,sum,sum1,critsUp,critsDown,innerprod,dict,
    row,tau2;

  dict:=NewDictionary([[1..(dimension-1)],1],true);

  critsUp:=Filtered(f[2],x->Length(x)=dimension);
  critsDown:=Filtered(f[2],x->Length(x)=dimension-1);

  tau:=[];
  for i in critsUp do
    sum:=List(critsDown,x->[x,0]);
    faces:=SCIntFunc.SCBdry([[i,1]]);
    for ii in faces do
      if Filtered(f[2],x->x=ii[1])<>[] then
        sum:=SCIntFunc.SCAddCrit(sum,ii);
      else
        new:=SCIntFunc.SCFindGradientPaths(f,ii,critsDown,dict);
        sum1:=new[1];
        sum:=SCIntFunc.SCAddCrits(sum,sum1);
      fi;
    od;
    Add(tau,sum);
  od;

  tau2:=[];
  for i in [1..Length(critsDown)] do
    row:=[];
    for ii in [1..Length(critsUp)] do
      Add(row,tau[ii][i][2]);
    od;
    Add(tau2,row);
  od;

  return tau2;
end;


################################################################################
##<#GAPDoc Label="SCHomologyEx">
## <ManSection>
## <Meth Name="SCHomologyEx" Arg="c, morsechoice, smithchoice"/>
## <Returns>a list of pairs of the form <C>[ integer, list ]</C> upon success, 
## fail otherwise.</Returns>
## <Description>
## Computes the homology groups of a given simplicial complex <Arg>c</Arg> 
## using the function <Arg>morsechoice</Arg> for discrete Morse function 
## computations and <Arg>smithchoice</Arg> for Smith normal form 
## computations.<P/>
##
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, 
## where <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the 
## homology groups <M>H_i</M> is given in terms of their maximal cyclic 
## subgroups, i.e. a homology group 
## <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> 
## is returned in form of a list 
## <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> is the (integer) 
## free part of <M>H_i</M> and <M>t_i</M> denotes the torsion parts of 
## <M>H_i</M> ordered in weakly increasing size.<P/>
## <Example><![CDATA[
## gap> c:=SCSeriesTorus(2);;
## gap> f:=SCHomology(c);
## ]]></Example>
## <Example><![CDATA[
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseRandom,SmithNormalFormIntegerMat); time;
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseRandomLex,SmithNormalFormIntegerMat); time;
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseRandomRevLex,SmithNormalFormIntegerMat); time;
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseEngstroem,SmithNormalFormIntegerMat); time;
## gap> c := SCSeriesHomologySphere(2,3,5);;
## gap> SCHomologyEx(c,SCMorseUST,SmithNormalFormIntegerMat); time;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCHomologyEx,
function(c,morsechoice,smithchoice)

  local i,ii,f,taus,Hom,Z,Tor,
    SCTor,SCNumZerosC,SCNumZerosR;

  SCNumZerosC:=function(tau)
    local i,ii,cols,rows,temp;
  
    if tau=[] then
      return 0;
    fi;

    cols:=Size(tau[1]);
    rows:=Size(tau);
    temp:=0;
    for i in [1..Minimum([cols,rows])] do 
      if tau[i][i]<>0 then
        temp:=temp+1;
      fi;
    od;
    return cols-temp;  
  end;

  SCNumZerosR:=function(tau)
    local i,ii,cols,rows,temp;

    if tau=[] then
      return 0;
    fi;
  
    cols:=Size(tau[1]);
    rows:=Size(tau);
    temp:=0;
    for i in [1..Minimum([cols,rows])] do 
      if tau[i][i]<>0 then
        temp:=temp+1;
      fi;
    od;
    return temp;  
  end;

  SCTor:=function(tau)
    local i,temp,rows,cols;
  
    if tau=[] then
      return [];
    fi;
  
    cols:=Size(tau[1]);
    rows:=Size(tau);
    i:=1;
    temp:=[];
    for i in [1..Minimum([cols,rows])] do
      if tau[i][i]>1 then
        Add(temp,tau[i][i]);
      fi;
    od;
    return temp;
  end;

  if HasSCHomology(c) then
    return SCHomology(c);
  fi;

  f:=morsechoice(c);
  if f = fail then
    return fail;
  fi;

  taus:=[];

  Add(taus,[]);
  for i in [2..Size(c)] do
    if Filtered(f[2],x->Length(x)=i)=[] then
      Add(taus,[]);
    else
      Add(taus,smithchoice(SCIntFunc.SCMorseBdryOperator(f,i)));
    fi;
  od;
  Add(taus,[]);

  Hom:=[];
  for i in [1..(Size(taus)-1)] do
    if taus[i]=[] then
      Z:=Length(Filtered(f[2],x->Length(x)=i))-SCNumZerosR(taus[i+1]);
    else
      Z:=SCNumZerosC(taus[i])-SCNumZerosR(taus[i+1]);
    fi;  
    Tor:=SCTor(taus[i+1]);
    Add(Hom,[Z,Tor]);
  od;

  Hom[1][1]:=Hom[1][1]-1;

  SetSCHomology(c,Hom);
  return Hom;
end);

################################################################################
##<#GAPDoc Label="SCHomology">
## <ManSection>
## <Meth Name="SCHomology" Arg="complex"/>
## <Returns>a list of pairs of the form <C>[ integer, list ]</C> upon 
## success</Returns>
## <Description>
## Computes the homology groups of a given simplicial complex 
## <Arg>complex</Arg> using 
## <Ref Func="SCMorseRandom"/> to obtain a Morse function and 
## <C>SmithNormalFormIntegerMat</C>.
## Use <Ref Func="SCHomologyEx"/> to use alternative methods to compute 
## discrete Morse functions (such as <Ref Func="SCMorseEngstroem"/>, 
## or <Ref Func="SCMorseUST"/>) or the Smith normal form. <P/>
##
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, 
## where <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the 
## homology groups <M>H_i</M> is given in terms of their maximal cyclic 
## subgroups, i.e. a homology group 
## <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> 
## is returned in form of a list <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> 
## is the (integer) free part of <M>H_i</M> and <M>t_i</M> denotes the torsion 
## parts of <M>H_i</M> ordered in weakly increasing size.<P/>
## <Example><![CDATA[
## gap> c:=SCSeriesTorus(2);;
## gap> f:=SCHomology(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomology,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(c)
  return [];
end);

InstallMethod(SCHomology,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)
  return SCHomologyEx(c,SCMorseRandom,SmithNormalFormIntegerMat);
end);


################################################################################
##<#GAPDoc Label="SCSpanningTreeRandom">
## <ManSection>
## <Func Name="SCSpanningTreeRandom" Arg="HD, top"/>
## <Returns>a list of edges upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes a uniformly sampled spanning tree of the complex belonging
## to the Hasse diagram <Arg>HD</Arg> using Wilson's algorithm (see 
## <Cite Key="Wilson96UST" />). 
## If <Arg>top = true</Arg> the output is a
## spanning tree of the dual graph of the underlying complex. If
## <Arg>top = false</Arg> the output is a spanning tree of the primal graph 
## (i.e., the <M>1</M>-skeleton.
## <Example><![CDATA[
## gap> c:=SCSurface(1,false);;
## gap> HD:=SCHasseDiagram(c);;
## gap> stTop:=SCSpanningTreeRandom(HD,true);
## gap> stBot:=SCSpanningTreeRandom(HD,false);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSpanningTreeRandom,
function(HD,top)
  local verts,v,visited,USPTop,vColl,eColl,e,l,mx,upward,downward,n;

  if not IsBool(top) then
    Info(InfoSimpcomp,2,"SCSpanningTreeRandom: second argument must be of ",
      "type IsBool.");
    return fail;
  fi;

  if not Size(HD)=2 or not ForAll(HD,x->IsList(x)) then
    Info(InfoSimpcomp,2,"SCSpanningTreeRandom: first argument must be a pair ",
      "of lists.");
    return fail;
  fi;

  if ForAny(HD[1][Size(HD[1])],x->Size(x) <> 2) and top then
    Info(InfoSimpcomp,2,"SCSpanningTreeRandom: first argument has boundary or ", 
      "is not a weak pseudomanifold, try top = false.");
    return fail;
  fi;

  if Size(HD[1]) < 2 or Size(HD[2]) < 2 then
    Info(InfoSimpcomp,2,"SCSpanningTreeRandom: first argument must be a ",
      "Hasse diagram of a d-dimensional simplicial complex, d > 1.");
    return fail;
  fi;

  if top then
    upward:=SCIntFunc.DeepCopy(HD[1][Size(HD[1])]);
    downward:=SCIntFunc.DeepCopy(HD[2][Size(HD[2])]);
    n:=Size(HD[2][Size(HD[2])]);
  else
    upward:=SCIntFunc.DeepCopy(HD[2][1]);
    downward:=SCIntFunc.DeepCopy(HD[1][1]);
    n:=Size(HD[1][1]);
  fi;

  verts := [1..n];
  v := Random(verts);
  Remove(verts,v);
  visited := [v];
  USPTop:=[];
  # choose new vertex
  while Size(visited) < n do
    v:=Random(verts);
    vColl := [];
    eColl := [];
    # start random walk from v to USP
    while not v in visited do
      Add(vColl,v);
      e := Random(downward[v]);
      Add(eColl,e);
      v := upward[e][(Position(upward[e],v) mod 2) + 1];
    od;
    # erase loops
    while vColl <> [] do
      l:=Positions(vColl,vColl[1]);
      mx := Size(l);
      Add(visited,vColl[l[mx]]);
      Remove(verts,PositionSorted(verts,vColl[l[mx]]));
      Add(USPTop,eColl[l[mx]]);
      eColl:=eColl{[l[mx]+1..Size(eColl)]};
      vColl:=vColl{[l[mx]+1..Size(vColl)]};
    od;
  od; 
  return USPTop;
end);


SCIntFunc.ChainToRels:=function(tau,gens)
  local chain,i,rel,rels,str,skip;

  str:=List(gens,x->String(x));
  rels:=[];
  for chain in tau do
    rel:=gens[1]^0;
    for i in [1..Size(chain)] do
      rel:=rel*gens[Position(str,String(chain[i][1]))]^chain[i][2];
    od;
    Add(rels,rel);
  od;

  return rels;
end;

SCIntFunc.FundGroupFindGradientPaths:=function(f,orFace,crits,dict)

  local elm,sum,sum1,i,gradPaths,matchedFace,matchedFaceBdry,outChain,
    check,dictCopy,SCGradient,skip;
  # f    =  [Morse function, list of critical points]
  # orFace  =  [starting face to compute gradient paths,multiplicity]
  # crits    =  list of critical points one dimension down
  # dict    =  dictionary containing all [face,gradient paths] pairs
  #      that are already known  

  # discrete gradient, takes an (i-)face and computes the unique matched 
  # (i+1)-face
  SCGradient:=function(f,face)
    local i,pos,matching,bdry,SCSimplexBdry;

    f:=f[1];
    pos:=Position(f,face);
    matching:=[];
    for i in [1..pos-1] do
      if not IsSubset(f[i],face) or not Size(f[i]) = Size(face)+1 then 
        continue; 
      fi;
      matching:=f[i];
      break;
    od;
    if matching = [] then
      return 0;
    else
      bdry:=SCIntFunc.SCSimplexBdry(matching);
      pos:=Position(bdry[1],face);
      return [matching,(-1)*bdry[2][pos]];
    fi;
  end;

  dictCopy:=dict;
  
  # if gradient paths from 'orFace' downwards are already known, return
  check:=LookupDictionary(dictCopy,orFace);
  if check<>fail then
    return [ShallowCopy(check),dictCopy];
  fi;

  # gradient of current face (returns oriented face [face,mult])
  matchedFace:=SCGradient(f,orFace[1]);
 
  # if current face is critical
  if matchedFace=0 then
    # add [orFace,empty chain] to dictionary
    AddDictionary(dictCopy,orFace,[]);
    # add [-orFace,empty chain] to dictionary
    AddDictionary(dictCopy,[orFace[1],(-1)*orFace[2]],[]);
    # return empty chain  
    return [[],dictCopy]; 
  # if current face has a matched face
  else
    # compute boundary in right order:
    if orFace[1] = matchedFace[1]{[1,2]} and orFace[2] = 1 then
      outChain:=[[matchedFace[1]{[1,3]},1],[matchedFace[1]{[2,3]},-1]];
    elif orFace[1] = matchedFace[1]{[1,2]} and orFace[2] = -1 then
      outChain:=[[matchedFace[1]{[2,3]},1],[matchedFace[1]{[1,3]},-1]];

    elif orFace[1] = matchedFace[1]{[1,3]} and orFace[2] = 1 then
      outChain:=[[matchedFace[1]{[1,2]},1],[matchedFace[1]{[2,3]},1]];

    elif orFace[1] = matchedFace[1]{[1,3]} and orFace[2] = -1 then
      outChain:=[[matchedFace[1]{[2,3]},-1],[matchedFace[1]{[1,2]},-1]];
    elif orFace[1] = matchedFace[1]{[2,3]} and orFace[2] = 1 then
      outChain:=[[matchedFace[1]{[1,2]},-1],[matchedFace[1]{[1,3]},1]];
    elif orFace[1] = matchedFace[1]{[2,3]} and orFace[2] = -1 then
      outChain:=[[matchedFace[1]{[1,3]},-1],[matchedFace[1]{[1,2]},1]];
    fi;
  fi;

  # new chain
  sum:=[];

  # first add critical faces in 'outChain' as trivial paths
  # for remaining (non-critical) out faces: do recursion 
  for i in [1..Size(outChain)] do
    # elm is critical face
    if outChain[i][1] in crits then
      # note: outChain[x][2] is \pm 1 for all x
      Add(sum,outChain[i]);
    else
      # new grad paths and new sum
      gradPaths:=SCIntFunc.FundGroupFindGradientPaths(f,outChain[i],crits,dict);
      # add gradpath to dictionary
      dictCopy:=gradPaths[2];
      # update sum
      Append(sum,gradPaths[1]);
    fi;
  od;

  # update dictionary and sum
  sum1:=[];
  skip:=false;
  for i in [1..Size(sum)] do
    if skip then 
      skip:=false; 
      continue; 
    fi;
    if sum[i][2] = 0 then 
      continue; 
    fi;
    if (i < Size(sum)) and (sum[i][1] = sum[i+1][1] and 
      sum[i][2] = (-1)*sum[i+1][2]) then
      skip:=true;
      continue;
    fi;
    Add(sum1,sum[i]);
  od;


  # update dictionary and sum
  AddDictionary(dictCopy,orFace,sum1);
  AddDictionary(dictCopy,[orFace[1],(-1)*orFace[2]],
    List(Reversed(sum1),x->[x[1],(-1)*x[2]]));

  return [sum,dictCopy];
end;



SCIntFunc.MorseFuncToFundGroup := function(Morse,critical)
  local i,levels,down,up,gens,g,rels,
    sum,ii,faces,gradPaths,dict,tau,elm,skip;

  down := Filtered(critical,x->Size(x)=2);
  up := Filtered(critical,x->Size(x)=3);

  if down = [] then
    return FreeGroup([]);
  fi;

  gens:=List(down,x->Concatenation("[ ",String(x[1]),", ",String(x[2])," ]"));
  g:=FreeGroup(gens);
  gens:=GeneratorsOfGroup(g);

  dict:=NewDictionary([[10000,20000],1],true);

  tau:=[];
  for elm in up do
    sum:=[];
    # d([t1,t2,t3]) -> [t2,t3] - [t1,t3] + [t1,t2]
    faces:=SCIntFunc.SCBdry([[elm,1]]);
    for ii in faces do
      if ii[1] in down then
        Add(sum,ii);
      else
        gradPaths:=SCIntFunc.FundGroupFindGradientPaths([Morse,critical],ii,
          down,dict);
        skip:=false;
        for i in [1..Size(gradPaths[1])] do
          if skip then 
            skip:=false; 
            continue; 
          fi;
          if gradPaths[1][i][2] = 0 then 
            continue; 
          fi;
          if (i < Size(gradPaths[1])) and 
            (gradPaths[1][i][1] = gradPaths[1][i+1][1] and 
            gradPaths[1][i][2] = (-1)*gradPaths[1][i+1][2]) then
            skip := true;
            continue;
          fi;
          Add(sum,gradPaths[1][i]);
        od;
      fi;
    od;
    Add(tau,sum);
  od;


  rels:=SCIntFunc.ChainToRels(tau,gens);

  return g/rels;
end;


################################################################################
##<#GAPDoc Label="SCIsSimplyConnectedEx">
## <ManSection>
## <Func Name="SCIsSimplyConnectedEx" Arg="c [, top, tries]"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes if the <C>SCSimplicialComplex</C> object <Arg>c</Arg> is simply 
## connected. The optional boolean argument <Arg>top</Arg> determines whether 
## a spanning graph in the dual or the primal graph of <Arg>c</Arg> will be 
## used for a collapsing sequence. The optional positive integer argument 
## <Arg>tries</Arg> determines the number of times the algorithm will try to 
## find a collapsing sequence. The algorithm is a heuristic method and is 
## described in <Cite Key="Paixao143SphereRec" />.
## <Example><![CDATA[
## gap> rp2:=SCSurface(1,false);;
## gap> SCIsSimplyConnectedEx(rp2);
## gap> c:=SCBdCyclicPolytope(8,18);;
## gap> SCIsSimplyConnectedEx(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCIsSimplyConnectedEx,
function(arg)
  local upward, downward, R, fl, tmp, g, c, top, tries, f, isTriv, 
    coll, available, r, pairedFace, pos, free, start, jj, sh, 
    time, i, iii, isconn, dim, SCHasseDiagram, morsechoice;

  SCHasseDiagram:=function(fl)
    local downward, upward, i, j, k, d, base, idx;
  
    upward:=[];
    upward[1]:=List([1..Size(fl[1])],x->[]);
    upward[2]:=List([1..Size(fl[2])],x->[]);
    downward:=[];
    downward[1]:=List([1..Size(fl[2])],x->[]);
    downward[2]:=List([1..Size(fl[3])],x->[]);
    for k in [2,3] do
      d:=Size(fl[k][1]);
      idx:=[];  
      for i in [1..d] do
        idx[i]:=[1..d];
        Remove(idx[i],i);
      od;
      for i in [1..Size(fl[k])] do
        for j in [1..d] do
          base:=fl[k][i]{idx[j]};
          Add(upward[k-1][PositionSorted(fl[k-1],base)],i);
          Add(downward[k-1][i],PositionSorted(fl[k-1],base));
        od;
      od;
    od;
    return [upward,downward];
  end;

  if Size(arg) < 1 or Size(arg) > 4 then
    Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: no. or arguments must be ",
      "1, 2, 3, or 4.");
    return fail;
  fi;

  if Size(arg) = 1 then
    c := SCCopy(arg[1]);
    SCRelabelStandard(c);
    top := false;
    tries := 3;
    morsechoice:=SCMorseRandom;
  elif Size(arg) = 2 then
    c := SCCopy(arg[1]);
    SCRelabelStandard(c);
    if IsBool(arg[2]) then
      top := arg[2];
      tries := 3;
    else
      top := false;
      tries := arg[2];
    fi;
    morsechoice:=SCMorseRandom;
  elif Size(arg) = 3 then
    c := SCCopy(arg[1]);
    SCRelabelStandard(c);
    top := arg[2];
    tries := arg[3];
    morsechoice:=SCMorseRandom;
  elif Size(arg) = 4 then
    c := SCCopy(arg[1]);
    SCRelabelStandard(c);
    top := arg[2];
    tries := arg[3];
    morsechoice:=arg[4];
  fi;

  if not SCIsSimplicialComplex(c) or not IsBool(top) or not IsPosInt(tries) then
    Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: first argument must be of ",
      "type SCIsSimplicialComplex.");
    return fail;
  fi;

  isconn:=SCIsConnected(c);
  if isconn = fail then
    return fail;
  fi;
  if isconn <> true then
    Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: first argument is not ",
      "connected.");
    return false;
  fi;

  dim := SCDim(c);
  if dim = fail then
    return fail;
  fi;

  if dim < 1 then
    return true;
  elif dim = 1 then
    return Size(SCSkel(c,1)) = Size(SCSkel(c,0))-1;
  elif dim = 2 then
    # the UST approach ensures all Morse functions on surfaces are perfect
    tmp:=SCMorseUST(c);
    if tmp = fail then
      return IsTrivial(SCFundamentalGroup(c));
    else
      return Filtered(tmp[2],x->Size(x)=2) = [];
    fi;
  elif dim=3 then
    f:=morsechoice(c);
    if Filtered(f[2],x->Size(x)=2) = [] then
      return true;
    else
      Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: Could not determine ",
        "collapsing seuqence, build fundamental group from Morse function ",
        "instead.");
      if [] in f[1] then
        Remove(f[1],Position(f[1],[]));
      fi;
      g:=SCIntFunc.MorseFuncToFundGroup(f[1],f[2]);
      if AbelianInvariants(g) <> [] then
        return false;
      fi;
      g:=SimplifiedFpGroup(g);
      if GeneratorsOfGroup(g) = [] then
        return true;
      else
        Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: could not determine or ",
          "disprove simple connectivity. Returning fundamental group. You ",
          "might want to try IsTrivial(g) to determine whether complex is ",
          "simply connected.");
        return [fail,g];    
      fi;
    fi;
  fi;

  if top then
    fl:=[SCSkel(c,dim-2),SCSkel(c,dim-1),SCSkel(c,dim)];
  else
    fl:=[SCSkel(c,0),SCSkel(c,1),SCSkel(c,2)];
  fi;

  if top then 
    Info(InfoSimpcomp,3,"SCIsSimplyConnectedEx: try to collapse co-dimension ",
      "one skeleton of complex ",tries," times (see optional arguments ",
      "'tries' to adjust number of collapsing attempts, see optional argument ",
      "'top' to switch to dual complex (faster for complexes with few ",
      "facets)).");
  else
    Info(InfoSimpcomp,3,"SCIsSimplyConnectedEx: try to collapse co-dimension ",
      "one skeleton of dual complex ",tries," times (see optional arguments ",
      "'tries' to adjust number of collapsing attempts, see optional argument ",
      "'top' to switch to complex (faster for higher dimensional complexes)).");
  fi;
  for jj in [1..tries] do
    time:=Runtime();
    Info(InfoSimpcomp,3,"SCIsSimplyConnectedEx: try ",jj,"...");
    sh:=Shuffle(ShallowCopy(SCVertices(c)));
    tmp := SCHasseDiagram(List(fl,x->SCIntFunc.RelabelSimplexList(x,sh)));
    if top then
      upward:=SCIntFunc.DeepCopy(tmp[1]);
      downward:=SCIntFunc.DeepCopy(tmp[2]);
      available:=List([1..Size(fl)],x->[1..Size(fl[x])]);
    else
      upward:=Reversed(SCIntFunc.DeepCopy(tmp[2]));
      downward:=Reversed(SCIntFunc.DeepCopy(tmp[1]));
      available:=List(Reversed([1..Size(fl)]),x->[1..Size(fl[x])]);
    fi;
    start := true; 
    coll:=true;

    for iii in Reversed([1..(Size(fl)-1)]) do
      if coll = false then break; fi;
      free:=[];
      for i in [1..Size(upward[iii])] do
          if Size(upward[iii][i]) = 1 then
              Add(free,i);
          fi;
      od;
      if free <> [] then
        start := false;
      fi;
      while available[iii+1] <> [] do
        if free=[] then
          if start = true then
            r:=available[iii+1][1];
            Remove(available[iii+1],1);
            start:=false;
          else
            coll:=false;
            break;
          fi;
          R:=downward[iii][r];
          # update upward Hasse diagram
          for i in R do
            Remove(upward[iii][i],Position(upward[iii][i],r));
            if Size(upward[iii][i]) = 1 then
              Add(free,i);
            fi;
          od;
        else
          r:=free[1];
          Remove(free,1);
          pairedFace:=upward[iii][r][1];
          Remove(available[iii],Position(available[iii],r));
          Remove(available[iii+1],Position(available[iii+1],pairedFace));
          R:=downward[iii][pairedFace];
          # update upward Hasse diagram
          for i in R do
            Remove(upward[iii][i],Position(upward[iii][i],pairedFace));
            if Size(upward[iii][i]) = 1 then
              Add(free,i);
            elif Size(upward[iii][i]) = 0 then
              pos:=Position(free,i);
              if pos <> fail then
                Remove(free,pos);
              fi;
            fi;
          od;
          if iii > 1 then
            R:=downward[iii-1][r];
          else
            R:=[];
          fi;
          for i in R do
            Remove(upward[iii-1][i],Position(upward[iii-1][i],r));
          od;
        fi;
      od;
    od;
    time:=Runtime()-time;
    Info(InfoSimpcomp,3,time,"ms for collapsing attempt no. ",jj,".");
    if coll = true then 
      return true;
    fi;
  od;

  Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: Could not determine collapsing ",
    "seqence, try simplifying fundamental group instead.");
  time:=Runtime();
  g:=SCFundamentalGroup(SC(SCSkel(c,2)));
  time:=Runtime()-time;
  Info(InfoSimpcomp,3,"SCIsSimplyConnectedEx: constructed fundamental ",
    "group in ",time,"ms.");
  time:=Runtime();
  g:=SimplifiedFpGroup(g);
  time:=Runtime()-time;
  Info(InfoSimpcomp,3,"SCIsSimplyConnectedEx: simplified fundamental group ",
    "in ",time,"ms.");
  if AbelianInvariants(g) <> [] then
    return false;
  fi;
  if GeneratorsOfGroup(g) = [] then
    return true;
  else
    Info(InfoSimpcomp,2,"SCIsSimplyConnectedEx: could not determine or ",
      "disprove simple connectivity. Returning fundamental group. You might ",
      "want to try IsTrivial(g) to determine whether complex is simply ",
      "connected.");
    return [fail,g];
  fi;
end);

################################################################################
##<#GAPDoc Label="SCIsSimplyConnected">
## <ManSection>
## <Func Name="SCIsSimplyConnected" Arg="c"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Computes if the <C>SCSimplicialComplex</C> object <Arg>c</Arg> is simply 
## connected. The algorithm is a heuristic method and is described in 
## <Cite Key="Paixao143SphereRec" />. Internally calls 
## <Ref Func="SCIsSimplyConnectedEx" />.
## <Example><![CDATA[
## gap> rp2:=SCSurface(1,false);;
## gap> SCIsSimplyConnected(rp2);
## gap> c:=SCBdCyclicPolytope(8,18);;
## gap> SCIsSimplyConnected(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsSimplyConnected,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(c)
  return false;
end);

InstallMethod(SCIsSimplyConnected,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)
  return SCIsSimplyConnectedEx(c);
end);


################################################################################
##<#GAPDoc Label="SCIsManifoldEx">
## <ManSection>
## <Func Name="SCIsManifoldEx" Arg="c [,aut, quasi]"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## If the boolean argument <Arg>aut</Arg> is <C>true</C> the automorphism group
## is computed and only one link per orbit is checked to be a sphere.
## If <Arg>aut</Arg> is not provided symmetry information is only used if
## the automorphism group is already known.
## If the boolean argument <Arg>quasi</Arg> is <C>false</C> the algorithm
## returns whether or not <Arg>c</Arg> is a combinatorial manifold. If
## <Arg>quasi</Arg> is <C>true</C> the <M>4</M>-dimensional links are
## not verified to be standard PL <M>4</M>-spheres and <Arg>c</Arg> is
## a combinatorial manifold modulo the smooth Poincare conjecture. 
## By default <Arg>quasi</Arg> is set to <C>false</C>. The algorithm
## is a heuristic method and is described in <Cite Key="Paixao143SphereRec" /> 
## in more detail.<P/>
##
## See <Ref Func="SCBistellarIsManifold" /> for an alternative method for 
## manifold verification.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,20);;
## gap> SCIsManifold(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCIsManifoldEx,
function(arg)
  local dim,i,j,s,elm,
    mfld,sc,c,quasi,fl,G,orbits,o,lk,isPM,
    homOfSphere,hom,aut,vis;
  
  if Size(arg) < 1 or Size(arg) > 3 then
    Info(InfoSimpcomp,2,"SCIsManifoldEx: no. or arguments must be 1, 2, or 3.");
    return fail;
  fi;

  if Size(arg) = 1 then
    c:=arg[1];
    if HasSCAutomorphismGroup(c) then
      aut:=true;
    else
      aut:=false;
    fi;
    quasi:=false;
  elif Size(arg) = 2 then
    c:=arg[1];
    aut:=arg[2];
    quasi := false;
  elif Size(arg) = 3 then
    c:=arg[1];
    aut:= arg[2];
    quasi := arg[3];
  fi;

  if not SCIsSimplicialComplex(c) or not IsBool(quasi) or not IsBool(aut) then
    Info(InfoSimpcomp,2,"SCIsManifoldEx: first argument must be of type ",
      "SCIsSimplicialComplex, second and third argument must be of type ",
      "IsBool.");
    return fail;
  fi;
  
  dim := SCDim(c);
  if dim = fail then
    return fail;
  fi;

  if dim = 1 then
    return SCIsPseudoManifold(c) and not SCHasBoundary(c);
  fi;

  if quasi = true and dim < 5 then
    Info(InfoSimpcomp,3,"SCIsManifoldEx: dimension of complex < 5, switching ",
      "argument 'quasi' to 'false'.");
    quasi:=false;
  fi;

  Info(InfoSimpcomp,3,"SCIsManifoldEx: compute face lattice.");

  fl:=SCFaceLattice(c);
  if fl = fail or fail in fl then
    return fail;
  fi;

  sc:=SCIsStronglyConnected(c);
  if sc = fail then
    return fail;
  fi;

  if not sc then
    return false;
  fi;

  if aut then
    Info(InfoSimpcomp,3,"SCIsManifoldEx: automorphism group ",
      "provided/calculated. Compute orbit representatives in face lattice.");  
    G:=SCAutomorphismGroup(c);
    if G = fail then
      return fail;
    fi;
  
    orbits:=[];
    for i in [1..dim-1] do
      Add(orbits,[]);
      vis:=[];
      for elm in fl[i] do
        if elm in vis then continue; fi;
        Add(orbits[i],elm);
        o := Orbit(G,elm,OnTuples);
        Append(vis,o);
        if Size(vis) = Size(fl[i]) then
          break;
        fi;
      od;
    od;
  else
    orbits:=fl{[1..dim-1]};
  fi;

  # co-dimension 2 links
  if quasi = false then
    Info(InfoSimpcomp,3,"SCIsManifoldEx: check co-dimension 2 links.");
    for j in [1..Size(orbits[dim-1])] do
      if j mod 500 = 0 then
        Info(InfoSimpcomp,5,"SCIsManifoldEx: 1-dimensional links: ",
          Int(100*j/Size(orbits[dim-1])),"% done...");
      fi;
      lk:=SCLink(c,orbits[dim-1][j]);
      if not SCIsPseudoManifold(lk) or SCHasBoundary(lk) or 
        not SCIsConnected(lk) then
        Info(InfoSimpcomp,2,"SCIsManifoldEx: could not reduce link ",
          orbits[dim-1][j],".");
        return false;
      fi;
    od;
    Info(InfoSimpcomp,3,"SCIsManifoldEx: check higher dimensional links.");
  fi;

  # links of higher co-dimension
  for i in Reversed([1..dim-2]) do
    if quasi = false and dim > 4 and i > dim-4 then
      continue;
    fi;
    if quasi = false and i = dim-4 then
      Info(InfoSimpcomp,3,"SCIsManifoldEx: check 4-dimensional links via ",
        "bistellar moves.");
      for j in [1..Size(orbits[i])] do;
        if j mod 10 = 0 then
          Info(InfoSimpcomp,2,"SCIsManifoldEx: ",dim-i,"-dimensional links: ",
            Int(100*j/Size(orbits[i])),"% done...");
        fi;
        lk:=SCLink(c,orbits[i][j]);
        sc:=SCIsSimplyConnected(lk);
        if sc = false then
          Info(InfoSimpcomp,2,"SCIsManifoldEx: found non-simply ",
            "connected link ",orbits[i][j],".");
          return false;
        fi;
        lk:=SCReduceComplex(lk);
        if lk[1] <> true or (lk[1] = true and 
          SCFVector(lk[2]) <> [6,15,20,15,6]) then
          Info(InfoSimpcomp,2,"SCIsManifoldEx: could not reduce link ",
            orbits[i][j],".");
          return fail;
        fi;
      od;
    fi;


    for j in [1..Size(orbits[i])] do
      if j mod 500 = 0 then
        Info(InfoSimpcomp,5,"SCIsManifoldEx: ",Int(100*j/Size(orbits[i])),
          "% done...");
      fi;
      lk:=SCLink(c,orbits[i][j]);
      if i = dim-2 then
        if SCEulerCharacteristic(lk) <> 2 then
          return false;
        fi;
      else
        sc:=SCIsSimplyConnected(lk);
        if sc = false then
          Info(InfoSimpcomp,2,"SCIsManifoldEx: found non-simply ",
            "connected link ",orbits[i][j],".");
          return false;
        fi;
        if sc <> true then
          Info(InfoSimpcomp,2,"SCIsManifoldEx: could not determine simply ",
            "connectivity of link ",orbits[i][j],".");
          return fail;
        fi;

        hom:=SCHomology(lk);
        if ForAny(hom{[1..Size(hom)-1]},x->x <> [0,[]]) or 
          hom[Size(hom)] <> [1,[]] then
          return false;
        fi;
      fi;
    od;
    Info(InfoSimpcomp,2,"SCIsManifoldEx: links in dimension \t",i-1,"\tok.");
  od;

  if quasi then
    Info(InfoSimpcomp,2,"SCIsManifoldEx: WARNING: assuming Smooth Poincare ",
      "conjecture.");
  fi;

  return true;
end);


################################################################################
##<#GAPDoc Label="SCIsManifold">
## <ManSection>
## <Func Name="SCIsManifold" Arg="c"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## The algorithm is a heuristic method and is described in 
## <Cite Key="Paixao143SphereRec" /> in more detail.
## Internally calls <Ref Func="SCIsManifoldEx" />.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,20);;
## gap> SCIsManifold(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsManifold,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(c)
  return false;
end);

InstallMethod(SCIsManifold,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)
  return SCIsManifoldEx(c);
end);

################################################################################
##<#GAPDoc Label="SCIsSphere">
## <ManSection>
## <Func Name="SCIsSphere" Arg="c"/>
## <Returns>a boolean value upon success, <C>fail</C> otherweise.</Returns>
## <Description>
## Determines whether the <C>SCSimplicialComplex</C> object <Arg>c</Arg>
## is a topological sphere.
## In dimension <M>\neq 4</M> the algorithm determines whether <Arg>c</Arg>
## is PL-homeomorphic to the standard sphere. In dimension <M>4</M>
## the PL type is not specified. The algorithm uses a result due to 
## <Cite Key="Kirby77PLStructures" />
## stating that, in dimension <M>\neq 4</M>, any simply connected homology 
## sphere with PL structure
## is a standard PL sphere. The function calls 
## <Ref Meth="SCIsSimplyConnected" /> which uses
## a heuristic method described in <Cite Key="Paixao143SphereRec" />.
## <Example><![CDATA[
## gap> c:=SCBdCyclicPolytope(4,20);;
## gap> SCIsSphere(c);
## gap> c:=SCSurface(1,true);;
## gap> SCIsSphere(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsSphere,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(c)
  return false;
end);

InstallMethod(SCIsSphere,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(c)
  local mfld,sc,hom,dim;

  dim:=SCDim(c);
  if dim = fail then
    return fail;
  fi;

  if dim = 0 then
    return Size(SCFacets(c))=2;
  fi;

  if dim = 1 then
    return SCIsPseudoManifold(c) and not SCHasBoundary(c) and SCIsConnected(c);
  fi;

  if dim = 4 then
    Info(InfoSimpcomp,2,"SCIsSphere: WARNING, result is only valid up to ",
      "homeomorphy.");
  fi;

  hom:=SCHomology(c);
  if hom = fail then
    return fail;
  fi;
  if ForAny(hom{[1..Size(hom)-1]},x->x <> [0,[]]) or 
    hom[Size(hom)] <> [1,[]] then
    return false;
  fi;

  mfld:=SCIsManifold(c);
  if mfld = fail then
    return fail;
  fi;

  sc:=SCIsSimplyConnected(c);
  if sc = fail then
    return fail;
  fi;

  return mfld and sc;
end);
