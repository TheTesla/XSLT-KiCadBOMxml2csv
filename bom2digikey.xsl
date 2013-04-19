<!--XSL style sheet to convert EESCHEMA XML Partlist Format to CSV BOM Format
    Copyright (C) 2013, Stefan Helmert.
    GPL v2.

	Functionality:
		Generation of Digi-Key ordering system compatible BOM 
		
    How to use this is explained in eeschema.pdf chapter 14.  You enter a command line into the
    netlist exporter using a new (custom) tab in the netlist export dialog.  The command is
        on Windows:
            xsltproc -o "%O.csv" "C:\Program Files (x86)\KiCad\bin\plugins\bom2csv.xsl" "%I"
        on Linux:
            xsltproc -o %O.csv /usr/local/lib/kicad/plugins/bom2csv.xsl %I
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text"/>

	<!-- all parts, parts with same Digi-Key Part Number should be grouped -->
	<xsl:key name="Partentr" match="field" use="."/>

	<!-- to know the corresponding Customer References of each Digi-Key Part Number entry  -->
	<xsl:key name="Compentr" match="comp" use="fields/field"/>
	
	<!-- main part -->
	<xsl:template match="/export">
		<!-- table head -->
		<xsl:text>Digi-Key Part Number,Customer Reference,Quantity 1</xsl:text>
			<!-- each Digi-Key Part Numbber only one time in table -->
			<xsl:for-each select="components/comp/fields/field[generate-id(.) = generate-id(key('Partentr',.)[1])]">
				<!-- only fields, this implies only components, with Digi-Key Part Number -->
				<xsl:if test="@name='Digi-Key Part Number'">
					<!-- line end -->
					<xsl:text>;&#xA;</xsl:text>
					<!-- Digi-Key Part Number -->
					<xsl:value-of select="."/>
					<xsl:text>,</xsl:text>
					<!-- corresponding Customer References -->
					<xsl:for-each select="key('Compentr', .)">
						<!-- no leading cell separation -->
						<xsl:if test="position()!=1">
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="@ref"/>
					</xsl:for-each>					
					<xsl:text>,</xsl:text>
					<!-- how often the same part is used -->
					<xsl:variable name="tmp" select="."/> <!-- work around, because [field=.] not allowed-->
					<xsl:value-of select="count(/export/components/comp/fields[field=$tmp])"/>
				</xsl:if>
			</xsl:for-each>
	</xsl:template>
 </xsl:stylesheet>
