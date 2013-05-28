<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:ns2="http://www.w3.org/1999/xlink" xmlns:cal="xalan://java.util.GregorianCalendar"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <!--
        *******************************************************************
        *                                                                 *
        * VERSION:          1.01                                          *
        *                                                                 *
        * AUTHOR:           Winona Salesky                                *
        *                   wsalesky@gmail.com                            *
        *                                                                 *
        * REVISED          January 15, 2011 WS                            *
        *                  September 26, 2011 WS                          *
        *                  May 28, 2013 HA                                *
        * ADAPTED          Adapted for Rockefeller Archive Center         *  
        *                                                                 *
        * ABOUT:           This file has been created for use with        *
        *                  the Archivists' Toolkit  July 30 2008.         *
        *                  this file calls lookupLists.xsl, which         *
        *                  should be located in the same folder.          *
        *                                                                 *
        *******************************************************************
    -->
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
<!--    <xsl:include href="lookupListsPDF.xsl"/>-->
    <xsl:include href="reports/Resources/eadToPdf/lookupListsPDF.xsl"/>
    <!-- 9/19/11 WS for RA: Caculates current date -->   
    <xsl:variable name="tmp" select="cal:new()"/>
    <xsl:variable name="year" select="cal:get($tmp, 1)"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
   
    <!--The following two variables headerString and pageHeader establish the title of the finding aid and substring long titles for dsiplay in the header -->
    <xsl:variable name="headerString">
        <xsl:choose>
            <xsl:when test="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper">
                <xsl:choose>
                    <xsl:when test="starts-with(/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper,/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)">
                        <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="header"/>
                    </xsl:when>
                    <xsl:when test="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/@type = 'filing'">
                        <xsl:choose>
                            <xsl:when test="count(/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper) &gt; 1">
                                <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper[not(@type='filing')]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="header"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="header"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pageHeader">
        <xsl:value-of select="substring($headerString,1,100)"/>
        <xsl:if test="string-length(normalize-space($headerString)) &gt; 100">...</xsl:if>
    </xsl:variable>

    <xsl:template match="ead:ead">
        <!--fo:root establishes the page types and layouts contained in the PDF, the finding aid consists of 4 distinct 
            page types, the cover page, the table of contents, contents and the container list. To alter basic page apperence 
            such as margins fonts alter the following page-masters.-->
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="verdana, arial, sans-serif" font-size="11pt">
            <fo:layout-master-set>
                <!-- Page master for Cover Page -->
                <fo:simple-page-master master-name="cover-page" page-width="8.5in"
                    page-height="11in" margin-top="0.2in" margin-bottom="0.5in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-bottom="1in"/>
                    <fo:region-before extent="0.2in"/>
                    <fo:region-after extent="2in"/>
                </fo:simple-page-master>
                <!-- 8/11/11 WS: Page master for Overview for Rockefeller Archives -->
                <fo:simple-page-master master-name="overview" page-width="8.5in" page-height="11in"
                    margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-bottom="1in"/>
                    <fo:region-before extent=".75in"/>
                    <fo:region-after extent=".75in"/>
                </fo:simple-page-master>
                <!-- Page master for Table of Contents -->
                <fo:simple-page-master master-name="toc" page-width="8.5in" page-height="11in"
                    margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-bottom="1in"/>
                    <fo:region-before extent="0.75in"/>
                    <fo:region-after extent="0.2in"/>
                </fo:simple-page-master>
                <!-- Page master for Contents -->
                <fo:simple-page-master master-name="contents" page-width="8.5in" page-height="11in"
                    margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-bottom="1in"/>
                    <fo:region-before extent="0.75in"/>
                    <fo:region-after extent="0.2in"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <!-- The fo:page-sequence establishes headers, footers and the body of the page.-->
            <fo:page-sequence master-reference="cover-page">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center">
                        <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt"/>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <xsl:apply-templates select="ead:eadheader"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
            <!-- 8/11/11 WS: Added overview page for Rockefeller Archives -->
            <fo:page-sequence master-reference="overview">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block color="gray" text-align="center" margin-top=".25in">
                        <xsl:value-of select="$pageHeader"/>
                    </fo:block>
                </fo:static-content>
                <!-- 8/14/11 WS for RA: changed footer-->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block border-top-style="solid" border-top-color="#7E1416"
                        border-top-width=".04in" padding-top=".025in" margin-bottom="0in"
                        padding-after="0in" padding-bottom="0">
                        <fo:block color="gray" padding-top="0in" margin-top="-0.015in"
                            border-top-style="solid" border-top-color="#7E1416"
                            border-top-width=".015in">
                            <fo:table space-before="0.07in" table-layout="fixed" width="100%"
                                font-size="8pt" margin-top=".05in" padding-top="0in">
                                <fo:table-column column-width="2in"/>
                                <fo:table-column column-width="5in"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block text-align="left" margin-left=".025in">
                                                <xsl:text> Overview</xsl:text>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block text-align="right" margin-right="-.475in">
                                                <xsl:text> Page </xsl:text>
                                                <fo:page-number/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="ead:archdesc/ead:did"/>
                </fo:flow>
            </fo:page-sequence>
            <fo:page-sequence master-reference="toc">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block color="gray" text-align="center" margin-top=".25in">
                        <xsl:value-of select="$pageHeader"/>
                    </fo:block>
                </fo:static-content>
                <!-- 8/14/11 WS for RA: changed footer-->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block border-top-style="solid" border-top-color="#7E1416"
                        border-top-width=".04in" padding-top=".025in" margin-bottom="0in"
                        padding-after="0in" padding-bottom="0">
                        <fo:block color="gray" padding-top="0in" margin-top="-0.015in"
                            border-top-style="solid" border-top-color="#7E1416"
                            border-top-width=".015in">
                            <fo:table space-before="0.07in" table-layout="fixed" width="100%"
                                font-size="8pt" margin-top=".05in" padding-top="0in">
                                <fo:table-column column-width="2in"/>
                                <fo:table-column column-width="5in"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block text-align="left" margin-left=".025in">
                                                <xsl:text> Table of Contents</xsl:text>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block text-align="right" margin-right="-.475in">
                                                <xsl:text> Page </xsl:text>
                                                <fo:page-number/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="toc"/>
                </fo:flow>
            </fo:page-sequence>
            <fo:page-sequence master-reference="contents">
                <fo:static-content flow-name="xsl-region-before" margin-top=".25in">
                    <fo:block color="gray" text-align="center">
                        <xsl:value-of select="$pageHeader"/>
                    </fo:block>
                </fo:static-content>
                <!-- 8/14/11 WS for RA: changed footer-->
                <!-- NOTE: get parent -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block border-top-style="solid" border-top-color="#7E1416"
                        border-top-width=".04in" padding-top=".025in" margin-bottom="0in"
                        padding-after="0in" padding-bottom="0">
                        <fo:block color="gray" padding-top="0in" margin-top="-0.015in"
                            border-top-style="solid" border-top-color="#7E1416"
                            border-top-width=".015in">
                            <fo:table space-before="0.07in" table-layout="fixed" width="100%"
                                font-size="8pt" margin-top=".05in" padding-top="0in">
                                <fo:table-column column-width="5in"/>
                                <fo:table-column column-width="2in"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block text-align="left" margin-left=".025in">
                                                <fo:retrieve-marker retrieve-class-name="title"/>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block text-align="right" margin-right="-.475in">
                                                <xsl:text> Page </xsl:text>
                                                <fo:page-number/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="ead:archdesc"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <!-- EAD Header, this information populates the cover page -->
    <xsl:template match="ead:eadheader">
        <fo:block text-align="center" padding-top=".5in" line-height="24pt"
            border-bottom="3pt solid #F4EFEF" space-after="18pt" padding-bottom="12pt">
            <fo:block font-size="20pt" wrap-option="wrap">
               <xsl:value-of select="$headerString"/>
            </fo:block>
            <fo:block font-size="16pt">
                <xsl:apply-templates select="ead:filedesc/ead:titlestmt/ead:subtitle"/>
            </fo:block>
        </fo:block>
        <fo:block margin="1in" font-size="14pt" space-before="18pt" color="#666" text-align="center" font-weight="normal" line-height="24pt">
            <fo:block>
                <!-- 10/30/11 WS for RA: Replaced default AT language in author field with "Collection Guide prepared by"-->
                <xsl:if test="ead:filedesc/ead:titlestmt/ead:author">
                    <xsl:value-of select="concat('Collection Guide prepared ',substring-after(ead:filedesc/ead:titlestmt/ead:author,'prepared'))"/>                    
                </xsl:if>
            </fo:block>
            <!-- 8/10/11 WS: Changed publication date from profiledec to publicationstmt/date -->
            <!--<xsl:apply-templates select="ead:profiledesc"/>-->
            <xsl:apply-templates select="ead:filedesc/ead:publicationstmt/ead:date"/>    
            <xsl:apply-templates select="ead:revisiondesc"/>    
            
            <!-- 8/10/11 WS: Added Rockefeller Logo -->
            <fo:block space-before="75pt">
                <fo:external-graphic src="reports/Resources/eadToPdf/RAClogo.jpg" content-height="200%" content-width="200%"/>
                <fo:block font-size="11pt"> &#169; Rockefeller Archive Center,
                    <xsl:choose>
                        <xsl:when test="ead:filedesc/ead:publicationstmt/ead:date">
                            <xsl:value-of select="ead:filedesc/ead:publicationstmt/ead:date"/>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$year"/>
                        </xsl:otherwise>
                    </xsl:choose> 
                </fo:block>
            </fo:block>
        </fo:block>
        <!-- 9/10/11 WS: Commented out for Rockefeller customized display -->
        <!--    <fo:block margin="1in" space-before="18pt" font-size="12pt" text-align="center"
            font-weight="normal" line-height="24pt">
            <xsl:apply-templates select="ead:filedesc/ead:editionstmt"/>
            </fo:block> -->
    </xsl:template>
    <xsl:template match="ead:filedesc/ead:titlestmt/ead:titleproper/ead:num">
        <!-- 8/15/11 WS: Added parenthesizes for RA -->
        <fo:block> &#160;(<xsl:apply-templates/>) </fo:block>
    </xsl:template>
    <xsl:template match="ead:revisiondesc">
        <fo:block line-height="12pt">
            <xsl:if test="ead:change/ead:date">Last revised: &#160;<xsl:value-of select="ead:change/ead:date"/>                
                <!--<xsl:value-of select="concat($month,' ',substring(.,9,2),', ',substring(.,1,4))"/>-->
            </xsl:if>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:publicationstmt">
        <fo:block font-size="14pt">
            <xsl:apply-templates select="ead:publisher"/>
        </fo:block>
        <!--<xsl:if test="ead:date">
            <fo:block>
                <xsl:apply-templates select="ead:date"/>
            </fo:block>
        </xsl:if>-->
        <xsl:apply-templates select="ead:address"/>
    </xsl:template>
    <xsl:template match="ead:address">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <!-- 8/10/11 WS: Added test to link email addresses -->
    <xsl:template match="ead:addressline">
        <xsl:choose>
            <xsl:when test="position()=1">
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="contains(.,'@')">
                <fo:block>
                    <fo:basic-link external-destination="url('mailto:{.}')" color="blue"
                        text-decoration="underline">
                        <xsl:value-of select="."/>
                    </fo:basic-link>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:profiledesc/ead:creation/ead:date">
        <xsl:variable name="month">
            <xsl:choose>
                <xsl:when test="substring(.,6,2) = '01'">January</xsl:when>
                <xsl:when test="substring(.,6,2) = '02'">February</xsl:when>
                <xsl:when test="substring(.,6,2) = '03'">March</xsl:when>
                <xsl:when test="substring(.,6,2) = '04'">April</xsl:when>
                <xsl:when test="substring(.,6,2) = '05'">May</xsl:when>
                <xsl:when test="substring(.,6,2) = '06'">June</xsl:when>
                <xsl:when test="substring(.,6,2) = '07'">July</xsl:when>
                <xsl:when test="substring(.,6,2) = '08'">August</xsl:when>
                <xsl:when test="substring(.,6,2) = '09'">September</xsl:when>
                <xsl:when test="substring(.,6,2) = '10'">October</xsl:when>
                <xsl:when test="substring(.,6,2) = '11'">November</xsl:when>
                <xsl:when test="substring(.,6,2) = '12'">December</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <fo:block line-height="18pt" font-size="12pt">
            <xsl:value-of select="concat($month,' ',substring(.,9,2),', ',substring(.,1,4))"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:profiledesc/ead:langusage"/>
    <!-- Special template for header display -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:unittitle" mode="header">
        <xsl:apply-templates mode="header"/>
    </xsl:template>
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:unittitle/child::*" mode="header">
            &#160;<xsl:apply-templates select="." mode="header"/>
    </xsl:template>
    <xsl:template match="ead:num" mode="header"> (<xsl:value-of select="."/>) </xsl:template>
    <!-- A named template generating the Table of Contents, order of items is pre-determined, to change the order, rearrange the xsl:if or xsl:for-each statements.  -->
    <!-- 8/21/11 WS for RA: uses predefined headings, not headings output in the xml-->
    <xsl:template name="toc">
        <fo:block font-size="14pt" space-before="24pt" padding-bottom="-2pt" space-after="18pt"
            color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
            Table of Contents </fo:block>
        <fo:block line-height="16pt">
            <xsl:if test="/ead:ead/ead:archdesc/ead:did">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="{generate-id(/ead:ead/ead:archdesc/ead:did)}">Overview</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="{generate-id(/ead:ead/ead:archdesc/ead:did)}"/>
                </fo:block>
            </xsl:if>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:scopecontent">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="tocLinks"/>Collection Description</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
            <!-- 8/16/11 WS for RA: Added Access and Use Location note-->
            <xsl:if test="/ead:ead/ead:archdesc/ead:relatedmaterial or /ead:ead/ead:archdesc/ead:separatedmaterial
                or /ead:ead/ead:archdesc/ead:accessrestrict or /ead:ead/ead:archdesc/ead:userestrict
                or /ead:ead/ead:archdesc/ead:phystech or /ead:ead/ead:archdesc/ead:prefercite
                or /ead:ead/ead:archdesc/ead:otherfindaid /ead:ead/ead:archdesc/ead:originalsloc /ead:ead/ead:archdesc/ead:altformavail">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="relMat">Access and Use</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="relMat"/>
                </fo:block>
            </xsl:if>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:arrangement">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="tocLinks"/>Arrangement</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:bioghist">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="tocLinks"/>Biographical/Historical Note</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>

            <xsl:for-each select="/ead:ead/ead:archdesc/ead:controlaccess">
                <fo:block text-align-last="justify">
                    <fo:basic-link>
                        <xsl:call-template name="tocLinks"/>Controlled Access Headings</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <xsl:call-template name="tocPage"/>
                </fo:block>
            </xsl:for-each>
           <!-- Administrative Information  -->
            <xsl:if test="/ead:ead/ead:archdesc/ead:acqinfo or 
                /ead:ead/ead:archdesc/ead:fileplan or
                /ead:ead/ead:archdesc/ead:custodhist or
                /ead:ead/ead:archdesc/ead:accruals or 
                /ead:ead/ead:archdesc/ead:processinfo or
                /ead:ead/ead:archdesc/ead:appraisal or /ead:ead/ead:archdesc/ead:separatedmaterial">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="adminInfo">Administrative Information</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="adminInfo"/>
                </fo:block>
            </xsl:if>
            
            <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc[@label = 'General Physical Description note'][1]">
                <fo:block text-align-last="justify">
                    <fo:basic-link internal-destination="physdesc">Physical Description of Material</fo:basic-link>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:leader leader-pattern="dots"/>
                    <xsl:text>&#160;&#160;</xsl:text>
                    <fo:page-number-citation ref-id="physdesc"/>
                </fo:block> 
            </xsl:if>
            <xsl:for-each select="/ead:ead/ead:archdesc/ead:dsc">
                <xsl:if test="child::*">
                    <fo:block text-align-last="justify">
                        <fo:basic-link>
                            <xsl:call-template name="tocLinks"/>Inventory</fo:basic-link>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <fo:leader leader-pattern="dots"/>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <xsl:call-template name="tocPage"/>
                    </fo:block>
                </xsl:if>

                <!--Creates a submenu for collections, record groups and series and fonds-->
                <xsl:for-each select="child::*[@level = 'collection']  | child::*[@level = 'recordgrp']  | child::*[@level = 'series'] | child::*[@level = 'fonds']">
                    <fo:block text-align-last="justify" margin-left="18pt">
                        <fo:basic-link>
                            <xsl:call-template name="tocLinks"/>
                            <!-- 8/21/11 WS for RA: Added series headings -->
                            <xsl:if test="child::*/ead:unitid">
                                <xsl:choose>
                                    <xsl:when test="@level='series'">Series <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subseries'">Subseries <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='collection'">Collection <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subcollection'">Subcollection <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='fonds'">Fonds <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subfonds'">Subfonds <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='recordgrp'">Record Group <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:when test="@level='subgrp'">Subgroup <xsl:value-of select="child::*/ead:unitid"/>: </xsl:when>
                                    <xsl:otherwise><xsl:value-of select="child::*/ead:unitid"/>: </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:apply-templates select="child::*/ead:unittitle"/>
                        </fo:basic-link>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <fo:leader leader-pattern="dots"/>
                        <xsl:text>&#160;&#160;</xsl:text>
                        <xsl:call-template name="tocPage"/>
                    </fo:block>
                </xsl:for-each>
            </xsl:for-each>
        </fo:block>
    </xsl:template>

    <!-- Template generates the page numbers for the table of contents -->
    <xsl:template name="tocPage">
        <fo:page-number-citation>
            <xsl:attribute name="ref-id">
                <xsl:choose>
                    <xsl:when test="self::*/@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </fo:page-number-citation>
    </xsl:template>

    <!--Orders the how ead elements appear in the PDF, order matches Table of Contents.  -->
    <xsl:template match="ead:archdesc">
        <xsl:if test="/ead:ead/ead:archdesc/ead:scopecontent">
            <fo:block>
                <fo:marker marker-class-name="title">Collection Description</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:scopecontent"/>
            </fo:block>
        </xsl:if>
        <!--NOTE: In process 8/16/11 WS for RA: Added Access and Use  location note        -->
        <xsl:if test="/ead:ead/ead:archdesc/ead:relatedmaterial or /ead:ead/ead:archdesc/ead:separatedmaterial
            or /ead:ead/ead:archdesc/ead:accessrestrict or /ead:ead/ead:archdesc/ead:userestrict
            or /ead:ead/ead:archdesc/ead:phystech or /ead:ead/ead:archdesc/ead:prefercite
            or /ead:ead/ead:archdesc/ead:otherfindaid">
            <fo:block>
                <fo:marker marker-class-name="title">Access and Use</fo:marker>
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                    space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                    border-bottom="1pt solid #000" id="relMat">Access and Use</fo:block>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:did/ead:physloc"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:accessrestrict"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:userestrict"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:phystech"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:prefercite"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:otherfindaid"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:relatedmaterial"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:altformavail"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:originalsloc"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:bibliography"/>
            </fo:block>
        </xsl:if>
        
        <xsl:if test="/ead:ead/ead:archdesc/ead:arrangement">
            <fo:block>
                <fo:marker marker-class-name="title">Arrangement</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:arrangement"/>
            </fo:block>
        </xsl:if>        

        <xsl:if test="/ead:ead/ead:archdesc/ead:bioghist">
            <fo:block>
                <fo:marker marker-class-name="title">Biographical/Historical Note</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:bioghist"/>
            </fo:block>
        </xsl:if>

        <xsl:if test="/ead:ead/ead:archdesc/ead:controlaccess">
            <fo:block>
                <fo:marker marker-class-name="title">Controlled Access Headings</fo:marker>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:controlaccess"/>
            </fo:block>
        </xsl:if>
       
        <!-- Administrative Information  -->
        <xsl:if test="/ead:ead/ead:archdesc/ead:acqinfo or 
            /ead:ead/ead:archdesc/ead:fileplan or
            /ead:ead/ead:archdesc/ead:custodhist or
            /ead:ead/ead:archdesc/ead:accruals or 
            /ead:ead/ead:archdesc/ead:processinfo or
            /ead:ead/ead:archdesc/ead:appraisal or /ead:ead/ead:archdesc/ead:separatedmaterial">
            <fo:block>
                <fo:marker marker-class-name="title">Administrative Information</fo:marker>
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                    space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                    border-bottom="1pt solid #000" id="adminInfo"> Administrative Information </fo:block>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:acqinfo"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:fileplan"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:custodhist"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:accruals"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:processinfo"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:appraisal"/>
                <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:separatedmaterial"/>
                <!--<xsl:apply-templates select="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt" mode="admin"/>
            <xsl:apply-templates select="/ead:ead/ead:eadheader/ead:revisiondesc" mode="admin"/>-->
            </fo:block>
        </xsl:if>
       
        
        <xsl:if test="/ead:ead/ead:archdesc/ead:did/ead:physdesc[@label = 'General Physical Description note']">
            <fo:block>
                <fo:marker marker-class-name="title">Physical Description of Material</fo:marker>
                    <fo:block space-after="12pt" space-before="12pt">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                            space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                            border-bottom="1pt solid #000" id="physdesc">Physical Description of Material </fo:block>
                        <xsl:for-each select="/ead:ead/ead:archdesc/ead:did/ead:physdesc[@label = 'General Physical Description note']">
                            <fo:block>
                                <xsl:apply-templates/>
                            </fo:block>
                        </xsl:for-each>     
                    </fo:block>         
            </fo:block>     
        </xsl:if>

        <xsl:if test="/ead:ead/ead:archdesc/ead:dsc/child::*">
            <xsl:apply-templates select="/ead:ead/ead:archdesc/ead:dsc"/>            
        </xsl:if>
   
    </xsl:template>
    
    <!-- Summary Information, generated from ead:archdesc/ead:did -->
    <xsl:template match="ead:archdesc/ead:did">
        <fo:block break-after="page">
            <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt"
                color="black" padding-before="24pt" border-bottom="1pt solid #000"
                id="{generate-id(.)}">
                Overview
            </fo:block>
            <fo:table space-before="0.1in" table-layout="fixed" width="100%">
                <fo:table-column column-width="2in"/>
                <fo:table-column column-width="5in"/>
                <fo:table-body>
                    <!-- Determines the order the elements from the archdesc did appear, 
                        to change the order of appearance for the children of did
                        by changing the order of the following statements.
                    -->
                    <xsl:apply-templates select="ead:repository" mode="overview"/>
                    <xsl:apply-templates select="ead:origination[starts-with(child::*/@role,'Author')]" mode="overview"/>
                    <xsl:apply-templates select="ead:unittitle" mode="overview"/>
                    <!-- 8/14/11 WS: Reformated dates to be called all in one row -->
                    <xsl:call-template name="archdescUnitdate"/>
                    <!-- 10/30/11 WS for RA: Changed to only call extent, not all physdesc notes  -->
                    <xsl:apply-templates select="ead:physdesc[ead:extent]" mode="overview"/>
                    <xsl:apply-templates select="ead:physloc" mode="overview"/>
                    <xsl:apply-templates select="ead:langmaterial" mode="overview"/>
                    <xsl:apply-templates select="ead:materialspec" mode="overview"/>
                    <xsl:apply-templates select="ead:container" mode="overview"/>
                    <xsl:apply-templates select="ead:abstract" mode="overview"/>
                    <xsl:apply-templates select="ead:note" mode="overview"/>
                </fo:table-body>
            </fo:table>
            <!--8/14/11 WS for RA: removed prefered citation  -->
            <!--<xsl:apply-templates select="../ead:prefercite"/>-->
            <!--8/14/11 WS for RA: Added test to check for restrictions  -->
            <xsl:if test="../ead:accessrestrict">
                <fo:block color="#990000" font-size="10pt" text-align="center" space-before="24pt">
                    *Restrictions Apply. Please see the Access and Use section for more details.*
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <!-- Template calls and formats the children of archdesc/did -->
    <xsl:template
        match="ead:archdesc/ead:did/ead:repository | ead:archdesc/ead:did/ead:unittitle | ead:archdesc/ead:did/ead:unitid | ead:archdesc/ead:did/ead:origination[starts-with(child::*/@role,'Author')] 
        | ead:archdesc/ead:did/ead:unitdate | ead:archdesc/ead:did/ead:physdesc | ead:archdesc/ead:did/ead:physloc 
        | ead:archdesc/ead:did/ead:abstract | ead:archdesc/ead:did/ead:langmaterial | ead:archdesc/ead:did/ead:materialspec |
        ead:archdesc/ead:did/ead:container" mode="overview">
        <fo:table-row>
            <fo:table-cell padding-bottom="2pt">
                <fo:block font-weight="bold" color="#111">
                            <xsl:choose>
                                <xsl:when test="self::ead:repository">Repository:</xsl:when>
                                <xsl:when test="self::ead:unittitle">Title:</xsl:when>
                                <xsl:when test="self::ead:unitid">Resource ID:</xsl:when>
                                <xsl:when test="self::ead:unitdate">Date<xsl:if test="@type">
                                            [<xsl:value-of select="@type"/>]</xsl:if>:</xsl:when>
                                <xsl:when test="self::ead:origination">Creator:
                                    <!-- 9/17/11 WS for RA: Added choose statement to suppress creators not listed as 'authors' -->
                                    <!--<xsl:choose>
                                        <xsl:when test="not(starts-with(child::*/@role,'Author'))"/>
                                        <xsl:otherwise> Creator:</xsl:otherwise>
                                    </xsl:choose>-->
                                </xsl:when>
                                <xsl:when test="self::ead:physdesc[ead:extent]">Extent:</xsl:when>
                                <xsl:when test="self::ead:abstract">Abstract:</xsl:when>
                                <xsl:when test="self::ead:physloc">Location:</xsl:when>
                                <xsl:when test="self::ead:langmaterial">Language:</xsl:when>
                                <xsl:when test="self::ead:materialspec">Material Specific Details:</xsl:when>
                                <xsl:when test="self::ead:container">Container:</xsl:when>
                                <xsl:when test="self::ead:note">General Note:</xsl:when>
                            </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-bottom="2pt">
                <fo:block>
                    <!-- 9/17/11 WS for RA: Added choose statement to suppress creators not listed as 'authors' -->
                    <xsl:choose>
                        <xsl:when test="self::ead:origination">
                            <xsl:choose>
                                <xsl:when test="not(starts-with(child::*/@role,'Author'))"/>
                                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- 10/30/11 WS for RA: addeds comma if there is a second extent in a single physdesc element -->
                        <xsl:when test="self::ead:physdesc[ead:extent]">
                            <xsl:value-of select="ead:extent[1]"/>
                            <xsl:if test="ead:extent[position() &gt; 1]">, <xsl:value-of select="ead:extent[position() &gt; 1]"/> </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:if test="self::ead:repository">
            <fo:table-row>
                <fo:table-cell padding-bottom="2pt">
                    <fo:block font-weight="bold" color="#111"> Resource ID: </fo:block>
                </fo:table-cell>
                <fo:table-cell padding-bottom="2pt">
                    <fo:block>
                        <xsl:value-of select="../ead:unitid"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>

    <!-- 8/14/11 WS for RA: Added named template to handle date display in overview -->
    <xsl:template name="archdescUnitdate">
        <xsl:if test="ead:unitdate[not(@type='bulk')]">
        <fo:table-row>
            <fo:table-cell padding-bottom="2pt">
                <fo:block font-weight="bold" color="#111">Date(s): </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-bottom="2pt">
                <fo:block>                          
                    <xsl:value-of select="ead:unitdate"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        </xsl:if>
    </xsl:template>

    <!-- Template calls and formats all other children of archdesc many of 
        these elements are repeatable within the ead:dsc section as well.-->
    <xsl:template match="ead:odd | ead:arrangement  | ead:bioghist 
        | ead:accessrestrict | ead:userestrict  | ead:custodhist | ead:altformavail | ead:originalsloc 
        | ead:fileplan | ead:acqinfo | ead:otherfindaid | ead:phystech | ead:processinfo | ead:relatedmaterial
        | ead:separatedmaterial | ead:appraisal | ead:materialspec">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <xsl:choose>
                    <xsl:when test="self::ead:odd">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                            <xsl:call-template name="anchor"/>General Note</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:arrangement">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                            <xsl:call-template name="anchor"/>Arrangement</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:bioghist">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                            <xsl:call-template name="anchor"/>Biographical/Historical Note</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:accessrestrict">
                        <xsl:choose>
                            <xsl:when test="ead:legalstatus"/>
                            <xsl:otherwise>
                                <fo:block space-before="18pt" font-weight="bold" color="#111">
                                    <xsl:call-template name="anchor"/>Access Restrictions</fo:block>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:when>
                    <xsl:when test="self::ead:userestrict">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Use Restrictions</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:custodhist">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Custodial History</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:altformavail">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Location of Copies</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:originalsloc">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Location of Originals</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:fileplan">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>File Plan</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:acqinfo">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Acquisition Information</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:otherfindaid">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Other Finding Aids</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:phystech">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Physical Characteristics and Technical Requirements </fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:processinfo">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Processing Information</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:relatedmaterial">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Related Archival Materials</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:separatedmaterial">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Separated Materials</fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:appraisal">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Appraisal</fo:block>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <fo:block font-weight="bold" color="#111" margin-top="0pt" margin-bottom="0pt">
                    <xsl:choose>
                        <xsl:when test="self::ead:odd">General Note</xsl:when>
                        <xsl:when test="self::ead:arrangement">Arrangement</xsl:when>
                        <xsl:when test="self::ead:bioghist">Biographical/Historical Note</xsl:when>
                        <xsl:when test="self::ead:accessrestrict">
                            <xsl:choose>
                                <xsl:when test="ead:legalstatus"/>
                                <xsl:otherwise>
                                    Access Restrictions                            
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="self::ead:userestrict">Use Restrictions</xsl:when>
                        <xsl:when test="self::ead:custodhist">Custodial History</xsl:when>
                        <xsl:when test="self::ead:altformavail">Location of Copies</xsl:when>
                        <xsl:when test="self::ead:originalsloc">Location of Originals</xsl:when>
                        <xsl:when test="self::ead:fileplan">File Plan</xsl:when>
                        <xsl:when test="self::ead:acqinfo">Acquisition Information</xsl:when>
                        <xsl:when test="self::ead:otherfindaid">Other Finding Aids</xsl:when>
                        <xsl:when test="self::ead:phystech">Physical Characteristics and Technical Requirements</xsl:when>
                        <xsl:when test="self::ead:processinfo">Processing Information</xsl:when>
                        <xsl:when test="self::ead:relatedmaterial">Related Archival Materials</xsl:when>
                        <xsl:when test="self::ead:separatedmaterial">Separated Materials</xsl:when>
                        <xsl:when test="self::ead:appraisal">Appraisal</xsl:when>
                        <xsl:when test="self::ead:materialspec">Material Specific Details</xsl:when>
                    </xsl:choose>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <xsl:choose>
                    <xsl:when test="self::ead:bioghist">
                        <fo:block space-after="12pt">
                            <xsl:apply-templates select="ead:p"/>
                            <xsl:apply-templates select="child::*[name() != 'head' and name() != 'p']"/>
                        </fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:materialspec">
                        <fo:block space-after="12pt">
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block space-after="12pt">
                            <xsl:apply-templates select="child::*[name() != 'head']"/>
                        </fo:block>                
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="self::ead:bioghist">
                        <fo:block margin-bottom="6pt">
                            <xsl:apply-templates select="ead:p"/>
                            <xsl:apply-templates select="child::*[name() != 'head' and name() != 'p']"/>
                        </fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:materialspec">
                        <fo:block margin-bottom="6pt">
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block margin-bottom="6pt">
                            <xsl:apply-templates select="child::*[name() != 'head']"/>
                        </fo:block>                
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 11/2/11 WS for RA: templates added for special handeling of physdesc notes and language -->
    <xsl:template match="ead:physdesc">
        <xsl:choose>
            <xsl:when test="child::ead:extent"/>
            <xsl:when test="@label = 'General Physical Description note'">
                <fo:block space-after="12pt" space-before="12pt">
                       <fo:block font-weight="bold">Physical Description of Material </fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
            </xsl:when>
            <xsl:when test="@label='Physical Facet note'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="ead:dimensions">
                <fo:block space-after="12pt">
                    <fo:block font-weight="bold">Dimensions</fo:block>
                    <xsl:apply-templates select="*[not(ead:head)]"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-after="12pt" space-before="12pt">
                    <fo:block font-weight="bold"><xsl:value-of select="@label"/> </fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:langmaterial">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <fo:block space-after="12pt">
                    <fo:block font-weight="bold">Language</fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <fo:block font-weight="bold" margin-top="3pt" margin-bottom="0pt">Language</fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 10/30/11 WS for RA: added choose statment to print accruals and bibliography at collection level only-->
    <xsl:template match="ead:accruals | ead:bibliography">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <xsl:choose>
                    <xsl:when test="self::ead:bibliography">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Bibliography </fo:block>
                    </xsl:when>
                    <xsl:when test="self::ead:accruals">
                        <fo:block space-before="18pt" font-weight="bold" color="#111">
                            <xsl:call-template name="anchor"/>Accruals</fo:block>
                    </xsl:when>
                </xsl:choose>
                <fo:block space-after="12pt">
                    <xsl:apply-templates select="child::*[name() != 'head']"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
   
    <!-- 10/30/11 WS for RA: Template to format scope and contents notes -->
    <xsl:template match="ead:scopecontent">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">        
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="18pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000">
                    <xsl:call-template name="anchor"/>Collection Description 
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::*[@level = 'recordgrp']"><fo:block font-weight="bold">Record Group Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'subgrp']"><fo:block font-weight="bold">Subgroup Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'collection']"><fo:block font-weight="bold">Collection Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'fonds']"><fo:block font-weight="bold">Fonds Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'subfonds']"><fo:block font-weight="bold">Sub-Fonds Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'series']"><fo:block font-weight="bold">Series Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'subseries']"><fo:block font-weight="bold">Subseries Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'item']"><fo:block font-weight="bold">Item Description</fo:block></xsl:when>
            <xsl:when test="parent::*[@level = 'file']"><fo:block font-weight="bold">File Description</fo:block></xsl:when>
            <xsl:otherwise>
                <fo:block space-before="2pt" font-weight="bold" color="#111">Description</fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <fo:block space-after="12pt">
                    <xsl:apply-templates select="child::*[name() != 'head']"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block margin-bottom="6pt">
                    <xsl:apply-templates select="child::*[name() != 'head']"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Templates for publication information  -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt" mode="admin">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111"> Publication
            Information</fo:block>
        <fo:block>
            <xsl:apply-templates select="ead:publisher"/>
            <xsl:if test="ead:date">&#160;<xsl:apply-templates select="ead:date"/></xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- Templates for revision description  -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:revisiondesc" mode="admin">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111">Revision
            Description</fo:block>
        <fo:block>
            <xsl:if test="ead:change/ead:item">
                <xsl:apply-templates select="ead:change/ead:item"/>
            </xsl:if>
            <xsl:if test="ead:change/ead:date">&#160;<xsl:apply-templates select="ead:change/ead:date"/></xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- 10/30/11 WS for RA: added template for ead:ead/ead:arcdesc/ead:did/ead:physloc -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:physloc">
        <fo:block>                  
            <fo:block font-weight="bold" color="#111">Location</fo:block>                      
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>  
    
    <!-- Formats prefered citiation -->
    <xsl:template match="ead:prefercite">
        <!-- 10/30/11 WS for RA: added choose statment to print prefercite at collection level only-->
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <fo:block>                  
                    <fo:block font-weight="bold" color="#111">Preferred Citation</fo:block>                      
                    <xsl:apply-templates select="child::*[not(name()='head')]"/>
                </fo:block>                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
        
    <!-- 9/12/11 WS for RA: added special template for preferred citation example paragraph -->
    <xsl:template match="ead:prefercite/ead:p[starts-with(.,'Example:')]">
            <fo:block margin-left="24pt">
                <fo:block font-weight="bold">Example</fo:block>
                <fo:block><xsl:value-of select="substring-after(.,'Example: ')"/></fo:block>
            </fo:block>
    </xsl:template>
    <!-- Formats controlled access terms -->
   
    <!-- 8/16/11 WS for RA: Changed grouping for RA specified display -->
    <xsl:template match="ead:controlaccess">
        <xsl:choose>
            <xsl:when test="parent::ead:archdesc">
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt" space-after="8pt" color="black" padding-after="1pt" padding-before="24pt" border-bottom="1pt solid #000" id="{generate-id(.)}"> 
                    Controlled Access Headings
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-before="12pt" space-after="4pt" font-weight="bold" color="#111">Controlled Access Headings</fo:block>
            </xsl:otherwise>
        </xsl:choose>
            <!-- 8/17/11 WS for RA: Changed grouping for controlaccess -->
        <xsl:if test="ead:corpname or ead:famname or ead:famname or ead:persname or 
            /ead:ead/ead:archdesc/ead:did/ead:origination/ead:corpname or 
            /ead:ead/ead:archdesc/ead:did/ead:origination/ead:famname or 
            /ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname">
                <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold" color="#111"
                    padding-after="8pt" padding-before="8pt"> Name(s) </fo:block>
                <fo:list-block margin-bottom="8pt" margin-left="8pt">                        
                    <xsl:for-each select="ead:corpname | ead:famname | ead:persname  | /ead:ead/ead:archdesc/ead:did/ead:origination/ead:corpname | /ead:ead/ead:archdesc/ead:did/ead:origination/ead:famname | /ead:ead/ead:archdesc/ead:did/ead:origination/ead:persname">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block> </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                    <!--<xsl:if test="@role"> (<xsl:value-of select="@role"/>)</xsl:if>-->
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:for-each>
                </fo:list-block>
            </xsl:if>
            <xsl:if test="ead:genreform">
                <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt"> Genre/Form</fo:block>
                <fo:list-block margin-bottom="8pt" margin-left="8pt">
                    <xsl:for-each select="ead:genreform">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block> </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:for-each>
                </fo:list-block>
            </xsl:if>
            <xsl:if
                test="ead:subject or ead:function or ead:occupation or ead:geogname or ead:title or ead:name">
                <fo:block space-before="8pt" font-variant="small-caps" font-weight="bold" color="#111"
                    padding-after="8pt" padding-before="8pt"> Subject(s)</fo:block>
                <fo:list-block margin-bottom="8pt" margin-left="8pt">
                    <xsl:for-each select="ead:subject | ead:function | ead:occupation | ead:geogname | ead:title | ead:name">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block> </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:for-each>
                </fo:list-block>
            </xsl:if>
        </xsl:template>
    
    <!-- Formats index and child elements, groups indexentry elements by type (i.e. corpname, subject...)-->
    <!-- 10/30/11 WS for RA: removed ead:index -->
    <xsl:template match="ead:index"/>
    <!--<xsl:template match="ead:index">
        <xsl:choose>
            <xsl:when test="ead:head"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="parent::ead:archdesc">
                        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                            space-after="18pt" color="black" padding-after="1pt"
                            padding-before="24pt" border-bottom="1pt solid #000"
                            id="{generate-id(.)}">Index</fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111">Index</fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="child::*[not(self::ead:indexentry)]"/>
        <xsl:if test="ead:indexentry/ead:corpname">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt"> Corporate Name(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:corpname">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:famname">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt"> Family
                Name(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:famname">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:function">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt">
                Function(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:function">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:genreform">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt">
                Genre(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:genreform">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:geogname">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt"> Geographic
                Name(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:geogname">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:name">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt">
                Name(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:name">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:occupation">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt">
                Occupation(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:occupation">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:persname">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt"> Personal
                Name(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:persname">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:subject">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt">
                Subject(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:subject">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
        <xsl:if test="ead:indexentry/ead:title">
            <fo:block space-before="18pt" space-after="18pt" font-variant="small-caps"
                font-weight="bold" color="#111" padding-after="8pt" padding-before="8pt">
                Title(s)</fo:block>
            <fo:list-block margin-bottom="8pt" margin-left="8pt">
                <xsl:for-each select="ead:indexentry/ead:title">
                    <xsl:sort/>
                    <fo:list-item>
                        <fo:list-item-label end-indent="24pt">
                            <fo:block>&#x2022;</fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="24pt">
                            <fo:block><xsl:apply-templates select="."/> &#160;<xsl:apply-templates
                                    select="following-sibling::*"/></fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
    </xsl:template>
    -->
 
    <xsl:template match="ead:indexentry">
        <fo:block font-weight="bold">
            <xsl:apply-templates select="child::*[1]"/>
        </fo:block>
        <fo:block margin-left="18pt">
            <xsl:apply-templates select="child::*[2]"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:ptrgrp">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Digital Archival Object -->
    <xsl:template match="ead:dao">
        <xsl:choose>
            <xsl:when test="child::*">
                <xsl:apply-templates/>
                <fo:basic-link external-destination="url('{@ns2:href}')" text-decoration="underline"
                    color="blue"> [<xsl:value-of select="@ns2:href"/>]</fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:basic-link external-destination="url('{@ns2:href}')" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="@ns2:href"/>
                </fo:basic-link>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Linking elements, ptr and ref. -->
    <xsl:template match="ead:ptr">
        <xsl:choose>
            <xsl:when test="@target">
                <fo:basic-link internal-destination="{@target}" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ptr">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <fo:basic-link internal-destination="{@ns2:href}" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ptr">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:ref">
        <xsl:choose>
            <xsl:when test="@target">
                <fo:basic-link internal-destination="{@target}" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ref">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <fo:basic-link internal-destination="{@ns2:href}" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:ref">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 8/16/11 WS for AR: added extref template -->
    <xsl:template match="ead:extref">
        <xsl:choose>
            <xsl:when test="@target">
                <fo:basic-link external-destination="{@target}" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="@target"/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:extref">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <fo:basic-link external-destination="{@ns2:href}" text-decoration="underline"
                    color="blue">
                    <xsl:value-of select="."/>
                </fo:basic-link>
                <xsl:if test="following-sibling::ead:extref">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- FLAG: need to deal with exptr and extref example:
        <extptr linktype="simple" entityref="phyllis" title="Image of Phyllis Wheatley"
        actuate="onload" show="embed">-->

    <!--Creates a hidden anchor tag that allows navigation within the finding aid. 
        In this stylesheet only children of the archdesc and c0* itmes call this template. 
        It can be applied anywhere in the stylesheet as the id attribute is universal. -->
    <xsl:template match="@id">
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="anchor">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="tocLinks">
        <xsl:attribute name="internal-destination">
            <xsl:choose>
                <xsl:when test="self::*/@id">
                    <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <!-- 9/19/11 WS added for RA -->
    <xsl:template match="ead:legalstatus">
        <fo:block space-after="12pt">
            <fo:block font-weight="bold">Access Restrictions / Legal Status</fo:block>
            <fo:block><xsl:apply-templates/></fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:physfacet">
        <fo:block space-after="12pt">
            <fo:block font-weight="bold">Physical Facet Note</fo:block>
            <fo:block><xsl:apply-templates/></fo:block>
        </fo:block>
    </xsl:template>
    <!-- Formats headings throughout the finding aid -->
    <xsl:template match="ead:head[parent::*/parent::ead:archdesc]">
        <xsl:choose>
            <xsl:when
                test="parent::ead:accessrestrict or parent::ead:userestrict or
                parent::ead:custodhist or parent::ead:accruals or
                parent::ead:altformavail or parent::ead:acqinfo or 
                parent::ead:processinfo or parent::ead:appraisal or parent::ead:fileplan or
                parent::ead:originalsloc or parent::ead:phystech or parent::eadotherfindaid or
                parent::ead:relatedmaterial or parent::ead:separatedmaterial">
                <fo:block space-before="18pt" space-after="4pt" font-weight="bold" color="#111">
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::ead:prefercite">
                <fo:block space-before="4pt" space-after="8pt" font-weight="bold" color="#111">
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
                    space-after="18pt" color="black" padding-after="1pt" padding-before="24pt"
                    border-bottom="1pt solid #000">
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 8/17/11 WS for RA: Added new header formating for display within inventory -->
    <xsl:template match="ead:head[ancestor-or-self::ead:dsc]">
        <fo:block space-before="8pt" font-weight="bold" color="#111">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:head">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!--Bibref, choose statement decides if the citation is inline, if there is a parent element
        or if it is its own line, typically when it is a child of the bibliography element.-->
    <xsl:template match="ead:bibref">
        <xsl:choose>
            <xsl:when test="parent::ead:p">
                <xsl:choose>
                    <xsl:when test="@ns2:href">
                        <fo:basic-link external-destination="url('{@ns2:href}')">
                            <xsl:apply-templates/>
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <fo:block margin-bottom="8pt">
                    <xsl:choose>
                        <xsl:when test="@ns2:href">
                            <fo:basic-link external-destination="url('{@ns2:href}')">
                                <xsl:apply-templates/>
                            </fo:basic-link>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Puts a space between sibling elements -->
    <xsl:template match="child::*">
        <xsl:if test="preceding-sibling::*">&#160;</xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ead:p">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::ead:dsc">
                <fo:block margin-bottom="4pt">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block margin-bottom="8pt">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
    <xsl:template match="ead:table">
        <xsl:for-each select="tgroup">
            <fo:table table-layout="fixed" width="100%" space-after="24pt" space-before="36pt"
                font-size="12pt" line-height="18pt" border-top="1pt solid #000"
                border-bottom="1pt solid #000">
                <xsl:for-each select="ead:colspec">
                    <fo:table-column column-width="{@colwidth}"/>
                </xsl:for-each>
                <fo:table-body>
                    <xsl:for-each select="ead:thead">
                        <xsl:for-each select="ead:row">
                            <fo:table-row>
                                <xsl:for-each select="ead:entry">
                                    <fo:table-cell border="1pt solid #fff" background-color="#000"
                                        padding="8pt">
                                        <fo:block font-size="14pt" font-weight="bold" color="#111">
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="ead:tbody">
                        <xsl:for-each select="ead:row">
                            <fo:table-row>
                                <xsl:for-each select="ead:entry">
                                    <fo:table-cell padding="8pt">
                                        <fo:block>
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </xsl:for-each>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </xsl:for-each>
    </xsl:template>
    <!-- Formats unitdates and dates -->
    <xsl:template match="ead:unitdate">
        <xsl:if test="preceding-sibling::*">&#160;</xsl:if>
        <xsl:choose>
            <xsl:when test="@type = 'bulk'"> (<xsl:apply-templates/>) </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:date">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Formats unittitle -->
    <xsl:template match="ead:unittitle">
        <xsl:choose>
            <xsl:when test="child::ead:unitdate[@type='bulk']">
                <xsl:apply-templates select="node()[not(self::ead:unitdate[@type='bulk'])]"/>
                <xsl:apply-templates select="ead:date[@type='bulk']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Following five templates output chronlist and children in a table -->
    <xsl:template match="ead:chronlist">
        <fo:table table-layout="fixed" width="100%" space-before="14pt" line-height="18pt"
            border-top="1pt solid #000" border-bottom="1pt solid #000" space-after="24pt">
            <fo:table-body>
                <xsl:apply-templates/>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    <xsl:template match="ead:chronlist/ead:listhead">
        <fo:table-row>
            <fo:table-cell border="1pt solid #fff" background-color="#000" padding="4pt">
                <fo:block font-weight="bold" color="#fff">
                    <xsl:apply-templates select="ead:head01"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell border="1pt solid #fff" background-color="#000" padding="4pt">
                <fo:block font-size="14pt" font-weight="bold" color="#fff">
                    <xsl:apply-templates select="ead:head02"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="ead:chronlist/ead:head">
        <fo:table-row>
            <fo:table-cell border="1pt solid #fff" background-color="#000"
                number-columns-spanned="2" padding="4pt">
                <fo:block font-weight="bold" color="#fff">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="ead:chronitem">
        <fo:table-row>
            <xsl:attribute name="background-color">
                <xsl:choose>
                    <xsl:when test="(position() mod 2 = 0)">#eee</xsl:when>
                    <xsl:otherwise>#fff</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <fo:table-cell>
                <fo:block margin-left=".15in">
                    <xsl:apply-templates select="ead:date"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="descendant::ead:event"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="ead:event">
        <xsl:choose>
            <xsl:when test="following-sibling::*">
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
                <fo:block/>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Output for a variety of list types -->
    <xsl:template match="ead:list">
        <xsl:if test="ead:head">
            <fo:block space-before="18pt" space-after="4pt" font-weight="bold" color="#111">
                <xsl:value-of select="ead:head"/>
            </fo:block>
        </xsl:if>
        <fo:list-block margin-bottom="8pt" margin-left="8pt">
            <xsl:apply-templates/>
        </fo:list-block>
    </xsl:template>
    <xsl:template match="ead:list/ead:head"/>
    <xsl:template match="ead:list/ead:item">
        <xsl:choose>
            <xsl:when test="parent::*/@type = 'ordered'">
                <xsl:choose>
                    <xsl:when test="parent::*/@numeration = 'arabic'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="1"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperalpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="A"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'loweralpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="a"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="I"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'lowerroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="i"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="1"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="parent::*/@type='simple'">
                <fo:list-item>
                    <fo:list-item-label end-indent="24pt">
                        <fo:block>&#x2022;</fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="24pt">
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="parent::*/@numeration = 'arabic'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="1"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperalpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="A"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'loweralpha'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="a"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'upperroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="I"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:when test="parent::*/@numeration = 'lowerroman'">
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>
                                    <xsl:number format="i"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:list-item>
                            <fo:list-item-label end-indent="24pt">
                                <fo:block>&#x2022;</fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="24pt">
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ead:defitem">
        <fo:list-item>
            <fo:list-item-label>
                <fo:block/>
            </fo:list-item-label>
            <fo:list-item-body>
                <fo:block font-weight="bold">
                    <xsl:apply-templates select="ead:label"/>
                </fo:block>
                <fo:block margin-left="18pt">
                    <xsl:apply-templates select="ead:item"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

    <!-- Formats list as tabel if list has listhead element  -->
    <xsl:template match="ead:list[child::ead:listhead]">
        <fo:table table-layout="fixed" space-before="24pt" space-after="24pt" line-height="18pt"
            width="4.5in" margin-left="8pt" border-top="1pt solid #000"
            border-bottom="1pt solid #000">
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell border="1pt solid #fff" background-color="#000" padding="8pt">
                        <fo:block font-size="14pt" font-weight="bold" color="#fff">
                            <xsl:apply-templates select="ead:listhead/ead:head01"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border="1pt solid #fff" background-color="#000" padding="8pt">
                        <fo:block font-size="14pt" font-weight="bold" color="#fff">
                            <xsl:apply-templates select="ead:listhead/ead:head02"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <xsl:for-each select="ead:defitem">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block margin-left="8pt">
                                <xsl:apply-templates select="ead:label"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block margin-left="8pt">
                                <xsl:apply-templates select="ead:item"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- Formats notestmt and notes -->
    <xsl:template match="ead:notestmt">
        <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111"
            id="{generate-id(.)}">General Note</fo:block>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ead:note">
        <xsl:choose>
            <xsl:when test="parent::ead:notestmt">
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::ead:notestmt">
                <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">               
                    Physical Description of Material
                </fo:block>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>            
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-before="18pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">               
                    General Note
                </fo:block>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Generic text display elements -->
    <xsl:template match="ead:lb">
        <fo:block/>
    </xsl:template>
    <xsl:template match="ead:blockquote">
        <fo:block margin="18pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="ead:emph">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!--Render elements -->
    <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] ">
        <fo:inline font-weight="bold">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']">
        <fo:inline font-weight="bold"><xsl:if test="preceding-sibling::*">
            &#160;</xsl:if>"<xsl:apply-templates/>"</fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']">
        <fo:inline font-weight="bold"><xsl:if test="preceding-sibling::*">
            &#160;</xsl:if>'<xsl:apply-templates/>'</fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']">
        <fo:inline font-weight="bold" font-style="italic">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']">
        <fo:inline font-weight="bold" font-variant="small-caps">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']">
        <fo:inline font-weight="bold" border-bottom="1pt solid #000">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>"<xsl:apply-templates/>" </xsl:template>
    <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']">
        <fo:inline font-style="italic">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>'<xsl:apply-templates/>' </xsl:template>
    <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']">
        <fo:inline font-variant="small-caps">
            <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']">
        <fo:inline baseline-shift="sub">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']">
        <fo:inline baseline-shift="super">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']">
        <fo:inline text-decoration="underline">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- *** Begin templates for Container List *** -->
    <xsl:template match="ead:archdesc/ead:dsc">
        <fo:block font-size="14pt" space-before="18pt" padding-bottom="-2pt"
            border-bottom="1pt solid #000" color="black" padding-after="0" padding-before="8pt"
            id="{generate-id(.)}" break-before="page"> Inventory </fo:block>
        <fo:block>
            <xsl:choose>
                <xsl:when test="child::*[@level='series' or @level='subseries' or @level='collection' or @level='subcollection' or  @level='fonds' or @level='subfonds' or  @level='recordgrp' or @level='subgrp']"></xsl:when>
                <xsl:otherwise>
                    <fo:marker marker-class-name="title">
                        Inventory
                    </fo:marker>
                </xsl:otherwise>
            </xsl:choose>
        <fo:table table-layout="fixed" space-after="12pt" width="7.25in">
            <fo:table-column column-number="1" column-width="3.25in"/>
            <fo:table-column column-number="2" column-width="1in"/>
            <fo:table-column column-number="3" column-width="1in"/>
            <fo:table-column column-number="4" column-width="1in"/>
            <fo:table-column column-number="5" column-width="1in"/>
            <fo:table-body>
                <xsl:apply-templates select="*[not(self::ead:head)]"/>
            </fo:table-body>
        </fo:table>
        </fo:block>
    </xsl:template>

    <!--This section of the stylesheet creates a div for each c01 or c 
        It then recursively processes each child component of the c01 by 
        calling the clevel template. -->
    <xsl:template match="ead:c">
        <xsl:call-template name="clevel">
            <xsl:with-param name="level">01</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="ead:c">
            <xsl:call-template name="clevel">
                <xsl:with-param name="level">02</xsl:with-param>
            </xsl:call-template>
            <xsl:for-each select="ead:c">
                <xsl:call-template name="clevel">
                    <xsl:with-param name="level">03</xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="ead:c">
                    <xsl:call-template name="clevel">
                        <xsl:with-param name="level">04</xsl:with-param>
                    </xsl:call-template>
                    <xsl:for-each select="ead:c">
                        <xsl:call-template name="clevel">
                            <xsl:with-param name="level">05</xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="ead:c">
                            <xsl:call-template name="clevel">
                                <xsl:with-param name="level">06</xsl:with-param>
                            </xsl:call-template>
                            <xsl:for-each select="ead:c">
                                <xsl:call-template name="clevel">
                                    <xsl:with-param name="level">07</xsl:with-param>
                                </xsl:call-template>
                                <xsl:for-each select="ead:c">
                                    <xsl:call-template name="clevel">
                                        <xsl:with-param name="level">08</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:for-each select="ead:c">
                                        <xsl:call-template name="clevel">
                                            <xsl:with-param name="level">019</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ead:c01">
        <xsl:call-template name="clevel">
            <xsl:with-param name="level">01</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="ead:c02">
            <xsl:call-template name="clevel">
                <xsl:with-param name="level">02</xsl:with-param>
            </xsl:call-template>
            <xsl:for-each select="ead:c03">
                <xsl:call-template name="clevel">
                    <xsl:with-param name="level">03</xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="ead:c04">
                    <xsl:call-template name="clevel">
                        <xsl:with-param name="level">04</xsl:with-param>
                    </xsl:call-template>
                    <xsl:for-each select="ead:c05">
                        <xsl:call-template name="clevel">
                            <xsl:with-param name="level">05</xsl:with-param>
                        </xsl:call-template>
                        <xsl:for-each select="ead:c06">
                            <xsl:call-template name="clevel">
                                <xsl:with-param name="level">06</xsl:with-param>
                            </xsl:call-template>
                            <xsl:for-each select="ead:c07">
                                <xsl:call-template name="clevel">
                                    <xsl:with-param name="level">07</xsl:with-param>
                                </xsl:call-template>
                                <xsl:for-each select="ead:c08">
                                    <xsl:call-template name="clevel">
                                        <xsl:with-param name="level">08</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:for-each select="ead:c09">
                                        <xsl:call-template name="clevel">
                                            <xsl:with-param name="level">09</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:for-each select="ead:c10">
                                            <xsl:call-template name="clevel">
                                                <xsl:with-param name="level">10</xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:for-each select="ead:c11">
                                                <xsl:call-template name="clevel">
                                                    <xsl:with-param name="level">11</xsl:with-param>
                                                </xsl:call-template>
                                                <xsl:for-each select="ead:c12">
                                                  <xsl:call-template name="clevel">
                                                      <xsl:with-param name="level">12</xsl:with-param>
                                                  </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <!--This is a named template that processes all c0* elements  -->
    <xsl:template name="clevel">
        <!-- 9/8/11 WS for RA: this feature is not used by the RA stylesheets 
            Establishes which level is being processed in order to provided indented displays. 
            Indents handdled by CSS margins-->
        <xsl:param name="level" />
        <xsl:variable name="clevelMargin">
            <xsl:choose>
                <xsl:when test="$level = 01">0in</xsl:when>
                <xsl:when test="$level = 02">.4in</xsl:when>
                <xsl:when test="$level = 03">.8in</xsl:when>
                <xsl:when test="$level = 04">1.2in</xsl:when>
                <xsl:when test="$level = 05">1.6in</xsl:when>
                <xsl:when test="$level = 06">2in</xsl:when>
                <xsl:when test="$level = 07">2.4in</xsl:when>
                <xsl:when test="$level = 08">2.8in</xsl:when>
                <xsl:when test="$level = 09">3.2in</xsl:when>
                <xsl:when test="$level = 10">3.6in</xsl:when>
                <xsl:when test="$level = 11">4in</xsl:when>
                <xsl:when test="$level = 12">4.4in</xsl:when>
                <xsl:when test="../c">0in</xsl:when>
                <xsl:when test="../c01">.4in</xsl:when>
                <xsl:when test="../c02">.8in</xsl:when>
                <xsl:when test="../c03">1.2in</xsl:when>
                <xsl:when test="../c04">1.6in</xsl:when>
                <xsl:when test="../c05">2in</xsl:when>
                <xsl:when test="../c06">2.4in</xsl:when>
                <xsl:when test="../c07">2.8in</xsl:when>
                <xsl:when test="../c08">3.2in</xsl:when>
                <xsl:when test="../c08">3.6in</xsl:when>
                <xsl:when test="../c08">4in</xsl:when>
                <xsl:when test="../c08">4.4in</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="clevelFont">
            <xsl:choose>
                <xsl:when test="$level = '01'">11pt</xsl:when>
                <xsl:when test="$level = '02'">10pt</xsl:when>
                <xsl:when test="$level = '03'">9pt</xsl:when>
                <xsl:when test="$level = '04'">8pt</xsl:when>
                <xsl:when test="$level = '05'">7pt</xsl:when>
                <xsl:when test="$level = '06'">6pt</xsl:when>
                <xsl:when test="$level = '07'">6pt</xsl:when>
                <xsl:when test="$level = '08'">6pt</xsl:when>
                <xsl:when test="$level = '09'">6pt</xsl:when>
                <xsl:when test="$level = '10'">6pt</xsl:when>
                <xsl:when test="$level = '11'">6pt</xsl:when>
                <xsl:when test="$level = '12'">6pt</xsl:when>
                <xsl:when test="../c">11pt</xsl:when>
                <xsl:when test="../c01">10pt</xsl:when>
                <xsl:when test="../c02">9pt</xsl:when>
                <xsl:when test="../c03">8pt</xsl:when>
                <xsl:when test="../c04">7pt</xsl:when>
                <xsl:when test="../c05">6pt</xsl:when>
                <xsl:when test="../c06">6pt</xsl:when>
                <xsl:when test="../c07">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
                <xsl:when test="../c08">6pt</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- 9/8/11 WS for RA: this feature is not used by the RA stylesheets
            Establishes a class for even and odd rows in the table for color coding. 
            Colors are Declared in the CSS. -->
        <xsl:variable name="colorClass">
            <xsl:choose>
                <xsl:when
                    test="ancestor-or-self::*[@level='file' or @level='item'  or @level='otherlevel']">
                    <xsl:choose>
                        <xsl:when test="(position() mod 2 = 0)">#fff</xsl:when>
                        <xsl:otherwise>#fff</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- Processes the all child elements of the c or c0* level -->
        <xsl:for-each select=".">
            <xsl:choose>
                <!--Formats Series and Groups  -->
                <xsl:when test="@level='collection' or @level='subcollection'  or @level='series' or @level='subseries' or 
                     @level='fonds' or @level='subfonds' or @level='recordgrp' or @level='subgrp'">
                    <fo:table-row font-size="{$clevelFont}">
                        <!-- 9/8/11 WS for RA: removed background color for series and subseries -->
                        <fo:table-cell number-columns-spanned="5" padding="4pt">
                            <fo:block margin-left="{$clevelMargin}">
                                <fo:block>
                                    <xsl:call-template name="anchor"/>
                                    <xsl:apply-templates select="ead:did" mode="dsc"/>
                                    <xsl:apply-templates select="ead:scopecontent"/>
                                    <xsl:for-each select="ead:did/ead:physdesc[ead:extent]">
                                        <fo:block>
                                            <fo:block font-weight="bold">Extent</fo:block>
                                            <fo:block space-after="8pt">
                                                <xsl:value-of select="ead:extent[1]"/>
                                                <xsl:if test="ead:extent[position() &gt; 1]">, <xsl:value-of select="ead:extent[position() &gt; 1]"/> </xsl:if>
                                            </fo:block>
                                        </fo:block>
                                    </xsl:for-each>
                                    <xsl:apply-templates select="ead:accruals"/>
                                    <xsl:apply-templates select="ead:appraisal"/>
                                    <xsl:apply-templates select="ead:arrangement"/>
                                    <xsl:apply-templates select="ead:bioghist"/>
                                    <xsl:apply-templates select="ead:accessrestrict[not(child::ead:legalstatus)]"/>
                                    <xsl:apply-templates select="ead:userestrict"/>
                                    <xsl:apply-templates select="ead:custodhist"/>
                                    <xsl:apply-templates select="ead:altformavail"/>
                                    <xsl:apply-templates select="ead:originalsloc"/>
                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label='Dimensions note']"/>
                                    <xsl:apply-templates select="ead:fileplan"/>
                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label = 'General Physical Description note']"/>
                                    <xsl:apply-templates select="ead:odd"/>
                                    <xsl:apply-templates select="ead:acqinfo"/>
                                    <xsl:apply-templates select="ead:did/ead:langmaterial"/>
                                    <xsl:apply-templates select="ead:accessrestrict[child::ead:legalstatus]"/>
                                    <xsl:apply-templates select="ead:did/ead:materialspec"/>
                                    <xsl:apply-templates select="ead:otherfindaid"/>
                                    <xsl:apply-templates select="ead:phystech"/>
                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label='Physical Facet note']"/>
                                    <xsl:for-each select="ead:did/ead:physdesc">
                                        <xsl:choose>
                                            <xsl:when test="@label='General Physical Description note'"/>
                                            <xsl:when test="@label='Dimensions note'"/>
                                            <xsl:when test="@label='Physical Facet note'"/>
                                            <xsl:when test="child::ead:extent"/>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="."/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:apply-templates select="ead:processinfo"/>
                                    <xsl:apply-templates select="ead:relatedmaterial"/>
                                    <xsl:apply-templates select="ead:separatedmaterial"/>
                                    <xsl:call-template name="dscControlAccess"/>
                                </fo:block>        
                                <xsl:if test="child::*[@level][1]/ead:did/ead:container">
                                    <fo:block font-weight="bold" margin-top="4pt" margin-bottom="4pt">
                                        Inventory 
                                    </fo:block>
                                </xsl:if>                            
                                <xsl:if test="ead:did/ead:container or child::*[name() = 'dao']">
                                            <fo:table table-layout="fixed" space-before="4pt" space-after="4pt" width="6.25in" font-size="11pt" line-height="12pt" margin-left=".25in">
                                                <fo:table-column column-number="1" column-width="3.25in"/>
                                                <fo:table-column column-number="2" column-width="3in"/>
                                                <fo:table-body>
                                                    <!-- 5/28/2013 HA removed Instances header -->
                                                    <!--<xsl:if test="ead:did/ead:container or ead:dao">
                                                        <fo:table-row>
                                                            <fo:table-cell number-columns-spanned="2">
                                                                <fo:block font-weight="bold" text-decoration="underline" space-after="4pt"> Instances </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                    </xsl:if> -->
                                                    <xsl:for-each select="ead:did/ead:container[@id]">
                                                        <xsl:variable name="id" select="@id"/>
                                                        <fo:table-row space-after="2pt">
                                                            <fo:table-cell>
                                                                <fo:block>
                                                                    <xsl:value-of select="@label"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell>
                                                                <fo:block>
                                                                    <xsl:value-of select="concat(@type,' ',.)"/>
                                                                    <xsl:if test="../ead:container[@parent = $id]">
                                                                        <xsl:value-of select="concat(' / ',../ead:container[@parent = $id]/@type,' ',../ead:container[@parent = $id])"/>
                                                                    </xsl:if>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>
                                                    </xsl:for-each>
                                                    <!-- Uncomment for digital object display
                                                    <xsl:if test="ead:dao">
                                                        <xsl:for-each select="ead:dao">
                                                            <fo:table-row>
                                                                <fo:table-cell>
                                                                    <fo:block>
                                                                        Digital Object
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell>
                                                                    <fo:block>
                                                                        Digital Object ID: <xsl:value-of select="@ns2:href"/>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>                                                
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                    -->
                                                </fo:table-body>
                                            </fo:table> 
                                </xsl:if>
                                </fo:block>
                          </fo:table-cell>
                    </fo:table-row>
                </xsl:when>

                <!-- Items/Files-->
                <xsl:when test="@level='file' or @level='item' or @level='otherlevel'">
                    <fo:table-row font-size="{$clevelFont}">
                        <fo:table-cell padding="4pt" number-columns-spanned="5">
                            <fo:block margin-left="{$clevelMargin}">
                            <fo:block><xsl:apply-templates select="ead:did" mode="dsc"/></fo:block>
                            <!-- 9/8/11 WS for RA: Added internal table for instances -->
                                <xsl:if test="ead:did/ead:container or ead:scopecontent or ead:controlaccess
                                    or ead:accruals or ead:appraisal or ead:arrangement or ead:bioghist
                                    or ead:accessrestrict[not(child::ead:legalstatus)] or ead:userestrict
                                    or ead:custodhist or ead:altformavail or ead:originalsloc 
                                    or ead:did/ead:physdesc[@label='Dimensions note'] or ead:fileplan 
                                    or ead:did/ead:physdesc[@label = 'General Physical Description note']
                                    or ead:odd or ead:acqinfo or ead:did/ead:langmaterial or 
                                    ead:accessrestrict[child::ead:legalstatus] or ead:did/ead:materialspec 
                                    or ead:otherfindaid or ead:phystech or ead:did/ead:physdesc[@label='Physical Facet note'] 
                                    or ead:processinfo or ead:relatedmaterial or ead:separatedmaterial">
                                <fo:table table-layout="fixed" width="6.25in" line-height="12pt">
                                    <fo:table-column column-number="1" column-width="3.25in"/>
                                    <fo:table-column column-number="2" column-width="3in"/>
                                    <fo:table-body>
                                        <!-- 5/28/2013 HA removed Instances header -->
                                        <!--<xsl:if test="ead:did/ead:container or ead:dao">
                                            <fo:table-row>
                                                <fo:table-cell number-columns-spanned="2"  margin-left=".4in">
                                                  <fo:block font-weight="bold" text-decoration="underline" margin-top="4pt">Instances</fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:if> -->
                                        <xsl:for-each select="ead:did/ead:container[@id]">
                                            <xsl:sort select="@label"/>
                                            <xsl:variable name="id" select="@id"/>
                                            <fo:table-row margin-top="2pt">
                                                <fo:table-cell margin-left=".4in">
                                                  <fo:block>
                                                  <xsl:value-of select="@label"/>
                                                  </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                  <fo:block>
                                                  <xsl:value-of select="concat(@type,' ',.)"/>
                                                  <xsl:if test="../ead:container[@parent = $id]">
                                                  <xsl:value-of select="concat(' / ',../ead:container[@parent = $id]/@type,' ',../ead:container[@parent = $id])"/>
                                                  </xsl:if>
                                                  </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:for-each>
                                        <!-- Uncomment for digital object display
                                        <xsl:if test="descendant-or-self::ead:dao">
                                            <xsl:for-each select="descendant-or-self::ead:dao">
                                                <fo:table-row>
                                                    <fo:table-cell margin-left=".4in">
                                                        <fo:block>
                                                            Digital Object
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell>
                                                        <fo:block>
                                                            Digital Object ID: <xsl:value-of select="@ns2:href"/>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>                                                
                                            </xsl:for-each>
                                        </xsl:if>
                                        -->
                                        <!-- Adds row for scope and contents notes and dimensions -->
                                        <xsl:if test="ead:scopecontent or ead:controlaccess
                                            or ead:accruals or ead:appraisal or ead:arrangement or ead:bioghist
                                            or ead:accessrestrict[not(child::ead:legalstatus)] or ead:userestrict
                                            or ead:custodhist or ead:altformavail or ead:originalsloc 
                                            or ead:did/ead:physdesc[@label='Dimensions note'] or ead:fileplan 
                                            or ead:did/ead:physdesc[@label = 'General Physical Description note']
                                            or ead:odd or ead:acqinfo or ead:did/ead:langmaterial or 
                                            ead:accessrestrict[child::ead:legalstatus] or ead:did/ead:materialspec 
                                            or ead:otherfindaid or ead:phystech or ead:did/ead:physdesc[@label='Physical Facet note'] 
                                            or ead:processinfo or ead:relatedmaterial or ead:separatedmaterial">
                                            <fo:table-row>
                                                <fo:table-cell number-columns-spanned="2"  margin-left=".4in">
                                                    <fo:block font-weight="bold" text-decoration="underline" margin-top="4pt"><!--Details--></fo:block>
                                                    <xsl:apply-templates select="ead:scopecontent"/>
                                                    <xsl:apply-templates select="ead:accruals"/>
                                                    <xsl:apply-templates select="ead:appraisal"/>
                                                    <xsl:apply-templates select="ead:arrangement"/>
                                                    <xsl:apply-templates select="ead:bioghist"/>
                                                    <xsl:apply-templates select="ead:accessrestrict[not(child::ead:legalstatus)]"/>
                                                    <xsl:apply-templates select="ead:userestrict"/>
                                                    <xsl:apply-templates select="ead:custodhist"/>
                                                    <xsl:apply-templates select="ead:altformavail"/>
                                                    <xsl:apply-templates select="ead:originalsloc"/>
                                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label='Dimensions note']"/>
                                                    <xsl:apply-templates select="ead:fileplan"/>
                                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label = 'General Physical Description note']"/>
                                                    <xsl:apply-templates select="ead:odd"/>
                                                    <xsl:apply-templates select="ead:acqinfo"/>
                                                    <xsl:apply-templates select="ead:did/ead:langmaterial"/>
                                                    <xsl:apply-templates select="ead:accessrestrict[child::ead:legalstatus]"/>
                                                    <xsl:apply-templates select="ead:did/ead:materialspec"/>
                                                    <xsl:apply-templates select="ead:otherfindaid"/>
                                                    <xsl:apply-templates select="ead:phystech"/>
                                                    <xsl:apply-templates select="ead:did/ead:physdesc[@label='Physical Facet note']"/>
                                                    <xsl:for-each select="ead:did/ead:physdesc">
                                                        <xsl:choose>
                                                            <xsl:when test="@label='General Physical Description note'"/>
                                                            <xsl:when test="@label='Dimensions note'"/>
                                                            <xsl:when test="@label='Physical Facet note'"/>
                                                            <xsl:when test="child::ead:extent"/>
                                                            <xsl:otherwise>
                                                                <xsl:apply-templates select="."/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                    <xsl:apply-templates select="ead:processinfo"/>
                                                    <xsl:apply-templates select="ead:relatedmaterial"/>
                                                    <xsl:apply-templates select="ead:separatedmaterial"/>
                                                    <xsl:call-template name="dscControlAccess"/>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:if>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:if>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:when>
                <xsl:otherwise>
                    <fo:table-row>
                        <fo:table-cell padding="4pt">
                            <fo:block  padding-left="{$clevelMargin}">
                            <fo:block padding-before="8pt"><xsl:apply-templates select="ead:did" mode="dsc"/>
                                <xsl:apply-templates select="ead:scopecontent"/>
                                <xsl:apply-templates select="ead:accruals"/>
                                <xsl:apply-templates select="ead:appraisal"/>
                                <xsl:apply-templates select="ead:arrangement"/>
                                <xsl:apply-templates select="ead:bioghist"/>
                                <xsl:apply-templates select="ead:accessrestrict[not(child::ead:legalstatus)]"/>
                                <xsl:apply-templates select="ead:userestrict"/>
                                <xsl:apply-templates select="ead:custodhist"/>
                                <xsl:apply-templates select="ead:altformavail"/>
                                <xsl:apply-templates select="ead:originalsloc"/>
                                <xsl:apply-templates select="ead:did/ead:physdesc[@label='Dimensions note']"/>
                                <xsl:apply-templates select="ead:fileplan"/>
                                <xsl:apply-templates select="ead:did/ead:physdesc[@label = 'General Physical Description note']"/>
                                <xsl:for-each select="ead:did/ead:physdesc">
                                    <xsl:choose>
                                        <xsl:when test="@label='General Physical Description note'"/>
                                        <xsl:when test="@label='Dimensions note'"/>
                                        <xsl:when test="@label='Physical Facet note'"/>
                                        <xsl:when test="child::ead:extent"/>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <xsl:apply-templates select="ead:odd"/>
                                <xsl:apply-templates select="ead:acqinfo"/>
                                <xsl:apply-templates select="ead:did/ead:langmaterial"/>
                                <xsl:apply-templates select="ead:accessrestrict[child::ead:legalstatus]"/>
                                <xsl:apply-templates select="ead:did/ead:materialspec"/>
                                <xsl:apply-templates select="ead:otherfindaid"/>
                                <xsl:apply-templates select="ead:phystech"/>
                                <xsl:apply-templates select="ead:did/ead:physdesc[@label='Physical Facet note']"/>
                                <xsl:apply-templates select="ead:processinfo"/>
                                <xsl:apply-templates select="ead:relatedmaterial"/>
                                <xsl:apply-templates select="ead:separatedmaterial"/>
                                <xsl:call-template name="dscControlAccess"/>                         
                            </fo:block>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- 8/17/11 WS for RA: added a test to include Series/Subseries and unitid, customized display -->
    <xsl:template match="ead:did" mode="dsc">
        <xsl:choose>
            <xsl:when  test="../@level='series' or ../@level='subseries'  or ../@level='collection' or ../@level='subcollection' or  ../@level='fonds' or ../@level='subfonds' or  ../@level='recordgrp' or ../@level='subgrp'">
                <fo:block font-size="14pt" margin-top="12pt" space-after="8pt" font-weight="bold" color="#111" id="{generate-id(.)}">
                    <fo:marker marker-class-name="title">
                        <xsl:if test="../@level='subcollection' or ../@level='subgrp' or ../@level='subseries' or ../@level='subfonds'">                                
                            <xsl:if test="ancestor::*[@level='series'] or ancestor::*[1][@level='collection'] or ancestor::*[1][@level='fonds'] or ancestor::*[1][@level='recordgrp']">
                                <xsl:choose>
                                    <xsl:when test="ancestor::*[@level='series']">Series <xsl:value-of select="ancestor::*[@level='series']/ead:did/ead:unitid"/>: 
                                        <xsl:value-of select="ancestor::*[@level='series']/ead:did/ead:unittitle"/>; </xsl:when>
                                    <xsl:when test="ancestor::*[1][@level='collection']">Collection <xsl:value-of select="ancestor::*[@level='collection']/ead:did/ead:unitid"/>: 
                                        <xsl:value-of select="ancestor::*[@level='collection']/ead:did/ead:unittitle"/>; </xsl:when>
                                    <xsl:when test="ancestor::*[1][@level='fonds']">Fonds <xsl:value-of select="ancestor::*[@level='fonds']/ead:did/ead:unitid"/>:
                                        <xsl:value-of select="ancestor::*[@level='fonds']/ead:did/ead:unittitle"/>;                  
                                    </xsl:when>
                                    <xsl:when test="ancestor::*[1][@level='recordgrp']">Record Group <xsl:value-of select="ancestor::*[@level='recordgrp']/ead:did/ead:unitid"/>: 
                                        <xsl:value-of select="ancestor::*[@level='recordgrp']/ead:did/ead:unittitle"/>; </xsl:when>
                                </xsl:choose>
                            </xsl:if> 
                        </xsl:if>
                        <xsl:if test="ead:unitid">
                            <xsl:choose>
                                <xsl:when test="../@level='series'">Series <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subseries'">Subseries <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='collection'">Collection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subcollection'">Subcollection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='fonds'">Fonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subfonds'">Subfonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='recordgrp'">Record Group <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:when test="../@level='subgrp'">Subgroup <xsl:value-of select="ead:unitid"/>: </xsl:when>
                                <xsl:otherwise><xsl:value-of select="ead:unitid"/>: </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(ead:unittitle)"/>
                    </fo:marker>
                    <xsl:if test="ead:unitid">
                        <xsl:choose>
                            <xsl:when test="../@level='series'">Series <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subseries'">Subseries <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subsubseries'">Sub-Subseries <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='collection'">Collection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subcollection'">Subcollection <xsl:value-of select="ead:unitid"/>: </xsl:when>
                           <xsl:when test="../@level='fonds'">Fonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subfonds'">Subfonds <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='recordgrp'">Record Group <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:when test="../@level='subgrp'">Subgroup <xsl:value-of select="ead:unitid"/>: </xsl:when>
                            <xsl:otherwise><xsl:value-of select="ead:unitid"/>: </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates select="ead:unittitle"/> 
                    <xsl:if test="ead:unitdate[not(@type)] or ead:unitdate[@type != 'bulk']">, 
                        <xsl:apply-templates select="ead:unitdate[not(@type)] | ead:unitdate[@type != 'bulk']"/>
                    </xsl:if>
                </fo:block>
            </xsl:when>
            <!--Otherwise render the text in its normal font.-->
            <xsl:otherwise>
                <fo:block><xsl:call-template name="component-did-core"/></fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="component-did-core">
        <!--Inserts unitid and a space if it exists in the markup.-->
        <xsl:if test="ead:unitid"><fo:inline font-style="italic"><xsl:value-of select="normalize-space(ead:unitid)"/></fo:inline>
            <xsl:if test="ead:unittitle | ead:origination">:</xsl:if>
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <!--This choose statement selects between cases where unitdate is a child of unittitle and where it is a separate child of did.-->
        <xsl:choose>
            <!--This code processes the elements when unitdate is a child of unittitle.-->
            <xsl:when test="ead:unittitle/ead:unitdate">
                <fo:block font-weight="bold">
                <xsl:apply-templates select="ead:unittitle"/>
                </fo:block>
            </xsl:when>
            <!--This code process the elements when unitdate is not a child of untititle-->
            <xsl:otherwise>
                <fo:block font-weight="bold">
                <xsl:apply-templates select="ead:unittitle"/>
                <xsl:if test="ead:unitdate and ead:unittitle and string-length(ead:unittitle) &gt; 1">, </xsl:if>
                <xsl:for-each select="ead:unitdate[not(self::ead:unitdate[@type='bulk'])]">
                    <xsl:apply-templates/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ead:physdesc/ead:extent">
            <xsl:text>&#160;</xsl:text>
            <!-- 9/16/11 WS for RA: added parentheses -->
            (<xsl:for-each select="ead:physdesc">
                <xsl:value-of select="ead:extent[1]"/>
                <xsl:if test="ead:extent[position() &gt; 1]">, <xsl:value-of select="ead:extent[position() &gt; 1]"/> </xsl:if>                
            </xsl:for-each>)
        </xsl:if>
    </xsl:template>
    <!-- 11/1/11 WS for RA: Added special template for inventory list -->
    <xsl:template name="dscControlAccess">
        <xsl:choose>
            <xsl:when test="ead:controlaccess
                or ead:did/ead:origination/ead:corpname or ead:did/ead:origination/ead:famname or ead:did/ead:origination/ead:persname">
                <fo:block space-before="8pt" font-weight="bold" color="#111">Controlled Access Headings</fo:block>
                <fo:block margin-left="8pt">
                    <xsl:if test="ead:controlaccess/ead:corpname or ead:controlaccess/ead:famname 
                        or ead:controlaccess/ead:famname or ead:controlaccess/ead:persname
                        or ead:did/ead:origination/ead:corpname or ead:did/ead:origination/ead:famname or ead:did/ead:origination/ead:persname">
                        <fo:block font-variant="small-caps" 
                            font-weight="bold"  color="#111">Name(s) </fo:block>
                        <fo:list-block margin-bottom="8pt">
                            <xsl:for-each select="ead:controlaccess/ead:corpname | ead:controlaccess/ead:famname | ead:controlaccess/ead:persname | 
                                ead:did/ead:origination/ead:corpname | ead:did/ead:origination/ead:famname 
                                | ead:did/ead:origination/ead:persname">
                                <fo:list-item>
                                    <fo:list-item-label>
                                        <fo:block> </fo:block>
                                    </fo:list-item-label>
                                    <fo:list-item-body>
                                        <fo:block>
                                            <xsl:apply-templates/>
                                            <!--<xsl:if test="@role"> (<xsl:value-of select="@role"/>)</xsl:if>-->
                                        </fo:block>
                                    </fo:list-item-body>
                                </fo:list-item>
                            </xsl:for-each>
                        </fo:list-block>
                    </xsl:if>
                    <xsl:if test="ead:controlaccess/ead:genreform">
                        <fo:block space-before="8pt" font-variant="small-caps" 
                            font-weight="bold"  color="#111">Genre/Form</fo:block>
                        <fo:list-block margin-bottom="8pt">
                            <xsl:for-each select="ead:controlaccess/ead:genreform">
                                <fo:list-item>
                                    <fo:list-item-label>
                                        <fo:block> </fo:block>
                                    </fo:list-item-label>
                                    <fo:list-item-body>
                                        <fo:block>
                                            <xsl:apply-templates/>
                                        </fo:block>
                                    </fo:list-item-body>
                                </fo:list-item>
                            </xsl:for-each>
                        </fo:list-block>
                    </xsl:if>
                    <xsl:if test="ead:controlaccess/ead:subject or ead:controlaccess/ead:function 
                        or ead:controlaccess/ead:occupation or ead:controlaccess/ead:geogname or ead:controlaccess/ead:title 
                        or ead:controlaccess/ead:name">
                        <fo:block space-before="8pt" font-variant="small-caps" 
                            font-weight="bold"  color="#111"> Subject(s)</fo:block>
                        <fo:list-block margin-bottom="8pt">
                            <xsl:for-each
                                select="ead:controlaccess/ead:subject | ead:controlaccess/ead:function | 
                                ead:controlaccess/ead:occupation | ead:controlaccess/ead:geogname | 
                                ead:controlaccess/ead:title | ead:controlaccess/ead:name">
                                <fo:list-item>
                                    <fo:list-item-label>
                                        <fo:block> </fo:block>
                                    </fo:list-item-label>
                                    <fo:list-item-body>
                                        <fo:block>
                                            <xsl:apply-templates/>
                                        </fo:block>
                                    </fo:list-item-body>
                                </fo:list-item>
                            </xsl:for-each>
                        </fo:list-block>
                    </xsl:if>
                </fo:block>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
