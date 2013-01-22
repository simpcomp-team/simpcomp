################################################################################
##
##  simpcomp / tools.gd
##
##  Miscellaneous functions   
##
##  $Id$
##
################################################################################


## <#GAPDoc Label="tools">
##
## The behaviour of <Package>simpcomp</Package> can be changed by setting cetain global options. This can be achieved by the functions described in the following.  
##
## <Section>
## <Heading><Package>simpcomp</Package> logging</Heading>
##
## The verbosity of the output of information to the screen during calls to functions of the package <Package>simpcomp</Package> can be controlled by setting the info level parameter via the function <Ref Func="SCInfoLevel" />.
##
## <ManSection>
## <Func Name="SCInfoLevel" Arg="level"/>
## <Returns><K>true</K></Returns>
## <Description>
## Sets the logging verbosity of <Package>simpcomp</Package>. A level of <M>0</M> suppresses all output, a level of <M>1</M> lets <Package>simpcomp</Package> output normal running information, whereas levels of <M>2</M> and higher display verbose running information. Examples of functions using more verbose logging are bistellar flip-related functions. 
## <Example>
## gap> SCInfoLevel(3);
## gap> c:=SCBdCrossPolytope(3);;
## gap> SCReduceComplex(c); 
## #I  round 0, move: [ [ 4, 6 ], [ 1, 2 ] ]
## F: [ 6, 12, 8 ]
## #I  round 1, move: [ [ 6 ], [ 1, 2, 3 ] ]
## F: [ 5, 9, 6 ]
## #I  round 1
## Reduced complex, F: [ 5, 9, 6 ]
## #I  round 2, move: [ [ 4 ], [ 1, 2, 5 ] ]
## F: [ 4, 6, 4 ]
## #I  round 2
## Reduced complex, F: [ 4, 6, 4 ]
## #I  SCReduceComplexEx: computed locally minimal complex after 3 rounds.
## [ true, [SimplicialComplex
##     
##      Properties known: Dim, Facets, Name, SCVertices.
##     
##      Name="unnamed complex 3"
##      Dim=2
##     
##     /SimplicialComplex], 3 ]
## </Example>
## </Description>
## </ManSection>
## </Section>
##
##
## <Section>
## <Heading>Email notification system</Heading>
##
## <Package>simpcomp</Package> comes with an email notification system that can be used for being notified of the progress of lengthy computations (such as reducing a complex via bistellar flips). See below for a description of the mail notification related functions. Note that this might not work on non-Unix systems.<P/>
## 
## See <Ref Func="SCReduceComplexEx"/> for an example computation using the email notification system. 
##
## <#Include Label="SCMailClearPending"/>
## <#Include Label="SCMailIsEnabled"/>
## <#Include Label="SCMailIsPending"/>
## <#Include Label="SCMailSend"/>
## <#Include Label="SCMailSendPending"/>
## <#Include Label="SCMailSetAddress"/>
## <#Include Label="SCMailSetEnabled"/>
## <#Include Label="SCMailSetMinInterval"/>
## </Section>
##
## <Section>
## <Heading>Testing the functionality of <Package>simpcomp</Package></Heading>
##
## <Package>simpcomp</Package> makes use of the &GAP; internal testing mechanisms and provides the user with a function to test the functionality of the package. 
##
## <#Include Label="SCRunTest"/>
##
## On a modern computer, the function <C>SCRunTest</C> should take about a minute to complete when the packages <Package>GRAPE</Package>  <Cite Key="Soicher06GRAPE"/> and <Package>homology</Package> <Cite Key="Dumas04Homology"/> are available. If these packages are missing, the testing will take slightly longer. 
##
## </Section>
##
##<#/GAPDoc>



DeclareGlobalFunction("SCMailClearPending");
DeclareGlobalFunction("SCMailIsEnabled");
DeclareGlobalFunction("SCMailIsPending");
DeclareGlobalFunction("SCMailSend");
DeclareGlobalFunction("SCMailSendPending");
DeclareGlobalFunction("SCMailSetAddress");
DeclareGlobalFunction("SCMailSetEnabled");
DeclareGlobalFunction("SCMailSetMinInterval");
DeclareGlobalFunction("SCRunTest");

