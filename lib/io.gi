################################################################################
##
##  simpcomp / io.gi
##
##  simpcomp IO functions 
##
##  $Id$
##
################################################################################

#make list to dense string (not containing any spaces
SCIntFunc.ListToDenseString:=function(item)
	if(IsStringRep(item)) then
		return Concatenation(["\"",item,"\""]);
	elif(IsList(item) and not IsStringRep(item)) then
		return Concatenation("[",
      JoinStringsWithSeparator(List(item,SCIntFunc.ListToDenseString),","),"]");
	else
		return String(item);
	fi;
end;




#parsing variables
SCIntFunc.parseDelim:=',';
SCIntFunc.parseOpenstruct:='[';
SCIntFunc.parseClosestruct:=']';
SCIntFunc.parseArray:=['0','1','2','3','4','5','6','7','8','9',' ',',',
  '[',']','\'','\"'];
SCIntFunc.parseChar:='\'';
SCIntFunc.parseString:='\"';
SCIntFunc.parseEscape:='\\';

#reader functions for reading xml (pc)data 
SCIntFunc.ReadInteger:=
function(string)
	if IsEmptyString(string) or not ForAll(string,x->IsDigitChar(x) or x='-') then
		Info(InfoSimpcomp,1,"SCIntFunc.ReadInteger: error reading from string \"",
      string,"\".");
		return fail;
	else
		return Int(string);
	fi;
end;

SCIntFunc.ReadBoolean:=
function(string)
	local b;
	b:=SCIntFunc.ReadInteger(string);
	if(b<>fail) then
		if(b=0) then
			return false;
		elif(b=1) then
			return true;
		fi;
	fi;
	Info(InfoSimpcomp,1,"SCIntFunc.ReadBoolean: error reading from string \"",
    string,"\".");
	return fail;
end;

SCIntFunc.BooleanToString:=
function(b)
	if(b=false) then
		return "0";
	elif(b=true) then
		return "1";
	else
		return "2";
	fi;
end;

SCIntFunc.ReadString:=
function(string)
	return String(string);
end;


SCIntFunc.ReadArray:=
function(string)
	local p,ret,ReadArrayInteger,ReadArrayString,ReadArrayArray;

	ReadArrayInteger:=function(arr,pos)
		local p,int;

		int:=[];

		for p in [pos..Length(arr)] do
			if(IsDigitChar(arr[p]) or arr[p]='-') then
				Add(int,arr[p]);
			else
				break;
			fi;
		od;

		if(int=[] or (p=Length(arr) and not arr[Length(arr)]=']')) then
			Info(InfoSimpcomp,1,"ReadArrayInteger: error reading from string \"",
        arr,"\" at position ",pos,".");
			return [fail,pos];
		else
			return [Int(int),p];
		fi;
	end;

	ReadArrayString:=function(arr,pos)
		local p,int,delim,escape,str;

		str:=[];
		escape:=false;
		delim:=arr[pos];
		for p in [pos+1..Length(arr)] do
			if(arr[p]=SCIntFunc.parseEscape) then
				escape:=true;
				continue;
			fi;

			if(escape) then
				Add(str,arr[p]);
				escape:=false;
			elif(arr[p]=delim) then
				return [str,p+1];
			else
				Add(str,arr[p]);
			fi;
		od;

		Info(InfoSimpcomp,1,"ReadArrayString: error reading from string \"",
      arr,"\" at position ",pos,".");
		return [fail,pos];
	end;

	ReadArrayArray:=function(arr,pos)
		local p,int,ret,a,range;

		a:=[];
		range:=false;
		p:=pos+1;
		while p<=Length(arr) do
			if(arr[p]=' ' or arr[p]=',') then
				p:=p+1;
				continue;
			fi;

			if(range and not (IsDigitChar(arr[p]) or arr[p]='-')) then
				return fail;
			fi;

			if(not range and arr[p]=']') then
				return [a,p+1];
			elif(arr[p]='[') then
				ret:=ReadArrayArray(arr,p);
			elif(IsDigitChar(arr[p]) or arr[p]='-') then
				ret:=ReadArrayInteger(arr,p);
			elif(arr[p]='\'' or arr[p]='\"') then
				ret:=ReadArrayString(arr,p);
			elif(arr[p]='.' and p<Length(arr) and arr[p+1]='.') then
				range:=true;
				p:=p+2;
				continue;
			else
				Info(InfoSimpcomp,1,"ReadArrayArray: unknown type in string \"",
          arr,"\" at position ",pos,".");
				ret:=fail;
			fi;

			if(ret=fail or ret[1]=fail) then
				return fail;
			fi;

			if(not range) then
				Add(a,ret[1]);
				p:=ret[2];
			else
				range:=[a[Length(a)]..ret[1]];
				a[Length(a)]:=range;
				p:=ret[2];
				range:=false;
			fi;
		od;

		return fail;
	end;


	for p in [1..Length(string)] do
		if(string[p]=' ') then
			continue;
		fi;

		if(string[p]='[') then
			ret:=ReadArrayArray(string,p);
			if(ret=fail) then
				return fail;
			else
				return ret[1];
			fi;
		else
			break;
		fi;
	od;

	Info(InfoSimpcomp,1,"SCIntFunc.ReadArray: no starting sequence found ",
    "in string \"",string,"\".");
	return fail;
end;

SCIntFunc.ReadPerm:=
function(arr)
	local a;
	a:=SCIntFunc.ReadArray(arr);
	if(a<>fail) then
		return PermList(a);
	else
		return fail;
	fi;
end;

SCIntFunc.PermToString:=
function(p)
	return SCIntFunc.ListToDenseString(ListPerm(p));
end;


SCIntFunc.ReadPermGroup:=
function(arr)
	local a,g;
	a:=SCIntFunc.ReadArray(arr);

	if(a<>fail) then
		if a <> [] and a<>[[]] then
			if(IsString(a[1]) and a[1]<>[]) then
				if(a[2]<>[]) then
					g:=Group(List(a[2],x->PermList(x)));
				else
					g:=Group(());
				fi;
				SetStructureDescription(g,a[1]);
				SetName(g,a[1]);
				return g;
			else
				return Group(List(a,x->PermList(x)));
			fi;
		else
			return Group(());
		fi;
	else
		return fail;
	fi;
end;

SCIntFunc.PermGroupToString:=
function(g)
	if(HasName(g) and Name(g)<>"") then
		return String([Name(g),List(GeneratorsOfGroup(g),x->ListPerm(x))]);
	else
		return String([StructureDescription(g),
      List(GeneratorsOfGroup(g),x->ListPerm(x))]);
	fi;
end;





#position object (gets splitted into elements when serialized to xml, 
#as opposed to list)
SCPositionalObjectFamily:=NewFamily("SCPositionalObjectFamily",
  SCIsPositionalObject and IsPositionalObjectRep and IsMutable);
SCPositionalObjectType:=NewType(SCPositionalObjectFamily,SCIsPositionalObject);

#create positional object from list
SCIntFunc.SCPositionalObjectFromList:=
function(list)
	return Objectify(SCPositionalObjectType,rec(data:=list));
end;

#methods for positional object
InstallMethod(
	\[\],"for SCPositionalObject",
	[SCIsPositionalObject,IsInt],
function(po, pos)
	 return po!.data[pos];
end);

InstallMethod(
	IsBound\[\],"for SCPositionalObject",
	[SCIsPositionalObject,IsInt],
function(po, pos)
	return IsBound(po!.data[pos]);
end);

InstallMethod(
	\[\]\:\=,"for SCPositionalObject",
	[SCIsPositionalObject and IsMutable,IsInt,IsObject],
function(po, pos, val)
	po!.data[pos]:=val;
end);

InstallMethod(
	Unbind\[\],"for SCPositionalObject",
	[SCIsPositionalObject and IsMutable,IsInt],
function(po, pos)
	Unbind(po!.data[pos]);
end);

InstallMethod(
	Length,"for SCPositionalObject",
	[SCIsPositionalObject],
function(po)
	return Length(po!.data);
end);

InstallMethod(
	ViewObj,"for SCPositionalObject",
	[SCIsPositionalObject],
function(po)
	ViewObj(po!.data);
end);

InstallMethod(
	PrintObj,"for SCPositionalObject",
	[SCIsPositionalObject],
function(po)
	PrintObj(po!.data);
end);


#serialize object to xml
SCIntFunc.SCObjectToXML:=
function(object,name,ident)
	local type,prefix,subitems,processed;

	if(object=fail) then
		return "";
	fi;

	processed:=false;
	for type in RecNames(SCIntFunc.SCXMLIOHandlers) do
		if(not SCIntFunc.SCXMLIOHandlers.(type)[1](object)) then
			continue;
		else
			prefix:=Concatenation(ListWithIdenticalEntries(ident,"\t"));

			if(SCIntFunc.SCXMLIOHandlers.(type)[4]=true) then
				#atomic type
				return Concatenation([prefix,"<",String(name)," type=\"",type,"\">",
          SCIntFunc.SCXMLIOHandlers.(type)[2](object),"</",name,">\n"]);
			else
				#compound type
				return Concatenation([prefix,"<",String(name)," type=\"",type,"\">\n",
          SCIntFunc.SCXMLIOHandlers.(type)[2](object,ident),prefix,"</",name,
          ">\n"]);
			fi;
		fi;
	od;

	Info(InfoSimpcomp,3,"SCIntFunc.SCObjectToXML: ignoring property ",name,
    " -- unknown type.");
	return "";
end;


#element reading handler for xml reader
SCIntFunc.SCXMLElementHandler:=
function(target,pos,root)
	local type,content,c,value,data,lpos;

	if(root.name="PCDATA" or root.name="XMLPI" or 
      root.name="XMLCOMMENT" or root.name="Ignore") then
		#ignore processing instructions & comments
		return 0;
	fi;

	#assume type string
	type:="SCString";
	value:=fail;

	if "attributes" in RecNames(root) and "type" in RecNames(root.attributes) then
		type:=root.attributes.type;
	fi;


	if(type="SCEmpty") then
		return 1;
	fi;


	if(not type in RecNames(SCIntFunc.SCXMLIOHandlers)) then
		Info(InfoSimpcomp,3,"SCIntFunc.SCXMLElementHandler: warning, ignoring ",
      "unknown type \"",type,"\".");
		return 0;
	fi;

	value:=fail;
	if(SCIntFunc.SCXMLIOHandlers.(type)[4]=true) then
		#atomic content
		content:=fail;
		for c in root.content do
			if c.name="PCDATA" then
				content:=c.content;
				break;
			fi;
		od;

		if(content=fail) then
			Info(InfoSimpcomp,1,"SCIntFunc.SCXMLElementHandler: getting content of ",
        "xml node ",root," failed.");
			return -1;
		fi;

		value:=SCIntFunc.SCXMLIOHandlers.(type)[3](content);
	else
		#xml content
		value:=SCIntFunc.SCXMLIOHandlers.(type)[3](root);
	fi;

	if(value=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCXMLElementHandler: I/O handler ",
      "for property ",root.name," failed.");
		return -1;
	fi;

	if(IsRecord(target)) then
		target.(root.name):=value;
	elif(IsList(target)) then
		target[pos]:=value;
	else
		Info(InfoSimpcomp,1,"SCIntFunc.SCXMLElementHandler: target object ",
      "neither of Record nor of List type. target=",target,".");
		return -1;
	fi;
	
	return 1;
end;

#deserialize xml to object
SCIntFunc.SCXMLToObject:=
function(xml)
	local n,tree,items,pos;

	if(IsEmptyString(xml)) then
		return [];
	fi;
	tree:=ParseTreeXMLString(xml);
	if(tree=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCXMLToObject: parsing xml ",
      "input string failed.");
		return fail;
	fi;
	if tree.name="WHOLEDOCUMENT" then
		#start processing
		items:=[];
		pos:=1;
		for n in tree.content do
			if(SCIntFunc.SCXMLElementHandler(items,pos,n)>0) then
				pos:=pos+1;
				
			fi;
		od;
		return items;
	fi;

	Info(InfoSimpcomp,1,"SCIntFunc.SCXMLToObject: xml document root not found.");
	return fail;
end;


#serialize record to xml
SCIntFunc.RecordToXML:=
function(object,ident)
	local key,subitems;
	
	if(not IsRecord(object)) then
		Info(InfoSimpcomp,1,"SCIntFunc.RecordToXML: first argument must be ",
      "of type Record.");
		return "";
	fi;
	
	subitems:="";
	for key in RecNames(object) do
		Append(subitems,SCIntFunc.SCObjectToXML(object.(key),key,ident+1));
	od;
	return subitems;
end;


#deserialize record from xml
SCIntFunc.RecordFromXML:=
function(root)
	local c,r;
	r:=rec();
	for c in root.content do
		SCIntFunc.SCXMLElementHandler(r,1,c);
	od;
	return r;
end;


#serialize positional object to xml
SCIntFunc.PositionalObjectToXML:=
function(object,ident)
	local key,subitems,prefix;
	subitems:="";

	if(not SCIsPositionalObject(object)) then
		Info(InfoSimpcomp,1,"SCIntFunc.PositionalObjectToXML: first argument ",
      "must be of type SCPositionalObject.");
		return "";
	fi;
	
	
	prefix:=Concatenation(ListWithIdenticalEntries(ident,"\t"));
	for key in [1..Length(object)] do
		if(not IsBound(object[key])) then
			Append(subitems,Concatenation(prefix,
        "\t<Entry type=\"SCEmpty\"></Entry>\n"));
		else
			Append(subitems,SCIntFunc.SCObjectToXML(object[key],"Entry",ident+1));
		fi;
	od;
	return subitems;
end;


#deserialize positional object from xml
SCIntFunc.PositionalObjectFromXML:=
function(root)
	local c,po,pos;
	po:=[];
	pos:=1;
	for c in root.content do
		if(SCIntFunc.SCXMLElementHandler(po,pos,c)>0) then
			pos:=pos+1;
		fi;
	od;
	return SCIntFunc.SCPositionalObjectFromList(po);
end;



#serialize fp group to xml
SCIntFunc.FpGroupToXML:=
function(object,ident)
	local key,subitems,prefix;
	subitems:="";

	if(not IsFpGroup(object)) then
		Info(InfoSimpcomp,1,"SCIntFunc.FpGroupToXML: first argument must be ",
      "of type FpGroup.");
		return "";
	fi;
	
	
	prefix:=Concatenation(ListWithIdenticalEntries(ident,"\t"));
	
	Append(subitems,Concatenation(prefix,"\t<Generators type=\"SCArray\">",
    String(List(GeneratorsOfGroup(object),String)),"</Generators>\n"));
	Append(subitems,Concatenation(prefix,"\t<Relators type=\"SCArray\">",
    String(List(RelatorsOfFpGroup(object),String)),"</Relators>\n"));
	
	#return subitems;
	return "";
end;


#deserialize fp group from xml
SCIntFunc.FpGroupFromXML:=
function(root)
	local c,po,pos;
	po:=[];
	pos:=1;
	for c in root.content do
		if(SCIntFunc.SCXMLElementHandler(po,pos,c)>0) then
			pos:=pos+1;
		fi;
	od;
	return [];
end;


#serialize simplicial complex object to xml
SCIntFunc.SCSimplicialComplexToXML:=
function(object,ident)
	local key,subitems,prefix;
	subitems:="";
	
	if(not SCIsSimplicialComplex(object)) then
		Info(InfoSimpcomp,1,"SCIsSimplicialComplex: first argument must be of ",
      "type SCSimplicialComplex.");
		return "";
	fi;
	
	prefix:=Concatenation(ListWithIdenticalEntries(ident,"\t"));
	subitems:="";
	
	#legacy format v1
	#for key in SCPropertiesNames(object) do
	#	Append(subitems,SCIntFunc.SCObjectToXML(SCPropertyByName(object,key),
  # key,ident+1));
	#od;
	
	#new format v2
	for key in KnownAttributesOfObject(object) do
		Append(subitems,SCIntFunc.SCObjectToXML(object!.(key),key,ident+1));
	od;
	
	return subitems;
end;


#deserialize simplicial complex object from xml, legacy format 1
SCIntFunc.SCSimplicialComplexFromXMLv1Legacy:=rec(
Facets:=SCFacetsEx,
Faces:=SCFaceLatticeEx,
VertexLabels:=SCFacetsEx,
StronglyConnected:=SCIsStronglyConnected,
Connected:=SCIsConnected,
Generators:=SCGeneratorsEx,
MinimalNonFaces:=SCMinimalNonFacesEx,
Pure:=SCIsPure,
PM:=SCIsPseudoManifold,
CentrallySymmetric:=SCIsCentrallySymmetric,
CohomologyBasis:=SCCohomologyBasis,
HomologyBasis:=SCHomologyBasis,
);

SCIntFunc.SCSimplicialComplexFromXMLv1:=
function(root)
	local props,key,fkey,sc;

	props:=SCIntFunc.RecordFromXML(root);
	sc:=SCIntFunc.SCNew();
	
	for key in RecNames(props) do
		if(IsBound(SCIntFunc.SCSimplicialComplexFromXMLv1Legacy.(key))) then
			fkey:=SCIntFunc.SCSimplicialComplexFromXMLv1Legacy.(key);
		elif(IsBound(SCIntFunc.SCPropertyHandlers.(key))) then
			fkey:=SCIntFunc.SCPropertyHandlers.(key);
		else
			fkey:=EvalString(key);
		fi;
		if(Setter(fkey)=false or Setter(fkey)=fail) then
			Info(InfoSimpcomp,2,"SCIntFunc.SCSimplicialComplexFromXMLv1: legacy ",
        "format, skipped loading attribute '",key,"'");
			continue;
		fi;
		Setter(fkey)(sc,props.(key));
	od;
	
	return sc;
end;


#deserialize simplicial complex object from xml, format 2
SCIntFunc.SCSimplicialComplexFromXMLv2:=
function(root)
	local props,key,sc;

	props:=SCIntFunc.RecordFromXML(root);
	sc:=SCIntFunc.SCNew();
	
	for key in RecNames(props) do
		Setter(EvalString(key))(sc,props.(key));
	od;
	
	return sc;
end;



#serialize library repository object to xml
SCIntFunc.SCLibraryRepositoryToXML:=
function(object,ident)
	local key,subitems,prefix;
	subitems:="";

	if(not SCIsLibRepository(object)) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCLibraryRepositoryToXML: first argument ",
      "must be of type SCLibRepository.");
		return "";
	fi;

	prefix:=Concatenation(ListWithIdenticalEntries(ident,"\t"));
	subitems:="";
	for key in SCPropertiesNames(object) do
		if(key="Loaded") then continue; fi;
		Append(subitems,SCIntFunc.SCObjectToXML(SCPropertyByName(object,key),
      key,ident+1));
	od;
	return subitems;
end;


#deserialize library repository object from xml
SCIntFunc.SCLibraryRepositoryFromXML:=
function(root)
	local props;

	props:=SCIntFunc.RecordFromXML(root);

	if(props=fail) then
		return fail;
	fi;

	return SCIntFunc.LibRepositoryEmptyWithAttributes(props);
end;



################################################################################
##<#GAPDoc Label="SCLoad">
## <ManSection>
## <Func Name="SCLoad" Arg="filename"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Loads a simplicial complex stored in a binary format (using 
## <C>IO_Pickle</C>) from a file specified in <Arg>filename</Arg> (as string). 
## If <Arg>filename</Arg> does not end in <C>.scb</C>, this suffix is 
## appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSave(c,"/tmp/bddelta3");
## true
## gap> d:=SCLoad("/tmp/bddelta3");
## gap> c=d;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLoad,
	function(filename)

	local lf,fh,c;

	if(not IsString(filename)) then
		Info(InfoSimpcomp,1,"SCLoad: first argument must be of type String.");
		return fail;
	fi;

	#try to detect format (xml,binary) by extension
	if(Length(filename)>2 and 
    filename{[Length(filename)-2..Length(filename)]}=".sc") then
		Info(InfoSimpcomp,2,"SCLoad: assuming XML format for file '",
      filename,"', falling back to SCLoadXML.");
		return SCLoadXML(filename);
	fi;
	
	lf:=ShallowCopy(filename);
	if(Length(filename)<4 or 
    filename{[Length(filename)-3..Length(filename)]}<>".scb") then
		Append(lf,".scb");
	fi;
	
	fh:=IO_File(lf,"r");
	
	if(fh=fail) then
		Info(InfoSimpcomp,1,"SCLoad: Error opening file '",lf,"' for reading.");
		return fail;
	fi;

	#unpickle
	c:=IO_Unpickle(fh);
	
	IO_Close(fh);

	if(c=IO_Error) then
		Info(InfoSimpcomp,1,"SCLoad: Error loading simplicial complex from file '",
      lf,"'.");
		return fail;
	else
		return c;
	fi;
	
end);


################################################################################
##<#GAPDoc Label="SCLoadXML">
## <ManSection>
## <Func Name="SCLoadXML" Arg="filename"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Loads a simplicial complex stored in XML format from a file specified in 
## <Arg>filename</Arg> (as string). If <Arg>filename</Arg> does not end in 
## <C>.sc</C>, this suffix is appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSaveXML(c,"/tmp/bddelta3");
## true
## gap> d:=SCLoadXML("/tmp/bddelta3");
## gap> c=d;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLoadXML,
	function(filename)

	local data,obj,lf;

	if(not IsString(filename)) then
		Info(InfoSimpcomp,1,"SCLoadXML: first argument must be of type String.");
		return fail;
	fi;
	
	lf:=ShallowCopy(filename);
	if(Length(filename)<3 or 
    filename{[Length(filename)-2..Length(filename)]}<>".sc") then
		Append(lf,".sc");
	fi;

	data:=StringFile(lf);
	if(data=fail or IsEmptyString(data)) then
		Info(InfoSimpcomp,1,"SCLoadXML: error reading file \"",lf,"\".");
		return fail;
	fi;

	obj:=SCIntFunc.SCXMLToObject(data);

	if(obj=fail or Length(obj)<1 or not SCIsSimplicialComplex(obj[1])) then
		Info(InfoSimpcomp,1,"SCLoadXML: error loading simplicial complex from file.");
		return fail;
	fi;

	return obj[1];
end);



################################################################################
##<#GAPDoc Label="SCSave">
## <ManSection>
## <Func Name="SCSave" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Saves a simplicial complex in a binary format (using <C>IO_Pickle</C>) to 
## a file specified in <Arg>filename</Arg> (as string). If <Arg>filename</Arg> 
## does not end in <C>.scb</C>, this suffix is appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSave(c,"/tmp/bddelta3");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSave,
	function(complex,filename)

	local fh,lf;

	if(not SCIsSimplicialComplex(complex) or not IsString(filename)) then
		Info(InfoSimpcomp,1,"SCSave: first argument must be of type ",
      "SCSimplicialComplex, second of type String.");
		return fail;
	fi;

	lf:=ShallowCopy(filename);
	if(Length(filename)>2 and 
    filename{[Length(filename)-2..Length(filename)]}=".sc") then
		Append(lf,"b");
	fi;

	if(Length(lf)<4 or lf{[Length(lf)-3..Length(lf)]}<>".scb") then
		Append(lf,".scb");
	fi;
	
	Info(InfoSimpcomp,3,"SCSave: Saving simplicial complex to file '",lf,"'.");	
	fh:=IO_File(lf,"w");
	
	if(fh=fail) then
		Info(InfoSimpcomp,1,"SCSave: Error opening file '",lf,"' for writing.");
		return fail;
	fi;

	#pickle
	if(IO_Pickle(fh,complex)<>IO_OK) then
		Info(InfoSimpcomp,1,"SCSave: Error saving simplicial complex to file '",
      lf,"'.");
		IO_Close(fh);
		return fail;
	else
		IO_Close(fh);
		return true;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCSaveXML">
## <ManSection>
## <Func Name="SCSaveXML" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Saves a simplicial complex <Arg>complex</Arg> to a file specified by 
## <Arg>filename</Arg> (as string) in XML format. If <Arg>filename</Arg> does 
## not end in <C>.sc</C>, this suffix is appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSaveXML(c,"/tmp/bddelta3");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCSaveXML,
	function(complex,filename)

	local buf,lf;
	
	if(not SCIsSimplicialComplex(complex) or not IsString(filename)) then
		Info(InfoSimpcomp,1,"SCSaveXML: first argument must be of type ",
      "SCSimplicialComplex, second of type String.");
		return fail;
	fi;
	
	lf:=ShallowCopy(filename);

	if(Length(filename)>3 and 
    filename{[Length(filename)-3..Length(filename)]}=".scb") then
		lf:=lf{[1..Length(lf)-1]};
	fi;

	if(Length(lf)<3 or lf{[Length(lf)-2..Length(lf)]}<>".sc") then
		Append(lf,".sc");
	fi;

	Info(InfoSimpcomp,3,"SCSaveXML: saving simplicial complex to file '",lf,"'.");	

	buf:=Concatenation("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
	SCIntFunc.SCObjectToXML(complex,"SimplicialComplexV2",0));

	if(FileString(lf,buf)=fail) then
		Info(InfoSimpcomp,1,"SCSaveXML: file \"",filename,"\" not writeable!");
		return fail;
	else
		return true;
	fi;
end);


SCIntFunc.SCGetSimplicialComplexAttributesXMLEx:=
function(sc,attrs)
	local buf,pname,prop,ptype;

	if(Length(attrs)>0 and not ForAll(attrs,IsString)) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCGetSimplicialComplexAttributesXMLEx: ",
      "invalid attribute list.");
		return fail;
	fi;

	buf:="";

	for pname in Intersection(SCPropertiesNames(sc),attrs) do
		prop:=SCPropertyByName(sc,pname);
		Append(buf,SCIntFunc.SCObjectToXML(prop,pname,1));
	od;

	return buf;
end;


SCIntFunc.SCGetSimplicialComplexAttributesXML:=
function(sc,attrs)
	local buf;

	buf:=SCIntFunc.SCGetSimplicialComplexAttributesXMLEx(sc,attrs);
	if(buf=fail) then return fail; fi;

	return Concatenation(["<SimplicialComplex>\n",buf,"</SimplicialComplex>\n\n"]);
end;

################################################################################
##<#GAPDoc Label="SCExportMacaulay2">
## <ManSection>
## <Func Name="SCExportMacaulay2" Arg="complex, ring,  filename [, alphalabels]"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list of a given simplicial complex <Arg>complex</Arg> in 
## <C>Macaulay2</C> format to a file specified by <Arg>filename</Arg>. The 
## argument <Arg>ring</Arg> can either be the ring of integers (specified by 
## <C>Integers</C>) or the ring of rationals (sepcified by <C>Rationals</C>). 
## The optional boolean argument <Arg>alphalabels</Arg> labels the complex 
## with characters from <M>a, \dots ,z</M> in the exported file if a value of 
## <K>true</K> is supplied, while the standard labeling of the vertices is 
## <M>v_1, \dots ,v_n</M> where <M>n</M> is the number of vertices of 
## <Arg>complex</Arg>. If <Arg>complex</Arg> has more than <M>26</M> 
## vertices, the argument <Arg>alphalabels</Arg> is ignored. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportMacaulay2(c,Integers,"/tmp/bdbeta4.m2");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportMacaulay2,
function(arg)
	local complex,filename,ring,alpha,buf,i,s,v,verts,lut,facets;

	if(Length(arg)<3 or Length(arg)>4 or not SCIsSimplicialComplex(arg[1]) or 
      (not IsIntegers(arg[2]) and not IsRationals(arg[2])) or 
      not IsStringRep(arg[3])) then
			Info(InfoSimpcomp,1,"SCExportMacaulay2: invalid arguments, first",
        "argument must be of type SCSimplicialComplex, seconds a ring ",
        "(Integers or Rationals), third a string.");
			return fail;
	fi;
	
	complex:=arg[1];
	ring:=arg[2];
	filename:=arg[3];
	
	if(SCIsEmpty(complex)) then
		Info(InfoSimpcomp,1,"SCExportMacaulay2: empty complex, duh.");
		return true;
	fi;
	
	if(Length(arg)=4 and IsBool(arg[4]) and arg[4]=true) then
		alpha:=true;
	else
		alpha:=false;
	fi;
	
	
	buf:=["-- simpcomp export of complex ",SCName(complex),
    "\n\nloadPackage \"SimplicialComplexes\";\n\nR = "];
	
	if(IsIntegers(ring)) then
		Add(buf,"ZZ[");
	else
		Add(buf,"QQ[");
	fi;
	
	verts:=Union(SCSkelEx(complex,0));

	#dump variables
	if(Length(verts)<27 and alpha) then
		lut:=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o",
      "p","q","r","s","t","u","v","w","x","y","z"];
		Add(buf,Concatenation("a..",lut[Length(verts)]));
	else
		lut:=[1..Length(verts)];
		for i in [1..Length(verts)] do
			Add(buf,Concatenation("v",String(i)));
			if(i<Length(verts)) then
				Add(buf,", ");
			fi;
		od;
	fi;
	Add(buf,"];\nFacets = {");
	
	facets:=SCFacetsEx(complex);
	for s in [1..Length(facets)] do
		for v in [1..Length(facets[s])] do
			if not alpha then
				Add(buf,Concatenation("v",String(lut[Position(verts,facets[s][v])])));
			else
				Add(buf,String(lut[Position(verts,facets[s][v])]));
			fi;
			
			if(v<Length(facets[s])) then
				Add(buf,"*");
			elif(s<Length(facets)) then
				Add(buf,", ");
			fi;
		od;
	od;
	Add(buf,"}\n");

	Add(buf,"complex = simplicialComplex Facets;\n\n-- end of export");

	if(FileString(filename,String(Concatenation(buf)))=fail) then
		Info(InfoSimpcomp,1,"SCExportMacaulay2: file \"",filename,
      "\" not writeable!");
		return fail;
	else
		return true;
	fi;

end);


################################################################################
##<#GAPDoc Label="SCExportPolymake">
## <ManSection>
## <Func Name="SCExportPolymake" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list with vertex labels of a given simplicial complex 
## <Arg>complex</Arg> in <C>polymake</C> format to a file specified by 
## <Arg>filename</Arg>. Currently, only the export in the format of 
## <C>polymake</C> version 2.3 is supported. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportPolymake(c,"/tmp/bdbeta4.poly");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportPolymake,
function(complex,filename)
	local buf,i,s,v,verts;

	buf:=["_application topaz\n_version 2.3\n_type SimplicialComplex\n\nFACETS\n"];

	verts:=SCVertices(complex);

	for s in SCFacetsEx(complex) do
		Add(buf,"{ ");
		for v in s do
			Append(buf,[String(Position(verts,v)-1)," "]);
		od;
		Add(buf,"}\n");
	od;

	#print vertex labels
	Add(buf,"\nVERTEX_LABELS\n");

	for i in [1..Length(verts)] do
		Add(buf,SCIntFunc.ListToDenseString(verts[i]));
		if(i<Length(verts)) then Add(buf," "); fi;
	od;
	Add(buf,"\n\n");

	if(FileString(filename,String(Concatenation(buf)))=fail) then
		Info(InfoSimpcomp,1,"SCExportPolymake: file \"",filename,"\" not ",
      "writeable!");
		return fail;
	else
		return true;
	fi;

end);


################################################################################
##<#GAPDoc Label="SCExportRecognizer">
## <ManSection>
## <Func Name="SCExportRecognizer" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the gluings of the tetrahedra of a given combinatorial 
## <M>3</M>-manifold <Arg>complex</Arg> in a format compatible with Matveev's 
## <M>3</M>-manifold software <C>Recognizer</C>.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportRecognizer(c,"/tmp/bdbeta4.mv");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportRecognizer,
function(complex,filename)
	local buf,i,dim,pm,facets,done,j,k,l,elm,trig,f3;

	dim := SCDim(complex);
	pm := SCIsPseudoManifold(complex);
	if dim <> 3 or pm <> true then
		Info(InfoSimpcomp,1,"SCExportRecognizer: input must be a 3-dimensional ",
      "weak pseudomanifold.");
		return fail;
	fi;

	buf:=["triangulation\n"];
	facets := SCFacetsEx(complex);
	if facets = fail then
		return fail;
	fi;
	f3 := Size(facets);
	done := List([1..f3],x->[false,false,false,false]);
	for i in [1..f3] do
		for j in [4,3,2,1] do
			if done[i][j] = true then continue; fi;
			elm := [1..4];
			Remove(elm,j);
			Append(buf,["t",String(i),"(",String(elm[1]),",",String(elm[2]),",",
        String(elm[3]),") - "]);
			trig := facets[i]{elm};
			for k in [i+1..f3] do
				if IsSubset(facets[k],trig) then
					elm := [Position(facets[k],trig[1]),Position(facets[k],trig[2]),
            Position(facets[k],trig[3])];
					Append(buf,["t",String(k),"(",String(elm[1]),",",String(elm[2]),",",
            String(elm[3]),"),\n"]);
					for l in [1..4] do
						if not l in elm then
							done[k][l] := true;
							break;
						fi;
					od;
					break;
				fi;
			od; 
		od;
	od;
	Add(buf,"end\n");
	if(FileString(filename,String(Concatenation(buf)))=fail) then
		Info(InfoSimpcomp,1,"SCExportRecognizer: file \"",filename,
      "\" not writeable!");
		return fail;
	else
		return true;
	fi;

end);

################################################################################
##<#GAPDoc Label="SCExportJavaView">
## <ManSection>
## <Func Name="SCExportJavaView" Arg="complex, file, coords"/>
## <Returns><K>true</K> on success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the 2-skeleton of the given simplicial complex <Arg>complex</Arg> 
## (or the facets if the complex is of dimension 2 or less) in <C>JavaView</C> 
## format (file name suffix <C>.jvx</C>) to a file specified by 
## <Arg>filename</Arg> (as string). The list <Arg>coords</Arg> must contain a 
## <M>3</M>-tuple of real coordinates for each vertex of <Arg>complex</Arg>, 
## either as tuple of length three containing the coordinates (Warning: 
## as &GAP; only has rudimentary support for floating point values, currently 
## only integer numbers can be used as coordinates when providing 
## <Arg>coords</Arg> as list of <M>3</M>-tuples) or as string of the form 
## <C>"x.x y.y z.z"</C> with decimal numbers <C>x.x</C>, <C>y.y</C>, 
## <C>z.z</C> for the three coordinates (i.e. <C>"1.0 0.0 0.0"</C>).
## <Example><![CDATA[
## gap> coords:=[[1,0,0],[0,1,0],[0,0,1]];;
## gap> SCExportJavaView(SCBdSimplex(2),"/tmp/triangle.jvx",coords);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportJavaView,
function(complex,filename,coords)
	local buf,v,f,verts,vertices,trigs,i,name,fl,dim;

	if(SCIsEmpty(complex)) then
		Info(InfoSimpcomp,1,"SCExportJavaView: empty complex, nothing to do.");
		return true;
	fi;

	buf:=[];
	dim:=SCDim(complex);
	if(dim=fail) then
		return fail;
	fi;
	
	if(dim<3) then
		trigs:=SCFacetsEx(complex);
	else
		trigs:=SCSkelEx(complex,2);
	fi;
	
	verts:=Union(SCSkelEx(complex,0));
	
	if(trigs=fail or verts=fail or Length(verts)<>Length(coords)) then
		if(Length(verts)<>Length(coords)) then
			Info(InfoSimpcomp,1,"SCExportJavaView: vertex count must match ",
        "coordinate count.");
		fi;
		return fail;
	fi;
	
	name:=SCPropertyByName(complex,"Name");
	
	if(name=fail) then
		name:="Unnamed simplcicial complex";
	fi;
	
	
	Append(buf,Concatenation("\
	<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n\
	<!DOCTYPE jvx-model SYSTEM \"http://www.javaview.de/rsrc/jvx.dtd\">\n\
	<jvx-model>\n\
		<meta generator=\"<Package>simpcomp</Package>\"/>\n\
		<meta dtd=\"1.11.001\"/>\n\
		<meta date=\"\"/>\n\
		<version type=\"dump\">1.0</version>\n\
		<title>",name,"</title>\n\
		<geometries>\n"));
	
	Append(buf,Concatenation("\
	<geometry name=\"",String(verts),"\">\n\
		<pointSet point=\"show\" dim=\"3\">\n\
			<points num=\"",String(Length(verts)),"\">\n"));
	
	vertices:=[];
	for v in [1..Length(verts)] do
		if(not IsString(coords[v])) then
			#coordinates as list
			vertices[v]:=Concatenation("<p name=\"",String(verts[v]),"\">");
			
			#convert to floating point
			for i in [1..3] do
			
				if(not IsInt(coords[v][i])) then
					Info(InfoSimpcomp,1,"SCExportJavaView: currently only integer ",
            "coordinates are supported when passed as list of coordinate ",
            "tuples. Use list of strings instead.");
					return fail;
				fi;
				
				fl:=ShallowCopy(String(coords[v][i]));
				
				if(PositionSublist(fl,".")=fail) then
					Append(fl,".0");
				fi;
				
				Append(vertices[v],fl);
				
				if(i<3) then
					Append(vertices[v]," ");
				fi;
			od;
			
			Append(vertices[v],"</p>");
		else
			#coordinates as string
			vertices[v]:=Concatenation("<p name=\"",String(verts[v]),"\">",
        coords[v],"</p>");
		fi;
		Append(buf,Concatenation("\t\t\t",vertices[v],"\n"));
	od;


	Append(buf,Concatenation("\
				<thickness>4.0</thickness>\n\
				<color type=\"rgb\">255 0 0</color>\n\
				<colorTag type=\"rgb\">255 0 255</colorTag>\n\
				<labelAtt font=\"text\" horAlign=\"head\" name=\"SansSerif\" verAlign=\"middle\" style=\"plain\" visible=\"show\">\n\
					<xOffset>0</xOffset>\n\
					<yOffset>0</yOffset>\n\
					<size>20</size>\n\
					<color type=\"rgb\">0 0 0</color>\n\
				</labelAtt>\n\
			</points>\n\
		</pointSet>\n\
		<faceSet color=\"show\" edge=\"show\" face=\"show\">\n\
			<faces num=\"",String(Length(trigs)),"\">\n"));

	for f in trigs do
		Append(buf,"\t\t\t<f>");
		for v in [1..Length(f)] do
			if(v>1) then Append(buf," "); fi;
			Append(buf,String(Position(verts,f[v])-1));
		od;
		Append(buf,"</f>\n");
	od;
		
	Append(buf,"\
				<color type=\"rgb\">0 255 0</color>\n\
				<colorTag type=\"rgb\">255 0 255</colorTag>\n\
				<creaseAngle>3.2</creaseAngle>\n\
			</faces>\n\
			<neighbours num=\"1\">\n\
				<nb>-1 -1 -1</nb>\n\
			</neighbours>\n\
			<edges>\n\
				<thickness>1.0</thickness>\n\
				<color type=\"rgb\">0 0 0</color>\n\
				<colorTag type=\"rgb\">255 0 255</colorTag>\n\
			</edges>\n\
			<colors num=\"1\" type=\"rgb\">\n\
				<c>119 236 158</c>\n\
			</colors>\n\
		</faceSet>\n\
		<center visible=\"hide\">\n\
			<p>0.0 0.0 0.0</p>\n\
		</center>\n\
		<material>\n\
			<ambientIntensity>0.2</ambientIntensity>\n\
			<diffuse>\n\
				<color type=\"rgb\">204 204 204</color>\n\
			</diffuse>\n\
			<emissive>\n\
				<color type=\"rgb\">0 0 0</color>\n\
			</emissive>\n\
			<shininess>10.0</shininess>\n\
			<specular>\n\
				<color type=\"rgb\">255 255 255</color>\n\
			</specular>\n\
			<transparency visible=\"show\">0.5</transparency>\n\
		</material>\n\
	</geometry>\n\
	</geometries>\n\
	</jvx-model>\n");
	
	if(FileString(filename,buf)=fail) then
		Info(InfoSimpcomp,1,"SCExportJavaView: filename \"",filename,
      "\" not writeable!");
		return fail;
	else
		return true;
	fi;
	
end);

################################################################################
##<#GAPDoc Label="SCExportLatexTable">
## <ManSection>
## <Func Name="SCExportLatexTable" Arg="complex, filename, itemsperline"/>
## <Returns><K>true</K> on success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list of a given simplicial complex <Arg>complex</Arg> 
## (or any list given as first argument) in form of a &LaTeX; table to a file 
## specified by <Arg>filename</Arg>. The argument <Arg>itemsperline</Arg> 
## specifies how many columns the exported table should have. The faces are 
## exported in the format <M>\langle v_1,\dots,v_k \rangle</M>.  
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCExportLatexTable(c,"/tmp/bd5simplex.tex",5);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportLatexTable,
function(complex,filename,itemsperline)
	local i,j,buf,facets;

	if(not SCIsSimplicialComplex(complex) and not IsList(complex)) then
		Info(InfoSimpcomp,1,"SCExportLatexTable: first argument must be of type ",
      "SCSimplicialComplex or a list of faces.");
		return fail;
	fi;
		
	if(SCIsSimplicialComplex(complex)) then
		facets:=SCFacets(complex);
	else
		facets:=complex;
	fi;

	if(facets=fail) then
		return fail;
	fi;

	buf:=Concatenation(["\\begin{tabular}{",
    Concatenation(ListWithIdenticalEntries(itemsperline,"l")),"}\n"]);

	for i in [1..Length(facets)] do
		Append(buf,"$\\langle ");

		for j in [1..Length(facets[i])-1] do
			Append(buf,
        Concatenation([SCIntFunc.ListToDenseString(facets[i][j]),"\\,"]));
		od;
		Append(buf,SCIntFunc.ListToDenseString(facets[i][Length(facets[i])]));


		Append(buf," \\rangle$");

		if(i=Length(facets)) then
			Append(buf,".");
			Append(buf,
        Concatenation(ListWithIdenticalEntries(-(i mod itemsperline) mod itemsperline,"&")));
			Append(buf,"\n");
			break;
		fi;

		if(i mod itemsperline=0) then
			Append(buf,",\\\\\n\n");
		else
			Append(buf,", &\n");
		fi;
	od;

	Append(buf,"\\end{tabular}");
	buf:=ReplacedString(buf,"\"","");

	if(FileString(filename,buf)=fail) then
		Info(InfoSimpcomp,1,"SCExportLatexTable: file \"",filename,
      "\" not writeable!");
		return fail;
	fi;

	return true;
end);



################################################################################
##<#GAPDoc Label="SCImportPolymake">
## <ManSection>
## <Func Name="SCImportPolymake" Arg="filename"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Imports the facet list of a <C>topaz</C> <C>polymake</C> file specified by 
## <Arg>filename</Arg> (discarding any vertex labels) and creates a 
## simplicial complex object from these facets.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportPolymake(c,"/tmp/bdbeta4.poly");
## gap> d:=SCImportPolymake("/tmp/bdbeta4.poly");
## gap> c=d;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCImportPolymake,
function(filename)
	local file,lines,fpos,lidx,v,verts,s,facets,sc;
	
	file:=StringFile(filename);
	
	if(file=fail) then
		Info(InfoSimpcomp,1,"SCImportPolymake: error reading file \"",
      filename,"\".");
		return fail;
	fi;
	
	
	lines:=SplitString(file,"\n");
	Apply(lines,NormalizedWhitespace);
	
	fpos:=Position(lines,"VERTICES_IN_FACETS");
	if(fpos=fail) then
		fpos:=Position(lines,"FACETS");
	fi;
	
	
	if(fpos=fail) then
		Info(InfoSimpcomp,1,"SCImportPolymake: could neither find section ",
      "VERTICES_IN_FACETS nor section FACETS in polymake file.");
		return fail;
	fi;
	
	facets:=[];
	for lidx in [fpos+1..Length(lines)] do
		if(not IsBound(lines[lidx]) or IsEmptyString(lines[lidx]) or 
      lines[lidx]=" ") then
			break;
		fi;
		verts:=SplitString(lines[lidx]," ","{}");
		s:=[];
		for v in verts do
			if(IsEmpty(v)) then continue; fi;
			Add(s,Rat(v));
		od;
		Add(facets,s+1);
	od;
	
	sc:=SCFromFacets(facets);
	
	if(sc<>fail) then
		SCRename(sc,Concatenation("polymake import '",filename,"'"));
	fi;
	
	return sc; 
end);



#general io pickling function
SCIntFunc.GeneralPicklerIgnoreList:=[
"ComputedSCHomalgBoundaryMatricess", "ComputedSCHomalgCoboundaryMatricess", 
  "ComputedSCHomalgHomologys", "ComputedSCHomalgCohomologys" 
];
SCIntFunc.GeneralPickler:=
function(f,c,id)
	local p;
	
	# write SCSimplicialComplex tag
	IO_AddToPickled(c);
	if IO_Write(f,id) = fail then 
		IO_FinalizePickled();
		return IO_Error;
	fi;
	
	# write number of attributes
	if IO_WriteSmallInt(f,Length(KnownAttributesOfObject(c))) = IO_Error then
		IO_FinalizePickled();
		return IO_Error;
	fi;        
	
	# pickle all attributes
	for p in KnownAttributesOfObject(c) do
		if(p in SCIntFunc.GeneralPicklerIgnoreList) then
			Info(InfoSimpcomp,3,"SCIntFunc.GeneralPickler: ignoring attribute ",p,
        " as it is in ignore list (no pickler available).");
			continue;
		fi;
	
		# write attribute name
		if(IO_Pickle(f,p)<>IO_OK) then
			IO_FinalizePickled();
			return IO_Error;
		fi;

		# write attribute value
		if(IO_Pickle(f,c!.(p))<>IO_OK) then
			IO_FinalizePickled();
			return IO_Error;
		fi;
	od;

	IO_FinalizePickled();
	return IO_OK;
end;
	
#general io unpickling function
SCIntFunc.GeneralUnpickler:=
function(f,c)
    local i,len,name,ob;

    # read number of attributes
    len:=IO_ReadSmallInt(f);
    if len = IO_Error then
        Info(InfoSimpcomp,1,"SCIntFunc.GeneralUnpickler: Error during ",
          "unpicking of attribute name");
        return c;
    fi;

    # do unpickling
    IO_AddToUnpickled(c);
    for i in [1..len] do
        # read attribute name
    	name:=IO_Unpickle(f);
        if name = IO_Error or not(IsString(name)) then
            Info(InfoSimpcomp,1,"SCIntFunc.GeneralUnpickler: Error while ",
                "unpicking attribute name");
        fi;
        
        # read attribute value
        ob:=IO_Unpickle(f);
        if IO_Result(ob) then
            if ob = IO_Error then
                Info(InfoSimpcomp,1,"SCIntFunc.GeneralUnpickler: Error while ",
                  "unpicking attribute value of '",name,"'");
            fi;
        else
	    Setter(EvalString(name))(c,ob);
        fi;
    od;
    IO_FinalizeUnpickled();
end;


#pickler for SCSimplicialComplex
InstallMethod(IO_Pickle, "for SCSimplicialComplex",
[ IsFile, SCIsSimplicialComplex ],
function(f,c)
	return SCIntFunc.GeneralPickler(f,c,"SCSC");
end);


# unpickler for SCSimplicialComplex
IO_Unpicklers.SCSC:=
function(f)
    local c;
    
    # SCSimplicialComplex
    c:=SCIntFunc.SCNew();

    SCIntFunc.GeneralUnpickler(f,c);
    return c;
end;

# pickler for SCLibraryRepository
InstallMethod(IO_Pickle, "for SCLibRepository",
[ IsFile, SCIsLibRepository ],
function(f,lr)
	IO_AddToPickled(lr);

	# write SCLibRepository tag
	if IO_Write(f,"SCLR") = fail then 
		IO_FinalizePickled();
		return IO_Error;
	fi;
	
	if(IO_Pickle(f,lr!.Properties)<>IO_OK) then
		IO_FinalizePickled();
		return IO_Error;
	fi;
	
	IO_FinalizePickled();
	return IO_OK;
end);


# unpickler for SCLibraryRepository
IO_Unpicklers.SCLR:=
function(f)
    local prop;
	
    #get library properties    
    prop:=IO_Unpickle(f);
    
    if IO_Result(prop) then
    	if prop = IO_Error then
    		Info(InfoSimpcomp,1,"IO_Unpicklers.SCLR: Error while unpicking ",
          "library repository. Delete file complexes.idx and complexes.idxb ",
          "and recreate them with SCLibInit.");
    		return IO_Error;
    	fi;
    else
    	return SCIntFunc.LibRepositoryEmptyWithAttributes(prop);
    fi;
end;

#handler functions for file load/save operations
SCIntFunc.SCXMLIOHandlers:=
rec(
	SCSimplicialComplex:=[SCIsSimplicialComplex,
    SCIntFunc.SCSimplicialComplexToXML,SCIntFunc.SCSimplicialComplexFromXMLv1,
    false],
	SCSimplicialComplexV2:=[SCIsSimplicialComplex,
    SCIntFunc.SCSimplicialComplexToXML,SCIntFunc.SCSimplicialComplexFromXMLv2,
    false],
	SCLibraryRepository:=[SCIsLibRepository,SCIntFunc.SCLibraryRepositoryToXML,
    SCIntFunc.SCLibraryRepositoryFromXML,false],
	SCRecord:=[IsRecord,SCIntFunc.RecordToXML,SCIntFunc.RecordFromXML,false],
	SCPositionalObject:=[SCIsPositionalObject,SCIntFunc.PositionalObjectToXML,
    SCIntFunc.PositionalObjectFromXML,false],
	SCInteger:=[IsInt,String,SCIntFunc.ReadInteger,true],
	SCBoolean:=[IsBool,SCIntFunc.BooleanToString,SCIntFunc.ReadBoolean,true],
	SCString:=[IsStringRep,String,SCIntFunc.ReadString,true],
	SCArray:=[IsList,SCIntFunc.ListToDenseString,SCIntFunc.ReadArray,true],
	SCPerm:=[IsPerm,SCIntFunc.PermToString,SCIntFunc.ReadPerm,true],
	SCPermGroup:=[IsPermGroup,SCIntFunc.PermGroupToString,SCIntFunc.ReadPermGroup,
    true],
	SCFpGroup:=[IsFpGroup,SCIntFunc.FpGroupToXML,SCIntFunc.FpGroupFromXML,false]
);


################################################################################

################################################################################
##<#GAPDoc Label="SCExportSnapPy">
## <ManSection>
## <Func Name="SCExportSnapPy" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list and orientability of a given combinatorial 
## <M>3</M>-pseudomanifold <Arg>complex</Arg> in <C>SnapPy</C> format to a 
## file specified by <Arg>filename</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("Dim=3 and F=[8,28,56,28]");
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCExportSnapPy(c,"/tmp/M38.tri");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCExportSnapPy,
function(complex,filename)
	local curvertex,buf,dim,name,orient,lks,i,pmflag,lksconn,kleinb,torus,
    sphere,lktype,neighbors,gluings,cusps,j,k,trig,remoteidx,verts,facets;

	dim:=SCDim(complex);
	if dim=fail then
		return fail;
	fi;

	if dim<>3 then
		Info(InfoSimpcomp,1,"SCExportSnapPy: argument must be a 3-dimensional ",
      "simplicial complex.");
		return fail;
	fi;

	kleinb:=0;
	torus:=0;
	sphere:=0;

	if SCIsManifold(complex) then
		sphere:=SCNumFaces(complex,0);
		lktype:=ListWithIdenticalEntries(sphere,0);
	fi;

	if sphere=0 then

		lks:=SCLinks(complex,0);
		pmflag:=true;
		for i in [1..Size(lks)] do 
			if not SCIsManifold(lks[i]) then
				pmflag:=false;
				break;
			fi;
		od;
	
		if pmflag<>true then
			Info(InfoSimpcomp,1,"SCExportSnapPy: argument must be a combinatorial ",
        "3-pseudomanifold.");
			return fail;
		fi;

		lksconn:=true;
		for i in [1..Size(lks)] do 
			if not SCIsConnected(lks[i]) then
				lksconn:=false;
				break;
			fi;
		od;

		if lksconn<>true then
			Info(InfoSimpcomp,1,"SCExportSnapPy: argument must be a combinatorial ",
        "3-pseudomanifold with connected links.");
			return fail;
		fi;

		lktype:=[];
		for i in [1..Size(lks)] do
			if SCEulerCharacteristic(lks[i])=2 then
				lktype[i]:=0;
				sphere:=sphere+1;
			elif SCEulerCharacteristic(lks[i])=0 then
				if SCIsOrientable(lks[i]) then
					lktype[i]:=1;
					torus:=torus+1;
				else
					lktype[i]:=2;
					kleinb:=kleinb+1;
				fi;
			else
				Info(InfoSimpcomp,1,"SCExportSnapPy: argument must be a combinatorial ",
          "3-pseudomanifold with links of type S^2, T^2 or K^2.");
				return fail;
			fi;
		od;

	fi;

	name:=SCName(complex);
	if name=fail then
		return fail;
	fi;

	buf:=["% Triangulation\n"];
	Append(buf,[name,"\nunknown 0.0\n"]);

	orient:=SCIsOrientable(complex);
	if orient=fail then
		return fail;
	fi;

	if orient=true then
		Append(buf,["oriented_manifold\nCS_unknown\n\n"]);
	else
		Append(buf,["nonorientable_manifold\nCS_unknown\n\n"]);
	fi;

	verts:=SCVertices(complex);

	Append(buf,[String(torus)," ",String(kleinb),"\n"]);
	for i in [1..SCNumFaces(complex,0)] do
		if lktype[i]=0 then
			#Append(buf,["        internal   0 0\n"]);
			continue;
		elif lktype[i]=1 then
			Append(buf,["        torus   0 0\n"]);
		elif lktype[i]=2 then
			Append(buf,["        Klein bottle   0 0\n"]);
		fi;
	od;

	neighbors:=[];
	gluings:=[];
	cusps:=[];
	facets:=SCFacets(complex);
	if facets=fail then
		return fail;
	fi;
	for j in [1..Size(facets)] do
		neighbors[j]:=[];
		gluings[j]:=[];
		cusps[j]:=[];
		for trig in Combinations(facets[j],3) do
			curvertex:=Difference(facets[j],trig)[1];
			k:=Position(facets[j],curvertex);
			for i in [1..Size(facets)] do
				if facets[i] = facets[j] then continue; fi;
				if IsSubset(facets[i],trig) then
					remoteidx:=Position(facets[i],Difference(facets[i],trig)[1]);
					neighbors[j][k]:=i-1;	
					gluings[j][k]:=[];
					gluings[j][k][k]:=remoteidx-1;				
					gluings[j][k][Position(facets[j],trig[1])]:=
            Position(facets[i],trig[1])-1;
					gluings[j][k][Position(facets[j],trig[2])]:=
            Position(facets[i],trig[2])-1;
					gluings[j][k][Position(facets[j],trig[3])]:=
            Position(facets[i],trig[3])-1;
					cusps[j][k]:=curvertex-1;
					break;
				fi;
			od;
		od;
	od;

	Append(buf,["\n",String(SCNumFaces(complex,dim)),"\n"]);
	for i in [1..Size(facets)] do
		Append(buf,["    ",String(neighbors[i][1]),"    ",
      String(neighbors[i][2]),"    ",String(neighbors[i][3]),"    ",
      String(neighbors[i][4]),"\n"]);
		Append(buf,["    ",String(gluings[i][1][1]),String(gluings[i][1][2]),
      String(gluings[i][1][3]),String(gluings[i][1][4])," ",
      String(gluings[i][2][1]),String(gluings[i][2][2]),
      String(gluings[i][2][3]),String(gluings[i][2][4])," ",
      String(gluings[i][3][1]),String(gluings[i][3][2]),
      String(gluings[i][3][3]),String(gluings[i][3][4])," ",
      String(gluings[i][4][1]),String(gluings[i][4][2]),
      String(gluings[i][4][3]),String(gluings[i][4][4]),"\n"]);
		Append(buf,["    ",String(cusps[i][1]),"    ",String(cusps[i][2]),"    ",
      String(cusps[i][3]),"    ",String(cusps[i][4]),"\n"]);
		Append(buf,["    0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0\n"]);
		Append(buf,["    0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0\n"]);
		Append(buf,["    0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0\n"]);
		Append(buf,["    0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0\n"]);
		Append(buf,["    0  0\n\n"]);
	od;

	if(FileString(filename,String(Concatenation(buf)))=fail) then
		Info(InfoSimpcomp,1,"SCExportSnapPy: file \"",filename,"\" not writeable!");
		return fail;
	else
		return true;
	fi;

end);
