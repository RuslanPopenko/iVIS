<%@ page import="com.imcode.entities.Statement,
                 com.imcode.services.StatementService" pageEncoding="UTF-8" %>
<%@ page import="imcode.server.Imcms" %>
<%@ page import="imcode.services.restful.IvisFacade" %>
<%@ page import="imcode.services.restful.IvisServiceFactory" %>
<%@ page import="imcode.services.utils.IvisOAuth2Utils" %>
<%@ page import="org.apache.oro.text.perl.Perl5Util" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="org.springframework.security.oauth2.client.token.grant.code.AuthorizationCodeResourceDetails" %>
<%@ page import="org.springframework.security.oauth2.common.OAuth2AccessToken" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.List" %>
<%@ page import="org.springframework.security.oauth2.client.resource.UserRedirectRequiredException" %>
<%@ page import="org.springframework.security.oauth2.client.OAuth2ClientContext" %>

<%@taglib prefix="imcms" uri="imcms" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%--<%--%>
<%--//    HttpSession pageContext.getSe--%>
<%--String IVIS_TOKEN = "IVIS_TOKEN";--%>
<%--String token = (String) session.getAttribute(IVIS_TOKEN);--%>

<%--if (token == null) {--%>
<%--//        response.sendRedirect("http://localhost:8080/ivis/oauth/authorize?client_id=2e9fa895-e577-4156-844a-2cbb1ebbe06d&redirect_uri=http://localhost:8080/client&response_type=code&scope=read&state=M7bQDn");--%>
<%--response.sendRedirect("http://localhost:8081/tonr2");--%>
<%--return;--%>
<%--}--%>

<%--//    System.out.println("sdf");--%>
<%--%>--%>

<%--<imcms:variables/>--%>
<%

//    // TODO: Add support for imCMS versions > 5
//
//    String documentationUrl = "http://doc.imcms.net/SNAPSHOT";
//
//    Perl5Util re = new Perl5Util();
//
//    if (re.match("/^(.*\\/)(\\d)(\\.\\d).*/", documentationUrl)) {
//        try {
//            int majorVersion = Integer.parseInt(re.group(2));
//            if (majorVersion > 5) {
//                majorVersion = 5;
//            }
//            documentationUrl = re.group(1) + majorVersion + re.group(3);
//        } catch (Exception ignore) {
//        }
//    }
//
//    request.setAttribute("documentationUrl", documentationUrl);

    ApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(pageContext.getServletContext());
    AuthorizationCodeResourceDetails client = context.getBean(AuthorizationCodeResourceDetails.class);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

    <title><c:out value="${document.headline}"/> - Powered by imCMS from imCode Partner AB</title>
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:400,300" rel="stylesheet" type="text/css">
    <%--<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/imcms/css/imcms_demo.css.jsp"/>--%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/general.css"/>
    <script type="text/javascript">
        var isAuthorize = <%=IvisOAuth2Utils.getAccessToken(request) != null%>;
        var wnd;
        function facebookAuth () {
            var authUrl = "<%=IvisOAuth2Utils.getOAuth2AuthirizationUrl(client, Imcms.getServerProperties().getProperty("AuthorizationCodeHandlerUri"))%>";
            var width = 600;
            var height = 300;
            var left = (screen.width / 2) - (width / 2);
            var top = (screen.height / 2) - (height / 2);
            wnd = window.open(authUrl, "newwinow", "left=" + left + ", top=" + top + ", width=" + width + ", height=" + height + ", menubar=0, status=0, resizable=0, scrollbars=0");
        }
        function authComplete(){
            wnd.close();
            location.reload();
        }
    </script>
</head>
<body>
<%
    if (IvisOAuth2Utils.getAccessToken(request) == null) {
%>
<%--window.location.href = "<%=IvisOAuth2Utils.getOAuth2AuthirizationUrl(client, Imcms.getServerProperties().getProperty("AuthorizationCodeHandlerUri"))%>";--%>
<script type="text/javascript">
    facebookAuth();
</script>
<%
    } else {
        OAuth2ClientContext clientContext = IvisOAuth2Utils.getClientContext(session);

        if (client != null) {
            IvisFacade ivis = IvisFacade.instance(new IvisFacade.Configuration.Builder()
                    .endPointUrl(Imcms.getServerProperties().getProperty("ServerAddress"))
                    .responseType("json")
                    .version("v1").build());
            IvisServiceFactory factory = ivis.getServiceFactory(client, clientContext);
            StatementService service = factory.getStatementService();
            Statement statement = null;
            try {
                statement = service.find(Long.valueOf(request.getParameter("id")));
            } catch (UserRedirectRequiredException e) {
                IvisOAuth2Utils.setAccessToken(session, null);
                response.sendRedirect(Imcms.getServerProperties().getProperty("StatementsAddress"));
                return;
            }
            request.setAttribute("statement", statement);
        }
    }
%>
    <div class="container">
        <div class="content">
            <div class="box">
                <h1>Statement</h1>
                <c:if test="${not empty statement}">
                    <table class="table table-striped">
                        <tbody>
                        <tr>
                            <td>Id</td>
                            <td>${statement.id}</td>
                        </tr>
                        <tr>
                            <td>Submit date</td>
                            <td>${statement.submitDate}</td>
                        </tr>
                        <tr>
                            <td>Change date</td>
                            <td>${statement.changedDate}</td>
                        </tr>
                        <tr>
                            <td>Status</td>
                            <td>${statement.status}</td>
                        </tr>
                        <tr>
                            <td>Submitted person</td>
                            <td>${statement.submittedPerson}</td>
                        </tr>
                        <tr>
                            <td>Pupil</td>
                            <td>${statement.pupil}</td>
                        </tr>
                        </tbody>
                    </table>
                    <div class="buttons">
                        <a class="button neutral" href="<%=Imcms.getServerProperties().getProperty("StatementsAddress")%>">Back</a>
                    </div>

                </c:if>
            </div>
        </div>
    </div>
<%--<div class="col-sm-6">--%>
<%--<div class="mb-md">--%>
<%--<button id="addToTable" class="btn btn-primary" onclick="addApplication()">Add <i class="fa fa-plus"></i></button>--%>
<%--</div>--%>
<%--</div>--%>

</body>
</html>