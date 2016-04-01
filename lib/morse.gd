################################################################################
##
##  simpcomp / morse.gd
##
##  Polyhedral Morse functions 
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="morse">
## 
## In this chapter we present some useful functions dealing with polyhedral Morse theory. See Section <Ref Chap="sec:MorseTheory" /> for a very short introduction to the field, see <Cite Key="Kuehnel95TightPolySubm" /> for more information. Note: this is not to be confused with Robin Forman's discrete Morse theory for cell complexes which is described in Chapter <Ref Chap="chap:DMT"/>.<P/>
## 
## If <M>M</M> is a combinatorial <M>d</M>-manifold with <M>n</M>-vertices a  rsl-function will be represented as an ordering on the set of vertices, i. e. a list of length <M>n</M> containing all vertex labels of the corresponding simplicial complex.<P/>
## 
## <Section Label="sec:morsefunc">
## <Heading>Polyhedral Morse theory related functions</Heading>
## 
## <#Include Label="SCIsTight"/>
## <#Include Label="SCMorseIsPerfect"/>
## <#Include Label="SCSlicing"/>
## <#Include Label="SCMorseMultiplicityVector"/>
## <#Include Label="SCMorseNumberOfCriticalPoints"/>
## 
## </Section>
## 
## 
## <!--
## <Section>
## <Heading></Heading>
## </Section>
## -->
## 
## <#/GAPDoc>

DeclareAttribute("SCIsTight",SCIsPolyhedralComplex);

DeclareGlobalFunction("SCMorseIsPerfect");
DeclareGlobalFunction("SCSlicing");
DeclareGlobalFunction("SCMorseMultiplicityVector");
DeclareGlobalFunction("SCMorseNumberOfCriticalPoints");
