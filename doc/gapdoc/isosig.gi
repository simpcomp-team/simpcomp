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
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(3,9);;
## gap> s:=SCExportIsoSig(c);
## "deefgaf.hbi.gbh.eaiaeaicg.g.ibf.heg.iff.hggcfffgg"
## ]]></Example>
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
## <Example><![CDATA[
## gap> c:=SCSeriesBdHandleBody(3,9);;
## gap> s:=SCExportToString(c); time;
## "deffg.h.f.fahaiciai.i.hai.fbgeiagihbhceceba.g.gag"
## 3
## gap> s:=SCExportIsoSig(c); time;
## "deefgaf.hbi.gbh.eaiaeaicg.g.ibf.heg.iff.hggcfffgg"
## 11
## ]]></Example>
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
## <Example><![CDATA[
## gap> s:="deeee";;
## gap> c:=SCFromIsoSig(s);;
## gap> SCIsIsomorphic(c,SCBdSimplex(4));
## true
## ]]></Example>
## <Example><![CDATA[
## gap> s:="deeee";;
## gap> PrintTo("tmp.txt",s,"\n");;
## gap> cc:=SCFromIsoSig("tmp.txt");
## [ <SimplicialComplex: unnamed complex 9 | dim = 3 | n = 5> ]
## gap> cc[1].F;
## [ 5, 10, 10, 5 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
