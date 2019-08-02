<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Properties"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.springframework.core.io.Resource"%>
<%@page import="org.springframework.core.io.FileSystemResource"%>
<%@page import="org.springframework.web.context.support.ServletContextResource"%>
<%@page import="org.springframework.util.ResourceUtils"%>
<%@page import="org.springframework.core.io.support.PropertiesLoaderUtils"%>
<%@page import="net.shopxx.CommonAttributes"%>
<%!
	// 数据库类型
	public enum DatabaseType {
		
		/**
		 * MySQL
		 */
		MYSQL,
		
		/**
		 * SQLSERVER
		 */
		SQLSERVER,
		
		/**
		 * Oracle
		 */
		ORACLE
	}
	
	// 解析JDBC驱动
	public String resolveJdbcDriver(DatabaseType databaseType) {
		switch (databaseType) {
			case MYSQL:
				return "com.mysql.jdbc.Driver";
			case SQLSERVER:
				return "com.microsoft.sqlserver.jdbc.SQLServerDriver";
			case ORACLE:
				return "oracle.jdbc.OracleDriver";
		}
		return null;
	}
	
	// 解析JDBC URL
	public String resolveJdbcUrl(DatabaseType databaseType, String databaseHost, String databasePort, String databaseName) {
		switch (databaseType) {
			case MYSQL:
				return String.format("jdbc:mysql://%s:%s/%s?useUnicode=true&characterEncoding=UTF-8", databaseHost, databasePort, databaseName);
			case SQLSERVER:
				return String.format("jdbc:sqlserver://%s:%s;databasename=%s", databaseHost, databasePort, databaseName);
			case ORACLE:
				return String.format("jdbc:oracle:thin:@%s:%s:%s", databaseHost, databasePort, databaseName);
		}
		return null;
	}
	
	// 解析Hibernate方言
	public String resolveHibernateDialect(DatabaseType databaseType, String databaseName, int databaseMajorVersion, int databaseMinorVersion) {
		switch (databaseType) {
			case MYSQL:
				return databaseMajorVersion >= 5 ? "org.hibernate.dialect.MySQL5Dialect" : "org.hibernate.dialect.MySQLDialect";
			case SQLSERVER:
				switch (databaseMajorVersion) {
					case 8:
						return "org.hibernate.dialect.SQLServerDialect";
					case 9:
						return "org.hibernate.dialect.SQLServer2005Dialect";
					case 10:
						return "org.hibernate.dialect.SQLServer2008Dialect";
					case 11:
						return "org.hibernate.dialect.SQLServer2012Dialect";
					default:
						return databaseMajorVersion > 11 ? "org.hibernate.dialect.SQLServer2012Dialect" : "org.hibernate.dialect.SQLServerDialect";
				}
			case ORACLE:
				switch (databaseMajorVersion) {
					case 8:
						return "org.hibernate.dialect.Oracle8iDialect";
					case 9:
						return "org.hibernate.dialect.Oracle9iDialect";
					case 10:
						return "org.hibernate.dialect.Oracle10gDialect";
					case 11:
						return "org.hibernate.dialect.Oracle10gDialect";
					case 12:
						return "org.hibernate.dialect.Oracle12cDialect";
					default:
						return databaseMajorVersion > 12 ? "org.hibernate.dialect.Oracle12cDialect" : "org.hibernate.dialect.Oracle8iDialect";
				}
		}
		return null;
	}
	
	// 解析init.sql路径
	public String resolveInitSqlPath(DatabaseType databaseType) {
		return String.format("/install/data/%s/init.sql", StringUtils.lowerCase(databaseType.toString()));
	}
	
	// 解析demo.sql路径
	public String resolveDemoSqlPath(DatabaseType databaseType) {
		return String.format("/install/data/%s/demo.sql", StringUtils.lowerCase(databaseType.toString()));
	}
%>
<%
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", 0);
	
	String base = request.getContextPath();
	String siteUrl;
	if (request.getServerPort() == 80) {
		siteUrl = request.getScheme() + "://" + request.getServerName() + base;
	} else {
		siteUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + base;
	}
	String demoImageUrlPrefix = "http://image.demo.b2b2c.shopxx.net/6.0";
	Resource webXmlResource = new ServletContextResource(application, "/WEB-INF/web.xml");
	File webXmlFile = webXmlResource.getFile();
	Resource webXmlSampleResource = new ServletContextResource(application, "/install/sample/web.xml");
	File webXmlSampleFile = webXmlSampleResource.getFile();
	File shopxxXmlFile = ResourceUtils.getFile(CommonAttributes.SHOPXX_XML_PATH);
	File shopxxPropertiesFile = ResourceUtils.getFile(CommonAttributes.SHOPXX_PROPERTIES_PATH);
	Properties shopxxProperties = PropertiesLoaderUtils.loadProperties(new FileSystemResource(shopxxPropertiesFile));
	Resource installPropertiesResource = new ServletContextResource(application, "/install/install.properties");
	File installPropertiesFile = installPropertiesResource.getFile();
	Properties installProperties = PropertiesLoaderUtils.loadProperties(installPropertiesResource);
	
	if (StringUtils.equalsIgnoreCase(installProperties.getProperty("disabled"), "true")) {
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>系统提示 - Powered By SHOP++</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="css/install.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<fieldset>
		<legend>系统提示</legend>
		<p>您无此访问权限！若您需要重新安装SHOP++程序，请重新配置/install/install.properties文件！ [<a href="<%=base%>/">进入首页</a>]</p>
		<p>
			<strong>提示: 基于安全考虑请在安装成功后删除install目录</strong>
		</p>
	</fieldset>
</body>
</html>
<%
		return;
	}
%>