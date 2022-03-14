################################################################################
##
##  simpcomp / generate.gi
##
##  Generate simplicial complexes or construct them using existing
##  complexes.
##
##  $Id$
##
################################################################################

#checks if labels of a facet list are valid 
SCIntFunc.HasValidLabels:=
function(facets)

	local i,j;
	
	for j in [1..Size(facets)] do
		for i in facets[j] do
			if IsRat(i) or IsCyclotomic(i) or IsFFE(i) or IsPerm(i) or IsBool(i) or IsChar(i) or IsList(i) then
				continue;
			else
				Info(InfoSimpcomp,1,"SCIntFunc.HasValidLabels: vertex labels have to be rationals, cyclotomics, finite field elements, permutations, characters, lists or strings");
				return false;
			fi;
		od;
	od;
	return true;
	
end;

#checks if facet list is valid 
SCIntFunc.IsValidFacetList:=
function(facets)
	if(not IsList(facets) or not IsDuplicateFreeList(facets) or not ForAll(facets,x->IsList(x) and IsDuplicateFree(x)) or not SCIntFunc.HasValidLabels(facets)) then
		return false;
	else
		return true;
	fi;
end;

#extract dimension of facet list
SCIntFunc.GetFacetListDimension:=
function(facets)
	if facets<>[] then
		return MaximumList(List(facets,x->Length(x)))-1;
	else
		return -1;
	fi;
end;


#recursive function to make deep (i.e. full) copies of objects
SCIntFunc.DeepCopy:=
function(obj)
	local tmprec,key,scnew,i,cobj;
	if(SCIsSimplicialComplex(obj)) then
		scnew:=SCIntFunc.SCNew();
		scnew!.Properties:=SCIntFunc.DeepCopy(obj!.Properties);
		scnew!.PropertiesTmp:=SCIntFunc.DeepCopy(obj!.PropertiesTmp);
		return scnew;
	elif(IsRecord(obj)) then
		tmprec:=rec();
		for key in RecNames(obj) do
			tmprec.(key):=SCIntFunc.DeepCopy(obj.(key));
		od;
		return tmprec;
	elif(not IsList(obj)) then
		return ShallowCopy(obj);
	elif(ForAll(obj,x->not IsList(x))) then
		return ShallowCopy(obj);
	else
		cobj:=[];
		
		for i in [1..Length(obj)] do
			if not IsBound(obj[i]) then
				continue;
			fi;
			
			cobj[i]:=SCIntFunc.DeepCopy(obj[i]);
		od;
		return cobj;
	fi;
end;


#apply a function "deeply" on a list
SCIntFunc.DeepList:=function(list,func)
	if not IsList(list) or (IsList(list) and not ForAny(list,IsList)) then
		return func(list);
	else
		return List(list,x->SCIntFunc.DeepList(x,func));
	fi;
end;

#deep sort a list
SCIntFunc.DeepSortList:=function(list)
	if not IsList(list) then
		return;
	elif ForAll(list,x->not IsList(x) or IsStringRep(x)) then
		Sort(list);
	else
		Perform(list,SCIntFunc.DeepSortList);
		Sort(list);
	fi;
end;


################################################################################
##<#GAPDoc Label="SCFromGenerators">
## <ManSection>
## <Meth Name="SCFromGenerators" Arg="group, generators"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructs a simplicial complex object from the set of <Arg>generators</Arg> on which the group <Arg>group</Arg> acts, i.e. a complex which has <Arg>group</Arg> as a subgroup of the automorphism group and a facet list that consists of the <Arg>group</Arg>-orbits specified by the list of representatives passed in <Arg>generators</Arg>. Note that <Arg>group</Arg> is not stored as an attribute of the resulting complex as it might just be a subgroup of the actual automorphism group. Internally calls <C>Orbits</C> and <Ref Func="SCFromFacets" />. 
## <Example><![CDATA[
## gap> #group: AGL(1,7) of order 42
## gap> G:=Group([(2,6,5,7,3,4),(1,3,5,7,2,4,6)]);;
## gap> c:=SCFromGenerators(G,[[ 1, 2, 4 ]]);
## gap> SCLib.DetermineTopologicalType(c);
## [ [ true, 5 ] ] # the 7-vertex torus
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFromGenerators,
"for Group and List",
[IsPermGroup,IsList],
function(group,generators)
	local complex,facets,os,g,vertices,newGens,ggens,newGGens,len;
	
	if not IsDuplicateFreeList(generators) or IsEmpty(generators) then
		Info(InfoSimpcomp,1,"SCFromGenerators: first argument must be a group in permutation representation, second a nonempty list of generators.");
		return fail;
	fi;
	
	os:=Orbits(group,generators,OnSets);
	facets:=Union(os);
	len:=List(os,x->Size(x));
	
	if(not SCIntFunc.IsValidFacetList(facets)) then
		Info(InfoSimpcomp,1,"SCFromGenerators: group operation yields invalid facet list!");
		return fail;
	fi;
	
	complex:=SCFromFacets(facets);
	if(complex=fail) then
		return fail;
	fi;

	#vertices:=SCVertices(complex);
	#if vertices = fail then
	#	return fail;
	#fi;
	
	#if Size(group) = 1 then
	#	g:=Group(());
	#else
	#	ggens:=GeneratorsOfGroup(group);
	#	newGGens:=List(ggens,x->SCIntFunc.RelabelPermutation(x,vertices));
	#	g:=Group(newGGens);
	#fi;
	
	#newGens:=SCIntFunc.RelabelSimplexListInv(generators,vertices);

	#SetSCAutomorphismGroup(complex,g);
	#SetSCAutomorphismGroupSize(complex,Size(g));
	#SetSCAutomorphismGroupStructure(complex,StructureDescription(g));
	#SetSCAutomorphismGroupTransitivity(complex,Transitivity(g));
	#SetSCGeneratorsEx(complex,List(newGens,x->[x,len[Position(newGens,x)]]));
	
	if HasStructureDescription(group) then
		SCRename(complex, Concatenation("complex from generators under group ",StructureDescription(group)));
	elif HasName(group) then
		SCRename(complex, Concatenation("complex from generators under group ",Name(group)));
	else
		SCRename(complex,"complex from generators under unknown group");
	fi;
	
	
	return complex;
end);


################################################################################
##<#GAPDoc Label="SCFromFacets">
## <ManSection>
## <Meth Name="SCFromFacets" Arg="facets"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructs a simplicial complex object from the given facet list. The facet list <Arg>facets</Arg> has to be a duplicate free list (or set) which consists of duplicate free entries, which are in turn lists or sets. For the vertex labels (i. e. the entries of the list items of <Arg>facets</Arg>) an ordering via the less-operator has to be defined. Following Section 4.11 of the &GAP; manual this is the case for objects of the following families: rationals <C>IsRat</C>, cyclotomics <C>IsCyclotomic</C>, finite field elements <C>IsFFE</C>, permutations <C>IsPerm</C>, booleans <C>IsBool</C>, characters <C>IsChar</C> and lists (strings) <C>IsList</C>.<P/>
## Internally the vertices are mapped to the standard labeling <M>1..n</M>, where <M>n</M> is the number of vertices of the complex and the vertex labels of the original complex are stored in the property ''VertexLabels'', see <Ref Func="SCLabels" /> and the <C>SCRelabel..</C> functions like <Ref Func="SCRelabel" /> or <Ref Func="SCRelabelStandard" />. 
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,5], [1,4,5], [1,4,6], [2,3,5], [3,4,6], [3,5,6]]);
## gap> c:=SCFromFacets([["a","b","c"], ["a","b",1], ["a","c",1], ["b","c",1]]);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFromFacets,
"for List",
[IsList],
function(facets)
	local lfacets,obj,dim,known,vertices,i,j,idx;

	if(not SCIntFunc.IsValidFacetList(facets)) then
		Info(InfoSimpcomp,1,"SCFromFacets: invalid facet list!");
		return fail;
	fi;

	dim:=SCIntFunc.GetFacetListDimension(facets);

	if(dim=-1) then
		obj:=SCEmpty();
	else
		lfacets:=Set(SCIntFunc.DeepCopy(facets));
		Perform(lfacets,Sort);
		Sort(lfacets);
		
		vertices:=Union(lfacets);
		for i in [1..Size(lfacets)] do
			for j in [1..Size(lfacets[i])] do
				idx:=Position(vertices,lfacets[i][j]);
				if idx<>fail then
					lfacets[i][j]:=idx;
				else
					Info(InfoSimpcomp,1,"SCFromFacets: error in vertex index.");
					return fail;
				fi;
			od;
		od;
		
		obj:=SCIntFunc.SCNew();
		SetSCVertices(obj,vertices);
		SetSCDim(obj,dim);
		SetSCFacetsEx(obj,lfacets);
		SetSCName(obj,Concatenation("unnamed complex ",String(SCSettings.ComplexCounter)));
		
		SCSettings.ComplexCounter:=SCSettings.ComplexCounter+1;
	fi;

	return obj;
end);


################################################################################
##<#GAPDoc Label="SC">
## <ManSection>
## <Meth Name="SC" Arg="facets"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## A shorter function to create a simplicial complex from a facet list, just calls <Ref Func="SCFromFacets" Style="Text"/>(<Arg>facets</Arg>).
## <Example><![CDATA[
## gap> c:=SC(Combinations([1..6],5));
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SC,
"for List",
[IsList],
function(facets)
	return SCFromFacets(facets);
end);


################################################################################
##<#GAPDoc Label="SCEmpty">
## <ManSection>
## <Func Name="SCEmpty" Arg=""/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates an empty complex (of dimension <M>-1</M>), i. e. a <C>SCSimplicialComplex</C> object with empty facet list.
## <Example><![CDATA[
## gap> SCEmpty();
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCEmpty,
function()
	local obj;

	obj:=SCIntFunc.SCNew();
	SetSCVertices(obj,[]);
	SetSCDim(obj,-1);
	SetSCFacetsEx(obj,[]);
	SetSCName(obj,"empty complex");	
	SetFilterObj(obj,IsEmpty);
	
	return obj;
end);


##########################
## <#GAPDoc Label="SCFVectorBdCrossPolytope">
## <ManSection>
## <Func Name="SCFVectorBdCrossPolytope" Arg="d"/>
## <Returns> a list of integers of size <C>d + 1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the <M>d</M>-dimensional cross polytope without generating the underlying complex.  
## <Example><![CDATA[
## gap> SCFVectorBdCrossPolytope(50);
## [100, 4900, 156800, 3684800, 67800320, 1017004800, 12785203200,
##   137440934400, 1282782054400, 10518812846080, 76500457062400,
##   497252970905600, 2907017368371200, 15365663232819200, 73755183517532160,
##   322678927889203200, 1290715711556812800, 4732624275708313600,
##   15941471244491161600, 49418560857922600960, 141195888165493145600,
##   372243705163572838400, 906332499528699084800, 2039248123939572940800,
##   4241636097794311716864, 8156992495758291763200, 14501319992459185356800,
##   23823597130468661657600, 36146147370366245273600, 50604606318512743383040,
##   65296266217435797913600, 77539316133205010022400, 84588344872587283660800,
##   84588344872587283660800, 77337915312079802204160, 64448262760066501836800,
##   48771658304915190579200, 33370081998099867238400, 20535435075753764454400,
##   11294489291664570449920, 5509506971543692902400, 2361217273518725529600,
##   878592473867432755200, 279552150776001331200, 74547240206933688320,
##   16205921784116019200, 2758454771764428800, 344806846470553600,
##   28147497671065600, 1125899906842624]
## ]]></Example>
## </Description>
## </ManSection>
## <#/GAPDoc>
##########################
InstallGlobalFunction(SCFVectorBdCrossPolytope,
function(d)
	local F,i;

	if(d<=0) then
		Info(InfoSimpcomp,1,"SCFVectorBdCrossPolytope: dimension must be positive.");
		return fail;
	fi;

	F:=ListWithIdenticalEntries(d,0);

	for i in [1..d] do
		F[i]:=(2^i)*Binomial(d,i);
	od;

	return F;

end);


##########################
## <#GAPDoc Label="SCFVectorBdCyclicPolytope">
## <ManSection>
## <Func Name="SCFVectorBdCyclicPolytope" Arg="d, n"/>
## <Returns> a list of integers of size <C>d+1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the <Arg>d</Arg>-dimensional cyclic polytope on <Arg>n</Arg> vertices, <M>n\geq d+2</M>, without generating the underlying complex.  
## <Example><![CDATA[
## gap> SCFVectorBdCyclicPolytope(25,198); 
## [ 198, 19503, 1274196, 62117055, 2410141734, 77526225777, 2126433621312, 
##   50768602708824, 1071781612741840, 20256672480820776, 346204947854027808, 
##   5395027104058600008, 48354596155522298656, 262068846498922699590, 
##   940938105142239825104, 2379003007642628680027, 4396097923113038784642, 
##   6062663500381642763609, 6294919173643129209180, 4911378208855785427761, 
##   2840750019404460890298, 1183225500922302444568, 335951678686835900832, 
##   58265626173398052500, 4661250093871844200 ]
## ]]></Example>
## </Description>
## </ManSection>
## <#/GAPDoc>
##########################
InstallGlobalFunction(SCFVectorBdCyclicPolytope,
function(d,n)
	local F,i,j,x;

	if(d<=0 or n<d+2) then
		Info(InfoSimpcomp,1,"SCFVectorBdCyclicPolytope: dimension must be positive, n>d+1.");
		return fail;
	fi;

	F:=ListWithIdenticalEntries(d,0);

	for i in [1..Int(d/2)] do
		F[i]:=Binomial(n,i);
	od;
	
	for i in [Int(d/2)+1..d] do
		F[i]:=0;
		for j in [0..Int(d/2)] do
			x:=(Binomial(d-j,i-j)+Binomial(j,i-d+j))*Binomial(n-d-1+j,j);
			if(d mod 2 = 0 and j=d/2) then
				F[i]:=F[i]+x/2;
			else
				F[i]:=F[i]+x;
			fi;
		od;
	od;

	return F;
end);


################################################################################
##<#GAPDoc Label="SCFVectorBdSimplex">
## <ManSection>
## <Func Name="SCFVectorBdSimplex" Arg="d"/>
## <Returns> a list of integers of size <C>d + 1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the <M>f</M>-vector of the <M>d</M>-simplex without generating the underlying complex.  
## <Example><![CDATA[
## gap> SCFVectorBdSimplex(100);
## [101, 5050, 166650, 4082925, 79208745, 1267339920, 17199613200,
##   202095455100, 2088319702700, 19212541264840, 158940114100040,
##   1192050855750300, 8160963550905900, 51297485177122800, 297525414027312240,
##   1599199100396803290, 7995995501984016450, 37314645675925410100,
##   163006083742200475700, 668324943343021950370, 2577824781465941808570,
##   9373908296239788394800, 32197337191432316660400, 104641345872155029146300,
##   322295345286237489770604, 942094086221309585483304,
##   2616928017281415515231400, 6916166902815169575968700,
##   17409661513983013070541900, 41783187633559231369300560,
##   95696978128474368620010960, 209337139656037681356273975,
##   437704928371715151926754675, 875409856743430303853509350,
##   1675784582908852295948146470, 3072271735332895875904935195,
##   5397234129638871133346507775, 9090078534128625066688855200,
##   14683973016669317415420458400, 22760158175837441993901710520,
##   33862674359172779551902544920, 48375249084532542217003635600,
##   66375341767149302111702662800, 87494768693060443692698964600,
##   110826707011209895344085355160, 134919469404951176940625649760,
##   157884485473879036845412994400, 177620046158113916451089618700,
##   192119641762857909630770403900, 199804427433372226016001220056,
##   199804427433372226016001220056, 192119641762857909630770403900,
##   177620046158113916451089618700, 157884485473879036845412994400,
##   134919469404951176940625649760, 110826707011209895344085355160,
##   87494768693060443692698964600, 66375341767149302111702662800,
##   48375249084532542217003635600, 33862674359172779551902544920,
##   22760158175837441993901710520, 14683973016669317415420458400,
##   9090078534128625066688855200, 5397234129638871133346507775,
##   3072271735332895875904935195, 1675784582908852295948146470,
##   875409856743430303853509350, 437704928371715151926754675,
##   209337139656037681356273975, 95696978128474368620010960,
##   41783187633559231369300560, 17409661513983013070541900,
##   6916166902815169575968700, 2616928017281415515231400,
##   942094086221309585483304, 322295345286237489770604,
##   104641345872155029146300, 32197337191432316660400, 9373908296239788394800,
##   2577824781465941808570, 668324943343021950370, 163006083742200475700,
##   37314645675925410100, 7995995501984016450, 1599199100396803290,
##   297525414027312240, 51297485177122800, 8160963550905900, 1192050855750300,
##   158940114100040, 19212541264840, 2088319702700, 202095455100, 17199613200,
##   1267339920, 79208745, 4082925, 166650, 5050, 101]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCFVectorBdSimplex,
function(d)
	local F;
	if(d<0) then
		Info(InfoSimpcomp,1,"SCFVectorBdSimplex: dimension must be positive.");
		return fail;
	fi;

	if d=0 then
		return [0];
	fi;
	
	F:=[1..d];
	Apply(F,x->Binomial(d+1,x));
	return F;
end);






################################################################################
##<#GAPDoc Label="SCBdCrossPolytope">
## <ManSection>
## <Func Name="SCBdCrossPolytope" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the boundary of the <M>d</M>-dimensional cross polytope <M>\beta^{d}</M>, a centrally symmetric combinatorial <M>d-1</M>-sphere.
## <Example><![CDATA[
## gap> SCBdCrossPolytope(3); # the octahedron
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCBdCrossPolytope,
function(d)

	local i,j,complex,newComplex,tmp,sc,FVectorCrossPoly,fvec;

	if(d<0) then
		Info(InfoSimpcomp,1,"SCBdCrossPolytope: dimension must be non-negative.");
		return fail;
	fi;

	complex:=[[1],[2]];

	for i in [1..d-1] do
		newComplex:=[];
		for j in [1..Size(complex)] do
			tmp:=[Union(complex[j],[2*i+1]),Union(complex[j],[2*i+2])];
			Append(newComplex,tmp);
		od;
		complex:=newComplex;
	od;

	sc:=SCFromFacets(complex);
	if(sc<>fail) then
		SCRename(sc,Concatenation(["Bd(\\beta^",String(d),")"]));
		SetSCTopologicalType(sc,Concatenation("S^",String(d-1)));
		fvec:=SCFVectorBdCrossPolytope(d);
		tmp:=[];
		for i in [1..d] do
			tmp[2*i-1]:=i-1;
			tmp[2*i]:=fvec[i];
		od;
		SetComputedSCNumFacess(sc,tmp);
		SetSCEulerCharacteristic(sc,1+(-1)^(d-1));
		SetSCIsConnected(sc,true);
		SetSCIsStronglyConnected(sc,true);
		SetSCHasBoundary(sc,false);
		SetSCHomology(sc,Concatenation(ListWithIdenticalEntries(d-1,[0,[]]),[[1,[]]]));
	fi;
	return sc;
end);


################################################################################
##<#GAPDoc Label="SCBdCyclicPolytope">
## <ManSection>
## <Func Name="SCBdCyclicPolytope" Arg="d, n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the boundary complex of the <Arg>d</Arg>-dimensional cyclic polytope (a combinatorial <M>d-1</M>-sphere) on <Arg>n</Arg> vertices, where <M>n\geq d+2</M>.
## <Example><![CDATA[
## gap> SCBdCyclicPolytope(3,8); 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCBdCyclicPolytope,
function(d,n)

	local s,i,a,b,facets,sc,fvec,tmp;

	if(d<0 or n<d+2) then
		Info(InfoSimpcomp,1,"SCBdCyclicPolytope: dimension must be non-negative, n>=d+2.");
		return fail;
	fi;

	#construct facets using gale's evenness condition	
	facets:=[];
	if IsInt(d/2) = true then
		for s in Combinations([1..(n-d/2)],d/2) do
			a:=[];
			for i in s do 
				Add(a,i+Position(s,i)-1);		 
				Add(a,i+Position(s,i));
		od;
		Add(facets,a);
	od;
		
	for s in Combinations([1..(n-2-(d-2)/2)],(d-2)/2) do
		a:=[];
		for i in s do 
			Add(a,i+Position(s,i));		 
			Add(a,i+Position(s,i)+1);
		od;
			Add(a,1);
			Add(a,n);
			Add(facets,a);
		od;
	else
		for s in Combinations([1..(n-1-(d-1)/2)],(d-1)/2) do
			a:=[];
			b:=[];
			for i in s do 
				Add(a,i+Position(s,i));		 
				Add(a,i+Position(s,i)+1);
				Add(b,i+Position(s,i)-1);		 
				Add(b,i+Position(s,i));
			od;
			Add(a,1);
			Add(b,n);
			Add(facets,a);
			Add(facets,b);
		od;
	fi;

	sc:=SCFromFacets(facets);
	if(sc<>fail) then
		SCRename(sc,Concatenation(["Bd(C_",String(d),"(",String(n),"))"]));
		SetSCTopologicalType(sc,Concatenation("S^",String(d-1)));
		fvec:=SCFVectorBdCyclicPolytope(d,n);
		tmp:=[];
		for i in [1..d] do
			tmp[2*i-1]:=i-1;
			tmp[2*i]:=fvec[i];
		od;
		SetComputedSCNumFacess(sc,tmp);
		SetSCEulerCharacteristic(sc,1+(-1)^(d-1));
		SetSCIsConnected(sc,true);
		SetSCIsStronglyConnected(sc,true);
		SetSCHasBoundary(sc,false);
		SetSCHomology(sc,Concatenation(ListWithIdenticalEntries(d-1,[0,[]]),[[1,[]]]));
	fi;
	return sc;
end);



################################################################################
##<#GAPDoc Label="SCBdSimplex">
## <ManSection>
## <Func Name="SCBdSimplex" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the boundary of the <M>d</M>-simplex <M>\Delta^d</M>, a combinatorial <M>d-1</M>-sphere.
## <Example><![CDATA[
## gap> SCBdSimplex(5);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCBdSimplex,
function(d)

	local complex,sc,fvec,tmp,G,i;

	if(d<0) then
		Info(InfoSimpcomp,1,"SCBdSimplex: dimension must be non-negative.");
		return fail;
	fi;
	
	complex:=Combinations([1..d+1],d);
	sc:=SCFromFacets(complex);

	if(sc<>fail) then
		SCRename(sc,Concatenation(["S^",String(d-1),"_",String(d+1)]));
		SetSCTopologicalType(sc,Concatenation("S^",String(d-1)));
		fvec:=SCFVectorBdSimplex(d);
		tmp:=[];
		for i in [1..d] do
			tmp[2*i-1]:=i-1;
			tmp[2*i]:=fvec[i];
		od;
		SetComputedSCNumFacess(sc,tmp);
		SetSCEulerCharacteristic(sc,1+(-1)^(d-1));
		G:=SymmetricGroup(IsPermGroup,d+1);
		SetSCAutomorphismGroup(sc,G);
		SetSCAutomorphismGroupTransitivity(sc,d+1);
		SetSCAutomorphismGroupSize(sc,Factorial(d+1));
		SetSCAutomorphismGroupStructure(sc,Concatenation("S",String(d+1)));
		SetSCGeneratorsEx(sc,[[[1..d],[d+1]]]);
		if d>1 then
			SetSCIsConnected(sc,true);
			SetSCIsStronglyConnected(sc,true);
		elif d=1 then
			SetSCIsConnected(sc,false);
			SetSCIsStronglyConnected(sc,false);
		fi;
		SetSCHasBoundary(sc,false);
		SetSCHomology(sc,Concatenation(ListWithIdenticalEntries(d-1,[0,[]]),[[1,[]]]));
	fi;
	return sc;
end);


################################################################################
##<#GAPDoc Label="SCSimplex">
## <ManSection>
## <Func Name="SCSimplex" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>d</Arg>-simplex.
## <Example><![CDATA[
## gap> SCSimplex(3);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSimplex,
function(d)
	local facets,i,sc,tmp,fvec;

	facets:=[[1..d+1]];
	sc:=SCFromFacets(facets);

	if(sc<>fail) then
		fvec:=SCFVectorBdSimplex(d);
		tmp:=[];
		for i in [1..d] do
			tmp[2*i-1]:=i-1;
			tmp[2*i]:=fvec[i];
		od;
		tmp[2*d+1]:=d;
		tmp[2*(d+1)]:=1;
		SetComputedSCNumFacess(sc,tmp);
		SCRename(sc,Concatenation(["B^",String(d),"_",String(d+1)]));
		SetSCTopologicalType(sc,Concatenation("B^",String(d)));
		SetSCEulerCharacteristic(sc,1);
	fi;

	return sc;
end);


################################################################################
##<#GAPDoc Label="SCCartesianProduct">
## <ManSection>
## <Meth Name="SCCartesianProduct" Arg="complex1,complex2"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the simplicial cartesian product of <Arg>complex1</Arg> and <Arg>complex2</Arg> where  <Arg>complex1</Arg> and <Arg>complex2</Arg> are pure, simplicial complexes. The original vertex labeling of <Arg>complex1</Arg> and <Arg>complex2</Arg> is changed into the standard one. The new complex has vertex labels of type <M>[v_i, v_j]</M> where <M>v_i</M> is a vertex of <Arg>complex1</Arg> and <M>v_j</M> is a vertex of <Arg>complex2</Arg>.<P/>
## If <M>n_i</M>, <M>i=1,2</M>, are the number facets and <M>d_i</M>, <M>i=1,2</M>, are the dimensions of <Arg>complexi</Arg>, then the new complex has <M>n_1 \cdot n_2 \cdot { d_1+d_2 \choose d_1}</M> facets. The number of vertices of the new complex equals the product of the numbers of vertices of the arguments.
## <Example><![CDATA[
## gap> c1:=SCBdSimplex(2);;
## gap> c2:=SCBdSimplex(3);;
## gap> c3:=SCCartesianProduct(c1,c2);
## gap> c3.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ]
## gap> c3.F;
## [ 12, 48, 72, 36 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCartesianProduct,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local dim1, dim2,facets1,facets2,facets,nFacets,
			i, j, flag, tmp, idx, element, facet, ctr,
			combinations, paths,names,scprod,toptypes,vertices;

	if SCIsEmpty(complex1) or SCIsEmpty(complex2) then
		return SCEmpty();
	fi;
			
	#save names
	if HasSCName(complex1) and HasSCName(complex2) then
		names:=[SCName(complex1),SCName(complex2)];
	fi;
	if HasSCTopologicalType(complex1) and HasSCTopologicalType(complex2) then 
		toptypes:=[SCTopologicalType(complex1),SCTopologicalType(complex2)];
	fi;
	vertices:=[];

	# extract facets
	facets1:=SCFacetsEx(complex1);
	facets2:=SCFacetsEx(complex2);
	if facets1=fail or facets2=fail then
		return fail;
	fi;

	# compute complex dimensions
	tmp :=SCIsPure(complex1);
	dim1:= SCDim(complex1);
	if dim1=fail or tmp=fail or tmp=false then
		if(tmp=false) then
			Info(InfoSimpcomp,1,"SCCartesianProduct: complex1 not pure");
			return fail;
		else
			return fail;
		fi;
	fi;

	tmp :=SCIsPure(complex2);
	dim2:= SCDim(complex2);
	if dim1=fail or tmp=fail or tmp=false then
		if(tmp=false) then
			Info(InfoSimpcomp,1,"SCCartesianProduct: complex2 not pure");
			return fail;
		else
			return fail;
		fi;
	fi;
	
	# compute possible combinations
	combinations:=Cartesian(facets1,facets2);
	# compute paths
	tmp:=Concatenation(ListWithIdenticalEntries(dim1,1),ListWithIdenticalEntries(dim2,2));
	paths:=Arrangements(tmp,Size(tmp));
	# compute facets of Cartesian product
	facets:=[];
	nFacets:= Size(facets1)*Size(facets2)*Binomial(dim1+dim2,dim1);
	ctr:=0;
	for element in combinations do
		for i in paths do
			idx:=[1,1];
			facet:=[];
			facet[1]:=[element[1][1],element[2][1]];
			for j in [1..dim1+dim2] do
				idx[i[j]]:=idx[i[j]]+1;
				facet[j+1]:=[element[1][idx[1]],element[2][idx[2]]];
			od;
			if Size(facet)=dim1 + dim2 + 1 then
				Add(facets,facet);
			else
				Info(InfoSimpcomp,1,"SCCartesianProduct: facet ",facet," has wrong dimension.");
			fi;
			ctr:=ctr+1;
		od;
	od;

	
	vertices:=Union(facets);
	for i in [1..Size(facets)] do
		for j in [1..Size(facets[i])] do
			facets[i][j] := Position(vertices,facets[i][j]);
		od;
	od;
	scprod:=SCFromFacets(facets);

	if(IsBound(toptypes)) then
		SetSCTopologicalType(scprod,Concatenation([toptypes[1],"x",toptypes[2]]));
	fi;

	if(IsBound(names)) then
		SCRename(scprod,Concatenation([names[1],"x",names[2]]));
	fi;

	return scprod;

end);


################################################################################
##<#GAPDoc Label="SCCartesianPower">
## <ManSection>
## <Meth Name="SCCartesianPower" Arg="complex,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## The new complex is <M>PL</M>-homeomorphic to <M>n</M> times the cartesian product of <Arg>complex</Arg>, of dimensions <M>n \cdot d</M> and has <M>f_{d}^n \cdot n \cdot \frac{2n-1}{2^{n-1}}!</M> facets where <M>d</M> denotes the dimension and <M>f_d</M> denotes the number of facets of <Arg>complex</Arg>. Note that the complex returned by the function is not the <M>n</M>-fold cartesian product <Arg>complex</Arg><M>^n</M> of <Arg>complex</Arg> (which, in general, is not simplicial) but a simplicial subdivision of <Arg>complex</Arg><M>^n</M>.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(2);;
## gap> 4torus:=SCCartesianPower(c,4);
## gap> 4torus.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 6, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## gap> 4torus.Chi;
## 0
## gap> 4torus.F;
## [ 81, 1215, 4050, 4860, 1944 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCartesianPower,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex, n)

	local dim1, facets1,facets,nFacets,
		i, j, k, flag, tmp, idx, element, facet, ctr,
		combinations, paths, vertices, sc, name, toptype;

	if SCIsEmpty(complex) then
		return SCEmpty();
	fi;
		
	if HasSCName(complex) then
		name:=SCName(complex);
	fi;
	if HasSCTopologicalType(complex) then
		toptype:=SCTopologicalType(complex);
	fi;
	
	# extract facets
	facets1:=SCFacetsEx(complex);
	if facets1=fail then
		return fail;
	fi;

	# compute possible combinations
	tmp:=ListWithIdenticalEntries(n,facets1);
	combinations:=Cartesian(tmp);

	# compute complex dimensions
	tmp :=SCIsPure(complex);
	dim1:= SCDim(complex);
	if dim1=fail or tmp=fail or tmp=false then
		if(tmp=false) then
			Info(InfoSimpcomp,1,"SCCartesianPower: complex not pure");
		fi;
		return fail;
	fi;

	
	# compute paths
	tmp:=[];
	for i in [1..n] do
		for j in [1..dim1] do
			Add(tmp,i);
		od;
	od;

	paths:=Arrangements(tmp,Size(tmp));

	# compute facets of Cartesian product
	facets:=[];
	nFacets:= (Size(facets1)^n)*n*(Factorial(2*n-1)/2^(n-1));
	ctr:=0;
	for element in combinations do
		for i in paths do
			idx:=ListWithIdenticalEntries(n,1);
			facet:=[];
			facet[1]:=[];
			for j in [1..n] do
				facet[1][j]:=element[j][1];
			od;
			for j in [1..n*dim1] do
				facet[j+1]:=[];
				idx[i[j]]:=idx[i[j]]+1;
				for k in [1..n] do
					facet[j+1][k]:=element[k][idx[k]];
				od;
			od;
			if Size(facet)=n*dim1 + 1 then
				Add(facets,facet);
			else
				Info(InfoSimpcomp,1,"SCCartesianPower: facet ",facet," has wrong dimension.");
			fi;
			ctr:=ctr+1;
		od;
	od;

	vertices:=Union(facets);
	for i in [1..Size(facets)] do
		for j in [1..Size(facets[i])] do
			facets[i][j] := Position(vertices,facets[i][j]);
		od;
	od;
	sc:=SCFromFacets(facets);
	
	if(IsBound(toptype)) then
		SetSCTopologicalType(sc,Concatenation(["(",toptype,")^",String(n)]));
	fi;

	if(IsBound(name)) then
		SCRename(sc,Concatenation(["(",name,")^",String(n)]));
	fi;

	return sc; 

end);



################################################################################
##<#GAPDoc Label="SCConnectedSumMinus">
## <ManSection>
## <Meth Name="SCConnectedSumMinus" Arg="complex1,complex2"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a lexicographic ordering the smallest facet of both <Arg>complex1</Arg> and  <Arg>complex2</Arg> is removed and the complexes are glued together along the resulting boundaries. The bijection used to identify the vertices of the boundaries differs from the one chosen in <Ref Func="SCConnectedSum"/> by a transposition. Thus, the topological type of <C>SCConnectedSumMinus</C> is different from the one of <Ref Func="SCConnectedSum"/> whenever <Arg>complex1</Arg> and <Arg>complex2</Arg> do not allow an orientation reversing homeomorphism. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], 
##   [ 10, "T^2 (VT)" ], [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> genus2:=SCConnectedSumMinus(torus,torus);
## gap> genus2.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## gap> genus2.Chi;
## -2
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");
## [ [ 16, "CP^2 (VT)" ], [ 96, "CP^2#-CP^2" ], 
##   [ 97, "CP^2#CP^2" ], [ 185, "CP^2#(S^2xS^2)" ], 
##   [ 397, "Gaifullin CP^2" ], 
##   [ 457, "(S^3~S^1)#(CP^2)^{#5} (VT)" ] ]
## gap> cp2:=SCLib.Load(last[1][1]);;
## # CP^2 # CP^2 (signature of intersection form is 2)  
## gap> c1:=SCConnectedSum(cp2,cp2);;
## # CP^2 # - CP^2 (signature of intersection form is 0)
## gap> c2:=SCConnectedSumMinus(cp2,cp2);;
## gap> c1.F=c2.F;
## true
## gap> c1.ASDet=c2.ASDet;
## true
## gap> SCIsIsomorphic(c1,c2);
## false
## gap> PrintArray(SCIntersectionForm(c1));
## [ [  1,  0 ],
##   [  0,  1 ] ]
## gap> PrintArray(SCIntersectionForm(c2));
## [ [   1,   0 ],
##   [   0,  -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCConnectedSumMinus,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local maxvertex1, maxvertex2, facets1, facets2, simplex1, simplex2,
		maptable, i, j, sc, name1, name2, vertices, idx, dim1, dim2, pure1, pure2;

	pure1:=SCIsPure(complex1);
	pure2:=SCIsPure(complex2);
	if pure1 <> true or pure2 <> true then
		Info(InfoSimpcomp,1,"SCConnectedSumMinus: complexes must be pure simplicial copmplexes.");
		return fail;
	fi;
	
	dim1:=SCDim(complex1);
	dim2:=SCDim(complex2);
	if dim1 = fail or dim2 = fail then
		Info(InfoSimpcomp,1,"SCConnectedSumMinus: complexes must have the same dimension");
		return fail;
	fi;
	
	if dim1 < 1 or dim2 < 1 then
		Info(InfoSimpcomp,1,"SCConnectedSumMinus: complexes must have at least dimension 1.");
		return fail;
	fi;
	
	if dim1 <> dim2 then
		Info(InfoSimpcomp,1,"SCConnectedSumMinus: complexes are not of the same dimension.");
		return fail;
	fi;
		
	if HasSCName(complex1) and HasSCName(complex2) then
		name1:=SCName(complex1);
		name2:=SCName(complex2);
	fi;
	
	# compute maximal labels
	maxvertex1:=Maximum(SCVerticesEx(complex1));
	maxvertex2:=Maximum(SCVerticesEx(complex2));
	if maxvertex1=fail or maxvertex2=fail then
		Info(InfoSimpcomp,1,"SCConnectedSumMinus: complex lacks vertex labels.");
		return fail;
	fi;
	
	# facets in standard labeling
	facets1:=SCIntFunc.DeepCopy(SCFacetsEx(complex1));
	facets2:=SCIntFunc.DeepCopy(SCFacetsEx(complex2)+maxvertex1);

	if facets1=fail or facets2=fail then
		Info(InfoSimpcomp,1,"SCConnectedSumMinus: complex lacks facets.");	
		return fail;
	fi;
	
	# relabel facets2
	simplex1:=SCIntFunc.DeepCopy(facets1[1]);
	simplex2:=SCIntFunc.DeepCopy(facets2[1]);
	RemoveSet(facets1,simplex1);
	RemoveSet(facets2,simplex2);
	for i in [1..Size(facets2)] do
		for j in [1..Size(facets2[i])] do
			if facets2[i][j] in simplex2 then
				idx := Position(simplex2,facets2[i][j]);
				facets2[i][j]:=simplex1[idx];
			fi;
		od;
	od;
	for i in [1..Size(facets2)] do
		Sort(facets2[i]);
	od;
	Sort(facets2);
	
	if not IsSet(facets1) then
		facets1:=Set(facets1);
	fi;
	if not IsSet(facets2) then
		facets2:=Set(facets2);
	fi;
	
	sc:=SCFromFacets(Union(facets1,facets2));
	vertices:=SCVerticesEx(sc);
	
	if(vertices=fail) then
		return fail;
	fi;
	SCRelabelStandard(sc);

	if(IsBound(name1) and IsBound(name2)) then
		SCRename(sc,Concatenation(name1,"#+-",name2));
	fi;

	return sc;

end);


SCIntFunc.ConnectedSumEx:=function(facets1,facets2)
	local simplex1,simplex2,i,j, idx;
	
	# relabel facets2
	simplex1:=SCIntFunc.DeepCopy(facets1[1]);
	simplex2:=SCIntFunc.DeepCopy(facets2[1]);
	Remove(facets1,Position(facets1,simplex1));
	Remove(facets2,Position(facets2,simplex2));
	for i in [1..Size(facets2)] do
		for j in [1..Size(facets2[i])] do
			if facets2[i][j] in simplex2 then
				idx := Position(simplex2,facets2[i][j]);
				if idx = 1 then
					facets2[i][j]:=simplex1[2];
				elif idx = 2 then
					facets2[i][j]:=simplex1[1];
				else
					facets2[i][j]:=simplex1[idx];
				fi;
			fi;
		od;
	od;

	return [facets1,facets2];
end;

################################################################################
##<#GAPDoc Label="SCConnectedSum">
## <ManSection>
## <Meth Name="SCConnectedSum" Arg="complex1,complex2"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## In a lexicographic ordering the smallest facet of both <Arg>complex1</Arg> and <Arg>complex2</Arg> is removed and the complexes are glued together along the resulting boundaries. The bijection used to identify the vertices of the boundaries differs from the one chosen in <Ref Func="SCConnectedSumMinus"/> by a transposition. Thus, the topological type of <C>SCConnectedSum</C> is different from the one of <Ref Func="SCConnectedSumMinus"/> whenever <Arg>complex1</Arg> and <Arg>complex2</Arg> do not allow an orientation reversing homeomorphism. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], 
##   [ 10, "T^2 (VT)" ], [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> genus2:=SCConnectedSum(torus,torus);
## gap> genus2.Homology;
## [ [ 0, [  ] ], [ 4, [  ] ], [ 1, [  ] ] ]
## gap> genus2.Chi;
## -2
## ]]></Example>
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");
## [ [ 16, "CP^2 (VT)" ], [ 96, "CP^2#-CP^2" ], 
##   [ 97, "CP^2#CP^2" ], [ 185, "CP^2#(S^2xS^2)" ], 
##   [ 397, "Gaifullin CP^2" ], 
##   [ 457, "(S^3~S^1)#(CP^2)^{#5} (VT)" ] ]
## gap> cp2:=SCLib.Load(last[1][1]);;
## # CP^2 # CP^2 (signature of intersection form is 2)  
## gap> c1:=SCConnectedSum(cp2,cp2);;
## # CP^2 # - CP^2 (signature of intersection form is 0)
## gap> c2:=SCConnectedSumMinus(cp2,cp2);;
## gap> c1.F=c2.F;
## true
## gap> c1.ASDet=c2.ASDet;
## true
## gap> SCIsIsomorphic(c1,c2);
## false
## gap> PrintArray(SCIntersectionForm(c1));
## [ [  1,  0 ],
##   [  0,  1 ] ]
## gap> PrintArray(SCIntersectionForm(c2));
## [ [   1,   0 ],
##   [   0,  -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCConnectedSum,
"for SCSimplicialComplex and SCSimplicialComplex",
[SCIsSimplicialComplex,SCIsSimplicialComplex],
function(complex1, complex2)

	local maxvertex1, maxvertex2, facets,facets1, facets2, simplex1, simplex2,
		maptable, i, j, sc, name1, name2, vertices, idx, dim1, dim2, pure1, pure2;

	if(not SCIsSimplicialComplex(complex1) or not SCIsSimplicialComplex(complex2)) then
		Info(InfoSimpcomp,1,"SCConnectedSum: arguments must be of type SCSimplicialComplex.");
		return fail;
	fi;
	
	pure1:=SCIsPure(complex1);
	pure2:=SCIsPure(complex2);
	if pure1 <> true or pure2 <> true then
		Info(InfoSimpcomp,1,"SCConnectedSum: complexes must be pure simplicial copmplexes.");
		return fail;
	fi;
	
	dim1:=SCDim(complex1);
	dim2:=SCDim(complex2);
	if dim1 = fail or dim2 = fail then
		Info(InfoSimpcomp,1,"SCConnectedSum: complexes must have the same dimension");
		return fail;
	fi;
	
	if dim1 < 1 or dim2 < 1 then
		Info(InfoSimpcomp,1,"SCConnectedSum: complexes must have at least dimension 1.");
		return fail;
	fi;
	
	if dim1 <> dim2 then
		Info(InfoSimpcomp,1,"SCConnectedSum: complexes are not of the same dimension.");
		return fail;
	fi;
	
	if HasSCName(complex1) and HasSCName(complex2) then
		name1:=SCName(complex1);
		name2:=SCName(complex2);
	fi;

	# compute maximal labels
	maxvertex1:=Maximum(SCVerticesEx(complex1));
	maxvertex2:=Maximum(SCVerticesEx(complex2));
	if maxvertex1=fail or maxvertex2=fail then
		Info(InfoSimpcomp,1,"SCConnectedSum: complex lacks vertex labels.");
		return fail;
	fi;
	
	# facets in standard labeling
	facets1:=SCIntFunc.DeepCopy(SCFacetsEx(complex1));
	facets2:=SCIntFunc.DeepCopy(SCFacetsEx(complex2)+maxvertex1);

	if facets1=fail or facets2=fail or name1 = fail or name2 = fail then
		Info(InfoSimpcomp,1,"SCConnectedSum: complex lacks name or facets.");	
		return fail;
	fi;
	
	facets:=SCIntFunc.ConnectedSumEx(facets1,facets2);
	facets1:=facets[1];
	facets2:=facets[2];
		
	for i in [1..Size(facets2)] do
		Sort(facets2[i]);
	od;
	Sort(facets2);
	
	if not IsSet(facets1) then
		facets1:=Set(facets1);
	fi;
	if not IsSet(facets2) then
		facets2:=Set(facets2);
	fi;
	
	sc:=SCFromFacets(Union(facets1,facets2));

	if(IsBound(name1) and IsBound(name2)) then
		SCRename(sc,Concatenation(name1,"#+-",name2));
	fi;

	return sc;

end);

################################################################################
##<#GAPDoc Label="SCConnectedProduct">
## <ManSection>
## <Meth Name="SCConnectedProduct" Arg="complex,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <M>n \geq 2</M>, the function internally calls <M>1 \times</M> <Ref Func="SCConnectedSum"/> and <M>(n-2) \times</M> <Ref Func="SCConnectedSumMinus"/>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("T^2"){[1..6]};
## [ [ 4, "T^2 (VT)" ], [ 5, "T^2 (VT)" ], [ 9, "T^2 (VT)" ], 
##   [ 10, "T^2 (VT)" ], [ 17, "T^2 (VT)" ], [ 20, "(T^2)#2" ] ]
## gap> torus:=SCLib.Load(last[1][1]);;
## gap> genus10:=SCConnectedProduct(torus,10);
## gap> genus10.Chi;
## -18
## gap> genus10.F;
## [ 43, 183, 122 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCConnectedProduct,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex, n)

	local maxvertex, newComplex, maptable, i, idx, tmp, sc, dim, facets, facets1, facets2, name, pure;

	if(not SCIsSimplicialComplex(complex)) then
		Info(InfoSimpcomp,1,"SCConnectedProduct: argument must be of type SCSimplicialComplex.");
		return fail;
	fi;
	
	pure:=SCIsPure(complex);
	if pure <> true then
		Info(InfoSimpcomp,1,"SCConnectedProduct: complex must be a pure simplicial complex.");
		return fail;
	fi;
	
	dim := SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	
	if dim < 1 then 
		Info(InfoSimpcomp,1,"SCConnectedProduct: complex must be at least of dimensions 1.");
		return fail;
	fi;
	
	if SCIsEmpty(complex) then
		Info(InfoSimpcomp,1,"SCConnectedProduct: complexes is empty.");
		return SCEmpty();
	fi;
	if n<1 then
		return SCEmpty();
	elif n=1 then
		return complex;
	else
		name:=SCName(complex);

		maxvertex:=Maximum(SCVerticesEx(complex));
		if maxvertex=fail then
			Info(InfoSimpcomp,1,"SCConnectedProduct: complex lacks vertex labels.");
			return fail;
		fi;
		
		# facets in standard labeling
		facets1:=SCIntFunc.DeepCopy(SCFacetsEx(complex));
		if facets1=fail then
			return fail;
		fi;

		for i in [1..(n-1)] do
			facets2:=SCIntFunc.DeepCopy(SCFacetsEx(complex)+i*maxvertex);
			facets1:=Concatenation(SCIntFunc.ConnectedSumEx(facets1,facets2));
		od;

		for i in [1..Size(facets1)] do
			Sort(facets1[i]);
		od;
		Sort(facets1);
		
		if not IsSet(facets1) then
			facets1:=Set(facets1);
		fi;

		sc:=SCFromFacets(facets1);
		
		if(name<>fail) then
			SCRename(sc,Concatenation(Concatenation(ListWithIdenticalEntries(n-1,Concatenation(name,"#+-"))),name));
		fi;
		
		return sc;
	fi;

end);

################################################################################
##<#GAPDoc Label="SCDifferenceCycleExpand">
## <ManSection>
## <Func Name="SCDifferenceCycleExpand" Arg="diffcycle"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <Arg>diffcycle</Arg> induces a simplex <M>\Delta = ( v_1 , \ldots , v_{n+1} )</M> by <M>v_1 = </M><Arg>diffcycle[1]</Arg>, <M>v_i = v_{i-1} + </M> <Arg>diffcycle[i]</Arg> and a cyclic group action by <M>\mathbb{Z}_{\sigma}</M> where <M>\sigma = \sum </M> <Arg>diffcycle[i]</Arg> is the modulus of <C>diffcycle</C>. The function returns the <M>\mathbb{Z}_{\sigma}</M>-orbit of <M>\Delta</M>.<P/>
## Note that modulo operations in &GAP; are often a little bit cumbersome, since all integer ranges usually start from <M>1</M>.
## <Example><![CDATA[
## gap> c:=SCDifferenceCycleExpand([1,1,2]);;
## gap> c.Facets;
## [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCDifferenceCycleExpand,
	function(diffcycle)
	local rs,i,modulus,orbit;

	if(Length(diffcycle)<1 or not ForAll(diffcycle,IsPosInt)) then
		Info(InfoSimpcomp,1,"SCDifferenceCycleExpand: invalid difference cycle.");
		return fail;
	fi;
		
	modulus:=Sum(diffcycle);
	rs:=[0];
	for i in [1..Length(diffcycle)-1] do
		rs[i+1]:=(rs[i]+diffcycle[i]) mod modulus;
	od;
	
	orbit:=[Set(rs)];
	for i in [1..modulus-1] do
		AddSet(orbit,Set((rs+i) mod modulus));
	od;
	
	return SCFromFacets(orbit+1);
end);

################################################################################
##<#GAPDoc Label="SCFromDifferenceCycles">
## <ManSection>
## <Meth Name="SCFromDifferenceCycles" Arg="diffcycles"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Creates a simplicial complex object from the list of difference cycles provided. If <Arg>diffcycles</Arg> is of length <M>1</M> the computation is equivalent to the one in <Ref Func="SCDifferenceCycleExpand"/>. Otherwise the induced modulus (the sum of all entries of a difference cycle) of all cycles has to be equal and the union of all expanded difference cycles is returned.<P/>
## A <M>n</M>-dimensional difference cycle <M>D = (d_1 : \ldots : d_{n+1})</M> induces a simplex <M>\Delta = ( v_1 , \ldots , v_{n+1} )</M> by <M>v_1 = d_1</M>, <M>v_i = v_{i-1} + d_i</M> and a cyclic group action by <M>\mathbb{Z}_{\sigma}</M> where <M>\sigma = \sum d_i</M> is the modulus of <M>D</M>. The function returns the <M>\mathbb{Z}_{\sigma}</M>-orbit of <M>\Delta</M>.<P/>
## Note that modulo operations in &GAP; are often a little bit cumbersome, since all integer ranges usually start from <M>1</M>.
## <Example><![CDATA[
## gap> c:=SCFromDifferenceCycles([[1,1,6],[2,3,3]]);;
## gap> c.F;
## [ 8, 24, 16 ]
## gap> c.Homology;
## [ [ 0, [  ] ], [ 2, [  ] ], [ 1, [  ] ] ]
## gap> c.Chi;
## 0
## gap> c.HasBoundary;
## false
## gap> SCIsPseudoManifold(c);
## true
## gap> SCIsManifold(c);
## #I  SCIsManifold: link is sphere.
## #I  SCIsManifold: transitive automorphism group, checking only one link.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCFromDifferenceCycles,
"for List of difference cycles",
[IsList],
function(diffcycles)

	local modulus,expanded,complex,facets;

	if(Length(diffcycles)<1 or not ForAll(diffcycles,IsList)) then
		Info(InfoSimpcomp,1,"SCFromDifferenceCycles: invalid difference cycle list.");
		return fail;
	fi;
	
	modulus:=Sum(diffcycles[1]);
	expanded:=List(diffcycles,SCDifferenceCycleExpand);

	if(ForAny(diffcycles,x->Sum(x)<>modulus) or fail in expanded) then
		Info(InfoSimpcomp,1,"SCFromDifferenceCycles: invalid difference cycle in arguments.");
		return fail;
	fi;
	
        facets:=List(expanded,SCFacets);
	complex:=SC(Union(facets));
	
	if complex=fail then
		return fail;
	fi;
	SetSCDifferenceCycles(complex,diffcycles);
	SCRename(complex,Concatenation("complex from diffcycles ",String(diffcycles)));
	
	return complex;
end);

################################################################################
##<#GAPDoc Label="SCDifferenceCycleCompress">
## <ManSection>
## <Func Name="SCDifferenceCycleCompress" Arg="simplex,modulus"/>
## <Returns> list with possibly duplicate entries upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## A difference cycle is returned, i. e. a list of integer values of length <M>(d+1)</M>, if <M>d</M> is the dimension of <Arg>simplex</Arg>, and a sum equal to <Arg>modulus</Arg>. In some sense this is the inverse operation of <Ref Func="SCDifferenceCycleExpand"/>.
## <Example><![CDATA[
## gap> sphere:=SCBdSimplex(4);;
## gap> gens:=SCGenerators(sphere);
## [ [ [ 1, 2, 3, 4 ], [ [ 5 ] ] ] ]
## gap> diffcycle:=SCDifferenceCycleCompress(gens[1][1],5);
## [ 1, 1, 1, 2 ]
## gap> c:=SCDifferenceCycleExpand([1,1,1,2]);;
## gap> c.Facets;
## [ [ 1, 2, 3, 4 ], [ 1, 2, 3, 5 ], [ 1, 2, 4, 5 ], [ 1, 3, 4, 5 ],
##   [ 2, 3, 4, 5 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCDifferenceCycleCompress,
	function(simplex,modulus)
	local dc,i,j,sum;
	
	if(Length(simplex)<2 or modulus<2 or not ForAll(simplex,x->x>=0)) then
		Info(InfoSimpcomp,1,"SCDifferenceCycleCompress: invalid simplex or simplex labeling.");
		return fail;
	fi;
	
	dc:=[];
	sum:=0;
	for i in [1..Length(simplex)-1] do
		dc[i]:=AbsoluteValue(simplex[i+1]-simplex[i]);
		sum:=sum+dc[i];
	od;
	
	dc[Length(simplex)]:=-sum mod modulus;
	return Set(Orbit(CyclicGroup(IsPermGroup,Length(simplex)),dc,Permuted))[1];
end);

################################################################################
##<#GAPDoc Label="SCStronglyConnectedComponents">
## <ManSection>
## <Meth Name="SCStronglyConnectedComponents" Arg="complex"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all strongly connected components of a pure simplicial complex.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[2,3,4],[4,5,6],[5,6,7]]);;
## gap> comps:=SCStronglyConnectedComponents(c);
## gap> comps[1].Facets;
## [ [ 1, 2, 3 ], [ 2, 3, 4 ] ]
## gap> comps[2].Facets;
## [ [ 4, 5, 6 ], [ 5, 6, 7 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCStronglyConnectedComponents,
"for SCSimplicialComplex and IsEmpty",
[SCIsSimplicialComplex and IsEmpty],
function(complex)
	SetSCIsStronglyConnected(complex,true);
	return [SCEmpty()];
end);

InstallMethod(SCStronglyConnectedComponents,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local ispure, i, j, flag, untreated, allComponents, curComponent, boundary, faces, labels, dim, facets, name;
	
	
	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCStronglyConnectedComponents: argument lacks vertex labels.");
		return fail;
	fi;
	
	dim := SCDim(complex);
	if dim = fail then
		return fail;
	fi;

	ispure := SCIsPure(complex);
	if ispure = fail then
		return fail;
	fi;

	if not ispure then
		Info(InfoSimpcomp,1,"SCStronglyConnectedComponents: argument must be a pure simplicial complex.");
		return fail;
	fi;

	if dim = 0 then
		facets:=SCFacets(complex);
		if facets = fail then
			return fail;
		fi;
		allComponents := List(facets,x->SC([x]));
		if fail in allComponents then
			return fail;
		fi;
		SetSCIsStronglyConnected(complex,Length(allComponents)=1);
		return allComponents;
	fi;

	untreated:=SCIntFunc.DeepCopy(SCFacetsEx(complex));
	if untreated=fail then
		return fail;
	fi;

	allComponents :=[];
	while untreated<>[] do
		curComponent:=[untreated[1]];
		Remove(untreated,1);
		flag:=0;
		while flag=0 do
			flag:=1;
			boundary:=SCBoundary(SC(curComponent));
			faces:=SCFacets(boundary);
			if faces=fail then
				return fail;
			fi;
			for i in faces do
				for j in Reversed([1..Size(untreated)]) do
					if IsSubset(untreated[j],i) then
						flag:=0;
						Add(curComponent,untreated[j]);
						Remove(untreated,j);
					fi;
				od;
			od;
		od;
		AddSet(allComponents,curComponent);
	od;



	name:=SCName(complex);
	if(name<>fail and Size(allComponents)>0) then
		for i in [1..Length(allComponents)] do
			allComponents[i]:=SCFromFacets(SCIntFunc.RelabelSimplexList(allComponents[i],labels));
			SCRename(allComponents[i],Concatenation(["Strongly connected component #",String(i)," of ",name]));
		od;
	fi;
	
	SetSCIsStronglyConnected(complex,Length(allComponents)=1);
	return allComponents;

end);

################################################################################
##<#GAPDoc Label="SCConnectedComponents">
## <ManSection>
## <Meth Name="SCConnectedComponents" Arg="complex"/>
## <Returns> a list of simplicial complexes of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes all connected components of an arbitrary simplicial complex.
## <Example><![CDATA[
## gap> c:=SC([[1,2,3],[3,4,5],[4,5,6,7,8]]);;
## gap> SCRename(c,"connected complex");;
## gap> SCConnectedComponents(c);
## gap> c:=SC([[1,2,3],[4,5],[6,7,8]]);;
## gap> SCRename(c,"non-connected complex");;
## gap> SCConnectedComponents(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>                                         
################################################################################
InstallMethod(SCConnectedComponents,
"for SCPolyhedralComplex and IsEmpty",
[SCIsPolyhedralComplex and IsEmpty],
function(complex)
	SetSCIsConnected(complex,true);
	return [SCEmpty()];
end);

InstallMethod(SCConnectedComponents,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)

	local vertices, star, conncomps, verticesComponent, innerVertices, treatedVertices, name, i, labels, span, facets, sc;
	

	labels:=SCVertices(complex);
	if(labels=fail) then
		Info(InfoSimpcomp,1,"SCConnectedComponents: complex lacks vertex labels.");
		return fail;
	fi;

	facets:=SCFacetsEx(complex);
	vertices:=SCVerticesEx(complex);
	if facets=fail or vertices=fail then
		return fail;
	fi;
	
	conncomps:=[];
	conncomps:=[];
	while vertices<>[] do 
		innerVertices:=[vertices[1]];
		treatedVertices:=[];
		verticesComponent:=[];
		while verticesComponent<>vertices and innerVertices<>[] do
			star:=Filtered(facets,x->innerVertices[1] in x);
			AddSet(treatedVertices,innerVertices[1]);
			RemoveSet(innerVertices,innerVertices[1]);
			innerVertices:=Union(innerVertices,Difference(Union(star),treatedVertices));
			verticesComponent:=Union(verticesComponent,Union(star));
		od;
		span:=Filtered(facets,x->IsSubset(verticesComponent,x));
		Add(conncomps,span);
		vertices:=Difference(vertices,verticesComponent);
	od;
	
	name:=SCName(complex);
	if name = fail then
		return fail;
	fi;
	
	if(Size(conncomps)>0) then
		for i in [1..Length(conncomps)] do
			conncomps[i]:=SCFromFacets(SCIntFunc.RelabelSimplexList(conncomps[i],labels));
			SCRename(conncomps[i],Concatenation(["Connected component #",String(i)," of ",name])); 
		od;
	fi;
	
	SetSCIsConnected(complex,Size(conncomps)=1);
	return conncomps;

end);

SCIntFunc.AGL1p:=function(p)

	local b,factor,start,i,j,perm,t,l,G;
	
	if(not IsPrime(p) or p < 5) then
		Info(InfoSimpcomp,1,"SCAGL1: argument must be a prime > 3.");
		return fail;
	fi;
	
	factor:=0;
	for j in [2..p-2] do
		if Gcd(j,p-1) = 1 then
			b:=[];
			b[1]:=1;
			b[2]:=j;
			start:=j;
			i:=3;
			while start <> 1 and i < p do
				start:=start*j mod p;
				b[i]:=start;
				i:=i+1;
			od;
			if i > p then 
				Info(InfoSimpcomp,1,"SCAGL1: no generator found.");
				return fail; 
			fi;
			if Size(b) = p-1 then
				factor:=j;
				break;
			fi;
		fi;
	od;
	if factor = 0 then 
		Info(InfoSimpcomp,1,"SCAGL1: no generator found.");
		return fail; 
	fi;
	
	perm:=List([1..p-1],x->factor*x mod p)+1;
	perm:=Concatenation([1],perm);
	l:=PermList(perm);
	t:=PermList(Concatenation([2..p],[1]));
	G:=Group(t,l);
	SetName(G,Concatenation("AGL(1,",String(p),")"));
	
	return G;
	
end;

################################################################################
##<#GAPDoc Label="SCSeriesAGL">
## <ManSection>
## <Func Name="SCSeriesAGL" Arg="p"/>
## <Returns> a permutation group and a list of <M>5</M>-tuples of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## For a given prime <Arg>p</Arg> the automorphism group (AGL<M>(1,p)</M>) and the generators of all members of the series of <M>2</M>-transitive combinatorial <M>4</M>-pseudomanifolds with <Arg>p</Arg> vertices from <Cite Key="Spreer10Diss"/>, Section 5.2, is computed. The affine linear group AGL<M>(1,p)</M> is returned as the first argument. If no member of the series with <Arg>p</Arg> vertices exists only the group is returned. 
## <Example><![CDATA[
## gap> gens:=SCSeriesAGL(17);
## [ AGL(1,17), [ [ 1, 2, 4, 8, 16 ] ] ]
## gap> c:=SCFromGenerators(gens[1],gens[2]);;
## gap> SCIsManifold(SCLink(c,1));
## true
## ]]></Example>
## <Example><![CDATA[
## gap> List([19..23],x->SCSeriesAGL(x));     
## #I  SCSeriesAGL: argument must be a prime > 13.
## #I  SCSeriesAGL: argument must be a prime > 13.
## #I  SCSeriesAGL: argument must be a prime > 13.
## [ [ AGL(1,19), [ [ 1, 2, 10, 12, 17 ] ] ], fail, fail, fail, 
##   [ AGL(1,23), [ [ 1, 2, 7, 9, 19 ], [ 1, 2, 4, 8, 22 ] ] ] ]
## gap> for i in [80000..80100] do if IsPrime(i) then Print(i,"\n"); fi; od;
## 80021
## 80039
## 80051
## 80071
## 80077
## gap> SCSeriesAGL(80021);                                                 
## [ AGL(1,80021), [  ] ]
## gap> SCSeriesAGL(80039);                                                 
## [ AGL(1,80039), [ [ 1, 2, 6496, 73546, 78018 ] ] ]
## gap> SCSeriesAGL(80051);                                                 
## [ AGL(1,80051), [ [ 1, 2, 31498, 37522, 48556 ] ] ]
## gap> SCSeriesAGL(80071);                                                 
## [ AGL(1,80071), [  ] ]
## gap> SCSeriesAGL(80077);                                                 
## [ AGL(1,80077), [ [ 1, 2, 4126, 39302, 40778 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesAGL,
	function(p)

	local b,factor,start,i,j,perm,t,l,candidates,c,G;

	if(not IsPrime(p) or p <= 14) then
		Info(InfoSimpcomp,1,"SCSeriesAGL: argument must be a prime > 13.");
		return fail;
	fi;
	
	factor:=0;
	for j in [2..p-2] do
		if Gcd(j,p-1) = 1 then
			b:=[];
			b[1]:=1;
			b[2]:=j;
			start:=j;
			i:=3;
			while start <> 1 and i < p do
				start:=start*j mod p;
				b[i]:=start;
				i:=i+1;
			od;
			if i > p then 
				Info(InfoSimpcomp,1,"SCSeriesAGL: no generator found.");
				return fail; 
			fi;
			if Size(b) = p-1 then
				factor:=j;
				break;
			fi;
		fi;
	od;
	if factor = 0 then 
		Info(InfoSimpcomp,1,"SCSeriesAGL: no generator found.");
		return fail; 
	fi;
	
	perm:=List([1..p-1],x->factor*x mod p)+1;
	perm:=Concatenation([1],perm);
	l:=PermList(perm);
	t:=PermList(Concatenation([2..p],[1]));
	G:=Group(t,l);
	SetName(G,Concatenation("AGL(1,",String(p),")"));
		
	candidates:=[];
	for i in [2..(p-1)] do

		if ((1-b[((2*(i-1)-0) mod (p-1)) + 1]) mod p = b[((3*(i-1)-0) mod (p-1)) +1]) then
			c:=[0,1,b[i],b[((2*(i-1)-0) mod (p-1)) + 1],b[((3*(i-1)-0) mod (p-1)) +1]];
			Sort(c);
			c:=c+1;
			Add(candidates,c);
		fi;
	od;
	
	if candidates=[] then	
		return G;
	else
		return [G,candidates];
	fi;

end);


################################################################################
##<#GAPDoc Label="SCSeriesBid">
## <ManSection>
## <Func Name="SCSeriesBid" Arg="i,d"/>
## <Returns> a simplicial complex upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Constructs the complex <M>B(i,d)</M> as described in <Cite Key="Klee11CentSymmMnfFewVert" />, cf. <Cite Key="Effenberger10Diss" />, <Cite Key="Sparla99LBTComb2kMnf" />. The complex <M>B(i,d)</M> is a <M>i</M>-Hamiltonian subcomplex of the <M>d</M>-cross polytope and its boundary topologically is a sphere product <M>S^i\times S^{d-i-2}</M> with vertex transitive automorphism group.   
## <Example><![CDATA[
## gap> b26:=SCSeriesBid(2,6);
## gap> s2s2:=SCBoundary(b26);
## gap> SCFVector(s2s2);
## gap> SCAutomorphismGroup(s2s2); 
## gap> SCIsManifold(s2s2); 
## gap> SCHomology(s2s2);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesBid,
	function(i,d)
	local facets,b,changes,f,j,c;
	
	if(not IsInt(i) or not IsPosInt(d) or i<0) then
		Info(InfoSimpcomp,1,"SCSeriesBid: argument i must be a non-negative integer between 0 and d-2, argument d a positive integer.");
		return fail;
	fi;	
	
	#returns list of facets with exactly b "changes"
	changes:=function(b)
		local i,o,c;
		o:=b[1];
		c:=0;
		for i in b{[2..Length(b)]} do
			if(i<>o) then
				c:=c+1;
				o:=i;
			fi;
		od;
		return c;
	end;
	
	#generate facet list
	facets:=[];
	for b in Cartesian(ListWithIdenticalEntries(d,[0,1])) do
		if(changes(b)<=i) then
			#build facet
			f:=[];
			for j in [1..Length(b)] do
				if(b[j]=1) then
					f[j]:=d+j;
				else
					f[j]:=j;
				fi;
			od;
			
			Add(facets,f);
		fi;
	od;
	
	c:=SCFromFacets(facets);
	SCRename(c,Concatenation("B(",String(i),",",String(d),")"));
	SCSetReference(c,"S. Klee and I. Novik, Centrally symmetric manifolds with few vertices, arXiv:1102.0542v1 [math.CO], Preprint, 15 pages, 2011.");
	return c;
end);




################################################################################
##<#GAPDoc Label="SCSeriesC2n">
## <ManSection>
## <Func Name="SCSeriesC2n" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the combinatorial <M>3</M>-manifold <M>C_{2n}</M>, <M>n \geq 8</M>, with <M>2n</M> vertices from <Cite Key="Spreer10Diss"/>, Section 4.5.3 and Section 5.2. The complex is homeomorphic to <M>S^2 \times S^1</M> for <M>n</M> odd and homeomorphic to <M>S^2 \dtimes S^1</M> in case <M>n</M> is an even number. In the latter case <M>C_{2n}</M> is isomorphic to <M>D_{2n}</M> from <Ref Func="SCSeriesD2n"/>. The complexes are believed to appear as the vertex links of some of the members of the series of <M>2</M>-transitive <M>4</M>-pseudomanifolds from <Ref Func="SCSeriesAGL"/>. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesC2n(8);
## gap> SCGenerators(c);  
## [ [ [ 1, 2, 3, 6 ], 32 ], [ [ 1, 2, 5, 6 ], 16 ], [ [ 1, 3, 6, 8 ], 16 ], 
##   [ [ 1, 3, 8, 10 ], 16 ] ]
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCSeriesC2n(8);;
## gap> d:=SCSeriesD2n(8); 
## gap> SCIsIsomorphic(c,d);
## true
## gap> c:=SCSeriesC2n(11);;
## gap> d:=SCSeriesD2n(11);;
## gap> c.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ]
## gap> d.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesC2n,
	function(n)

	local c;

	if(not IsInt(n) or n < 8) then
		Info(InfoSimpcomp,1,"SCSeriesC2n: argument must be an integer > 7.");
		return fail;
	fi;
	
	c:=SCFromDifferenceCycles([[1,1,n-5,n+3],[1,1,n+3,n-5],[1,n-5,1,n+3],[2,n-5,2,n+1],[2,n-3,2,n-1]]);
	SCRename(c,Concatenation(["C_",String(2*n)," = { (1:1:",String(n-5),":",String(n+3),"),(1:1:",String(n+3),":",String(n-5),"),(1:",String(n-5),":1:",String(n+3),"),(2:",String(n-5),":2:",String(n+1),"),(2:",String(n-3),":2:",String(n-1),") }"]));
	if not IsInt(n/2) then
		SetSCTopologicalType(c,"S^2 x S^1");
	else
		SetSCTopologicalType(c,"S^2 ~ S^1");
	fi;

	return c;

end);

################################################################################
##<#GAPDoc Label="SCSeriesD2n">
## <ManSection>
## <Func Name="SCSeriesD2n" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the combinatorial <M>3</M>-manifold <M>D_{2n}</M>, <M>n \geq 8</M>, <M>n \neq 9</M>, with <M>2n</M> vertices from <Cite Key="Spreer10Diss"/>, Section 4.5.3 and Section 5.2. The complex is homeomorphic to <M>S^2 \dtimes S^1</M>. In the case that <M>n</M> is even <M>D_{2n}</M> is isomorphic to <M>C_{2n}</M> from <Ref Func="SCSeriesC2n"/>. The complexes are believed to appear as the vertex links of some of the members of the series of <M>2</M>-transitive <M>4</M>-pseudomanifolds from <Ref Func="SCSeriesAGL"/>. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> d:=SCSeriesD2n(15);
## gap> SCAutomorphismGroup(d);  
## TransitiveGroup(30,14) = t30n14
## gap> StructureDescription(last);
## "D60"
## ]]></Example>
## <Example><![CDATA[
## gap> c:=SCSeriesC2n(8);;
## gap> d:=SCSeriesD2n(8); 
## gap> SCIsIsomorphic(c,d);
## true
## gap> c:=SCSeriesC2n(11);;
## gap> d:=SCSeriesD2n(11);;
## gap> c.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ]
## gap> d.Homology;
## [ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesD2n,
	function(n)

	local c;

	if(not IsInt(n) or n < 8 or n=9) then
		Info(InfoSimpcomp,1,"SCSeriesD2n: argument must be an integer > 7 not equal to 9.");
		return fail;
	fi;
	
	c:=SCFromDifferenceCycles([[1,1,1,2*n-3],[1,2,2*n-5,2],[3,n-4,5,n-4],[2,3,n-4,n-1],[2,n-1,n-4,3]]);
	SCRename(c,Concatenation(["D_",String(2*n)," = { (1:1:1:",String(2*n-3),"),(1:2:",String(2*n-5),":2),(3:",String(n-4),":5:",String(n-4),"),(2:3:",String(n-4),":",String(n-1),"),(2:",String(n-1),":",String(n-4),":3) }"]));
	SetSCTopologicalType(c,"S^2 ~ S^1");
	
	return c;

end);

################################################################################
##<#GAPDoc Label="SCSeriesKu">
## <ManSection>
## <Func Name="SCSeriesKu" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the symmetric orientable sphere bundle Ku<M>(n)</M> with <M>4n</M> vertices from <Cite Key="Spreer10Diss"/>, Section 4.5.2. The series is defined as a generalization of the slicings from <Cite Key="Spreer10Diss"/>, Section 3.3.
## <Example><![CDATA[
## gap> c:=SCSeriesKu(4);                                    
## gap> SCSlicing(c,[[1,2,3,4,9,10,11,12],[5,6,7,8,13,14,15,16]]);
## gap> Mminus:=SCSpan(c,[1,2,3,4,9,10,11,12]);;                  
## gap> Mplus:=SCSpan(c,[5,6,7,8,13,14,15,16]);;                  
## gap> SCCollapseGreedy(Mminus).Facets;
## gap> SCCollapseGreedy(Mplus).Facets; 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesKu,
function(n)

	local G, orbs, tmp, perm, i, c;

	if(not IsInt(n) or n < 3) then
		Info(InfoSimpcomp,1,"SCSeriesKu: argument must be an integer > 2.");
		return fail;
	fi;

	perm:=[];
	tmp:=[];
	for i in [1..n] do
		tmp[i]:=2*n-i+1;
		tmp[n+i]:=n-i+1;
		tmp[2*n+i]:=4*n-i+1;
		tmp[3*n+i]:=3*n-i+1;
	od;	
	perm[1]:=PermList(tmp);

	tmp:=[];
	for i in [1..n] do
		tmp[i]:=n+i;
		if i < n then
			tmp[n+i]:=i+1;
			tmp[3*n+i]:=2*n+i+1;
		elif i = n then
			tmp[n+i]:=1;
			tmp[3*n+i]:=2*n+1;
		fi;
		tmp[2*n+i]:=3*n+i;
		
	od;	
	perm[2]:=PermList(tmp);

	tmp:=[];
	for i in [1..2*n] do
		tmp[i]:=4*n-i+1;
		tmp[4*n-i+1]:=i;
	od;	
	perm[3]:=PermList(tmp);

        if perm = [] then
          G:=Group(());
        else
          G:=Group(perm);
        fi;
	c:=SCFromGenerators(G,[[1,2,n+1,2*n+1],[1,2,2*n+1,2*n+2],[1,n+1,2*n+1,4*n]]);
	SCRename(c,Concatenation(["Sl_",String(4*n)," = G{ [1,2,",String(n+1),",",String(2*n+1),"],[1,2,",String(2*n+1),",",String(2*n+2),"],[1,",String(n+1),",",String(2*n+1),",",String(4*n),"] }"]));
	return c;

end);

################################################################################
##<#GAPDoc Label="SCSeriesCSTSurface">
## <ManSection>
## <Func Name="SCSeriesCSTSurface" Arg="l,[j,]2k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <C>SCSeriesCSTSurface(l,j,2k)</C> generates the centrally symmetric transitive (cst) surface <M>S_{(l,j,2k)}</M>, <C>SCSeriesCSTSurface(l,2k)</C> generates the cst surface <M>S_{(l,2k)}</M> from <Cite Key="Spreer10PartBetaK"/>, Section 4.4.
## <Example><![CDATA[
## gap> SCSeriesCSTSurface(2,4,14);
## gap> last.Homology;
## [ [ 1, [  ] ], [ 4, [  ] ], [ 2, [  ] ] ]
## gap> SCSeriesCSTSurface(2,10);  
## gap> last.Homology;                    
## [ [ 0, [  ] ], [ 1, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesCSTSurface,
function(arg)

	local n,l,j,S;

	if Size(arg) < 2 or Size(arg) > 3 then
		Info(InfoSimpcomp,1,"SCSeriesCSTSurface: there must be either 2 or 3 arguments.");
		return fail;
	fi;
	
	if Size(arg) = 3 then
		n:=arg[3];
		l:=arg[1];
		j:=arg[2];
		if not IsPosInt(l) or not IsPosInt(j) or not IsPosInt(n/2) or n < 3 or j = n/2 or l = n/2 or j+l = n/2 or l >= j  or j >= n-l-j then
			Info(InfoSimpcomp,1,"SCSeriesCSTSurface: 2k must be an even number, k>2, l,j and l+j must be different from k and l < j < 2k-l-j must hold.");
			return fail;
		fi;
		S:=SCFromDifferenceCycles([[l,j,n-l-j],[l,n-l-j,j]]);
		SCRename(S,Concatenation(["cst surface S_{(",String(l),",",String(j),",",String(n),")} = { (",String(l),":",String(j),":",String(n-l-j),"),(",String(l),":",String(n-l-j),":",String(j),") }"]));
		return S;
	elif Size(arg) = 2 then
		n:=arg[2];
		l:=arg[1];
		if not IsPosInt(l) or not IsPosInt(n/2) or n < 3 or l > (n/2-1)/2 then
			Info(InfoSimpcomp,1,"SCSeriesCSTSurface: 2k must be an even number, k > 2, and l <= (k-1)/2.");
			return fail;
		fi;
		S:=SCFromDifferenceCycles([[l,l,n-2*l],[n/2-l,n/2-l,2*l]]);
		SCRename(S,Concatenation(["cst surface S_{(",String(l),",",String(n),")} = { (",String(l),":",String(l),":",String(n-2*l),"),(",String(n/2-l),":",String(n/2-l),":",String(2*l),") }"]));
		return S;
	fi;

end);

################################################################################
##<#GAPDoc Label="SCSeriesHandleBody">
## <ManSection>
## <Func Name="SCSeriesHandleBody" Arg="d,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <C>SCSeriesHandleBody(d,n)</C> generates a transitive <M>d</M>-dimensional handle body (<M>d \geq 3</M>) with <M>n</M> vertices (<M>n \geq 2d + 1</M>). The handle body is orientable if <M>d</M> is odd or if <M>d</M> and <M>n</M> are even, otherwise it is not orientable. The complex equals the difference cycle <M>(1 : \ldots : 1 : n-d)</M> To obtain the boundary complexes of <C>SCSeriesHandleBody(d,n)</C> use the function <Ref Func="SCSeriesBdHandleBody"/>. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesHandleBody(3,7);
## gap> SCAutomorphismGroup(c);    
## PrimitiveGroup(7,2) = D(2*7)
## gap> bd:=SCBoundary(c);;
## gap> SCAutomorphismGroup(bd);
## PrimitiveGroup(7,4) = AGL(1, 7)
## gap> SCIsIsomorphic(bd,SCSeriesBdHandleBody(2,7));
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesHandleBody,
function(d,n)

	local S;

	if not IsPosInt(d) or not IsPosInt(n) or d < 3 or n < 2*d + 1 then
		Info(InfoSimpcomp,1,"SCSeriesHandleBody: the first argument d must be an integer >= 3, the second argument n must fulfill n >= 2d + 1");
		return fail;
	fi;
	
	S:=SCFromDifferenceCycles([Concatenation(ListWithIdenticalEntries(d,1),[n-d])]);
	if IsInt(d/2) and not IsInt(n/2) then
		SCRename(S,Concatenation(["Handle body B^",String(d-1)," ~ S^1"]));
		SetSCTopologicalType(S,Concatenation(["B^",String(d-1)," ~ S^1"]));
		SetSCIsOrientable(S,false);
	else
		SCRename(S,Concatenation(["Handle body B^",String(d-1)," x S^1"]));
		SetSCTopologicalType(S,Concatenation(["B^",String(d-1)," x S^1"]));
		SetSCIsOrientable(S,true);
	fi;
	return S;

end);

################################################################################
##<#GAPDoc Label="SCSeriesBdHandleBody">
## <ManSection>
## <Func Name="SCSeriesBdHandleBody" Arg="d,n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## <C>SCSeriesBdHandleBody(d,n)</C> generates a transitive <M>d</M>-dimensional sphere bundle (<M>d \geq 2</M>) with <M>n</M> vertices (<M>n \geq 2d + 3</M>) which coincides with the boundary of <Ref Func="SCSeriesHandleBody"/><C>(d,n)</C>. The sphere bundle is orientable if <M>d</M> is even or if <M>d</M> is odd and <M>n</M> is even, otherwise it is not orientable. Internally calls <Ref Func="SCFromDifferenceCycles"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(2,7);
## gap> SCLib.DetermineTopologicalType(c);
## gap> SCIsIsomorphic(c,SCSeriesHandleBody(3,7).Boundary);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesBdHandleBody,
function(d,n)

	local S;

	if not IsPosInt(d) or not IsPosInt(n) or d < 2 or n < 2*d + 3 then
		Info(InfoSimpcomp,1,"SCSeriesBdHandleBody: the first argument d must be an integer >= 2, the second argument n must fulfill n >= 2d + 3");
		return fail;
	fi;
	
	S:=SCBoundary(SCFromDifferenceCycles([Concatenation(ListWithIdenticalEntries(d+1,1),[n-d-1])]));
	if not IsInt(d/2) and not IsInt(n/2) then
		SCRename(S,Concatenation(["Sphere bundle S^",String(d-1)," ~ S^1"]));
		SetSCTopologicalType(S,Concatenation(["S^",String(d-1)," ~ S^1"]));
		SetSCIsOrientable(S,false);
	else
		SCRename(S,Concatenation(["Sphere bundle S^",String(d-1)," x S^1"]));
		SetSCTopologicalType(S,Concatenation(["S^",String(d-1)," x S^1"]));
		SetSCIsOrientable(S,true);
	fi;
	return S;

end);


################################################################################
##<#GAPDoc Label="SCSeriesLe">
## <ManSection>
## <Func Name="SCSeriesLe" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>k</Arg>-th member (<M>k \geq 7</M>) of the series <C>Le</C> from <Cite Key="Spreer10Diss"/>, Section 4.5.1. The series can be constructed as the generalization of the boundary of a genus <M>1</M> handlebody decomposition of the manifold <C>manifold_3_14_1_5</C> from the classification in <Cite Key="Lutz03TrigMnfFewVertVertTrans"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesLe(7);                     
## gap> d:=SCLib.DetermineTopologicalType(c);;
## gap> SCReference(d);
## "manifold_3_14_1_5 in F.H.Lutz: 'The Manifold Page', http://www.math.tu-berlin\
## .de/diskregeom/stellar/,\nF.H.Lutz: 'Triangulated manifolds with few vertices \
## and vertex-transitive group actions', Doctoral Thesis TU Berlin 1999, Shaker-V\
## erlag, Aachen 1999"
## gap>  
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesLe,
	function(k)

	local gens,c,l;

	if(not IsInt(k) or not k > 6) then
		Info(InfoSimpcomp,1,"SCSeriesLe: argument must be an integer > 6.");
		return fail;
	fi;
	
	gens:=[[1,1,1,2*k-3],[1,2,k-3,k],[1,k-3,2,k],[2,1,k-3,k],[2,k-2,2,k-2],[2,k-3,2,k-1]];
	c:=SCFromDifferenceCycles(gens);
	SCRename(c,Concatenation(["Le_",String(2*k)," = { (1:1:1:",String(2*k-3),"),(1:2:",String(k-3),":",String(k),"),(1:",String(k-3),":2:",String(k),"),(2:1:",String(k-3),":",String(k),"),(2:",String(k-2),":2:",String(k-2),"),(2:",String(k-3),":2:",String(k-1),") }"]));
	
	return c;

end);


################################################################################
##<#GAPDoc Label="SCSeriesL">
## <ManSection>
## <Func Name="SCSeriesL" Arg="i,k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>k</Arg>-th member (<M>k \geq 0</M>) of the series <Arg>L^i</Arg>, <M>1 \leq i \leq 18</M>  from <Cite Key="Spreer10Diss"/>. The <M>18</M> series describe a complete classification of all series of cyclic <M>3</M>-manifolds with a fixed number of difference cycles of order <M>2</M> (i. e. there is a member of the series for every second integer, <M>f_0 (L^i (k+1) ) = f_0 (L^i (k)) +2</M>) and at least one member with less than <M>15</M> vertices where each series does not appear as a sub series of one of the series <M>K^i</M> from <Ref Func="SCSeriesK"/>.
## <Example><![CDATA[
## gap> cc:=List([1..18],x->SCSeriesL(x,0));;
## gap> Set(List(cc,x->x.F));
## [ [ 10, 45, 70, 35 ], [ 12, 60, 96, 48 ], [ 12, 66, 108, 54 ], 
##   [ 14, 77, 126, 63 ], [ 14, 84, 140, 70 ], [ 14, 91, 154, 77 ] ]
## gap> cc:=List([1..18],x->SCSeriesL(x,10));; 
## gap> Set(List(cc,x->x.IsManifold));
## [ true ]
## gap>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesL,
	function(i,k)

	local dc,c;

	if(not IsInt(k) or not k >= 0 or not i in [1..18]) then
		Info(InfoSimpcomp,1,"SCSeriesL: 'i' must be in [1..18], 'k' must be an integer >= 0.");
		return fail;
	fi;
	
	dc:=[
		# n = 10
		[[1,1,3+k,5+k,],[1,1,4+k,4+k,],[1,3+k,2,4+k,],[2,3+k,2,3+k,]],
		[[1,1,3+k,5+k,],[1,1,5+k,3+k,],[1,3+k,1,5+k,],[2,3+k,2,3+k,]],
		[[1,3+k,1,5+k,],[1,3+k,2,4+k,],[1,4+k,2,3+k,],[2,3+k,2,3+k,]],
		# n = 12
		[[1,1,1,9+2*k,],[1,2,4+k,5+k,],[1,4+k,2,5+k,],[1,4+k,5+k,2,],[2,4+k,2,4+k,]],
		[[1,1,1,9+2*k,],[1,2,5+k,4+k,],[1,4+k,3,4+k,],[1,4+k,5+k,2,]],
		[[1,1,3+k,7+k,],[1,1,4+k,6+k,],[1,3+k,2,6+k,],[2,3+k,2,5+k,],[2,4+k,2,4+k,]],
		[[1,1,3+k,7+k,],[1,1,6+k,4+k,],[1,3+k,1,7+k,],[1,6+k,2,3+k,],[2,4+k,2,4+k,]],
		[[1,1,3+k,7+k,],[1,1,7+k,3+k,],[1,3+k,1,7+k,],[2,3+k,2,5+k,]],
		[[1,2,4+k,5+k,],[1,2,5+k,4+k,],[1,4+k,2,5+k,],[1,4+k,3,4+k,],[2,4+k,2,4+k,]],
		# n = 14
		[[1,1,1,11+2*k,],[1,2,1,10+2*k,],[1,3,5+k,5+k,],[1,5+k,3,5+k,],[1,5+k,5+k,3,]],
		[[1,1,1,11+2*k,],[1,2,4+k,7+k,],[1,6+k,5+k,2,],[2,4+k,2,6+k,],[2,5+k,2,5+k,],[2,5+k,3,4+k,]],
		[[1,1,3+k,9+k,],[1,1,4+k,8+k,],[1,3+k,2,8+k,],[2,3+k,2,7+k,],[2,4+k,2,6+k,],[2,5+k,2,5+k,]],
		[[1,1,3+k,9+k,],[1,1,7+k,5+k,],[1,3+k,1,9+k,],[1,7+k,2,4+k,],[1,8+k,2,3+k,],[2,5+k,2,5+k,]],
		[[1,1,3+k,9+k,],[1,1,8+k,4+k,],[1,3+k,1,9+k,],[1,8+k,2,3+k,],[2,4+k,2,6+k,]],
		[[1,1,3+k,9+k,],[1,1,8+k,4+k,],[1,3+k,2,8+k,],[1,4+k,1,8+k,],[2,3+k,2,7+k,],[2,5+k,2,5+k,]],
		[[1,1,3+k,9+k,],[1,1,9+k,3+k,],[1,3+k,1,9+k,],[2,3+k,2,7+k,],[2,5+k,2,5+k,]],
		[[1,4+k,1,8+k,],[1,4+k,2,7+k,],[1,5+k,3,5+k,],[1,6+k,3,4+k,],[2,5+k,2,5+k,],[2,5+k,3,4+k,]],
		[[1,4+k,1,8+k,],[1,4+k,7+k,2,],[1,5+k,3,5+k,],[1,6+k,3,4+k,],[1,6+k,5+k,2,],[2,5+k,2,5+k,]]
	];	
	
	c:=SCFromDifferenceCycles(dc[i]);
	SCRename(c,Concatenation(["L^",String(i),"_",String(2*k)]));
	
	return c;

end);


################################################################################
##<#GAPDoc Label="SCSeriesK">
## <ManSection>
## <Func Name="SCSeriesK" Arg="i,k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the <Arg>k</Arg>-th member (<M>k \geq 0</M>) of the series <Arg>K^i</Arg>  (<M>1 \leq i \leq 396</M>) from <Cite Key="Spreer10Diss"/>.  The <M>396</M> series describe a complete classification of all dense series (i. e. there is a member of the series for every integer, <M>f_0 (K^i (k+1) ) = f_0 (K^i (k)) +1</M>) of cyclic <M>3</M>-manifolds with a fixed number of difference cycles and at least one member with less than <M>23</M> vertices. See <Ref Func="SCSeriesL"/> for a list of series of order <M>2</M>.
## <Example><![CDATA[
## gap> cc:=List([1..10],x->SCSeriesK(x,0));;                                                                                                                                                                                                  
## gap> Set(List(cc,x->x.F));                                                                                                                                                                                                                        
## gap> cc:=List([1..10],x->SCSeriesK(x,10));;
## gap> gap> cc:=List([1..10],x->SCSeriesK(x,10));;
## gap> Set(List(cc,x->x.Homology));
## gap> Set(List(cc,x->x.IsManifold));
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesK,
	function(i,k)

	local dc,c;

	if(not IsInt(k) or not k >= 0 or not i in [1..396]) then
		Info(InfoSimpcomp,1,"SCSeriesK: 'i' must be in [1..396], 'k' must be an integer >= 0.");
		return fail;
	fi;
	
  dc:=[
		# n = 9
		[[1,1,2,5+k],[1,1,5+k,2],[1,2,1,5+k]],
		# n = 11
		[[1,1,2,7+k],[1,1,6+k,3],[1,2,2,6+k],[1,3,1,6+k]],
		# n = 13
		[[1,1,2,9+k],[1,1,7+k,4],[1,2,2,8+k],[1,3,2,7+k],[1,4,1,7+k]],
		[[1,1,3,8+k],[1,1,7+k,4],[1,3,1,8+k],[1,7+k,2,3],[2,2,2,7+k]],
		[[1,1,4,7+k],[1,1,7+k,4],[1,4,1,7+k],[2,2,2,7+k]],
		[[1,2,1,9+k],[1,2,7+k,3],[1,3,7+k,2],[2,2,2,7+k]],
		[[1,2,3,7+k],[1,2,8+k,2],[1,3,2,7+k],[1,3,7+k,2],[2,2,2,7+k]],
		# n = 15
		[[1,1,2,11+k],[1,1,8+k,5],[1,2,2,10+k],[1,3,2,9+k],[1,4,2,8+k],[1,5,1,8+k]],
		[[1,1,4,9+k],[1,1,8+k,5],[1,2,2,10+k],[1,2,4,8+k],[1,5,1,8+k],[2,2,8+k,3]],
		[[1,1,4,9+k],[1,1,8+k,5],[1,4,2,8+k],[1,5,1,8+k],[2,2,2,9+k]],
		[[1,2,2,10+k],[1,2,8+k,4],[1,3,1,10+k],[1,3,8+k,3],[2,2,8+k,3]],
		[[1,2,2,10+k],[1,2,9+k,3],[1,3,3,8+k],[1,3,8+k,3],[1,4,2,8+k],[2,2,8+k,3]],
		[[1,2,4,8+k],[1,2,8+k,4],[1,3,1,10+k],[1,3,8+k,3],[1,4,2,8+k],[2,2,2,9+k]],
		[[1,2,4,8+k],[1,2,8+k,4],[1,4,2,8+k],[1,4,8+k,2],[1,8+k,2,4],[1,8+k,4,2]],
		[[1,2,4,8+k],[1,2,9+k,3],[1,3,3,8+k],[1,3,8+k,3],[2,2,2,9+k]],
		# n = 17
		[[1,1,2,13+k],[1,1,9+k,6],[1,2,2,12+k],[1,3,2,11+k],[1,4,2,10+k],[1,5,2,9+k],[1,6,1,9+k]],
		[[1,1,3,12+k],[1,1,9+k,6],[1,3,3,10+k],[1,4,3,9+k],[1,6,1,9+k],[2,3,9+k,3],[2,9+k,3,3]],
		[[1,1,4,11+k],[1,1,9+k,6],[1,2,2,12+k],[1,2,4,10+k],[1,5,2,9+k],[1,6,1,9+k],[2,2,10+k,3]],
		[[1,1,4,11+k],[1,1,9+k,6],[1,4,2,10+k],[1,5,2,9+k],[1,6,1,9+k],[2,2,2,11+k]],
		[[1,1,4,11+k],[1,1,9+k,6],[1,4,3,9+k],[1,5,2,9+k],[1,9+k,5,2],[1,10+k,4,2],[2,2,2,11+k]],
		[[1,1,5,10+k],[1,1,9+k,6],[1,5,1,10+k],[1,9+k,2,5],[2,2,2,11+k],[2,4,2,9+k]],
		[[1,1,6,9+k],[1,1,9+k,6],[1,6,1,9+k],[2,2,2,11+k],[2,4,2,9+k]],
		[[1,1,6,9+k],[1,1,9+k,6],[1,6,1,9+k],[2,3,3,9+k],[2,3,9+k,3],[2,9+k,3,3]],
		[[1,2,2,12+k],[1,2,9+k,5],[1,3,2,11+k],[1,3,9+k,4],[1,4,1,11+k],[2,2,9+k,4]],
		[[1,2,2,12+k],[1,2,9+k,5],[1,3,4,9+k],[1,3,9+k,4],[1,4,1,11+k],[1,5,2,9+k],[2,2,10+k,3]],
		[[1,2,2,12+k],[1,2,10+k,4],[1,3,2,11+k],[1,3,9+k,4],[1,4,3,9+k],[1,5,2,9+k],[2,2,9+k,4]],
		[[1,2,2,12+k],[1,2,10+k,4],[1,3,4,9+k],[1,3,9+k,4],[1,4,3,9+k],[2,2,10+k,3]],
		[[1,2,2,12+k],[1,2,10+k,4],[1,4,9+k,3],[1,9+k,3,4],[1,9+k,4,3],[2,2,10+k,3]],
		[[1,2,3,11+k],[1,2,12+k,2],[1,5,9+k,2],[2,2,2,11+k],[2,4,2,9+k],[2,9+k,3,3]],
		[[1,2,4,10+k],[1,2,9+k,5],[1,4,2,10+k],[1,4,10+k,2],[1,9+k,2,5],[1,9+k,5,2],[2,4,2,9+k]],
		[[1,2,4,10+k],[1,2,10+k,4],[1,3,4,9+k],[1,3,9+k,4],[1,4,2,10+k],[1,4,3,9+k],[2,2,2,11+k]],
		[[1,2,4,10+k],[1,2,10+k,4],[1,4,2,10+k],[1,4,9+k,3],[1,9+k,3,4],[1,9+k,4,3],[2,2,2,11+k]],
		[[1,2,4,10+k],[1,2,10+k,4],[1,4,3,9+k],[1,4,10+k,2],[1,6,1,9+k],[1,9+k,5,2],[1,10+k,2,4]],
		[[1,2,5,9+k],[1,2,9+k,5],[1,4,1,11+k],[1,4,10+k,2],[1,5,2,9+k],[1,9+k,3,4],[1,9+k,5,2]],
		[[1,2,5,9+k],[1,2,9+k,5],[1,5,2,9+k],[1,5,9+k,2],[1,9+k,2,5],[1,9+k,5,2]],
		[[1,2,5,9+k],[1,2,10+k,4],[1,4,3,9+k],[1,4,10+k,2],[1,9+k,3,4],[1,9+k,5,2]],
		[[1,2,5,9+k],[1,2,12+k,2],[1,5,2,9+k],[1,5,9+k,2],[2,2,2,11+k],[2,3,2,10+k],[2,4,2,9+k]],
		[[1,2,9+k,5],[1,2,11+k,3],[1,11+k,2,3],[2,2,2,11+k],[2,3,9+k,3],[2,9+k,3,3]],
		[[1,2,10+k,4],[1,2,11+k,3],[1,9+k,3,4],[1,9+k,4,3],[2,2,9+k,4],[2,2,10+k,3],[2,9+k,3,3]],
		[[1,3,3,10+k],[1,3,10+k,3],[1,4,2,10+k],[1,4,9+k,3],[2,2,9+k,4],[2,2,10+k,3],[2,9+k,3,3]],
		[[2,2,2,11+k],[2,3,3,9+k],[2,3,9+k,3],[2,4,2,9+k],[2,9+k,3,3]],
		[[2,2,4,9+k],[2,2,9+k,4],[2,4,2,9+k]],
		# n = 19
		[[1,1,2,15+k],[1,1,10+k,7],[1,2,2,14+k],[1,3,2,13+k],[1,4,2,12+k],[1,5,2,11+k],[1,6,2,10+k],[1,7,1,10+k]],
		[[1,1,3,14+k],[1,1,10+k,7],[1,3,2,13+k],[1,4,3,11+k],[1,5,3,10+k],[1,7,1,10+k],[2,3,10+k,4],[2,10+k,4,3]],
		[[1,1,3,14+k],[1,1,10+k,7],[1,3,3,12+k],[1,4,3,11+k],[1,6,2,10+k],[1,7,1,10+k],[2,3,11+k,3],[2,11+k,3,3]],
		[[1,1,3,14+k],[1,1,10+k,7],[1,3,5,10+k],[1,4,3,11+k],[1,7,1,10+k],[2,3,11+k,3],[2,10+k,4,3]],
		[[1,1,3,14+k],[1,1,11+k,6],[1,3,5,10+k],[1,4,3,11+k],[1,6,1,11+k],[1,6,2,10+k],[2,3,11+k,3],[2,10+k,4,3]],
		[[1,1,4,13+k],[1,1,10+k,7],[1,2,2,14+k],[1,2,4,12+k],[1,5,2,11+k],[1,6,2,10+k],[1,7,1,10+k],[2,2,12+k,3]],
		[[1,1,4,13+k],[1,1,10+k,7],[1,3,2,13+k],[1,3,4,11+k],[1,4,4,10+k],[1,7,1,10+k],[2,4,10+k,3],[2,10+k,3,4]],
		[[1,1,4,13+k],[1,1,10+k,7],[1,4,2,12+k],[1,5,2,11+k],[1,6,2,10+k],[1,7,1,10+k],[2,2,2,13+k]],
		[[1,1,4,13+k],[1,1,10+k,7],[1,4,2,12+k],[1,5,3,10+k],[1,6,2,10+k],[1,10+k,6,2],[1,11+k,5,2],[2,2,2,13+k]],
		[[1,1,4,13+k],[1,1,11+k,6],[1,4,3,11+k],[1,5,3,10+k],[1,7,1,10+k],[1,10+k,6,2],[1,12+k,4,2],[2,2,2,13+k]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,2,2,14+k],[1,2,6,10+k],[1,4,2,12+k],[1,7,1,10+k],[2,2,12+k,3],[2,10+k,3,4]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,2,4,12+k],[1,2,5,11+k],[1,10+k,3,5],[1,11+k,2,5],[2,2,2,13+k],[2,10+k,3,4]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,2,4,12+k],[1,2,6,10+k],[1,7,1,10+k],[2,2,2,13+k],[2,10+k,3,4]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,2,4,12+k],[1,2,6,10+k],[1,7,1,10+k],[2,2,10+k,5],[2,2,12+k,3],[2,4,10+k,3]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,3,3,12+k],[1,3,5,10+k],[1,7,1,10+k],[2,3,3,11+k],[2,3,11+k,3],[2,10+k,4,3]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,6,2,10+k],[1,7,1,10+k],[2,2,2,13+k],[2,4,2,11+k]],
		[[1,1,6,11+k],[1,1,10+k,7],[1,6,2,10+k],[1,7,1,10+k],[2,3,3,11+k],[2,3,11+k,3],[2,11+k,3,3]],
		[[1,2,1,15+k],[1,2,5,11+k],[1,3,10+k,5],[1,5,3,10+k],[1,5,11+k,2],[1,7,1,10+k],[1,10+k,5,3],[1,11+k,2,5]],
		[[1,2,1,15+k],[1,2,6,10+k],[1,3,10+k,5],[1,5,1,12+k],[1,5,3,10+k],[1,6,10+k,2],[1,10+k,2,6],[1,10+k,5,3]],
		[[1,2,1,15+k],[1,2,6,10+k],[1,3,10+k,5],[1,5,3,10+k],[1,5,11+k,2],[1,10+k,3,5],[1,10+k,5,3]],
		[[1,2,2,14+k],[1,2,10+k,6],[1,3,2,13+k],[1,3,10+k,5],[1,4,2,12+k],[1,5,1,12+k],[2,2,10+k,5]],
		[[1,2,2,14+k],[1,2,10+k,6],[1,3,2,13+k],[1,3,10+k,5],[1,4,4,10+k],[1,5,1,12+k],[1,6,2,10+k],[2,2,11+k,4]],
		[[1,2,2,14+k],[1,2,11+k,5],[1,3,2,13+k],[1,3,10+k,5],[1,4,2,12+k],[1,5,3,10+k],[1,6,2,10+k],[2,2,10+k,5]],
		[[1,2,2,14+k],[1,2,11+k,5],[1,3,2,13+k],[1,3,10+k,5],[1,4,4,10+k],[1,5,3,10+k],[2,2,11+k,4]],
		[[1,2,2,14+k],[1,2,11+k,5],[1,3,4,11+k],[1,3,10+k,5],[1,4,4,10+k],[1,5,2,11+k],[1,5,3,10+k],[2,2,12+k,3]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,3,2,13+k],[1,3,10+k,5],[1,5,1,12+k],[2,4,10+k,3],[2,10+k,3,4]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,4,2,12+k],[1,4,12+k,2],[1,10+k,2,6],[1,10+k,6,2],[2,4,2,11+k],[2,5,2,10+k]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,4,2,12+k],[1,4,12+k,2],[1,12+k,4,2],[2,4,3,10+k],[2,5,2,10+k]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,4,3,11+k],[1,4,12+k,2],[1,6,1,11+k],[1,11+k,5,2],[2,4,3,10+k],[2,5,2,10+k]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,5,1,12+k],[1,5,11+k,2],[1,10+k,3,5],[1,10+k,6,2],[2,4,2,11+k],[2,10+k,3,4]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,6,10+k,2],[1,10+k,2,6],[1,10+k,6,2],[2,4,2,11+k],[2,10+k,3,4]],
		[[1,2,4,12+k],[1,2,10+k,6],[1,6,10+k,2],[1,12+k,4,2],[2,4,3,10+k],[2,10+k,3,4]],
		[[1,2,4,12+k],[1,2,11+k,5],[1,3,2,13+k],[1,3,10+k,5],[1,5,3,10+k],[1,6,2,10+k],[2,4,10+k,3],[2,10+k,3,4]],
		[[1,2,4,12+k],[1,2,11+k,5],[1,6,10+k,2],[1,11+k,2,5],[1,11+k,5,2],[2,4,2,11+k],[2,5,2,10+k],[2,10+k,3,4]],
		[[1,2,4,12+k],[1,2,12+k,4],[1,4,2,12+k],[1,4,10+k,4],[2,3,4,10+k],[2,3,10+k,4],[2,4,3,10+k]],
		[[1,2,4,12+k],[1,2,14+k,2],[1,6,10+k,2],[2,3,10+k,4],[2,4,3,10+k],[2,10+k,3,4],[2,10+k,4,3]],
		[[1,2,5,11+k],[1,2,10+k,6],[1,5,2,11+k],[1,5,11+k,2],[1,10+k,2,6],[1,10+k,6,2],[2,5,2,10+k]],
		[[1,2,5,11+k],[1,2,11+k,5],[1,4,1,13+k],[1,4,12+k,2],[1,5,3,10+k],[1,7,1,10+k],[1,10+k,6,2],[1,11+k,3,4]],
		[[1,2,5,11+k],[1,2,11+k,5],[1,5,3,10+k],[1,5,11+k,2],[1,7,1,10+k],[1,10+k,6,2],[1,11+k,2,5]],
		[[1,2,5,11+k],[1,2,12+k,4],[1,5,2,11+k],[1,5,11+k,2],[1,10+k,2,6],[1,10+k,6,2],[1,12+k,2,4],[2,4,3,10+k]],
		[[1,2,6,10+k],[1,2,10+k,6],[1,3,2,13+k],[1,3,10+k,5],[1,5,1,12+k],[1,6,2,10+k],[2,4,2,11+k],[2,4,10+k,3]],
		[[1,2,6,10+k],[1,2,10+k,6],[1,5,1,12+k],[1,5,11+k,2],[1,6,2,10+k],[1,10+k,3,5],[1,10+k,6,2]],
		[[1,2,6,10+k],[1,2,10+k,6],[1,6,2,10+k],[1,6,10+k,2],[1,10+k,2,6],[1,10+k,6,2]],
		[[1,2,6,10+k],[1,2,11+k,5],[1,3,2,13+k],[1,3,10+k,5],[1,5,3,10+k],[2,4,2,11+k],[2,4,10+k,3]],
		[[1,2,6,10+k],[1,2,11+k,5],[1,5,3,10+k],[1,5,11+k,2],[1,10+k,3,5],[1,10+k,6,2]],
		[[1,2,6,10+k],[1,2,14+k,2],[1,6,2,10+k],[1,6,10+k,2],[2,3,10+k,4],[2,4,2,11+k],[2,4,3,10+k],[2,10+k,4,3]],
		[[1,2,11+k,5],[1,2,13+k,3],[1,10+k,3,5],[1,10+k,5,3],[2,2,2,13+k],[2,4,10+k,3],[2,11+k,3,3]],
		[[1,2,11+k,5],[1,2,13+k,3],[1,10+k,3,5],[1,10+k,5,3],[2,2,10+k,5],[2,2,12+k,3],[2,10+k,3,4],[2,11+k,3,3]],
		[[1,3,1,14+k],[1,3,2,13+k],[1,4,10+k,4],[1,5,10+k,3],[2,2,2,13+k],[2,4,10+k,3]],
		[[1,3,1,14+k],[1,3,2,13+k],[1,4,10+k,4],[1,5,10+k,3],[2,2,10+k,5],[2,2,12+k,3],[2,10+k,3,4]],
		[[1,3,1,14+k],[1,3,4,11+k],[1,4,10+k,4],[1,5,2,11+k],[1,5,10+k,3],[2,2,10+k,5],[2,2,11+k,4],[2,10+k,3,4]],
		[[1,3,1,14+k],[1,3,12+k,3],[1,4,10+k,4],[2,2,2,13+k],[2,3,4,10+k],[2,3,10+k,4],[2,4,3,10+k]],
		[[1,3,1,14+k],[1,3,12+k,3],[1,4,10+k,4],[2,2,3,12+k],[2,2,5,10+k],[2,3,4,10+k]],
		[[1,3,2,13+k],[1,3,5,10+k],[1,4,4,10+k],[1,4,11+k,3],[1,5,10+k,3],[2,2,2,13+k],[2,4,10+k,3]],
		[[1,3,2,13+k],[1,3,5,10+k],[1,4,4,10+k],[1,4,11+k,3],[1,5,10+k,3],[2,2,10+k,5],[2,2,12+k,3],[2,10+k,3,4]],
		[[1,3,2,13+k],[1,3,10+k,5],[1,5,10+k,3],[1,10+k,3,5],[1,10+k,5,3],[2,3,10+k,4],[2,3,11+k,3]],
		[[1,3,2,13+k],[1,3,10+k,5],[1,5,10+k,3],[1,13+k,2,3],[2,3,10+k,4],[2,4,10+k,3]],
		[[1,3,2,13+k],[1,3,11+k,4],[1,4,3,11+k],[1,4,10+k,4],[1,5,2,11+k],[2,2,10+k,5],[2,2,11+k,4],[2,10+k,4,3]],
		[[1,3,2,13+k],[1,3,11+k,4],[1,5,10+k,3],[1,10+k,4,4],[1,10+k,5,3],[2,2,2,13+k],[2,4,10+k,3]],
		[[1,3,2,13+k],[1,3,11+k,4],[1,5,10+k,3],[1,10+k,4,4],[1,10+k,5,3],[2,2,10+k,5],[2,2,12+k,3],[2,10+k,3,4]],
		[[1,3,2,13+k],[1,3,12+k,3],[1,5,10+k,3],[2,3,4,10+k],[2,3,10+k,4],[2,4,3,10+k],[2,4,10+k,3]],
		[[1,3,3,12+k],[1,3,12+k,3],[1,4,4,10+k],[1,4,11+k,3],[1,6,2,10+k],[2,2,10+k,5],[2,2,12+k,3],[2,11+k,3,3]],
		[[1,3,4,11+k],[1,3,11+k,4],[1,4,3,11+k],[1,4,10+k,4],[2,2,2,13+k],[2,3,4,10+k],[2,3,10+k,4],[2,4,3,10+k]],
		[[1,3,4,11+k],[1,3,11+k,4],[1,4,3,11+k],[1,4,10+k,4],[2,2,2,13+k],[2,4,10+k,3],[2,10+k,3,4],[2,10+k,4,3]],
		[[1,3,4,11+k],[1,3,11+k,4],[1,4,3,11+k],[1,4,10+k,4],[2,2,3,12+k],[2,2,5,10+k],[2,3,4,10+k]],
		[[1,3,4,11+k],[1,3,11+k,4],[1,4,3,11+k],[1,4,10+k,4],[2,2,10+k,5],[2,2,12+k,3],[2,10+k,4,3]],
		[[1,3,5,10+k],[1,3,10+k,5],[1,5,3,10+k],[1,5,10+k,3],[1,10+k,3,5],[1,10+k,5,3]],
		[[1,3,5,10+k],[1,3,12+k,3],[1,4,2,12+k],[1,4,11+k,3],[1,6,2,10+k],[2,2,11+k,4],[2,2,12+k,3],[2,10+k,4,3]],
		[[1,3,5,10+k],[1,3,12+k,3],[1,4,4,10+k],[1,4,11+k,3],[2,2,2,13+k],[2,3,4,10+k],[2,3,10+k,4],[2,4,3,10+k]],
		[[1,3,5,10+k],[1,3,12+k,3],[1,4,4,10+k],[1,4,11+k,3],[2,2,2,13+k],[2,4,10+k,3],[2,10+k,3,4],[2,10+k,4,3]],
		[[1,3,5,10+k],[1,3,12+k,3],[1,4,4,10+k],[1,4,11+k,3],[2,2,3,12+k],[2,2,5,10+k],[2,3,4,10+k]],
		[[1,3,5,10+k],[1,3,12+k,3],[1,4,4,10+k],[1,4,11+k,3],[2,2,10+k,5],[2,2,12+k,3],[2,10+k,4,3]],
		[[1,3,5,10+k],[1,3,12+k,3],[1,5,3,10+k],[1,5,10+k,3],[2,3,4,10+k],[2,3,11+k,3],[2,4,3,10+k],[2,4,10+k,3]],
		[[2,3,4,10+k],[2,3,10+k,4],[2,4,3,10+k],[2,4,10+k,3],[2,10+k,3,4],[2,10+k,4,3]],
		# n = 21
		[[1,1,2,17+k],[1,1,11+k,8],[1,2,2,16+k],[1,3,2,15+k],[1,4,2,14+k],[1,5,2,13+k],[1,6,2,12+k],[1,7,2,11+k],[1,8,1,11+k]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,2,15+k],[1,4,2,14+k],[1,5,3,12+k],[1,6,3,11+k],[1,8,1,11+k],[2,3,11+k,5],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,2,15+k],[1,4,3,13+k],[1,5,3,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,3,12+k,4],[2,12+k,4,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,2,15+k],[1,4,5,11+k],[1,5,3,12+k],[1,8,1,11+k],[2,3,12+k,4],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,3,14+k],[1,4,3,13+k],[1,6,2,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,3,13+k,3],[2,13+k,3,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,5,12+k],[1,4,3,13+k],[1,7,2,11+k],[1,8,1,11+k],[2,3,13+k,3],[2,12+k,4,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,5,12+k],[1,4,5,11+k],[1,8,1,11+k],[2,3,2,14+k],[2,5,11+k,3],[2,11+k,3,5]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,5,12+k],[1,4,5,11+k],[1,8,1,11+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,6,11+k],[1,4,3,13+k],[1,7,2,11+k],[1,11+k,4,5],[1,12+k,3,5],[2,3,13+k,3],[2,12+k,4,3]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,6,11+k],[1,4,5,11+k],[1,11+k,4,5],[1,12+k,3,5],[2,3,2,14+k],[2,5,11+k,3],[2,11+k,3,5]],
		[[1,1,3,16+k],[1,1,11+k,8],[1,3,6,11+k],[1,4,5,11+k],[1,11+k,4,5],[1,12+k,3,5],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,12+k,7],[1,3,2,15+k],[1,4,5,11+k],[1,5,3,12+k],[1,7,1,12+k],[1,7,2,11+k],[2,3,12+k,4],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,12+k,7],[1,3,5,12+k],[1,4,5,11+k],[1,7,1,12+k],[1,7,2,11+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,13+k,6],[1,3,5,12+k],[1,4,5,11+k],[1,6,1,13+k],[1,6,2,12+k],[1,7,2,11+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,3,16+k],[1,1,14+k,5],[1,3,5,12+k],[1,4,5,11+k],[1,8,1,11+k],[1,11+k,3,6],[1,12+k,3,5],[2,3,2,14+k],[2,5,11+k,3]],
		[[1,1,3,16+k],[1,1,14+k,5],[1,3,6,11+k],[1,4,5,11+k],[1,11+k,3,6],[1,11+k,4,5],[2,3,2,14+k],[2,5,11+k,3]],
		[[1,1,3,16+k],[1,1,14+k,5],[1,3,6,11+k],[1,4,5,11+k],[1,11+k,3,6],[1,11+k,4,5],[2,3,13+k,3],[2,11+k,3,5],[2,11+k,5,3]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,2,2,16+k],[1,2,4,14+k],[1,5,2,13+k],[1,6,2,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,2,14+k,3]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,3,2,15+k],[1,3,4,13+k],[1,4,4,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,4,12+k,3],[2,12+k,3,4]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,3,2,15+k],[1,3,6,11+k],[1,4,4,12+k],[1,8,1,11+k],[2,4,12+k,3],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,4,2,14+k],[1,5,2,13+k],[1,6,2,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,2,2,15+k]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,4,2,14+k],[1,5,2,13+k],[1,6,3,11+k],[1,7,2,11+k],[1,11+k,7,2],[1,12+k,6,2],[2,2,2,15+k]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,4,3,13+k],[1,5,3,12+k],[1,7,1,12+k],[1,11+k,6,3],[1,13+k,4,3],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,4,4,12+k],[1,5,3,12+k],[1,11+k,6,3],[1,12+k,5,3],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,11+k,8],[1,4,4,12+k],[1,5,4,11+k],[1,8,1,11+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,12+k,7],[1,3,2,15+k],[1,3,6,11+k],[1,4,4,12+k],[1,7,1,12+k],[1,7,2,11+k],[2,4,12+k,3],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,12+k,7],[1,3,4,13+k],[1,3,6,11+k],[1,4,4,12+k],[1,5,4,11+k],[1,7,1,12+k],[2,4,11+k,4],[2,12+k,3,4]],
		[[1,1,4,15+k],[1,1,12+k,7],[1,4,2,14+k],[1,5,3,12+k],[1,6,3,11+k],[1,8,1,11+k],[1,11+k,7,2],[1,13+k,5,2],[2,2,2,15+k]],
		[[1,1,4,15+k],[1,1,12+k,7],[1,4,3,13+k],[1,5,4,11+k],[1,7,2,11+k],[1,12+k,5,3],[1,13+k,4,3],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,12+k,7],[1,4,4,12+k],[1,5,4,11+k],[1,7,1,12+k],[1,7,2,11+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,4,15+k],[1,1,15+k,4],[1,4,1,15+k],[2,4,11+k,4],[3,3,4,11+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,1,5,14+k],[1,1,11+k,8],[1,3,2,15+k],[1,3,5,12+k],[1,4,2,14+k],[1,4,5,11+k],[1,8,1,11+k],[2,5,11+k,3],[2,11+k,3,5]],
		[[1,1,5,14+k],[1,1,11+k,8],[1,4,2,14+k],[1,4,5,11+k],[1,5,3,12+k],[1,8,1,11+k],[2,3,2,14+k],[2,3,12+k,4],[2,11+k,5,3]],
		[[1,1,5,14+k],[1,1,11+k,8],[1,5,3,12+k],[1,6,3,11+k],[1,8,1,11+k],[2,3,2,14+k],[2,3,11+k,5],[2,11+k,5,3]],
		[[1,1,5,14+k],[1,1,11+k,8],[1,5,4,11+k],[1,6,3,11+k],[1,11+k,6,3],[1,12+k,5,3],[2,3,2,14+k],[2,3,11+k,5],[2,11+k,5,3]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,2,2,16+k],[1,2,6,12+k],[1,4,2,14+k],[1,7,2,11+k],[1,8,1,11+k],[2,2,14+k,3],[2,12+k,3,4]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,2,4,14+k],[1,2,6,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,2,2,15+k],[2,12+k,3,4]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,2,4,14+k],[1,2,6,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,2,12+k,5],[2,2,14+k,3],[2,4,12+k,3]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,3,3,14+k],[1,3,5,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,3,3,13+k],[2,3,13+k,3],[2,12+k,4,3]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,6,1,13+k],[1,11+k,2,7],[1,12+k,2,6],[2,3,5,11+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,6,1,13+k],[1,11+k,5,4],[1,12+k,2,6],[1,13+k,3,4],[2,3,4,12+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,6,2,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,2,2,15+k],[2,4,2,13+k]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,6,2,12+k],[1,7,2,11+k],[1,8,1,11+k],[2,3,3,13+k],[2,3,13+k,3],[2,13+k,3,3]],
		[[1,1,6,13+k],[1,1,11+k,8],[1,6,3,11+k],[1,7,2,11+k],[1,11+k,7,2],[1,12+k,6,2],[2,2,2,15+k],[2,4,2,13+k]],
		[[1,1,6,13+k],[1,1,12+k,7],[1,6,2,12+k],[1,7,1,12+k],[2,3,5,11+k],[2,3,13+k,3],[2,6,2,11+k],[2,11+k,5,3]],
		[[1,1,6,13+k],[1,1,13+k,6],[1,6,1,13+k],[2,3,5,11+k],[2,3,13+k,3],[2,6,2,11+k],[2,11+k,5,3]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,4,3,13+k],[1,4,4,12+k],[1,11+k,6,3],[1,12+k,5,3],[2,4,3,12+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,2,7],[2,2,2,15+k],[2,4,2,13+k],[2,6,2,11+k]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,2,7],[2,3,3,13+k],[2,3,13+k,3],[2,6,2,11+k],[2,13+k,3,3]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,2,7],[2,3,5,11+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,2,7],[2,4,4,11+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,4,5],[1,13+k,4,3],[1,15+k,2,3],[2,3,12+k,4],[2,4,3,12+k],[2,11+k,4,4]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,5,4],[1,13+k,3,4],[2,3,4,12+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,7,12+k],[1,1,11+k,8],[1,7,1,12+k],[1,11+k,6,3],[1,13+k,4,3],[2,4,3,12+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,1,8,11+k],[1,1,11+k,8],[1,8,1,11+k],[2,2,2,15+k],[2,4,2,13+k],[2,6,2,11+k]],
		[[1,1,8,11+k],[1,1,11+k,8],[1,8,1,11+k],[2,3,2,14+k],[2,3,5,11+k],[2,5,11+k,3],[2,11+k,3,5]],
		[[1,1,8,11+k],[1,1,11+k,8],[1,8,1,11+k],[2,3,3,13+k],[2,3,13+k,3],[2,6,2,11+k],[2,13+k,3,3]],
		[[1,1,8,11+k],[1,1,11+k,8],[1,8,1,11+k],[2,3,5,11+k],[2,3,13+k,3],[2,11+k,5,3]],
		[[1,1,8,11+k],[1,1,11+k,8],[1,8,1,11+k],[2,4,4,11+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,2,1,17+k],[1,2,5,13+k],[1,3,12+k,5],[1,5,4,11+k],[1,5,13+k,2],[1,7,1,12+k],[1,8,1,11+k],[1,11+k,6,3],[1,13+k,2,5]],
		[[1,2,1,17+k],[1,2,6,12+k],[1,3,11+k,6],[1,5,1,14+k],[1,5,13+k,2],[1,6,3,11+k],[1,8,1,11+k],[1,11+k,6,3],[1,12+k,3,5]],
		[[1,2,1,17+k],[1,2,6,12+k],[1,3,11+k,6],[1,5,3,12+k],[1,5,4,11+k],[1,6,3,11+k],[1,6,12+k,2],[1,12+k,2,6],[1,12+k,5,3]],
		[[1,2,1,17+k],[1,2,6,12+k],[1,3,11+k,6],[1,6,3,11+k],[1,6,12+k,2],[1,8,1,11+k],[1,11+k,6,3],[1,12+k,2,6]],
		[[1,2,1,17+k],[1,2,6,12+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,4,11+k],[1,6,12+k,2],[1,8,1,11+k],[1,11+k,6,3],[1,12+k,2,6]],
		[[1,2,1,17+k],[1,2,6,12+k],[1,3,12+k,5],[1,5,4,11+k],[1,5,13+k,2],[1,8,1,11+k],[1,11+k,6,3],[1,12+k,3,5]],
		[[1,2,1,17+k],[1,2,7,11+k],[1,3,11+k,6],[1,6,1,13+k],[1,6,3,11+k],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,6,3]],
		[[1,2,1,17+k],[1,2,7,11+k],[1,3,11+k,6],[1,6,3,11+k],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,6,3]],
		[[1,2,1,17+k],[1,2,7,11+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,3,12+k],[1,6,12+k,2],[1,8,1,11+k],[1,11+k,3,6],[1,12+k,5,3]],
		[[1,2,1,17+k],[1,2,7,11+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,4,11+k],[1,6,1,13+k],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,6,3]],
		[[1,2,1,17+k],[1,2,7,11+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,4,11+k],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,6,3]],
		[[1,2,1,17+k],[1,2,7,11+k],[1,3,12+k,5],[1,5,4,11+k],[1,5,13+k,2],[1,11+k,3,6],[1,11+k,6,3],[1,12+k,2,6],[1,12+k,3,5]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,3,2,15+k],[1,3,11+k,6],[1,4,2,14+k],[1,5,2,13+k],[1,6,1,13+k],[2,2,11+k,6]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,3,2,15+k],[1,3,11+k,6],[1,4,2,14+k],[1,5,4,11+k],[1,6,1,13+k],[1,7,2,11+k],[2,2,12+k,5]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,1,15+k],[1,5,11+k,4],[1,11+k,2,7],[1,11+k,4,5],[2,2,5,12+k],[2,5,3,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,1,15+k],[1,5,11+k,4],[1,13+k,2,5],[2,2,6,11+k],[2,5,3,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,2,14+k],[1,6,11+k,3],[1,13+k,4,3],[2,2,14+k,3],[2,11+k,4,4],[3,4,3,11+k]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,12+k,4],[1,11+k,2,7],[1,11+k,5,4],[2,2,5,12+k],[2,5,3,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,12+k,4],[1,11+k,4,5],[1,11+k,5,4],[1,13+k,2,5],[2,2,6,11+k],[2,5,3,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,13+k,3],[1,13+k,4,3],[2,2,11+k,6],[2,13+k,3,3],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,2,2,16+k],[1,2,11+k,7],[1,4,13+k,3],[1,13+k,4,3],[2,2,14+k,3],[2,11+k,3,5],[3,4,3,11+k]],
		[[1,2,2,16+k],[1,2,12+k,6],[1,3,2,15+k],[1,3,11+k,6],[1,4,2,14+k],[1,5,2,13+k],[1,6,3,11+k],[1,7,2,11+k],[2,2,11+k,6]],
		[[1,2,2,16+k],[1,2,12+k,6],[1,3,2,15+k],[1,3,11+k,6],[1,4,2,14+k],[1,5,4,11+k],[1,6,3,11+k],[2,2,12+k,5]],
		[[1,2,2,16+k],[1,2,12+k,6],[1,3,2,15+k],[1,3,11+k,6],[1,4,4,12+k],[1,5,4,11+k],[1,6,2,12+k],[1,6,3,11+k],[2,2,13+k,4]],
		[[1,2,2,16+k],[1,2,13+k,5],[1,4,1,15+k],[1,5,11+k,4],[2,2,6,11+k],[2,6,2,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,13+k,5],[1,4,1,15+k],[1,5,11+k,4],[2,2,13+k,4],[2,11+k,4,4],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,13+k,5],[1,4,12+k,4],[1,11+k,2,7],[1,11+k,5,4],[1,13+k,2,5],[2,2,5,12+k],[2,6,2,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,13+k,5],[1,4,12+k,4],[1,11+k,4,5],[1,11+k,5,4],[2,2,6,11+k],[2,6,2,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,13+k,5],[1,4,12+k,4],[1,11+k,4,5],[1,11+k,5,4],[2,2,13+k,4],[2,11+k,4,4],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,14+k,4],[1,4,3,13+k],[1,5,2,13+k],[1,5,11+k,4],[2,2,6,11+k],[2,6,2,11+k],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,14+k,4],[1,4,3,13+k],[1,5,2,13+k],[1,5,11+k,4],[2,2,13+k,4],[2,11+k,4,4],[2,11+k,5,3]],
		[[1,2,2,16+k],[1,2,14+k,4],[1,4,5,11+k],[1,5,2,13+k],[1,5,11+k,4],[1,7,2,11+k],[2,2,6,11+k],[2,6,2,11+k],[2,12+k,4,3]],
		[[1,2,2,16+k],[1,2,14+k,4],[1,4,5,11+k],[1,5,2,13+k],[1,5,11+k,4],[1,7,2,11+k],[2,2,13+k,4],[2,11+k,4,4],[2,12+k,4,3]],
		[[1,2,2,16+k],[1,2,15+k,3],[1,4,2,14+k],[1,6,11+k,3],[2,2,14+k,3],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,2,2,16+k],[1,2,15+k,3],[1,4,13+k,3],[2,2,14+k,3],[2,11+k,3,5],[2,11+k,4,4],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,2,3,15+k],[1,2,7,11+k],[1,4,5,11+k],[1,4,12+k,4],[1,5,11+k,4],[2,3,4,12+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,2,3,15+k],[1,2,11+k,7],[1,4,1,15+k],[1,4,11+k,5],[1,13+k,3,4],[2,3,11+k,5],[2,11+k,3,5],[3,3,4,11+k]],
		[[1,2,3,15+k],[1,2,11+k,7],[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,13+k,3,4],[2,3,11+k,5],[2,11+k,3,5],[3,3,4,11+k]],
		[[1,2,3,15+k],[1,2,13+k,5],[1,4,3,13+k],[1,4,11+k,5],[1,5,2,13+k],[2,3,11+k,5],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,2,3,15+k],[1,2,14+k,4],[1,4,1,15+k],[1,4,11+k,5],[2,3,11+k,5],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,2,3,15+k],[1,2,14+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[2,3,11+k,5],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,3,2,15+k],[1,3,11+k,6],[1,5,4,11+k],[1,6,1,13+k],[1,7,2,11+k],[2,4,12+k,3],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,3,4,13+k],[1,3,11+k,6],[1,6,1,13+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,3,6,11+k],[1,3,11+k,6],[1,6,1,13+k],[1,7,2,11+k],[2,4,11+k,4],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,4,2,14+k],[1,4,13+k,3],[1,13+k,4,3],[2,2,2,15+k],[2,11+k,3,5],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,4,2,14+k],[1,4,14+k,2],[1,11+k,2,7],[1,11+k,7,2],[2,4,2,13+k],[2,5,2,12+k],[2,6,2,11+k]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,4,2,14+k],[1,4,14+k,2],[1,13+k,5,2],[2,4,2,13+k],[2,5,3,11+k],[2,6,2,11+k]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,4,3,13+k],[1,4,14+k,2],[1,6,3,11+k],[1,7,2,11+k],[1,13+k,5,2],[2,4,3,12+k],[2,5,2,12+k]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,6,11+k,3],[1,13+k,4,3],[2,2,2,15+k],[2,11+k,4,4],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,6,12+k,2],[1,11+k,2,7],[1,11+k,7,2],[2,4,2,13+k],[2,6,2,11+k],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,7,2],[1,13+k,3,4],[1,14+k,2,4],[2,5,2,12+k],[2,11+k,3,5]],
		[[1,2,4,14+k],[1,2,11+k,7],[1,6,12+k,2],[1,13+k,5,2],[2,4,2,13+k],[2,5,2,12+k],[2,5,3,11+k],[2,6,2,11+k],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,3,2,15+k],[1,3,11+k,6],[1,5,4,11+k],[1,6,3,11+k],[2,4,12+k,3],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,3,4,13+k],[1,3,11+k,6],[1,6,3,11+k],[1,7,2,11+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,3,4,13+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,4,11+k],[1,7,2,11+k],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,3,6,11+k],[1,3,11+k,6],[1,6,3,11+k],[2,4,11+k,4],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,3,6,11+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,4,11+k],[2,4,11+k,4],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,4,3,13+k],[1,4,14+k,2],[1,6,1,13+k],[1,11+k,2,7],[1,11+k,7,2],[2,4,3,12+k],[2,5,3,11+k]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,6,1,13+k],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,7,2],[2,4,3,12+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,6,1,13+k],[1,7,11+k,2],[1,13+k,5,2],[2,4,3,12+k],[2,5,2,12+k],[2,5,3,11+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,12+k,6],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,7,2],[2,4,3,12+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,13+k,5],[1,3,6,11+k],[1,3,12+k,5],[1,5,3,12+k],[1,5,4,11+k],[1,6,2,12+k],[2,4,11+k,4],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,13+k,5],[1,6,12+k,2],[1,11+k,2,7],[1,11+k,7,2],[1,13+k,2,5],[2,4,2,13+k],[2,5,3,11+k],[2,12+k,3,4]],
		[[1,2,4,14+k],[1,2,14+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,6,3,11+k],[2,3,4,12+k],[2,3,11+k,5],[2,4,3,12+k]],
		[[1,2,4,14+k],[1,2,14+k,4],[1,6,1,13+k],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,7,2],[1,14+k,2,4],[2,5,2,12+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,14+k,4],[1,6,1,13+k],[1,7,11+k,2],[1,13+k,5,2],[1,14+k,2,4],[2,5,3,11+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,14+k,4],[1,6,11+k,3],[1,13+k,3,4],[1,13+k,4,3],[2,2,2,15+k],[2,11+k,3,5],[2,11+k,4,4]],
		[[1,2,4,14+k],[1,2,14+k,4],[1,6,12+k,2],[1,11+k,2,7],[1,11+k,3,6],[1,13+k,5,2],[1,14+k,2,4],[2,5,3,11+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,14+k,4],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,7,2],[1,14+k,2,4],[2,5,2,12+k],[3,4,3,11+k]],
		[[1,2,4,14+k],[1,2,15+k,3],[1,6,11+k,3],[2,2,2,15+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,3,4,13+k],[1,3,11+k,6],[1,13+k,3,4],[1,14+k,2,4],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,3,5,12+k],[1,3,11+k,6],[1,7,1,12+k],[1,12+k,4,4],[1,14+k,2,4],[2,4,11+k,4],[2,11+k,4,4]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,3,6,11+k],[1,3,11+k,6],[1,7,2,11+k],[1,13+k,3,4],[1,14+k,2,4],[2,4,11+k,4],[2,12+k,3,4]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,4,2,14+k],[1,4,14+k,2],[1,6,1,13+k],[1,11+k,3,6],[1,11+k,7,2],[2,11+k,3,5],[2,12+k,3,4]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,4,3,13+k],[1,4,14+k,2],[1,13+k,5,2],[2,11+k,3,5],[3,4,3,11+k]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,5,2,13+k],[1,5,13+k,2],[1,11+k,2,7],[1,11+k,7,2],[2,5,2,12+k],[2,6,2,11+k]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,5,2,13+k],[1,5,13+k,2],[1,13+k,5,2],[2,5,3,11+k],[2,6,2,11+k]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,5,3,12+k],[1,5,13+k,2],[1,7,1,12+k],[1,12+k,6,2],[2,5,3,11+k],[2,6,2,11+k]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,6,1,13+k],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,7,2],[2,5,2,12+k],[2,11+k,3,5]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,7,2],[2,5,2,12+k],[2,11+k,3,5]],
		[[1,2,5,13+k],[1,2,11+k,7],[1,7,11+k,2],[1,13+k,5,2],[2,5,3,11+k],[2,11+k,3,5]],
		[[1,2,5,13+k],[1,2,12+k,6],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,7,2],[1,13+k,3,4],[1,14+k,2,4],[2,4,3,12+k],[3,4,3,11+k]],
		[[1,2,5,13+k],[1,2,12+k,6],[1,7,11+k,2],[1,12+k,2,6],[1,12+k,6,2],[2,5,2,12+k],[2,6,2,11+k],[2,11+k,3,5]],
		[[1,2,5,13+k],[1,2,14+k,4],[1,6,1,13+k],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,7,2],[1,13+k,3,4],[2,5,2,12+k],[3,4,3,11+k]],
		[[1,2,5,13+k],[1,2,14+k,4],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,7,2],[1,13+k,3,4],[2,5,2,12+k],[3,4,3,11+k]],
		[[1,2,5,13+k],[1,2,14+k,4],[1,7,11+k,2],[1,12+k,2,6],[1,12+k,6,2],[1,14+k,2,4],[2,4,3,12+k],[2,6,2,11+k],[2,11+k,3,5]],
		[[1,2,5,13+k],[1,2,15+k,3],[1,4,3,13+k],[1,4,13+k,3],[2,4,4,11+k],[2,4,11+k,4],[2,5,3,11+k],[3,3,11+k,4]],
		[[1,2,5,13+k],[1,2,16+k,2],[1,7,11+k,2],[2,2,2,15+k],[2,3,2,14+k],[2,4,2,13+k],[2,6,2,11+k],[2,11+k,3,5]],
		[[1,2,5,13+k],[1,2,16+k,2],[1,7,11+k,2],[2,3,2,14+k],[2,4,4,11+k],[2,4,11+k,4],[2,11+k,3,5],[2,11+k,4,4]],
		[[1,2,6,12+k],[1,2,7,11+k],[1,3,6,11+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,3,12+k],[1,6,11+k,3],[1,12+k,2,6],[1,12+k,5,3]],
		[[1,2,6,12+k],[1,2,11+k,7],[1,6,2,12+k],[1,6,12+k,2],[1,11+k,2,7],[1,11+k,7,2],[2,6,2,11+k]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,3,2,15+k],[1,3,11+k,6],[1,5,4,11+k],[1,6,2,12+k],[1,6,3,11+k],[2,4,2,13+k],[2,4,12+k,3]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,3,5,12+k],[1,3,6,11+k],[1,5,1,14+k],[1,5,13+k,2],[1,6,3,11+k],[1,11+k,4,5],[1,11+k,7,2]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,3,6,11+k],[1,3,11+k,6],[1,6,2,12+k],[1,6,3,11+k],[2,4,2,13+k],[2,4,11+k,4]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,3,6,11+k],[1,3,12+k,5],[1,5,1,14+k],[1,5,4,11+k],[1,6,2,12+k],[2,4,2,13+k],[2,4,11+k,4]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,3,11+k,6],[1,3,12+k,5],[1,5,4,11+k],[1,5,13+k,2],[1,8,1,11+k],[1,11+k,7,2],[1,12+k,3,5]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,5,1,14+k],[1,5,13+k,2],[1,6,3,11+k],[1,8,1,11+k],[1,11+k,7,2],[1,12+k,3,5]],
		[[1,2,6,12+k],[1,2,12+k,6],[1,6,3,11+k],[1,6,12+k,2],[1,8,1,11+k],[1,11+k,7,2],[1,12+k,2,6]],
		[[1,2,6,12+k],[1,2,13+k,5],[1,3,6,11+k],[1,3,11+k,6],[1,5,1,14+k],[1,5,3,12+k],[1,6,3,11+k],[2,4,2,13+k],[2,4,11+k,4]],
		[[1,2,6,12+k],[1,2,13+k,5],[1,3,6,11+k],[1,3,12+k,5],[1,5,3,12+k],[1,5,4,11+k],[2,4,2,13+k],[2,4,11+k,4]],
		[[1,2,6,12+k],[1,2,13+k,5],[1,6,2,12+k],[1,6,12+k,2],[1,11+k,2,7],[1,11+k,7,2],[1,13+k,2,5],[2,5,3,11+k]],
		[[1,2,6,12+k],[1,2,13+k,5],[1,6,2,12+k],[1,6,12+k,2],[1,11+k,4,5],[1,11+k,7,2],[2,2,5,12+k],[2,2,6,11+k],[2,5,3,11+k]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,4,1,15+k],[1,4,11+k,5],[1,5,4,11+k],[1,13+k,3,4],[2,3,4,12+k],[2,3,11+k,5],[2,11+k,3,5]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,4,2,14+k],[1,4,12+k,4],[1,6,3,11+k],[1,13+k,3,4],[2,3,4,12+k],[2,3,12+k,4],[2,11+k,3,5]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,4,2,14+k],[1,4,13+k,3],[1,6,3,11+k],[1,13+k,4,3],[2,2,2,15+k],[2,4,3,12+k],[2,11+k,3,5]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,4,5,11+k],[1,4,12+k,4],[1,13+k,3,4],[2,3,4,12+k],[2,3,11+k,5],[2,11+k,3,5]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,6,1,13+k],[1,6,12+k,2],[1,7,2,11+k],[1,11+k,3,6],[1,11+k,7,2]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,6,3,11+k],[1,6,11+k,3],[1,13+k,4,3],[2,2,2,15+k],[2,4,3,12+k],[2,11+k,4,4]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,6,3,11+k],[1,6,11+k,3],[1,13+k,4,3],[2,2,3,14+k],[2,2,5,12+k],[2,3,12+k,4],[2,11+k,4,4]],
		[[1,2,7,11+k],[1,2,11+k,7],[1,7,2,11+k],[1,7,11+k,2],[1,11+k,2,7],[1,11+k,7,2]],
		[[1,2,7,11+k],[1,2,12+k,6],[1,6,3,11+k],[1,6,12+k,2],[1,11+k,3,6],[1,11+k,7,2]],
		[[1,2,7,11+k],[1,2,13+k,5],[1,4,3,13+k],[1,4,11+k,5],[1,5,2,13+k],[1,5,4,11+k],[2,3,4,12+k],[2,3,11+k,5],[3,4,3,11+k]],
		[[1,2,7,11+k],[1,2,14+k,4],[1,4,1,15+k],[1,4,11+k,5],[1,5,4,11+k],[2,3,4,12+k],[2,3,11+k,5],[3,4,3,11+k]],
		[[1,2,7,11+k],[1,2,14+k,4],[1,4,2,14+k],[1,4,12+k,4],[1,6,3,11+k],[2,3,4,12+k],[2,3,12+k,4],[3,4,3,11+k]],
		[[1,2,7,11+k],[1,2,14+k,4],[1,4,5,11+k],[1,4,12+k,4],[2,3,4,12+k],[2,3,11+k,5],[3,4,3,11+k]],
		[[1,2,7,11+k],[1,2,15+k,3],[1,6,3,11+k],[1,6,11+k,3],[2,2,2,15+k],[2,4,3,12+k],[3,3,11+k,4]],
		[[1,2,7,11+k],[1,2,15+k,3],[1,6,3,11+k],[1,6,11+k,3],[2,2,3,14+k],[2,2,5,12+k],[2,3,12+k,4],[3,3,11+k,4]],
		[[1,2,7,11+k],[1,2,15+k,3],[1,6,3,11+k],[1,6,11+k,3],[2,2,5,12+k],[2,2,6,11+k],[2,3,3,13+k],[2,3,12+k,4],[2,5,3,11+k]],
		[[1,2,7,11+k],[1,2,16+k,2],[1,6,3,11+k],[1,6,12+k,2],[2,3,12+k,4],[2,12+k,3,4],[2,12+k,4,3],[3,4,3,11+k]],
		[[1,2,7,11+k],[1,2,16+k,2],[1,7,2,11+k],[1,7,11+k,2],[2,2,2,15+k],[2,3,2,14+k],[2,4,2,13+k],[2,5,2,12+k],[2,6,2,11+k]],
		[[1,2,7,11+k],[1,2,16+k,2],[1,7,2,11+k],[1,7,11+k,2],[2,3,2,14+k],[2,4,4,11+k],[2,4,11+k,4],[2,5,2,12+k],[2,11+k,4,4]],
		[[1,2,7,11+k],[1,2,16+k,2],[1,7,2,11+k],[1,7,11+k,2],[2,3,12+k,4],[2,4,2,13+k],[2,4,3,12+k],[2,6,2,11+k],[2,12+k,4,3]],
		[[1,2,11+k,7],[1,2,13+k,5],[1,4,11+k,5],[1,4,12+k,4],[1,11+k,2,7],[1,11+k,5,4],[2,2,5,12+k],[2,2,11+k,6],[2,5,3,11+k]],
		[[1,2,11+k,7],[1,2,13+k,5],[1,13+k,2,5],[2,2,2,15+k],[2,3,2,14+k],[2,3,11+k,5],[2,4,2,13+k],[2,11+k,5,3]],
		[[1,2,11+k,7],[1,2,13+k,5],[1,13+k,2,5],[2,2,3,14+k],[2,2,11+k,6],[2,3,3,13+k],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,2,11+k,7],[1,2,14+k,4],[1,13+k,3,4],[2,2,6,11+k],[2,2,14+k,3],[2,6,2,11+k],[2,13+k,3,3],[3,3,11+k,4]],
		[[1,2,11+k,7],[1,2,14+k,4],[1,13+k,3,4],[2,2,13+k,4],[2,2,14+k,3],[2,11+k,4,4],[2,13+k,3,3],[3,3,11+k,4]],
		[[1,2,11+k,7],[1,2,15+k,3],[1,13+k,4,3],[2,2,11+k,6],[2,2,13+k,4],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,2,11+k,7],[1,2,15+k,3],[1,13+k,4,3],[2,2,13+k,4],[2,2,14+k,3],[2,11+k,3,5],[2,13+k,3,3],[3,4,3,11+k]],
		[[1,2,12+k,6],[1,2,13+k,5],[1,3,6,11+k],[1,3,12+k,5],[1,6,2,12+k],[1,6,11+k,3],[1,8,1,11+k],[1,11+k,3,6],[1,12+k,5,3]],
		[[1,2,13+k,5],[1,2,14+k,4],[1,11+k,4,5],[1,11+k,5,4],[2,2,6,11+k],[2,2,12+k,5],[2,6,2,11+k],[2,11+k,5,3],[2,12+k,4,3]],
		[[1,2,13+k,5],[1,2,14+k,4],[1,11+k,4,5],[1,11+k,5,4],[2,2,12+k,5],[2,2,13+k,4],[2,11+k,4,4],[2,11+k,5,3],[2,12+k,4,3]],
		[[1,2,13+k,5],[1,2,15+k,3],[1,12+k,3,5],[1,12+k,5,3],[2,2,11+k,6],[2,2,12+k,5],[2,11+k,3,5],[2,12+k,3,4],[3,3,4,11+k]],
		[[1,2,14+k,4],[1,2,15+k,3],[1,13+k,3,4],[1,13+k,4,3],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,3,5],[3,3,4,11+k]],
		[[1,3,1,16+k],[1,3,4,13+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,12+k,3],[1,7,2,11+k],[2,2,11+k,6],[2,2,13+k,4],[2,12+k,3,4]],
		[[1,3,1,16+k],[1,3,6,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,12+k,3],[1,7,2,11+k],[2,2,6,11+k],[2,2,12+k,5],[2,6,2,11+k]],
		[[1,3,1,16+k],[1,3,6,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,12+k,3],[1,7,2,11+k],[2,2,12+k,5],[2,2,13+k,4],[2,11+k,4,4]],
		[[1,3,1,16+k],[1,3,6,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,12+k,3],[2,2,2,15+k],[2,4,11+k,4]],
		[[1,3,1,16+k],[1,3,6,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,12+k,3],[2,2,4,13+k],[2,2,6,11+k],[2,4,4,11+k]],
		[[1,3,1,16+k],[1,3,6,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,12+k,3],[2,2,6,11+k],[2,2,11+k,6],[2,6,2,11+k]],
		[[1,3,1,16+k],[1,3,6,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,12+k,3],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,4,4]],
		[[1,3,2,15+k],[1,3,4,13+k],[1,4,5,11+k],[1,4,12+k,4],[1,5,11+k,4],[1,7,2,11+k],[2,2,12+k,5],[2,2,14+k,3],[2,11+k,4,4]],
		[[1,3,2,15+k],[1,3,4,13+k],[1,5,2,13+k],[2,11+k,3,5],[2,11+k,4,4],[2,13+k,3,3],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,3,2,15+k],[1,3,6,11+k],[1,4,5,11+k],[1,4,12+k,4],[1,5,11+k,4],[2,2,2,15+k],[2,4,12+k,3]],
		[[1,3,2,15+k],[1,3,6,11+k],[1,4,5,11+k],[1,4,12+k,4],[1,5,11+k,4],[2,2,12+k,5],[2,2,14+k,3],[2,12+k,3,4]],
		[[1,3,2,15+k],[1,3,6,11+k],[1,5,2,13+k],[1,7,2,11+k],[2,11+k,3,5],[2,12+k,3,4],[2,13+k,3,3],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,3,2,15+k],[1,3,11+k,6],[1,5,11+k,4],[1,14+k,2,4],[2,3,2,14+k],[2,3,11+k,5],[2,4,11+k,4]],
		[[1,3,2,15+k],[1,3,11+k,6],[1,5,11+k,4],[1,14+k,2,4],[2,3,5,11+k],[2,3,13+k,3],[2,4,11+k,4],[2,5,3,11+k]],
		[[1,3,2,15+k],[1,3,12+k,5],[1,4,2,14+k],[1,4,11+k,5],[1,5,3,12+k],[1,6,2,12+k],[2,2,11+k,6],[2,2,12+k,5],[2,11+k,5,3]],
		[[1,3,2,15+k],[1,3,12+k,5],[1,4,4,12+k],[1,4,11+k,5],[1,5,3,12+k],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,5,3]],
		[[1,3,2,15+k],[1,3,12+k,5],[1,5,1,14+k],[1,6,11+k,3],[1,11+k,3,6],[1,11+k,6,3],[2,4,11+k,4],[2,4,12+k,3]],
		[[1,3,2,15+k],[1,3,12+k,5],[1,5,12+k,3],[1,11+k,4,5],[1,11+k,6,3],[2,4,11+k,4],[2,4,12+k,3]],
		[[1,3,2,15+k],[1,3,13+k,4],[1,4,1,15+k],[1,4,11+k,5],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,5,3]],
		[[1,3,2,15+k],[1,3,13+k,4],[1,4,3,13+k],[1,4,12+k,4],[1,5,4,11+k],[1,7,2,11+k],[2,2,11+k,6],[2,2,13+k,4],[2,12+k,4,3]],
		[[1,3,2,15+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,7,2,11+k],[2,2,12+k,5],[2,2,13+k,4],[2,11+k,5,3]],
		[[1,3,2,15+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,5,3]],
		[[1,3,2,15+k],[1,3,13+k,4],[1,5,11+k,4],[2,3,2,14+k],[2,3,11+k,5],[2,4,4,11+k],[2,4,11+k,4],[2,5,3,11+k]],
		[[1,3,2,15+k],[1,3,13+k,4],[1,5,11+k,4],[2,3,5,11+k],[2,3,13+k,3],[2,4,4,11+k],[2,4,11+k,4]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,4,2,14+k],[1,4,13+k,3],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,3,5],[3,3,4,11+k]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,4,4,12+k],[1,4,13+k,3],[1,6,2,12+k],[2,2,11+k,6],[2,2,12+k,5],[2,11+k,3,5],[3,3,4,11+k]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,6,11+k,3],[2,2,2,15+k],[2,4,11+k,4],[3,3,4,11+k]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,6,11+k,3],[2,2,4,13+k],[2,2,6,11+k],[2,4,4,11+k],[3,3,4,11+k]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,6,11+k,3],[2,2,6,11+k],[2,2,11+k,6],[2,6,2,11+k],[3,3,4,11+k]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,6,11+k,3],[2,2,6,11+k],[2,2,14+k,3],[2,6,2,11+k],[2,11+k,3,5],[2,13+k,3,3]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,6,11+k,3],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,4,4],[3,3,4,11+k]],
		[[1,3,3,14+k],[1,3,14+k,3],[1,6,11+k,3],[2,2,13+k,4],[2,2,14+k,3],[2,11+k,3,5],[2,11+k,4,4],[2,13+k,3,3]],
		[[1,3,4,13+k],[1,3,6,11+k],[1,4,5,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,11+k,4],[2,2,12+k,5],[2,2,13+k,4],[2,12+k,3,4]],
		[[1,3,4,13+k],[1,3,12+k,5],[1,4,4,12+k],[1,4,11+k,5],[1,5,2,13+k],[1,5,3,12+k],[2,2,11+k,6],[2,2,14+k,3],[2,11+k,5,3]],
		[[1,3,4,13+k],[1,3,13+k,4],[1,4,1,15+k],[1,4,11+k,5],[1,5,2,13+k],[2,2,11+k,6],[2,2,14+k,3],[2,11+k,5,3]],
		[[1,3,4,13+k],[1,3,13+k,4],[1,4,1,15+k],[1,4,11+k,5],[1,5,4,11+k],[1,7,2,11+k],[2,2,12+k,5],[2,2,14+k,3],[2,11+k,5,3]],
		[[1,3,4,13+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,4,11+k],[2,2,11+k,6],[2,2,14+k,3],[2,11+k,5,3]],
		[[1,3,4,13+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,7,2,11+k],[2,2,2,15+k],[2,4,12+k,3],[2,11+k,5,3],[2,12+k,3,4]],
		[[1,3,4,13+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[1,7,2,11+k],[2,2,12+k,5],[2,2,14+k,3],[2,11+k,5,3]],
		[[1,3,5,12+k],[1,3,6,11+k],[1,4,4,12+k],[1,4,13+k,3],[1,5,4,11+k],[1,5,12+k,3],[2,2,2,15+k],[2,4,11+k,4]],
		[[1,3,5,12+k],[1,3,11+k,6],[1,5,1,14+k],[1,5,12+k,3],[1,6,3,11+k],[1,8,1,11+k],[1,11+k,6,3],[1,12+k,3,5]],
		[[1,3,5,12+k],[1,3,11+k,6],[1,5,3,12+k],[1,5,11+k,4],[1,14+k,2,4],[2,3,5,11+k],[2,3,12+k,4],[2,4,11+k,4],[2,5,3,11+k]],
		[[1,3,5,12+k],[1,3,12+k,5],[1,4,4,12+k],[1,4,11+k,5],[2,2,2,15+k],[2,3,5,11+k],[2,3,12+k,4],[2,4,4,11+k]],
		[[1,3,5,12+k],[1,3,12+k,5],[1,4,4,12+k],[1,4,11+k,5],[2,2,3,14+k],[2,2,5,12+k],[2,3,5,11+k],[2,4,3,12+k],[2,4,4,11+k]],
		[[1,3,5,12+k],[1,3,12+k,5],[1,4,4,12+k],[1,4,13+k,3],[1,11+k,4,5],[1,11+k,6,3],[2,2,2,15+k],[2,4,11+k,4]],
		[[1,3,5,12+k],[1,3,12+k,5],[1,5,4,11+k],[1,5,12+k,3],[1,8,1,11+k],[1,11+k,6,3],[1,12+k,3,5]],
		[[1,3,5,12+k],[1,3,12+k,5],[1,6,2,12+k],[1,6,11+k,3],[1,11+k,4,5],[1,11+k,6,3],[2,2,11+k,6],[2,2,12+k,5],[2,11+k,3,5]],
		[[1,3,5,12+k],[1,3,13+k,4],[1,5,3,12+k],[1,5,11+k,4],[2,3,5,11+k],[2,3,12+k,4],[2,4,4,11+k],[2,4,11+k,4]],
		[[1,3,5,12+k],[1,3,14+k,3],[1,6,2,12+k],[1,6,11+k,3],[2,2,6,11+k],[2,2,14+k,3],[2,6,2,11+k],[2,11+k,3,5],[2,12+k,4,3]],
		[[1,3,5,12+k],[1,3,14+k,3],[1,6,2,12+k],[1,6,11+k,3],[2,2,13+k,4],[2,2,14+k,3],[2,11+k,3,5],[2,11+k,4,4],[2,12+k,4,3]],
		[[1,3,6,11+k],[1,3,11+k,6],[1,5,1,14+k],[1,5,12+k,3],[1,6,3,11+k],[1,11+k,4,5],[1,11+k,6,3]],
		[[1,3,6,11+k],[1,3,11+k,6],[1,5,4,11+k],[1,5,11+k,4],[1,14+k,2,4],[2,3,2,14+k],[2,3,11+k,5],[2,4,12+k,3]],
		[[1,3,6,11+k],[1,3,11+k,6],[1,5,4,11+k],[1,5,11+k,4],[1,14+k,2,4],[2,3,5,11+k],[2,3,13+k,3],[2,4,12+k,3],[2,5,3,11+k]],
		[[1,3,6,11+k],[1,3,11+k,6],[1,6,3,11+k],[1,6,11+k,3],[1,11+k,3,6],[1,11+k,6,3]],
		[[1,3,6,11+k],[1,3,12+k,5],[1,5,4,11+k],[1,5,12+k,3],[1,11+k,4,5],[1,11+k,6,3]],
		[[1,3,6,11+k],[1,3,13+k,4],[1,4,3,13+k],[1,4,12+k,4],[1,7,2,11+k],[2,2,2,15+k],[2,4,12+k,3],[2,11+k,4,4],[2,12+k,4,3]],
		[[1,3,6,11+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[2,2,2,15+k],[2,4,12+k,3],[2,11+k,4,4],[2,11+k,5,3]],
		[[1,3,6,11+k],[1,3,13+k,4],[1,4,5,11+k],[1,4,12+k,4],[2,2,12+k,5],[2,2,14+k,3],[2,11+k,4,4],[2,11+k,5,3],[2,12+k,3,4]],
		[[1,3,6,11+k],[1,3,13+k,4],[1,5,4,11+k],[1,5,11+k,4],[2,3,2,14+k],[2,3,11+k,5],[2,4,4,11+k],[2,4,12+k,3],[2,5,3,11+k]],
		[[1,3,6,11+k],[1,3,13+k,4],[1,5,4,11+k],[1,5,11+k,4],[2,3,5,11+k],[2,3,13+k,3],[2,4,4,11+k],[2,4,12+k,3]],
		[[1,3,6,11+k],[1,3,14+k,3],[1,5,4,11+k],[1,5,12+k,3],[2,3,4,12+k],[2,3,12+k,4],[2,4,3,12+k],[2,4,11+k,4]],
		[[1,3,11+k,6],[1,3,13+k,4],[1,12+k,2,6],[1,12+k,4,4],[2,2,3,14+k],[2,2,5,12+k],[2,3,3,13+k],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,3,11+k,6],[1,3,13+k,4],[1,14+k,2,4],[2,2,3,14+k],[2,2,4,13+k],[2,3,3,13+k],[3,3,4,11+k],[3,4,3,11+k]],
		[[1,3,11+k,6],[1,3,13+k,4],[1,14+k,2,4],[2,3,2,14+k],[2,3,11+k,5],[2,4,11+k,4],[2,11+k,4,4],[2,11+k,5,3]],
		[[1,4,1,15+k],[1,4,11+k,5],[1,5,11+k,4],[2,2,2,15+k],[2,4,11+k,4]],
		[[1,4,1,15+k],[1,4,11+k,5],[1,5,11+k,4],[2,2,4,13+k],[2,2,6,11+k],[2,4,4,11+k]],
		[[1,4,1,15+k],[1,4,11+k,5],[1,5,11+k,4],[2,2,6,11+k],[2,2,11+k,6],[2,6,2,11+k]],
		[[1,4,1,15+k],[1,4,11+k,5],[1,5,11+k,4],[3,3,4,11+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[1,4,3,13+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,11+k,4],[2,2,6,11+k],[2,2,12+k,5],[2,6,2,11+k],[2,11+k,5,3],[2,12+k,4,3]],
		[[1,4,3,13+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,11+k,4],[2,2,12+k,5],[2,2,13+k,4],[2,11+k,4,4],[2,11+k,5,3],[2,12+k,4,3]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,11+k,4],[1,7,2,11+k],[2,2,6,11+k],[2,2,12+k,5],[2,6,2,11+k]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,2,13+k],[1,5,11+k,4],[1,7,2,11+k],[2,2,12+k,5],[2,2,13+k,4],[2,11+k,4,4]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,11+k,4],[2,2,2,15+k],[2,4,11+k,4]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,11+k,4],[2,2,4,13+k],[2,2,6,11+k],[2,4,4,11+k]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,11+k,4],[2,2,6,11+k],[2,2,11+k,6],[2,6,2,11+k]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,11+k,4],[2,2,11+k,6],[2,2,13+k,4],[2,11+k,4,4]],
		[[1,4,5,11+k],[1,4,12+k,4],[1,5,4,11+k],[1,5,11+k,4],[3,3,4,11+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[2,2,2,15+k],[2,3,2,14+k],[2,3,5,11+k],[2,4,2,13+k],[2,5,11+k,3],[2,6,2,11+k],[2,11+k,3,5]],
		[[2,2,2,15+k],[2,3,5,11+k],[2,3,13+k,3],[2,4,2,13+k],[2,6,2,11+k],[2,11+k,5,3]],
		[[2,2,2,15+k],[2,4,11+k,4],[3,3,4,11+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[2,2,3,14+k],[2,2,4,13+k],[2,3,3,13+k],[2,4,4,11+k],[2,5,3,11+k],[3,3,4,11+k],[3,4,3,11+k]],
		[[2,2,3,14+k],[2,2,11+k,6],[2,3,3,13+k],[2,5,3,11+k],[2,6,2,11+k],[3,3,4,11+k],[3,4,3,11+k]],
		[[2,2,4,13+k],[2,2,6,11+k],[2,4,4,11+k],[3,3,4,11+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[2,2,4,13+k],[2,2,11+k,6],[2,4,4,11+k],[2,6,2,11+k]],
		[[2,2,6,11+k],[2,2,11+k,6],[2,6,2,11+k],[3,3,4,11+k],[3,3,11+k,4],[3,4,3,11+k]],
		[[2,3,2,14+k],[2,3,5,11+k],[2,4,4,11+k],[2,4,11+k,4],[2,5,11+k,3],[2,11+k,3,5],[2,11+k,4,4]],
		[[2,3,5,11+k],[2,3,13+k,3],[2,4,4,11+k],[2,4,11+k,4],[2,11+k,4,4],[2,11+k,5,3]]
  ];

	c:=SCFromDifferenceCycles(dc[i]);
	SCRename(c,Concatenation(["K^",String(i),"_",String(k)]));
	
	return c;

end);

################################################################################
##<#GAPDoc Label="SCSeriesPrimeTorus">
## <ManSection>
## <Func Name="SCSeriesPrimeTorus" Arg="l,j,p"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the well known triangulated torus <M>\{ (l:j:p-l-j),(l:p-l-j:j) \}</M> with <M>p</M> vertices, <M>3p</M> edges and <M>2p</M> triangles where <M>j</M> has to be greater than <M>l</M> and <M>p</M> must be any prime number greater than <M>6</M>.
## <Example><![CDATA[
## gap> l:=List([2..19],x->SCSeriesPrimeTorus(1,x,41));; 
## gap> Set(List(l,x->SCHomology(x)));
## gap> 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesPrimeTorus,
function(l,j,p)

	local c;

	if not IsPosInt(l) or not IsPosInt(j) or not IsPosInt(p) or not IsPrime(p) or not l < j or not j < p-l-j or p < 7 then
		Info(InfoSimpcomp,1,"SCSeriesPrimeTorus: arguments must be positive integers l < j < p-l-j, and p must be a prime number > 6.");
		return fail;
	fi;
	
	if not Gcd(l,j) = 1 then
		Info(InfoSimpcomp,1,"SCSeriesPrimeTorus: l and j  have to be coprime integers.");
		return fail;
	fi;
	
	c:=SCFromDifferenceCycles([[l,j,p-l-j],[l,p-l-j,j]]);
		SCRename(c,Concatenation(["prime torus S_{(",String(l),",",String(j),",",String(p),")} = { (",String(l),":",String(j),":",String(p-l-j),"),(",String(l),":",String(p-l-j),":",String(j),") }"]));
	return c;
end);


################################################################################
##<#GAPDoc Label="SCSeriesNSB1">
## <ManSection>
## <Func Name="SCSeriesNSB1" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the first neighborly sphere bundle NSB<M>_1</M> from <Cite Key="Spreer10Diss"/>, Section 4.5.4. The complex has <M>2k+1</M> vertices, <M>k \geq 4</M>
## <Example><![CDATA[
## gap> List([4..10],x->SCNeighborliness(SCSeriesNSB1(x)));
## [ 2, 2, 2, 2, 2, 2, 2 ]
## gap> List([4..10],x->SCFVector(SCSeriesNSB1(x)));        
## [ [ 9, 36, 54, 27 ], [ 11, 55, 88, 44 ], [ 13, 78, 130, 65 ], 
##   [ 15, 105, 180, 90 ], [ 17, 136, 238, 119 ], [ 19, 171, 304, 152 ], 
##   [ 21, 210, 378, 189 ] ]
## gap>  
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesNSB1,
function(k)

	local dc,c,l;

	if not IsPosInt(k) or k < 4 then
		Info(InfoSimpcomp,1,"SCSeriesNSB1: argument must be a positive integer > 3.");
		return fail;
	fi;
	
	dc:=[[1,1,2,2*k-3], [1,1,k+1,k-2], [1,k-2,1,k+1]];
	
	for l in [2..k-3] do
	  Add(dc,[1,l,2,2*k-2-l]);
	od;
	
	c:=SCFromDifferenceCycles(dc);
		SCRename(c,Concatenation(["Neighborly sphere bundle NSB_1"]));
	return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesNSB2">
## <ManSection>
## <Func Name="SCSeriesNSB2" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the second neighborly sphere bundle NSB<M>_2</M> from <Cite Key="Spreer10Diss"/>, Section 4.5.4. The complex has <M>2k</M> vertices, <M>k \geq 5</M>
## <Example><![CDATA[
## gap> List([5..10],x->SCNeighborliness(SCSeriesNSB2(x)));
## [ 2, 2, 2, 2, 2, 2 ]
## gap> List([5..10],x->SCFVector(SCSeriesNSB2(x)));       
## [ [ 10, 45, 70, 35 ], [ 12, 66, 108, 54 ], [ 14, 91, 154, 77 ], 
##   [ 16, 120, 208, 104 ], [ 18, 153, 270, 135 ], [ 20, 190, 340, 170 ] ]
## gap> 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesNSB2,
function(k)

	local dc,c,l;

	if not IsPosInt(k) or k < 5 then
		Info(InfoSimpcomp,1,"SCSeriesNSB2: argument must be a positive integer > 4.");
		return fail;
	fi;
	
	dc:=[[1,1,3,2*k-5], [1,1,k,k-2], [1,3,1,2*k-5], [2,k-2,2,k-2]];
	
	for l in [1..k-5] do
	  Add(dc,[1,k-1+l,2,k-l-2]);
	od;
	
	c:=SCFromDifferenceCycles(dc);
		SCRename(c,Concatenation(["Neighborly sphere bundle NSB_2"]));
	return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesNSB3">
## <ManSection>
## <Func Name="SCSeriesNSB3" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates the third neighborly sphere bundle NSB<M>_3</M> from <Cite Key="Spreer10Diss"/>, Section 4.5.4. The complex has <M>k</M> vertices, <M>k \geq 11</M>
## <Example><![CDATA[
## gap> List([11..15],x->SCNeighborliness(SCSeriesNSB3(x)));
## [ 2, 2, 2, 2, 2 ]
## gap> List([11..15],x->SCFVector(SCSeriesNSB3(x)));       
## [ [ 11, 55, 88, 44 ], [ 12, 66, 108, 54 ], [ 13, 78, 130, 65 ], 
##   [ 14, 91, 154, 77 ], [ 15, 105, 180, 90 ] ]
## gap> 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesNSB3,
function(k)

	local dc,c,l;

	if not IsPosInt(k) or k < 11 then
		Info(InfoSimpcomp,1,"SCSeriesNSB3: argument must be a positive integer > 10.");
		return fail;
	fi;
	
	dc:=[[1,1,1,k-3], [1,2,4,k-7], [1,4,2,k-7], [1,4,k-7,2]];
	
	for l in [4..k-8] do
	  Add(dc,[2,l,2,k-l-4]);
	od;
	
	c:=SCFromDifferenceCycles(dc);
		SCRename(c,Concatenation(["Neighborly sphere bundle NSB_3"]));
	return c;
end);


################################################################################
##<#GAPDoc Label="SCSeriesTorus">
## <ManSection>
## <Func Name="SCSeriesTorus" Arg="d"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates the <M>d</M>-torus described in <Cite Key="Kuehnel86HigherDimCsaszar"/>.
## <Example><![CDATA[
## gap> t4:=SCSeriesTorus(4);
## gap> t4.Homology;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesTorus,
function(d)

	local dc, base, i, j, c;

	if not IsPosInt(d) or d < 1 then
		Info(InfoSimpcomp,1,"SCSeriesTorus: argument must be a positive integer.");
		return fail;
	fi;

  dc:=[];
  base:=[];
  for j in [1..d] do
    Add(base,2^j); 
  od;
  for i in SymmetricGroup(d) do
    Add(dc,Concatenation([1],Permuted(base,i))); 
  od;

  c:=SCFromDifferenceCycles(dc);
  if d=1 then
  	SCRename(c,"S^1");
  	SetSCTopologicalType(c,"S^1");
  else
		SCRename(c,Concatenation([String(d),"-torus T^",String(d)]));
		SetSCTopologicalType(c,Concatenation(["T^",String(d)]));
	fi;
	return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesLensSpace">
## <ManSection>
## <Func Name="SCSeriesLensSpace" Arg="p,q"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates the lens space <M>L(p,q)</M> whenever <M>p = (k+2)^2-1</M> and <M>q = k+2</M> or <M>p = 2k+3</M> and <M>q = 1</M>
## for a <M>k \geq 0</M> and <K>fail</K> otherwise. All complexes have a transitive cyclic automorphism group.
## <Example><![CDATA[
## gap> l154:=SCSeriesLensSpace(15,4);
## gap> l154.Homology;
## gap> g:=SimplifiedFpGroup(SCFundamentalGroup(l154));
## gap> StructureDescription(g);
## ]]></Example>
## <Example><![CDATA[
## gap> l151:=SCSeriesLensSpace(15,1);
## gap> l151.Homology;
## gap> g:=SimplifiedFpGroup(SCFundamentalGroup(l151));
## gap> StructureDescription(g);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesLensSpace,
function(p,q)

  local dc, i, n, c, sqrt, k, str;

  if not IsPosInt(p) or not IsPosInt(q) then
    Info(InfoSimpcomp,1,"SCSeriesLensSpace: arguments must be positive integers.");
    return fail;
  fi;

  sqrt:=Sqrt(p+1);
  if IsInt(sqrt) and q = sqrt then 
    k:=sqrt-2;
    n:=14+4*k;
    dc:=[[1,1,1,n-3],[1,2,4,n-7],[1,4,2,n-7],[1,4,n-7,2]];
    for i in [0..k] do
      Add(dc,[2,5+2*i,2,n-9-2*i]);
    od;
    for i in [0..k] do
      Add(dc,[4,2+2*i,4,n-10-2*i]);
    od;
    c:=SCFromDifferenceCycles(dc);
  elif IsOddInt(p) and p > 2 and q = 1 then
    c:=SCIntFunc.SeifertFibredSpace(2,p,2);
  else
    Info(InfoSimpcomp,1,"SCSeriesLensSpace: only lens spaces of type L((k+1)^2-1,k+1) and L(2k+1,1), k > 0, can be generated.");
    return fail;
  fi;

  str:=Concatenation("L(",String(p),",",String(q),")");
  SCRename(c,Concatenation("Lens space ",str));
  SetSCTopologicalType(c,str);
  return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesBrehmKuehnelTorus">
## <ManSection>
## <Func Name="SCSeriesBrehmKuehnelTorus" Arg="n"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a neighborly 3-torus with <Arg>n</Arg> vertices if <Arg>n</Arg> is odd and a centrally symmetric 3-torus if <Arg>n</Arg> is even (<Arg>n</Arg><M>\geq 15</M> . The triangulations are taken from <Cite Key="Brehm09LatticeTrigE33Torus"/>
## <Example><![CDATA[
## gap> T3:=SCSeriesBrehmKuehnelTorus(15);
## gap> T3.Homology;
## gap> T3.Neighborliness;
## gap> T3:=SCSeriesBrehmKuehnelTorus(16);
## gap> T3.Homology;
## gap> T3.IsCentrallySymmetric;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesBrehmKuehnelTorus,
function(n)

	local k, dc, i, c;

	if (not IsInt(n)) or (n < 15) then
		Info(InfoSimpcomp,1,"SCSeriesBrehmKuehnelTorus: argument must be an integer greater or equal to 15.");
		return fail;
	fi;

	if n mod 4 = 3 then
		k := (n+1)/4;
		dc := [[1,k-2,k,2*k],[1,k,2,3*k-4],[1,k,2*k,k-2],[1,2*k,k-2,k],[1,2,3*k-4,k],[1,3*k-4,k,2]];
		for i in Union([2..k-3],[k+2..2*k-3]) do
			Add(dc,[1,i,1,4*k-i-3]);
		od;
	elif n mod 4 = 0 then
		k := n/4;
		dc := [[1,k-2,k,2*k+1],[1,k,2,3*k-3],[1,k,2*k+1,k-2],[1,2*k+1,k-2,k],[1,2,3*k-3,k],[1,3*k-3,k,2]];
		for i in Union([2..k-3],[k+2..2*k-3]) do
			Add(dc,[1,i,1,4*k-i-2]);
		od;
	elif n mod 4 = 1 then
		k := (n-1)/4;
		dc := [[1,k-2,k+1,2*k+1],[1,k,2,3*k-2],[1,k,2*k+2,k-2],[1,2*k+1,k-1,k],[1,2,3*k-2,k],[1,3*k-2,k,2]];
		for i in Union([2..k-3],[k+2..2*k-2]) do
			Add(dc,[1,i,1,4*k-i-1]);
		od;
	elif n mod 4 = 2 then
		k := (n-2)/4;
		dc := [[1,k-2,k+1,2*k+2],[1,k,2,3*k-1],[1,k,2*k+3,k-2],[1,2*k+2,k-1,k],[1,2,3*k-1,k],[1,3*k-1,k,2]];
		for i in Union([2..k-3],[k+2..2*k-2]) do
			Add(dc,[1,i,1,4*k-i]);
		od;
	fi;

	c := SCFromDifferenceCycles(dc);
	if n mod 2 = 0 then
		SCRename(c,Concatenation("Centrally symmetric 3-Torus SCT3(",String(n),")"));
	elif n mod 2 = 1 then
		SCRename(c,Concatenation("Neighborly 3-Torus NT3(",String(n),")"));
	fi;
	SetSCTopologicalType(c,"T^3");
	return c;
end);

SCIntFunc.SeifertFibredSpace:=function(p,q,r)
	local dc,i,k,l,m,gcd,n,a,b,tmp;

	gcd:=function(l,m,n,r)
		local dc;
		dc:=[];
		while l > m do
			l:=l-m;
			Add(dc,[m,l,m,n-2*m-l+r]);
		od;
		return [m,l,dc];
	end;

	# make sure p,q co-prime
	if GCD_INT(p,q) <> 1 then
		Info(InfoSimpcomp,1,"SCIntFunc.SeifertFibredSpace: arguments one and two must be co-prime.");
		return fail;
	fi;  

	# always finds a solution since p and q are co-prime
	k:=0;
	for i in [1..p-1] do
		if IsInt((i*q+1)/p) then
			k:=i;
			break;
		fi;
	od;
	
	# seed triangulation
	a:=k*q;
	b:=(p-k)*q-1;
	dc:=[[1,a,b,p*q+r],[1,a,p*q+r,b],[1,p*q+r,a,b]];

	# 1st exceptional fibre (p,x)
	if b > p*q-b then
		l:=b;
		m:=p*q-b;
	else
		l:=p*q-b;
		m:=b;
	fi;
	while l>p do
		tmp:=gcd(l,m,2*p*q,r);
		l:=tmp[1];
		m:=tmp[2];
		Append(dc,tmp[3]);
	od;
	
	# 2nd exceptional fibre (q,x)
	if a > p*q-a then
		l:=a;
		m:=p*q-a;
	else
		l:=p*q-a;
		m:=a;
	fi;
	while l>q do
		tmp:=gcd(l,m,2*p*q,r);
		l:=tmp[1];
		m:=tmp[2];
		Append(dc,tmp[3]);
	od;

	# 3rd exceptional fibre (r,x)
	for i in [0..Int(r/2)] do
		Add(dc,[1,p*q-1+i,1,p*q-1+r-i]);
	od;

	return SCFromDifferenceCycles(dc);
end;

################################################################################
##<#GAPDoc Label="SCSeriesHomologySphere">
## <ManSection>
## <Func Name="SCSeriesHomologySphere" Arg="p,q,r"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial Brieskorn homology sphere of type <M>\Sigma (p,q,r)</M>, <M>p</M>, <M>q</M> and <M>r</M>
## pairwise co-prime. The complex is a combinatorial <M>3</M>-manifold with transitive cyclic symmetry
## as described in <Cite Key="Spreer12VarCyclPolytope"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesHomologySphere(2,3,5);
## gap> c.Homology;
## gap> c:=SCSeriesHomologySphere(3,4,13);
## gap> c.Homology;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesHomologySphere,
function(p,q,r)
	local c,l,str;

	if not IsPosInt(p) or not IsPosInt(q) or not IsPosInt(r) or GCD_INT(p,q) > 1 or GCD_INT(p,r) > 1 or GCD_INT(q,r) > 1 or not p > 1 or not q > 1 or not r > 1 then
		Info(InfoSimpcomp,1,"SCSeriesHomologySphere: arguments must be three positive and pairwise co-prime integer.");
		return fail;
	fi;
	l:=[p,q,r];
	Sort(l);
	p:=l[1];
	q:=l[2];
	r:=l[3];

	c:= SCIntFunc.SeifertFibredSpace(p,q,r);
	str:=Concatenation("Sigma(",String(p),",",String(q),",",String(r),")");
	SetSCTopologicalType(c,str);
	SCRename(c,Concatenation("Homology sphere ",str));
	return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesConnectedSum">
## <ManSection>
## <Func Name="SCSeriesConnectedSum" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial manifold of type <M>(S^2 x S^1)^{\#k}</M> for <M>k</M> even. 
## The complex is a combinatorial <M>3</M>-manifold with transitive cyclic symmetry
## as described in <Cite Key="Spreer12VarCyclPolytope"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesConnectedSum(12);
## gap> c.Homology;
## gap> g:=SimplifiedFpGroup(SCFundamentalGroup(c));
## gap> RelatorsOfFpGroup(g);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesConnectedSum,
function(k)
	local c,str;

	if not IsEvenInt(k) or k < 2 then
		Info(InfoSimpcomp,1,"SCSeriesConnectedSum: argument must be an even positive integer.");
		return fail;
	fi;

	c:= SCIntFunc.SeifertFibredSpace(2,k+1,0);
	str:=Concatenation("(S^2xS^1)^#",String(k),")");
	SetSCTopologicalType(c,str);
	SCRename(c,str);
	return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesSeifertFibredSpace">
## <ManSection>
## <Func Name="SCSeriesSeifertFibredSpace" Arg="p,q,r"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial Seifert fibred space of type 
##
## <Display>SFS [ (\mathbb{T}^2)^{(a-1)(b-1)} : (p/a,b_1)^b , (q/b,b_2)^a, (r/ab,b_3) ]</Display>
## 
## where <M>p</M> and <M>q</M> are co-prime, <M>a = \operatorname{gcd} (p,r)</M>, <M>b = \operatorname{gcd} (p,r)</M>,
## and the <M>b_i</M> are given by the identity
##
## <Display>\frac{b_1}{p} + \frac{b_2}{q} + \frac{b_3}{r} = \frac{\pm ab}{pqr}.</Display>
##
## This <M>3</M>-parameter family of combinatorial <M>3</M>-manifolds contains the
## families generated by <Ref Func="SCSeriesHomologySphere"/>, <Ref Func="SCSeriesConnectedSum"/>
## and parts of <Ref Func="SCSeriesLensSpace"/>, internally calls <K>SCIntFunc.SeifertFibredSpace(p,q,r)</K>.
##
## The complexes are combinatorial <M>3</M>-manifolds with transitive cyclic symmetry
## as described in <Cite Key="Spreer12VarCyclPolytope"/>.
## <Example><![CDATA[
## gap> c:=SCSeriesSeifertFibredSpace(2,3,15);
## gap> c.Homology;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesSeifertFibredSpace,
function(p,q,r)
	local c,str,a,b,connSum,orbifold;

	if not IsPosInt(p) or not IsPosInt(q) or not IsInt(r) or r < 0 or GCD_INT(p,q) > 1 or p < 2 or q <= p then
		Info(InfoSimpcomp,1,"SCSeriesSeifertFibredSpace: arguments must be non-negative integers, first argument must be smaller than second argument and first and second argument mus be co-prime and > 1.");
		return fail;
	fi;

	c:= SCIntFunc.SeifertFibredSpace(p,q,r);
	a:=GCD_INT(p,r);
	b:=GCD_INT(q,r);
	connSum:=(a-1)*(b-1)/2;
	if connSum = 0 then
		orbifold:="S^2";
	elif connSum = 1 then
		orbifold:="T^2";
	else
		orbifold:=Concatenation("(T^2)^#",String(connSum));
	fi;
	if r = 0 then
		str:=Concatenation("(S^2xS^1)^#",String(2*connSum)); 
	else
	str:=Concatenation("SFS [ ",orbifold," : "); 
	if p/a > 1 then
		if b > 1 then
			str:=Concatenation(str,"(",String(p/a),",b1)^",String(b));
		else
			str:=Concatenation(str,"(",String(p/a),",b1)");
		fi;
	fi;
	if p/a > 1 and q/b > 1 then
		str:=Concatenation(str,", ");
	fi;
	if q/b > 1 then
		if a > 1 then
			str:=Concatenation(str,"(",String(q/b),",b2)^",String(a));
		else
			str:=Concatenation(str,"(",String(q/b),",b2)");
		fi;
	fi;
	if q/b > 1 or (q/b = 1 and p/a > 1) then
		str:=Concatenation(str,", (",String(r/(a*b)),",b3)");
	else
		str:=Concatenation(str,"(",String(r/(a*b)),",b3)");
	fi;
	fi;
	str:=Concatenation(str," ]");
	SetSCTopologicalType(c,str);
	SCRename(c,str);
	return c;
end);


################################################################################
##<#GAPDoc Label="SCSurface">
## <ManSection>
## <Func Name="SCSurface" Arg="g,orient"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates the surface of genus <Arg>g</Arg> where the boolean argument <Arg>orient</Arg> specifies 
## whether the surface is orientable or not. The surfaces have transitive cyclic group actions and
## can be described using the minimum amount of <M>O(\operatorname{log} (g))</M> memory.
##
## If <Arg>orient</Arg> is <C>true</C> and <Arg>g</Arg><M> \geq 50</M> or if 
## <Arg>orient</Arg> is <C>false</C> and <Arg>g</Arg><M> \geq 100</M> only the difference cycles of the
## surface are returned
## <Example><![CDATA[
## gap> c:=SCSurface(23,true); 
## gap> c.Homology;
## gap> c.TopologicalType;
## gap> c:=SCSurface(23,false); 
## gap> c.Homology;
## gap> c.TopologicalType;
## ]]></Example>
## <Example><![CDATA[
## gap> dc:=SCSurface(345,true);
## gap> c:=SCFromDifferenceCycles(dc);
## gap> c.Chi;
## gap> dc:=SCSurface(12345678910,true); time;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSurface,
function(g,orient)
	local c, G;

	if not IsInt(g) or g < 0 then
		Info(InfoSimpcomp,1,"SCSurface: first argument must be a non-negative integer.");
		return fail;
	fi;

	if not IsBool(orient) or orient = fail then
		Info(InfoSimpcomp,1,"SCSurface: second argument must be a boolean (true or false).");
		return fail;
	fi;

	if g = 0 and orient = false then
		Info(InfoSimpcomp,1,"SCSurface: there is no non-orientable surface of genus 0.");
		return fail;
	fi;

	if orient = true then
		if g = 0 then
			c:=SCBdSimplex(3);
		elif g = 1 then
			c:=SCSeriesPrimeTorus(1,2,7);
		elif g = 2 then
			c:=SCFromDifferenceCycles([[1,1,10],[2,4,6],[4,4,4]]);
		elif g = 3 then
			# Dyck's map
			G:=Group([ (1,6)(2,10)(3,11)(4,9)(5,8)(7,12), 
				   (1,10,8,7,4,2)(3,12,11,9,6,5) ]);
			c:=SCFromGenerators(G,[[1,2,4]]);
		elif g = 4 then
			G:=Group([ (1,12)(2,11)(3,10)(4,9)(5,8)(6,7), 
				   (1,2,3,4,5,6)(7,8,9,10,11,12) ]);
			c:=SCFromGenerators(G,[[1,2,4],[1,2,7],[1,3,10]]);
		elif g = 6 then
			G:=Group([ (1,9,5)(2,4,3)(6,8,7)(10,12,11), 
				   (1,4)(2,11)(3,6)(5,8)(7,10)(9,12) ]);
			c:=SCFromGenerators(G,[[1,2,4],[1,2,7],[1,3,8],[1,5,9],[1,5,11]]);
		elif g = 8 then
			G:=Group([ (1,3,5,7,9,11,13)(2,4,6,8,10,12,14), 
				   (1,8)(2,13,12,7,10,11)(3,4,9,6,5,14) ]);
			c:=SCFromGenerators(G,[[1,2,3],[1,3,7]]);			
		elif IsOddInt(g)  and g < 50 then
			c:=SCFromDifferenceCycles([[1,1,4*g-6],[2,g-2,3*g-4],[g-2,g,2*g-2]]);
		elif IsEvenInt(g)  and g < 50 then
			c:=SCFromDifferenceCycles([[1,1,2*g-4],[2,4,2*g-8],[3,3,2*g-8],[4,g-3,g-3]]);
		elif IsOddInt(g)  and g >= 50 then
			c:=[[1,1,4*g-6],[2,g-2,3*g-4],[g-2,g,2*g-2]];
		elif IsEvenInt(g)  and g >= 50 then
			c:=[[1,1,2*g-4],[2,4,2*g-8],[3,3,2*g-8],[4,g-3,g-3]];
		fi;
	else
		if g = 1 then
			G:=Group([(1,2,5)(3,4,6),(3,5)(4,6)]);
			c:=SCFromGenerators(G,[[1,2,3]]);
		elif g = 2 then
			c:=SCFromDifferenceCycles([[1,1,8],[2,4,4]]);
		elif g = 3 then
			Info(InfoSimpcomp,1,"SCSurface: there is no surface of non-orientable genus 3 with transitive automorphism group.");
			G:=Group([(1,2,5)(3,4,6),(3,5)(4,6)]);
			c:=SCFromGenerators(G,[[1,2,3]]);
			return SCConnectedSum(c,SCSeriesPrimeTorus(1,2,7));
		elif g = 4 then
			G:=Group([ (1,9,5)(2,4,3)(6,8,7)(10,12,11), 
				   (1,4)(2,11)(3,6)(5,8)(7,10)(9,12) ]);
			c:=SCFromGenerators(G,[[1,2,3],[1,2,4],[1,3,8]]);
		elif g = 5 then
			G:=Group([ (2,9)(3,5)(6,8), (1,8,3)(2,6,4)(5,9,7) ]);
			c:=SCFromGenerators(G,[[1,2,4],[1,3,8]]);
		elif g = 6 then
			Info(InfoSimpcomp,1,"SCSurface: there is no surface of non-orientable genus 6 with transitive automorphism group KNOWN to the authours.");
			return fail;
			G:=Group(());
			c:=SCFromGenerators(G,[]);
		elif g = 7 then
			G:=Group([ (1,3,5,7,9)(2,4,6,8,10), 
				   (1,9)(3,4)(5,10)(6,7) ]);
			c:=SCFromGenerators(G,[[1,2,3]]);
		elif g = 8 then
			c:=SCFromDifferenceCycles([[1,2,9],[1,3,8],[2,4,6]]);
		elif g = 9 then
			G:=Group([ (1,2,17,18,15,13)(3,4,16,9,14,20)(5,10,7,12,21,11)(6,19,8), 
				   (1,2,3)(4,8,13)(5,9,14)(6,7,15)(10,19,16)(11,20,17)(12,21,18) ]);
			c:=SCFromGenerators(G,[[1,2,3],[1,2,4],[1,4,14]]);
		elif g = 10 then
			G:=Group([ (1,9,5)(2,4,3)(6,8,7)(10,12,11), 
				   (1,4)(2,11)(3,6)(5,8)(7,10)(9,12) ]);
			c:=SCFromGenerators(G,[[1,2,3],[1,2,4],[1,3,7],[1,5,9]]);
		elif g = 11 then
			G:=Group([ (1,17,10,3,14,11,6,16,7)(2,18,9,4,13,12,5,15,8), 
				(7,8)(9,10)(11,12)(13,14)(15,16)(17,18) ]);
			c:=SCFromGenerators(G,[[1,2,7],[1,7,13]]);
		elif g = 12 then
			c:=SCFromDifferenceCycles([[1,1,13],[2,3,10],[3,6,6],[5,5,5]]);
		elif g = 13 then
			Info(InfoSimpcomp,1,"SCSurface: there is no surface of non-orientable genus 13 with transitive automorphism group KNOWN to the authours.");
			return fail;
			G:=Group(());
			c:=SCFromGenerators(G,[]);
		elif g = 14 then
			c:=SCFromDifferenceCycles([[1,1,16],[2,6,10],[4,4,10],[6,6,6]]);
		elif g = 16 then
			c:=SCFromDifferenceCycles([[1,1,12],[2,3,9],[3,5,6],[4,4,6]]);
		elif IsOddInt(g) and g < 100 then
			c:=SCFromDifferenceCycles([[1,1,g-4],[2,(g-7)/2,(g-1)/2],[3,(g-7)/2,(g-3)/2],[3,(g-5)/2,(g-5)/2]]);
		elif IsEvenInt(g) and g < 100 then
			c:=SCFromDifferenceCycles([[1,1,g-4],[2,(g-8)/2,g/2],[4,(g-8)/2,(g-4)/2],[4,(g-6)/2,(g-6)/2]]);
		elif IsOddInt(g) and g >= 100 then
			c:=[[1,1,g-4],[2,(g-7)/2,(g-1)/2],[3,(g-7)/2,(g-3)/2],[3,(g-5)/2,(g-5)/2]];
		elif IsEvenInt(g) and g >= 100 then
			c:=[[1,1,g-4],[2,(g-8)/2,g/2],[4,(g-8)/2,(g-4)/2],[4,(g-6)/2,(g-6)/2]];
		fi;


	fi;

	if (orient and g < 50) or (not orient and g < 100) then
		if g = 0 then
			SCRename(c,"S^2");
			SetSCTopologicalType(c,"S^2");
		elif g = 1 and orient then
			SCRename(c,"T^2");
			SetSCTopologicalType(c,"T^2");
		elif g = 1 and not orient then
			SCRename(c,"RP^2");
			SetSCTopologicalType(c,"RP^2");
		elif g = 2 and not orient then
			SCRename(c,"K^2");
			SetSCTopologicalType(c,"K^2");
		elif orient then
			SCRename(c,Concatenation("S_",String(g),"^or"));
			SetSCTopologicalType(c,Concatenation("(T^2)^#",String(g)));	
		else
			SCRename(c,Concatenation("S_",String(g),"^non"));
			SetSCTopologicalType(c,Concatenation("(RP^2)^#",String(g)));
		fi;
	fi;

	return c;
end);

################################################################################
##<#GAPDoc Label="SCSeriesS2xS2">
## <ManSection>
## <Func Name="SCSeriesS2xS2" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Generates a combinatorial version of <M>(S^2 \times S^2)^{\# k}</M>.
## <Example><![CDATA[
## gap> c:=SCSeriesS2xS2(3);
## gap> c.Homology;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSeriesS2xS2,
function(k)
	local dc, i, n, c, str;
	if not IsInt(k) or k < 0 then
		Info(InfoSimpcomp,1,"SCSeriesS2xS2: argument must be a non-negative integer.");
		return fail;
	fi;
	if k = 0 then
		return SCBdSimplex(5);
	fi;
	n:=6*k+6;
	dc:=[];
	Add(dc,[1,1,1,1,n-4]);
	Add(dc,[1,1,2*k+1,2*k+3,2*k]);
	Add(dc,[1,2*k+1,1,2*k+1,2*k+2]);
	Add(dc,[1,2*k+2,2*k+1,2,2*k]);

	for i in [2..2*k] do
		Add(dc,[1,1,i,1,6*k+3-i]);
	od;

	if IsOddInt(k) then
		Add(dc,[2*k+1,2,2*k+1,2*k,2]);
		for i in [0..k-2] do
			if IsOddInt(i) then
				Add(dc,[3*k-2*Int(i/2),2,3*k-2*Int((i+1)/2),2,2+2*i]);
			else
				Add(dc,[3*k-2*Int(i/2),2,3*k-2*Int((i+1)/2),2+2*i,2]);
			fi;
			Add(dc,[3*k-2*Int(i/2),3*k-2*Int((i+1)/2),2,2+2*i,2]);
		od;
	else
		Add(dc,[2*k+1,2,2*k+1,2,2*k]);
		for i in [0..k-2] do
			if IsOddInt(i) then
				Add(dc,[3*k-1-2*Int(i/2),2,3*k+1-2*Int((i+1)/2),2,2+2*i]);
			else
				Add(dc,[3*k-1-2*Int(i/2),2,3*k+1-2*Int((i+1)/2),2+2*i,2]);
			fi;
			Add(dc,[3*k-1-2*Int(i/2),3*k+1-2*Int((i+1)/2),2,2+2*i,2]);
		od;
	fi;

	for i in [0..k-2] do
		Add(dc,[1,1,6*k-2*i,2,2+2*i]);
	od;
	str:=Concatenation("(S^2 x S^2)^(# ",String(k),")"); 
	c:=SCFromDifferenceCycles(dc);
	SetSCTopologicalType(c,str);
	SCRename(c,str);
	return c;

end);
