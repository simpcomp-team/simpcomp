################################################################################
##<#GAPDoc Label="SCNrCyclic3Mflds">
## <ManSection>
## <Func Name="SCNrCyclic3Mflds" Arg="i"/>
## <Returns> integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Returns the number of combinatorial 3-manifolds with transitive cyclic 
## symmetry with <Arg>i</Arg> vertices.
## 
## See <Cite Key="Spreer11CyclicCombMflds"/> for more about the classification 
## of combinatorial 3-manifolds with transitive cyclic symmetry up to 
## <M>22</M> vertices.
## <Example><![CDATA[
## gap> SCNrCyclic3Mflds(22);
## 3090
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCyclic3MfldTopTypes">
## <ManSection>
## <Func Name="SCCyclic3MfldTopTypes" Arg="i"/>
## <Returns> a list of strings upon success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Returns a list of all topological types that occur in the classification 
## combinatorial 3-manifolds with transitive cyclic symmetry with <Arg>i</Arg> 
## vertices.
## 
## See <Cite Key="Spreer11CyclicCombMflds"/> for more about the classification 
## of combinatorial 3-manifolds with transitive cyclic symmetry up to 
## <M>22</M> vertices.
## <Example><![CDATA[
## gap> SCCyclic3MfldTopTypes(19);
## [ "B2", "RP^2xS^1", "SFS[RP^2:(2,1)(3,1)]", "S^2~S^1", "S^3", "Sigma(2,3,7)", 
##   "T^3" ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCyclic3Mfld">
## <ManSection>
## <Func Name="SCCyclic3Mfld" Arg="i,j"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Returns the <Arg>j</Arg>th combinatorial 3-manifold with <Arg>i</Arg> 
## vertices in the classification of combinatorial 3-manifolds with transitive 
## cyclic symmetry.
## 
## See <Cite Key="Spreer11CyclicCombMflds"/> for more about the classification 
## of combinatorial 3-manifolds with transitive cyclic symmetry up to 
## <M>22</M> vertices.
## <Example><![CDATA[
## gap> SCCyclic3Mfld(15,34);
## <SimplicialComplex: Cyclic 3-mfld (15,34): T^3 | dim = 3 | n = 15>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCyclic3MfldByType">
## <ManSection>
## <Func Name="SCCyclic3MfldByType" Arg="type"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Returns the smallest combinatorial 3-manifolds in the classification of 
## combinatorial 3-manifolds with transitive cyclic symmetry of topological 
## type <Arg>type</Arg>.
## 
## See <Cite Key="Spreer11CyclicCombMflds"/> for more about the classification 
## of combinatorial 3-manifolds with transitive cyclic symmetry up to 
## <M>22</M> vertices.
## <Example><![CDATA[
## gap> SCCyclic3MfldByType("T^3");
## <SimplicialComplex: Cyclic 3-mfld (15,34): T^3 | dim = 3 | n = 15>
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCyclic3MfldListOfGivenType">
## <ManSection>
## <Func Name="SCCyclic3MfldListOfGivenType" Arg="type"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>	
## Returns a list of indices 
## <M>\{ (i_1, j_1) , (i_1, j_1) , \ldots (i_n, j_n) \}</M> of all 
## combinatorial 3-manifolds in the classification of combinatorial 
## 3-manifolds with transitive cyclic symmetry of topological type 
## <Arg>type</Arg>. Complexes can be obtained by calling 
## <Ref Func="SCCyclic3Mfld" /> using these indices.
## 
## See <Cite Key="Spreer11CyclicCombMflds"/> for more about the 
## classification of combinatorial 3-manifolds with transitive cyclic 
## symmetry up to <M>22</M> vertices.
## <Example><![CDATA[
## gap> SCCyclic3MfldListOfGivenType("Sigma(2,3,7)");
## [ [ 19, 100 ], [ 19, 118 ], [ 19, 120 ], [ 19, 130 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
