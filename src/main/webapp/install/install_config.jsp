<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Properties"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.lang.BooleanUtils"%>
<%@page import="org.apache.commons.lang.exception.ExceptionUtils"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.io.OutputFormat"%>
<%@page import="org.dom4j.io.XMLWriter"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="net.shopxx.util.JsonUtils"%>
<%@include file="common.jsp"%>
<%
	Boolean agreeAgreement = (Boolean) session.getAttribute("agreeAgreement");
	if (BooleanUtils.isNotTrue(agreeAgreement)) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	DatabaseType databaseType = DatabaseType.valueOf((String) session.getAttribute("databaseType"));
	String databaseHost = (String) session.getAttribute("databaseHost");
	String databasePort = (String) session.getAttribute("databasePort");
	String databaseUsername = (String) session.getAttribute("databaseUsername");
	String databasePassword = (String) session.getAttribute("databasePassword");
	String databaseName = (String) session.getAttribute("databaseName");
	String locale = (String) session.getAttribute("locale");
	
	boolean failed = false;
	String message = "";
	String stackTrace = "";
	
	if (databaseType == null) {
		failed = true;
		message = "数据库类型不允许为空!";
	} else if (StringUtils.isEmpty(databaseHost)) {
		failed = true;
		message = "数据库主机不允许为空!";
	} else if (StringUtils.isEmpty(databasePort)) {
		failed = true;
		message = "数据库端口不允许为空!";
	} else if (StringUtils.isEmpty(databaseUsername)) {
		failed = true;
		message = "数据库用户名不允许为空!";
	} else if (StringUtils.isEmpty(databaseName)) {
		failed = true;
		message = "数据库名称不允许为空!";
	} else if (StringUtils.isEmpty(locale)) {
		failed = true;
		message = "语言不允许为空!";
	}
	
	String jdbcDriver = resolveJdbcDriver(databaseType);
	String jdbcUrl = resolveJdbcUrl(databaseType, databaseHost, databasePort, databaseName);
	String hibernateDialect = null;
	
	if (!failed) {
		Connection connection = null;
		try {
			connection = DriverManager.getConnection(jdbcUrl, databaseUsername, databasePassword);
			DatabaseMetaData databaseMetaData = connection.getMetaData();
			int databaseMajorVersion = databaseMetaData.getDatabaseMajorVersion();
			int databaseMinorVersion = databaseMetaData.getDatabaseMinorVersion();
			hibernateDialect = resolveHibernateDialect(databaseType, databaseName, databaseMajorVersion, databaseMinorVersion);
		} catch (SQLException e) {
			failed = true;
			message = "JDBC执行错误!";
			stackTrace = ExceptionUtils.getStackTrace(e);
		} finally {
			try {
				if (connection != null) {
					connection.close();
					connection = null;
				}
			} catch (SQLException e) {
			}
		}
	}
	
	if (!failed) {
		OutputStream outputStream = null;
		try {
			outputStream = new FileOutputStream(shopxxPropertiesFile);
			shopxxProperties.setProperty("jdbc.driver", jdbcDriver);
			shopxxProperties.setProperty("jdbc.url", jdbcUrl);
			shopxxProperties.setProperty("jdbc.username", databaseUsername);
			shopxxProperties.setProperty("jdbc.password", databasePassword);
			shopxxProperties.setProperty("hibernate.dialect", hibernateDialect);
			shopxxProperties.store(outputStream, "SHOP++ PROPERTIES");
		} catch (IOException e) {
			failed = true;
			message = "SHOPXX.PROPERTIES文件写入失败!";
			stackTrace = ExceptionUtils.getStackTrace(e);
		} finally {
			IOUtils.closeQuietly(outputStream);
		}
	}
	
	if (!failed) {
		Document document = new SAXReader().read(shopxxXmlFile);
		Element siteUrlElement = (Element) document.selectSingleNode("/shopxx/setting[@name='siteUrl']");
		Element logoElement = (Element) document.selectSingleNode("/shopxx/setting[@name='logo']");
		Element defaultLargeProductImageElement = (Element) document.selectSingleNode("/shopxx/setting[@name='defaultLargeProductImage']");
		Element defaultMediumProductImageElement = (Element) document.selectSingleNode("/shopxx/setting[@name='defaultMediumProductImage']");
		Element defaultThumbnailProductImageElement = (Element) document.selectSingleNode("/shopxx/setting[@name='defaultThumbnailProductImage']");
		Element defaultStoreLogoElement = (Element) document.selectSingleNode("/shopxx/setting[@name='defaultStoreLogo']");
		Element watermarkImageElement = (Element) document.selectSingleNode("/shopxx/setting[@name='watermarkImage']");
		Element localeElement = (Element) document.selectSingleNode("/shopxx/setting[@name='locale']");
		siteUrlElement.attribute("value").setValue(siteUrl);
		logoElement.attribute("value").setValue(demoImageUrlPrefix + "/logo.png");
		defaultLargeProductImageElement.attribute("value").setValue(demoImageUrlPrefix + "/default_large_product_image.png");
		defaultMediumProductImageElement.attribute("value").setValue(demoImageUrlPrefix + "/default_medium_product_image.png");
		defaultThumbnailProductImageElement.attribute("value").setValue(demoImageUrlPrefix + "/default_thumbnail_product_image.png");
		defaultStoreLogoElement.attribute("value").setValue(demoImageUrlPrefix + "/default_store_logo.png");
		watermarkImageElement.attribute("value").setValue("/upload/image/watermark.png");
		localeElement.attribute("value").setValue(locale);
		
		XMLWriter xmlWriter = null;
		try {
			OutputFormat outputFormat = OutputFormat.createPrettyPrint();
			outputFormat.setEncoding("UTF-8");
			outputFormat.setIndent(true);
			outputFormat.setIndent("	");
			outputFormat.setNewlines(true);
			xmlWriter = new XMLWriter(new FileOutputStream(shopxxXmlFile), outputFormat);
			xmlWriter.write(document);
			xmlWriter.flush();
		} catch (Exception e) {
			failed = true;
			message = "SHOPXX.XML文件写入失败!";
			stackTrace = ExceptionUtils.getStackTrace(e);
		} finally {
			try {
				if (xmlWriter != null) {
					xmlWriter.close();
				}
			} catch (IOException e) {
			}
		}
	}
	
	if (!failed) {
		OutputStream outputStream = null;
		try {
			outputStream = new FileOutputStream(installPropertiesFile);
			installProperties.setProperty("disabled", "true");
			installProperties.store(outputStream, "SHOP++ PROPERTIES");
		} catch (IOException e) {
			failed = true;
			message = "INSTALL.PROPERTIES文件写入失败!";
			stackTrace = ExceptionUtils.getStackTrace(e);
		} finally {
			IOUtils.closeQuietly(outputStream);
		}
	}
	
	if (!failed) {
		try {
			FileUtils.copyFile(webXmlSampleFile, webXmlFile);
		} catch (IOException e) {
			failed = true;
			message = "WEB.XML文件写入失败!";
			stackTrace = ExceptionUtils.getStackTrace(e);
		}
	}
	
	Map<String, Object> data = new HashMap<String, Object>();
	data.put("failed", failed);
	data.put("message", message);
	data.put("stackTrace", stackTrace.replaceAll("\\r?\\n", "</br>"));
	JsonUtils.writeValue(response.getWriter(), data);
%>