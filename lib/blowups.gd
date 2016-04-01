################################################################################
##
##  simpcomp / blowups.gd
##
##  Functions for bistellar moves  
##
##  $Id: bistellar.gd 41 2010-04-07 16:32:50Z jonathan $
##
################################################################################

## <#GAPDoc Label="blowups">
## <Section Label="sec:bltheory"> <Heading>Theory</Heading>
##
## In this chapter functions are provided to perform simplicial blowups as 
## well as the resolution of isolated singularities of certain types of 
## combinatorial <M>4</M>-manifolds. As of today singularities where the 
## link is homeomorphic to <M>\mathbb{R}P^3</M>, <M>S^2 \times S^1</M>, 
## <M>S^2 \dtimes S^1</M> and the lens spaces <M>L(k,1)</M> are supported. 
## In addition, the program provides the possibility to hand over additional 
## types of mapping cylinders to cover other types of singularities.<P/> 
##
## Please note that the program is based on a heuristic algorithm using 
## bistellar moves. Hence, the search for a suitable sequence of bistellar 
## moves to perform the blowup does not always terminate. However, 
## especially in the case of ordinary double points (singularities of type 
## <M>\mathbb{R}P^3</M>), a lot of blowups have already been successful.
##
## For a very short introduction to simplicial blowups see 
## <Ref Chap="sec:Blowups"/>, for further information see 
## <Cite Key="Spreer09CombPorpsOfK3"/>.
## </Section>
##
## <Section>
## <Heading>Functions related to simplicial blowups</Heading>
##
## <#Include Label="SCBlowup"/>
## <#Include Label="SCMappingCylinder"/>
##
## </Section>
##<#/GAPDoc>

DeclareGlobalFunction("SCBlowup");
DeclareGlobalFunction("SCMappingCylinder");

################################################################################
