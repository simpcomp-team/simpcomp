################################################################################
##
##  simpcomp / io.gd
##
##  simpcomp IO functions 
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="io">
## <Section>
## <Heading><Package>simpcomp</Package> input / output functions</Heading>
##		
## This section contains a description of the input/output-functionality 
## provided by <Package>simpcomp</Package>. The package provides the 
## functionality to save and load simplicial complexes (and their known 
## properties) to, respectively from files in XML format. Furthermore, it 
## provides the user with functions to export simplicial complexes into 
## polymake format (for this format there also exists rudimentary import 
## functionality), as JavaView geometry or in form of a &LaTeX; table.
## For importing more complex polymake data the package polymaking 
## <Cite Key="Roeder07Polymaking" /> can be used. 
##  
## <#Include Label="SCLoad"/>
## <#Include Label="SCLoadXML"/>
## <#Include Label="SCSave"/>
## <#Include Label="SCSaveXML"/>
## <#Include Label="SCExportMacaulay2"/>
## <#Include Label="SCExportPolymake"/>
## <#Include Label="SCImportPolymake"/>
## <#Include Label="SCExportLatexTable"/>
## <#Include Label="SCExportJavaView"/>
## <#Include Label="SCExportRecognizer"/>
## <#Include Label="SCExportSnapPy"/>
##
## </Section>
## <#/GAPDoc>


#positional object is list that is splitted to xml elements when 
#serialized to xml
DeclareCategory("SCIsPositionalObject",IsList);
DeclareCategory("SCIsComponentObject",IsRecord);

DeclareGlobalFunction("SCLoad");
DeclareGlobalFunction("SCLoadXML");
DeclareGlobalFunction("SCSave");
DeclareGlobalFunction("SCSaveXML");

DeclareGlobalFunction("SCExportMacaulay2");
DeclareGlobalFunction("SCExportPolymake");
DeclareGlobalFunction("SCImportPolymake");
DeclareGlobalFunction("SCExportLatexTable");
DeclareGlobalFunction("SCExportJavaView");
DeclareGlobalFunction("SCExportRecognizer");
DeclareGlobalFunction("SCExportSnapPy");




################################################################################

