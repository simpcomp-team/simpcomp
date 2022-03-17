################################################################################
##
##  simpcomp / tools.gi
##
##  Miscellaneous functions   
##
##  $Id$
##
################################################################################

SCSettings.SCMailAddress:="";
SCSettings.SCMailEnabled:=false;
SCSettings.SCMailMinInterval:=3600; # 1h
SCSettings.SCMailPendingMsg:="";
SCSettings.SCMailTimeLastMsg:=-1;
SCSettings.SCTimer:=-1;


SCIntFunc.GetProgramOutput:=
function(program,params)
	local syspath,prog,out,tmp;
	syspath:=DirectoriesSystemPrograms();
	
	if(syspath=fail) then
		Info(InfoWarning,1,"simpcomp: could not determine system programs path.");
		return fail;
	fi;
	
	prog:=Filename(syspath,program);

	if(prog=fail) then
		Info(InfoWarning,1,"simpcomp: could not call external process \"",program,"\".");
		return fail;
	fi;
	
	out:="";
	tmp:=OutputTextString(out,true);
	Process(DirectoryCurrent(),prog,InputTextNone(),tmp,params);
	CloseStream(tmp);
	
	return out;
end;


SCIntFunc.ArrayLineString:=
function(list)
	local i,out;

	out:="";
	for i in [1..Length(list)] do
		if(not IsBound(list[i])) then
			continue;
		fi;
		Append(out,String(list[i]));
		Append(out,"\n");
	od;
	return out;
end;



SCIntFunc.GetCurrentTimeString:=
function()
	local time,timestring;
	time:=DMYhmsSeconds(IO_gettimeofday().tv_sec);
	if time = fail then
		Info(InfoWarning,1,"simpcomp: could not determine system time.");
		return fail;
	fi;
	if time[1] < 10 then
		time[1] := Concatenation("0",String(time[1]));
	else
		time[1] := String(time[1]);
	fi;
	if time[2] < 10 then
		time[2] := Concatenation("0",String(time[2]));
	else
		time[2] := String(time[2]);
	fi;
	if time[4] < 10 then
		time[4] := Concatenation("0",String(time[4]));
	else
		time[4] := String(time[4]);
	fi;
	if time[5] < 10 then
		time[5] := Concatenation("0",String(time[5]));
	else
		time[5] := String(time[5]);
	fi;
	if time[6] < 10 then
		time[6] := Concatenation("0",String(time[6]));
	else
		time[6] := String(time[6]);
	fi;
	timestring:=Concatenation(String(time[3]),"-",time[2],"-",time[1],"_",time[4],"-",time[5],"-",time[6]);
	if timestring = fail then
		Info(InfoWarning,1,"simpcomp: could not determine system time.");
		return fail;
	fi;
	return timestring;
end;

SCIntFunc.SanitizeFilename:=
function(fname)
	local san,i,legalspecialchars;

	legalspecialchars:="_-+=,.#()[]!/";
	san:=[];
	for i in [1..Length(fname)] do
		if(not IsAlphaChar(fname[i]) and not IsDigitChar(fname[i]) and not fname[i] in legalspecialchars) then
			continue;
		else
			Add(san,fname[i]);
		fi;
	od;

	return san;
end;

SCIntFunc.GetHostname:=
function()
	local hostname;
	hostname:=IO_gethostname();
	if hostname = fail then
		return "unknown";
	else
		return hostname;
	fi;
end;

SCIntFunc.GetCurrentTimeInt:=
function()
	local out;
	out:=IO_gettimeofday().tv_sec;
	if(out=fail) then
		Info(InfoWarning,1,"simpcomp: could not determine system time.");
		return fail;
	else
		return out;
	fi;
end;

SCIntFunc.ConvertTimespanToString:=
function(t1,t2)
	local i,div,span,str,tmp,conv,convstr;

	if(t2<t1) then
		return fail;
	fi;

	str:="";
	span:=t2-t1;

	conv:=[1,60,60,24];
	convstr:=["second","minute","hour","day"];

	for i in Reversed([1..Length(conv)]) do
		div:=Product(conv{[1..i]});
		if(span>=div or div=1) then
			tmp:=Int(span/div);
			if(not IsEmptyString(str)) then
				Append(str,", ");
			fi;
			Append(str,Concatenation([String(tmp)," ",convstr[i]]));
			if(tmp<>1) then Append(str,"s"); fi;
			span:=span mod div;
		fi;
	od;

	return str;
end;

################################################################################
##<#GAPDoc Label="SCMailSetMinInterval">
## <ManSection>
## <Func Name="SCMailSetMinInterval" Arg="interval"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Sets the minimal time interval in seconds that mail messages can be sent by <Package>simpcomp</Package>. This prevents a flooding of the specified email address with messages sent by <Package>simpcomp</Package>. Default is 3600, i.e. one hour. 
## <Example><![CDATA[
## gap> SCMailSetMinInterval(7200);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailSetMinInterval,
function(interval)
	if(interval<0) then
		return fail;
	fi;

	SCSettings.SCMailMinInterval:=interval;
	return true;
end);


################################################################################
##<#GAPDoc Label="SCMailSetAddress">
## <ManSection>
## <Func Name="SCMailSetAddress" Arg="address"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Sets the email address that should be used to send notification messages and enables the mail notification system by calling <Ref Func="SCMailSetEnabled" />(<K>true</K>).
## <Example><![CDATA[
## gap> SCMailSetAddress("johndoe@somehost");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailSetAddress,
function(address)
	if(IsEmptyString(address)) then
		return fail;
	fi;

	SCSettings.SCMailAddress:=address;
	return SCMailSetEnabled(true);
end);

################################################################################
##<#GAPDoc Label="SCMailSetEnabled">
## <ManSection>
## <Func Name="SCMailSetEnabled" Arg="flag"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Enables or disables the mail notification system of <Package>simpcomp</Package>. By default it is disabled. Returns <K>fail</K> if no email message was previously set with <Ref Func="SCMailSetAddress" />.
## <Example><![CDATA[
## gap> SCMailSetAddress("johndoe@somehost"); #enables mail notification
## true
## gap> SCMailSetEnabled(false);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailSetEnabled,
function(flag)
	if(not "mail" in SCIntFunc.ExternalProgramsAvailable or IsEmptyString(SCSettings.SCMailAddress)) then
		return fail;
	fi;

	SCMailClearPending();

	if(flag=true) then
		SCSettings.SCMailTimeLastMsg:=-1;
	fi;

	SCSettings.SCMailEnabled:=flag;
	return true;
end);


################################################################################
##<#GAPDoc Label="SCMailSend">
## <ManSection>
## <Func Name="SCMailSend" Arg="message [,starttime] [,forcesend]"/>
## <Returns><K>true</K> when the message was sent, <K>false</K> if it was not send, <K>fail</K> upon an error.</Returns>
## <Description>
## Tries to send an email to the address specified by <Ref Func="SCMailSetAddress" /> using the Unix program <C>mail</C>. The optional parameter <Arg>starttime</Arg> specifies the starting time (as the integer Unix timestamp) a calculation was started (then the duration of the calculation is included in the email), the optional boolean parameter <Arg>forcesend</Arg> can be used to force the sending of an email, even if this violates the minimal email sending interval, see <Ref Func="SCMailSetMinInterval" />.
## <Example><![CDATA[
## gap> SCMailSetAddress("johndoe@somehost"); #enables mail notification
## true
## gap> SCMailIsEnabled();
## true
## gap> SCMailSend("Hello, this is simpcomp.");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailSend,
function(arg)
	local message,recipient,starttime,curtime,path,mail,instream,outstream,host,fullinfo,ret,runtime,forcewrite;

	if(Length(arg)<1 or (Length(arg)>0 and not IsString(arg[1])) or (Length(arg)>1 and not IsInt(arg[2]) and not IsBool(arg[2])) or (Length(arg)>2 and not (IsInt(arg[2]) or not IsBool(arg[3])))) then
		Info(InfoSimpcomp,1,"SCMailSend: invalid parameters.");
		return fail;
	fi;

	message:=arg[1];

	forcewrite:=false;
	starttime:=fail;
	if(Length(arg)>1) then
		if(IsInt(arg[2])) then
			starttime:=arg[2];
		else
			forcewrite:=arg[2];
		fi;
	fi;
	curtime:=fail;

	if(Length(arg)>2) then
		forcewrite:=arg[3];
	fi;

	if(not SCSettings.SCMailEnabled or IsEmptyString(SCSettings.SCMailAddress) or IsEmptyString(message)) then
		return false;
	fi;

	recipient:=SCSettings.SCMailAddress;
	path:=DirectoriesSystemPrograms();
	curtime:=SCIntFunc.GetCurrentTimeInt();
	mail:=Filename(path,"mail");
	if(mail=fail) then
		Info(InfoSimpcomp,1,"SCMail: sending mail failed.");
		return fail;
	fi;


	if(path=fail or curtime=fail) then
		Info(InfoSimpcomp,1,"SCMail: getting current time failed.");
		return fail;
	fi;


	if(Length(message)<2 or (message[Length(message)-1]<>'\n' or message[Length(message)]<>'\n')) then
		if(message[Length(message)]='\n') then
			message:=Concatenation(message,"\n");
		else
			message:=Concatenation(message,"\n\n");
		fi;
	fi;

	if(SCSettings.SCMailTimeLastMsg<>-1 and not SCSettings.SCMailMinInterval=0 and SCSettings.SCMailTimeLastMsg+SCSettings.SCMailMinInterval>curtime and not forcewrite) then
		SCSettings.SCMailPendingMsg:=message;
		return false;
	fi;


	host:=SCIntFunc.GetHostname();
	if host = fail then
		Info(InfoSimpcomp,1,"SCMail: getting hostname failed.");
		return fail;
	fi;
	fullinfo:=GAPInfo.Architecture;
	if fullinfo = fail then
		Info(InfoSimpcomp,1,"SCMail: getting system type failed.");
		return fail;
	fi;

	if(starttime<>fail and curtime<>fail) then
		runtime:=Concatenation([" for ",SCIntFunc.ConvertTimespanToString(starttime,curtime)]);
	else
		runtime:="";
	fi;


	outstream:=OutputTextNone();
	instream:=InputTextString(Concatenation(["\nGreetings,\n\nthis is simpcomp ",SCIntFunc.Version," running on ",host," (",fullinfo,"), GAP ",GAPInfo.Version,".\n\nI have been working hard",runtime," and have a message for you, see below.\n\n#### START MESSAGE ####\n\n",message,"##### END MESSAGE #####\n\nThat's all, I hope this is good news! Have a nice day.\n",String(CHAR_INT(4))]));;

	ret:=Process(path[1],mail,instream,outstream,["-s",Concatenation(["Message from simpcomp ",SCIntFunc.Version," running on ",host]),recipient]);

	if(ret<>0) then
		SCSettings.SCMailPendingMsg:=message;
	else
		SCSettings.SCMailPendingMsg:="";
		SCSettings.SCMailTimeLastMsg:=curtime;
	fi;

	return ret=0;
end);

################################################################################
##<#GAPDoc Label="SCMailSendPending">
## <ManSection>
## <Func Name="SCMailSendPending" Arg=""/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Tries to send a pending email of the <Package>simpcomp</Package> email notification system. Returns <K>true</K> on success or if there was no mail pending.
## <Example><![CDATA[
## gap> SCMailSendPending();
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailSendPending,
function()
	local ret;

	if(SCSettings.SCMailEnabled=false) then
		return false;
	fi;

	if(IsEmptyString(SCSettings.SCMailPendingMsg)) then
		return true;
	fi;

	return SCMailSend(SCSettings.SCMailPendingMsg);
end);


################################################################################
##<#GAPDoc Label="SCMailIsPending">
## <ManSection>
## <Func Name="SCMailIsPending" Arg=""/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> when an email of the <Package>simpcomp</Package> email notification system is pending, <K>false</K> otherwise.
## <Example><![CDATA[
## gap> SCMailIsPending();
## false
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailIsPending,
function()
	return not IsEmptyString(SCSettings.SCMailPendingMsg);
end);


################################################################################
##<#GAPDoc Label="SCMailIsEnabled">
## <ManSection>
## <Func Name="SCMailIsEnabled" Arg=""/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> when the mail notification system of <Package>simpcomp</Package> is enabled, <K>false</K> otherwise. Default setting is <K>false</K>.
## <Example><![CDATA[
## gap> SCMailSetAddress("johndoe@somehost"); #enables mail notification
## true
## gap> SCMailIsEnabled();
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailIsEnabled,
function()
	return SCSettings.SCMailEnabled;
end);



################################################################################
##<#GAPDoc Label="SCMailClearPending">
## <ManSection>
## <Func Name="SCMailClearPending" Arg=""/>
## <Returns>nothing.</Returns>
## <Description>
## Clears a pending mail message.
## <Example><![CDATA[
## gap> SCMailClearPending();
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMailClearPending,
function()
	SCSettings.SCMailPendingMsg:="";
end);



SCIntFunc.TimerStart:=
function()
	local t;
	t:=SCIntFunc.GetCurrentTimeInt();
	if(t=fail) then
		return fail;
	fi;
	SCSettings.SCTimer:=t;
	return t;
end;

SCIntFunc.TimerStop:=
function()
	SCSettings.SCTimer:=-1;
end;


SCIntFunc.TimerElapsed:=
function()
	local t,test;

	if(SCSettings.SCTimer=-1) then
		return fail;
	fi;

	t:=SCIntFunc.GetCurrentTimeInt();

	if(t=fail) then
		return fail;
	fi;

	return t-SCSettings.SCTimer;
end;


#reread the package
SCReread:=
function()
	Print("rereading init.g ",RereadPackage("simpcomp","init.g"),"\n");
	Print("rereading read.g ",RereadPackage("simpcomp","read.g"),"\n");
end;


#function availability test
SCIntFunc.CheckExternalProgramsAvailability:=
function()
	local path,programs,p;
	
	path:=DirectoriesSystemPrograms();
	programs:=["date","hostname","uname","mail"];

	SCIntFunc.ExternalProgramsAvailable:=[];
	
	if(IsBound(GAPInfo.UserHome) and GAPInfo.UserHome<>fail and IsString(GAPInfo.UserHome) and not IsEmpty(GAPInfo.UserHome)) then
		SCIntFunc.UserHome:=GAPInfo.UserHome;
	else
		SCIntFunc.UserHome:="";
	fi;
	
	if(path=fail) then
		return fail;
	fi;

	for p in programs do 
		if Filename(path,p)<>fail then
			Add(SCIntFunc.ExternalProgramsAvailable,p);
		fi;
	od;
end;


################################################################################
##<#GAPDoc Label="SCRunTest">
## <ManSection>
## <Func Name="SCRunTest" Arg=""/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Test whether the package <Package>simpcomp</Package> is functional by calling <C>Test("GAPROOT/pkg/simpcomp/tst/simpcomp.tst",rec(compareFunction := "uptowhitespace"));</C>. The returned value of GAP4stones is a measure of your system performance and differs from system to system.
## <Example><![CDATA[
## gap> SCRunTest();
## + test simpcomp package, version 0.0.0
## + GAP4stones: 69988
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCRunTest,
function()
	local path;
  path:=DirectoriesPackageLibrary("simpcomp", "tst");
  return Test(Filename(path,"simpcomp.tst"), rec( compareFunction := "uptowhitespace" ));
end);

