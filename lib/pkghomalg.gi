################################################################################
##
##  simpcomp / pkghomalg.gi
##
##  Loaded when package `homalg' is available
##
##  $Id$
##
################################################################################

# helper function that converts an integer modulus to an homalg ring according
# to the following table:
# modulus - homalg ring
# 0 - rationals
# 1 - integers
# n - integers mod n
SCIntFunc.ModulusToHomalgRing:=function(modulus)
  if(modulus<0) then
    return fail;
  elif(modulus=1) then
    return HomalgRingOfIntegers();
  elif(modulus=0) then
    return HomalgFieldOfRationals();
  else
    return HomalgRingOfIntegers(modulus);
  fi;
end;

SCIntFunc.bdOperator:=function(simplex) 
  local b,cur,i,j,pos;
  b:=[];
  
  #all positions, i=kill entry
  for i in [1..Length(simplex)] do
    cur:=[];
    pos:=1;
    
    #extract one boundary face
    for j in [1..Length(simplex)] do
      if(i=j) then continue; fi;
      
      cur[pos]:=simplex[j];
      pos:=pos+1;
    od;
    
    #add to list of boundary faces
    Add(b,ShallowCopy(cur));
  od;
  
  return b;
end;



################################################################################
##<#GAPDoc Label="SCHomalgBoundaryMatrices">
## <ManSection>
## <Meth Name="SCHomalgBoundaryMatrices" Arg="complex,modulus"/>
## <Returns>a list of <Package>homalg</Package> objects upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the boundary operator matrices for the simplicial 
## complex <Arg>complex</Arg> with a ring of coefficients as specified by 
## <Arg>modulus</Arg>: a value of <C>0</C> yields <M>\mathbb{Q}</M>-matrices, 
## a value of <C>1</C> yields <M>\mathbb{Z}</M>-matrices and a value of 
## <C>q</C>, q a prime or a prime power, computes the 
## <M>\mathbb{F}_q</M>-matrices.<P/>
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2 (VT)");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomalgBoundaryMatrices(c,0);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomalgBoundaryMatricesOp,
"for SCSimplicialComplex and Integer",
[SCIsSimplicialComplex, IsInt],
function(complex, modulus)
  local tmp,skel,x,matrices,one,minusone,k,p,i,j,b,ind,pos,res,d,ring;

  ring:=SCIntFunc.ModulusToHomalgRing(modulus);
  if(ring=fail) then
    return fail;
  fi;
  
  # for matrices
  matrices := [];
  
  # 1 and -1 in ring
  one:=One(ring);
  minusone:=MinusOne(ring);
  
  skel:=SCFaceLatticeEx(complex);
  d:=SCDim(complex);

  matrices[d+1]:=HomalgInitialMatrix(0,Length(skel[d+1]),ring);
  ResetFilterObj(matrices[d+1], IsInitialMatrix);
  for k in [2..d+1] do
    matrices[k-1] := HomalgInitialMatrix(Length(skel[k]),
      Length(skel[k-1]),ring);
    
    for i in [1..Length(skel[k])] do
      #get boundary of current simplex
      b:=SCIntFunc.bdOperator(skel[k][i]);
      
      for j in [1..Length(b)] do
        pos:=Position(skel[k-1],b[j]);
        if(pos<>fail) then
          if((j mod 2)=0) then
            AddToMatElm( matrices[k-1], i, pos, one );
          else
            AddToMatElm( matrices[k-1], i, pos, minusone );
          fi;
        else
          Info(InfoSimpcomp,1,"SCHomalgBoundaryOperatorMatrices: list of ",
            "boundary skel[k-1] is not complete k=",k,", b[j]=",b[j],"!");
          return fail;
        fi;
      od;
    od;
    ResetFilterObj(matrices[k-1],IsInitialMatrix);
  od;  

  return matrices;
end);    


################################################################################
##<#GAPDoc Label="SCHomalgCoboundaryMatrices">
## <ManSection>
## <Meth Name="SCHomalgCoboundaryMatrices" Arg="complex,modulus"/>
## <Returns>a list of <Package>homalg</Package> objects upon success, 
## <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the coboundary operator matrices for the simplicial 
## complex <Arg>complex</Arg> with a ring of coefficients as specified by 
## <Arg>modulus</Arg>: a value of <C>0</C> yields <M>\mathbb{Q}</M>-matrices, 
## a value of <C>1</C> yields <M>\mathbb{Z}</M>-matrices and a value of 
## <C>q</C>, q a prime or a prime power, computes the 
## <M>\mathbb{F}_q</M>-matrices.<P/>
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2 (VT)");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomalgCoboundaryMatrices(c,0);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomalgCoboundaryMatricesOp,
"for SCSimplicialComplex and Integer",
[SCIsSimplicialComplex, IsInt],
  function( complex, modulus )
  local tmp,skel,x,matrices,one,minusone,k,p,i,j,b,ind,pos,res,d,ring;

  ring:=SCIntFunc.ModulusToHomalgRing(modulus);
  if(ring=fail) then
    return fail;
  fi;
  
  # for matrices
  matrices := [];
  
  # 1 and -1 in ring
  one:=One(ring);
  minusone:=MinusOne(ring);
  
  skel:=SCFaceLatticeEx(complex);
  d:=SCDim(complex);
  
  matrices[d+1]:=HomalgInitialMatrix(Length(skel[d+1]),0,ring);
  ResetFilterObj(matrices[d+1],IsInitialMatrix);
  for  k in [2..d+1] do
    matrices[k-1]:=HomalgInitialMatrix(Length(skel[k-1]),Length(skel[k]),ring);
    
    for i in [1..Length(skel[k])] do
      #get boundary of current simplex
      b:=SCIntFunc.bdOperator(skel[k][i]);
      
      for j in [1..Length(b)] do
        pos:=Position(skel[k-1],b[j]);
        if(pos<>fail) then
          if((j mod 2)=0) then
            AddToMatElm(matrices[k-1],pos,i,one);
          else
            AddToMatElm(matrices[k-1],pos,i,minusone);
          fi;
        else
          Info(InfoSimpcomp,1,"SCHomalgCoboundaryOperatorMatrices: list of ",
            "boundary skel[k] is not complete!");
          return fail;
        fi;
      od;
    od;
    ResetFilterObj(matrices[k-1],IsInitialMatrix);
  od;  
  return matrices;
end);    


################################################################################
##<#GAPDoc Label="SCHomalgHomology">
## <ManSection>
## <Meth Name="SCHomalgHomology" Arg="complex,modulus"/>
## <Returns>a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the ranks of the homology groups of 
## <Arg>complex</Arg> with a ring of coefficients as specified by 
## <Arg>modulus</Arg>: a value of <C>0</C> computes the 
## <M>\mathbb{Q}</M>-homology, a value of <C>1</C> computes the 
## <M>\mathbb{Z}</M>-homology and a value of <C>q</C>, q a prime or a 
## prime power, computes the <M>\mathbb{F}_q</M>-homology ranks.<P/>
## Note that if you are interested not only in the ranks of the homology 
## groups, but rather their full structure, have a look at the function 
## <Ref Meth="SCHomalgHomologyBasis" />.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomalgHomology(c,0);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomalgHomologyOp,
"for SCSimplicialComplex and Integer",
[SCIsSimplicialComplex, IsInt],
function(complex,modulus)
   #homology: ker(M[i])/im(M[i+1])
  local M,C,m,morphisms,L,i,H,ring,rnam;
  
  ring:=SCIntFunc.ModulusToHomalgRing(modulus);
  if ring=fail then
    return fail;
  fi;  
  
  rnam:=RingName(ring);
  
  M:=SCHomalgBoundaryMatrices(complex,modulus);

  Info(InfoSimpcomp,2,"SCHomalgHomologyOp: computing ",
    rnam,"-homology ranks...");  
  
  L := [];
  for i in [ 1 .. Length( M ) ] do
    L[i] := SCIntFunc.DeepCopy(DimensionsMat( M[i] ));
    L[i][3] := RowRankOfMatrix( M[i] );
    L[i][4] := L[i][2] - L[i][3];
  od;
  
  H := [ L[1][4] ]; #first image dimension
  for i in [ 2 .. Length( L ) ] do
    H[i] := L[i][4] - L[i-1][3]; #dim ker - dim im
  od;
  
  Info(InfoSimpcomp,1,"SCHomalgHomologyOp: ",rnam,"-homology ranks: ",H);
  return H;
end);

################################################################################
##<#GAPDoc Label="SCHomalgHomologyBasis">
## <ManSection>
## <Meth Name="SCHomalgHomologyBasis" Arg="complex,modulus"/>
## <Returns>a <Package>homalg</Package> object upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## This function computes the homology groups (including explicit bases of 
## the modules involved) of <Arg>complex</Arg> with a ring of coefficients 
## as specified by <Arg>modulus</Arg>: a value of <C>0</C> computes the 
## <M>\mathbb{Q}</M>-homology, a value of <C>1</C> computes the 
## <M>\mathbb{Z}</M>-homology and a value of <C>q</C>, q a prime or a prime 
## power, computes the <M>\mathbb{F}_q</M>-homology groups.<P/>
## The <M>k</M>-th homology group <C>hk</C> can be obtained by calling 
## <C>hk:=CertainObject(homology,k);</C>, where <C>homology</C> is the 
## <Package>homalg</Package> object returned by this function. The 
## generators of <C>hk</C> can then be obtained via 
## <C>GeneratorsOfModule(hk);</C>.<P/>
## Note that if you are only interested in the ranks of the homology groups, 
## then it is better to use the funtion <Ref Meth="SCHomalgHomology" /> 
## which is way faster.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomalgHomologyBasis(c,0);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomalgHomologyBasisOp,
"for SCSimplicialComplex and Integer",
[SCIsSimplicialComplex, IsInt],
function(complex,modulus)
  #homology: ker(M[i])/im(M[i+1])
  local M,R, C, m,morphisms,L,i,H,ring,rnam;
  
  ring:=SCIntFunc.ModulusToHomalgRing(modulus);
  if ring=fail then
    return fail;
  fi;  
  
  rnam:=RingName(ring);

  M:=SCHomalgBoundaryMatrices(complex,modulus);
  C := HomalgComplex( HomalgMap( M[1] ), 1 );
  for m in M{[ 2 .. Length( M )-1 ]} do
    Add( C, m );
  od;
  
  # C:=ByASmallerPresentation(C);
  # C!.SkipHighestDegreeHomology := true;
  # C!.HomologyOnLessGenerators := true;
  # C!.DisplayHomology := true;
  # C!.StringBeforeDisplay :="";
  
  Info(InfoSimpcomp,1,"SCHomalgHomologyBasisOp: constructed ",rnam,
    "-homology groups.");
  return Homology(C);
end);


################################################################################
##<#GAPDoc Label="SCHomalgCohomology">
## <ManSection>
## <Meth Name="SCHomalgCohomology" Arg="complex,modulus"/>
## <Returns>a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the ranks of the cohomology groups of 
## <Arg>complex</Arg> with a ring of coefficients as specified by 
## <Arg>modulus</Arg>: a value of <C>0</C> computes the 
## <M>\mathbb{Q}</M>-cohomology, a value of <C>1</C> computes the 
## <M>\mathbb{Z}</M>-cohomology and a value of <C>q</C>, q a prime or a 
## prime power, computes the <M>\mathbb{F}_q</M>-cohomology ranks.<P/>
## Note that if you are interested not only in the ranks of the cohomology 
## groups, but rather their full structure, have a look at the function 
## <Ref Meth="SCHomalgCohomologyBasis" />.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomalgCohomology(c,0);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomalgCohomologyOp,
"for SCSimplicialComplex and Integer",
[SCIsSimplicialComplex, IsInt],
function(complex,modulus)
  #cohomology:  ker( M[i+1] ) / im( M[i] )
  local M,R, C, m,morphisms,L,i,H,ring,rnam;
  
  ring:=SCIntFunc.ModulusToHomalgRing(modulus);
  if ring=fail then
    return fail;
  fi;  
  
  rnam:=RingName(ring);
  
  M:=SCHomalgCoboundaryMatrices(complex,modulus);

  Info(InfoSimpcomp,2,"SCHomalgCohomologyOp: computing ",rnam,
    "-cohomology ranks...");
  
  L := [];
  for i in [ 1 .. Length( M ) ] do
    L[i] := SCIntFunc.DeepCopy(DimensionsMat( M[i] ));
    L[i][3] := RowRankOfMatrix( M[i] );
    L[i][4] := L[i][1] - L[i][3];
  od;
  H := [ L[1][4] ]; #first kernel dimension
  for i in [ 2 .. Length( L ) ] do
    H[i] := L[i][4] - L[i-1][3]; #dim ker - dim im
  od;

  Info(InfoSimpcomp,1,"SCHomalgCohomologyOp: ",rnam,"-cohomology ranks: ",H);
  return H;
end);

################################################################################
##<#GAPDoc Label="SCHomalgCohomologyBasis">
## <ManSection>
## <Meth Name="SCHomalgCohomologyBasis" Arg="complex,modulus"/>
## <Returns>a <Package>homalg</Package> object upon success, <K>fail</K> 
## otherwise.</Returns>
## <Description>
## This function computes the cohomology groups (including explicit bases of 
## the modules involved) of <Arg>complex</Arg> with a ring of coefficients as 
## specified by <Arg>modulus</Arg>: a value of <C>0</C> computes the 
## <M>\mathbb{Q}</M>-cohomology, a value of <C>1</C> computes the 
## <M>\mathbb{Z}</M>-cohomology and a value of <C>q</C>, q a prime or a prime 
## power, computes the <M>\mathbb{F}_q</M>-homology groups.<P/>
## The <M>k</M>-th cohomology group <C>ck</C> can be obtained by calling 
## <C>ck:=CertainObject(cohomology,k);</C>, where <C>cohomology</C> is the 
## <Package>homalg</Package> object returned by this function. The 
## generators of <C>ck</C> can then be obtained via 
## <C>GeneratorsOfModule(ck);</C>.<P/>
## Note that if you are only interested in the ranks of the cohomology groups, 
## then it is better to use the funtion <Ref Meth="SCHomalgCohomology" /> 
## which is way faster.
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomalgCohomologyBasis(c,0);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomalgCohomologyBasisOp,
"for SCSimplicialComplex and Integer",
[SCIsSimplicialComplex, IsInt],
function(complex,modulus)
  #cohomology:  ker( M[i+1] ) / im( M[i] )
  local M,R, C, m,morphisms,L,i,H,ring,rnam;
  
  ring:=SCIntFunc.ModulusToHomalgRing(modulus);
  if ring=fail then
    return fail;
  fi;  
  
  rnam:=RingName(ring);
    
  M:=SCHomalgCoboundaryMatrices(complex,modulus);
  C := HomalgCocomplex( HomalgMap( M[1] ), 1 );
  for m in M{[ 2 .. Length( M )-1 ]} do
    Add( C, m );
  od;
  
  # C:=ByASmallerPresentation(C);
  # C!.SkipHighestDegreeHomology := true;
  # C!.HomologyOnLessGenerators := true;
  # C!.DisplayHomology := true;
  # C!.StringBeforeDisplay :="";

  Info(InfoSimpcomp,1,"SCHomalgCohomologyBasisOp: constructed ",rnam,
    "-cohomology groups.");
  return Cohomology(C);
end);


#homologybasis:=
#function(h,k)
#  local hk;
#  hk:=CertainObject(h,k);
#  return GeneratorsOfModule(hk);
#end;

