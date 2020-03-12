﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:pd="http://www.munique.net/OpenMU/PacketDefinitions"
>
  <xsl:param name="resultFileName" />
  <xsl:param name="subNamespace" />
  <xsl:output method="text" indent="yes" />
  <xsl:include href="Common.xslt" />

  <xsl:template match="pd:PacketDefinitions">
    <xsl:text>// &lt;copyright file="ConnectionExtensions.cs" company="MUnique"&gt;
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// &lt;/copyright&gt;

//------------------------------------------------------------------------------
// &lt;auto-generated&gt;
//     This source code was auto-generated by an XSL transformation.
//     Do not change this file. Instead, change the XML data which contains
//     the packet definitions and re-run the transformation (rebuild this project).
// &lt;/auto-generated&gt;
//------------------------------------------------------------------------------

// ReSharper disable RedundantVerbatimPrefix
// ReSharper disable AssignmentIsFullyDiscarded
namespace MUnique.OpenMU.Network.Packets</xsl:text>
    <xsl:if test="$subNamespace">
      <xsl:text>.</xsl:text>
      <xsl:value-of select="$subNamespace"/>
    </xsl:if>
    <xsl:text>
{
    using System;
    using System.Threading;
    using MUnique.OpenMU.Network;

    /// &lt;summary&gt;
    /// Extension methods to start writing messages of this namespace on a &lt;see cref="IConnection"/&gt;.
    /// &lt;/summary&gt;
    public static class ConnectionExtensions
    {</xsl:text>
    <xsl:apply-templates select="pd:Packets/pd:Packet" mode="ext" />
    <xsl:apply-templates select="pd:Packets/pd:Packet" mode="ext2" />
    <xsl:text>    }</xsl:text>
    <xsl:apply-templates select="pd:Packets/pd:Packet" mode="writer" />

    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="pd:Packet[pd:Length]" mode="writer">
    <xsl:variable name="template">
      <xsl:text disable-output-escaping="yes" xml:space="preserve">
    /// &lt;summary>
    /// A helper struct to write a &lt;see cref="%NAME%"/> safely to a &lt;see cref="IConnection.Output" /&gt;.
    /// &lt;/summary>
    public readonly ref struct %NAME%ThreadSafeWriter
    {
        private readonly IConnection connection;

        /// &lt;summary&gt;
        /// Initializes a new instance of the &lt;see cref="%NAME%ThreadSafeWriter" /&gt; struct.
        /// &lt;/summary&gt;
        /// &lt;param name="connection"&gt;The connection.&lt;/param&gt;
        public %NAME%ThreadSafeWriter(IConnection connection)
        {
            this.connection = connection;
            Monitor.Enter(this.connection);
            try
            {
                // Initialize header and default values
                var span = this.Span;
                span.Clear();
                _ = new %NAME%(span);
            }
            catch (InvalidOperationException)
            {
                Monitor.Exit(this.connection);
                throw;
            }
        }

        /// &lt;summary&gt;Gets the span to write at.&lt;/summary&gt;
        private Span&lt;byte&gt; Span => this.connection.Output.GetSpan(%NAME%.Length).Slice(0, %NAME%.Length);

        /// &lt;summary&gt;Gets the packet to write at.&lt;/summary&gt;
        public %NAME% Packet => this.Span;

        /// &lt;summary&gt;
        /// Commits the data of the &lt;see cref="%NAME%" /&gt;.
        /// &lt;/summary&gt;
        public void Commit()
        {
            this.connection.Output.Advance(%NAME%.Length);
            this.connection.Output.FlushAsync().ConfigureAwait(false);
        }

        /// &lt;summary&gt;
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// &lt;/summary&gt;
        public void Dispose()
        {
            Monitor.Exit(this.connection);
        }
    }
      </xsl:text>
    </xsl:variable>
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$template" />
      <xsl:with-param name="replace">%NAME%</xsl:with-param>
      <xsl:with-param name="by">
        <xsl:apply-templates select="pd:Name" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="pd:Packet[pd:Length]" mode="ext">
    <xsl:value-of select="$newline" />
    <xsl:text>
        /// &lt;summary&gt;
        /// Starts a safe write of a &lt;see cref="</xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>" /&gt; to this connection.
        /// &lt;/summary&gt;
        /// &lt;param name="connection"&gt;The connection.&lt;/param&gt;</xsl:text>
    <xsl:call-template name="WriteRemarks" />
    <xsl:text>        public static </xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>ThreadSafeWriter StartWrite</xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>(this IConnection connection)</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>        {
          return new </xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>ThreadSafeWriter(connection);</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>        }</xsl:text>
  </xsl:template>


  <xsl:template match="pd:Packet[pd:Length]" mode="ext2">
    <xsl:value-of select="$newline" />
    <xsl:text>
        /// &lt;summary&gt;
        /// Sends a &lt;see cref="</xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>" /&gt; to this connection.
        /// &lt;/summary&gt;</xsl:text>
        /// &lt;param name="connection"&gt;The connection.&lt;/param&gt;
    <xsl:apply-templates select="pd:Fields/pd:Field" mode="paramdoc">
      <xsl:sort select="pd:DefaultValue"/>
    </xsl:apply-templates>
    <xsl:call-template name="WriteRemarks" />
    <xsl:text>        public static </xsl:text>
    <xsl:text>void Send</xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>(this IConnection connection</xsl:text>
    <xsl:apply-templates select="pd:Fields/pd:Field" mode="params">
      <xsl:sort select="pd:DefaultValue"/>
    </xsl:apply-templates>
    <xsl:text>)</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>        {
            using var writer = connection.StartWrite</xsl:text>
    <xsl:apply-templates select="pd:Name" />
    <xsl:text>();</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:if test="pd:Fields/pd:Field">
      <xsl:text>            var packet = writer.Packet;</xsl:text>
      <xsl:value-of select="$newline"/>
      <xsl:apply-templates select="pd:Fields/pd:Field" mode="assignment" />
    </xsl:if>
    <xsl:text>            writer.Commit();</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:text>        }</xsl:text>
  </xsl:template>

  <xsl:template match="pd:Field" mode="paramdoc">
    <xsl:value-of select="$newline"/>
    <xsl:text>        /// &lt;param name="</xsl:text>
    <xsl:call-template name="LowerCaseName" />
    <xsl:text>"&gt;</xsl:text>
    <xsl:choose>
      <xsl:when test="pd:Description">
        <xsl:value-of select="pd:Description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>The</xsl:text>
        <xsl:call-template name="splitName">
          <xsl:with-param name="name" select="pd:Name" />
        </xsl:call-template>
        <xsl:text>.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:text>&lt;/param&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="pd:Field" mode="params">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="pd:Type" mode="type"/>
    <xsl:text> @</xsl:text>
    <xsl:call-template name="LowerCaseName" />
    <xsl:if test="pd:DefaultValue">
      <xsl:text> = </xsl:text>
      <xsl:value-of select="pd:DefaultValue"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="pd:Field" mode="assignment">
    <xsl:choose>
      <xsl:when test="pd:Type='Binary'">
        <xsl:text>            @</xsl:text>
        <xsl:call-template name="LowerCaseName" />
        <xsl:text>.CopyTo(packet.</xsl:text>
        <xsl:value-of select="pd:Name"/>
        <xsl:text>);</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>            packet.</xsl:text>
        <xsl:value-of select="pd:Name"/>
        <xsl:text> = @</xsl:text>
        <xsl:call-template name="LowerCaseName" />
        <xsl:text>;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template name="WriteRemarks">
    <xsl:if test="pd:SentWhen or pd:CausedReaction">
      <xsl:text>
        /// &lt;remarks&gt;
        /// Is sent </xsl:text>
      <xsl:choose>
        <xsl:when test="pd:Direction = 'ClientToServer'">
          <xsl:text>by the client when: </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>by the server when: </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="pd:SentWhen"/>
      <xsl:text>
        /// Causes reaction </xsl:text>
      <xsl:choose>
        <xsl:when test="pd:Direction = 'ClientToServer'">
          <xsl:text>on server side: </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>on client side: </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="pd:CausedReaction"/>
      <xsl:text>
        /// &lt;/remarks&gt;</xsl:text>
      <xsl:value-of select="$newline" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="params"></xsl:template>
  <xsl:template match="text()" mode="paramdoc"></xsl:template>
  <xsl:template match="text()" mode="assignment"></xsl:template>
  <xsl:template match="text()" mode="ext"></xsl:template>
  <xsl:template match="text()" mode="ext2"></xsl:template>
  <xsl:template match="text()" mode="writer"></xsl:template>
  <xsl:template match="text()"></xsl:template>

</xsl:stylesheet>
