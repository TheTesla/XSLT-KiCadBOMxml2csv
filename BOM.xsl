<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  
  <xsl:key name="headentr" match="field" use="@name"/>
  

  

  <xsl:template match="/export">
	  <xsl:text>Reference, Value, Footprint, Datasheet</xsl:text>
	  <xsl:for-each select="/export/components/comp/fields/field[generate-id(.) = generate-id(key('headentr',@name)[1])]">
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@name"/>
	  </xsl:for-each>
	  <xsl:text>; &#xA;</xsl:text>
      <xsl:apply-templates select="components"/>

  </xsl:template>
 
 <xsl:template match="components">
	<xsl:apply-templates select="comp"/>
  </xsl:template>

  <xsl:template match="fields">
		
		<xsl:variable name="fieldvar" select="field"/>
		
		<xsl:for-each select="/export/components/comp/fields/field[generate-id(.) = generate-id(key('headentr',@name)[1])]">
		  <xsl:variable name="allnames" select="@name"/>
		  <xsl:text>, </xsl:text>
		  <xsl:for-each select="$fieldvar">
			 <xsl:if test="@name=$allnames">
			   <xsl:value-of select="."/>
			 </xsl:if>
		  </xsl:for-each>
		  
		  
		</xsl:for-each>

		
		
	
  </xsl:template>

    
  <xsl:template match="comp">
    <xsl:value-of select="@ref"/><xsl:text>, </xsl:text>
    <xsl:value-of select="value"/><xsl:text>, </xsl:text>
    <xsl:value-of select="footprint"/><xsl:text>, </xsl:text>
    <xsl:value-of select="datasheet"/>
	<xsl:apply-templates select="fields"/>

	
    <xsl:text>; &#xA;</xsl:text>
  </xsl:template> 

  
 
 <xsl:template match="components" mode="head">
	<xsl:apply-templates select="comp" mode="head"/>
  </xsl:template>

  <xsl:template match="fields" mode="head">
	<xsl:for-each select="field">
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@name"/>
	</xsl:for-each>
  </xsl:template>
  
  <xsl:template match="comp" mode="head">
    <xsl:text>Reference, Value, Footprint, Datasheet</xsl:text>
	<xsl:apply-templates select="fields" mode="head"/>
    <xsl:text>; &#xA;</xsl:text>
  </xsl:template> 
 

  
  
 </xsl:transform>
