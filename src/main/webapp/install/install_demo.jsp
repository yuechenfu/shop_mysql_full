<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.lang.BooleanUtils"%>
<%@page import="org.apache.commons.lang.exception.ExceptionUtils"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="net.shopxx.util.FreeMarkerUtils"%>
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
	}
	
	if (!failed) {
		Connection connection = null;
		Statement statement = null;
		String currentSQL = null;
		try {
			String jdbcUrl = resolveJdbcUrl(databaseType, databaseHost, databasePort, databaseName);
			connection = DriverManager.getConnection(jdbcUrl, databaseUsername, databasePassword);
			connection.setAutoCommit(false);
			statement = connection.createStatement();
			
			Map<String, Object> model = new HashMap<String, Object>();
			model.put("siteUrl", siteUrl);
			model.put("demoImageUrlPrefix", demoImageUrlPrefix);
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			calendar.set(Calendar.HOUR_OF_DAY, calendar.getActualMinimum(Calendar.HOUR_OF_DAY));
			calendar.set(Calendar.MINUTE, calendar.getActualMinimum(Calendar.MINUTE));
			calendar.set(Calendar.SECOND, calendar.getActualMinimum(Calendar.SECOND));
			
			List<String> sqlLines = null;
			InputStream inputStream = null;
			try {
				inputStream = new BufferedInputStream(application.getResourceAsStream(resolveDemoSqlPath(databaseType)));
				sqlLines = IOUtils.readLines(inputStream, "UTF-8");
			} catch (IOException e) {
				throw new RuntimeException(e.getMessage(), e);
			} finally {
				IOUtils.closeQuietly(inputStream);
			}
			for (String sqlLine : sqlLines) {
				if (StringUtils.isNotBlank(sqlLine) && !sqlLine.startsWith("--")) {
					calendar.add(Calendar.SECOND, 1);
					model.put("date", calendar.getTime());
					currentSQL = FreeMarkerUtils.process(sqlLine, model);
					statement.executeUpdate(currentSQL);
				}
			}
			connection.commit();
			currentSQL = null;
		} catch (SQLException e) {
			failed = true;
			message = "JDBC执行错误!";
			stackTrace = ExceptionUtils.getStackTrace(e);
			if (currentSQL != null) {
				stackTrace = "SQL: " + currentSQL + "<br />" + stackTrace;
			}
		} catch (IOException e) {
			failed = true;
			message = "DEMO.SQL文件读取失败!";
			stackTrace = ExceptionUtils.getStackTrace(e);
		} finally {
			try {
				if (statement != null) {
					statement.close();
					statement = null;
				}
				if (connection != null) {
					connection.close();
					connection = null;
				}
			} catch (SQLException e) {
			}
		}
	}
	
	Map<String, Object> data = new HashMap<String, Object>();
	data.put("failed", failed);
	data.put("message", message);
	data.put("stackTrace", stackTrace.replaceAll("\\r?\\n", "</br>"));
	JsonUtils.writeValue(response.getWriter(), data);
%>