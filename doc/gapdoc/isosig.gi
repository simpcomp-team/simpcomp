###############################################################################
##
##  simpcomp / isosig.gi
##
##  Functions to compute the isomorphism signature of a complex
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCExportIsoSig">
## <ManSection>
## <Meth Name="SCExportIsoSig" Arg="c"/>
## <Returns>string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the isomorphism signature of a closed, strongly connected weak 
## pseudomanifold. The isomorphism signature is stored as an attribute of the
## complex.
## <Example>
## gap&gt; c:=SCSeriesBdHandleBody(3,9);;
## gap&gt; s:=SCExportIsoSig(c);
## "deefgaf.hbi.gbh.eaiaeaicg.g.ibf.heg.iff.hggcfffgg"
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExportToString">
## <ManSection>
## <Func Name="SCExportToString" Arg="c"/>
## <Returns>string upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes one string representation of a closed and strongly connected weak 
## pseudomanifold. Compare <Ref Func="SCExportIsoSig" />, which returns the
## lexicographically minimal string representation.
## <Example>
## gap&gt; c:=SCSeriesBdHandleBody(3,9);;
## gap&gt; s:=SCExportToString(c); time;
## "deffg.h.f.fahaiciai.i.hai.fbgeiagihbhceceba.g.gag"
## 5
## gap&gt; s:=SCExportIsoSig(c); time;
## "deefgaf.hbi.gbh.eaiaeaicg.g.ibf.heg.iff.hggcfffgg"
## 22
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCFromIsoSig">
## <ManSection>
## <Meth Name="SCFromIsoSig" Arg="str"/>
## <Returns>a SCSimplicialComplex object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes a simplicial complex from its isomorphism signature. If a file with
## isomorphism signatures is provided a list of all complexes is returned.
## <Example>
## gap&gt; s:="deeee";;
## gap&gt; c:=SCFromIsoSig(s);;
## gap&gt; SCIsIsomorphic(c,SCBdSimplex(4));
## true
## </Example>
## <Example>
## gap&gt; s:="deeee";;
## gap&gt; PrintTo("tmp.txt",s,"\n");;
## gap&gt; cc:=SCFromIsoSig("tmp.txt");
## [ &lt;SimplicialComplex: unnamed complex 9 | dim = 3 | n = 5&gt; ]
## gap&gt; cc[1].F;
## [ 5, 10, 10, 5 ]
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
