################################################################################
##
##  simpcomp / propobject.gd
##
##  provides object type SCPropertyObject
##
##  $Id$
##
################################################################################

#representation
DeclareRepresentation("SCIsPropertyObjectRep",IsComponentObjectRep,
[
	"Properties",
	"PropertiesTmp",
	"PropertyHandlers"
]);

SCPropertyObjectFamily:=NewFamily("SCPropertyObjectFamily",SCIsPropertyObject and SCIsPropertyObjectRep and IsMutable and IsCopyable);
SCPropertyObjectType:=NewType(SCPropertyObjectFamily,SCIsPropertyObject and SCIsPropertyObjectRep and IsAttributeStoringRep);


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
InstallMethod(SCPropertyHandlersSet,"for SCPropertyObject",
[SCIsPropertyObject,IsRecord],
function(po,handlers)
	po!.PropertyHandlers:=handlers;
	return true;
end);


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
InstallMethod(SCProperties,"for SCPropertyObject",
[SCIsPropertyObject],
function(po)
	return po!.Properties;
end);

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
InstallMethod(SCPropertiesNames,"for SCPropertyObject",
[SCIsPropertyObject],
function(po)
	return RecNames(po!.Properties);
end);


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
InstallMethod(SCPropertyByName,"for SCPropertyObject",
[SCIsPropertyObject,IsString],
function(po,name)
	if not IsBound(po!.Properties.(name)) then
		return fail;
	else
		return po!.Properties.(name);
	fi;
end);


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
InstallMethod(SCPropertySet,"for SCPropertyObject",
[SCIsPropertyObject,IsString,IsObject],
function(po,name,data)
	MakeImmutable(data);
	po!.Properties.(name):=data;
	return true;
end);

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
InstallMethod(SCPropertySetMutable,"for SCPropertyObject",
[SCIsPropertyObject,IsString,IsObject],
function(po,name,data)
	po!.Properties.(name):=data;
	return true;
end);



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
InstallMethod(SCPropertyDrop,"for SCPropertyObject",
[SCIsPropertyObject,IsString],
function(po,name)
	if not IsBound(po!.Properties.(name)) then
		return fail;
	else
		Unbind(po!.Properties.(name));
	fi;
	return true;
end);

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
InstallMethod(SCPropertiesTmp,"for SCPropertyObject",
[SCIsPropertyObject],
function(po)
	return po!.PropertiesTmp;
end);

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
InstallMethod(SCPropertiesTmpNames,"for SCPropertyObject",
[SCIsPropertyObject],
function(po)
	return RecNames(po!.PropertiesTmp);
end);



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
InstallMethod(SCPropertyTmpByName,"for SCPropertyObject",
[SCIsPropertyObject,IsString],
function(po,name)
	if not IsBound(po!.PropertiesTmp.(name)) then
		return fail;
	else
		return po!.PropertiesTmp.(name);
	fi;
	return true;
end);


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
InstallMethod(SCPropertyTmpSet,"for SCPropertyObject",
[SCIsPropertyObject,IsString,IsObject],
function(po,name,data)
	po!.PropertiesTmp.(name):=data;
	return true;
end);


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
InstallMethod(SCPropertyTmpDrop,"for SCPropertyObject",
[SCIsPropertyObject,IsString],
function(po,name)
	if not IsBound(po!.PropertiesTmp.(name)) then
		return fail;
	else
		Unbind(po!.PropertiesTmp.(name));
	fi;
	return true;
end);


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
InstallMethod(SCPropertiesFlush,
[SCIsPropertyObject],
function(po)
	po!.Properties:=rec();
	po!.PropertiesTmp:=rec();
	return true;
end);


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
InstallMethod(SCPropertiesManaged,
[SCIsPropertyObject],
function(po)
	if(not IsBound(po!.PropertyHandlers)) then
		return fail;
	fi;
	
	return Concatenation(RecNames(po!.PropertyHandlers),RecNames(po!.Properties));
end);

#see whether property is handled or exists
InstallMethod(
	IsBound\.,"for SCPropertyObject",
	[SCIsPropertyObject, IsPosInt],
function(po, key)
	local strid;
	strid:=NameRNam(key);
	
	if(IsBound(po!.PropertyHandlers.(strid)) or IsBound(po!.Properties.(strid))) then
		return true;
	else
		return false;
	fi;
end);



InstallMethod(
	IsBound\.,"for SCPropertyObject",
	[SCIsPolyhedralComplex, IsPosInt],
function(po, key)
	local strid;
	strid:=NameRNam(key);
	
	if(IsBound(po!.PropertyHandlers.(strid)) or IsBound(po!.(strid))) then
		return true;
	else
		return false;
	fi;
end);


#access a property
InstallMethod(
	\.,"for SCPropertyObject",
	[SCIsPropertyObject, IsPosInt],
function(po, key)
	local strid;
	strid:=NameRNam(key);
	if(IsBound(po!.PropertyHandlers.(strid))) then
		if(IsBound(SCIntFunc.PropertyHandlersNoargs.(strid))) then
			return po!.PropertyHandlers.(strid)(po);
		else
			return SCIntFunc.WrapperFunc(po!.PropertyHandlers.(strid),po);
		fi;
	elif IsBound(po!.Properties.(strid)) then
		return po!.Properties.(strid);
	else
		Info(InfoSimpcomp,1,"SCPropertyObject: unhandled property '",strid,"'. Handled properties are ",Concatenation(RecNames(po!.PropertyHandlers),RecNames(po!.Properties)),".");
		return fail;
	fi;
end);


#wrapper function for pseudo-object-orientation
SCIntFunc.WrapperFunc:=
function(func,obj)
	return function(arg) return CallFuncList(func,Concatenation([obj],arg)); end;
end;

SCIntFunc.ParseParameters:=
function(params)
	local sc,larg;

	if(SCIntFunc._SC<>fail) then
		sc:=SCIntFunc._SC;
		SCIntFunc._SC:=fail;
		larg:=params;
	else
		if(Length(params)=0 or not SCIsSimplicialComplex(params[1])) then
			return fail;
		else
			sc:=params[1];
		fi;
		larg:=params{[2..Length(params)]};
	fi;
	
	return [sc,larg];
end;
	
SCIntFunc.EnsureParameters:=
function(func,params,filters,types)
	local i;
	
	if(IsList(params) and not IsStringRep(params)) then
		if(Length(params)<>Length(filters)) then
			Info(InfoSimpcomp,1,"SCIntFunc.EnsureParameters: number of parameters and number of types do not match."); 
			return false;
		fi;
		
		for i in [1..Length(params)] do
			if(not filters[i](params[i])) then
				Info(InfoSimpcomp,1,func,": wrong arguments, expected ",types,".");
				return false;
			fi;
		od;
		return true;
	else
		return types(params);
	fi;
end;
