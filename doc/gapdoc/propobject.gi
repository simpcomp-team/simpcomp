################################################################################
##
##  simpcomp / propobject.gd
##
##  provides object type SCPropertyObject
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertyHandlersSet">
## <ManSection>
## <Meth Name="SCPropertyHandlersSet" Arg="po, handlers"/>
## <Returns><K>true</K></Returns>
## <Description>
## Sets the property handling functions for a SCPropertyObject <Arg>po</Arg> to the functions described in the record <Arg>handlers</Arg>. The record <Arg>handlers</Arg> has to contain entries of the following structure: <C>[Property Name]:=[Function name computing and returning the property]</C>. For <C>SCSimplicialComplex</C> for example <Package>simpcomp</Package> defines (among many others): <C>F:=SCFVector</C>. See the file <C>lib/prophandler.gd</C>.    
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCProperties">
## <ManSection>
## <Meth Name="SCProperties" Arg="po"/>
## <Returns>a record upon success.</Returns>
## <Description>
## Returns the record of all stored properties of the <C>SCPropertyObject</C> <Arg>po</Arg>.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertiesNames">
## <ManSection>
## <Meth Name="SCPropertiesNames" Arg="po"/>
## <Returns>a list upon success.</Returns>
## <Description>
## Returns a list of all the names of the stored properties of the <C>SCPropertyObject</C> <Arg>po</Arg>. These can be accessed via <Ref Meth="SCPropertySet" /> and <Ref Meth="SCPropertyDrop" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertyByName">
## <ManSection>
## <Meth Name="SCPropertyByName" Arg="po, name"/>
## <Returns>any value upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the value of the property with name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg> if this property is known for <Arg>po</Arg> and <K>fail</K> otherwise. The names of known properties can be accessed via the function <Ref Meth="SCPropertiesNames" /> 
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertySet">
## <ManSection>
## <Meth Name="SCPropertySet" Arg="po, name, data"/>
## <Returns><K>true</K> upon success.</Returns>
## <Description>
## Sets the value of the property with name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg> to <Arg>data</Arg>. Note that the argument becomes immutable. If this behaviour is not desired, use <Ref Meth="SCPropertySetMutable" /> instead.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertySetMutable">
## <ManSection>
## <Meth Name="SCPropertySetMutable" Arg="po, name, data"/>
## <Returns><K>true</K> upon success.</Returns>
## <Description>
## Sets the value of the property with name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg> to <Arg>data</Arg>. Note that the argument does not become immutable. If this behaviour is not desired, use <Ref Meth="SCPropertySet" /> instead.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertyDrop">
## <ManSection>
## <Meth Name="SCPropertyDrop" Arg="po, name"/>
## <Returns><K>true</K> upopn success, <K>fail</K> otherwise</Returns>
## <Description>
## Drops the property with name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg>. Returns <K>true</K> if the property is successfully dropped and <K>fail</K> if a property with that name did not exist.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertiesTmp">
## <ManSection>
## <Meth Name="SCPropertiesTmp" Arg="po"/>
## <Returns>a record upon success.</Returns>
## <Description>
## Returns the record of all stored temporary properties (these are mutable in contrast to regular properties and not serialized when the object is serialized to XML) of the <C>SCPropertyObject</C> <Arg>po</Arg>.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertiesTmpNames">
## <ManSection>
## <Meth Name="SCPropertiesTmpNames" Arg="po"/>
## <Returns>a list upon success.</Returns>
## <Description>
## Returns a list of all the names of the stored temporary properties of the <C>SCPropertyObject</C> <Arg>po</Arg>. These can be accessed via <Ref Meth="SCPropertyTmpSet" /> and <Ref Meth="SCPropertyTmpDrop" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertyTmpByName">
## <ManSection>
## <Meth Name="SCPropertyTmpByName" Arg="po, name"/>
## <Returns>any value upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the value of the temporary property with the name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg> if this temporary property is known for <Arg>po</Arg> and <K>fail</K> otherwise. The names of known temporary properties can be accessed via the function <Ref Meth="SCPropertiesTmpNames" /> 
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertyTmpSet">
## <ManSection>
## <Meth Name="SCPropertyTmpSet" Arg="po, name, data"/>
## <Returns><K>true</K> upon success.</Returns>
## <Description>
## Sets the value of the temporary property with name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg> to <Arg>data</Arg>. Note that the argument does not become immutable. This is the standard behaviour for temporary properties.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertyTmpDrop">
## <ManSection>
## <Meth Name="SCPropertyTmpDrop" Arg="po, name"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise</Returns>
## <Description>
## Drops the temporary property with name <Arg>name</Arg> of the <C>SCPropertyObject</C> <Arg>po</Arg>. Returns <K>true</K> if the property is successfully dropped and <K>fail</K> if a temporary property with that name did not exist.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertiesFlush">
## <ManSection>
## <Meth Name="SCPropertiesFlush" Arg="po"/>
## <Returns><K>true</K> upon success.</Returns>
## <Description>
## Drops all properties and temporary properties of the  <C>SCPropertyObject</C> <Arg>po</Arg>.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCPropertiesManaged">
## <ManSection>
## <Meth Name="SCPropertiesManaged" Arg="po"/>
## <Returns>a list of managed properties upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list of all properties that are managed for the <C>SCPropertyObject</C> <Arg>po</Arg> via property handler functions. See <Ref Meth="SCPropertyHandlersSet" />.
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
