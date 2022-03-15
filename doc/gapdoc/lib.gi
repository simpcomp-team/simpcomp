################################################################################
##
##  simpcomp / lib.gi
##
##  simplicial complexes library
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCIsLibRepository">
## <ManSection>
## <Filt Name="SCIsLibRepository" Arg="object"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Filter for the category of a library repository <C>SCIsLibRepository</C> used by the <Package>simpcomp</Package> library. The category <C>SCLibRepository</C> is derived from the category <C>SCPropertyObject</C>.
## <Example><![CDATA[
## gap> SCIsLibRepository(SCLib); #the global library is stored in SCLib
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibIsLoaded">
## <ManSection>
## <Func Name="SCLibIsLoaded" Arg="repository"/>
## <Returns><K>true</K> or <K>false</K> upon succes, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> when a given library repository <Arg>repository</Arg> is in loaded state. This means that the directory of this repository is accessible and a repository index file for this repository exists in the repositories' path. If this is not the case <K>false</K> is returned.
## <Example><![CDATA[
## gap> SCLibIsLoaded(SCLib);
## true
## gap> SCLib.IsLoaded;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibSize">
## <ManSection>
## <Func Name="SCLibSize" Arg="repository"/>
## <Returns> integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the number of complexes contained in the given repository <Arg>repository</Arg>. Fails if the library repository was not previously loaded with <C>SCLibInit</C>.
## <Example><![CDATA[
## gap> SCLibSize(SCLib); #SCLib is the repository of the global library
## 648
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibLoad">
## <ManSection>
## <Func Name="SCLibLoad" Arg="repository, id"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C>, <K>fail</K> otherwise.</Returns>
## <Description>
## Loads a simplicial complex from the given library repository <Arg>repository</Arg> by its id <C>id</C>. The id is repository specific and ranges from 1 to N where N are the number of complexes currently in the repository (this number can be determined by <C>SCLibSize</C>). If the id is not valid (non-positive or bigger than maximal id), an error is signalled. Ids in the global library repository of <Package>simpcomp</Package>, <C>SCLib</C>, are sorted by in ascending order by the f-vector of the complexes. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("S^2~S^1"){[1..3]};
## [ [ 12, "S^2~S^1 (VT)" ], [ 26, "S^2~S^1 (VT)" ], [ 27, "S^2~S^1 (VT)" ] ]
## gap> id:=last[1][1];;
## gap> SCLibLoad(SCLib,id);
## <SimplicialComplex: S^2~S^1 (VT) | dim = 3 | n = 9>
## gap> SCLib.Load(id);; #the same operation in alternative syntax
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibUpdate">
## <ManSection>
## <Func Name="SCLibUpdate" Arg="repository [, recalc]"/>
## <Returns>library repository of type <C>SCLibRepository</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Recreates the index of a given repository (either via a repository object or a base path of a repository <Arg>repository</Arg>) by scanning the base path for all <C>.sc</C> files containing simplicial complexes of the repository. Returns a repository object with the newly created index on success or <K>fail</K> in case of an error. The optional boolean argument <Arg>recalc</Arg> forces <Package>simpcomp</Package> to recompute all the indexed properties (such as f-vector, homology, etc.) of the simplicial complexes in the repository if set to <K>true</K>. 
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");;
## gap> SCLibUpdate(myRepository);
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=0
## IndexAttributes=[ "Name", "Dim", "F", "G", "H", "Chi", "Homology", "IsPM", 
##   "IsManifold" ]
## Loaded=true
## Path="/tmp/repository/"
## ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
#############0###################################################################
################################################################################
##<#GAPDoc Label="SCLibAllComplexes">
## <ManSection>
## <Func Name="SCLibAllComplexes" Arg="repository"/>
## <Returns> list of entries of the form <C>[ integer, string ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list with entries of the form <C>[ ID, NAME ]</C> of all the complexes in the given repository <Arg>repository</Arg> of type <C>SCIsLibRepository</C>. 
## <Example><![CDATA[
## gap> all:=SCLibAllComplexes(SCLib);;
## gap> all[1];
## [ 1, "Moebius Strip" ]
## gap> Length(all);
## 648
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibAdd">
## <ManSection>
## <Func Name="SCLibAdd" Arg="repository, complex [, name]"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Adds a given simplicial complex <Arg>complex</Arg> to a given repository <Arg>repository</Arg> of type <C>SCIsLibRepository</C>. <Arg>complex</Arg> is saved to a file with suffix <C>.sc</C> in the repositories base path, where the file name is either formed from the optional argument <Arg>name</Arg> and the current time or taken from the name of the complex, if it is named. 
## <Example><![CDATA[
## gap> info:=InfoLevel(InfoSimpcomp);;
## gap> SCInfoLevel(0);;
## gap> myRepository:=SCLibInit("/tmp/repository");
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=0
## IndexAttributes=[ "Name", "Dim", "F", "G", "H", "Chi", "Homology", "IsPM", 
##   "IsManifold" ]
## Loaded=true
## Path="/tmp/repository/"
## ]
## gap> complex1:=SCBdCrossPolytope(4);;
## gap> SCLibAdd(myRepository,complex1);
## true
## gap> complex2:=SCBdCrossPolytope(4);;
## gap> myRepository.Add(complex2);; # alternative syntax
## gap> SCInfoLevel(info);;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibDelete">
## <ManSection>
## <Func Name="SCLibDelete" Arg="repository, id"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Deletes the simplicial complex with the given id <Arg>id</Arg> from the given repository <Arg>repository</Arg>. Apart from deleting the complexes' index entry, the associated <C>.sc</C> file is also deleted.
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=2
## IndexAttributes=[ "Name", "Dim", "F", "G", "H", "Chi", "Homology", "IsPM", 
##   "IsManifold" ]
## Loaded=true
## Path="/tmp/repository/"
## ]
## gap> SCLibAdd(myRepository,SCSimplex(2));;
## gap> SCLibDelete(myRepository,1);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibFlush">
## <ManSection>
## <Func Name="SCLibFlush" Arg="repository, confirm"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Completely empties a given repository <Arg>repository</Arg>. The index and all 
## simplicial complexes in this repository are deleted. The second argument, 
## <Arg>confirm</Arg>, must be the string <C>"yes"</C> in order to confirm the deletion. 
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");;
## gap> SCLibFlush(myRepository,"yes");
## #I  SCLibInit: invalid parameters.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibSearchByName">
## <ManSection>
## <Func Name="SCLibSearchByName" Arg="repository, name"/>
## <Returns>A list of items of the form <C>[ integer, string ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Searches a given repository <Arg>repository</Arg> for complexes that contain the string <Arg>name</Arg> as a substring of their name attribute and returns a list of the complexes found with entries of the form <C>[ID, NAME]</C>. See <Ref Var="SCLib"/> for a naming convention used for the global library of <Package>simpcomp</Package>.
## <Example><![CDATA[
## gap> SCLibSearchByName(SCLib,"K3");
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> SCLib.SearchByName("K3"); #alternative syntax
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> SCLib.SearchByName("S^4x"); #search for products with S^4
## [ [ 282, "S^4xS^1 (VT)" ], [ 329, "S^4xS^1 (VT)" ], [ 331, "S^4xS^1 (VT)" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibSearchByAttribute">
## <ManSection>
## <Func Name="SCLibSearchByAttribute" Arg="repository, expr"/>
## <Returns>A list of items of the form <C>[ integer, string ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Searches a given repository <Arg>repository</Arg> for complexes for which the boolean expression <Arg>expr</Arg>, passed as string, evaluates to <K>true</K> and returns a list of complexes with entries of the form <C>[ID, NAME]</C> or <K>fail</K> upon error. The expression may use all &GAP; functions and can access all the indexed attributes of the complexes in the given repository for the query. The standard attributes are: Dim (Dimension), F (f-vector), G (g-vector), H (h-vector), Chi (Euler characteristic), Homology, Name, IsPM, IsManifold. See <C>SCLib</C> for the set of indexed attributes of the global library of <Package>simpcomp</Package>. 
## <Example><![CDATA[
## gap> SCLibSearchByAttribute(SCLib,"Dim=4 and F[3]=Binomial(F[1],3)");
## [ [ 16, "CP^2 (VT)" ], [ 520, "K3_16" ] ]
## gap> SCLib.SearchByAttribute("Dim=4 and F[3]=Binomial(F[1],3)");
## [ [ 16, "CP^2 (VT)" ], [ 520, "K3_16" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibStatus">
## <ManSection>
## <Func Name="SCLibStatus" Arg="repository"/>
## <Returns>library repository of type <C>SCLibRepository</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Lets &GAP; print the status of a given library repository <Arg>repository</Arg>. <C>IndexAttributes</C> is the list of attributes indexed for this repository. If <C>CalculateIndexAttributes</C> is true, the index attributes for a complex added to the library are calculated automatically upon addition of the complex, otherwise this is left to the user and only pre-calculated attributes are indexed.
## <Example><![CDATA[
## gap> SCLibStatus(SCLib);
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=648
## IndexAttributes=[ "Name", "Dim", "F", "G", "H", "Chi", "Homology", "IsPM", 
##   "IsManifold" ]
## Loaded=true
## Path="/home/jonathan/bin/gap-4.11.1/pkg/simpcomp/complexes/"
## ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibDetermineTopologicalType">
## <ManSection>
## <Func Name="SCLibDetermineTopologicalType" Arg="[repository,] complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> or a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Tries to determine the topological type of a given complex <Arg>complex</Arg> by first looking for complexes with matching homology in the library repository <Arg>repository</Arg> (if no repository is passed, the global repository <C>SCLib</C> is used) and either returns a simplicial complex object (that is combinatorially isomorphic to the complex given) or a list of library ids of complexes in the library with the same homology as the complex provided.<P/>
## The ids obtained in this way can then be used to compare the corresponding complexes with <Arg>complex</Arg> via the function <Ref Meth="SCEquivalent" />.<P/>
##
## If <Arg>complex</Arg> is a combinatorial manifold of dimension <M>1</M> or <M>2</M> its topological type is computed, stored to the property <C>TopologicalType</C> and <Arg>complex</Arg> is returned.<P/>
##
## If no complexes with matching homology can be found, the empty set is returned.
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],
##                       [2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]);;
## gap> SCLibDetermineTopologicalType(c);
## <SimplicialComplex: unnamed complex 250 | dim = 2 | n = 6>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLibInit">
## <ManSection>
## <Func Name="SCLibInit" Arg="dir"/>
## <Returns>library repository of type <C>SCLibRepository</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function initializes a library repository object for the given directory <Arg>dir</Arg> (which has to be provided in form of a &GAP; object of type <C>String</C> or <C>Directory</C>) and returns that library repository object in case of success. The returned object then provides a mean to access the library repository via the <C>SCLib</C>-functions of <Package>simpcomp</Package>.<P/>
## The global library repository of <Package>simpcomp</Package> is loaded automatically at startup and is stored in the variable <C>SCLib</C>. User repositories can be created by calling <C>SCLibInit</C> with a desired destination directory. Note that each repository must reside in a different path since otherwise data may get lost.  <P/>
## The function first tries to load the repository index for the given directory to rebuild it (by calling <C>SCLibUpdate</C>) if loading the index fails.
## The library index of a library repository is stored in its base path in the XML file <C>complexes.idx</C>, the complexes are stored in files with suffix <C>.sc</C>, also in XML format.
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");
## #I  SCLibInit: made directory "/tmp/repository/" for user library.
## #I  SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=0
## IndexAttributes=[ "Name", "Dim", "F", "G", "H", "Chi", "Homology", "IsPM", 
##   "IsManifold" ]
## Loaded=true
## Path="/tmp/repository/"
## ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLib">
## <ManSection>
## <Var Name="SCLib" />
## <Description>
## The global variable <C>SCLib</C> contains the library object of the global library of <Package>simpcomp</Package> through which the user can access the library. The path to the global library is <C>GAPROOT/pkg/simpcomp/complexes</C>.<P/>
##
## The naming convention in the global library is the following: complexes are usually named by their topological type. As usual, `<Alt Only="LaTeX"><![CDATA[	S\^{}d]]></Alt><Alt Not="LaTeX"><![CDATA[S^d]]></Alt>' denotes a <M>d</M>-sphere, `T' a torus, `x' the cartesian product, `<Alt Only="LaTeX"><![CDATA[\~{}]]></Alt><Alt Not="LaTeX"><![CDATA[~]]></Alt>' the twisted product and `<Alt Only="LaTeX"><![CDATA[\#]]></Alt><Alt Not="LaTeX"><![CDATA[#]]></Alt>' the connected sum. The Klein Bottle is denoted by `K' or `<Alt Only="LaTeX"><![CDATA[K\^{}2]]></Alt><Alt Not="LaTeX"><![CDATA[K^2]]></Alt>'.
## <Example><![CDATA[
## gap> SCLib;
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=648
## IndexAttributes=[ "Name", "Dim", "F", "G", "H", "Chi", "Homology", "IsPM", 
##   "IsManifold" ]
## Loaded=true
## Path="/home/jonathan/bin/gap-4.11.1/pkg/simpcomp/complexes/"
## ]
## gap> SCLib.Size;
## 648
## gap> SCLib.SearchByName("S^4~");
## [ [ 203, "S^4~S^1 (VT)" ], [ 330, "S^4~S^1 (VT)" ], [ 332, "S^4~S^1 (VT)" ], 
##   [ 395, "S^4~S^1 (VT)" ], [ 451, "S^4~S^1 (VT)" ], [ 452, "S^4~S^1 (VT)" ], 
##   [ 453, "S^4~S^1 (VT)" ], [ 454, "S^4~S^1 (VT)" ], [ 455, "S^4~S^1 (VT)" ], 
##   [ 458, "S^4~S^1 (VT)" ], [ 459, "S^4~S^1 (VT)" ], [ 460, "S^4~S^1 (VT)" ] ]
## gap> SCLib.Load(last[1][1]);          
## <SimplicialComplex: S^4~S^1 (VT) | dim = 5 | n = 13>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
