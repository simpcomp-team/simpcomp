################################################################################
##
##  simpcomp / fromgroup.gi
##
##  Compute Simplicial Complexes from given Permutation Groups.  
##
##  $Id: glprops.gi 68 2010-04-23 14:08:15Z felix $
##
################################################################################

################################################################################
##<#GAPDoc Label="SCsFromGroupExt">
## <ManSection>
## <Func Name="SCsFromGroupExt" Arg="G,n,d,objectType,cache,removeDoubleEntries,
## outfile,maxLinkSize,subset"/>
## <Returns>a list of simplicial complexes of type <C>SCSimplicialComplex</C> 
## upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d=2</M> / all 
## strongly connected combinatorial <Arg>d</Arg>-pseudomanifolds, 
## <M>d \geq 3</M>, as a union of orbits of the group action of <Arg>G</Arg> 
## on <C>(d+1)</C>-tuples on the set of <Arg>n</Arg> vertices, see 
## <Cite Key="Lutz03TrigMnfFewVertVertTrans" />. The integer argument 
## <Arg>objectType</Arg> specifies, whether complexes exceeding the maximal 
## size of each vertex link for combinatorial manifolds are sorted out 
## (<C>objectType = 0</C>) or not (<C>objectType = 1</C>, in this case some 
## combinatorial pseudomanifolds won't be found, but no combinatorial manifold 
## will be sorted out). The integer argument <Arg>cache</Arg> specifies if the 
## orbits are held in memory during the computation, a value of <C>0</C> means 
## that the orbits are discarded, trading speed for memory, any other value 
## means that they are kept, trading memory for speed. The boolean argument 
## <Arg>removeDoubleEntries</Arg> specifies whether the results are checked for 
## combinatorial isomorphism, preventing isomorphic entries. The argument 
## <Arg>outfile</Arg> specifies an output file containing all complexes found 
## by the algorithm, if <Arg>outfile</Arg> is anything else than a string, not 
## output file is generated. The argument <Arg>maxLinkSize</Arg> determines a 
## maximal link size of any output complex. If <Arg>maxLinkSize</Arg><M>=0</M> 
## or if <Arg>maxLinkSize</Arg> is anything else than an integer the argument 
## is ignored. The argument <Arg>subset</Arg> specifies a set of orbits (given 
## by a list of indices of <C>repHigh</C>) which have to be contained in any 
## output complex. If <Arg>subset</Arg> is anything else than a subset of 
## <C>matrixAllowedRows</C> the argument is ignored.
## <Example><![CDATA[
## gap> G:=PrimitiveGroup(8,5);
## gap> Size(G);
## gap> Transitivity(G);
## gap> list:=SCsFromGroupExt(G,8,3,1,0,true,false,0,[]);
## gap> c:=SCFromIsoSig(list[1]);
## gap> SCNeighborliness(c); 
## gap> c.F;
## gap> c.IsManifold; 
## gap> SCLibDetermineTopologicalType(SCLink(c,1));
## gap> # there are no 3-neighborly 3-manifolds with 8 vertices
## gap> list:=SCsFromGroupExt(PrimitiveGroup(8,5),8,3,0,0,true,false,0,[]); 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCsFromGroupExt,
  function(G,n,d,objectType,cache,removeDoubleEntries,outfile,maxLinkSize,
    subset)
  local
  forbiddenHigh,forbiddenLow,stab,repHighForbidden,repHigh,repHighTmp,repLow,
  repHighOrbitLen,repHighOrbitLenTmp,repOrbitLen,matrix,matrixRows,matrixCols,
  matrixAllowedRows,allCount,repLowCount,repHighCount,cachedHighOrbits,
  candidateCount,max,tmp,t,orbit,pos,curRow,complex,complex_collection,
  count,maxIdxLow,maxIdxHigh,maxIdxLowReal,maxIdxHighReal,simplex,
  maxSimplexPos,simplexPos,add,simplexIdx,rl,ru,rlIdx,rowIdx,singleResults,
  element,j,i,o,name,column,s,vectorsum,curComb,stop,stopSize,foundComplex,
  colPos,curPos,lastRow,srctr,subsetValid,isoSig,isoSigs,

  # functions
  examineComplex,
  Faces,
  assembleComplex,
  updateRowVector;

  candidateCount:=0;
  
  if not IsString(outfile) then
    outfile:=false;
  else
    tmp:=SmallGeneratingSet(G);
    if tmp = [] then
      PrintTo(outfile,"G:=Group(());\nc:=[];\n\n");
    else
      PrintTo(outfile,"G:=Group(\n",SmallGeneratingSet(G),"\n);\nc:=[];\n\n");
    fi;
  fi;
  #upper boundaries for link length
  if IsInt(maxLinkSize) and maxLinkSize > 0 then
  max:=maxLinkSize;
  else 
    if objectType=0 then #manifolds
      if IsInt((d-1)/2) = true then
        max:=Binomial((n-1)-Int(d/2)-1,Int(d/2))+
          Binomial((n-1)-1-(d-1)/2,(d-1)/2);
      else
        max:=Binomial((n-1)-d/2,d/2)+Binomial((n-1)-1-
          Int((d-1)/2)-1,Int((d-1)/2));
      fi;
    else #pseudomanifolds
      if d = 4 then
        max:=Binomial((n-1)-d/2,d/2)+Binomial((n-1)-1-
          Int((d-1)/2)-1,Int((d-1)/2));
      else
        max:=Binomial(n-1,d);
      fi;
    fi;
  fi;
  
  # upper boundary for length of facet list
  max:=Int(n*max/(d+1));
  complex_collection:=[];

  updateRowVector:=function(add,row)
    local i;
    if(add) then
      #add row to chosen combination
      for i in matrix[row] do
        if vectorsum[i[1]]+i[2] >= 3 then
          return false;
        fi;
      od;
      if vectorsum[repLowCount+2]+repHighOrbitLen[row] > max then
        return false;
      fi;
      for i in matrix[row] do
        vectorsum[i[1]]:=vectorsum[i[1]]+i[2];
        if vectorsum[i[1]] = 1 then
          vectorsum[repLowCount+1]:=vectorsum[repLowCount+1]+1;
        elif vectorsum[i[1]]=2 and i[2]=1 then
          vectorsum[repLowCount+1]:=vectorsum[repLowCount+1]-1;
        fi;
      od;
      vectorsum[repLowCount+2]:=vectorsum[repLowCount+2]+repHighOrbitLen[row];
    else
      #remove row from chosen combination
      for i in matrix[row] do
        if vectorsum[i[1]]=2 and i[2]=1 then
          vectorsum[repLowCount+1]:=vectorsum[repLowCount+1]+1;  
        elif vectorsum[i[1]] = 1 then
          vectorsum[repLowCount+1]:=vectorsum[repLowCount+1]-1;
        fi;
        vectorsum[i[1]]:=vectorsum[i[1]]-i[2];
      od;
      vectorsum[repLowCount+2]:=vectorsum[repLowCount+2]-repHighOrbitLen[row];        
    fi;
    return true;
  end;

  assembleComplex:=function(combination)
    local j,tmp,orbit;
    
    complex:=[];
    tmp:=[];
    for j in combination do
      #generate orbit
      if cache=1 then
        orbit:=cachedHighOrbits[j];
      else
        orbit:=Orbit(G,repHigh[j],OnSets);
      fi;      
      Append(complex,orbit);
    od;
  end;
  
  examineComplex := function(complex,complex_collection,objectType,t)
    local k,j,d,isconn,c,lk;
    c:=SCFromFacets(complex);
    if t = 0 then
      lk:=SCLinks(c,0);
    else
      lk:=[SCLink(c,1)];
    fi;
    d:=Size(complex[1])-1;
    if not SCIsConnected(c) then 
      Info(InfoSimpcomp,2,"complex not connected.");
      return false;
    fi;

    if not SCIsStronglyConnected(c) then 
      Info(InfoSimpcomp,2,"complex not strongly connected.");
      return false;
    fi;

    Info(InfoSimpcomp,2,"Testing connectedness of link(s)...");
    isconn:= List(lk,x->SCIsConnected(x)) ;
    if (objectType=0 and false in isconn) or (objectType=1 and false in isconn 
        and d > 2) then
      Info(InfoSimpcomp,2,"link not connected.");
      return false;
    fi;
    if (objectType = 1 and IsInt(d/2)) or objectType = 0 then
      Info(InfoSimpcomp,2,"Testing vertex link...");
      if Set(List(lk,x->SCEulerCharacteristic(x))) <> [1 + (-1)^(d-1)] then
        Info(InfoSimpcomp,2,"link not valid.");
        return false;
      fi;
    fi;
    Info(InfoSimpcomp,2,"ok.");

    # test lower links
    if objectType = 0 then
      return SCIsManifold(c);
    else
      return true;
    fi;
  end;
  
  Info(InfoSimpcomp,2,"Calculating for group ",G);
  
  # check if G operates on [1..n]
  if DegreeOperation(G) <> n then
    Info(InfoSimpcomp,2,"Group does not operate on ",n," points.");
    return [];
  fi;

  # check group size
  if Size(G) > Factorial(d+1)*max and objectType = 0 then
    Info(InfoSimpcomp,2,"Group too large for combinatorial manifolds.");
    return [];
  fi;

  # check if G operates on [1..n]
  if n < d+2 then
    Info(InfoSimpcomp,2,"There is no ",d,"-dimensional (pseudo)manifold with ",
      n," vertices.");
    return [];
  fi;

  repHigh:=[];
  repLow:=[];

  repHighOrbitLen:=[];
  repOrbitLen:=0;
  
  matrix:=[];
  matrixRows:=0;
  matrixCols:=0;
  matrixAllowedRows:=[];
  allCount:=[];
  
  cachedHighOrbits:=[];

  t:=Transitivity(G);
  if t < 1 then
    Info(InfoSimpcomp,1,"Automorphism is not transitive.");
    return fail;
  fi;
  
  #complex
  complex:=[];
  
  count:=0;
  
  if removeDoubleEntries then
    isoSigs:=[];
  fi;

  ##############################################################################
  #MAIN
  ##############################################################################

  #number of (possible) simplices calculated
  maxIdxLow:=Binomial(n-t,d-t); #maximum number of (d-1)-vertices
  maxIdxHigh:=Binomial(n-t,d+1-t); #maximum number of d-vertices
  
  maxIdxLowReal:=Binomial(n,d);
  maxIdxHighReal:=Binomial(n,d+1);
    
  if(maxIdxLow<1) then maxIdxLow:=1; fi;
  if(maxIdxHigh<1) then maxIdxHigh:=1; fi;
  
  Info(InfoSimpcomp,2,"Simplices count low=",maxIdxLow," high=",maxIdxHigh);
  Info(InfoSimpcomp,2,"Generating low simplices count=",maxIdxLow);

  forbiddenLow:=[];
  #compute low represetative list
  maxSimplexPos:=d;
  simplex:=[1..d];
  simplex[d]:=d-1;
  for simplexIdx in [1..maxIdxLow] do
    simplexPos:=d;
    simplex[simplexPos]:=simplex[simplexPos]+1;
    if(simplex[simplexPos]>n) then
      simplexPos:=simplexPos-1;
      simplex[simplexPos]:=simplex[simplexPos]+1;
      while(simplex[simplexPos]>n or simplex[simplexPos]+
        maxSimplexPos-simplexPos>n) do
        simplexPos:=simplexPos-1;
        simplex[simplexPos]:=simplex[simplexPos]+1;
      od;
      while(simplexPos<maxSimplexPos) do
        simplex[simplexPos+1]:=simplex[simplexPos]+1;
        simplexPos:=simplexPos+1;
      od;
    fi;
    #generate orbit & look if already represented
    add:=1;
    orbit:=Orbit(G,simplex,OnSets);
    #Info(InfoSimpcomp,2,"orbit ",orbit);

    for rl in repLow do
      pos:=Position(orbit,rl);
      if(pos<>fail) then
        #Info(InfoSimpcomp,2,"discarded simplex ",simplex);
        add:=0;
        break;
      fi;
    od;
    for rl in forbiddenLow do
      pos:=Position(orbit,rl);
      if(pos<>fail) then
        #Info(InfoSimpcomp,2,"discarded simplex ",simplex);
        add:=0;
        break;
      fi;
    od;
    if(add=1) then
      # check, if pointwise stabilizer is valid (<= C2)
      stab:=Stabilizer(G,simplex,OnTuples);
      if d > 2 then
        if Size(stab) <= 2 then
          Add(repLow,ShallowCopy(simplex));
        else
          Info(InfoSimpcomp,3,"simplex ",simplex,
            " not valid, stabilizer too large.");
          Add(forbiddenLow,ShallowCopy(simplex));
        fi;
      elif d <= 2 then
        Add(repLow,ShallowCopy(simplex));
      fi;
      repOrbitLen:=repOrbitLen+Length(orbit);
    fi;

    if((simplexIdx mod 100)=0) then
      Info(InfoSimpcomp,2,"Processing (d-1)-simplex ",simplexIdx,"/",maxIdxLow,
      ", ",Length(repLow)," represenative(s) so far. simplices=",repOrbitLen,
      "/",maxIdxLowReal);
      GASMAN("collect");
    fi;
    if(repOrbitLen=maxIdxLowReal) then
      Info(InfoSimpcomp,3,"No more low orbits possible. Finished.");
      break;
    fi;
  od;
  
  repLowCount:=Length(repLow);
  Info(InfoSimpcomp,2,repLowCount," low represenative(s): ",repLow," orbits=",
    repOrbitLen,"/",maxIdxLowReal);
  
  allCount:=[];
  allCount[1]:=ListWithIdenticalEntries(repLowCount,0);
  allCount[2]:=ListWithIdenticalEntries(repLowCount,0);
    
  repHigh:=[];
  forbiddenHigh:=[];
  Info(InfoSimpcomp,2,"Generating high simplices count=",maxIdxHigh,
    " and matrix...");
  #compute high representative list & matrix
  repOrbitLen:=0;
  maxSimplexPos:=d+1;
  simplex:=[1..d+1];
  simplex[d+1]:=d;
  for simplexIdx in [1..maxIdxHigh] do
    simplexPos:=d+1;
    simplex[simplexPos]:=simplex[simplexPos]+1;
    if(simplex[simplexPos]>n) then
      simplexPos:=simplexPos-1;
      simplex[simplexPos]:=simplex[simplexPos]+1;
      while(simplex[simplexPos]>n or simplex[simplexPos]+maxSimplexPos-
          simplexPos>n) do
        simplexPos:=simplexPos-1;
        simplex[simplexPos]:=simplex[simplexPos]+1;
      od;
    
      while(simplexPos<maxSimplexPos) do
        simplex[simplexPos+1]:=simplex[simplexPos]+1;
        simplexPos:=simplexPos+1;
      od;
    fi;
    #Info(InfoSimpcomp,2,"simplex ",simplex);
  
    #generate orbit & check whether already represented
    add:=1;
    orbit:=Orbit(G,simplex,OnSets);
    for ru in repHigh do
      pos:=Position(orbit,ru);
      if(pos<>fail) then
        #Info(InfoSimpcomp,2,"discarded simplex ",simplex);
        add:=0;
        break;
      fi;
    od;
    for ru in forbiddenHigh do
      pos:=Position(orbit,ru);
      if(pos<>fail) then
        #Info(InfoSimpcomp,2,"discarded simplex ",simplex);
        add:=0;
        break;
      fi;
    od;
    if(add=1 and d>2) then
      # check, if pointwise stabilizer is trivial
      stab:=Stabilizer(G,simplex,OnTuples);
      if Size(stab) = 1 then
        Add(repHigh,ShallowCopy(simplex));
        Add(repHighOrbitLen,Length(orbit));
      else
        Add(forbiddenHigh,ShallowCopy(simplex));
        Info(InfoSimpcomp,3,"simplex ",simplex,
          " not valid, stabilizer not trivial.");
      fi;
      repOrbitLen:=repOrbitLen+Length(orbit);
    elif(add=1 and d <= 2) then
      Add(repHigh,ShallowCopy(simplex));
      Add(repHighOrbitLen,Length(orbit));
    fi;

    if((simplexIdx mod 100)=0) then
      Info(InfoSimpcomp,2,"Processing d-simplex ",simplexIdx,"/",maxIdxHigh,
        ", ",Length(repHigh)," represenative(s) so far. simplices="
        ,repOrbitLen,"/",maxIdxHighReal);
      GASMAN("collect");
    fi;
    
    if(repOrbitLen=maxIdxHighReal) then
      Info(InfoSimpcomp,3,"No more high orbits possible. Finished.");
      break;
    fi;
    od;
  
  repHighCount:=Length(repHigh);
  Info(InfoSimpcomp,2,repHighCount, " high represenative(s): ",repHigh,
     " orbits=",repOrbitLen,"/",maxIdxHighReal);
  
  repHighForbidden:=[];
  
  #check pseudomanifold property & generate matrix
  Info(InfoSimpcomp,2,"Calculating matrix...");
  cachedHighOrbits:=[];
  for simplexIdx in [1..repHighCount] do
    simplex:=repHigh[simplexIdx];
    if(simplexIdx mod 100 = 1) then Info(InfoSimpcomp,2,
      "Calculating incidence matrix row ",simplexIdx,"/",repHighCount); fi;
    add:=1;
    curRow:=[];
    orbit:=Orbit(G,simplex,OnSets);
    
    if(Size(orbit) > max) then
      add:=0;
    fi;
    
    if(add=1) then
      #calculate how often every (d-1)-simplex is contained in this d-simplex
      for rlIdx in [1..repLowCount] do
        count:=0;
        for element in orbit do
          if(IsSubset(element,repLow[rlIdx])) then
            count:=count+1;
            if(count>2) then
              break;
            fi;
          fi;  
        od;
    
        if(count>2) then
          add:=0;
          break;
        elif(count>0) then
          curRow[rlIdx]:=count;
        fi;
      od;
    fi;
    
    if(add=1) then
      tmp:=[];
      for i in [1..repLowCount] do
        if(IsBound(curRow[i])) then     
          allCount[curRow[i]][i]:=allCount[curRow[i]][i]+1;
          Add(tmp,[i,curRow[i]]);
        fi;
      od;
      #save matrix row
      Add(matrix,ShallowCopy(tmp));
      if(cache=1) then
        Add(cachedHighOrbits,ShallowCopy(orbit));
      fi;
    else
        Add(repHighForbidden,simplex);
    fi;
  
  od;

  repHighTmp:=[];
  repHighOrbitLenTmp:=[];
  for i in [1..Length(repHigh)] do  
    if(repHigh[i] in repHighForbidden) then
      continue;
    fi;
    
    Add(repHighTmp,repHigh[i]);
    Add(repHighOrbitLenTmp,repHighOrbitLen[i]);
  od;
  
  repHigh:=repHighTmp;
  repHighOrbitLen:=repHighOrbitLenTmp;
  repHighCount:=Length(repHigh);
  Info(InfoSimpcomp,2,repHighCount, " valid high represenative(s).");
  Info(InfoSimpcomp,2,"Matrix calculation done.");

  #setup matrix  
  matrixRows:=Length(matrix);
  matrixCols:=repLowCount;
  matrixAllowedRows:=[1..matrixRows];

  if(matrixRows=0 or matrixCols=0) then
    Info(InfoSimpcomp,2,"Nothing to compute.");
    return [];
  fi;

  #get single results
  singleResults:=[];
  
  for rowIdx in matrixAllowedRows do
      if(ForAll(matrix[rowIdx],x->x[2]=2)) then
      Add(singleResults,rowIdx);
    fi;
  od;
  Info(InfoSimpcomp,2,"Got ",Length(singleResults)," single results.");

  # test subset
  subsetValid:=true;
  srctr:=0;
  if not IsList(subset) or subset = [] then
    subsetValid := false;
  else
    SCIntFunc.DeepSortList(subset);
    subset:=Set(subset);
    for i in [1..Size(subset)] do
      pos:=Position(repHigh,subset[i]);
      if pos = fail or not pos in matrixAllowedRows then
        subsetValid:=false;
        break;
      fi;
      if pos in singleResults then
        srctr:=srctr+1;
      fi;
    od;
  fi;
  if srctr > 1 then
    return [];
  fi;
  if subsetValid then
    subset:=List(subset,x->Position(repHigh,x));
  fi;
  
  if Size(subset) = 1 and srctr = 1 then
    #generate complex
    complex:=Orbit(G,repHigh[subset[1]],OnSets);

    if Union(complex) = [1..n] then
      tmp:=[[repHigh[subset[1]],Size(complex)]];
      if(examineComplex(complex,complex_collection,objectType,t)) then
        complex:=SCFromFacets(complex);
        if removeDoubleEntries and d>2 then
          Info(InfoSimpcomp,2,"Testing if complex is equivalent ",
             "to previous one...");
          isoSig:=SCExportIsoSig(complex);
          if isoSig = fail then
            return fail;
          fi;
          if isoSig in isoSigs then
            Info(InfoSimpcomp,2,"yes.");
          else
            Info(InfoSimpcomp,2,"no.");
            Add(isoSigs,isoSig);
            candidateCount:=candidateCount+1;
            if outfile <> false then
              AppendTo(outfile,"Add(c,SCFromGenerators(G,",[repHigh[subset[1]]],"));\n");
            fi;
          fi;
        else
          if not HasName(G) then
            SetName(G,StructureDescription(G));
          fi;
          name:=Concatenation("Complex ",String(Size(complex_collection)+1),
            " of ",Name(G)," (single orbit)");
          SCRename(complex,name);
          if outfile <> false then
            AppendTo(outfile,"Add(c,SCFromGenerators(G,",
              [repHigh[subset[1]]],"));\n");
          fi;
          Add(complex_collection,complex);
          candidateCount:=candidateCount+1;
        fi;
      fi;
      if removeDoubleEntries then
        return isoSigs;
      else
        return complex_collection;
      fi;
    fi;
  elif not subsetValid then
    for i in [1..Length(singleResults)] do
      Info(InfoSimpcomp,2,"Single result ",i,"/",Length(singleResults),
        " :  ",matrix[singleResults[i]],"(",singleResults[i],")");
      for j in matrix[singleResults[i]] do
         allCount[2][j[1]]:=allCount[2][j[1]]-1;
      od;
      
      #generate complex
      complex:=Orbit(G,repHigh[singleResults[i]],OnSets);

      if Union(complex) = [1..n] then
        tmp:=[[repHigh[singleResults[i]],Size(complex)]];
        if(examineComplex(complex,complex_collection,objectType,1)) then
          complex:=SCFromFacets(complex);
          if removeDoubleEntries and d>2 then
            Info(InfoSimpcomp,2,"Testing if complex is equivalent ",
              "to previous one...");
            isoSig:=SCExportIsoSig(complex);
            if isoSig = fail then
              return fail;
            fi;
            if isoSig in isoSigs then
              Info(InfoSimpcomp,2,"yes.");
            else
              Info(InfoSimpcomp,2,"no.");
              Add(isoSigs,isoSig);
              candidateCount:=candidateCount+1;
              if outfile <> false then
                AppendTo(outfile,"Add(c,SCFromGenerators(G,",[repHigh[subset[1]]],"));\n");
              fi;
            fi;
          else
            if not HasName(G) then
              SetName(G,StructureDescription(G));
            fi;
            name:=Concatenation("Complex ",String(Size(complex_collection)+1),
              " of ",Name(G)," (single orbit)");
            SCRename(complex,name);
            if outfile <> false then
              AppendTo(outfile,"Add(c,SCFromGenerators(G,",
                [repHigh[subset[1]]],"));\n");
            fi;
            Add(complex_collection,complex);
            candidateCount:=candidateCount+1;
          fi;
        fi;
      fi;
    od;
  fi;
    
  SubtractSet(matrixAllowedRows,singleResults);
  matrixRows:=Length(matrixAllowedRows);
  if(matrixRows<1) then
    Info(InfoSimpcomp,2,"No more computations needed (no more rows).");
    if removeDoubleEntries then
      return isoSigs;
    else
      return complex_collection;
    fi;
  fi;
    
  Info(InfoSimpcomp,2,"Incidence matrix:\n",matrix);
  
  if(matrixRows<1 or matrixCols<1) then
    Info(InfoSimpcomp,2,"No more computations needed (no more rows/cols).");
    if removeDoubleEntries then
      return isoSigs;
    else
      return complex_collection;
    fi;
  fi;
    
  GASMAN("collect");
  Info(InfoSimpcomp,2,"Got ",matrixRows," rows, ",matrixCols,
    " cols in matrix, computing row combinations...");
  
  #init column vector
  column:=[];
  for s in [1..repLowCount] do
    column[s]:=[];
  od;

  for i in [1..matrixRows] do
    Add(column[matrix[matrixAllowedRows[i]][1][1]],matrixAllowedRows[i]);
  od;
  
  if matrixRows <= 1 then
    stop:=1;
  else
    stop:=0;
  fi;
  
  # vectorsum{[1..repLowCount]} = current combination of rows
  # vectorsum[repLowCount+1] = number of 1-entries in combination
  # vectorsum[repLowCount+2] = size of complex (facets)
  vectorsum:=ListWithIdenticalEntries(repLowCount+2,0);

  ##########################
  ### SETUP BACKTRACKING ###
  ##########################
  
  if subsetValid then
    # case: "subset" is valid
    curComb:=[];
    for i in subset do
      Add(curComb,i);
      if (updateRowVector(true,i)=false) then
        Info(InfoSimpcomp,2,"argument subset valid but not part ",
          "of a candidate complex.");
        return [];
      fi;
    od;
    if not matrixAllowedRows[1] in subset then
      i:=1;
      while (updateRowVector(true,matrixAllowedRows[i])=false) do
        i:=i+1;
        if i in subset then
          break;
        fi;
      od;
      if not i in subset then
        Add(curComb,matrixAllowedRows[i]);
        colPos:=matrix[matrixAllowedRows[i]][1][1];
        i:=Position(column[colPos],matrixAllowedRows[i])+1;
        while i <= Size(column[colPos]) and column[colPos][i] in subset do
          i:=i+1;
        od;
        curPos:=i;
      else
        colPos:=matrix[subset[1]][1][1];
        curPos:=Position(column[colPos],subset[1])+1;
      fi;
    else
      colPos:=matrix[subset[1]][1][1];
      curPos:=Position(column[colPos],subset[1])+1;
    fi;    
  else
    # case: "subset" is invalid or empty
    i:=1;
    while (updateRowVector(true,matrixAllowedRows[i])=false) do
      i:=i+1;
    od;
    curComb:=[matrixAllowedRows[i]];
    colPos:=matrix[matrixAllowedRows[i]][1][1];
    curPos:=Position(column[colPos],matrixAllowedRows[i])+1;
  fi;
  foundComplex:=0;
  # column: column[i] contains all row numbers x with row[x][i] <> 0 and 
  # row[x][j] = 0 for all j < i
  # colPos: position of first non zero entry of current row
  # curPos: next row where first non zero entry is at the same 
  # position as in current row
  while stop = 0 do
    foundComplex:=0;
    while foundComplex = 0 and colPos <= repLowCount do
      # if there is a row left where the first non zero entry is at the 
      # same column as colPos
      if curPos > Length(column[colPos]) then
        if vectorsum[colPos] in [0,2] then
          colPos:=colPos+1;
          if subsetValid then
            i:=1;
            while colPos <= Size(column) and i <= Size(column[colPos]) and 
              column[colPos][i] in subset do
              i:=i+1;
            od;
            curPos:=i;
          else
            curPos:=1;
          fi;
        else
          if subsetValid and Size(curComb) = Size(subset) then
            stop:=1;
            break;
          fi;
          lastRow:=curComb[Length(curComb)];
          updateRowVector(false,lastRow);
          Unbind(curComb[Length(curComb)]);
          if curComb = [] and colPos > repLowCount then
            stop:=1;
          fi;
          colPos:=matrix[lastRow][1][1];
          if subsetValid then
            i:=Position(column[colPos],lastRow)+1;
            while i <= Size(column[colPos]) and column[colPos][i] in subset do
              i:=i+1;
            od;
            curPos:=i;
          else
            curPos:=Position(column[colPos],lastRow)+1;
          fi;
        fi;
        continue;
      fi;
      # column colPos is already mapped -> next step
      if vectorsum[colPos] = 2 then
        colPos:=colPos+1;
        if subsetValid then
          i:=1;
          while colPos <= Size(column) and i <= Size(column[colPos]) and 
            column[colPos][i] in subset do
            i:=i+1;
          od;
          curPos:=i;
        else
          curPos:=1;
        fi;
      # if this is the last row where the first non zero entry is at the 
      # same column as colPos and orbit cannot be closed anymore -> next step
      elif vectorsum[colPos] = 0 and matrix[column[colPos][curPos]][1][2] = 1 
         and curPos = Length(column[colPos]) then
        colPos:=colPos+1;
        if subsetValid then
          i:=1;
          while colPos <= Size(column) and i <= Size(column[colPos]) 
            and column[colPos][i] in subset do
            i:=i+1;
          od;
          curPos:=i;
        else
          curPos:=1;
        fi;
      elif subsetValid and column[colPos][curPos] in subset then
        curPos:=curPos+1;
      else 
        foundComplex:=1;
        stopSize:=0;
        if(updateRowVector(true,column[colPos][curPos])=false) then
          stopSize:=1;
        fi;

        if stopSize = 0 then
          Add(curComb,column[colPos][curPos]);

          if vectorsum[repLowCount+1] = 0 then
            assembleComplex(curComb);
            if (Union(complex) = [1..n] and 
              examineComplex(complex,complex_collection,objectType,1)) then
              complex:=SCFromFacets(complex);
              if removeDoubleEntries and d>2 then
                Info(InfoSimpcomp,2,"Testing if complex is equivalent ",
                  "to previous one...");
                isoSig:=SCExportIsoSig(complex);
                if isoSig = fail then
                  return fail;
                fi;
                if isoSig in isoSigs then
                  Info(InfoSimpcomp,2,"yes.");
                else
                  Info(InfoSimpcomp,2,"no.");
                  Info(InfoSimpcomp,2,"Found candidate.");
                  Add(isoSigs,isoSig);
                  candidateCount:=candidateCount+1;
                  if outfile <> false then
                    AppendTo(outfile,"Add(c,SCFromGenerators(G,",repHigh{curComb},"));\n");
                  fi;
                fi;
              else
                if not HasName(G) then
                  SetName(G,StructureDescription(G));
                fi;
                name:=Concatenation("Complex ",
                  String(Size(complex_collection)+1)," of ",Name(G),
                  " (multiple orbits)");
                SCRename(complex,name);
                if outfile <> false then
                  AppendTo(outfile,"Add(c,SCFromGenerators(G,",
                    repHigh{curComb},"));\n");
                fi;
                Info(InfoSimpcomp,2,"Found candidate.");
                Add(complex_collection,complex);
                candidateCount:=candidateCount+1;
              fi;
            fi;
          else
            foundComplex:=0;
          fi;
        else
          foundComplex:=0;
          #updateRowVector(false,column[colPos][curPos]);  
        fi;
        if subsetValid then
          curPos:=curPos+1;
          while curPos <= Length(column[colPos]) and 
            column[colPos][curPos] in subset do
            curPos:=curPos+1;
          od;
        else
          curPos:=curPos+1;
        fi;
      fi;
    od;
    if stop = 1 then break; fi; 
    if curComb = [] and colPos > repLowCount then
      stop:=1;
      break;
    else
      if subsetValid and Size(curComb) = Size(subset) then
        stop:=1;
        break;
      fi;
      lastRow:=curComb[Length(curComb)];
      updateRowVector(false,lastRow);
      Unbind(curComb[Length(curComb)]);
      colPos:=matrix[lastRow][1][1];
      if subsetValid then
        i:=Position(column[colPos],lastRow)+1;
        while i <= Size(column[colPos]) and column[colPos][i] in subset do
          i:=i+1;
        od;
        curPos:=i;
      else
        curPos:=Position(column[colPos],lastRow)+1;
      fi;
    fi;
  od; 


  Info(InfoSimpcomp,2,"All done, ",candidateCount," candidate(s).");
  if removeDoubleEntries then
    return isoSigs;
  else
    return complex_collection;
  fi;
end);

################################################################################
##<#GAPDoc Label="SCsFromGroupByTransitivity">
## <ManSection>
## <Func Name="SCsFromGroupByTransitivity" Arg="n,d,k,maniflag,computeAutGroup,
## removeDoubleEntries"/>
## <Returns>a list of simplicial complexes of type <C>SCSimplicialComplex</C> 
## upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all combinatorial <Arg>d</Arg>-pseudomanifolds, <M>d = 2</M> / all 
## strongly connected combinatorial <Arg>d</Arg>-pseudomanifolds, 
## <M>d \geq 3</M>, as union of orbits of group actions for all 
## <Arg>k</Arg>-transitive groups on <C>(d+1)</C>-tuples on the set of 
## <Arg>n</Arg> vertices, see <Cite Key="Lutz03TrigMnfFewVertVertTrans" />. 
## The boolean argument <Arg>maniflag</Arg> specifies, whether the resulting 
## complexes should be listed separately by combinatorial manifolds, 
## combinatorial pseudomanifolds and complexes where the verification that the 
## object is at least a combinatorial pseudomanifold failed. The boolean 
## argument <Arg>computeAutGroup</Arg> specifies whether or not the real 
## automorphism group should be computed (note that a priori the generating 
## group is just a subgroup of the automorphism group). The boolean argument 
## <Arg>removeDoubleEntries</Arg> specifies whether the results are checked 
## for combinatorial isomorphism, preventing isomorphic entries. Internally 
## calls <Ref Func="SCsFromGroupExt" /> for every group.
## <Example><![CDATA[
## gap> list:=SCsFromGroupByTransitivity(8,3,2,true,true,true);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCsFromGroupByTransitivity,
  function(n,d,k,maniflag,computeAutGroup,removeDoubleEntries)
  local coll, i, G, tmp, dim, verts, sum, Gcollection, g, gg, retList, 
    retListTmp, c, lk, pm, m, flag, ctr, cc, j, l, warn, isoSigs;
  
  if((not IsPosInt(n) and not (IsList(n) and ForAll(n,x->IsPosInt(x)))) or 
    (not IsPosInt(d) and not (IsList(d) and ForAll(d,x->IsPosInt(x)))) or 
    not IsPosInt(k) or not IsBool(maniflag) or not IsBool(computeAutGroup) 
    or not IsBool(removeDoubleEntries)) then
    Info(InfoSimpcomp,1,"SCsFromGroupCheckByTransitivity: 'n' and 'd' must ",
      "be positive integers or a list of positive integers, 'k' must be a ",
      "positive integer, 'maniflag', computeAutGroup' and ",
      "'removeDoubleEntries' must be boolean");
    return fail;
  fi;
  
  if IsInt(n) then
    n:=[n];
  fi;
  if IsInt(d) then
    d:=[d];
  fi;

  if removeDoubleEntries then
    isoSigs:=[];
  fi;

  # detect group list, do not check groups with k-transitive subgroups
  Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: Building list of groups...");
  Gcollection:=[];
  if k > 1 then
    for verts in n do
      Gcollection[verts]:=[];
      for i in [1..NrPrimitiveGroups(verts)] do
        g:=PrimitiveGroup(verts,i);
        if Transitivity(g) <> k then
          continue;
        fi;
        flag := 0;
        for gg in Gcollection[verts] do
          if IsSubgroup(g,gg) then
            flag:=1;
            break;
          fi;
        od;
        if flag = 0 then
          Add(Gcollection[verts],g);
        fi;
      od;
    od;
  elif k = 1 then
    for verts in n do
      Gcollection[verts]:=[];
      for i in [1..NrTransitiveGroups(verts)] do
        g:=TransitiveGroup(verts,i);
        flag := 0;
        for gg in Gcollection[verts] do
          if IsSubgroup(g,gg) then
            flag:=1;
            break;
          fi;
        od;
        if flag = 0 then
          Add(Gcollection[verts],g);
        fi;
      od;
    od;
  else
    Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: third argument 'k' must ",
      "be a positive integer.");
    return fail;
  fi;
  sum:=0;
  for i in Gcollection do
    sum:=sum+Size(i);
  od;
  Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ...",sum," groups found.");
  for i in Gcollection do
    if i <> [] then
      Info(InfoSimpcomp,1,"degree ",Position(Gcollection,i),": ",i);
    fi;
  od;
  
  coll:=[];
  retList:=[];
  if maniflag then
    retList[1]:=[];
    retList[2]:=[];
    retList[3]:=[];
  fi;
  warn:=false;
  for dim in d do
    if dim=2 and removeDoubleEntries=true then
      warn:=true;
    fi;
    Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: Processing dimension ",
      dim,".");
    coll[dim]:=[];
    for verts in n do
      Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: Processing degree ",
        verts,".");
      sum:=0;
      retListTmp:=[];
      if maniflag then
        retListTmp[1]:=[];
        retListTmp[2]:=[];
        retListTmp[3]:=[];
      fi;
      for G in Gcollection[verts] do
        tmp:=SCsFromGroupExt(G,verts,dim,1,0,removeDoubleEntries,false,0,[]);
        if removeDoubleEntries then
          for i in [1..Size(tmp)] do
            if tmp[i] in isoSigs then
              Unbind(tmp[i]);
            else
              Add(isoSigs,tmp[i]);
            fi;
          od;
          tmp:=Compacted(tmp);
        fi;
        sum:=sum+1;
        Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ",sum," / ",
          Size(Gcollection[verts])," groups calculated, found ",Size(tmp),
          " complexes.");
        if computeAutGroup then
          Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: Calculating ",
            Size(tmp)," automorphism and homology groups...");
          cc:=0;
          for i in [1..Size(tmp)] do
            if removeDoubleEntries then
              tmp[i]:=SCFromIsoSig(tmp[i]);
            fi;
            cc:=cc+1;
            SCAutomorphismGroup(tmp[i]);
            SCHomology(tmp[i]);
            SCGenerators(tmp[i]);
            Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ",cc," / ",
              Size(tmp)," automorphism groups calculated.");
          od;
          Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ...all ",
            "automorphism groups calculated for group ",sum," / ",
            Size(Gcollection[verts]),".");
        fi;
        if maniflag then
          for c in tmp do
            lk:=SCLink(c,1);
            pm:=SCIsManifold(lk);
            if pm = fail then
              Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: Could not ",
                "determine whether candidate is combinatorial pseudomanifold ",
                "or not");
              Add(retListTmp[3],c);
            fi;
            if pm then
              m:=SCIsManifold(c);
              if m then
                Add(retListTmp[1],c);
              elif not m or m = fail then
                Add(retListTmp[2],c);
              fi;
            elif not pm then
              Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: Combinatorial ",
                "pseudomanifold property not fulfilled, discarding complex.");
            fi;
          od;
        else
          Append(retListTmp,tmp);
        fi;
      od;
      
    
      if maniflag then
        Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ...done dim = ",dim,
          ", deg =  ",verts,", ",Size(retListTmp[1])," manifolds, ",
          Size(retListTmp[2])," pseudomanifolds, ",Size(retListTmp[3]),
          " candidates found.");
      else
        Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ...done dim = ",
          dim,", deg =  ",verts,", ",Size(retListTmp)," candidates found.");
      fi;
    od;
    Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: ...done dim = ",dim,".");
  od;
  
  if warn then
    Info(InfoSimpcomp,1,"SCsFromGroupByTransitivity: can not remove double ",
      "entries for pp-surfaces.");
  fi;
  return retList;
end);

