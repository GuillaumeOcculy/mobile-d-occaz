<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:html="http://www.w3.org/TR/REC-html40"
                xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Sitemap - Iris Conseil</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<style type="text/css">
					body {
						background-color: #1F1F1F;
						font-size: 11px;
						font-family: Verdana, Helvetica, Arial, sans-serif;
						color: #fff;
					}
					A { color:#fff; text-decoration: none;} 
					A:visited { text-decoration: none}
					A:hover { color:#ED5132; text-decoration: underline; }
					A:link { text-decoration: none}
					A:active { text-decoration: none}
					h1 {
						margin: 0;
						padding: 10px 0;
						border-bottom: 4px solid #999;
						color: #fff;
					}
					#intro, #content {
						clear: left;
						background-color: #575757;
						border-width: 1px;
						border-style: solid;
						border-color: #999;
						padding: 10px;
						margin-bottom: 20px;
					}
					
					.table { 
					    width: 100%;
					}
					.table tr > th {
						background-color: #e1e1e1;
						border-top: 1px solid #fff;
						border-bottom: 1px solid #fff;
						height: 26px;
						color: #f00;
						padding: 0 0 0 10px;
						font-size: 12px;
					}
					.table td {
						vertical-align: middle;
						padding: 3px;
						border-bottom: 1px solid #999;
						font-size: 11px;
					}
					.table a { display: block }
					
					#footer {
						clear: left;
						text-align: center;
						padding: 20px 30px 40px 30px;
						font-size: 10px;
					}
				</style>
			</head>
			<body>
				<h1>XML Sitemap</h1>
				<div id="intro">
					<p>
						This is a XML Sitemap which is supposed to be processed by search engines like <a href="http://www.google.com">Google</a>, <a href="http://search.msn.com">MSN Search</a> and <a href="http://www.yahoo.com">YAHOO</a>.<br />
						You can find more information about XML sitemaps on <a href="http://sitemaps.org">sitemaps.org</a> and Google's <a href="http://code.google.com/sm_thirdparty.html">list of sitemap programs</a>.
					</p>
				</div>
				<h2>
				Nombre d'urls : 
				<xsl:value-of select="count(sitemap:urlset/sitemap:url)"/>
				</h2>
				<div id="content">
					<table class="table" cellpadding="0" cellspacing="0">
						<tr style="border-bottom:1px black solid;">
							<th>URL</th>
							<th>Priority</th>
							<th>Change Frequency</th>
							<th>LastChange</th>
						</tr>
						<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
						<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
						<xsl:for-each select="sitemap:urlset/sitemap:url">
							<tr>
								<xsl:if test="position() mod 2 != 1">
									<xsl:attribute  name="class">high</xsl:attribute>
								</xsl:if>
								<td>
									<xsl:variable name="itemURL">
										<xsl:value-of select="sitemap:loc"/>
									</xsl:variable>
									<a href="{$itemURL}" target="_new">
										<xsl:value-of select="sitemap:loc"/>
									</a>
								</td>
								<td>
									<xsl:value-of select="concat(sitemap:priority*100,'%')"/>
								</td>
								<td>
									<xsl:value-of select="concat(translate(substring(sitemap:changefreq, 1, 1),concat($lower, $upper),concat($upper, $lower)),substring(sitemap:changefreq, 2))"/>
								</td>
								<td>
									<xsl:value-of select="concat(substring(sitemap:lastmod,0,11),concat(' ', substring(sitemap:lastmod,12,5)))"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</div>
				<div id="footer">
					Copyright 2012
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
