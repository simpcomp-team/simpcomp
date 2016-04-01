################################################################################
##
##  simpcomp / propobject.gd
##
##  provides object type SCPropertyObject
##
##  $Id$
##
################################################################################


## GAPDoc include
## <#GAPDoc Label="propobject">
## <Section> 
## <Heading>The &GAP; object type <C>SCPropertyObject</C></Heading>
##
## In the following, we present a number of functions to manage a &GAP; object of type <C>SCPropertyObject</C>. Since most properties of <C>SCPolyhedralComplex</C>, <C>SCSimplicialComplex</C> and <C>SCNormalSurface</C> are managed by the GAP4 type system (cf. <Cite Key="Breuer98GAP4TypeSystem"/>), the functions described below are mainly used by the object type <C>SCLibRepository</C> and to store temporary properties.
##
## <#Include Label="SCProperties"/>
## <#Include Label="SCPropertiesFlush"/>
## <#Include Label="SCPropertiesManaged"/>
## <#Include Label="SCPropertiesNames"/>
## <#Include Label="SCPropertiesTmp"/>
## <#Include Label="SCPropertiesTmpNames"/>
## <#Include Label="SCPropertyByName"/>
## <#Include Label="SCPropertyDrop"/>
## <#Include Label="SCPropertyHandlersSet"/>
## <#Include Label="SCPropertySet"/>
## <#Include Label="SCPropertySetMutable"/>
## <#Include Label="SCPropertyTmpByName"/>
## <#Include Label="SCPropertyTmpDrop"/>
## <#Include Label="SCPropertyTmpSet"/>
## </Section>
## <#/GAPDoc>

DeclareCategory("SCIsPropertyObject",IsRecord);

DeclareOperation("SCPropertiesFlush",[SCIsPropertyObject]);
DeclareOperation("SCProperties",[SCIsPropertyObject]);
DeclareOperation("SCPropertiesManaged",[SCIsPropertyObject]);
DeclareOperation("SCPropertiesNames",[SCIsPropertyObject]);
DeclareOperation("SCPropertiesTmp",[SCIsPropertyObject]);
DeclareOperation("SCPropertiesTmpNames",[SCIsPropertyObject]);
DeclareOperation("SCPropertyByName",[SCIsPropertyObject,IsString]);
DeclareOperation("SCPropertyDrop",[SCIsPropertyObject,IsString]);
DeclareOperation("SCPropertyHandlersSet",[SCIsPropertyObject,IsRecord]);
DeclareOperation("SCPropertySet",[SCIsPropertyObject,IsString,IsObject]);
DeclareOperation("SCPropertySetMutable",[SCIsPropertyObject,IsString,IsObject]);
DeclareOperation("SCPropertyTmpByName",[SCIsPropertyObject,IsString]);
DeclareOperation("SCPropertyTmpDrop",[SCIsPropertyObject,IsString]);
DeclareOperation("SCPropertyTmpSet",[SCIsPropertyObject,IsString,IsObject]);

################################################################################

