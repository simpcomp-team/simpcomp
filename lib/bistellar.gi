################################################################################
##
##  simpcomp / bistellar.gi
##
##  Functions for bistellar moves  
##
##  $Id$
##
################################################################################

################################################################################
##<#GAPDoc Label="SCBistellarOptions">
## <ManSection>
## <Var Name="SCBistellarOptions"/>
## <Description>
## Record of global variables to adjust output an behavior of bistellar moves 
## in <Ref Func="SCIntFunc.SCChooseMove"/> and <Ref Func="SCReduceComplexEx"/> 
## respectively.
## <Enum>
## <Item><C>BaseRelaxation</C>: determines the length of the relaxation period. 
## Default: <M>3</M></Item>
## <Item><C>BaseHeating</C>: determines the length of the heating period. 
## Default: <M>4</M></Item>
## <Item><C>Relaxation</C>: value of the current relaxation period. Default: 
## <M>0</M></Item>
## <Item><C>Heating</C>: value of the current heating period. Default: 
## <M>0</M></Item>
## <Item><C>MaxRounds</C>: maximal over all number of bistellar flips that 
## will be performed. Default: <M>500000</M></Item>
## <Item><C>MaxInterval</C>: maximal number of bistellar flips that will be 
## performed without a change of the <M>f</M>-vector of the moved complex. 
## Default: <M>100000</M></Item>
## <Item><C>Mode</C>: flip mode, <M>0</M>=reducing, <M>1</M>=comparing, 
## <M>2</M>=reduce as sub-complex, <M>3</M>=randomize. Default: <M>0</M> 
## </Item>
## <Item><C>WriteLevel</C>: <M>0</M>=no output, <M>1</M>=storing of every 
## vertex minimal complex to user library, <M>2</M>=e-mail notification. 
## Default: <M>1</M> </Item>
## <Item><C>MailNotifyIntervall</C>: (minimum) number of seconds between 
## two e-mail notifications. Default: 
## <M>24 \cdot 60 \cdot 60</M> (one day)</Item>
## <Item><C>MaxIntervalIsManifold</C>: maximal number of bistellar flips that 
## will be performed without a change of the <M>f</M>-vector of a vertex link 
## while trying to prove that the complex is a combinatorial manifold. Default:
## <M>5000</M></Item>
## <Item><C>MaxIntervalRandomize := 50</C>: number of flips performed to create 
## a randomized sphere. Default: <M>50</M></Item>
## </Enum>
## <Example><![CDATA[
## gap> SCBistellarOptions.BaseRelaxation;
## 3
## gap> SCBistellarOptions.BaseHeating;
## 4
## gap> SCBistellarOptions.Relaxation;
## 0
## gap> SCBistellarOptions.Heating;
## 0
## gap> SCBistellarOptions.MaxRounds;
## 500000
## gap> SCBistellarOptions.MaxInterval;
## 100000
## gap> SCBistellarOptions.Mode;
## 0
## gap> SCBistellarOptions.WriteLevel;
## 1
## gap> SCBistellarOptions.MailNotifyInterval;
## 86400
## gap> SCBistellarOptions.MaxIntervalIsManifold;
## 5000
## gap> SCBistellarOptions.MaxIntervalRandomize;
## 50
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallValue(SCBistellarOptions,
rec(
  BaseRelaxation:=3,
  BaseHeating:=4,
  Relaxation:=0,
  Heating:=0,
  MaxRounds:=500000,
  MaxInterval:=100000,
  Mode:=0,
  WriteLevel:=0,
  MailNotifyInterval:=24*60*60,
  MaxIntervalIsManifold:=5000,
  MaxIntervalRandomize:=50
));
MakeReadWriteGlobal("SCBistellarOptions");

################################################################################
##
#F SCIntFunc.IRawBistellarRMoves (< r>,<faces>, <max >
##                    [,<mode>,<complex >])
##
##
##
## INPUT:      r: codimension of faces that are about to be examined
##              ("testelement")
##             sComplex: simplicial Complex by faces
##             max: Size of maximal Elements of sComplex (max-1) =
##              Dimension of complex
##
## OUTPUT:     rawOptions: vector containing all possible candidates for r-moves
##
## DESCRIPTION:
##
## Initial options for moves (and reverse moves)
## (Reverse_k_Move=(max-k-1)-move)
##
## Test for all (dim-r)-dimensional faces "testelement" whether there are
## exactly (r + 1) maximal faces "maxface" containing "testelement".
## If this is true return all vertices of those maximal faces ("linkface"), and
## "testelement" in rawOptions[r+1] (#(raw_element[r+1])<=#(faces[max-r]))
##
## EXAMPLE:
## r:=1;
## faces[max]:=[[1,2,3],[2,3,4], ...];
## faces[max-r]:=[[1,2],[2,3],[3,1],[2,4],[3,4], ...];
## raw_options[r+1]:=[[[2,3],[1,4]],[...], ...];
##
## r:=2;
## faces[max]:=[[1,2,3],[1,2,4],[1,3,4],[2,3,5],[2,4,6],[2,5,6], ...];
## faces[max-r]:=[[1],[2],[3],[4],[5],[6], ...];
## raw_options[r+1]:=[[[1],[2,3,4]],[...], ...];
## [[2],[1,3,4,5,6]] not in raw_options[r+1]
##
## Elements in raw_options[r+1] -> canditates for r-moves
## changes of global vars:
## raw_options[r+1] -> all faces in "faces[max-r]" which are contained in (r+1)
## maximal faces, including all vertices of those maximal faces.
##
SCIntFunc.IRawBistellarRMoves:=function(arg)

  local testelement, linkface, rawOptions, r, faces, max, 
    mode, complex, hd, idx, i, j, base, tmp;

  if Size(arg)<3 or Size(arg)=4 or Size(arg)>5 then
    Info(InfoSimpcomp,2,"SCIntFunc.IRawBistellarRMoves: number of arguments ",
      "must be 3 or 5");
    return fail;
  fi;
  r:=arg[1];
  faces:=arg[2];
  max:=arg[3];
  if Size(arg)=5 then
    mode:=arg[4];
    complex:=arg[5];
  fi;
  rawOptions:=[];

  # build Hasse diagram section
  hd:=List([1..Size(faces[max-r])],x->[]);
  
  idx:=Combinations([1..max],max-r);  

  for i in [1..Size(faces[max])] do
    for j in idx do
      base:=faces[max][i]{j};
      Add(hd[PositionSorted(faces[max-r],base)],i);
    od;
  od;

  for i in [1..Size(hd)] do
    if Size(hd[i]) <> r+1 then continue; fi;
    linkface:=Union(faces[max]{hd[i]});
    testelement:=faces[max-r][i];
    SubtractSet(linkface,testelement);
    if Size(arg)=3 or mode<>4 then
      Add(rawOptions,[testelement,linkface]);
    else
      if Size(linkface)>0 and linkface in complex[Size(linkface)] then
        Add(rawOptions,[testelement,linkface]);
        fi;
    fi;
  od;

  return rawOptions;
end;

################################################################################
##
#F SCIntFunc.IBistellarRMoves (< r>,<max>,<rawOptions>,<faces >)
##
## Include options for moves (and reverse moves)
## Test for all elements in "raw_options[r+1]" whether they are
## really candidates for a r-move or not.
##
## EXAMPLE:
## r:=0;
## faces[max]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]]; (2-sphere)
## faces[max-r]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]];
## raw_options[r+1]:=[[[1,2,3],[]],[[2,3,4],[]],[[1,3,4],[]],[[1,2,4],[]]];
## r:=1;
## faces[max]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]]; (2-sphere)
## faces[max-r]:=[[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]];
## raw_options[r+1]:=[[[1,2],[3,4]],[[1,3],[2,4]],[[1,4],[2,4]],[[2,3],[1,4]],
## [[2,4],[1,3]],[[[3,4],[1,2]]];
## r:=2;
## faces[max]:=[[1,2,3],[2,3,4],[1,3,4],[1,2,4]]; (2-sphere)
## faces[max-r]:=[[1],[2],[3],[4]];
## raw_options[r+1]:=[[[1],[2,3,4]],[[2],[1,3,4]],
## [[3],[1,2,4]],[[4],[1,2,3]]];
##
## but: [1,2] -> [3,4] in faces[2], etc. ...
##      [1] -> [2,3,4] in faces[3], etc. ...
## -> options:=[[[1,2,3],[]],[[2,3,4],[]],[[1,3,4],[]],[[1,2,4],[]]];
##
SCIntFunc.IBistellarRMoves:=function(r,max,rawOptions,faces)

  local element, options;

  options:=[];

  for element in rawOptions do
    # case element[1] in faces[max] (-> element[2]=[])
    if element[2]<>[] then
      # case "linkface" element[2] of element[1] isn't already
      # contained in the simplicial complex
      if not element[2] in faces[Length(element[2])] then
        Add(options,element);
      fi;
    elif element[2]=[] then
      Add(options,element);
    fi;
  od;

  #options :=Set(options);
  return options;

end;


###################################################################
###                Moves (and reverse moves)                    ###
###################################################################

################################################################################
##
#F SCIntFunc.BallBoundary (< max >,<faces>,<raw_options>,
##    < ball_boundary_faces>,<mode,complex >)
##
## test all elements in "ball_boundary_faces" whether they can be flipped or
## not (in this case, add them to "raw_options") (this routine is part
## of every r-move (at the end))
##
SCIntFunc.BallBoundary:=function(max,faces,raw_options,ball_boundary_faces,
    mode,complex)

  local element, j, count, linkface, maxface;

  element:=[];
  for j in ball_boundary_faces do
    element:=Union(element,j);
  od;
  if Size(element)>(max+1) or Size(element)<(max) then
    Info(InfoSimpcomp,2,"SCIntFunc.BallBoundary: wrong ball boundary faces - ",
      "wrong number\nof vertices: ",element,".");
    return fail;
  fi;

  for element in ball_boundary_faces do

    count:=0;
    linkface:=[];
    for maxface in faces[max] do
      if IsSubset(maxface,element)=true  then
        count:=count+1;
        UniteSet(linkface,maxface);
      fi;
    od;
    # linkface -> all vertices that are not in "element" but in a maximal
    # face containing "element".
    SubtractSet(linkface,element);

    # If "element" occurs in "raw_options[max-Length[element]+1]]", remove it.
    j:=1;
    while j<=Length(raw_options[max-Length(element)+1]) do
      if element=raw_options[max-Length(element)+1][j][1] then
        RemoveSet(raw_options[max-Length(element)+1],
                  raw_options[max-Length(element)+1][j]);
        j:=Length(raw_options[max-Length(element)+1]);
      fi;
      j:=j+1;
    od;

    # If "element" is contained in exactly "max - Length(element) + 1" maximal
    # faces, add it again to "raw_options" (with a
    # possibly different set "linkface")
    if count=max - Length(element) + 1 then
      if (linkface=[] and Size(element)=max) or
        (linkface<>[] and Size(element)+Size(linkface)=max + 1) then
        if(mode<>4) then
          AddSet(raw_options[max-Size(element)+1],[element,linkface]);
        else
          if Size(linkface)>0 and linkface in complex[Size(linkface)] then
            AddSet(raw_options[max-Size(element)+1],[element,linkface]);
          fi;
        fi;
      else
        Info(InfoSimpcomp,1,"SCIntFunc.BallBoundary: wrong flip added: ",
          [element,linkface]);
        return fail;
      fi;
    fi;
  od;

  return raw_options;

end;

################################################################################
##
#F SCIntFunc.ZeroMove (< max>,<faces>,<F >,<raw_options>, 
##  <mode>,   < randomelement>,<complex >)
##
## realizes a 0-move (i.e. f[1] -> f[1] + 1, ..., f[max] -> f[max] + dim)
#
## FURTHER EXPLANATION:
##
## A "0-move" subdivides a maximal (dim-)simplex into (dim+1)=max
## (dim-)simplices, coned over a new vertex in its center (see Paper
## "Simplicial Manifolds..." by Lutz/Björner for a formal definition of
## bistellar k-moves)
##
SCIntFunc.ZeroMove:=function(max,faces,F,randomelement,raw_options,mode,complex)

  local element, i, j, A, linkface, maxface, maxvertex, ball_boundary_faces;

  if randomelement[2]=[] then
    maxvertex:=MaximumList(faces[1])+1;
    maxvertex:=maxvertex[1];
  elif Size(randomelement[2])=1 then
    maxvertex:=randomelement[2][1];
  else
    Info(InfoSimpcomp,1,"SCIntFunc.ZeroMove: Ivalid type of 0_Move ",
      "(Size(randomelement[2])>1)");
    return fail;
  fi;

  # first part: "M \ (A * Bd(B))" (from the formal definition)...
  # ...where M=faces[max], A=randomelement[1], B=new vertex "[maxvertex]"
  # (-> Bd(B) =  [])
  RemoveSet(faces[max],randomelement[1]);
  F[max]:=F[max]-1;
  if raw_options<>[] then
    RemoveSet(raw_options[1],randomelement);
  fi;

  # second part: "(Bd(A) * B)"... (see above)
  for i in [0..(max-1)] do
    for element in Combinations(randomelement[1],i) do
      # add new elements to triangulation "faces"
      A:=[maxvertex];
      UniteSet(A,element);
      AddSet(faces[i+1],A);
      F[i+1]:=F[i+1]+1;

      if raw_options<>[] then
        # add new possible flip-operations
        linkface:=[];
        for maxface in Combinations(randomelement[1],max-1) do
          if IsSubset(maxface,element)=true  then
            UniteSet(linkface,maxface);
          fi;
        od;
        SubtractSet(linkface,element);

        if (linkface=[] and Size(A)=max) or (linkface<>[] and 
          Size(A)+Size(linkface)=max + 1) then
          if mode<>4 then
            AddSet(raw_options[max+1-Size(A)],[A,linkface]);
          else
            if Size(linkface)>0 and linkface in complex[Size(linkface)] then
              AddSet(raw_options[max+1-Size(A)],[A,linkface]);
            fi;
          fi;
        else
          Info(InfoSimpcomp,1,"SCIntFunc.ZeroMove: wrong flip added: ",
            [A,linkface]);
        fi;
      fi;
    od;
  od;

  if raw_options<>[] then
    # get all faces of boundary of simplex...
    ball_boundary_faces:=[];
    for i in [1..(max-1)] do
      UniteSet(ball_boundary_faces,Combinations(randomelement[1],i));
    od;

    # ... and check if they can be added to "raw_options"
    raw_options :=   SCIntFunc.BallBoundary(max,faces,raw_options,
      ball_boundary_faces,mode,complex);
    if raw_options=fail then
      return fail;
    fi;
  fi;
  return [faces,F,raw_options];

end;


################################################################################
##
#F SCIntFunc.Move (< r>,<max>,<faces>,<F>,<randomelement>,
##    < raw_options> ,<mode>,<complex>)
##
## realizes a r-move
##
SCIntFunc.Move:=function(r,max,faces,F,randomelement,raw_options,mode,complex)

  local element, i, j, A, count, maxface, linkface,
       new_facets, ball_interior_faces, ball_boundary_faces, tmp;

  if r=0 then
    tmp:=SCIntFunc.ZeroMove(max,faces,F,randomelement,raw_options,mode,complex);
    if tmp=fail then
      return fail;
    fi;
    faces:=tmp[1];
    F:=tmp[2];
    raw_options:=tmp[3];
  else
    for i in [0..r] do
      # for all (i-1)-dimensional faces of "linkface" of "(random-)element"
      for element in Combinations(randomelement[2],i) do
        # first part: "(M \ A * Bd(B))" -> remove (A * Bd(B))
        A:=[];
        UniteSet(A,randomelement[1]);
        UniteSet(A,element);
        # A -> (max - r + i - 1)-dimensional face of "facets"
        RemoveSet(faces[max-r+i],A);
        # update f-vector
        F[max-r+i]:=F[max-r+i]-1;
        if F[max-r+i]<>Size(faces[max-r+i]) then
          Info(InfoSimpcomp,1,"SCIntFunc.Move: invalid flip was performed.\n",
            A," not in complex.");
          return fail;
        fi;
        if raw_options<>[] then
          # update "raw_options"
          # remove flips, which involve the recently removed element "A" 
          # of "faces"
          for j in [1..Size(raw_options[r-i+1])] do
            if A=raw_options[r-i+1][j][1] then
              RemoveSet(raw_options[r-i+1],raw_options[r-i+1][j]);
              break;
            fi;
          od;
        fi;
      od;
    od;

    # second part: add "(Bd(A) * B)" to M
    new_facets:=[];
    ball_interior_faces:=[];

    for i in [0..(max-r-1)] do
      for element in Combinations(randomelement[1],i) do
        A:=[];
        UniteSet(A,randomelement[2]);
        UniteSet(A,element);
        # i in [0..(max-r-1)] -> (r + 1)<=(r + i + 1)<=max=(dim + 1)
        AddSet(faces[r+i+1],A);
        # update f-vector
        F[r+i+1]:=F[r+i+1]+1;
        if F[r+i+1]<>Size(faces[r+i+1]) then
          Info(InfoSimpcomp,1,"SCIntFunc.Move: invalid flip was performed:\n",
            A," is already in mainComplex.");
          return fail;
        fi;
        # if i is maximal, add A to the array "new_facets", if not, add it to
        # "ball_interior_faces"
        if i=max - r - 1 then
          AddSet(new_facets,A);
        else
          AddSet(ball_interior_faces,A);
        fi;
      od;
    od;

    # new_facets: Set of all maximal dimensional facets of the form
    # A=Union(Combinations(randomelement[1],(max-r-1)),randomelement[2])
    # second part: "add (Bd(A) * B) to M"
    for i in [0..(max-r-1)] do
      for element in Combinations(randomelement[1],i) do
        A:=[];
        UniteSet(A,randomelement[2]);
        UniteSet(A,element);

        # get "linkface" of A -> all maximal facets that contain A minus A
        linkface:=[];
        for maxface in new_facets do
          if IsSubset(maxface,A)=true  then
            UniteSet(linkface,maxface);
          fi;
        od;
        SubtractSet(linkface,A);

        if raw_options<>[] then
          # update options vector "raw_options"
          if (linkface=[] and Size(A)=max) or (linkface<>[] and 
            Size(A)+Size(linkface)=max + 1) then
            if(mode<>4) then
              AddSet(raw_options[max-Size(A)+1],[A,linkface]);
            else
              if Size(linkface)>0 and linkface in complex[Size(linkface)] then
                AddSet(raw_options[max-Size(A)+1],[A,linkface]);
              fi;
            fi;
          else
            Info(InfoSimpcomp,1,"SCIntFunc.Move: wrong flip added: ",
              [A,linkface]);
            return fail;
          fi;
        fi;
      od;
    od;

    if raw_options<>[] then
      # get all surrounding facets
      ball_boundary_faces:=[];
      for element in new_facets do
        for i in [1..(max-1)] do
          UniteSet(ball_boundary_faces,Combinations(element,i));
        od;
      od;
      SubtractSet(ball_boundary_faces,ball_interior_faces);

      raw_options:=SCIntFunc.BallBoundary(max,faces,raw_options,
        ball_boundary_faces,mode,complex);
      if raw_options=fail then
        return fail;
      fi;
    fi;

  fi;

  return [faces,F,raw_options];

end;

################################################################################
##<#GAPDoc Label="SCIsMovableComplex">
## <ManSection>
## <Meth Name="SCIsMovableComplex" Arg="complex"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.
## </Returns>
## <Description>
## Checks if a simplicial complex <Arg>complex</Arg> can be modified by 
## bistellar moves, i. e. if it is a pure simplicial complex which fulfills 
## the weak pseudomanifold property with empty boundary.<P/>
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> SCIsMovableComplex(c);
## true
## ]]></Example>
## Complex with non-empty boundary:
## <Example><![CDATA[
## gap> c:=SC([[1,2],[2,3],[3,4],[3,1]]);;
## gap> SCIsMovableComplex(c);
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsMovableComplex,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

  local pure, pm, bd, dim;
  
  dim :=SCDim(complex);
  if dim = fail then
    return fail;
  fi;
  
  if dim < 1 then
    Info(InfoSimpcomp,2,"SCIsMovableComplex: complex dimension is smaller ",
      "than 1, no bistellar moves are possible.");
    return false;
  fi;

  pure := SCIsPure(complex);
  if pure = fail then
    return fail;
  fi;
  
  if pure = false then
    return false;
  fi;
  
  pm := SCIsPseudoManifold(complex);
  if pm = fail then
    return fail;
  fi;
  
  if pm = false then
    return false;
  fi;
  
  bd := SCHasBoundary(complex);
  if bd = fail then
    return fail;
  fi;
  if bd = true then
    return false;
  fi;
  
  return true;

end);

################################################################################
##<#GAPDoc Label="SCRMoves">
## <ManSection>
## <Meth Name="SCRMoves" Arg="complex, r"/>
## <Returns> a list of pairs of the form <C>[ list, list ]</C>, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## A bistellar <M>r</M>-move of a <M>d</M>-dimensional combinatorial manifold 
## <Arg>complex</Arg> is a <M>r</M>-face <M>m_1</M> together with a 
## <M>d-r</M>-tuple <M>m_2</M> where <M>m_1</M> is a common face of exactly 
## <M>(d+1-r)</M> facets and <M>m_2</M> is not a face of <Arg>complex</Arg>.<P/>
## The <M>r</M>-move removes all facets containing <M>m_1</M> and replaces 
## them by the <M>(r+1)</M> faces obtained by uniting <M>m_2</M> with any 
## subset of <M>m_1</M> of order <M>r</M>.<P/>
## The resulting complex is PL-homeomorphic to <Arg>complex</Arg>. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> moves:=SCRMoves(c,1);
## [ [ [ 1, 3 ], [ 5, 6 ] ], [ [ 1, 4 ], [ 5, 6 ] ], [ [ 1, 5 ], [ 3, 4 ] ], 
##   [ [ 1, 6 ], [ 3, 4 ] ], [ [ 2, 3 ], [ 5, 6 ] ], [ [ 2, 4 ], [ 5, 6 ] ], 
##   [ [ 2, 5 ], [ 3, 4 ] ], [ [ 2, 6 ], [ 3, 4 ] ], [ [ 3, 5 ], [ 1, 2 ] ], 
##   [ [ 3, 6 ], [ 1, 2 ] ], [ [ 4, 5 ], [ 1, 2 ] ], [ [ 4, 6 ], [ 1, 2 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCRMoves,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,r)

  local tmp, options, dim, faces;

  dim:=SCDim(complex);
    if dim=fail then
      return fail;
  fi;
  
  if dim < 1 then
    SCPropertyTmpSet(complex,"Moves",[]);
    return [];
  fi;  
  
  
  if dim < r then
    return [];
  fi;  
  
  options:=SCPropertyTmpByName(complex,"Moves");
  if options<>fail and IsBound(options[r+1]) then
    return options[r+1];
  else
    if not SCIsMovableComplex(complex) then
      Info(InfoSimpcomp,2,"SCRMoves: argument should be a closed ",
        "pseudomanifold");
      return fail;
    fi;
    faces:=SCFaceLatticeEx(complex);
    if faces=fail then
      return fail;
    fi;

    if options=fail then
      options:=[];
    fi;
    tmp:=SCIntFunc.IRawBistellarRMoves(r,faces,dim+1);
    if tmp=fail then
      return fail;
    fi;
    options[r+1]:=SCIntFunc.IBistellarRMoves(r+1,dim+1,tmp,faces);

    SCPropertyTmpSet(complex,"Moves",options);
    return options[r+1];
  fi;

end);


################################################################################
##<#GAPDoc Label="SCMoves">
## <ManSection>
## <Meth Name="SCMoves" Arg="complex"/>
## <Returns> a list of list of pairs of lists upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## See <Ref Meth="SCRMoves"/> for further information.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> moves:=SCMoves(c);
## [
## # 0-moves
##   [[[1, 3, 5], []], [[1, 3, 6], []], [[1, 4, 5], []], 
##     [[1, 4, 6], []], [[2, 3, 5], []], [[2, 3, 6], []],
##     [[2, 4, 5], []], [[2, 4, 6], []]], 
## # 1-moves
##   [[[1, 3], [5, 6]], [[1, 4], [5, 6]], [[1, 5], [3, 4]], 
##     [[1, 6], [3, 4]], [[2, 3], [5, 6]], [[2, 4], [5, 6]], 
##     [[2, 5], [3, 4]], [[2, 6], [3, 4]], [[3, 5], [1, 2]], 
##     [[3, 6], [1, 2]], [[4, 5], [1, 2]], [[4, 6], [1, 2]]],
## # 2-moves
##   [] 
##]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCMoves,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

  local i, dim, options;

  dim:=SCDim(complex);

  if dim=fail then
    return fail;
  fi;
  
  if dim < 1 then
    SCPropertyTmpSet(complex,"Moves",[]);
    return [];
  fi;
  
  options:=[];
  for i in [0..dim] do
    options[i+1]:=SCRMoves(complex,i);
    if options[i+1]=fail then
      return fail;
    fi;
  od;
  
  SCPropertyTmpSet(complex,"Moves",options);
  return options;

end);



################################################################################
##<#GAPDoc Label="SCMove">
## <ManSection>
## <Meth Name="SCMove" Arg="c, move"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Applies the bistellar move <Arg>move</Arg> to a simplicial complex 
## <Arg>c</Arg>. <Arg>move</Arg> is given as a <M>(r+1)</M>-tuple together 
## with a <M>(d+1-r)</M>-tuple if <M>d</M> is the dimension of <Arg>c</Arg> 
## and if <Arg>move</Arg> is a <M>r</M>-move. See <Ref Meth="SCRMoves"/> for 
## detailed information about bistellar <M>r</M>-moves.<P/>
## Note: <Arg>move</Arg> and <Arg>c</Arg> should be given in standard 
## labeling to ensure a correct result.
## <Example><![CDATA[
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,1]]);
## gap> moves:=SCMoves(obj);
## [[[[1, 2], []], [[1, 4], []], 
##     [[2, 3], []], [[3, 4], []]], 
##   [[[1], [2, 4]], [[2], [1, 3]], 
##     [[3], [2, 4]], [[4], [1, 3]]]]
## gap> obj:=SCMove(obj,last[2][1]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCMove,
"for SCSimplicialComplex and List",
[SCIsSimplicialComplex,IsList],
function(c, move)

  local dim, moves, r, i, j, faces, f, tmp, options, labels, invLabels, max,
    fvec, fl, complex;

  complex:=SCCopy(c);
  labels:=SCVertices(complex);
  if labels=fail then
    return fail;
  fi;
  max:=SCLabelMax(complex);
  if max=fail then
    return fail;
  fi;
  if labels <> [1..max] then
    Info(InfoSimpcomp,2,"SCMove: complex not in standard labeling, ",
      "relabeling.");
    SCRelabelStandard(complex);
  fi;
  
  if not SCIsMovableComplex(complex) then
    Info(InfoSimpcomp,2,"SCMove: complex not closed or no pseudomanifold");
    return false;
  fi;
  
  dim:=SCDim(complex);
  if dim=fail then
    return fail;
  fi;
  faces:=SCIntFunc.DeepCopy(SCFaceLatticeEx(complex));
  if faces=fail then
    return fail;
  fi;
  f:=ShallowCopy(SCFVector(complex));
  if f=fail then
    return fail;
  fi;
  if Size(move)<>2 or not (Size(move[1]) + Size(move[2]) in [dim+1,dim+2]) then
    Info(InfoSimpcomp,2,"SCMove: 'move' is not a bistellar move");
    return fail;
  fi;
  if move[2]=[] then
    r:=0;
  else
    r:=Size(move[2])-1;
  fi;
  moves:=SCMoves(complex);
  if moves=fail then
    return fail;
  fi;
  if not move in moves[r+1] then
    Info(InfoSimpcomp,2,"SCMove: 'move' not valid (in standard labeling)");
    return fail;
  fi;
  
  tmp:=SCIntFunc.Move(r,dim+1,faces,f,move,moves,1,[]);
  if tmp=fail then
    return fail;
  fi;
  
  if r = dim then
    invLabels:=[];
    labels:=Union(tmp[1][1]);
    for i in [1..Size(labels)] do
      invLabels[labels[i]]:=i;
    od;
    for i in [1..Size(tmp[1])] do
      tmp[1][i]:=SCIntFunc.RelabelSimplexList(tmp[1][i],invLabels);
    od;
    for i in [1..Size(tmp[3])] do
      for j in [1..Size(tmp[3][i])] do
        tmp[3][i][j]:=SCIntFunc.RelabelSimplexList(tmp[3][i][j],invLabels);
      od;
    od;
  fi;
  
  complex:=SCFromFacets(tmp[1][dim+1]);
  if complex=fail then
    return fail;
  fi;
  
  fvec:=[];
  fl:=[];
  for i in [1..Size(tmp[2])] do
    fvec[2*i-1]:=i-1;
    fl[2*i-1]:=i-1;
    fvec[2*i]:=tmp[2][i];
    fl[2*i]:=tmp[1][i];
  od;
  SetComputedSCNumFacess(complex,fvec);
  SetComputedSCSkelExs(complex,fl);
    
  options:=[];
  for r in [1..dim+1] do
    options[r]:=SCIntFunc.IBistellarRMoves(r,dim+1,tmp[3][r],tmp[1]);
  od;
  SCPropertyTmpSet(complex,"Moves",options);

  return complex;

end);

################################################################################
##<#GAPDoc Label="SCIntFunc.SCChooseMove">
## <ManSection>
## <Func Name="SCIntFunc.SCChooseMove" Arg="dim, moves"/>
## <Returns> a bistellar move, i. e. a pair of lists upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## Since the problem of finding a bistellar flip sequence that reduces a 
## simplicial complex is undecidable, we have to use an heuristic approach to 
## choose the next move. <P/> 
## The implemented strategy <C>SCIntFunc.SCChooseMove</C> first tries to 
## directly remove vertices, edges, <M>i</M>-faces in increasing dimension etc. 
## If this is not possible it inserts high dimensional faces in decreasing 
## co-dimension. To do this in an efficient way a number of parameters have 
## to be adjusted, namely <C>SCBistellarOptions.BaseHeating</C> and 
## <C>SCBistellarOptions.BaseRelaxation</C>. See 
## <Ref Var="SCBistellarOptions"/> for further options.
## <P/>
## If this strategy does not work for you, just implement a customized 
## strategy and pass it to <Ref Func="SCReduceComplexEx"/>.<P/>
## See <Ref Meth="SCRMoves" /> for further information.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
SCIntFunc.SCChooseMove:=
  function(dim,moves)

  local i,options;

  options:=[];
  if dim=1 then
  
    Append(options,moves[2]);
    
  elif dim=2 then
  
    Append(options,moves[3]);
    if options=[] then
      Append(options,moves[2]);
    fi;
    
  elif dim=3 then
  
    if SCBistellarOptions.Heating>0 then
      if IsInt(SCBistellarOptions.Heating/15)=true then
        Append(options,moves[1]);
      else
        Append(options,moves[2]);
        if options=[] then
          Append(options,moves[3]);
          SCBistellarOptions.Heating:=0;
        fi;
      fi;
      SCBistellarOptions.Heating:=SCBistellarOptions.Heating-1;
    else
      Append(options,moves[4]);
      if options=[] then
        Append(options,moves[3]);
        if options=[] then
          Append(options,moves[2]);
          if SCBistellarOptions.Relaxation=10 then
            SCBistellarOptions.Heating:=15;
            SCBistellarOptions.Relaxation:=0;
          fi;
          SCBistellarOptions.Relaxation:=SCBistellarOptions.Relaxation+1;
        fi;
      fi;
    fi;
  
  elif dim=4 then
    
    if SCBistellarOptions.Heating>0 then
      if IsInt(SCBistellarOptions.Heating/20)=true then
        Append(options,moves[1]);
      else
        Append(options,moves[2]);
        Append(options,moves[3]);
        if options=[] then
          Append(options,moves[4]);
        fi;
      fi;
      SCBistellarOptions.Heating:=SCBistellarOptions.Heating-1;
    else
      Append(options,moves[5]);
      if options=[] then
        Append(options,moves[4]);
        if options=[] then
          Append(options,moves[3]);
          Append(options,moves[2]);
          if SCBistellarOptions.Relaxation=15 then 
            SCBistellarOptions.Heating:=20;
            SCBistellarOptions.Relaxation:=0;
          fi;
          SCBistellarOptions.Relaxation:=SCBistellarOptions.Relaxation+1;
        fi;
      fi;
    fi;

  elif dim=5 then
  
    if SCBistellarOptions.Heating>0 then
      if IsInt(SCBistellarOptions.Heating/40)=true then
        Append(options,moves[1]);
      else
        Append(options,moves[2]);
        Append(options,moves[3]);  
        Append(options,moves[4]);  
        if options=[] then
          Append(options,moves[5]);            
        fi;
      fi;
      SCBistellarOptions.Heating:=SCBistellarOptions.Heating-1;
    else
      Append(options,moves[6]);
      if options=[] then
        Append(options,moves[5]);
        if options=[] then
          Append(options,moves[4]);
          if options=[] then
            Append(options,moves[2]);
            Append(options,moves[3]);
            if SCBistellarOptions.Relaxation=20 then 
              SCBistellarOptions.Heating:=40;
              SCBistellarOptions.Relaxation:=0;
            fi;
            SCBistellarOptions.Relaxation:=SCBistellarOptions.Relaxation+1;
          fi;
        fi;
      fi;
    fi;
  
  else
  
    if SCBistellarOptions.Heating>0 then
      if IsInt(SCBistellarOptions.Heating/((dim+2)*SCBistellarOptions.BaseHeating))=true 
        and dim>2 then
        Append(options,moves[1]);
      else
        for i in [1..Int((dim+1)/2)] do
          Append(options,moves[i+1]);
        od;
      fi;
      if options=[] then
        for i in [1..(dim+1)] do
          Append(options,moves[dim+2-i]);
          if options<>[] and i>=Int((dim+1)/2)-1 then
            break;
          fi;
        od;
      fi;
      SCBistellarOptions.Heating:=SCBistellarOptions.Heating-1;
    else
      if IsInt((dim+1)/2) then
        for i in [1..Int((dim+1)/2)] do
          Append(options,moves[dim+2-i]);
          if options<>[] then
            break;
          fi;
        od;
      else
        for i in [1..Minimum((Int((dim+1)/2)+1),(dim+1)-1)] do
          Append(options,moves[dim+2-i]);
          if options<>[] then
            break;
          fi;
        od;
      fi;
      if options=[] then
        for i in [1..Minimum((Int((dim+1)/2)+1),(dim+1)-1)] do
          Append(options,moves[i+1]);
          if options<>[] then
            break;
          fi;
        od;
      fi;
      if SCBistellarOptions.Relaxation=(dim+2)*SCBistellarOptions.BaseRelaxation then
        SCBistellarOptions.Heating:=(dim+2)*SCBistellarOptions.BaseHeating;
        SCBistellarOptions.Relaxation:=0;
      fi;
      SCBistellarOptions.Relaxation:=SCBistellarOptions.Relaxation+1;
    fi;
    options:=Set(options);
  
  fi;
  
  # choosing move at random
  if options=[] then
    return [];
  else
    return RandomList(options);
  fi;

end;


################################################################################
##<#GAPDoc Label="SCExamineComplexBistellar">
## <ManSection>
## <Meth Name="SCExamineComplexBistellar" Arg="complex"/>
## <Returns> simplicial complex passed as argument with additional properties 
## upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the face lattice, the <M>f</M>-vector, the AS-determinant, the 
## dimension and the maximal vertex label of <Arg>complex</Arg>.
## <Example><![CDATA[
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]);
## gap> SCExamineComplexBistellar(obj);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCExamineComplexBistellar,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

  local dim, moves, faces, f,
        det, matrix, movable;


  movable := SCIsMovableComplex(complex);
  if movable = fail then
    return fail;
  fi;
  if not movable then
    Info(InfoSimpcomp,2,"SCExamineComplexBistellar: 'complex' not closed or ",
      "no pseudomanifold");
    return fail;
  fi;
  f:=SCFVector(complex);
  if f=fail then
    return fail;
  fi;
  det:=SCAltshulerSteinberg(complex);
  if det=fail then
    return fail;
  fi;
  dim:=SCDim(complex);
  if dim=fail then
    return fail;
  fi;
  moves:=SCMoves(complex);
  if moves=fail then
    return fail;
  fi;

  return complex;
  
end);


################################################################################
##<#GAPDoc Label="SCReduceComplexEx">
## <ManSection>
## <Func Name="SCReduceComplexEx" Arg="complex, refComplex, 
## mode, choosemove"/>
## <Returns><C>SCBistellarOptions.WriteLevel=0</C>: a triple of the form 
## <C>[ boolean, simplicial complex, rounds  ]</C> upon termination of the 
## algorithm.<P/>
## <C>SCBistellarOptions.WriteLevel=1</C>: A library of simplicial complexes 
## with a number of complexes from the reducing process and (upon termination) 
## a triple of the form <C>[ boolean, simplicial complex, rounds ]</C>.<P/>
## <C>SCBistellarOptions.WriteLevel=2</C>: A mail in case a smaller version 
## of <Arg>complex1</Arg> was found, a library of simplicial complexes with 
## a number of complexes from the reducing process and (upon termination) a 
## triple of the form <C>[ boolean, simplicial complex, rounds ]</C>.<P/>
## Returns <K>fail</K> upon an error.</Returns>
## <Description>
## Reduces a pure simplicial complex <Arg>complex</Arg> satisfying the weak 
## pseudomanifold property via bistellar moves <Arg>mode = 0</Arg>, compares 
## it to the simplicial complex <Arg>refComplex</Arg> (<Arg>mode = 1</Arg>) or 
## reduces it as a sub-complex of <Arg>refComplex</Arg> 
## (<Arg>mode = 2</Arg>).<P/>
## <Arg>choosemove</Arg> is a function containing a flip strategy, see also 
## <Ref Func="SCIntFunc.SCChooseMove"/>. <P/>
## The currently smallest complex is stored to the variable <C>minComplex</C>, 
## the currently smallest <M>f</M>-vector to <C>minF</C>. Note that in general 
## the algorithm will not stop until the maximum number of rounds is reached. 
## You can adjust the maximum number of rounds via the property 
## <Ref Var="SCBistellarOptions"/>. The number of rounds performed is returned 
## in the third entry of the triple returned by this function.<P/>
## This function is called by
## <Enum>
## <Item> <Ref Meth="SCReduceComplex" Style="Text"/>,</Item>
## <Item> <Ref Meth="SCEquivalent" Style="Text"/>,</Item>
## <Item> <Ref Meth="SCReduceAsSubcomplex" Style="Text"/>,</Item>
## <Item> <Ref Meth="SCBistellarIsManifold" Style="Text"/>.</Item>
## <Item> <Ref Meth="SCRandomize" Style="Text"/>.</Item>
## </Enum>
## Please see <Ref Func="SCMailIsPending"/> for further information about the 
## email notification system in case <C>SCBistellarOptions.WriteLevel</C> is 
## set to <M>2</M>.<P/>
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save complexes                      
## gap> SCReduceComplexEx(c,SCEmpty(),0,SCIntFunc.SCChooseMove);
## gap> SCReduceComplexEx(c,SCEmpty(),0,SCIntFunc.SCChooseMove);
## gap> SCMailSetAddress("johndoe@somehost");   
## true
## gap> SCMailIsEnabled();                     
## true
## gap> SCReduceComplexEx(c,SCEmpty(),0,SCIntFunc.SCChooseMove);
## ]]></Example>
## Content of sent mail:
## <Example><![CDATA[ NOEXECUTE
## Greetings master,
## 
## this is simpcomp 0.0.0 running on comp01.maths.fancytown.edu
##
## I have been working hard for 0 seconds and have a message for you, see below.
## 
## #### START MESSAGE ####
## 
## SCReduceComplex:
## 
## Computed locally minimal complex after 7 rounds:
## 
## [SimplicialComplex
## 
##  Properties known: Boundary, Chi, Date, Dim, F, Faces, Facets, G, H,
##  HasBoundary, Homology, IsConnected, IsManifold, IsPM, Name, SCVertices,
##  Vertices.
## 
##  Name="ReducedComplex_5_vertices_7"
##  Dim=3
##  Chi=0
##  F=[ 5, 10, 10, 5 ]
##  G=[ 0, 0 ]
##  H=[ 1, 1, 1, 1 ]
##  HasBoundary=false
##  Homology=[ [ 0, [ ] ], [ 0, [ ] ], [ 0, [ ] ], [ 1, [ ] ] ]
##  IsConnected=true
##  IsPM=true
## 
## /SimplicialComplex]
## 
## ##### END MESSAGE #####
## 
## That's all, I hope this is good news! Have a nice day.
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCReduceComplexEx,
  function(complex,refComplex,mode,choosemove)

  local move,moves,validMoves,rounds,minF,name,globalRounds,minComplex,
    refFaces,msg,elapsed,stime,i,j,equivalent,time,rep,tmpFaces,tmpF,
    tmpOptions,dim,tmp,refF;

  dim:=SCDim(complex);
  if dim = fail then
    return fail;
  fi;
  
  if dim <= 0 then
    return [true,complex,0];
  fi;
  
  SCBistellarOptions.Mode:=0;
  globalRounds:=0;
  rounds:=0;
  stime:=SCIntFunc.TimerStart();

  if stime=fail then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: can not start timer.");
    return fail;
  fi;

  if SCBistellarOptions.WriteLevel>=1 then
    time:=SCIntFunc.GetCurrentTimeString();
    if(time=fail) then
      return fail;
    fi;
    # TODO: FIX: paths cannot be given like that
    rep:=SCLibInit(Concatenation(SCIntFunc.UserHome,"/reducedComplexes/",time));
  fi;
  equivalent:=false;
  
  complex:=SCExamineComplexBistellar(complex);
  if complex=fail then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: can not compute complex ",
      "properties.");
    return fail;
  fi;

  minF:=SCIntFunc.DeepCopy(SCFVector(complex));
  if minF=fail then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: error calculating f-vector.");
    return fail;
  fi;
  
  minComplex:=complex;

  #init moves
  tmpFaces:=SCIntFunc.DeepCopy(SCFaceLatticeEx(complex));
  if tmpFaces = fail then
    return fail;
  fi;
  tmpF:=ShallowCopy(SCFVector(complex));
  if tmpF = fail then
    return fail;
  fi;
  
  tmpOptions:=[];
  for i in [1..dim+1] do
    tmpOptions[i]:=SCIntFunc.IRawBistellarRMoves(i-1,tmpFaces,dim+1);
    if tmpOptions[i]=fail then
      Info(InfoSimpcomp,1,"SCReduceComplexEx: no ",i-1,"-moves found.");
      return fail;
    fi;
    tmpOptions[i]:=SCIntFunc.IBistellarRMoves(i,dim+1,tmpOptions[i],tmpFaces);
  od;
  
  if mode=2 then
    if not SCIsSubcomplex(refComplex,complex) then
      Info(InfoSimpcomp,1,"SCReduceComplexEx: complex is not a sub-complex.");
      return fail;
    fi;

    refFaces:=SCFaceLatticeEx(refComplex);    
    if refFaces=fail then
      return fail;
    fi;
  fi;
  
  if mode = 1 then
    refF:=SCFVector(refComplex);
    
    if refF=fail then
      return fail;
    fi;
  fi;

    
  
  #loop..
  while rounds < SCBistellarOptions.MaxInterval and 
    globalRounds < SCBistellarOptions.MaxRounds do
    
    if mode=1 then
      if tmpF = refF then 
        equivalent:=SCIsIsomorphic(SCFromFacets(tmpFaces[dim+1]),refComplex);
      fi;
      if equivalent=fail then
        Info(InfoSimpcomp,1,"SCReduceComplexEx: can not compute isomorphism ",
          "between complexes.");
        return fail;
      fi;      
    fi;
    
    if mode<>1 or equivalent=false then
      if mode=2 then
        # remove bistellar moves that can't be performed in supercomplex
        # 'refComplex'
        validMoves:=[];
        validMoves[1]:=[];
        for i in [2..Size(tmpOptions)] do
          validMoves[i]:=[];
          for move in tmpOptions[i] do
            if move[2] in refFaces[Size(move[2])] then
              Add(validMoves[i],move);
            fi;
          od;
        od;
        tmpOptions:=validMoves;
      fi;

      #choose a move
#      move:=choosemove(dim,tmpOptions,tmpF,globalRounds);
      move:=choosemove(dim,tmpOptions);
      if move=fail then
        Info(InfoSimpcomp,1,"SCReduceComplexEx: error in flip strategy.");
        return fail;
      fi;

      if move<>[] then
        #move length
        i:=Length(move[2]);
        if(i>0) then
          i:=i-1;
        fi;

        #do move
        tmp:=SCIntFunc.Move(i,dim+1,tmpFaces,tmpF,move,tmpOptions,1,[]);
        
        tmpFaces:=tmp[1];
        tmpF:=tmp[2];
        
        for i in [1..dim+1] do
          tmpOptions[i]:=SCIntFunc.IBistellarRMoves(i,dim+1,tmp[3][i],tmpFaces);        
        od;
        
        Info(InfoSimpcomp,3,"round ",globalRounds,", move: ",move,"\nF: ",tmpF);
        rounds:=rounds+1;
        
        if tmpF<minF then
          rounds := 0;
          minComplex:=SCFromFacets(tmpFaces[dim+1]);

          if minComplex=fail then
            return fail;
          fi;

          Info(InfoSimpcomp,2,"round ",globalRounds,"\nReduced complex, F: ",tmpF);
          
          if tmpF[1]<minF[1] or rounds>SCBistellarOptions.MaxInterval then
            if SCBistellarOptions.WriteLevel>=1 then
              name:=Concatenation(["ReducedComplex_",String(tmpF[1]),
                "_vertices_",String(globalRounds)]);
              if minComplex<>fail and name<>fail and rep<>fail then
                SCRename(minComplex,name);
                SCLibAdd(rep,minComplex);
              else
                Info(InfoSimpcomp,1,"SCReduceComplexEx: illegal complex, ",
                  "name or rep.");
                return fail;
              fi;
            fi;
            if SCBistellarOptions.WriteLevel=2 then
              msg:=Concatenation(["SCReduceComplex:\n\nReduced complex after ",
                String(globalRounds)," rounds:\n\n",String(minComplex),"\n"]);
              SCMailSend(msg,stime);
            fi;
          fi;
          minF:=ShallowCopy(tmpF);
        fi;

        globalRounds:=globalRounds+1;

        if(globalRounds mod 1000000=0 and SCBistellarOptions.WriteLevel=2) then
          elapsed:=SCIntFunc.TimerElapsed();
          if elapsed=fail then
            return fail;
          fi;
          if(SCIntFunc.TimerElapsed()>=SCBistellarOptions.MailNotifyInterval) then
            SCIntFunc.TimerStart();
            msg:=Concatenation(["SCReduceComplex:\n\nStatus report after ",
              String(globalRounds)," rounds:\n\n",String(minComplex),
              "\n\nMinimal complex so far:\n\n",String(minComplex)]);
            SCMailSend(msg,stime);
          fi;
        fi;

      else
        # no moves available
        if SCBistellarOptions.WriteLevel>=1 then
          name:=Concatenation(["ReducedComplex_",String(tmpF[1]),"_vertices_",
            String(globalRounds)]);
          SCRename(minComplex,name);
          SCLibAdd(rep,minComplex);
        fi;
        if SCBistellarOptions.WriteLevel=2 then
          msg:=Concatenation(["SCReduceComplex:\n\nComputed locally minimal ",
            "complex after ",String(globalRounds)," rounds:\n\n",
            String(minComplex),"\n"]);
          SCMailClearPending();
          SCMailSend(msg,stime,true);
        fi;
        if mode=1 then
          Info(InfoSimpcomp,1,"SCReduceComplexEx: could not prove bistellar ",
            "equivalence between 'complex' and 'refComplex'\n(reached local ",
            "minimum after  ",String(globalRounds)," rounds).");
        elif mode<>1 then
          Info(InfoSimpcomp,2,"SCReduceComplexEx: computed locally minimal ",
            "complex after ",String(globalRounds)," rounds.");
        fi;
        
        if mode=1 then
          return [fail,minComplex,globalRounds];
        elif mode=3 then
          return [fail,SCFromFacets(tmpFaces[dim+1]),globalRounds];
        else
          return [true,minComplex,globalRounds];
        fi;
      fi;
    else
      # equivalent<>false and mode=1 -> bistellarly equivalent
      if SCBistellarOptions.WriteLevel>=1 then
        name:=Concatenation(["ReducedComplex_",String(tmpF[1]),"_vertices_",
          String(globalRounds)]);
        SCRename(minComplex,name);
        SCLibAdd(rep,minComplex);
      fi;

      if SCBistellarOptions.WriteLevel=2 then
        msg:=Concatenation(["SCReduceComplexEx:\n\nComplexes are bistellarly ",
          "equivalent.\n\n",String(minComplex),"\n"]);
        SCMailClearPending();
        SCMailSend(msg,stime,true);
      fi;
      if mode=1 then
        Info(InfoSimpcomp,1,"SCReduceComplexEx: complexes are bistellarly ",
          "equivalent.");
      fi;

      if mode <> 3 then
        return [true,minComplex,globalRounds];
      else
        return [true,SCFromFacets(tmpFaces[dim+1]),globalRounds];
      fi;
    fi;
  od;

  if SCBistellarOptions.WriteLevel>=1 then
    name:=Concatenation(["ReducedComplex_",String(tmpF[1]),"_vertices_",
      String(globalRounds)]);
    SCRename(minComplex,name);
    SCLibAdd(rep,minComplex);
  fi;

  if SCBistellarOptions.WriteLevel=2 then
    msg:=Concatenation(["SCReduceComplexEx:\n\nReached maximal number of ",
      "rounds ",String(globalRounds)," rounds. Reduced complex to:\n\n",
        String(minComplex),"\n"]);
    SCMailClearPending();
    SCMailSend(msg,stime,true);
  fi;
  
  if mode=1 then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: could not prove bistellar ",
      "equivalence between 'complex' and 'refComplex'.");
  elif mode<>1 and mode <> 3 then
    Info(InfoSimpcomp,2,"SCReduceComplexEx: reached maximal number of ",
      "rounds. Returning smallest complex found.");
  fi;

  if mode <> 3 then
#    return [fail,minComplex,globalRounds];
    return [fail,SC(tmpFaces[dim+1]),globalRounds];
  else
    return [fail,SCFromFacets(tmpFaces[dim+1]),globalRounds];
  fi;

end);

################################################################################
##<#GAPDoc Label="SCReduceComplex">
## <ManSection>
## <Meth Name="SCReduceComplex" Arg="complex"/>
## <Returns> <C>SCBistellarOptions.WriteLevel=0</C>: a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C> upon termination 
## of the algorithm.<P/>
## <C>SCBistellarOptions.WriteLevel=1</C>: A library of simplicial complexes 
## with a number of complexes from the reducing process and (upon termination) 
## a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## <C>SCBistellarOptions.WriteLevel=2</C>: A mail in case a smaller version 
## of <Arg>complex1</Arg> was found, a library of simplicial complexes with a 
## number of complexes from the reducing process and (upon termination) a 
## triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## Returns <K>fail</K> upon an error..</Returns>
## <Description>
## Reduces a pure simplicial complex <Arg>complex</Arg> satisfying the weak 
## pseudomanifold property via bistellar moves. 
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text" />
## <C>(complex,SCEmpty(),0,SCIntFunc.SCChooseMove);</C>
## <Example><![CDATA[
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]);; # hexagon
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save complexes                      
## gap> tmp := SCReduceComplex(obj);
## #I  round 0, move: [ [ 6 ], [ 1, 5 ] ]
## [ 5, 5 ]
## #I  round 1, move: [ [ 4 ], [ 3, 5 ] ]
## [ 4, 4 ]
## #I  round 2, move: [ [ 3 ], [ 2, 5 ] ]
## [ 3, 3 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 3 rounds.
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCReduceComplex,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex) 
  return SCReduceComplexEx(complex,SCEmpty(),0,SCIntFunc.SCChooseMove);
end);


################################################################################
##<#GAPDoc Label="SCEquivalent">
## <ManSection>
## <Meth Name="SCEquivalent" Arg="complex1, complex2"/>
## <Returns> <K>true</K> or <K>false</K> upon success, <K>fail</K> or a list 
## of type <C>[ fail, SCSimplicialComplex, Integer, facet list]</C> 
## otherwise.</Returns>
## <Description>
## Checks if the simplicial complex <Arg>complex1</Arg> (which has to fulfill 
## the weak pseudomanifold property with empty boundary) can be reduced to the 
## simplicial complex <Arg>complex2</Arg> via bistellar moves, i. e. if 
## <Arg>complex1</Arg> and <Arg>complex2</Arg> are <M>PL</M>-homeomorphic. 
## Note that in general the problem is undecidable. In this case <K>fail</K> 
## is returned.<P/>
## It is recommended to use a minimal triangulation <Arg>complex2</Arg> for 
## the check if possible.<P/>
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text"/>
## <C>(complex1,complex2,1,SCIntFunc.SCChooseMove);</C>
## <Example><![CDATA[
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save complexes to disk
## gap> obj:=SC([[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]]);; # hexagon
## gap> refObj:=SCBdSimplex(2);; # triangle as a (minimal) reference object
## gap> SCEquivalent(obj,refObj);
## #I  round 0: [ 5, 5 ]
## #I  round 1: [ 4, 4 ]
## #I  round 2: [ 3, 3 ]
## #I  SCReduceComplexEx: complexes are bistellarly equivalent.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCEquivalent,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2) 
  
  local dim1, dim2, pm1, pm2, hom1, hom2, ret;  
  
  dim1:=SCDim(complex1);
  if dim1=fail then
    return fail;
  fi;
  dim2:=SCDim(complex2);
  if dim2=fail then
    return fail;
  fi;
  if dim1<>dim2 then 
    return false;
  fi;
  pm1:=SCIsMovableComplex(complex1);
  if pm1=fail then
    return fail;
  fi;
  pm2:=SCIsMovableComplex(complex2);
  if pm2=fail then
    return fail;
  fi;
  if pm1<>pm2 then 
    return false;
  fi;
  if pm1=false then
    Info(InfoSimpcomp,2,"SCEquivalent: complexes should be closed ",
      "pseudomanifolds");
    return fail;
  fi;
  hom1:=SCHomology(complex1);
  if hom1=fail then
    return fail;
  fi;
  hom2:=SCHomology(complex2);
  if hom2=fail then
    return fail;
  fi;
  if hom1<>hom2 then 
    return false;
  fi;
  
  ret:=SCReduceComplexEx(complex1,complex2,1,SCIntFunc.SCChooseMove);
  
  if(ret<>fail) then
    return ret[1];
  else
    return fail;
  fi;
  
end);

################################################################################
##<#GAPDoc Label="SCReduceAsSubcomplex">
## <ManSection>
## <Meth Name="SCReduceAsSubcomplex" Arg="complex1, complex2"/>
## <Returns> <C>SCBistellarOptions.WriteLevel=0</C>: a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed  ]</C> upon termination 
## of the algorithm.<P/>
## <C>SCBistellarOptions.WriteLevel=1</C>: A library of simplicial complexes 
## with a number of complexes from the reducing process and (upon termination) 
## a triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## <C>SCBistellarOptions.WriteLevel=2</C>: A mail in case a smaller version of 
## <Arg>complex1</Arg> was found, a library of simplicial complexes with a 
## number of complexes from the reducing process and (upon termination) a 
## triple of the form 
## <C>[ boolean, simplicial complex, rounds performed ]</C>.<P/>
## Returns <K>fail</K> upon an error.</Returns>
## <Description>
## Reduces a  simplicial complex <Arg>complex1</Arg> (satisfying the weak 
## pseudomanifold property with empty boundary) as a sub-complex of the 
## simplicial complex <Arg>complex2</Arg>. <P/> 
## Main application: Reduce a sub-complex of the cross polytope without 
## introducing diagonals.
## <P/>
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text"  />
## <C>(complex1,complex2,2,SCIntFunc.SCChooseMove);</C>
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,3],[3,5],[4,5],[4,1]]);;
## gap> SCBistellarOptions.WriteLevel:=0;; # do not save any complexes                      
## gap> SCReduceAsSubcomplex(c,SCBdCrossPolytope(3));
## #I  round 0, move: [ [ 2 ], [ 1, 4 ] ]
## [ 3, 3 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 1 rounds.
##]]></Example>
##</Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCReduceAsSubcomplex,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2) 
  
  return SCReduceComplexEx(complex1,complex2,2,SCIntFunc.SCChooseMove);
  
end);

################################################################################
##<#GAPDoc Label="SCBistellarIsManifold">
## <ManSection>
## <Meth Name="SCBistellarIsManifold" Arg="complex"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> 
## otherwise.</Returns> 
## <Description>
## Tries to prove that a closed simplicial <M>d</M>-pseudomanifold is a 
## combinatorial manifold by reducing its vertex links to the boundary of the 
## d-simplex.<P/>
## <K>false</K> is returned if it can be proven that there exists a vertex link 
## which is not PL-homeomorphic to the standard PL-sphere, <K>true</K> is 
## returned if all vertex links are bistellarly equivalent to the boundary of 
## the simplex, <K>fail</K> is returned if the algorithm does not terminate 
## after the number of rounds indicated by 
## <C>SCBistellarOptions.MaxIntervallIsManifold</C>.<P/>
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text"/>
## <C>(link,SCEmpty(),0,SCIntFunc.SCChooseMove);</C> for every link of 
## <Arg>complex</Arg>. Note that <K>false</K> is returned in case of a bounded 
## manifold.<P/>
##
## See <Ref Func="SCIsManifoldEx" /> and <Ref Func="SCIsManifold" /> for 
## alternative methods for manifold verification.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(3);;
## gap> SCBistellarIsManifold(c);
## #I  SCBistellarIsManifold: processing vertex link 1/6
## #I  round 0: [ 3, 3 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 1 rounds.
## #I  SCBistellarIsManifold: link is sphere.
## ...
## #I  SCBistellarIsManifold: processing vertex link 6/6
## #I  round 0: [ 3, 3 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 1 rounds.
## #I  SCBistellarIsManifold: link is sphere.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCBistellarIsManifold,
function(complex) 
  
  local links, result, f, linkidx, verts, writelevel, maxrounds,
    type, movable, dim, manifold, im,t;
    
  if HasSCIsManifold(complex) then
    return SCIsManifold(complex);
  fi;
    
  dim :=SCDim(complex);
  if dim = fail then
    return fail;
  fi;
  verts:=SCVertices(complex);
  if verts=fail then
    Info(InfoSimpcomp,2,"SCBistellarIsManifold: complex has no vertex labels.");
    return fail;
  fi;
  
  if SCIsEmpty(complex) then
    Info(InfoSimpcomp,2,"SCBistellarIsManifold: complex is empty.");
      SetSCIsManifold(complex,false);
      return false;
  fi;
  if dim = 0 then
    im:=Size(verts)=2;
      SetSCIsManifold(complex,im);
      return im;
  fi;
  
  links:=SCLinks(complex,0);
  if fail in links then
    return fail;
  fi;
  
  maxrounds:=SCBistellarOptions.MaxInterval;
  SCBistellarOptions.MaxInterval:=SCBistellarOptions.MaxIntervalIsManifold;
  writelevel:=SCBistellarOptions.WriteLevel;
  SCBistellarOptions.WriteLevel:=0;
  
  for linkidx in [1..Length(links)] do
  
    SCRelabelStandard(links[linkidx]);
    Info(InfoSimpcomp,2,"SCBistellarIsManifold: processing vertex link ",
      verts[linkidx],"/",Length(verts));
    f:=links[linkidx].F[1];
    if f = fail then
      return fail;
    fi;
    if dim = 1 and f = 2 then
      continue;
    elif dim = 1 and f <> 2 then
      Info(InfoSimpcomp,2,"SCBistellarIsManifold: link is no sphere.");
      SetSCIsManifold(complex,false);
      return false;
    fi;
    
    movable:=SCIsMovableComplex(links[linkidx]);
    if movable = fail then
      Info(InfoSimpcomp,2,"SCBistellarIsManifold: complex check failed. ",
        "Invalid link.");
      return fail;
    fi;
  
    if movable then
      result:=SCReduceComplexEx(links[linkidx],SCEmpty(),0,
        SCIntFunc.SCChooseMove);
    else
      Info(InfoSimpcomp,2,"SCBistellarIsManifold: link ",linkidx,
        " is not a closed pseudomanifold.");
      SetSCIsManifold(complex,false);
      return false;
    fi;
    
    if result=fail then  
      Info(InfoSimpcomp,1,"SCBistellarIsManifold: SCReduceComplexEx ",
        "returned fail.");
      return fail;
    fi;
    
    if result[1]=true then
      f:=SCFVector(result[2]);
      if f = fail then
        return fail;
      fi;
      if f[1]<>f[Size(f)] or f[1]<>(Size(f)+1) then
        Info(InfoSimpcomp,2,"SCBistellarIsManifold: link is no sphere.");
        type:=SCLibDetermineTopologicalType(SCLib,result[2]);
        if type<>fail and type<>[] then
          if(Length(type)=1) then
            Info(InfoSimpcomp,2,"SCBistellarIsManifold: link is the following ",
              "complex:\n",type,".");
          else
            Info(InfoSimpcomp,2,"SCBistellarIsManifold: link could be PL ",
              "equivalnet to one of the following complexes specified by ",
              "their global library ids:\n",type,".");
          fi;
        else
          Info(InfoSimpcomp,2,"SCBistellarIsManifold: link is not in global ",
            "library.");
        fi;
        SetSCIsManifold(complex,false);
        return false;
      else
        Info(InfoSimpcomp,2,"SCBistellarIsManifold: link is sphere.");
        if HasSCAutomorphismGroupTransitivity(complex) and 
          SCAutomorphismGroupTransitivity(complex)>0 then
          Info(InfoSimpcomp,2,"SCBistellarIsManifold: transitive automorphism ",
            "group, checking only one link.");
          SetSCIsManifold(complex,true);
          return true;
        fi;
      fi;
    else
      Info(InfoSimpcomp,2,"SCBistellarIsManifold: maximum rounds reached, ",
        "check link ",linkidx,".");
      return fail;
    fi;
  od;
  
  SCBistellarOptions.MaxInterval:=maxrounds;
  SCBistellarOptions.WriteLevel:=writelevel;
  SetSCIsManifold(complex,true);
  return true;
  
end);

################################################################################
##<#GAPDoc Label="SCIsKStackedSphere">
## <ManSection>
## <Meth Name="SCIsKStackedSphere" Arg="complex, k"/>
## <Returns>a list upon success, <K>fail</K> otherwise.</Returns> 
## <Description>
## Checks, whether the given simplicial complex <Arg>complex</Arg> that must 
## be a PL <M>d</M>-sphere is a <Arg>k</Arg>-stacked sphere with 
## <M>1\leq k\leq \lfloor\frac{d+2}{2}\rfloor</M> using a randomized algorithm 
## based on bistellar moves (see 
## <Cite Key="Effenberger09StackPolyTightTrigMnf" />,
## <Cite Key="Effenberger10Diss" />). Note that it is not checked whether 
## <Arg>complex</Arg> is a PL sphere -- if not, the algorithm will not succeed.
## Returns a list upon success: the first entry is a boolean, where 
## <K>true</K>  means that the complex is <C>k</C>-stacked and <K>false</K> 
## means that the complex cannot be <Arg>k</Arg>-stacked. A value of -1 means 
## that the question could not be decided. The second argument contains a 
## simplicial complex that, in case of success, contains the trigangulated 
## <M>(d+1)</M>-ball <M>B</M> with <M>\partial B=S</M> and 
## <M>\operatorname{skel}_{d-k}(B)=\operatorname{skel}_{d-k}(S)</M>, 
## where <M>S</M> denotes the simplicial complex passed in 
## <Arg>complex</Arg>.<P/>   
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text" />.
## <Example><![CDATA[
## gap> SCLib.SearchByName("S^4~S^1");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> l:=SCLink(c,1);
## gap> SCIsKStackedSphere(l,1);
## #I  SCIsKStackedSphere: try 1/50
## #I  round 0: [ 11, 40, 70, 65, 26 ]
## #I  round 1: [ 10, 35, 60, 55, 22 ]
## #I  round 2: [ 9, 30, 50, 45, 18 ]
## #I  round 3: [ 8, 25, 40, 35, 14 ]
## #I  round 4: [ 7, 20, 30, 25, 10 ]
## #I  round 5: [ 6, 15, 20, 15, 6 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 6 rounds.
## 1
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIsKStackedSphereOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsPosInt],
function(complex,k) 
  
  local d, f, h, links, result, linkidx, verts, writelevel, maxrounds,
    type, movable, ks, cc, try, maxtries, kStackedStrategy, ball, tmp, l, i;
    
  
  kStackedStrategy:=function(dim,moves)
    local options,i,tmp;
  
    #allow reverse 0..(k-1)-moves
    options:=[];
    for i in [0..k-1] do
      Append(options,moves[dim+1-i]);
    od;
    
    #choose move at random
    if options=[] then
      return [];
    else
      tmp:=RandomList(options);
      #save move to reconstruct filled sphere later
      Add(ball,Union(tmp));
      return tmp;
    fi;
  end;
  
  if(k <= 0 or k > Int((SCDim(complex)+2)/2)) then
    Info(InfoSimpcomp,1,"SCIsKStackedSphere: second argument must be a ",
      "positive integer k with 1 <= k <= \\lfloor ",
      "(SCDim(complex)+2)/2 \\rfloor.");
    return fail;
  fi;

  if HasComputedSCIsKStackedSpheres(complex) then
    l:=ComputedSCIsKStackedSpheres(complex);
    for i in [1..Size(l)] do
      if not IsBound(l[i]) then
        continue;
      fi;
      if IsList(l[i]) and l[i][1] = true then
        if IsBound(l[i-1]) and l[i-1] <= k then
          Info(InfoSimpcomp,1,"SCIsKStackedSphere: complex is even (at least) a ",
            l[i-1],"-stacked sphere.");
          return l[i];
        fi;
        break;
      fi;
    od;
  fi;
  
  
  d:=SCDim(complex);
  f:=SCFVector(complex);
  h:=SCIsHomologySphere(complex);
  
  if(d=fail or h=fail or f=fail) then
    Info(InfoSimpcomp,1,"SCIsKStackedSphere: error computing dimension, f-vector, or homology.");
    return fail;
  fi;
  
  if(h<>true) then
    Info(InfoSimpcomp,1,"SCIsKStackedSphere: first argument must be a PL ",
      "manifold -- passed complex is not even a homology sphere.");
    return [false,SCEmpty()];
  fi;
  
  #set bistellar flip options
  maxrounds:=Sum(f)*10;
  SCBistellarOptions.MaxInterval:=SCBistellarOptions.MaxIntervalIsManifold;
  writelevel:=SCBistellarOptions.WriteLevel;
  SCBistellarOptions.WriteLevel:=0;
  
  Info(InfoSimpcomp,1,"SCIsKStackedSphere: checking if complex is a ",
    k,"-stacked sphere...");  
  
  if k = 1 then
    maxtries:=1;
  else
    maxtries:=50;
  fi;
  for try in [1..maxtries] do

    cc:=SCCopy(complex);
    SCRelabelStandard(cc);
      
    Info(InfoSimpcomp,1,Concatenation("SCIsKStackedSphere: try ",
      String(try),"/",String(maxtries)));
    
    movable:=SCIsMovableComplex(cc);
    if movable = fail then
      Info(InfoSimpcomp,1,"SCIsKStackedSphere: invalid complex.");
      return fail;
    fi;
    
    if movable then
      ball:=[]; #construct ball with skel_d-k(ball)=skel_d-k(sphere)
      result:=SCReduceComplexEx(cc,SCEmpty(),0,kStackedStrategy);
    else
      Info(InfoSimpcomp,1,"SCIsKStackedSphere: complex is not a closed ",
        "pseudomanifold.");
          return [false,SCEmpty()];
    fi;
    
    if result=fail then  
      Info(InfoSimpcomp,1,"SCIsKStackedSphere: SCReduceComplexEx ",
        "returned fail.");
      return fail;
    fi;
    
    
    if result[1]=true then
      f:=SCFVector(result[2]);
      
      if(f=fail) then
        return fail;
      fi;
      
      if (result[3]=0 and f[1]<>d+2) or (k=1 and f[1]<>d+2) then
        #could not reduce to boundary of a simplex. not k-stacked? 
        Info(InfoSimpcomp,1,"SCIsKStackedSphere: complex is not a ",
          k,"-stacked sphere.");
          return [false,SCEmpty()];
      fi;
      
      if f[1]=d+2 and f[1]=f[Size(f)] then
        #reduced to boundary of a simplex. k-stacked.
        Info(InfoSimpcomp,1,"SCIsKStackedSphere: complex is a ",
          k,"-stacked sphere.");
        tmp:=SCFacets(result[2]); #get facets of reduced complex
        if(tmp=fail) then
          return fail;
        fi;
        
        #add last simplex to ball = filled sphere
        ball:=Set(ball);
        AddSet(ball,Union(tmp));
        
        ball:=SCFromFacets(ball);
        
        if(ball=fail) then
          Info(InfoSimpcomp,1,"SCIsKStackedSphere: something is wrong with ",
            "the facet list of the constructed ball that should be a filled ",
            "version of the sphere passed as complex. Please contact the ",
            "authors/maintainers of simpcomp.");
          return fail;
        fi;
        
        SCRename(ball,Concatenation("Filled ",String(k),"-stacked sphere (",
          String(SCName(complex)),")"));
        return [true,ball];
      fi;
    fi;
  od;
  
  SCBistellarOptions.MaxInterval:=maxrounds;
  SCBistellarOptions.WriteLevel:=writelevel;
  
  Info(InfoSimpcomp,1,"SCIsKStackedSphere: could not determine whether ",
    "given complex is a ",k,"-stacked sphere.");
  return fail;
end);

################################################################################
##<#GAPDoc Label="SCRandomize">
## <ManSection>
## <Func Name="SCRandomize" Arg="complex [ [, rounds] [,allowedmoves] ]"/>
## <Returns>a simplicial complex upon success, <K>fail</K> otherwise.</Returns> 
## <Description>
## Randomizes the given simplicial complex <Arg>complex</Arg> via bistellar 
## moves chosen at random. By passing the optional array 
## <Arg>allowedmoves</Arg>, which has to be a dense array of integer values 
## of length <C>SCDim(complex)</C>, certain moves can be allowed or forbidden 
## in the proccess. An entry <C>allowedmoves[i]=1</C> allows <M>(i-1)</M>-moves 
## and an entry <C>allowedmoves[i]=0</C> forbids <M>(i-1)</M>-moves in the 
## randomization process.<P />With optional positive integer argument 
## <Arg>rounds</Arg>, the amount of randomization can be controlled. The 
## higher the value of <Arg>rounds</Arg>, the more bistellar moves will be 
## randomly performed on <Arg>complex</Arg>. Note that the argument 
## <Arg>rounds</Arg> overrides the global setting 
## <C>SCBistellarOptions.MaxIntervalRandomize</C> (this value is used, if 
## <Arg>rounds</Arg> is not specified).       
## Internally calls <Ref Func="SCReduceComplexEx" Style="Text" />.
## <Example><![CDATA[
## gap> c:=SCRandomize(SCBdSimplex(4));
## gap> c.F;
## [ 20, 85, 130, 65 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCRandomize,
function(arg) 
  
  local p,complex,tcomplex,allowedmoves,writelevel,maxrounds,d,f,i,movable,
    rounds,result,randomizeStrategy,arounds;
    
  randomizeStrategy:=function(dim,moves)
    local options,i;
  
    options:=[];
    for i in [0..d] do
      if(allowedmoves[i+1]<>0) then
        if((i>0 and i<d) or (i=0 and (rounds mod 2)=0) or 
          (i=d and (rounds mod 2)=1)) then
          Append(options,moves[i+1]);
        fi;
      fi;
    od;
    
    rounds:=rounds+1;
    
    # choosing move at random
    if options=[] then
      return [];
    else
      return RandomList(options);
    fi;
  end;
  
  if(Length(arg)<1 or not SCIsSimplicialComplex(arg[1])) then
    Info(InfoSimpcomp,2,"SCRandomize: invalid argument list, first argument ",
      "must be of type SCSimplicialComplex.");
    return fail;
  fi;
  
  complex:=arg[1];
  d:=SCDim(complex);
  f:=SCFVector(complex);
  
  if(d=fail or f=fail) then
    return fail;
  fi;

  if(Length(arg)>1 and IsInt(arg[2])) then
    arounds:=arg[2];
  else
    arounds:=0;
  fi;
    
  if(Length(arg)>1 and IsList(arg[2]) and not IsEmpty(arg[2]) 
    and ForAll(arg[2],x->(x=0 or x=1))) then
    p:=2;
  elif(Length(arg)>2 and IsList(arg[3]) and not IsEmpty(arg[3]) 
    and ForAll(arg[3],x->(x=0 or x=1))) then
    p:=3;
  else
    p:=0;
  fi;
  
  if(p<>0) then
    allowedmoves:=arg[p];
  else
    allowedmoves:=ListWithIdenticalEntries(d+1,1);
    allowedmoves[1]:=-1;
  fi;
  
  for i in [1..d+1] do
    if(not IsBound(allowedmoves[i])) then
      allowedmoves[i]:=1;
    fi;
  od;
  

  
  movable:=SCIsMovableComplex(complex);
  if movable = fail then
    Info(InfoSimpcomp,2,"SCRandomize: invalid complex.");
    return fail;
  fi;
  
  Info(InfoSimpcomp,2,"SCRandomize: randomizing complex ",SCName(complex),
    " with allowed moves ",allowedmoves);
  
  maxrounds:=SCBistellarOptions.MaxInterval;
  
  if(arounds<>0) then
    SCBistellarOptions.MaxInterval:=arounds;
  else  
    SCBistellarOptions.MaxInterval:=SCBistellarOptions.MaxIntervalRandomize;
  fi;
  
  
  
  writelevel:=SCBistellarOptions.WriteLevel;
  SCBistellarOptions.WriteLevel:=0;
  
  rounds:=0;
  result:=SCReduceComplexEx(complex,SCEmpty(),3,randomizeStrategy);

  SCBistellarOptions.MaxInterval:=maxrounds;
  SCBistellarOptions.WriteLevel:=writelevel;
    
  if result=fail then  
    Info(InfoSimpcomp,2,"SCRandomize: SCReduceComplexEx returned fail.");
    return fail;
  fi;
  
  tcomplex:=result[2];
  if(tcomplex<>fail) then
    SCRename(tcomplex,Concatenation("Randomized ",SCName(complex)));
  fi;
  
  return tcomplex;  
end);





SCIntFunc.SCReduceComplexEx2:=
  function(complex,refComplex,mode,choosemove)

  local move,moves,validMoves,rounds,minF,name,globalRounds,minComplex,
    refFaces,msg,elapsed,stime,i,j,equivalent,time,rep,tmpFaces,tmpF,
    tmpOptions,dim,tmp,refF;

  dim:=SCDim(complex);
  if dim = fail then
    return fail;
  fi;
  
  if dim <= 0 then
    return [true,complex,0];
  fi;
  
  SCBistellarOptions.Mode:=0;
  globalRounds:=0;
  rounds:=0;
  stime:=SCIntFunc.TimerStart();

  if stime=fail then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: can not start timer.");
    return fail;
  fi;

  if SCBistellarOptions.WriteLevel>=1 then
    time:=SCIntFunc.GetCurrentTimeString();
    if(time=fail) then
      return fail;
    fi;
    rep:=SCLibInit(Concatenation(SCIntFunc.UserHome,"/reducedComplexes/",time));
  fi;
  equivalent:=false;
  
  complex:=SCExamineComplexBistellar(complex);
  if complex=fail then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: can not compute complex ",
      "properties.");
    return fail;
  fi;

  minF:=SCIntFunc.DeepCopy(SCFVector(complex));
  if minF=fail then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: error calculating f-vector.");
    return fail;
  fi;
  
  minComplex:=complex;

  #init moves
  tmpFaces:=SCIntFunc.DeepCopy(SCFaceLatticeEx(complex));
  if tmpFaces = fail then
    return fail;
  fi;
  tmpF:=ShallowCopy(SCFVector(complex));
  if tmpF = fail then
    return fail;
  fi;
  
  tmpOptions:=[];
  for i in [1..dim+1] do
    tmpOptions[i]:=SCIntFunc.IRawBistellarRMoves(i-1,tmpFaces,dim+1);
    if tmpOptions[i]=fail then
      Info(InfoSimpcomp,1,"SCReduceComplexEx: no ",i-1,"-moves found.");
      return fail;
    fi;
    tmpOptions[i]:=SCIntFunc.IBistellarRMoves(i,dim+1,tmpOptions[i],tmpFaces);
  od;
  
  if mode=2 then
    if not SCIsSubcomplex(refComplex,complex) then
      Info(InfoSimpcomp,1,"SCReduceComplexEx: complex is not a sub-complex.");
      return fail;
    fi;

    refFaces:=SCFaceLatticeEx(refComplex);    
    if refFaces=fail then
      return fail;
    fi;
  fi;
  
  if mode = 1 then
    refF:=SCFVector(refComplex);
    
    if refF=fail then
      return fail;
    fi;
  fi;

    
  
  #loop..
  while rounds < SCBistellarOptions.MaxInterval and 
    globalRounds < SCBistellarOptions.MaxRounds do
    
    if mode=1 then
      if tmpF = refF then 
        equivalent:=SCIsIsomorphic(SCFromFacets(tmpFaces[dim+1]),refComplex);
      fi;
      if equivalent=fail then
        Info(InfoSimpcomp,1,"SCReduceComplexEx: can not compute ",
          "isomorphism between complexes.");
        return fail;
      fi;      
    fi;
    
    if mode<>1 or equivalent=false then
      if mode=2 then
        # remove bistellar moves that can't be performed in supercomplex
        # 'refComplex'
        validMoves:=[];
        validMoves[1]:=[];
        for i in [2..Size(tmpOptions)] do
          validMoves[i]:=[];
          for move in tmpOptions[i] do
            if move[2] in refFaces[Size(move[2])] then
              Add(validMoves[i],move);
            fi;
          od;
        od;
        tmpOptions:=validMoves;
      fi;

      #choose a move
      move:=choosemove(dim,tmpOptions);
      if move=fail then
        Info(InfoSimpcomp,1,"SCReduceComplexEx: error in flip strategy.");
        return fail;
      fi;

      if move<>[] then
        #move length
        i:=Length(move[2]);
        if(i>0) then
          i:=i-1;
        fi;

        #do move
        tmp:=SCIntFunc.Move(i,dim+1,tmpFaces,tmpF,move,tmpOptions,1,[]);
        
        tmpFaces:=tmp[1];
        tmpF:=tmp[2];
        
        for i in [1..dim+1] do
          tmpOptions[i]:=SCIntFunc.IBistellarRMoves(i,dim+1,tmp[3][i],tmpFaces);        
        od;
        
        Info(InfoSimpcomp,3,"round ",globalRounds,", move: ",move,"\nF: ",tmpF);
        rounds:=rounds+1;
        
        if tmpF<minF then
          rounds := 0;
          minComplex:=SCFromFacets(tmpFaces[dim+1]);

          if minComplex=fail then
            return fail;
          fi;

          Info(InfoSimpcomp,2,"round ",globalRounds,"\nReduced complex, F: ",
            tmpF);
          
          if tmpF[1]<minF[1] or rounds>SCBistellarOptions.MaxInterval then
            if SCBistellarOptions.WriteLevel>=1 then
              name:=Concatenation(["ReducedComplex_",String(tmpF[1]),
                "_vertices_",String(globalRounds)]);
              if minComplex<>fail and name<>fail and rep<>fail then
                SCRename(minComplex,name);
                SCLibAdd(rep,minComplex);
              else
                Info(InfoSimpcomp,1,"SCReduceComplexEx: illegal complex, ",
                  "name or rep.");
                return fail;
              fi;
            fi;
            if SCBistellarOptions.WriteLevel=2 then
              msg:=Concatenation(["SCReduceComplex:\n\nReduced complex after ",
                String(globalRounds)," rounds:\n\n",String(minComplex),"\n"]);
              SCMailSend(msg,stime);
            fi;
          fi;
          minF:=ShallowCopy(tmpF);
        fi;

        globalRounds:=globalRounds+1;

        if(globalRounds mod 1000000=0 and SCBistellarOptions.WriteLevel=2) then
          elapsed:=SCIntFunc.TimerElapsed();
          if elapsed=fail then
            return fail;
          fi;
          if(SCIntFunc.TimerElapsed()>=SCBistellarOptions.MailNotifyInterval) then
            SCIntFunc.TimerStart();
            msg:=Concatenation(["SCReduceComplex:\n\nStatus report after ",
              String(globalRounds)," rounds:\n\n",String(minComplex),
              "\n\nMinimal complex so far:\n\n",String(minComplex)]);
            SCMailSend(msg,stime);
          fi;
        fi;

      else
        # no moves available
        if SCBistellarOptions.WriteLevel>=1 then
          name:=Concatenation(["ReducedComplex_",String(tmpF[1]),
            "_vertices_",String(globalRounds)]);
          SCRename(minComplex,name);
          SCLibAdd(rep,minComplex);
        fi;
        if SCBistellarOptions.WriteLevel=2 then
          msg:=Concatenation(["SCReduceComplex:\n\nComputed locally minimal ",
            "complex after ",String(globalRounds)," rounds:\n\n",
            String(minComplex),"\n"]);
          SCMailClearPending();
          SCMailSend(msg,stime,true);
        fi;
        if mode=1 then
          Info(InfoSimpcomp,1,"SCReduceComplexEx: could not prove bistellar ",
          "equivalence between 'complex' and 'refComplex'\n(reached local ",
          "minimum after  ",String(globalRounds)," rounds).");
        elif mode<>1 then
          Info(InfoSimpcomp,2,"SCReduceComplexEx: computed locally minimal ",
            "complex after ",String(globalRounds)," rounds.");
        fi;
        
        return [fail,SCFromFacets(tmpFaces[dim+1]),globalRounds];
        
        if mode=1 then
          return [fail,minComplex,globalRounds];
        elif mode=3 then
          return [fail,SCFromFacets(tmpFaces[dim+1]),globalRounds];
        else
          return [true,minComplex,globalRounds];
        fi;
      fi;
    else
      # equivalent<>false and mode=1 -> bistellarly equivalent
      if SCBistellarOptions.WriteLevel>=1 then
        name:=Concatenation(["ReducedComplex_",String(tmpF[1]),"_vertices_",
          String(globalRounds)]);
        SCRename(minComplex,name);
        SCLibAdd(rep,minComplex);
      fi;

      if SCBistellarOptions.WriteLevel=2 then
        msg:=Concatenation(["SCReduceComplexEx:\n\nComplexes are bistellarly ",
          "equivalent.\n\n",String(minComplex),"\n"]);
        SCMailClearPending();
        SCMailSend(msg,stime,true);
      fi;
      if mode=1 then
        Info(InfoSimpcomp,1,"SCReduceComplexEx: complexes are bistellarly ",
          "equivalent.");
      fi;

      if mode <> 3 then
        return [true,minComplex,globalRounds];
      else
        return [true,SCFromFacets(tmpFaces[dim+1]),globalRounds];
      fi;
    fi;
  od;

  if SCBistellarOptions.WriteLevel>=1 then
    name:=Concatenation(["ReducedComplex_",String(tmpF[1]),"_vertices_",
      String(globalRounds)]);
    SCRename(minComplex,name);
    SCLibAdd(rep,minComplex);
  fi;

  if SCBistellarOptions.WriteLevel=2 then
    msg:=Concatenation(["SCReduceComplexEx:\n\nReached maximal number of ",
      "rounds ",String(globalRounds)," rounds. Reduced complex to:\n\n",
      String(minComplex),"\n"]);
    SCMailClearPending();
    SCMailSend(msg,stime,true);
  fi;
  
  if mode=1 then
    Info(InfoSimpcomp,1,"SCReduceComplexEx: could not prove bistellar ",
      "equivalence between 'complex' and 'refComplex'.");
  elif mode<>1 and mode <> 3 then
    Info(InfoSimpcomp,2,"SCReduceComplexEx: reached maximal number of ",
      "rounds. Returning smallest complex found.");
  fi;

  return [fail,SCFromFacets(tmpFaces[dim+1]),globalRounds];

  if mode <> 3 then
    return [fail,minComplex,globalRounds];
  else
    return [fail,SCFromFacets(tmpFaces[dim+1]),globalRounds];
  fi;

end;

SCIntFunc.SCMakeFlagComplex:=
  function(complex) 
  
  local d,f,h,links, result, linkidx, verts, writelevel, maxrounds,
    type, movable, ks, cc, try, maxtries, flagStrategy, ball, tmp;
    
  flagStrategy:=function(dim,moves)
    local options,i,tmp;
  
    #allow 1..(dim/2)-moves
    options:=[];
    for i in [1..Int(dim/2)] do
      Append(options,moves[i+1]);
    od;
    
    #choose move at random
    if options=[] then
      return [];
    else
      tmp:=RandomList(options);
      return tmp;
    fi;
  end;
  
  if(not SCIsSimplicialComplex(complex)) then
    Info(InfoSimpcomp,1,"SCMakeFlagComplex: first argument must be of type ",
      "SCSimplicialComplex.");
    return fail;
  fi;

  ks:=SCIsFlag(complex);
  
  if ks<>fail and IsBool(ks) then
    return ks;
  fi;

  d:=SCDim(complex);
  f:=SCFVector(complex);
  
  if(d=fail or f=fail) then
    return fail;
  fi;
  
  #set bistellar flip options
  maxrounds:=Sum(f)*10;
  SCBistellarOptions.MaxInterval:=SCBistellarOptions.MaxIntervalIsManifold;
  writelevel:=SCBistellarOptions.WriteLevel;
  SCBistellarOptions.WriteLevel:=0;
  
  Info(InfoSimpcomp,1,"SCMakeFlagComplex: trying to make flag complex...");  
  
  maxtries:=50;
  for try in [1..maxtries] do

    cc:=SCCopy(complex);
    SCRelabelStandard(cc);
      
    Info(InfoSimpcomp,1,Concatenation("SCMakeFlagComplex: try ",String(try),
      "/",String(maxtries)));
    
    movable:=SCIsMovableComplex(cc);
    if movable = fail then
      Info(InfoSimpcomp,1,"SCMakeFlagComplex: invalid complex.");
      return fail;
    fi;
    
    if movable then
      result:=SCReduceComplexEx(cc,SCEmpty(),0,flagStrategy);
    else
      Info(InfoSimpcomp,1,"SCMakeFlagComplex: complex is not a closed ",
        "pseudomanifold.");
      return false;
    fi;
      
    if result=fail then  
      Info(InfoSimpcomp,1,"SCMakeFlagComplex: SCReduceComplexEx returned ",
        "fail.");
      return fail;
    fi;
    
  od;
  
  SCBistellarOptions.MaxInterval:=maxrounds;
  SCBistellarOptions.WriteLevel:=writelevel;
  
  Info(InfoSimpcomp,1,"SCMakeFlagComplex: could not determine whether given ",
    "complex is flag.");
  return false;
end;


################################################################################
##<#GAPDoc Label="SCReduceComplexFast">
## <ManSection>
## <Func Name="SCReduceComplexFast" Arg="complex"/>
## <Returns>a simplicial complex upon success, <K>fail</K> otherwise.</Returns> 
## <Description>
## Same as <Ref Func="SCReduceComplex" Style="Text" />, but calls an external 
## binary provided with the simpcomp package.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCReduceComplexFast,
  function(complex)
  
  local 
  movable, dir, bin, stream, line, resultingcomplex;
  
  movable:=SCIsMovableComplex(complex);
  if movable = fail then
    Info(InfoSimpcomp, 2, "SCReduceComplexFast: invalid complex.");
    return fail;
  fi;
  
  dir := DirectoriesPackageLibrary("simpcomp", "bin");
  if dir = fail then
    Info(InfoSimpcomp, 1, "SCReduceComplexFast: cannot find executable.");
    return fail;
  fi;
  
  bin := Filename(dir, "bistellar");
  if bin = fail then
    Info(InfoSimpcomp, 1, "SCReduceComplexFast: cannot find executable.");
    return fail;
  fi;
  
  stream := InputOutputLocalProcess(DirectoryCurrent(), bin, []);
  if stream = fail then
    Info(InfoSimpcomp, 2, "SCReduceComplexFast: cannot open executable.");
    return fail;
  fi;
  
  WriteLine(stream, Concatenation("reduce ",
                SCIntFunc.ListToDenseString(complex.Facets),
                " with rounds=", String(SCBistellarOptions.MaxRounds),
                ", heating=",
                String(SCBistellarOptions.BaseHeating),
                " and relaxation=",
                String(SCBistellarOptions.BaseRelaxation)));
  
  repeat
    line := ReadAllLine(stream, true);
    
    if line{[1..5]} = "found" then
      Info(InfoSimpcomp, 2, Concatenation("SCReduceComplexFast: ", line));
    fi;
  until line{[1..5]} <> "found";

  CloseStream(stream);

  if line{[1..9]} = "resulting" then
    resultingcomplex := 
      SC(SCIntFunc.ReadArray(line{[22..(Position(line, ' ', 22)-1)]}));
    return resultingcomplex;
  else
    return fail;
  fi;
end);


