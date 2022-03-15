################################################################################
##
##  simpcomp / tools.gi
##
##  Miscellaneous functions   
##
##  $Id$
##
################################################################################
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
	instream:=InputTextString(Concatenation(["\nGreetings master,\n\nthis is simpcomp ",SCIntFunc.Version," running on ",host," (",fullinfo,"), GAP ",GAPInfo.Version,".\n\nI have been working hard",runtime," and have a message for you, see below.\n\n#### START MESSAGE ####\n\n",message,"##### END MESSAGE #####\n\nThat's all, I hope this is good news! Have a nice day.\n",String(CHAR_INT(4))]));;
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
################################################################################
##<#GAPDoc Label="SCMailClearPending">
## <ManSection>
## <Func Name="SCMailClearPending" Arg=""/>
## <Returns>nothing.</Returns>
## <Description>
## Clears a pending mail message.
## <Example><![CDATA[
## gap> SCMailClearPending();
## 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCRunTest">
## <ManSection>
## <Func Name="SCRunTest" Arg=""/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Test whether the package <Package>simpcomp</Package> is functional by calling <C>Test("GAPROOT/pkg/simpcomp/tst/simpcomp.tst",rec(compareFunction := "uptowhitespace"));</C>. The returned value of GAP4stones is a measure of your system performance and differs from system to system.
## <Example><![CDATA[
## gap> SCRunTest();
## simpcomp package test
## msecs: 8850
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
