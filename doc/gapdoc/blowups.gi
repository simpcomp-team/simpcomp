################################################################################
##
##  simpcomp / blowups.gi
##
##  Functions for bistellar moves  
##
##  $Id: bistellar.gi 68 2010-04-23 14:08:15Z jonathan $
##
################################################################################
	#############################################
	#############################################
		### computing possible flips in complex ###
			### computing possible flips in boundary ###
		### initial parameters ###
			### strategy for selecting options ###
				### computing possible flips in boundary ###
				###########################
				### test, if isomorphic ###
				###########################
################################################################################
##<#GAPDoc Label="SCBlowup">
## <ManSection>
## <Prop Name="SCBlowup" Arg="pseudomanifold,singularity[,mappingCyl]"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <C>singularity</C> is an ordinary double point of a combinatorial <M>4</M>-pseudomanifold <Arg>pseudomanifold</Arg> (lk(<C>singularity</C><M>) = \mathbb{R}P^3</M>) the blowup of <C>pseudomanifold</C> at <C>singularity</C> is computed. If it is a singularity of type <M>S^2 \times S^1</M>, <M>S^2 \dtimes S^1</M> or <M>L(k,1)</M>, <M>k \leq 4</M>, the canonical resolution of <C>singularity</C> is computed using the bounded complexes provided in the source code below. <P/>
##
## If the optional argument <C>mappingCyl</C> of type <C>SCIsSimplicialComplex</C> is given, this complex will be used to to resolve the singularity <C>singularity</C>.<P/>
##
## Note that bistellar moves do not necessarily preserve any orientation. Thus, the orientation of the blowup has to be checked in order to verify which type of blowup was performed. Normally, repeated computation results in both versions.
## <Example>
## gap&gt; SCLib.SearchByName("Kummer variety");
## [ [ 7493, "4-dimensional Kummer variety (VT)" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;                
## gap&gt; d:= SCBlowup(c,1);
## #I  SCBlowup: checking if singularity is a combinatorial manifold...
## #I  SCBlowup: ...true
## #I  SCBlowup: checking type of singularity...
## #I  SCReduceComplexEx: complexes are bistellarly equivalent.
## #I  SCBlowup: ...ordinary double point (supported type).
## #I  SCBlowup: starting blowup...
## #I  SCBlowup: map boundaries...
## #I  SCBlowup: boundaries not isomorphic, initializing bistellar moves...
## #I  SCBlowup: found complex with smaller boundary: f = [ 15, 74, 118, 59 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 15, 73, 116, 58 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 15, 72, 114, 57 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 14, 68, 108, 54 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 14, 67, 106, 53 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 13, 63, 100, 50 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 13, 62, 98, 49 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 12, 58, 92, 46 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 12, 57, 90, 45 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 12, 56, 88, 44 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 12, 55, 86, 43 ].
## #I  SCBlowup: found complex with smaller boundary: f = [ 11, 51, 80, 40 ].
## #I  SCBlowup: found complex with isomorphic boundaries.
## #I  SCBlowup: ...boundaries mapped succesfully.
## #I  SCBlowup: build complex...
## #I  SCBlowup: ...done.
## #I  SCBlowup: ...blowup completed.
## #I  SCBlowup: You may now want to reduce the complex via 'SCReduceComplex'.
## [SimplicialComplex
## 
##  Properties known: Dim, FacetsEx, Name, Vertices.
## 
##  Name="unnamed complex 3122 \ star([ 1 ]) in unnamed complex 3122 cup unnamed \
## complex 3126 cup unnamed complex 3124"
##  Dim=4
## 
## /SimplicialComplex]
## </Example>
## <Example> 
## gap> # resolving the singularities of a 4 dimensional Kummer variety
## gap> SCLib.SearchByName("Kummer variety");
## [ [ 7488, "4-dimensional Kummer variety (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> for i in [1..16] do
##        for j in SCLabels(c) do 
##          lk:=SCLink(c,j);
##          if lk.Homology = [[0],[0],[0],[1]] then continue; fi; 
##          singularity := j; break;
##        od;
##        c:=SCBlowup(c,singularity); 
##      od;
## gap> d.IsManifold;
## true
## gap> d.Homology;
## [ [ 0, [ ] ], [ 0, [ ] ], [ 22, [ ] ], [ 0, [ ] ], [ 1, [ ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCMappingCylinder">
## <ManSection>
## <Func Name="SCMappingCylinder" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates a bounded version of <M>\mathbb{C}P^2</M> (a so-called mapping cylinder for a simplicial blowup, compare <Cite Key="Spreer09CombPorpsOfK3"/>) with boundary <M>L(</M><C>k</C><M>,1)</M>.
## <Example>
## gap&gt; mapCyl:=SCMappingCylinder(3);;
## gap&gt; mapCyl.Homology;              
## [ [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ], [ 0, [  ] ], [ 0, [  ] ] ]
## gap&gt; l31:=SCBoundary(mapCyl);;
## gap&gt; l31.Homology;
## [ [ 0, [  ] ], [ 0, [ 3 ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
