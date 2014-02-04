<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- traduction des collections -->
   <xsl:template match="collection">
      <liste>
         <xsl:apply-templates select="*" />
      </liste>
   </xsl:template>

   <xsl:template match="recipe">
      <xsl:element name="recette">
         <xsl:apply-templates select="*" />
      </xsl:element>
   </xsl:template>

   <xsl:template match="title|description|comment">
      <xsl:element name="{local-name()}">
         <xsl:value-of select="text()" />
      </xsl:element>
   </xsl:template>

   <xsl:template match="ingredient">
      <xsl:element name="ingredient">
         <xsl:element name="nom">
            <xsl:value-of select="@name" />
         </xsl:element>

         <xsl:element name="Quantite">
            <xsl:value-of select="@amount" />
         </xsl:element>

         <xsl:element name="unite">
            <xsl:value-of select="@unit" />
         </xsl:element>
      </xsl:element>
   </xsl:template>

<!-- traduction des etapes -->
   <xsl:template match="step">
      <xsl:element name="etape">
         <xsl:attribute name="num">
            <xsl:number level="any" count="step" />
         </xsl:attribute>

         <xsl:value-of select="text()" />
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>

